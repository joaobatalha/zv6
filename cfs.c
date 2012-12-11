#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <assert.h>
#include <time.h>

#define stat xv6_stat  // avoid clash with host struct stat
#include "types.h"
#include "fs.h"
#include "stat.h"
#include "param.h"

#define static_assert(a, b) do { switch (0) case 0: case (a): ; } while (0)
#define min(a, b) ((a) < (b) ? (a) : (b))

int nblocks = 1999;
int nlog = LOGSIZE;
int ninodes = 200;
int size = 2048;

int fsfd;
struct superblock sb;
char zeroes[512];

void wsect(uint, void*);
void winode(uint, struct dinode*);
void rinode(uint inum, struct dinode *ip);
void rsect(uint sec, void *buf);
//void iappend(uint inum, void *p, int n);
int icorrupt(uint inum, void *p, int n, int pct);
int flip_bits(int pct, char * c, uint n);
uint ichecksum(struct dinode *din);
void rblock(struct dinode *din, uint bn, char * dst);
int readi(struct dinode *din, char * dst, uint off, uint n);
void copy_dinode_content(struct dinode *src, uint dst);

// convert to intel byte order
ushort
xshort(ushort x)
{
  ushort y;
  uchar *a = (uchar*)&y;
  a[0] = x;
  a[1] = x >> 8;
  return y;
}

uint
xint(uint x)
{
  uint y;
  uchar *a = (uchar*)&y;
  a[0] = x;
  a[1] = x >> 8;
  a[2] = x >> 16;
  a[3] = x >> 24;
  return y;
}

int
main(int argc, char *argv[])
{
  uint inum;
  char  corrupt[512];
  int i,pct;
  int counter = 0;
  for(i = 0; i < sizeof(corrupt); i++){
    corrupt[i] = 0xFF; 
  }
  char *zp = &(corrupt[0]);

  if(argc < 3){
    fprintf(stderr, "Wrong number of arguments \n");
    exit(1);
  }

  inum = atoi(argv[2]);
  pct  = atoi(argv[3]);

  fsfd = open(argv[1], O_RDWR, 0666);
  if(fsfd < 0){
    perror(argv[1]);
    exit(1);
  }
  srand(time(NULL));
  struct dinode din;
  rinode(inum, &din);
  uint size = xint(din.size);
  fprintf(stdout, "Size of file:  %d bits \n", size * 8);
  counter = icorrupt(inum,zp,size, pct);
  fprintf(stdout, "Corrupting 1 in every %d bits\n",pct);
  fprintf(stdout, "Corrupted %d bits \n", counter);
  fprintf(stdout, "Corrupted file with inode %d \n", inum);
  exit(0);
}

void
wsect(uint sec, void *buf)
{
  if(lseek(fsfd, sec * 512L, 0) != sec * 512L){
    perror("lseek");
    exit(1);
  }
  if(write(fsfd, buf, 512) != 512){
    perror("write");
    exit(1);
  }
}

//Inum to block
//You have to add 2 for the boot block and the super block
//After that its just simply indexing into the inode "table"
uint
i2b(uint inum)
{
  return (inum / IPB) + 2;
}

void
winode(uint inum, struct dinode *ip)
{
  char buf[512];
  uint bn;
  struct dinode *dip;

  bn = i2b(inum);
  //read section of the inode table into the buffer
  rsect(bn, buf);
  //find the right dinode
  dip = ((struct dinode*)buf) + (inum % IPB);
  //Set that dinode to the new one
  *dip = *ip;
  wsect(bn, buf);
}

void
rinode(uint inum, struct dinode *ip)
{
  char buf[512];
  uint bn;
  struct dinode *dip;

  bn = i2b(inum);
  rsect(bn, buf);
  dip = ((struct dinode*)buf) + (inum % IPB);
  *ip = *dip;
}

//Abstraction that reads sectors from fs.img
void
rsect(uint sec, void *buf)
{
  if(lseek(fsfd, sec * 512L, 0) != sec * 512L){
    perror("lseek");
    exit(1);
  }
  if(read(fsfd, buf, 512) != 512){
    perror("read");
    exit(1);
  }
}



//void
//iappend(uint inum, void *xp, int n)
//{
//  char *p = (char*)xp;
//  uint fbn, off, n1;
//  struct dinode din;
//  char buf[512];
//  uint indirect[NINDIRECT];
//  uint x;
//
//  rinode(inum, &din);
//
//  off = xint(din.size);
//  while(n > 0){
//    fbn = off / 512;
//    assert(fbn < MAXFILE);
//    if(fbn < NDIRECT){
//      if(xint(din.addrs[fbn]) == 0){
//        din.addrs[fbn] = xint(freeblock++);
//        usedblocks++;
//      }
//      x = xint(din.addrs[fbn]);
//    } else {
//      if(xint(din.addrs[NDIRECT]) == 0){
//        // printf("allocate indirect block\n");
//        din.addrs[NDIRECT] = xint(freeblock++);
//        usedblocks++;
//      }
//      // printf("read indirect block\n");
//      // The address just points to a block
//      rsect(xint(din.addrs[NDIRECT]), (char*)indirect);
//      if(indirect[fbn - NDIRECT] == 0){
//        indirect[fbn - NDIRECT] = xint(freeblock++);
//        usedblocks++;
//        wsect(xint(din.addrs[NDIRECT]), (char*)indirect);
//      }
//      x = xint(indirect[fbn-NDIRECT]);
//    }
//    n1 = min(n, (fbn + 1) * 512 - off);
//    rsect(x, buf);
//    bcopy(p, buf + off - (fbn * 512), n1);
//    wsect(x, buf);
//    n -= n1;
//    off += n1;
//    p += n1;
//  }
//  din.size = xint(off);
//  winode(inum, &din);
//}

int
icorrupt(uint inum, void *xp, int n, int pct)
{
  char *p = (char*)xp;
  uint fbn, off, n1;
  struct dinode din;
  char buf[512];
  uint indirect[NINDIRECT];
  uint x;
  char * c;
  int counter = 0;

  rinode(inum, &din);

  off = 0;
  while(n > 0){
    fbn = off / 512;
    assert(fbn < MAXFILE);
    if(fbn < NDIRECT){
      x = xint(din.addrs[fbn]);
    } else {
      // printf("read indirect block\n");
      // The address just points to a block
      rsect(xint(din.addrs[NDIRECT]), (char*)indirect);
      x = xint(indirect[fbn-NDIRECT]);
    }
    n1 = min(n, (fbn + 1) * 512 - off);
    rsect(x, buf);
//    bcopy(p, buf + off - (fbn * 512), n1);
    c = (char *) &buf;
    counter += flip_bits(pct, c, n1);
    wsect(x, buf);
    n -= n1;
    off += n1;
    p += n1;
  }
  winode(inum, &din);
  return counter;
}


int flip(int p){
    int i = rand() %p;
    if(i == 0){
	return 1;
    }
    else{
	return 0;
    }
}
int
flip_bits(int pct, char * c, uint n){
    uint i,s;
    char bit = 0x01;
    int counter = 0;
    for(i = 0; i < n; i++){
	for(s = 0; s < 8; s++){
	    if(flip(pct)){
		counter++;
		*(c + i) ^= bit << s;
	    }
	}
    }
    return counter;
}

int 
readi(struct dinode *din, char *dst, uint off, uint n){
    uint tot, m, fbn;
    char data[BSIZE];
    char *cdata = (char *)data;

    if(xint(din->type) == T_DEV){
	fprintf(stderr, "Reading DEV file. Not implemented in readi in mkfs\n");
	return -1;
    }
    if(off > xint(din->size) || off + n < off){
	return -1;
    }
    if(off + n > xint(din->size)){
	n = xint(din->size) - off;
    }

    for(tot = 0; tot < n;tot +=m, off+=m, dst+=m){
	fbn = off / BSIZE;
	rblock(din, fbn, (char*)data);
	m = min(n - tot, BSIZE - off%BSIZE);
	memmove(dst, cdata + off%BSIZE, m);
    }
    return n;
}

void 
rblock(struct dinode *din, uint bn, char *dst){
    uint indirect[NINDIRECT];
    uint addr;
    if(bn < NDIRECT){
	rsect(xint(din->addrs[bn]), dst);
	return;
    }
    bn -= NDIRECT;

    if(bn < NINDIRECT){
	rsect(xint(din->addrs[NDIRECT]), (char*)indirect);	
	addr = xint(indirect[bn]);
	rsect(addr, dst);
	return;
    }
}
//
//uint
//ichecksum(struct dinode *din){
//    unsigned int buf[512];
//    char *cbuf = (char *) buf;
//    uint n = sizeof(buf);
//    uint off = 0;
//    uint r, i;
//    unsigned int checksum = 0;
//    memset((void *) cbuf,0,n); 
//    unsigned int * bp;
//
//    while((r = readi(din, cbuf,off,n)) > 0){
//	off += r;
//	bp = (unsigned int *)buf;
//	for(i = 0; i < sizeof(buf) / sizeof(uint); i++){ 
//	    checksum ^= *bp;
//	    bp++;
//	}
//	memset((void *) cbuf,0,n); 
//    }
//
//    return checksum;
//}
//
//void
//copy_dinode_content(struct dinode *src, uint dst){
//    char buf[512];
//    char *cbuf = (char *) buf;
//    uint n = sizeof(buf);
//    uint off = 0;
//    uint r;
//    memset((void *) cbuf,0,n); 
//
//    while((r = readi(src, cbuf,off,n)) > 0){
//	off += r;
//	iappend(dst, cbuf, r);
//	memset((void *) cbuf,0,n); 
//    }
//}


