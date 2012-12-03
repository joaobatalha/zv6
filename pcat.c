#include "types.h"
#include "stat.h"
#include "user.h"

char buf[512];

void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
    write(1, buf, n);
  if(n < 0){
    printf(1, "pcat: read error\n");
    exit();
  }
}

int
main(int argc, char *argv[])
{
  int fd, dev, inum;

  if (argc != 3) {
		printf(1, "usage: pcat [DEV] [INUM]\n");
    exit();
  }

	dev = atoi(argv[1]);
	inum = atoi(argv[2]);

  if((fd = iopen(dev, inum)) < 0){
    printf(1, "pcat: cannot open inode %d on device %d\n", inum, dev);
    exit();
  }
  cat(fd);
  close(fd);
  exit();
}
