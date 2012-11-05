
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 1){
  14:	83 3b 00             	cmpl   $0x0,(%ebx)
  17:	7f 17                	jg     30 <main+0x30>
    printf(2, "usage: kill pid...\n");
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 b4 07 00 00       	push   $0x7b4
  21:	6a 02                	push   $0x2
  23:	e8 e4 03 00 00       	call   40c <printf>
  28:	83 c4 10             	add    $0x10,%esp
    exit();
  2b:	e8 70 02 00 00       	call   2a0 <exit>
  }
  for(i=1; i<argc; i++)
  30:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  37:	eb 26                	jmp    5f <main+0x5f>
    kill(atoi(argv[i]));
  39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  3c:	c1 e0 02             	shl    $0x2,%eax
  3f:	03 43 04             	add    0x4(%ebx),%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	83 ec 0c             	sub    $0xc,%esp
  47:	50                   	push   %eax
  48:	e8 c9 01 00 00       	call   216 <atoi>
  4d:	83 c4 10             	add    $0x10,%esp
  50:	83 ec 0c             	sub    $0xc,%esp
  53:	50                   	push   %eax
  54:	e8 77 02 00 00       	call   2d0 <kill>
  59:	83 c4 10             	add    $0x10,%esp

  if(argc < 1){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  5c:	ff 45 f4             	incl   -0xc(%ebp)
  5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  62:	3b 03                	cmp    (%ebx),%eax
  64:	7c d3                	jl     39 <main+0x39>
    kill(atoi(argv[i]));
  exit();
  66:	e8 35 02 00 00       	call   2a0 <exit>
  6b:	90                   	nop

0000006c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  6c:	55                   	push   %ebp
  6d:	89 e5                	mov    %esp,%ebp
  6f:	57                   	push   %edi
  70:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  74:	8b 55 10             	mov    0x10(%ebp),%edx
  77:	8b 45 0c             	mov    0xc(%ebp),%eax
  7a:	89 cb                	mov    %ecx,%ebx
  7c:	89 df                	mov    %ebx,%edi
  7e:	89 d1                	mov    %edx,%ecx
  80:	fc                   	cld    
  81:	f3 aa                	rep stos %al,%es:(%edi)
  83:	89 ca                	mov    %ecx,%edx
  85:	89 fb                	mov    %edi,%ebx
  87:	89 5d 08             	mov    %ebx,0x8(%ebp)
  8a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  8d:	5b                   	pop    %ebx
  8e:	5f                   	pop    %edi
  8f:	c9                   	leave  
  90:	c3                   	ret    

00000091 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  91:	55                   	push   %ebp
  92:	89 e5                	mov    %esp,%ebp
  94:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  97:	8b 45 08             	mov    0x8(%ebp),%eax
  9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  9d:	90                   	nop
  9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  a1:	8a 10                	mov    (%eax),%dl
  a3:	8b 45 08             	mov    0x8(%ebp),%eax
  a6:	88 10                	mov    %dl,(%eax)
  a8:	8b 45 08             	mov    0x8(%ebp),%eax
  ab:	8a 00                	mov    (%eax),%al
  ad:	84 c0                	test   %al,%al
  af:	0f 95 c0             	setne  %al
  b2:	ff 45 08             	incl   0x8(%ebp)
  b5:	ff 45 0c             	incl   0xc(%ebp)
  b8:	84 c0                	test   %al,%al
  ba:	75 e2                	jne    9e <strcpy+0xd>
    ;
  return os;
  bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  bf:	c9                   	leave  
  c0:	c3                   	ret    

000000c1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c1:	55                   	push   %ebp
  c2:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  c4:	eb 06                	jmp    cc <strcmp+0xb>
    p++, q++;
  c6:	ff 45 08             	incl   0x8(%ebp)
  c9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  cc:	8b 45 08             	mov    0x8(%ebp),%eax
  cf:	8a 00                	mov    (%eax),%al
  d1:	84 c0                	test   %al,%al
  d3:	74 0e                	je     e3 <strcmp+0x22>
  d5:	8b 45 08             	mov    0x8(%ebp),%eax
  d8:	8a 10                	mov    (%eax),%dl
  da:	8b 45 0c             	mov    0xc(%ebp),%eax
  dd:	8a 00                	mov    (%eax),%al
  df:	38 c2                	cmp    %al,%dl
  e1:	74 e3                	je     c6 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  e3:	8b 45 08             	mov    0x8(%ebp),%eax
  e6:	8a 00                	mov    (%eax),%al
  e8:	0f b6 d0             	movzbl %al,%edx
  eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  ee:	8a 00                	mov    (%eax),%al
  f0:	0f b6 c0             	movzbl %al,%eax
  f3:	89 d1                	mov    %edx,%ecx
  f5:	29 c1                	sub    %eax,%ecx
  f7:	89 c8                	mov    %ecx,%eax
}
  f9:	c9                   	leave  
  fa:	c3                   	ret    

000000fb <strlen>:

uint
strlen(char *s)
{
  fb:	55                   	push   %ebp
  fc:	89 e5                	mov    %esp,%ebp
  fe:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 101:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 108:	eb 03                	jmp    10d <strlen+0x12>
 10a:	ff 45 fc             	incl   -0x4(%ebp)
 10d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 110:	03 45 08             	add    0x8(%ebp),%eax
 113:	8a 00                	mov    (%eax),%al
 115:	84 c0                	test   %al,%al
 117:	75 f1                	jne    10a <strlen+0xf>
    ;
  return n;
 119:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 11c:	c9                   	leave  
 11d:	c3                   	ret    

0000011e <memset>:

void*
memset(void *dst, int c, uint n)
{
 11e:	55                   	push   %ebp
 11f:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 121:	8b 45 10             	mov    0x10(%ebp),%eax
 124:	50                   	push   %eax
 125:	ff 75 0c             	pushl  0xc(%ebp)
 128:	ff 75 08             	pushl  0x8(%ebp)
 12b:	e8 3c ff ff ff       	call   6c <stosb>
 130:	83 c4 0c             	add    $0xc,%esp
  return dst;
 133:	8b 45 08             	mov    0x8(%ebp),%eax
}
 136:	c9                   	leave  
 137:	c3                   	ret    

00000138 <strchr>:

char*
strchr(const char *s, char c)
{
 138:	55                   	push   %ebp
 139:	89 e5                	mov    %esp,%ebp
 13b:	83 ec 04             	sub    $0x4,%esp
 13e:	8b 45 0c             	mov    0xc(%ebp),%eax
 141:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 144:	eb 12                	jmp    158 <strchr+0x20>
    if(*s == c)
 146:	8b 45 08             	mov    0x8(%ebp),%eax
 149:	8a 00                	mov    (%eax),%al
 14b:	3a 45 fc             	cmp    -0x4(%ebp),%al
 14e:	75 05                	jne    155 <strchr+0x1d>
      return (char*)s;
 150:	8b 45 08             	mov    0x8(%ebp),%eax
 153:	eb 11                	jmp    166 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 155:	ff 45 08             	incl   0x8(%ebp)
 158:	8b 45 08             	mov    0x8(%ebp),%eax
 15b:	8a 00                	mov    (%eax),%al
 15d:	84 c0                	test   %al,%al
 15f:	75 e5                	jne    146 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 161:	b8 00 00 00 00       	mov    $0x0,%eax
}
 166:	c9                   	leave  
 167:	c3                   	ret    

00000168 <gets>:

char*
gets(char *buf, int max)
{
 168:	55                   	push   %ebp
 169:	89 e5                	mov    %esp,%ebp
 16b:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 16e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 175:	eb 38                	jmp    1af <gets+0x47>
    cc = read(0, &c, 1);
 177:	83 ec 04             	sub    $0x4,%esp
 17a:	6a 01                	push   $0x1
 17c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 17f:	50                   	push   %eax
 180:	6a 00                	push   $0x0
 182:	e8 31 01 00 00       	call   2b8 <read>
 187:	83 c4 10             	add    $0x10,%esp
 18a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 18d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 191:	7e 27                	jle    1ba <gets+0x52>
      break;
    buf[i++] = c;
 193:	8b 45 f4             	mov    -0xc(%ebp),%eax
 196:	03 45 08             	add    0x8(%ebp),%eax
 199:	8a 55 ef             	mov    -0x11(%ebp),%dl
 19c:	88 10                	mov    %dl,(%eax)
 19e:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 1a1:	8a 45 ef             	mov    -0x11(%ebp),%al
 1a4:	3c 0a                	cmp    $0xa,%al
 1a6:	74 13                	je     1bb <gets+0x53>
 1a8:	8a 45 ef             	mov    -0x11(%ebp),%al
 1ab:	3c 0d                	cmp    $0xd,%al
 1ad:	74 0c                	je     1bb <gets+0x53>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b2:	40                   	inc    %eax
 1b3:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1b6:	7c bf                	jl     177 <gets+0xf>
 1b8:	eb 01                	jmp    1bb <gets+0x53>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1ba:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1be:	03 45 08             	add    0x8(%ebp),%eax
 1c1:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1c4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1c7:	c9                   	leave  
 1c8:	c3                   	ret    

000001c9 <stat>:

int
stat(char *n, struct stat *st)
{
 1c9:	55                   	push   %ebp
 1ca:	89 e5                	mov    %esp,%ebp
 1cc:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1cf:	83 ec 08             	sub    $0x8,%esp
 1d2:	6a 00                	push   $0x0
 1d4:	ff 75 08             	pushl  0x8(%ebp)
 1d7:	e8 04 01 00 00       	call   2e0 <open>
 1dc:	83 c4 10             	add    $0x10,%esp
 1df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1e6:	79 07                	jns    1ef <stat+0x26>
    return -1;
 1e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1ed:	eb 25                	jmp    214 <stat+0x4b>
  r = fstat(fd, st);
 1ef:	83 ec 08             	sub    $0x8,%esp
 1f2:	ff 75 0c             	pushl  0xc(%ebp)
 1f5:	ff 75 f4             	pushl  -0xc(%ebp)
 1f8:	e8 fb 00 00 00       	call   2f8 <fstat>
 1fd:	83 c4 10             	add    $0x10,%esp
 200:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 203:	83 ec 0c             	sub    $0xc,%esp
 206:	ff 75 f4             	pushl  -0xc(%ebp)
 209:	e8 ba 00 00 00       	call   2c8 <close>
 20e:	83 c4 10             	add    $0x10,%esp
  return r;
 211:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 214:	c9                   	leave  
 215:	c3                   	ret    

00000216 <atoi>:

int
atoi(const char *s)
{
 216:	55                   	push   %ebp
 217:	89 e5                	mov    %esp,%ebp
 219:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 21c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 223:	eb 22                	jmp    247 <atoi+0x31>
    n = n*10 + *s++ - '0';
 225:	8b 55 fc             	mov    -0x4(%ebp),%edx
 228:	89 d0                	mov    %edx,%eax
 22a:	c1 e0 02             	shl    $0x2,%eax
 22d:	01 d0                	add    %edx,%eax
 22f:	d1 e0                	shl    %eax
 231:	89 c2                	mov    %eax,%edx
 233:	8b 45 08             	mov    0x8(%ebp),%eax
 236:	8a 00                	mov    (%eax),%al
 238:	0f be c0             	movsbl %al,%eax
 23b:	8d 04 02             	lea    (%edx,%eax,1),%eax
 23e:	83 e8 30             	sub    $0x30,%eax
 241:	89 45 fc             	mov    %eax,-0x4(%ebp)
 244:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 247:	8b 45 08             	mov    0x8(%ebp),%eax
 24a:	8a 00                	mov    (%eax),%al
 24c:	3c 2f                	cmp    $0x2f,%al
 24e:	7e 09                	jle    259 <atoi+0x43>
 250:	8b 45 08             	mov    0x8(%ebp),%eax
 253:	8a 00                	mov    (%eax),%al
 255:	3c 39                	cmp    $0x39,%al
 257:	7e cc                	jle    225 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 259:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 25c:	c9                   	leave  
 25d:	c3                   	ret    

0000025e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 25e:	55                   	push   %ebp
 25f:	89 e5                	mov    %esp,%ebp
 261:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 264:	8b 45 08             	mov    0x8(%ebp),%eax
 267:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 26a:	8b 45 0c             	mov    0xc(%ebp),%eax
 26d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 270:	eb 10                	jmp    282 <memmove+0x24>
    *dst++ = *src++;
 272:	8b 45 f8             	mov    -0x8(%ebp),%eax
 275:	8a 10                	mov    (%eax),%dl
 277:	8b 45 fc             	mov    -0x4(%ebp),%eax
 27a:	88 10                	mov    %dl,(%eax)
 27c:	ff 45 fc             	incl   -0x4(%ebp)
 27f:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 282:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 286:	0f 9f c0             	setg   %al
 289:	ff 4d 10             	decl   0x10(%ebp)
 28c:	84 c0                	test   %al,%al
 28e:	75 e2                	jne    272 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 290:	8b 45 08             	mov    0x8(%ebp),%eax
}
 293:	c9                   	leave  
 294:	c3                   	ret    
 295:	90                   	nop
 296:	90                   	nop
 297:	90                   	nop

00000298 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 298:	b8 01 00 00 00       	mov    $0x1,%eax
 29d:	cd 40                	int    $0x40
 29f:	c3                   	ret    

000002a0 <exit>:
SYSCALL(exit)
 2a0:	b8 02 00 00 00       	mov    $0x2,%eax
 2a5:	cd 40                	int    $0x40
 2a7:	c3                   	ret    

000002a8 <wait>:
SYSCALL(wait)
 2a8:	b8 03 00 00 00       	mov    $0x3,%eax
 2ad:	cd 40                	int    $0x40
 2af:	c3                   	ret    

000002b0 <pipe>:
SYSCALL(pipe)
 2b0:	b8 04 00 00 00       	mov    $0x4,%eax
 2b5:	cd 40                	int    $0x40
 2b7:	c3                   	ret    

000002b8 <read>:
SYSCALL(read)
 2b8:	b8 05 00 00 00       	mov    $0x5,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <write>:
SYSCALL(write)
 2c0:	b8 10 00 00 00       	mov    $0x10,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <close>:
SYSCALL(close)
 2c8:	b8 15 00 00 00       	mov    $0x15,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <kill>:
SYSCALL(kill)
 2d0:	b8 06 00 00 00       	mov    $0x6,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <exec>:
SYSCALL(exec)
 2d8:	b8 07 00 00 00       	mov    $0x7,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <open>:
SYSCALL(open)
 2e0:	b8 0f 00 00 00       	mov    $0xf,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <mknod>:
SYSCALL(mknod)
 2e8:	b8 11 00 00 00       	mov    $0x11,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <unlink>:
SYSCALL(unlink)
 2f0:	b8 12 00 00 00       	mov    $0x12,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <fstat>:
SYSCALL(fstat)
 2f8:	b8 08 00 00 00       	mov    $0x8,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <link>:
SYSCALL(link)
 300:	b8 13 00 00 00       	mov    $0x13,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <mkdir>:
SYSCALL(mkdir)
 308:	b8 14 00 00 00       	mov    $0x14,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <chdir>:
SYSCALL(chdir)
 310:	b8 09 00 00 00       	mov    $0x9,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <dup>:
SYSCALL(dup)
 318:	b8 0a 00 00 00       	mov    $0xa,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <getpid>:
SYSCALL(getpid)
 320:	b8 0b 00 00 00       	mov    $0xb,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <sbrk>:
SYSCALL(sbrk)
 328:	b8 0c 00 00 00       	mov    $0xc,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <sleep>:
SYSCALL(sleep)
 330:	b8 0d 00 00 00       	mov    $0xd,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <uptime>:
SYSCALL(uptime)
 338:	b8 0e 00 00 00       	mov    $0xe,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	83 ec 18             	sub    $0x18,%esp
 346:	8b 45 0c             	mov    0xc(%ebp),%eax
 349:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 34c:	83 ec 04             	sub    $0x4,%esp
 34f:	6a 01                	push   $0x1
 351:	8d 45 f4             	lea    -0xc(%ebp),%eax
 354:	50                   	push   %eax
 355:	ff 75 08             	pushl  0x8(%ebp)
 358:	e8 63 ff ff ff       	call   2c0 <write>
 35d:	83 c4 10             	add    $0x10,%esp
}
 360:	c9                   	leave  
 361:	c3                   	ret    

00000362 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 362:	55                   	push   %ebp
 363:	89 e5                	mov    %esp,%ebp
 365:	83 ec 38             	sub    $0x38,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 368:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 36f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 373:	74 17                	je     38c <printint+0x2a>
 375:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 379:	79 11                	jns    38c <printint+0x2a>
    neg = 1;
 37b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 382:	8b 45 0c             	mov    0xc(%ebp),%eax
 385:	f7 d8                	neg    %eax
 387:	89 45 ec             	mov    %eax,-0x14(%ebp)
 38a:	eb 06                	jmp    392 <printint+0x30>
  } else {
    x = xx;
 38c:	8b 45 0c             	mov    0xc(%ebp),%eax
 38f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 392:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 399:	8b 4d 10             	mov    0x10(%ebp),%ecx
 39c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 39f:	ba 00 00 00 00       	mov    $0x0,%edx
 3a4:	f7 f1                	div    %ecx
 3a6:	89 d0                	mov    %edx,%eax
 3a8:	8a 90 d0 07 00 00    	mov    0x7d0(%eax),%dl
 3ae:	8d 45 dc             	lea    -0x24(%ebp),%eax
 3b1:	03 45 f4             	add    -0xc(%ebp),%eax
 3b4:	88 10                	mov    %dl,(%eax)
 3b6:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 3b9:	8b 45 10             	mov    0x10(%ebp),%eax
 3bc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 3bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3c2:	ba 00 00 00 00       	mov    $0x0,%edx
 3c7:	f7 75 d4             	divl   -0x2c(%ebp)
 3ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3d1:	75 c6                	jne    399 <printint+0x37>
  if(neg)
 3d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3d7:	74 28                	je     401 <printint+0x9f>
    buf[i++] = '-';
 3d9:	8d 45 dc             	lea    -0x24(%ebp),%eax
 3dc:	03 45 f4             	add    -0xc(%ebp),%eax
 3df:	c6 00 2d             	movb   $0x2d,(%eax)
 3e2:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 3e5:	eb 1a                	jmp    401 <printint+0x9f>
    putc(fd, buf[i]);
 3e7:	8d 45 dc             	lea    -0x24(%ebp),%eax
 3ea:	03 45 f4             	add    -0xc(%ebp),%eax
 3ed:	8a 00                	mov    (%eax),%al
 3ef:	0f be c0             	movsbl %al,%eax
 3f2:	83 ec 08             	sub    $0x8,%esp
 3f5:	50                   	push   %eax
 3f6:	ff 75 08             	pushl  0x8(%ebp)
 3f9:	e8 42 ff ff ff       	call   340 <putc>
 3fe:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 401:	ff 4d f4             	decl   -0xc(%ebp)
 404:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 408:	79 dd                	jns    3e7 <printint+0x85>
    putc(fd, buf[i]);
}
 40a:	c9                   	leave  
 40b:	c3                   	ret    

0000040c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 40c:	55                   	push   %ebp
 40d:	89 e5                	mov    %esp,%ebp
 40f:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 412:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 419:	8d 45 0c             	lea    0xc(%ebp),%eax
 41c:	83 c0 04             	add    $0x4,%eax
 41f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 422:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 429:	e9 58 01 00 00       	jmp    586 <printf+0x17a>
    c = fmt[i] & 0xff;
 42e:	8b 55 0c             	mov    0xc(%ebp),%edx
 431:	8b 45 f0             	mov    -0x10(%ebp),%eax
 434:	8d 04 02             	lea    (%edx,%eax,1),%eax
 437:	8a 00                	mov    (%eax),%al
 439:	0f be c0             	movsbl %al,%eax
 43c:	25 ff 00 00 00       	and    $0xff,%eax
 441:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 444:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 448:	75 2c                	jne    476 <printf+0x6a>
      if(c == '%'){
 44a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 44e:	75 0c                	jne    45c <printf+0x50>
        state = '%';
 450:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 457:	e9 27 01 00 00       	jmp    583 <printf+0x177>
      } else {
        putc(fd, c);
 45c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 45f:	0f be c0             	movsbl %al,%eax
 462:	83 ec 08             	sub    $0x8,%esp
 465:	50                   	push   %eax
 466:	ff 75 08             	pushl  0x8(%ebp)
 469:	e8 d2 fe ff ff       	call   340 <putc>
 46e:	83 c4 10             	add    $0x10,%esp
 471:	e9 0d 01 00 00       	jmp    583 <printf+0x177>
      }
    } else if(state == '%'){
 476:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 47a:	0f 85 03 01 00 00    	jne    583 <printf+0x177>
      if(c == 'd'){
 480:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 484:	75 1e                	jne    4a4 <printf+0x98>
        printint(fd, *ap, 10, 1);
 486:	8b 45 e8             	mov    -0x18(%ebp),%eax
 489:	8b 00                	mov    (%eax),%eax
 48b:	6a 01                	push   $0x1
 48d:	6a 0a                	push   $0xa
 48f:	50                   	push   %eax
 490:	ff 75 08             	pushl  0x8(%ebp)
 493:	e8 ca fe ff ff       	call   362 <printint>
 498:	83 c4 10             	add    $0x10,%esp
        ap++;
 49b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 49f:	e9 d8 00 00 00       	jmp    57c <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4a4:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4a8:	74 06                	je     4b0 <printf+0xa4>
 4aa:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4ae:	75 1e                	jne    4ce <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4b3:	8b 00                	mov    (%eax),%eax
 4b5:	6a 00                	push   $0x0
 4b7:	6a 10                	push   $0x10
 4b9:	50                   	push   %eax
 4ba:	ff 75 08             	pushl  0x8(%ebp)
 4bd:	e8 a0 fe ff ff       	call   362 <printint>
 4c2:	83 c4 10             	add    $0x10,%esp
        ap++;
 4c5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4c9:	e9 ae 00 00 00       	jmp    57c <printf+0x170>
      } else if(c == 's'){
 4ce:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4d2:	75 43                	jne    517 <printf+0x10b>
        s = (char*)*ap;
 4d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4d7:	8b 00                	mov    (%eax),%eax
 4d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 4dc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 4e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4e4:	75 25                	jne    50b <printf+0xff>
          s = "(null)";
 4e6:	c7 45 f4 c8 07 00 00 	movl   $0x7c8,-0xc(%ebp)
        while(*s != 0){
 4ed:	eb 1d                	jmp    50c <printf+0x100>
          putc(fd, *s);
 4ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4f2:	8a 00                	mov    (%eax),%al
 4f4:	0f be c0             	movsbl %al,%eax
 4f7:	83 ec 08             	sub    $0x8,%esp
 4fa:	50                   	push   %eax
 4fb:	ff 75 08             	pushl  0x8(%ebp)
 4fe:	e8 3d fe ff ff       	call   340 <putc>
 503:	83 c4 10             	add    $0x10,%esp
          s++;
 506:	ff 45 f4             	incl   -0xc(%ebp)
 509:	eb 01                	jmp    50c <printf+0x100>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 50b:	90                   	nop
 50c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 50f:	8a 00                	mov    (%eax),%al
 511:	84 c0                	test   %al,%al
 513:	75 da                	jne    4ef <printf+0xe3>
 515:	eb 65                	jmp    57c <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 517:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 51b:	75 1d                	jne    53a <printf+0x12e>
        putc(fd, *ap);
 51d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 520:	8b 00                	mov    (%eax),%eax
 522:	0f be c0             	movsbl %al,%eax
 525:	83 ec 08             	sub    $0x8,%esp
 528:	50                   	push   %eax
 529:	ff 75 08             	pushl  0x8(%ebp)
 52c:	e8 0f fe ff ff       	call   340 <putc>
 531:	83 c4 10             	add    $0x10,%esp
        ap++;
 534:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 538:	eb 42                	jmp    57c <printf+0x170>
      } else if(c == '%'){
 53a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 53e:	75 17                	jne    557 <printf+0x14b>
        putc(fd, c);
 540:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 543:	0f be c0             	movsbl %al,%eax
 546:	83 ec 08             	sub    $0x8,%esp
 549:	50                   	push   %eax
 54a:	ff 75 08             	pushl  0x8(%ebp)
 54d:	e8 ee fd ff ff       	call   340 <putc>
 552:	83 c4 10             	add    $0x10,%esp
 555:	eb 25                	jmp    57c <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 557:	83 ec 08             	sub    $0x8,%esp
 55a:	6a 25                	push   $0x25
 55c:	ff 75 08             	pushl  0x8(%ebp)
 55f:	e8 dc fd ff ff       	call   340 <putc>
 564:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 567:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 56a:	0f be c0             	movsbl %al,%eax
 56d:	83 ec 08             	sub    $0x8,%esp
 570:	50                   	push   %eax
 571:	ff 75 08             	pushl  0x8(%ebp)
 574:	e8 c7 fd ff ff       	call   340 <putc>
 579:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 57c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 583:	ff 45 f0             	incl   -0x10(%ebp)
 586:	8b 55 0c             	mov    0xc(%ebp),%edx
 589:	8b 45 f0             	mov    -0x10(%ebp),%eax
 58c:	8d 04 02             	lea    (%edx,%eax,1),%eax
 58f:	8a 00                	mov    (%eax),%al
 591:	84 c0                	test   %al,%al
 593:	0f 85 95 fe ff ff    	jne    42e <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 599:	c9                   	leave  
 59a:	c3                   	ret    
 59b:	90                   	nop

0000059c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 59c:	55                   	push   %ebp
 59d:	89 e5                	mov    %esp,%ebp
 59f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5a2:	8b 45 08             	mov    0x8(%ebp),%eax
 5a5:	83 e8 08             	sub    $0x8,%eax
 5a8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5ab:	a1 ec 07 00 00       	mov    0x7ec,%eax
 5b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5b3:	eb 24                	jmp    5d9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5b8:	8b 00                	mov    (%eax),%eax
 5ba:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5bd:	77 12                	ja     5d1 <free+0x35>
 5bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5c2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5c5:	77 24                	ja     5eb <free+0x4f>
 5c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ca:	8b 00                	mov    (%eax),%eax
 5cc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5cf:	77 1a                	ja     5eb <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5d4:	8b 00                	mov    (%eax),%eax
 5d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5dc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5df:	76 d4                	jbe    5b5 <free+0x19>
 5e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5e4:	8b 00                	mov    (%eax),%eax
 5e6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5e9:	76 ca                	jbe    5b5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 5eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5ee:	8b 40 04             	mov    0x4(%eax),%eax
 5f1:	c1 e0 03             	shl    $0x3,%eax
 5f4:	89 c2                	mov    %eax,%edx
 5f6:	03 55 f8             	add    -0x8(%ebp),%edx
 5f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5fc:	8b 00                	mov    (%eax),%eax
 5fe:	39 c2                	cmp    %eax,%edx
 600:	75 24                	jne    626 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 602:	8b 45 f8             	mov    -0x8(%ebp),%eax
 605:	8b 50 04             	mov    0x4(%eax),%edx
 608:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60b:	8b 00                	mov    (%eax),%eax
 60d:	8b 40 04             	mov    0x4(%eax),%eax
 610:	01 c2                	add    %eax,%edx
 612:	8b 45 f8             	mov    -0x8(%ebp),%eax
 615:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 618:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61b:	8b 00                	mov    (%eax),%eax
 61d:	8b 10                	mov    (%eax),%edx
 61f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 622:	89 10                	mov    %edx,(%eax)
 624:	eb 0a                	jmp    630 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 626:	8b 45 fc             	mov    -0x4(%ebp),%eax
 629:	8b 10                	mov    (%eax),%edx
 62b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 630:	8b 45 fc             	mov    -0x4(%ebp),%eax
 633:	8b 40 04             	mov    0x4(%eax),%eax
 636:	c1 e0 03             	shl    $0x3,%eax
 639:	03 45 fc             	add    -0x4(%ebp),%eax
 63c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 63f:	75 20                	jne    661 <free+0xc5>
    p->s.size += bp->s.size;
 641:	8b 45 fc             	mov    -0x4(%ebp),%eax
 644:	8b 50 04             	mov    0x4(%eax),%edx
 647:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64a:	8b 40 04             	mov    0x4(%eax),%eax
 64d:	01 c2                	add    %eax,%edx
 64f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 652:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 655:	8b 45 f8             	mov    -0x8(%ebp),%eax
 658:	8b 10                	mov    (%eax),%edx
 65a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65d:	89 10                	mov    %edx,(%eax)
 65f:	eb 08                	jmp    669 <free+0xcd>
  } else
    p->s.ptr = bp;
 661:	8b 45 fc             	mov    -0x4(%ebp),%eax
 664:	8b 55 f8             	mov    -0x8(%ebp),%edx
 667:	89 10                	mov    %edx,(%eax)
  freep = p;
 669:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66c:	a3 ec 07 00 00       	mov    %eax,0x7ec
}
 671:	c9                   	leave  
 672:	c3                   	ret    

00000673 <morecore>:

static Header*
morecore(uint nu)
{
 673:	55                   	push   %ebp
 674:	89 e5                	mov    %esp,%ebp
 676:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 679:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 680:	77 07                	ja     689 <morecore+0x16>
    nu = 4096;
 682:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 689:	8b 45 08             	mov    0x8(%ebp),%eax
 68c:	c1 e0 03             	shl    $0x3,%eax
 68f:	83 ec 0c             	sub    $0xc,%esp
 692:	50                   	push   %eax
 693:	e8 90 fc ff ff       	call   328 <sbrk>
 698:	83 c4 10             	add    $0x10,%esp
 69b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 69e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6a2:	75 07                	jne    6ab <morecore+0x38>
    return 0;
 6a4:	b8 00 00 00 00       	mov    $0x0,%eax
 6a9:	eb 26                	jmp    6d1 <morecore+0x5e>
  hp = (Header*)p;
 6ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6b4:	8b 55 08             	mov    0x8(%ebp),%edx
 6b7:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6bd:	83 c0 08             	add    $0x8,%eax
 6c0:	83 ec 0c             	sub    $0xc,%esp
 6c3:	50                   	push   %eax
 6c4:	e8 d3 fe ff ff       	call   59c <free>
 6c9:	83 c4 10             	add    $0x10,%esp
  return freep;
 6cc:	a1 ec 07 00 00       	mov    0x7ec,%eax
}
 6d1:	c9                   	leave  
 6d2:	c3                   	ret    

000006d3 <malloc>:

void*
malloc(uint nbytes)
{
 6d3:	55                   	push   %ebp
 6d4:	89 e5                	mov    %esp,%ebp
 6d6:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6d9:	8b 45 08             	mov    0x8(%ebp),%eax
 6dc:	83 c0 07             	add    $0x7,%eax
 6df:	c1 e8 03             	shr    $0x3,%eax
 6e2:	40                   	inc    %eax
 6e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 6e6:	a1 ec 07 00 00       	mov    0x7ec,%eax
 6eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
 6ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6f2:	75 23                	jne    717 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 6f4:	c7 45 f0 e4 07 00 00 	movl   $0x7e4,-0x10(%ebp)
 6fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6fe:	a3 ec 07 00 00       	mov    %eax,0x7ec
 703:	a1 ec 07 00 00       	mov    0x7ec,%eax
 708:	a3 e4 07 00 00       	mov    %eax,0x7e4
    base.s.size = 0;
 70d:	c7 05 e8 07 00 00 00 	movl   $0x0,0x7e8
 714:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 717:	8b 45 f0             	mov    -0x10(%ebp),%eax
 71a:	8b 00                	mov    (%eax),%eax
 71c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 71f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 722:	8b 40 04             	mov    0x4(%eax),%eax
 725:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 728:	72 4d                	jb     777 <malloc+0xa4>
      if(p->s.size == nunits)
 72a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 72d:	8b 40 04             	mov    0x4(%eax),%eax
 730:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 733:	75 0c                	jne    741 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 735:	8b 45 f4             	mov    -0xc(%ebp),%eax
 738:	8b 10                	mov    (%eax),%edx
 73a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73d:	89 10                	mov    %edx,(%eax)
 73f:	eb 26                	jmp    767 <malloc+0x94>
      else {
        p->s.size -= nunits;
 741:	8b 45 f4             	mov    -0xc(%ebp),%eax
 744:	8b 40 04             	mov    0x4(%eax),%eax
 747:	89 c2                	mov    %eax,%edx
 749:	2b 55 ec             	sub    -0x14(%ebp),%edx
 74c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 752:	8b 45 f4             	mov    -0xc(%ebp),%eax
 755:	8b 40 04             	mov    0x4(%eax),%eax
 758:	c1 e0 03             	shl    $0x3,%eax
 75b:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 75e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 761:	8b 55 ec             	mov    -0x14(%ebp),%edx
 764:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 767:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76a:	a3 ec 07 00 00       	mov    %eax,0x7ec
      return (void*)(p + 1);
 76f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 772:	83 c0 08             	add    $0x8,%eax
 775:	eb 3b                	jmp    7b2 <malloc+0xdf>
    }
    if(p == freep)
 777:	a1 ec 07 00 00       	mov    0x7ec,%eax
 77c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 77f:	75 1e                	jne    79f <malloc+0xcc>
      if((p = morecore(nunits)) == 0)
 781:	83 ec 0c             	sub    $0xc,%esp
 784:	ff 75 ec             	pushl  -0x14(%ebp)
 787:	e8 e7 fe ff ff       	call   673 <morecore>
 78c:	83 c4 10             	add    $0x10,%esp
 78f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 792:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 796:	75 07                	jne    79f <malloc+0xcc>
        return 0;
 798:	b8 00 00 00 00       	mov    $0x0,%eax
 79d:	eb 13                	jmp    7b2 <malloc+0xdf>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 79f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a8:	8b 00                	mov    (%eax),%eax
 7aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7ad:	e9 6d ff ff ff       	jmp    71f <malloc+0x4c>
}
 7b2:	c9                   	leave  
 7b3:	c3                   	ret    
