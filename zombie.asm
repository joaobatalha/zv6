
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  if(fork() > 0)
  11:	e8 42 02 00 00       	call   258 <fork>
  16:	85 c0                	test   %eax,%eax
  18:	7e 0d                	jle    27 <main+0x27>
    sleep(5);  // Let child exit before parent.
  1a:	83 ec 0c             	sub    $0xc,%esp
  1d:	6a 05                	push   $0x5
  1f:	e8 cc 02 00 00       	call   2f0 <sleep>
  24:	83 c4 10             	add    $0x10,%esp
  exit();
  27:	e8 34 02 00 00       	call   260 <exit>

0000002c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  2c:	55                   	push   %ebp
  2d:	89 e5                	mov    %esp,%ebp
  2f:	57                   	push   %edi
  30:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  34:	8b 55 10             	mov    0x10(%ebp),%edx
  37:	8b 45 0c             	mov    0xc(%ebp),%eax
  3a:	89 cb                	mov    %ecx,%ebx
  3c:	89 df                	mov    %ebx,%edi
  3e:	89 d1                	mov    %edx,%ecx
  40:	fc                   	cld    
  41:	f3 aa                	rep stos %al,%es:(%edi)
  43:	89 ca                	mov    %ecx,%edx
  45:	89 fb                	mov    %edi,%ebx
  47:	89 5d 08             	mov    %ebx,0x8(%ebp)
  4a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  4d:	5b                   	pop    %ebx
  4e:	5f                   	pop    %edi
  4f:	c9                   	leave  
  50:	c3                   	ret    

00000051 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  51:	55                   	push   %ebp
  52:	89 e5                	mov    %esp,%ebp
  54:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  57:	8b 45 08             	mov    0x8(%ebp),%eax
  5a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  5d:	90                   	nop
  5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  61:	8a 10                	mov    (%eax),%dl
  63:	8b 45 08             	mov    0x8(%ebp),%eax
  66:	88 10                	mov    %dl,(%eax)
  68:	8b 45 08             	mov    0x8(%ebp),%eax
  6b:	8a 00                	mov    (%eax),%al
  6d:	84 c0                	test   %al,%al
  6f:	0f 95 c0             	setne  %al
  72:	ff 45 08             	incl   0x8(%ebp)
  75:	ff 45 0c             	incl   0xc(%ebp)
  78:	84 c0                	test   %al,%al
  7a:	75 e2                	jne    5e <strcpy+0xd>
    ;
  return os;
  7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  7f:	c9                   	leave  
  80:	c3                   	ret    

00000081 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  81:	55                   	push   %ebp
  82:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  84:	eb 06                	jmp    8c <strcmp+0xb>
    p++, q++;
  86:	ff 45 08             	incl   0x8(%ebp)
  89:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  8c:	8b 45 08             	mov    0x8(%ebp),%eax
  8f:	8a 00                	mov    (%eax),%al
  91:	84 c0                	test   %al,%al
  93:	74 0e                	je     a3 <strcmp+0x22>
  95:	8b 45 08             	mov    0x8(%ebp),%eax
  98:	8a 10                	mov    (%eax),%dl
  9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  9d:	8a 00                	mov    (%eax),%al
  9f:	38 c2                	cmp    %al,%dl
  a1:	74 e3                	je     86 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  a3:	8b 45 08             	mov    0x8(%ebp),%eax
  a6:	8a 00                	mov    (%eax),%al
  a8:	0f b6 d0             	movzbl %al,%edx
  ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  ae:	8a 00                	mov    (%eax),%al
  b0:	0f b6 c0             	movzbl %al,%eax
  b3:	89 d1                	mov    %edx,%ecx
  b5:	29 c1                	sub    %eax,%ecx
  b7:	89 c8                	mov    %ecx,%eax
}
  b9:	c9                   	leave  
  ba:	c3                   	ret    

000000bb <strlen>:

uint
strlen(char *s)
{
  bb:	55                   	push   %ebp
  bc:	89 e5                	mov    %esp,%ebp
  be:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  c8:	eb 03                	jmp    cd <strlen+0x12>
  ca:	ff 45 fc             	incl   -0x4(%ebp)
  cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  d0:	03 45 08             	add    0x8(%ebp),%eax
  d3:	8a 00                	mov    (%eax),%al
  d5:	84 c0                	test   %al,%al
  d7:	75 f1                	jne    ca <strlen+0xf>
    ;
  return n;
  d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  dc:	c9                   	leave  
  dd:	c3                   	ret    

000000de <memset>:

void*
memset(void *dst, int c, uint n)
{
  de:	55                   	push   %ebp
  df:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  e1:	8b 45 10             	mov    0x10(%ebp),%eax
  e4:	50                   	push   %eax
  e5:	ff 75 0c             	pushl  0xc(%ebp)
  e8:	ff 75 08             	pushl  0x8(%ebp)
  eb:	e8 3c ff ff ff       	call   2c <stosb>
  f0:	83 c4 0c             	add    $0xc,%esp
  return dst;
  f3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  f6:	c9                   	leave  
  f7:	c3                   	ret    

000000f8 <strchr>:

char*
strchr(const char *s, char c)
{
  f8:	55                   	push   %ebp
  f9:	89 e5                	mov    %esp,%ebp
  fb:	83 ec 04             	sub    $0x4,%esp
  fe:	8b 45 0c             	mov    0xc(%ebp),%eax
 101:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 104:	eb 12                	jmp    118 <strchr+0x20>
    if(*s == c)
 106:	8b 45 08             	mov    0x8(%ebp),%eax
 109:	8a 00                	mov    (%eax),%al
 10b:	3a 45 fc             	cmp    -0x4(%ebp),%al
 10e:	75 05                	jne    115 <strchr+0x1d>
      return (char*)s;
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	eb 11                	jmp    126 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 115:	ff 45 08             	incl   0x8(%ebp)
 118:	8b 45 08             	mov    0x8(%ebp),%eax
 11b:	8a 00                	mov    (%eax),%al
 11d:	84 c0                	test   %al,%al
 11f:	75 e5                	jne    106 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 121:	b8 00 00 00 00       	mov    $0x0,%eax
}
 126:	c9                   	leave  
 127:	c3                   	ret    

00000128 <gets>:

char*
gets(char *buf, int max)
{
 128:	55                   	push   %ebp
 129:	89 e5                	mov    %esp,%ebp
 12b:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 12e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 135:	eb 38                	jmp    16f <gets+0x47>
    cc = read(0, &c, 1);
 137:	83 ec 04             	sub    $0x4,%esp
 13a:	6a 01                	push   $0x1
 13c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 13f:	50                   	push   %eax
 140:	6a 00                	push   $0x0
 142:	e8 31 01 00 00       	call   278 <read>
 147:	83 c4 10             	add    $0x10,%esp
 14a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 14d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 151:	7e 27                	jle    17a <gets+0x52>
      break;
    buf[i++] = c;
 153:	8b 45 f4             	mov    -0xc(%ebp),%eax
 156:	03 45 08             	add    0x8(%ebp),%eax
 159:	8a 55 ef             	mov    -0x11(%ebp),%dl
 15c:	88 10                	mov    %dl,(%eax)
 15e:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 161:	8a 45 ef             	mov    -0x11(%ebp),%al
 164:	3c 0a                	cmp    $0xa,%al
 166:	74 13                	je     17b <gets+0x53>
 168:	8a 45 ef             	mov    -0x11(%ebp),%al
 16b:	3c 0d                	cmp    $0xd,%al
 16d:	74 0c                	je     17b <gets+0x53>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 16f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 172:	40                   	inc    %eax
 173:	3b 45 0c             	cmp    0xc(%ebp),%eax
 176:	7c bf                	jl     137 <gets+0xf>
 178:	eb 01                	jmp    17b <gets+0x53>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 17a:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 17b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 17e:	03 45 08             	add    0x8(%ebp),%eax
 181:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 184:	8b 45 08             	mov    0x8(%ebp),%eax
}
 187:	c9                   	leave  
 188:	c3                   	ret    

00000189 <stat>:

int
stat(char *n, struct stat *st)
{
 189:	55                   	push   %ebp
 18a:	89 e5                	mov    %esp,%ebp
 18c:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 18f:	83 ec 08             	sub    $0x8,%esp
 192:	6a 00                	push   $0x0
 194:	ff 75 08             	pushl  0x8(%ebp)
 197:	e8 04 01 00 00       	call   2a0 <open>
 19c:	83 c4 10             	add    $0x10,%esp
 19f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1a6:	79 07                	jns    1af <stat+0x26>
    return -1;
 1a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1ad:	eb 25                	jmp    1d4 <stat+0x4b>
  r = fstat(fd, st);
 1af:	83 ec 08             	sub    $0x8,%esp
 1b2:	ff 75 0c             	pushl  0xc(%ebp)
 1b5:	ff 75 f4             	pushl  -0xc(%ebp)
 1b8:	e8 fb 00 00 00       	call   2b8 <fstat>
 1bd:	83 c4 10             	add    $0x10,%esp
 1c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1c3:	83 ec 0c             	sub    $0xc,%esp
 1c6:	ff 75 f4             	pushl  -0xc(%ebp)
 1c9:	e8 ba 00 00 00       	call   288 <close>
 1ce:	83 c4 10             	add    $0x10,%esp
  return r;
 1d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1d4:	c9                   	leave  
 1d5:	c3                   	ret    

000001d6 <atoi>:

int
atoi(const char *s)
{
 1d6:	55                   	push   %ebp
 1d7:	89 e5                	mov    %esp,%ebp
 1d9:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1e3:	eb 22                	jmp    207 <atoi+0x31>
    n = n*10 + *s++ - '0';
 1e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1e8:	89 d0                	mov    %edx,%eax
 1ea:	c1 e0 02             	shl    $0x2,%eax
 1ed:	01 d0                	add    %edx,%eax
 1ef:	d1 e0                	shl    %eax
 1f1:	89 c2                	mov    %eax,%edx
 1f3:	8b 45 08             	mov    0x8(%ebp),%eax
 1f6:	8a 00                	mov    (%eax),%al
 1f8:	0f be c0             	movsbl %al,%eax
 1fb:	8d 04 02             	lea    (%edx,%eax,1),%eax
 1fe:	83 e8 30             	sub    $0x30,%eax
 201:	89 45 fc             	mov    %eax,-0x4(%ebp)
 204:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 207:	8b 45 08             	mov    0x8(%ebp),%eax
 20a:	8a 00                	mov    (%eax),%al
 20c:	3c 2f                	cmp    $0x2f,%al
 20e:	7e 09                	jle    219 <atoi+0x43>
 210:	8b 45 08             	mov    0x8(%ebp),%eax
 213:	8a 00                	mov    (%eax),%al
 215:	3c 39                	cmp    $0x39,%al
 217:	7e cc                	jle    1e5 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 219:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 21c:	c9                   	leave  
 21d:	c3                   	ret    

0000021e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 21e:	55                   	push   %ebp
 21f:	89 e5                	mov    %esp,%ebp
 221:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 224:	8b 45 08             	mov    0x8(%ebp),%eax
 227:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 22a:	8b 45 0c             	mov    0xc(%ebp),%eax
 22d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 230:	eb 10                	jmp    242 <memmove+0x24>
    *dst++ = *src++;
 232:	8b 45 f8             	mov    -0x8(%ebp),%eax
 235:	8a 10                	mov    (%eax),%dl
 237:	8b 45 fc             	mov    -0x4(%ebp),%eax
 23a:	88 10                	mov    %dl,(%eax)
 23c:	ff 45 fc             	incl   -0x4(%ebp)
 23f:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 242:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 246:	0f 9f c0             	setg   %al
 249:	ff 4d 10             	decl   0x10(%ebp)
 24c:	84 c0                	test   %al,%al
 24e:	75 e2                	jne    232 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 250:	8b 45 08             	mov    0x8(%ebp),%eax
}
 253:	c9                   	leave  
 254:	c3                   	ret    
 255:	90                   	nop
 256:	90                   	nop
 257:	90                   	nop

00000258 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 258:	b8 01 00 00 00       	mov    $0x1,%eax
 25d:	cd 40                	int    $0x40
 25f:	c3                   	ret    

00000260 <exit>:
SYSCALL(exit)
 260:	b8 02 00 00 00       	mov    $0x2,%eax
 265:	cd 40                	int    $0x40
 267:	c3                   	ret    

00000268 <wait>:
SYSCALL(wait)
 268:	b8 03 00 00 00       	mov    $0x3,%eax
 26d:	cd 40                	int    $0x40
 26f:	c3                   	ret    

00000270 <pipe>:
SYSCALL(pipe)
 270:	b8 04 00 00 00       	mov    $0x4,%eax
 275:	cd 40                	int    $0x40
 277:	c3                   	ret    

00000278 <read>:
SYSCALL(read)
 278:	b8 05 00 00 00       	mov    $0x5,%eax
 27d:	cd 40                	int    $0x40
 27f:	c3                   	ret    

00000280 <write>:
SYSCALL(write)
 280:	b8 10 00 00 00       	mov    $0x10,%eax
 285:	cd 40                	int    $0x40
 287:	c3                   	ret    

00000288 <close>:
SYSCALL(close)
 288:	b8 15 00 00 00       	mov    $0x15,%eax
 28d:	cd 40                	int    $0x40
 28f:	c3                   	ret    

00000290 <kill>:
SYSCALL(kill)
 290:	b8 06 00 00 00       	mov    $0x6,%eax
 295:	cd 40                	int    $0x40
 297:	c3                   	ret    

00000298 <exec>:
SYSCALL(exec)
 298:	b8 07 00 00 00       	mov    $0x7,%eax
 29d:	cd 40                	int    $0x40
 29f:	c3                   	ret    

000002a0 <open>:
SYSCALL(open)
 2a0:	b8 0f 00 00 00       	mov    $0xf,%eax
 2a5:	cd 40                	int    $0x40
 2a7:	c3                   	ret    

000002a8 <mknod>:
SYSCALL(mknod)
 2a8:	b8 11 00 00 00       	mov    $0x11,%eax
 2ad:	cd 40                	int    $0x40
 2af:	c3                   	ret    

000002b0 <unlink>:
SYSCALL(unlink)
 2b0:	b8 12 00 00 00       	mov    $0x12,%eax
 2b5:	cd 40                	int    $0x40
 2b7:	c3                   	ret    

000002b8 <fstat>:
SYSCALL(fstat)
 2b8:	b8 08 00 00 00       	mov    $0x8,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <link>:
SYSCALL(link)
 2c0:	b8 13 00 00 00       	mov    $0x13,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <mkdir>:
SYSCALL(mkdir)
 2c8:	b8 14 00 00 00       	mov    $0x14,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <chdir>:
SYSCALL(chdir)
 2d0:	b8 09 00 00 00       	mov    $0x9,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <dup>:
SYSCALL(dup)
 2d8:	b8 0a 00 00 00       	mov    $0xa,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <getpid>:
SYSCALL(getpid)
 2e0:	b8 0b 00 00 00       	mov    $0xb,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <sbrk>:
SYSCALL(sbrk)
 2e8:	b8 0c 00 00 00       	mov    $0xc,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <sleep>:
SYSCALL(sleep)
 2f0:	b8 0d 00 00 00       	mov    $0xd,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <uptime>:
SYSCALL(uptime)
 2f8:	b8 0e 00 00 00       	mov    $0xe,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	83 ec 18             	sub    $0x18,%esp
 306:	8b 45 0c             	mov    0xc(%ebp),%eax
 309:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 30c:	83 ec 04             	sub    $0x4,%esp
 30f:	6a 01                	push   $0x1
 311:	8d 45 f4             	lea    -0xc(%ebp),%eax
 314:	50                   	push   %eax
 315:	ff 75 08             	pushl  0x8(%ebp)
 318:	e8 63 ff ff ff       	call   280 <write>
 31d:	83 c4 10             	add    $0x10,%esp
}
 320:	c9                   	leave  
 321:	c3                   	ret    

00000322 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 322:	55                   	push   %ebp
 323:	89 e5                	mov    %esp,%ebp
 325:	83 ec 38             	sub    $0x38,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 328:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 32f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 333:	74 17                	je     34c <printint+0x2a>
 335:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 339:	79 11                	jns    34c <printint+0x2a>
    neg = 1;
 33b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 342:	8b 45 0c             	mov    0xc(%ebp),%eax
 345:	f7 d8                	neg    %eax
 347:	89 45 ec             	mov    %eax,-0x14(%ebp)
 34a:	eb 06                	jmp    352 <printint+0x30>
  } else {
    x = xx;
 34c:	8b 45 0c             	mov    0xc(%ebp),%eax
 34f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 352:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 359:	8b 4d 10             	mov    0x10(%ebp),%ecx
 35c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 35f:	ba 00 00 00 00       	mov    $0x0,%edx
 364:	f7 f1                	div    %ecx
 366:	89 d0                	mov    %edx,%eax
 368:	8a 90 7c 07 00 00    	mov    0x77c(%eax),%dl
 36e:	8d 45 dc             	lea    -0x24(%ebp),%eax
 371:	03 45 f4             	add    -0xc(%ebp),%eax
 374:	88 10                	mov    %dl,(%eax)
 376:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 379:	8b 45 10             	mov    0x10(%ebp),%eax
 37c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 37f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 382:	ba 00 00 00 00       	mov    $0x0,%edx
 387:	f7 75 d4             	divl   -0x2c(%ebp)
 38a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 38d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 391:	75 c6                	jne    359 <printint+0x37>
  if(neg)
 393:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 397:	74 28                	je     3c1 <printint+0x9f>
    buf[i++] = '-';
 399:	8d 45 dc             	lea    -0x24(%ebp),%eax
 39c:	03 45 f4             	add    -0xc(%ebp),%eax
 39f:	c6 00 2d             	movb   $0x2d,(%eax)
 3a2:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 3a5:	eb 1a                	jmp    3c1 <printint+0x9f>
    putc(fd, buf[i]);
 3a7:	8d 45 dc             	lea    -0x24(%ebp),%eax
 3aa:	03 45 f4             	add    -0xc(%ebp),%eax
 3ad:	8a 00                	mov    (%eax),%al
 3af:	0f be c0             	movsbl %al,%eax
 3b2:	83 ec 08             	sub    $0x8,%esp
 3b5:	50                   	push   %eax
 3b6:	ff 75 08             	pushl  0x8(%ebp)
 3b9:	e8 42 ff ff ff       	call   300 <putc>
 3be:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3c1:	ff 4d f4             	decl   -0xc(%ebp)
 3c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3c8:	79 dd                	jns    3a7 <printint+0x85>
    putc(fd, buf[i]);
}
 3ca:	c9                   	leave  
 3cb:	c3                   	ret    

000003cc <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3cc:	55                   	push   %ebp
 3cd:	89 e5                	mov    %esp,%ebp
 3cf:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 3d2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 3d9:	8d 45 0c             	lea    0xc(%ebp),%eax
 3dc:	83 c0 04             	add    $0x4,%eax
 3df:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 3e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 3e9:	e9 58 01 00 00       	jmp    546 <printf+0x17a>
    c = fmt[i] & 0xff;
 3ee:	8b 55 0c             	mov    0xc(%ebp),%edx
 3f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 3f4:	8d 04 02             	lea    (%edx,%eax,1),%eax
 3f7:	8a 00                	mov    (%eax),%al
 3f9:	0f be c0             	movsbl %al,%eax
 3fc:	25 ff 00 00 00       	and    $0xff,%eax
 401:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 404:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 408:	75 2c                	jne    436 <printf+0x6a>
      if(c == '%'){
 40a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 40e:	75 0c                	jne    41c <printf+0x50>
        state = '%';
 410:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 417:	e9 27 01 00 00       	jmp    543 <printf+0x177>
      } else {
        putc(fd, c);
 41c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 41f:	0f be c0             	movsbl %al,%eax
 422:	83 ec 08             	sub    $0x8,%esp
 425:	50                   	push   %eax
 426:	ff 75 08             	pushl  0x8(%ebp)
 429:	e8 d2 fe ff ff       	call   300 <putc>
 42e:	83 c4 10             	add    $0x10,%esp
 431:	e9 0d 01 00 00       	jmp    543 <printf+0x177>
      }
    } else if(state == '%'){
 436:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 43a:	0f 85 03 01 00 00    	jne    543 <printf+0x177>
      if(c == 'd'){
 440:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 444:	75 1e                	jne    464 <printf+0x98>
        printint(fd, *ap, 10, 1);
 446:	8b 45 e8             	mov    -0x18(%ebp),%eax
 449:	8b 00                	mov    (%eax),%eax
 44b:	6a 01                	push   $0x1
 44d:	6a 0a                	push   $0xa
 44f:	50                   	push   %eax
 450:	ff 75 08             	pushl  0x8(%ebp)
 453:	e8 ca fe ff ff       	call   322 <printint>
 458:	83 c4 10             	add    $0x10,%esp
        ap++;
 45b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 45f:	e9 d8 00 00 00       	jmp    53c <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 464:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 468:	74 06                	je     470 <printf+0xa4>
 46a:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 46e:	75 1e                	jne    48e <printf+0xc2>
        printint(fd, *ap, 16, 0);
 470:	8b 45 e8             	mov    -0x18(%ebp),%eax
 473:	8b 00                	mov    (%eax),%eax
 475:	6a 00                	push   $0x0
 477:	6a 10                	push   $0x10
 479:	50                   	push   %eax
 47a:	ff 75 08             	pushl  0x8(%ebp)
 47d:	e8 a0 fe ff ff       	call   322 <printint>
 482:	83 c4 10             	add    $0x10,%esp
        ap++;
 485:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 489:	e9 ae 00 00 00       	jmp    53c <printf+0x170>
      } else if(c == 's'){
 48e:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 492:	75 43                	jne    4d7 <printf+0x10b>
        s = (char*)*ap;
 494:	8b 45 e8             	mov    -0x18(%ebp),%eax
 497:	8b 00                	mov    (%eax),%eax
 499:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 49c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 4a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4a4:	75 25                	jne    4cb <printf+0xff>
          s = "(null)";
 4a6:	c7 45 f4 74 07 00 00 	movl   $0x774,-0xc(%ebp)
        while(*s != 0){
 4ad:	eb 1d                	jmp    4cc <printf+0x100>
          putc(fd, *s);
 4af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4b2:	8a 00                	mov    (%eax),%al
 4b4:	0f be c0             	movsbl %al,%eax
 4b7:	83 ec 08             	sub    $0x8,%esp
 4ba:	50                   	push   %eax
 4bb:	ff 75 08             	pushl  0x8(%ebp)
 4be:	e8 3d fe ff ff       	call   300 <putc>
 4c3:	83 c4 10             	add    $0x10,%esp
          s++;
 4c6:	ff 45 f4             	incl   -0xc(%ebp)
 4c9:	eb 01                	jmp    4cc <printf+0x100>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 4cb:	90                   	nop
 4cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4cf:	8a 00                	mov    (%eax),%al
 4d1:	84 c0                	test   %al,%al
 4d3:	75 da                	jne    4af <printf+0xe3>
 4d5:	eb 65                	jmp    53c <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4d7:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 4db:	75 1d                	jne    4fa <printf+0x12e>
        putc(fd, *ap);
 4dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4e0:	8b 00                	mov    (%eax),%eax
 4e2:	0f be c0             	movsbl %al,%eax
 4e5:	83 ec 08             	sub    $0x8,%esp
 4e8:	50                   	push   %eax
 4e9:	ff 75 08             	pushl  0x8(%ebp)
 4ec:	e8 0f fe ff ff       	call   300 <putc>
 4f1:	83 c4 10             	add    $0x10,%esp
        ap++;
 4f4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4f8:	eb 42                	jmp    53c <printf+0x170>
      } else if(c == '%'){
 4fa:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4fe:	75 17                	jne    517 <printf+0x14b>
        putc(fd, c);
 500:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 503:	0f be c0             	movsbl %al,%eax
 506:	83 ec 08             	sub    $0x8,%esp
 509:	50                   	push   %eax
 50a:	ff 75 08             	pushl  0x8(%ebp)
 50d:	e8 ee fd ff ff       	call   300 <putc>
 512:	83 c4 10             	add    $0x10,%esp
 515:	eb 25                	jmp    53c <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 517:	83 ec 08             	sub    $0x8,%esp
 51a:	6a 25                	push   $0x25
 51c:	ff 75 08             	pushl  0x8(%ebp)
 51f:	e8 dc fd ff ff       	call   300 <putc>
 524:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 527:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 52a:	0f be c0             	movsbl %al,%eax
 52d:	83 ec 08             	sub    $0x8,%esp
 530:	50                   	push   %eax
 531:	ff 75 08             	pushl  0x8(%ebp)
 534:	e8 c7 fd ff ff       	call   300 <putc>
 539:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 53c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 543:	ff 45 f0             	incl   -0x10(%ebp)
 546:	8b 55 0c             	mov    0xc(%ebp),%edx
 549:	8b 45 f0             	mov    -0x10(%ebp),%eax
 54c:	8d 04 02             	lea    (%edx,%eax,1),%eax
 54f:	8a 00                	mov    (%eax),%al
 551:	84 c0                	test   %al,%al
 553:	0f 85 95 fe ff ff    	jne    3ee <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 559:	c9                   	leave  
 55a:	c3                   	ret    
 55b:	90                   	nop

0000055c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 55c:	55                   	push   %ebp
 55d:	89 e5                	mov    %esp,%ebp
 55f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 562:	8b 45 08             	mov    0x8(%ebp),%eax
 565:	83 e8 08             	sub    $0x8,%eax
 568:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 56b:	a1 98 07 00 00       	mov    0x798,%eax
 570:	89 45 fc             	mov    %eax,-0x4(%ebp)
 573:	eb 24                	jmp    599 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 575:	8b 45 fc             	mov    -0x4(%ebp),%eax
 578:	8b 00                	mov    (%eax),%eax
 57a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 57d:	77 12                	ja     591 <free+0x35>
 57f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 582:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 585:	77 24                	ja     5ab <free+0x4f>
 587:	8b 45 fc             	mov    -0x4(%ebp),%eax
 58a:	8b 00                	mov    (%eax),%eax
 58c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 58f:	77 1a                	ja     5ab <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 591:	8b 45 fc             	mov    -0x4(%ebp),%eax
 594:	8b 00                	mov    (%eax),%eax
 596:	89 45 fc             	mov    %eax,-0x4(%ebp)
 599:	8b 45 f8             	mov    -0x8(%ebp),%eax
 59c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 59f:	76 d4                	jbe    575 <free+0x19>
 5a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5a4:	8b 00                	mov    (%eax),%eax
 5a6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5a9:	76 ca                	jbe    575 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 5ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5ae:	8b 40 04             	mov    0x4(%eax),%eax
 5b1:	c1 e0 03             	shl    $0x3,%eax
 5b4:	89 c2                	mov    %eax,%edx
 5b6:	03 55 f8             	add    -0x8(%ebp),%edx
 5b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5bc:	8b 00                	mov    (%eax),%eax
 5be:	39 c2                	cmp    %eax,%edx
 5c0:	75 24                	jne    5e6 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 5c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5c5:	8b 50 04             	mov    0x4(%eax),%edx
 5c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5cb:	8b 00                	mov    (%eax),%eax
 5cd:	8b 40 04             	mov    0x4(%eax),%eax
 5d0:	01 c2                	add    %eax,%edx
 5d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5d5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 5d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5db:	8b 00                	mov    (%eax),%eax
 5dd:	8b 10                	mov    (%eax),%edx
 5df:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5e2:	89 10                	mov    %edx,(%eax)
 5e4:	eb 0a                	jmp    5f0 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 5e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5e9:	8b 10                	mov    (%eax),%edx
 5eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5ee:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 5f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f3:	8b 40 04             	mov    0x4(%eax),%eax
 5f6:	c1 e0 03             	shl    $0x3,%eax
 5f9:	03 45 fc             	add    -0x4(%ebp),%eax
 5fc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5ff:	75 20                	jne    621 <free+0xc5>
    p->s.size += bp->s.size;
 601:	8b 45 fc             	mov    -0x4(%ebp),%eax
 604:	8b 50 04             	mov    0x4(%eax),%edx
 607:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60a:	8b 40 04             	mov    0x4(%eax),%eax
 60d:	01 c2                	add    %eax,%edx
 60f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 612:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 615:	8b 45 f8             	mov    -0x8(%ebp),%eax
 618:	8b 10                	mov    (%eax),%edx
 61a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61d:	89 10                	mov    %edx,(%eax)
 61f:	eb 08                	jmp    629 <free+0xcd>
  } else
    p->s.ptr = bp;
 621:	8b 45 fc             	mov    -0x4(%ebp),%eax
 624:	8b 55 f8             	mov    -0x8(%ebp),%edx
 627:	89 10                	mov    %edx,(%eax)
  freep = p;
 629:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62c:	a3 98 07 00 00       	mov    %eax,0x798
}
 631:	c9                   	leave  
 632:	c3                   	ret    

00000633 <morecore>:

static Header*
morecore(uint nu)
{
 633:	55                   	push   %ebp
 634:	89 e5                	mov    %esp,%ebp
 636:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 639:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 640:	77 07                	ja     649 <morecore+0x16>
    nu = 4096;
 642:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 649:	8b 45 08             	mov    0x8(%ebp),%eax
 64c:	c1 e0 03             	shl    $0x3,%eax
 64f:	83 ec 0c             	sub    $0xc,%esp
 652:	50                   	push   %eax
 653:	e8 90 fc ff ff       	call   2e8 <sbrk>
 658:	83 c4 10             	add    $0x10,%esp
 65b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 65e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 662:	75 07                	jne    66b <morecore+0x38>
    return 0;
 664:	b8 00 00 00 00       	mov    $0x0,%eax
 669:	eb 26                	jmp    691 <morecore+0x5e>
  hp = (Header*)p;
 66b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 66e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 671:	8b 45 f0             	mov    -0x10(%ebp),%eax
 674:	8b 55 08             	mov    0x8(%ebp),%edx
 677:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 67a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 67d:	83 c0 08             	add    $0x8,%eax
 680:	83 ec 0c             	sub    $0xc,%esp
 683:	50                   	push   %eax
 684:	e8 d3 fe ff ff       	call   55c <free>
 689:	83 c4 10             	add    $0x10,%esp
  return freep;
 68c:	a1 98 07 00 00       	mov    0x798,%eax
}
 691:	c9                   	leave  
 692:	c3                   	ret    

00000693 <malloc>:

void*
malloc(uint nbytes)
{
 693:	55                   	push   %ebp
 694:	89 e5                	mov    %esp,%ebp
 696:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 699:	8b 45 08             	mov    0x8(%ebp),%eax
 69c:	83 c0 07             	add    $0x7,%eax
 69f:	c1 e8 03             	shr    $0x3,%eax
 6a2:	40                   	inc    %eax
 6a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 6a6:	a1 98 07 00 00       	mov    0x798,%eax
 6ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
 6ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6b2:	75 23                	jne    6d7 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 6b4:	c7 45 f0 90 07 00 00 	movl   $0x790,-0x10(%ebp)
 6bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6be:	a3 98 07 00 00       	mov    %eax,0x798
 6c3:	a1 98 07 00 00       	mov    0x798,%eax
 6c8:	a3 90 07 00 00       	mov    %eax,0x790
    base.s.size = 0;
 6cd:	c7 05 94 07 00 00 00 	movl   $0x0,0x794
 6d4:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6da:	8b 00                	mov    (%eax),%eax
 6dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 6df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e2:	8b 40 04             	mov    0x4(%eax),%eax
 6e5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 6e8:	72 4d                	jb     737 <malloc+0xa4>
      if(p->s.size == nunits)
 6ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ed:	8b 40 04             	mov    0x4(%eax),%eax
 6f0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 6f3:	75 0c                	jne    701 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 6f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f8:	8b 10                	mov    (%eax),%edx
 6fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6fd:	89 10                	mov    %edx,(%eax)
 6ff:	eb 26                	jmp    727 <malloc+0x94>
      else {
        p->s.size -= nunits;
 701:	8b 45 f4             	mov    -0xc(%ebp),%eax
 704:	8b 40 04             	mov    0x4(%eax),%eax
 707:	89 c2                	mov    %eax,%edx
 709:	2b 55 ec             	sub    -0x14(%ebp),%edx
 70c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 70f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 712:	8b 45 f4             	mov    -0xc(%ebp),%eax
 715:	8b 40 04             	mov    0x4(%eax),%eax
 718:	c1 e0 03             	shl    $0x3,%eax
 71b:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 71e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 721:	8b 55 ec             	mov    -0x14(%ebp),%edx
 724:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 727:	8b 45 f0             	mov    -0x10(%ebp),%eax
 72a:	a3 98 07 00 00       	mov    %eax,0x798
      return (void*)(p + 1);
 72f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 732:	83 c0 08             	add    $0x8,%eax
 735:	eb 3b                	jmp    772 <malloc+0xdf>
    }
    if(p == freep)
 737:	a1 98 07 00 00       	mov    0x798,%eax
 73c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 73f:	75 1e                	jne    75f <malloc+0xcc>
      if((p = morecore(nunits)) == 0)
 741:	83 ec 0c             	sub    $0xc,%esp
 744:	ff 75 ec             	pushl  -0x14(%ebp)
 747:	e8 e7 fe ff ff       	call   633 <morecore>
 74c:	83 c4 10             	add    $0x10,%esp
 74f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 752:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 756:	75 07                	jne    75f <malloc+0xcc>
        return 0;
 758:	b8 00 00 00 00       	mov    $0x0,%eax
 75d:	eb 13                	jmp    772 <malloc+0xdf>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 75f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 762:	89 45 f0             	mov    %eax,-0x10(%ebp)
 765:	8b 45 f4             	mov    -0xc(%ebp),%eax
 768:	8b 00                	mov    (%eax),%eax
 76a:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 76d:	e9 6d ff ff ff       	jmp    6df <malloc+0x4c>
}
 772:	c9                   	leave  
 773:	c3                   	ret    
