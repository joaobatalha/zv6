
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 14             	sub    $0x14,%esp
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   7:	83 ec 0c             	sub    $0xc,%esp
   a:	ff 75 08             	pushl  0x8(%ebp)
   d:	e8 b5 03 00 00       	call   3c7 <strlen>
  12:	83 c4 10             	add    $0x10,%esp
  15:	03 45 08             	add    0x8(%ebp),%eax
  18:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1b:	eb 03                	jmp    20 <fmtname+0x20>
  1d:	ff 4d f4             	decl   -0xc(%ebp)
  20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  23:	3b 45 08             	cmp    0x8(%ebp),%eax
  26:	72 09                	jb     31 <fmtname+0x31>
  28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2b:	8a 00                	mov    (%eax),%al
  2d:	3c 2f                	cmp    $0x2f,%al
  2f:	75 ec                	jne    1d <fmtname+0x1d>
    ;
  p++;
  31:	ff 45 f4             	incl   -0xc(%ebp)
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  34:	83 ec 0c             	sub    $0xc,%esp
  37:	ff 75 f4             	pushl  -0xc(%ebp)
  3a:	e8 88 03 00 00       	call   3c7 <strlen>
  3f:	83 c4 10             	add    $0x10,%esp
  42:	83 f8 0d             	cmp    $0xd,%eax
  45:	76 05                	jbe    4c <fmtname+0x4c>
    return p;
  47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  4a:	eb 60                	jmp    ac <fmtname+0xac>
  memmove(buf, p, strlen(p));
  4c:	83 ec 0c             	sub    $0xc,%esp
  4f:	ff 75 f4             	pushl  -0xc(%ebp)
  52:	e8 70 03 00 00       	call   3c7 <strlen>
  57:	83 c4 10             	add    $0x10,%esp
  5a:	83 ec 04             	sub    $0x4,%esp
  5d:	50                   	push   %eax
  5e:	ff 75 f4             	pushl  -0xc(%ebp)
  61:	68 e8 0a 00 00       	push   $0xae8
  66:	e8 bf 04 00 00       	call   52a <memmove>
  6b:	83 c4 10             	add    $0x10,%esp
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  6e:	83 ec 0c             	sub    $0xc,%esp
  71:	ff 75 f4             	pushl  -0xc(%ebp)
  74:	e8 4e 03 00 00       	call   3c7 <strlen>
  79:	83 c4 10             	add    $0x10,%esp
  7c:	ba 0e 00 00 00       	mov    $0xe,%edx
  81:	89 d3                	mov    %edx,%ebx
  83:	29 c3                	sub    %eax,%ebx
  85:	83 ec 0c             	sub    $0xc,%esp
  88:	ff 75 f4             	pushl  -0xc(%ebp)
  8b:	e8 37 03 00 00       	call   3c7 <strlen>
  90:	83 c4 10             	add    $0x10,%esp
  93:	05 e8 0a 00 00       	add    $0xae8,%eax
  98:	83 ec 04             	sub    $0x4,%esp
  9b:	53                   	push   %ebx
  9c:	6a 20                	push   $0x20
  9e:	50                   	push   %eax
  9f:	e8 46 03 00 00       	call   3ea <memset>
  a4:	83 c4 10             	add    $0x10,%esp
  return buf;
  a7:	b8 e8 0a 00 00       	mov    $0xae8,%eax
}
  ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  af:	c9                   	leave  
  b0:	c3                   	ret    

000000b1 <ls>:

void
ls(char *path)
{
  b1:	55                   	push   %ebp
  b2:	89 e5                	mov    %esp,%ebp
  b4:	57                   	push   %edi
  b5:	56                   	push   %esi
  b6:	53                   	push   %ebx
  b7:	81 ec 3c 02 00 00    	sub    $0x23c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
  bd:	83 ec 08             	sub    $0x8,%esp
  c0:	6a 00                	push   $0x0
  c2:	ff 75 08             	pushl  0x8(%ebp)
  c5:	e8 e2 04 00 00       	call   5ac <open>
  ca:	83 c4 10             	add    $0x10,%esp
  cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  d4:	79 1a                	jns    f0 <ls+0x3f>
    printf(2, "ls: cannot open %s\n", path);
  d6:	83 ec 04             	sub    $0x4,%esp
  d9:	ff 75 08             	pushl  0x8(%ebp)
  dc:	68 80 0a 00 00       	push   $0xa80
  e1:	6a 02                	push   $0x2
  e3:	e8 f0 05 00 00       	call   6d8 <printf>
  e8:	83 c4 10             	add    $0x10,%esp
    return;
  eb:	e9 dd 01 00 00       	jmp    2cd <ls+0x21c>
  }
  
  if(fstat(fd, &st) < 0){
  f0:	83 ec 08             	sub    $0x8,%esp
  f3:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
  f9:	50                   	push   %eax
  fa:	ff 75 e4             	pushl  -0x1c(%ebp)
  fd:	e8 c2 04 00 00       	call   5c4 <fstat>
 102:	83 c4 10             	add    $0x10,%esp
 105:	85 c0                	test   %eax,%eax
 107:	79 28                	jns    131 <ls+0x80>
    printf(2, "ls: cannot stat %s\n", path);
 109:	83 ec 04             	sub    $0x4,%esp
 10c:	ff 75 08             	pushl  0x8(%ebp)
 10f:	68 94 0a 00 00       	push   $0xa94
 114:	6a 02                	push   $0x2
 116:	e8 bd 05 00 00       	call   6d8 <printf>
 11b:	83 c4 10             	add    $0x10,%esp
    close(fd);
 11e:	83 ec 0c             	sub    $0xc,%esp
 121:	ff 75 e4             	pushl  -0x1c(%ebp)
 124:	e8 6b 04 00 00       	call   594 <close>
 129:	83 c4 10             	add    $0x10,%esp
    return;
 12c:	e9 9c 01 00 00       	jmp    2cd <ls+0x21c>
  }
  
  switch(st.type){
 131:	8b 85 bc fd ff ff    	mov    -0x244(%ebp),%eax
 137:	98                   	cwtl   
 138:	83 f8 01             	cmp    $0x1,%eax
 13b:	74 47                	je     184 <ls+0xd3>
 13d:	83 f8 02             	cmp    $0x2,%eax
 140:	0f 85 79 01 00 00    	jne    2bf <ls+0x20e>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 146:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 14c:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 152:	8b 85 bc fd ff ff    	mov    -0x244(%ebp),%eax
 158:	0f bf d8             	movswl %ax,%ebx
 15b:	83 ec 0c             	sub    $0xc,%esp
 15e:	ff 75 08             	pushl  0x8(%ebp)
 161:	e8 9a fe ff ff       	call   0 <fmtname>
 166:	83 c4 10             	add    $0x10,%esp
 169:	83 ec 08             	sub    $0x8,%esp
 16c:	57                   	push   %edi
 16d:	56                   	push   %esi
 16e:	53                   	push   %ebx
 16f:	50                   	push   %eax
 170:	68 a8 0a 00 00       	push   $0xaa8
 175:	6a 01                	push   $0x1
 177:	e8 5c 05 00 00       	call   6d8 <printf>
 17c:	83 c4 20             	add    $0x20,%esp
    break;
 17f:	e9 3b 01 00 00       	jmp    2bf <ls+0x20e>
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 184:	83 ec 0c             	sub    $0xc,%esp
 187:	ff 75 08             	pushl  0x8(%ebp)
 18a:	e8 38 02 00 00       	call   3c7 <strlen>
 18f:	83 c4 10             	add    $0x10,%esp
 192:	83 c0 10             	add    $0x10,%eax
 195:	3d 00 02 00 00       	cmp    $0x200,%eax
 19a:	76 17                	jbe    1b3 <ls+0x102>
      printf(1, "ls: path too long\n");
 19c:	83 ec 08             	sub    $0x8,%esp
 19f:	68 b5 0a 00 00       	push   $0xab5
 1a4:	6a 01                	push   $0x1
 1a6:	e8 2d 05 00 00       	call   6d8 <printf>
 1ab:	83 c4 10             	add    $0x10,%esp
      break;
 1ae:	e9 0c 01 00 00       	jmp    2bf <ls+0x20e>
    }
    strcpy(buf, path);
 1b3:	83 ec 08             	sub    $0x8,%esp
 1b6:	ff 75 08             	pushl  0x8(%ebp)
 1b9:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1bf:	50                   	push   %eax
 1c0:	e8 98 01 00 00       	call   35d <strcpy>
 1c5:	83 c4 10             	add    $0x10,%esp
    p = buf+strlen(buf);
 1c8:	83 ec 0c             	sub    $0xc,%esp
 1cb:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1d1:	50                   	push   %eax
 1d2:	e8 f0 01 00 00       	call   3c7 <strlen>
 1d7:	83 c4 10             	add    $0x10,%esp
 1da:	8d 95 e0 fd ff ff    	lea    -0x220(%ebp),%edx
 1e0:	8d 04 02             	lea    (%edx,%eax,1),%eax
 1e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
 1e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1e9:	c6 00 2f             	movb   $0x2f,(%eax)
 1ec:	ff 45 e0             	incl   -0x20(%ebp)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1ef:	e9 aa 00 00 00       	jmp    29e <ls+0x1ed>
      if(de.inum == 0)
 1f4:	8b 85 d0 fd ff ff    	mov    -0x230(%ebp),%eax
 1fa:	66 85 c0             	test   %ax,%ax
 1fd:	0f 84 9a 00 00 00    	je     29d <ls+0x1ec>
        continue;
      memmove(p, de.name, DIRSIZ);
 203:	83 ec 04             	sub    $0x4,%esp
 206:	6a 0e                	push   $0xe
 208:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 20e:	83 c0 02             	add    $0x2,%eax
 211:	50                   	push   %eax
 212:	ff 75 e0             	pushl  -0x20(%ebp)
 215:	e8 10 03 00 00       	call   52a <memmove>
 21a:	83 c4 10             	add    $0x10,%esp
      p[DIRSIZ] = 0;
 21d:	8b 45 e0             	mov    -0x20(%ebp),%eax
 220:	83 c0 0e             	add    $0xe,%eax
 223:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
 226:	83 ec 08             	sub    $0x8,%esp
 229:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
 22f:	50                   	push   %eax
 230:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 236:	50                   	push   %eax
 237:	e8 59 02 00 00       	call   495 <stat>
 23c:	83 c4 10             	add    $0x10,%esp
 23f:	85 c0                	test   %eax,%eax
 241:	79 1b                	jns    25e <ls+0x1ad>
        printf(1, "ls: cannot stat %s\n", buf);
 243:	83 ec 04             	sub    $0x4,%esp
 246:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 24c:	50                   	push   %eax
 24d:	68 94 0a 00 00       	push   $0xa94
 252:	6a 01                	push   $0x1
 254:	e8 7f 04 00 00       	call   6d8 <printf>
 259:	83 c4 10             	add    $0x10,%esp
        continue;
 25c:	eb 40                	jmp    29e <ls+0x1ed>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 25e:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 264:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 26a:	8b 85 bc fd ff ff    	mov    -0x244(%ebp),%eax
 270:	0f bf d8             	movswl %ax,%ebx
 273:	83 ec 0c             	sub    $0xc,%esp
 276:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 27c:	50                   	push   %eax
 27d:	e8 7e fd ff ff       	call   0 <fmtname>
 282:	83 c4 10             	add    $0x10,%esp
 285:	83 ec 08             	sub    $0x8,%esp
 288:	57                   	push   %edi
 289:	56                   	push   %esi
 28a:	53                   	push   %ebx
 28b:	50                   	push   %eax
 28c:	68 a8 0a 00 00       	push   $0xaa8
 291:	6a 01                	push   $0x1
 293:	e8 40 04 00 00       	call   6d8 <printf>
 298:	83 c4 20             	add    $0x20,%esp
 29b:	eb 01                	jmp    29e <ls+0x1ed>
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
      if(de.inum == 0)
        continue;
 29d:	90                   	nop
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 29e:	83 ec 04             	sub    $0x4,%esp
 2a1:	6a 10                	push   $0x10
 2a3:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 2a9:	50                   	push   %eax
 2aa:	ff 75 e4             	pushl  -0x1c(%ebp)
 2ad:	e8 d2 02 00 00       	call   584 <read>
 2b2:	83 c4 10             	add    $0x10,%esp
 2b5:	83 f8 10             	cmp    $0x10,%eax
 2b8:	0f 84 36 ff ff ff    	je     1f4 <ls+0x143>
        printf(1, "ls: cannot stat %s\n", buf);
        continue;
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
 2be:	90                   	nop
  }
  close(fd);
 2bf:	83 ec 0c             	sub    $0xc,%esp
 2c2:	ff 75 e4             	pushl  -0x1c(%ebp)
 2c5:	e8 ca 02 00 00       	call   594 <close>
 2ca:	83 c4 10             	add    $0x10,%esp
}
 2cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2d0:	83 c4 00             	add    $0x0,%esp
 2d3:	5b                   	pop    %ebx
 2d4:	5e                   	pop    %esi
 2d5:	5f                   	pop    %edi
 2d6:	c9                   	leave  
 2d7:	c3                   	ret    

000002d8 <main>:

int
main(int argc, char *argv[])
{
 2d8:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 2dc:	83 e4 f0             	and    $0xfffffff0,%esp
 2df:	ff 71 fc             	pushl  -0x4(%ecx)
 2e2:	55                   	push   %ebp
 2e3:	89 e5                	mov    %esp,%ebp
 2e5:	53                   	push   %ebx
 2e6:	51                   	push   %ecx
 2e7:	83 ec 10             	sub    $0x10,%esp
 2ea:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 2){
 2ec:	83 3b 01             	cmpl   $0x1,(%ebx)
 2ef:	7f 15                	jg     306 <main+0x2e>
    ls(".");
 2f1:	83 ec 0c             	sub    $0xc,%esp
 2f4:	68 c8 0a 00 00       	push   $0xac8
 2f9:	e8 b3 fd ff ff       	call   b1 <ls>
 2fe:	83 c4 10             	add    $0x10,%esp
    exit();
 301:	e8 66 02 00 00       	call   56c <exit>
  }
  for(i=1; i<argc; i++)
 306:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 30d:	eb 1a                	jmp    329 <main+0x51>
    ls(argv[i]);
 30f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 312:	c1 e0 02             	shl    $0x2,%eax
 315:	03 43 04             	add    0x4(%ebx),%eax
 318:	8b 00                	mov    (%eax),%eax
 31a:	83 ec 0c             	sub    $0xc,%esp
 31d:	50                   	push   %eax
 31e:	e8 8e fd ff ff       	call   b1 <ls>
 323:	83 c4 10             	add    $0x10,%esp

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 326:	ff 45 f4             	incl   -0xc(%ebp)
 329:	8b 45 f4             	mov    -0xc(%ebp),%eax
 32c:	3b 03                	cmp    (%ebx),%eax
 32e:	7c df                	jl     30f <main+0x37>
    ls(argv[i]);
  exit();
 330:	e8 37 02 00 00       	call   56c <exit>
 335:	90                   	nop
 336:	90                   	nop
 337:	90                   	nop

00000338 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 338:	55                   	push   %ebp
 339:	89 e5                	mov    %esp,%ebp
 33b:	57                   	push   %edi
 33c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 33d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 340:	8b 55 10             	mov    0x10(%ebp),%edx
 343:	8b 45 0c             	mov    0xc(%ebp),%eax
 346:	89 cb                	mov    %ecx,%ebx
 348:	89 df                	mov    %ebx,%edi
 34a:	89 d1                	mov    %edx,%ecx
 34c:	fc                   	cld    
 34d:	f3 aa                	rep stos %al,%es:(%edi)
 34f:	89 ca                	mov    %ecx,%edx
 351:	89 fb                	mov    %edi,%ebx
 353:	89 5d 08             	mov    %ebx,0x8(%ebp)
 356:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 359:	5b                   	pop    %ebx
 35a:	5f                   	pop    %edi
 35b:	c9                   	leave  
 35c:	c3                   	ret    

0000035d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 35d:	55                   	push   %ebp
 35e:	89 e5                	mov    %esp,%ebp
 360:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 363:	8b 45 08             	mov    0x8(%ebp),%eax
 366:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 369:	90                   	nop
 36a:	8b 45 0c             	mov    0xc(%ebp),%eax
 36d:	8a 10                	mov    (%eax),%dl
 36f:	8b 45 08             	mov    0x8(%ebp),%eax
 372:	88 10                	mov    %dl,(%eax)
 374:	8b 45 08             	mov    0x8(%ebp),%eax
 377:	8a 00                	mov    (%eax),%al
 379:	84 c0                	test   %al,%al
 37b:	0f 95 c0             	setne  %al
 37e:	ff 45 08             	incl   0x8(%ebp)
 381:	ff 45 0c             	incl   0xc(%ebp)
 384:	84 c0                	test   %al,%al
 386:	75 e2                	jne    36a <strcpy+0xd>
    ;
  return os;
 388:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 38b:	c9                   	leave  
 38c:	c3                   	ret    

0000038d <strcmp>:

int
strcmp(const char *p, const char *q)
{
 38d:	55                   	push   %ebp
 38e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 390:	eb 06                	jmp    398 <strcmp+0xb>
    p++, q++;
 392:	ff 45 08             	incl   0x8(%ebp)
 395:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 398:	8b 45 08             	mov    0x8(%ebp),%eax
 39b:	8a 00                	mov    (%eax),%al
 39d:	84 c0                	test   %al,%al
 39f:	74 0e                	je     3af <strcmp+0x22>
 3a1:	8b 45 08             	mov    0x8(%ebp),%eax
 3a4:	8a 10                	mov    (%eax),%dl
 3a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a9:	8a 00                	mov    (%eax),%al
 3ab:	38 c2                	cmp    %al,%dl
 3ad:	74 e3                	je     392 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3af:	8b 45 08             	mov    0x8(%ebp),%eax
 3b2:	8a 00                	mov    (%eax),%al
 3b4:	0f b6 d0             	movzbl %al,%edx
 3b7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ba:	8a 00                	mov    (%eax),%al
 3bc:	0f b6 c0             	movzbl %al,%eax
 3bf:	89 d1                	mov    %edx,%ecx
 3c1:	29 c1                	sub    %eax,%ecx
 3c3:	89 c8                	mov    %ecx,%eax
}
 3c5:	c9                   	leave  
 3c6:	c3                   	ret    

000003c7 <strlen>:

uint
strlen(char *s)
{
 3c7:	55                   	push   %ebp
 3c8:	89 e5                	mov    %esp,%ebp
 3ca:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3d4:	eb 03                	jmp    3d9 <strlen+0x12>
 3d6:	ff 45 fc             	incl   -0x4(%ebp)
 3d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3dc:	03 45 08             	add    0x8(%ebp),%eax
 3df:	8a 00                	mov    (%eax),%al
 3e1:	84 c0                	test   %al,%al
 3e3:	75 f1                	jne    3d6 <strlen+0xf>
    ;
  return n;
 3e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3e8:	c9                   	leave  
 3e9:	c3                   	ret    

000003ea <memset>:

void*
memset(void *dst, int c, uint n)
{
 3ea:	55                   	push   %ebp
 3eb:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 3ed:	8b 45 10             	mov    0x10(%ebp),%eax
 3f0:	50                   	push   %eax
 3f1:	ff 75 0c             	pushl  0xc(%ebp)
 3f4:	ff 75 08             	pushl  0x8(%ebp)
 3f7:	e8 3c ff ff ff       	call   338 <stosb>
 3fc:	83 c4 0c             	add    $0xc,%esp
  return dst;
 3ff:	8b 45 08             	mov    0x8(%ebp),%eax
}
 402:	c9                   	leave  
 403:	c3                   	ret    

00000404 <strchr>:

char*
strchr(const char *s, char c)
{
 404:	55                   	push   %ebp
 405:	89 e5                	mov    %esp,%ebp
 407:	83 ec 04             	sub    $0x4,%esp
 40a:	8b 45 0c             	mov    0xc(%ebp),%eax
 40d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 410:	eb 12                	jmp    424 <strchr+0x20>
    if(*s == c)
 412:	8b 45 08             	mov    0x8(%ebp),%eax
 415:	8a 00                	mov    (%eax),%al
 417:	3a 45 fc             	cmp    -0x4(%ebp),%al
 41a:	75 05                	jne    421 <strchr+0x1d>
      return (char*)s;
 41c:	8b 45 08             	mov    0x8(%ebp),%eax
 41f:	eb 11                	jmp    432 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 421:	ff 45 08             	incl   0x8(%ebp)
 424:	8b 45 08             	mov    0x8(%ebp),%eax
 427:	8a 00                	mov    (%eax),%al
 429:	84 c0                	test   %al,%al
 42b:	75 e5                	jne    412 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 42d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 432:	c9                   	leave  
 433:	c3                   	ret    

00000434 <gets>:

char*
gets(char *buf, int max)
{
 434:	55                   	push   %ebp
 435:	89 e5                	mov    %esp,%ebp
 437:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 43a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 441:	eb 38                	jmp    47b <gets+0x47>
    cc = read(0, &c, 1);
 443:	83 ec 04             	sub    $0x4,%esp
 446:	6a 01                	push   $0x1
 448:	8d 45 ef             	lea    -0x11(%ebp),%eax
 44b:	50                   	push   %eax
 44c:	6a 00                	push   $0x0
 44e:	e8 31 01 00 00       	call   584 <read>
 453:	83 c4 10             	add    $0x10,%esp
 456:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 459:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 45d:	7e 27                	jle    486 <gets+0x52>
      break;
    buf[i++] = c;
 45f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 462:	03 45 08             	add    0x8(%ebp),%eax
 465:	8a 55 ef             	mov    -0x11(%ebp),%dl
 468:	88 10                	mov    %dl,(%eax)
 46a:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 46d:	8a 45 ef             	mov    -0x11(%ebp),%al
 470:	3c 0a                	cmp    $0xa,%al
 472:	74 13                	je     487 <gets+0x53>
 474:	8a 45 ef             	mov    -0x11(%ebp),%al
 477:	3c 0d                	cmp    $0xd,%al
 479:	74 0c                	je     487 <gets+0x53>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 47b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 47e:	40                   	inc    %eax
 47f:	3b 45 0c             	cmp    0xc(%ebp),%eax
 482:	7c bf                	jl     443 <gets+0xf>
 484:	eb 01                	jmp    487 <gets+0x53>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 486:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 487:	8b 45 f4             	mov    -0xc(%ebp),%eax
 48a:	03 45 08             	add    0x8(%ebp),%eax
 48d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 490:	8b 45 08             	mov    0x8(%ebp),%eax
}
 493:	c9                   	leave  
 494:	c3                   	ret    

00000495 <stat>:

int
stat(char *n, struct stat *st)
{
 495:	55                   	push   %ebp
 496:	89 e5                	mov    %esp,%ebp
 498:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 49b:	83 ec 08             	sub    $0x8,%esp
 49e:	6a 00                	push   $0x0
 4a0:	ff 75 08             	pushl  0x8(%ebp)
 4a3:	e8 04 01 00 00       	call   5ac <open>
 4a8:	83 c4 10             	add    $0x10,%esp
 4ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4b2:	79 07                	jns    4bb <stat+0x26>
    return -1;
 4b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4b9:	eb 25                	jmp    4e0 <stat+0x4b>
  r = fstat(fd, st);
 4bb:	83 ec 08             	sub    $0x8,%esp
 4be:	ff 75 0c             	pushl  0xc(%ebp)
 4c1:	ff 75 f4             	pushl  -0xc(%ebp)
 4c4:	e8 fb 00 00 00       	call   5c4 <fstat>
 4c9:	83 c4 10             	add    $0x10,%esp
 4cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4cf:	83 ec 0c             	sub    $0xc,%esp
 4d2:	ff 75 f4             	pushl  -0xc(%ebp)
 4d5:	e8 ba 00 00 00       	call   594 <close>
 4da:	83 c4 10             	add    $0x10,%esp
  return r;
 4dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 4e0:	c9                   	leave  
 4e1:	c3                   	ret    

000004e2 <atoi>:

int
atoi(const char *s)
{
 4e2:	55                   	push   %ebp
 4e3:	89 e5                	mov    %esp,%ebp
 4e5:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 4e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 4ef:	eb 22                	jmp    513 <atoi+0x31>
    n = n*10 + *s++ - '0';
 4f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4f4:	89 d0                	mov    %edx,%eax
 4f6:	c1 e0 02             	shl    $0x2,%eax
 4f9:	01 d0                	add    %edx,%eax
 4fb:	d1 e0                	shl    %eax
 4fd:	89 c2                	mov    %eax,%edx
 4ff:	8b 45 08             	mov    0x8(%ebp),%eax
 502:	8a 00                	mov    (%eax),%al
 504:	0f be c0             	movsbl %al,%eax
 507:	8d 04 02             	lea    (%edx,%eax,1),%eax
 50a:	83 e8 30             	sub    $0x30,%eax
 50d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 510:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 513:	8b 45 08             	mov    0x8(%ebp),%eax
 516:	8a 00                	mov    (%eax),%al
 518:	3c 2f                	cmp    $0x2f,%al
 51a:	7e 09                	jle    525 <atoi+0x43>
 51c:	8b 45 08             	mov    0x8(%ebp),%eax
 51f:	8a 00                	mov    (%eax),%al
 521:	3c 39                	cmp    $0x39,%al
 523:	7e cc                	jle    4f1 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 525:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 528:	c9                   	leave  
 529:	c3                   	ret    

0000052a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 52a:	55                   	push   %ebp
 52b:	89 e5                	mov    %esp,%ebp
 52d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 530:	8b 45 08             	mov    0x8(%ebp),%eax
 533:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 536:	8b 45 0c             	mov    0xc(%ebp),%eax
 539:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 53c:	eb 10                	jmp    54e <memmove+0x24>
    *dst++ = *src++;
 53e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 541:	8a 10                	mov    (%eax),%dl
 543:	8b 45 fc             	mov    -0x4(%ebp),%eax
 546:	88 10                	mov    %dl,(%eax)
 548:	ff 45 fc             	incl   -0x4(%ebp)
 54b:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 54e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 552:	0f 9f c0             	setg   %al
 555:	ff 4d 10             	decl   0x10(%ebp)
 558:	84 c0                	test   %al,%al
 55a:	75 e2                	jne    53e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 55c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 55f:	c9                   	leave  
 560:	c3                   	ret    
 561:	90                   	nop
 562:	90                   	nop
 563:	90                   	nop

00000564 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 564:	b8 01 00 00 00       	mov    $0x1,%eax
 569:	cd 40                	int    $0x40
 56b:	c3                   	ret    

0000056c <exit>:
SYSCALL(exit)
 56c:	b8 02 00 00 00       	mov    $0x2,%eax
 571:	cd 40                	int    $0x40
 573:	c3                   	ret    

00000574 <wait>:
SYSCALL(wait)
 574:	b8 03 00 00 00       	mov    $0x3,%eax
 579:	cd 40                	int    $0x40
 57b:	c3                   	ret    

0000057c <pipe>:
SYSCALL(pipe)
 57c:	b8 04 00 00 00       	mov    $0x4,%eax
 581:	cd 40                	int    $0x40
 583:	c3                   	ret    

00000584 <read>:
SYSCALL(read)
 584:	b8 05 00 00 00       	mov    $0x5,%eax
 589:	cd 40                	int    $0x40
 58b:	c3                   	ret    

0000058c <write>:
SYSCALL(write)
 58c:	b8 10 00 00 00       	mov    $0x10,%eax
 591:	cd 40                	int    $0x40
 593:	c3                   	ret    

00000594 <close>:
SYSCALL(close)
 594:	b8 15 00 00 00       	mov    $0x15,%eax
 599:	cd 40                	int    $0x40
 59b:	c3                   	ret    

0000059c <kill>:
SYSCALL(kill)
 59c:	b8 06 00 00 00       	mov    $0x6,%eax
 5a1:	cd 40                	int    $0x40
 5a3:	c3                   	ret    

000005a4 <exec>:
SYSCALL(exec)
 5a4:	b8 07 00 00 00       	mov    $0x7,%eax
 5a9:	cd 40                	int    $0x40
 5ab:	c3                   	ret    

000005ac <open>:
SYSCALL(open)
 5ac:	b8 0f 00 00 00       	mov    $0xf,%eax
 5b1:	cd 40                	int    $0x40
 5b3:	c3                   	ret    

000005b4 <mknod>:
SYSCALL(mknod)
 5b4:	b8 11 00 00 00       	mov    $0x11,%eax
 5b9:	cd 40                	int    $0x40
 5bb:	c3                   	ret    

000005bc <unlink>:
SYSCALL(unlink)
 5bc:	b8 12 00 00 00       	mov    $0x12,%eax
 5c1:	cd 40                	int    $0x40
 5c3:	c3                   	ret    

000005c4 <fstat>:
SYSCALL(fstat)
 5c4:	b8 08 00 00 00       	mov    $0x8,%eax
 5c9:	cd 40                	int    $0x40
 5cb:	c3                   	ret    

000005cc <link>:
SYSCALL(link)
 5cc:	b8 13 00 00 00       	mov    $0x13,%eax
 5d1:	cd 40                	int    $0x40
 5d3:	c3                   	ret    

000005d4 <mkdir>:
SYSCALL(mkdir)
 5d4:	b8 14 00 00 00       	mov    $0x14,%eax
 5d9:	cd 40                	int    $0x40
 5db:	c3                   	ret    

000005dc <chdir>:
SYSCALL(chdir)
 5dc:	b8 09 00 00 00       	mov    $0x9,%eax
 5e1:	cd 40                	int    $0x40
 5e3:	c3                   	ret    

000005e4 <dup>:
SYSCALL(dup)
 5e4:	b8 0a 00 00 00       	mov    $0xa,%eax
 5e9:	cd 40                	int    $0x40
 5eb:	c3                   	ret    

000005ec <getpid>:
SYSCALL(getpid)
 5ec:	b8 0b 00 00 00       	mov    $0xb,%eax
 5f1:	cd 40                	int    $0x40
 5f3:	c3                   	ret    

000005f4 <sbrk>:
SYSCALL(sbrk)
 5f4:	b8 0c 00 00 00       	mov    $0xc,%eax
 5f9:	cd 40                	int    $0x40
 5fb:	c3                   	ret    

000005fc <sleep>:
SYSCALL(sleep)
 5fc:	b8 0d 00 00 00       	mov    $0xd,%eax
 601:	cd 40                	int    $0x40
 603:	c3                   	ret    

00000604 <uptime>:
SYSCALL(uptime)
 604:	b8 0e 00 00 00       	mov    $0xe,%eax
 609:	cd 40                	int    $0x40
 60b:	c3                   	ret    

0000060c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 60c:	55                   	push   %ebp
 60d:	89 e5                	mov    %esp,%ebp
 60f:	83 ec 18             	sub    $0x18,%esp
 612:	8b 45 0c             	mov    0xc(%ebp),%eax
 615:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 618:	83 ec 04             	sub    $0x4,%esp
 61b:	6a 01                	push   $0x1
 61d:	8d 45 f4             	lea    -0xc(%ebp),%eax
 620:	50                   	push   %eax
 621:	ff 75 08             	pushl  0x8(%ebp)
 624:	e8 63 ff ff ff       	call   58c <write>
 629:	83 c4 10             	add    $0x10,%esp
}
 62c:	c9                   	leave  
 62d:	c3                   	ret    

0000062e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 62e:	55                   	push   %ebp
 62f:	89 e5                	mov    %esp,%ebp
 631:	83 ec 38             	sub    $0x38,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 634:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 63b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 63f:	74 17                	je     658 <printint+0x2a>
 641:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 645:	79 11                	jns    658 <printint+0x2a>
    neg = 1;
 647:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 64e:	8b 45 0c             	mov    0xc(%ebp),%eax
 651:	f7 d8                	neg    %eax
 653:	89 45 ec             	mov    %eax,-0x14(%ebp)
 656:	eb 06                	jmp    65e <printint+0x30>
  } else {
    x = xx;
 658:	8b 45 0c             	mov    0xc(%ebp),%eax
 65b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 65e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 665:	8b 4d 10             	mov    0x10(%ebp),%ecx
 668:	8b 45 ec             	mov    -0x14(%ebp),%eax
 66b:	ba 00 00 00 00       	mov    $0x0,%edx
 670:	f7 f1                	div    %ecx
 672:	89 d0                	mov    %edx,%eax
 674:	8a 90 d4 0a 00 00    	mov    0xad4(%eax),%dl
 67a:	8d 45 dc             	lea    -0x24(%ebp),%eax
 67d:	03 45 f4             	add    -0xc(%ebp),%eax
 680:	88 10                	mov    %dl,(%eax)
 682:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 685:	8b 45 10             	mov    0x10(%ebp),%eax
 688:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 68b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 68e:	ba 00 00 00 00       	mov    $0x0,%edx
 693:	f7 75 d4             	divl   -0x2c(%ebp)
 696:	89 45 ec             	mov    %eax,-0x14(%ebp)
 699:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 69d:	75 c6                	jne    665 <printint+0x37>
  if(neg)
 69f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6a3:	74 28                	je     6cd <printint+0x9f>
    buf[i++] = '-';
 6a5:	8d 45 dc             	lea    -0x24(%ebp),%eax
 6a8:	03 45 f4             	add    -0xc(%ebp),%eax
 6ab:	c6 00 2d             	movb   $0x2d,(%eax)
 6ae:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 6b1:	eb 1a                	jmp    6cd <printint+0x9f>
    putc(fd, buf[i]);
 6b3:	8d 45 dc             	lea    -0x24(%ebp),%eax
 6b6:	03 45 f4             	add    -0xc(%ebp),%eax
 6b9:	8a 00                	mov    (%eax),%al
 6bb:	0f be c0             	movsbl %al,%eax
 6be:	83 ec 08             	sub    $0x8,%esp
 6c1:	50                   	push   %eax
 6c2:	ff 75 08             	pushl  0x8(%ebp)
 6c5:	e8 42 ff ff ff       	call   60c <putc>
 6ca:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6cd:	ff 4d f4             	decl   -0xc(%ebp)
 6d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6d4:	79 dd                	jns    6b3 <printint+0x85>
    putc(fd, buf[i]);
}
 6d6:	c9                   	leave  
 6d7:	c3                   	ret    

000006d8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6d8:	55                   	push   %ebp
 6d9:	89 e5                	mov    %esp,%ebp
 6db:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6de:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 6e5:	8d 45 0c             	lea    0xc(%ebp),%eax
 6e8:	83 c0 04             	add    $0x4,%eax
 6eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6ee:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6f5:	e9 58 01 00 00       	jmp    852 <printf+0x17a>
    c = fmt[i] & 0xff;
 6fa:	8b 55 0c             	mov    0xc(%ebp),%edx
 6fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 700:	8d 04 02             	lea    (%edx,%eax,1),%eax
 703:	8a 00                	mov    (%eax),%al
 705:	0f be c0             	movsbl %al,%eax
 708:	25 ff 00 00 00       	and    $0xff,%eax
 70d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 710:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 714:	75 2c                	jne    742 <printf+0x6a>
      if(c == '%'){
 716:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 71a:	75 0c                	jne    728 <printf+0x50>
        state = '%';
 71c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 723:	e9 27 01 00 00       	jmp    84f <printf+0x177>
      } else {
        putc(fd, c);
 728:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 72b:	0f be c0             	movsbl %al,%eax
 72e:	83 ec 08             	sub    $0x8,%esp
 731:	50                   	push   %eax
 732:	ff 75 08             	pushl  0x8(%ebp)
 735:	e8 d2 fe ff ff       	call   60c <putc>
 73a:	83 c4 10             	add    $0x10,%esp
 73d:	e9 0d 01 00 00       	jmp    84f <printf+0x177>
      }
    } else if(state == '%'){
 742:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 746:	0f 85 03 01 00 00    	jne    84f <printf+0x177>
      if(c == 'd'){
 74c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 750:	75 1e                	jne    770 <printf+0x98>
        printint(fd, *ap, 10, 1);
 752:	8b 45 e8             	mov    -0x18(%ebp),%eax
 755:	8b 00                	mov    (%eax),%eax
 757:	6a 01                	push   $0x1
 759:	6a 0a                	push   $0xa
 75b:	50                   	push   %eax
 75c:	ff 75 08             	pushl  0x8(%ebp)
 75f:	e8 ca fe ff ff       	call   62e <printint>
 764:	83 c4 10             	add    $0x10,%esp
        ap++;
 767:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 76b:	e9 d8 00 00 00       	jmp    848 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 770:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 774:	74 06                	je     77c <printf+0xa4>
 776:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 77a:	75 1e                	jne    79a <printf+0xc2>
        printint(fd, *ap, 16, 0);
 77c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 77f:	8b 00                	mov    (%eax),%eax
 781:	6a 00                	push   $0x0
 783:	6a 10                	push   $0x10
 785:	50                   	push   %eax
 786:	ff 75 08             	pushl  0x8(%ebp)
 789:	e8 a0 fe ff ff       	call   62e <printint>
 78e:	83 c4 10             	add    $0x10,%esp
        ap++;
 791:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 795:	e9 ae 00 00 00       	jmp    848 <printf+0x170>
      } else if(c == 's'){
 79a:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 79e:	75 43                	jne    7e3 <printf+0x10b>
        s = (char*)*ap;
 7a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7a3:	8b 00                	mov    (%eax),%eax
 7a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7a8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7b0:	75 25                	jne    7d7 <printf+0xff>
          s = "(null)";
 7b2:	c7 45 f4 ca 0a 00 00 	movl   $0xaca,-0xc(%ebp)
        while(*s != 0){
 7b9:	eb 1d                	jmp    7d8 <printf+0x100>
          putc(fd, *s);
 7bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7be:	8a 00                	mov    (%eax),%al
 7c0:	0f be c0             	movsbl %al,%eax
 7c3:	83 ec 08             	sub    $0x8,%esp
 7c6:	50                   	push   %eax
 7c7:	ff 75 08             	pushl  0x8(%ebp)
 7ca:	e8 3d fe ff ff       	call   60c <putc>
 7cf:	83 c4 10             	add    $0x10,%esp
          s++;
 7d2:	ff 45 f4             	incl   -0xc(%ebp)
 7d5:	eb 01                	jmp    7d8 <printf+0x100>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7d7:	90                   	nop
 7d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7db:	8a 00                	mov    (%eax),%al
 7dd:	84 c0                	test   %al,%al
 7df:	75 da                	jne    7bb <printf+0xe3>
 7e1:	eb 65                	jmp    848 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7e3:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7e7:	75 1d                	jne    806 <printf+0x12e>
        putc(fd, *ap);
 7e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7ec:	8b 00                	mov    (%eax),%eax
 7ee:	0f be c0             	movsbl %al,%eax
 7f1:	83 ec 08             	sub    $0x8,%esp
 7f4:	50                   	push   %eax
 7f5:	ff 75 08             	pushl  0x8(%ebp)
 7f8:	e8 0f fe ff ff       	call   60c <putc>
 7fd:	83 c4 10             	add    $0x10,%esp
        ap++;
 800:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 804:	eb 42                	jmp    848 <printf+0x170>
      } else if(c == '%'){
 806:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 80a:	75 17                	jne    823 <printf+0x14b>
        putc(fd, c);
 80c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 80f:	0f be c0             	movsbl %al,%eax
 812:	83 ec 08             	sub    $0x8,%esp
 815:	50                   	push   %eax
 816:	ff 75 08             	pushl  0x8(%ebp)
 819:	e8 ee fd ff ff       	call   60c <putc>
 81e:	83 c4 10             	add    $0x10,%esp
 821:	eb 25                	jmp    848 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 823:	83 ec 08             	sub    $0x8,%esp
 826:	6a 25                	push   $0x25
 828:	ff 75 08             	pushl  0x8(%ebp)
 82b:	e8 dc fd ff ff       	call   60c <putc>
 830:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 833:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 836:	0f be c0             	movsbl %al,%eax
 839:	83 ec 08             	sub    $0x8,%esp
 83c:	50                   	push   %eax
 83d:	ff 75 08             	pushl  0x8(%ebp)
 840:	e8 c7 fd ff ff       	call   60c <putc>
 845:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 848:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 84f:	ff 45 f0             	incl   -0x10(%ebp)
 852:	8b 55 0c             	mov    0xc(%ebp),%edx
 855:	8b 45 f0             	mov    -0x10(%ebp),%eax
 858:	8d 04 02             	lea    (%edx,%eax,1),%eax
 85b:	8a 00                	mov    (%eax),%al
 85d:	84 c0                	test   %al,%al
 85f:	0f 85 95 fe ff ff    	jne    6fa <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 865:	c9                   	leave  
 866:	c3                   	ret    
 867:	90                   	nop

00000868 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 868:	55                   	push   %ebp
 869:	89 e5                	mov    %esp,%ebp
 86b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 86e:	8b 45 08             	mov    0x8(%ebp),%eax
 871:	83 e8 08             	sub    $0x8,%eax
 874:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 877:	a1 00 0b 00 00       	mov    0xb00,%eax
 87c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 87f:	eb 24                	jmp    8a5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 881:	8b 45 fc             	mov    -0x4(%ebp),%eax
 884:	8b 00                	mov    (%eax),%eax
 886:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 889:	77 12                	ja     89d <free+0x35>
 88b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 88e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 891:	77 24                	ja     8b7 <free+0x4f>
 893:	8b 45 fc             	mov    -0x4(%ebp),%eax
 896:	8b 00                	mov    (%eax),%eax
 898:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 89b:	77 1a                	ja     8b7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 89d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a0:	8b 00                	mov    (%eax),%eax
 8a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8a8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8ab:	76 d4                	jbe    881 <free+0x19>
 8ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b0:	8b 00                	mov    (%eax),%eax
 8b2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8b5:	76 ca                	jbe    881 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 8b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ba:	8b 40 04             	mov    0x4(%eax),%eax
 8bd:	c1 e0 03             	shl    $0x3,%eax
 8c0:	89 c2                	mov    %eax,%edx
 8c2:	03 55 f8             	add    -0x8(%ebp),%edx
 8c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c8:	8b 00                	mov    (%eax),%eax
 8ca:	39 c2                	cmp    %eax,%edx
 8cc:	75 24                	jne    8f2 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 8ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d1:	8b 50 04             	mov    0x4(%eax),%edx
 8d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d7:	8b 00                	mov    (%eax),%eax
 8d9:	8b 40 04             	mov    0x4(%eax),%eax
 8dc:	01 c2                	add    %eax,%edx
 8de:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e7:	8b 00                	mov    (%eax),%eax
 8e9:	8b 10                	mov    (%eax),%edx
 8eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ee:	89 10                	mov    %edx,(%eax)
 8f0:	eb 0a                	jmp    8fc <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 8f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f5:	8b 10                	mov    (%eax),%edx
 8f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8fa:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ff:	8b 40 04             	mov    0x4(%eax),%eax
 902:	c1 e0 03             	shl    $0x3,%eax
 905:	03 45 fc             	add    -0x4(%ebp),%eax
 908:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 90b:	75 20                	jne    92d <free+0xc5>
    p->s.size += bp->s.size;
 90d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 910:	8b 50 04             	mov    0x4(%eax),%edx
 913:	8b 45 f8             	mov    -0x8(%ebp),%eax
 916:	8b 40 04             	mov    0x4(%eax),%eax
 919:	01 c2                	add    %eax,%edx
 91b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 921:	8b 45 f8             	mov    -0x8(%ebp),%eax
 924:	8b 10                	mov    (%eax),%edx
 926:	8b 45 fc             	mov    -0x4(%ebp),%eax
 929:	89 10                	mov    %edx,(%eax)
 92b:	eb 08                	jmp    935 <free+0xcd>
  } else
    p->s.ptr = bp;
 92d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 930:	8b 55 f8             	mov    -0x8(%ebp),%edx
 933:	89 10                	mov    %edx,(%eax)
  freep = p;
 935:	8b 45 fc             	mov    -0x4(%ebp),%eax
 938:	a3 00 0b 00 00       	mov    %eax,0xb00
}
 93d:	c9                   	leave  
 93e:	c3                   	ret    

0000093f <morecore>:

static Header*
morecore(uint nu)
{
 93f:	55                   	push   %ebp
 940:	89 e5                	mov    %esp,%ebp
 942:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 945:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 94c:	77 07                	ja     955 <morecore+0x16>
    nu = 4096;
 94e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 955:	8b 45 08             	mov    0x8(%ebp),%eax
 958:	c1 e0 03             	shl    $0x3,%eax
 95b:	83 ec 0c             	sub    $0xc,%esp
 95e:	50                   	push   %eax
 95f:	e8 90 fc ff ff       	call   5f4 <sbrk>
 964:	83 c4 10             	add    $0x10,%esp
 967:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 96a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 96e:	75 07                	jne    977 <morecore+0x38>
    return 0;
 970:	b8 00 00 00 00       	mov    $0x0,%eax
 975:	eb 26                	jmp    99d <morecore+0x5e>
  hp = (Header*)p;
 977:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 97d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 980:	8b 55 08             	mov    0x8(%ebp),%edx
 983:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 986:	8b 45 f0             	mov    -0x10(%ebp),%eax
 989:	83 c0 08             	add    $0x8,%eax
 98c:	83 ec 0c             	sub    $0xc,%esp
 98f:	50                   	push   %eax
 990:	e8 d3 fe ff ff       	call   868 <free>
 995:	83 c4 10             	add    $0x10,%esp
  return freep;
 998:	a1 00 0b 00 00       	mov    0xb00,%eax
}
 99d:	c9                   	leave  
 99e:	c3                   	ret    

0000099f <malloc>:

void*
malloc(uint nbytes)
{
 99f:	55                   	push   %ebp
 9a0:	89 e5                	mov    %esp,%ebp
 9a2:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9a5:	8b 45 08             	mov    0x8(%ebp),%eax
 9a8:	83 c0 07             	add    $0x7,%eax
 9ab:	c1 e8 03             	shr    $0x3,%eax
 9ae:	40                   	inc    %eax
 9af:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9b2:	a1 00 0b 00 00       	mov    0xb00,%eax
 9b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9be:	75 23                	jne    9e3 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 9c0:	c7 45 f0 f8 0a 00 00 	movl   $0xaf8,-0x10(%ebp)
 9c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ca:	a3 00 0b 00 00       	mov    %eax,0xb00
 9cf:	a1 00 0b 00 00       	mov    0xb00,%eax
 9d4:	a3 f8 0a 00 00       	mov    %eax,0xaf8
    base.s.size = 0;
 9d9:	c7 05 fc 0a 00 00 00 	movl   $0x0,0xafc
 9e0:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9e6:	8b 00                	mov    (%eax),%eax
 9e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ee:	8b 40 04             	mov    0x4(%eax),%eax
 9f1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9f4:	72 4d                	jb     a43 <malloc+0xa4>
      if(p->s.size == nunits)
 9f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f9:	8b 40 04             	mov    0x4(%eax),%eax
 9fc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9ff:	75 0c                	jne    a0d <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a04:	8b 10                	mov    (%eax),%edx
 a06:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a09:	89 10                	mov    %edx,(%eax)
 a0b:	eb 26                	jmp    a33 <malloc+0x94>
      else {
        p->s.size -= nunits;
 a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a10:	8b 40 04             	mov    0x4(%eax),%eax
 a13:	89 c2                	mov    %eax,%edx
 a15:	2b 55 ec             	sub    -0x14(%ebp),%edx
 a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a1b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a21:	8b 40 04             	mov    0x4(%eax),%eax
 a24:	c1 e0 03             	shl    $0x3,%eax
 a27:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a2d:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a30:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a33:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a36:	a3 00 0b 00 00       	mov    %eax,0xb00
      return (void*)(p + 1);
 a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a3e:	83 c0 08             	add    $0x8,%eax
 a41:	eb 3b                	jmp    a7e <malloc+0xdf>
    }
    if(p == freep)
 a43:	a1 00 0b 00 00       	mov    0xb00,%eax
 a48:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a4b:	75 1e                	jne    a6b <malloc+0xcc>
      if((p = morecore(nunits)) == 0)
 a4d:	83 ec 0c             	sub    $0xc,%esp
 a50:	ff 75 ec             	pushl  -0x14(%ebp)
 a53:	e8 e7 fe ff ff       	call   93f <morecore>
 a58:	83 c4 10             	add    $0x10,%esp
 a5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a62:	75 07                	jne    a6b <malloc+0xcc>
        return 0;
 a64:	b8 00 00 00 00       	mov    $0x0,%eax
 a69:	eb 13                	jmp    a7e <malloc+0xdf>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a74:	8b 00                	mov    (%eax),%eax
 a76:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a79:	e9 6d ff ff ff       	jmp    9eb <malloc+0x4c>
}
 a7e:	c9                   	leave  
 a7f:	c3                   	ret    
