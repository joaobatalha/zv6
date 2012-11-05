
_echo:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
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

  for(i = 1; i < argc; i++)
  14:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  1b:	eb 33                	jmp    50 <main+0x50>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  20:	40                   	inc    %eax
  21:	3b 03                	cmp    (%ebx),%eax
  23:	7d 07                	jge    2c <main+0x2c>
  25:	b8 a4 07 00 00       	mov    $0x7a4,%eax
  2a:	eb 05                	jmp    31 <main+0x31>
  2c:	b8 a6 07 00 00       	mov    $0x7a6,%eax
  31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  34:	c1 e2 02             	shl    $0x2,%edx
  37:	03 53 04             	add    0x4(%ebx),%edx
  3a:	8b 12                	mov    (%edx),%edx
  3c:	50                   	push   %eax
  3d:	52                   	push   %edx
  3e:	68 a8 07 00 00       	push   $0x7a8
  43:	6a 01                	push   $0x1
  45:	e8 b2 03 00 00       	call   3fc <printf>
  4a:	83 c4 10             	add    $0x10,%esp
int
main(int argc, char *argv[])
{
  int i;

  for(i = 1; i < argc; i++)
  4d:	ff 45 f4             	incl   -0xc(%ebp)
  50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  53:	3b 03                	cmp    (%ebx),%eax
  55:	7c c6                	jl     1d <main+0x1d>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  exit();
  57:	e8 34 02 00 00       	call   290 <exit>

0000005c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  5c:	55                   	push   %ebp
  5d:	89 e5                	mov    %esp,%ebp
  5f:	57                   	push   %edi
  60:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  61:	8b 4d 08             	mov    0x8(%ebp),%ecx
  64:	8b 55 10             	mov    0x10(%ebp),%edx
  67:	8b 45 0c             	mov    0xc(%ebp),%eax
  6a:	89 cb                	mov    %ecx,%ebx
  6c:	89 df                	mov    %ebx,%edi
  6e:	89 d1                	mov    %edx,%ecx
  70:	fc                   	cld    
  71:	f3 aa                	rep stos %al,%es:(%edi)
  73:	89 ca                	mov    %ecx,%edx
  75:	89 fb                	mov    %edi,%ebx
  77:	89 5d 08             	mov    %ebx,0x8(%ebp)
  7a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  7d:	5b                   	pop    %ebx
  7e:	5f                   	pop    %edi
  7f:	c9                   	leave  
  80:	c3                   	ret    

00000081 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  81:	55                   	push   %ebp
  82:	89 e5                	mov    %esp,%ebp
  84:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  87:	8b 45 08             	mov    0x8(%ebp),%eax
  8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  8d:	90                   	nop
  8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  91:	8a 10                	mov    (%eax),%dl
  93:	8b 45 08             	mov    0x8(%ebp),%eax
  96:	88 10                	mov    %dl,(%eax)
  98:	8b 45 08             	mov    0x8(%ebp),%eax
  9b:	8a 00                	mov    (%eax),%al
  9d:	84 c0                	test   %al,%al
  9f:	0f 95 c0             	setne  %al
  a2:	ff 45 08             	incl   0x8(%ebp)
  a5:	ff 45 0c             	incl   0xc(%ebp)
  a8:	84 c0                	test   %al,%al
  aa:	75 e2                	jne    8e <strcpy+0xd>
    ;
  return os;
  ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  af:	c9                   	leave  
  b0:	c3                   	ret    

000000b1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b1:	55                   	push   %ebp
  b2:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  b4:	eb 06                	jmp    bc <strcmp+0xb>
    p++, q++;
  b6:	ff 45 08             	incl   0x8(%ebp)
  b9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  bc:	8b 45 08             	mov    0x8(%ebp),%eax
  bf:	8a 00                	mov    (%eax),%al
  c1:	84 c0                	test   %al,%al
  c3:	74 0e                	je     d3 <strcmp+0x22>
  c5:	8b 45 08             	mov    0x8(%ebp),%eax
  c8:	8a 10                	mov    (%eax),%dl
  ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  cd:	8a 00                	mov    (%eax),%al
  cf:	38 c2                	cmp    %al,%dl
  d1:	74 e3                	je     b6 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  d3:	8b 45 08             	mov    0x8(%ebp),%eax
  d6:	8a 00                	mov    (%eax),%al
  d8:	0f b6 d0             	movzbl %al,%edx
  db:	8b 45 0c             	mov    0xc(%ebp),%eax
  de:	8a 00                	mov    (%eax),%al
  e0:	0f b6 c0             	movzbl %al,%eax
  e3:	89 d1                	mov    %edx,%ecx
  e5:	29 c1                	sub    %eax,%ecx
  e7:	89 c8                	mov    %ecx,%eax
}
  e9:	c9                   	leave  
  ea:	c3                   	ret    

000000eb <strlen>:

uint
strlen(char *s)
{
  eb:	55                   	push   %ebp
  ec:	89 e5                	mov    %esp,%ebp
  ee:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  f8:	eb 03                	jmp    fd <strlen+0x12>
  fa:	ff 45 fc             	incl   -0x4(%ebp)
  fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 100:	03 45 08             	add    0x8(%ebp),%eax
 103:	8a 00                	mov    (%eax),%al
 105:	84 c0                	test   %al,%al
 107:	75 f1                	jne    fa <strlen+0xf>
    ;
  return n;
 109:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 10c:	c9                   	leave  
 10d:	c3                   	ret    

0000010e <memset>:

void*
memset(void *dst, int c, uint n)
{
 10e:	55                   	push   %ebp
 10f:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 111:	8b 45 10             	mov    0x10(%ebp),%eax
 114:	50                   	push   %eax
 115:	ff 75 0c             	pushl  0xc(%ebp)
 118:	ff 75 08             	pushl  0x8(%ebp)
 11b:	e8 3c ff ff ff       	call   5c <stosb>
 120:	83 c4 0c             	add    $0xc,%esp
  return dst;
 123:	8b 45 08             	mov    0x8(%ebp),%eax
}
 126:	c9                   	leave  
 127:	c3                   	ret    

00000128 <strchr>:

char*
strchr(const char *s, char c)
{
 128:	55                   	push   %ebp
 129:	89 e5                	mov    %esp,%ebp
 12b:	83 ec 04             	sub    $0x4,%esp
 12e:	8b 45 0c             	mov    0xc(%ebp),%eax
 131:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 134:	eb 12                	jmp    148 <strchr+0x20>
    if(*s == c)
 136:	8b 45 08             	mov    0x8(%ebp),%eax
 139:	8a 00                	mov    (%eax),%al
 13b:	3a 45 fc             	cmp    -0x4(%ebp),%al
 13e:	75 05                	jne    145 <strchr+0x1d>
      return (char*)s;
 140:	8b 45 08             	mov    0x8(%ebp),%eax
 143:	eb 11                	jmp    156 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 145:	ff 45 08             	incl   0x8(%ebp)
 148:	8b 45 08             	mov    0x8(%ebp),%eax
 14b:	8a 00                	mov    (%eax),%al
 14d:	84 c0                	test   %al,%al
 14f:	75 e5                	jne    136 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 151:	b8 00 00 00 00       	mov    $0x0,%eax
}
 156:	c9                   	leave  
 157:	c3                   	ret    

00000158 <gets>:

char*
gets(char *buf, int max)
{
 158:	55                   	push   %ebp
 159:	89 e5                	mov    %esp,%ebp
 15b:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 15e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 165:	eb 38                	jmp    19f <gets+0x47>
    cc = read(0, &c, 1);
 167:	83 ec 04             	sub    $0x4,%esp
 16a:	6a 01                	push   $0x1
 16c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 16f:	50                   	push   %eax
 170:	6a 00                	push   $0x0
 172:	e8 31 01 00 00       	call   2a8 <read>
 177:	83 c4 10             	add    $0x10,%esp
 17a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 17d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 181:	7e 27                	jle    1aa <gets+0x52>
      break;
    buf[i++] = c;
 183:	8b 45 f4             	mov    -0xc(%ebp),%eax
 186:	03 45 08             	add    0x8(%ebp),%eax
 189:	8a 55 ef             	mov    -0x11(%ebp),%dl
 18c:	88 10                	mov    %dl,(%eax)
 18e:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 191:	8a 45 ef             	mov    -0x11(%ebp),%al
 194:	3c 0a                	cmp    $0xa,%al
 196:	74 13                	je     1ab <gets+0x53>
 198:	8a 45 ef             	mov    -0x11(%ebp),%al
 19b:	3c 0d                	cmp    $0xd,%al
 19d:	74 0c                	je     1ab <gets+0x53>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1a2:	40                   	inc    %eax
 1a3:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1a6:	7c bf                	jl     167 <gets+0xf>
 1a8:	eb 01                	jmp    1ab <gets+0x53>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1aa:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ae:	03 45 08             	add    0x8(%ebp),%eax
 1b1:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1b4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1b7:	c9                   	leave  
 1b8:	c3                   	ret    

000001b9 <stat>:

int
stat(char *n, struct stat *st)
{
 1b9:	55                   	push   %ebp
 1ba:	89 e5                	mov    %esp,%ebp
 1bc:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1bf:	83 ec 08             	sub    $0x8,%esp
 1c2:	6a 00                	push   $0x0
 1c4:	ff 75 08             	pushl  0x8(%ebp)
 1c7:	e8 04 01 00 00       	call   2d0 <open>
 1cc:	83 c4 10             	add    $0x10,%esp
 1cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1d6:	79 07                	jns    1df <stat+0x26>
    return -1;
 1d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1dd:	eb 25                	jmp    204 <stat+0x4b>
  r = fstat(fd, st);
 1df:	83 ec 08             	sub    $0x8,%esp
 1e2:	ff 75 0c             	pushl  0xc(%ebp)
 1e5:	ff 75 f4             	pushl  -0xc(%ebp)
 1e8:	e8 fb 00 00 00       	call   2e8 <fstat>
 1ed:	83 c4 10             	add    $0x10,%esp
 1f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1f3:	83 ec 0c             	sub    $0xc,%esp
 1f6:	ff 75 f4             	pushl  -0xc(%ebp)
 1f9:	e8 ba 00 00 00       	call   2b8 <close>
 1fe:	83 c4 10             	add    $0x10,%esp
  return r;
 201:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 204:	c9                   	leave  
 205:	c3                   	ret    

00000206 <atoi>:

int
atoi(const char *s)
{
 206:	55                   	push   %ebp
 207:	89 e5                	mov    %esp,%ebp
 209:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 20c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 213:	eb 22                	jmp    237 <atoi+0x31>
    n = n*10 + *s++ - '0';
 215:	8b 55 fc             	mov    -0x4(%ebp),%edx
 218:	89 d0                	mov    %edx,%eax
 21a:	c1 e0 02             	shl    $0x2,%eax
 21d:	01 d0                	add    %edx,%eax
 21f:	d1 e0                	shl    %eax
 221:	89 c2                	mov    %eax,%edx
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	8a 00                	mov    (%eax),%al
 228:	0f be c0             	movsbl %al,%eax
 22b:	8d 04 02             	lea    (%edx,%eax,1),%eax
 22e:	83 e8 30             	sub    $0x30,%eax
 231:	89 45 fc             	mov    %eax,-0x4(%ebp)
 234:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 237:	8b 45 08             	mov    0x8(%ebp),%eax
 23a:	8a 00                	mov    (%eax),%al
 23c:	3c 2f                	cmp    $0x2f,%al
 23e:	7e 09                	jle    249 <atoi+0x43>
 240:	8b 45 08             	mov    0x8(%ebp),%eax
 243:	8a 00                	mov    (%eax),%al
 245:	3c 39                	cmp    $0x39,%al
 247:	7e cc                	jle    215 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 249:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 24c:	c9                   	leave  
 24d:	c3                   	ret    

0000024e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 24e:	55                   	push   %ebp
 24f:	89 e5                	mov    %esp,%ebp
 251:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 254:	8b 45 08             	mov    0x8(%ebp),%eax
 257:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 25a:	8b 45 0c             	mov    0xc(%ebp),%eax
 25d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 260:	eb 10                	jmp    272 <memmove+0x24>
    *dst++ = *src++;
 262:	8b 45 f8             	mov    -0x8(%ebp),%eax
 265:	8a 10                	mov    (%eax),%dl
 267:	8b 45 fc             	mov    -0x4(%ebp),%eax
 26a:	88 10                	mov    %dl,(%eax)
 26c:	ff 45 fc             	incl   -0x4(%ebp)
 26f:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 272:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 276:	0f 9f c0             	setg   %al
 279:	ff 4d 10             	decl   0x10(%ebp)
 27c:	84 c0                	test   %al,%al
 27e:	75 e2                	jne    262 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 280:	8b 45 08             	mov    0x8(%ebp),%eax
}
 283:	c9                   	leave  
 284:	c3                   	ret    
 285:	90                   	nop
 286:	90                   	nop
 287:	90                   	nop

00000288 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 288:	b8 01 00 00 00       	mov    $0x1,%eax
 28d:	cd 40                	int    $0x40
 28f:	c3                   	ret    

00000290 <exit>:
SYSCALL(exit)
 290:	b8 02 00 00 00       	mov    $0x2,%eax
 295:	cd 40                	int    $0x40
 297:	c3                   	ret    

00000298 <wait>:
SYSCALL(wait)
 298:	b8 03 00 00 00       	mov    $0x3,%eax
 29d:	cd 40                	int    $0x40
 29f:	c3                   	ret    

000002a0 <pipe>:
SYSCALL(pipe)
 2a0:	b8 04 00 00 00       	mov    $0x4,%eax
 2a5:	cd 40                	int    $0x40
 2a7:	c3                   	ret    

000002a8 <read>:
SYSCALL(read)
 2a8:	b8 05 00 00 00       	mov    $0x5,%eax
 2ad:	cd 40                	int    $0x40
 2af:	c3                   	ret    

000002b0 <write>:
SYSCALL(write)
 2b0:	b8 10 00 00 00       	mov    $0x10,%eax
 2b5:	cd 40                	int    $0x40
 2b7:	c3                   	ret    

000002b8 <close>:
SYSCALL(close)
 2b8:	b8 15 00 00 00       	mov    $0x15,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <kill>:
SYSCALL(kill)
 2c0:	b8 06 00 00 00       	mov    $0x6,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <exec>:
SYSCALL(exec)
 2c8:	b8 07 00 00 00       	mov    $0x7,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <open>:
SYSCALL(open)
 2d0:	b8 0f 00 00 00       	mov    $0xf,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <mknod>:
SYSCALL(mknod)
 2d8:	b8 11 00 00 00       	mov    $0x11,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <unlink>:
SYSCALL(unlink)
 2e0:	b8 12 00 00 00       	mov    $0x12,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <fstat>:
SYSCALL(fstat)
 2e8:	b8 08 00 00 00       	mov    $0x8,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <link>:
SYSCALL(link)
 2f0:	b8 13 00 00 00       	mov    $0x13,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <mkdir>:
SYSCALL(mkdir)
 2f8:	b8 14 00 00 00       	mov    $0x14,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <chdir>:
SYSCALL(chdir)
 300:	b8 09 00 00 00       	mov    $0x9,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <dup>:
SYSCALL(dup)
 308:	b8 0a 00 00 00       	mov    $0xa,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <getpid>:
SYSCALL(getpid)
 310:	b8 0b 00 00 00       	mov    $0xb,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <sbrk>:
SYSCALL(sbrk)
 318:	b8 0c 00 00 00       	mov    $0xc,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <sleep>:
SYSCALL(sleep)
 320:	b8 0d 00 00 00       	mov    $0xd,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <uptime>:
SYSCALL(uptime)
 328:	b8 0e 00 00 00       	mov    $0xe,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	83 ec 18             	sub    $0x18,%esp
 336:	8b 45 0c             	mov    0xc(%ebp),%eax
 339:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 33c:	83 ec 04             	sub    $0x4,%esp
 33f:	6a 01                	push   $0x1
 341:	8d 45 f4             	lea    -0xc(%ebp),%eax
 344:	50                   	push   %eax
 345:	ff 75 08             	pushl  0x8(%ebp)
 348:	e8 63 ff ff ff       	call   2b0 <write>
 34d:	83 c4 10             	add    $0x10,%esp
}
 350:	c9                   	leave  
 351:	c3                   	ret    

00000352 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 352:	55                   	push   %ebp
 353:	89 e5                	mov    %esp,%ebp
 355:	83 ec 38             	sub    $0x38,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 358:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 35f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 363:	74 17                	je     37c <printint+0x2a>
 365:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 369:	79 11                	jns    37c <printint+0x2a>
    neg = 1;
 36b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 372:	8b 45 0c             	mov    0xc(%ebp),%eax
 375:	f7 d8                	neg    %eax
 377:	89 45 ec             	mov    %eax,-0x14(%ebp)
 37a:	eb 06                	jmp    382 <printint+0x30>
  } else {
    x = xx;
 37c:	8b 45 0c             	mov    0xc(%ebp),%eax
 37f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 382:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 389:	8b 4d 10             	mov    0x10(%ebp),%ecx
 38c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 38f:	ba 00 00 00 00       	mov    $0x0,%edx
 394:	f7 f1                	div    %ecx
 396:	89 d0                	mov    %edx,%eax
 398:	8a 90 b4 07 00 00    	mov    0x7b4(%eax),%dl
 39e:	8d 45 dc             	lea    -0x24(%ebp),%eax
 3a1:	03 45 f4             	add    -0xc(%ebp),%eax
 3a4:	88 10                	mov    %dl,(%eax)
 3a6:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 3a9:	8b 45 10             	mov    0x10(%ebp),%eax
 3ac:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 3af:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3b2:	ba 00 00 00 00       	mov    $0x0,%edx
 3b7:	f7 75 d4             	divl   -0x2c(%ebp)
 3ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3c1:	75 c6                	jne    389 <printint+0x37>
  if(neg)
 3c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3c7:	74 28                	je     3f1 <printint+0x9f>
    buf[i++] = '-';
 3c9:	8d 45 dc             	lea    -0x24(%ebp),%eax
 3cc:	03 45 f4             	add    -0xc(%ebp),%eax
 3cf:	c6 00 2d             	movb   $0x2d,(%eax)
 3d2:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 3d5:	eb 1a                	jmp    3f1 <printint+0x9f>
    putc(fd, buf[i]);
 3d7:	8d 45 dc             	lea    -0x24(%ebp),%eax
 3da:	03 45 f4             	add    -0xc(%ebp),%eax
 3dd:	8a 00                	mov    (%eax),%al
 3df:	0f be c0             	movsbl %al,%eax
 3e2:	83 ec 08             	sub    $0x8,%esp
 3e5:	50                   	push   %eax
 3e6:	ff 75 08             	pushl  0x8(%ebp)
 3e9:	e8 42 ff ff ff       	call   330 <putc>
 3ee:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3f1:	ff 4d f4             	decl   -0xc(%ebp)
 3f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3f8:	79 dd                	jns    3d7 <printint+0x85>
    putc(fd, buf[i]);
}
 3fa:	c9                   	leave  
 3fb:	c3                   	ret    

000003fc <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3fc:	55                   	push   %ebp
 3fd:	89 e5                	mov    %esp,%ebp
 3ff:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 402:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 409:	8d 45 0c             	lea    0xc(%ebp),%eax
 40c:	83 c0 04             	add    $0x4,%eax
 40f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 412:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 419:	e9 58 01 00 00       	jmp    576 <printf+0x17a>
    c = fmt[i] & 0xff;
 41e:	8b 55 0c             	mov    0xc(%ebp),%edx
 421:	8b 45 f0             	mov    -0x10(%ebp),%eax
 424:	8d 04 02             	lea    (%edx,%eax,1),%eax
 427:	8a 00                	mov    (%eax),%al
 429:	0f be c0             	movsbl %al,%eax
 42c:	25 ff 00 00 00       	and    $0xff,%eax
 431:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 434:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 438:	75 2c                	jne    466 <printf+0x6a>
      if(c == '%'){
 43a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 43e:	75 0c                	jne    44c <printf+0x50>
        state = '%';
 440:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 447:	e9 27 01 00 00       	jmp    573 <printf+0x177>
      } else {
        putc(fd, c);
 44c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 44f:	0f be c0             	movsbl %al,%eax
 452:	83 ec 08             	sub    $0x8,%esp
 455:	50                   	push   %eax
 456:	ff 75 08             	pushl  0x8(%ebp)
 459:	e8 d2 fe ff ff       	call   330 <putc>
 45e:	83 c4 10             	add    $0x10,%esp
 461:	e9 0d 01 00 00       	jmp    573 <printf+0x177>
      }
    } else if(state == '%'){
 466:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 46a:	0f 85 03 01 00 00    	jne    573 <printf+0x177>
      if(c == 'd'){
 470:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 474:	75 1e                	jne    494 <printf+0x98>
        printint(fd, *ap, 10, 1);
 476:	8b 45 e8             	mov    -0x18(%ebp),%eax
 479:	8b 00                	mov    (%eax),%eax
 47b:	6a 01                	push   $0x1
 47d:	6a 0a                	push   $0xa
 47f:	50                   	push   %eax
 480:	ff 75 08             	pushl  0x8(%ebp)
 483:	e8 ca fe ff ff       	call   352 <printint>
 488:	83 c4 10             	add    $0x10,%esp
        ap++;
 48b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 48f:	e9 d8 00 00 00       	jmp    56c <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 494:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 498:	74 06                	je     4a0 <printf+0xa4>
 49a:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 49e:	75 1e                	jne    4be <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4a3:	8b 00                	mov    (%eax),%eax
 4a5:	6a 00                	push   $0x0
 4a7:	6a 10                	push   $0x10
 4a9:	50                   	push   %eax
 4aa:	ff 75 08             	pushl  0x8(%ebp)
 4ad:	e8 a0 fe ff ff       	call   352 <printint>
 4b2:	83 c4 10             	add    $0x10,%esp
        ap++;
 4b5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4b9:	e9 ae 00 00 00       	jmp    56c <printf+0x170>
      } else if(c == 's'){
 4be:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4c2:	75 43                	jne    507 <printf+0x10b>
        s = (char*)*ap;
 4c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4c7:	8b 00                	mov    (%eax),%eax
 4c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 4cc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 4d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4d4:	75 25                	jne    4fb <printf+0xff>
          s = "(null)";
 4d6:	c7 45 f4 ad 07 00 00 	movl   $0x7ad,-0xc(%ebp)
        while(*s != 0){
 4dd:	eb 1d                	jmp    4fc <printf+0x100>
          putc(fd, *s);
 4df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e2:	8a 00                	mov    (%eax),%al
 4e4:	0f be c0             	movsbl %al,%eax
 4e7:	83 ec 08             	sub    $0x8,%esp
 4ea:	50                   	push   %eax
 4eb:	ff 75 08             	pushl  0x8(%ebp)
 4ee:	e8 3d fe ff ff       	call   330 <putc>
 4f3:	83 c4 10             	add    $0x10,%esp
          s++;
 4f6:	ff 45 f4             	incl   -0xc(%ebp)
 4f9:	eb 01                	jmp    4fc <printf+0x100>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 4fb:	90                   	nop
 4fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ff:	8a 00                	mov    (%eax),%al
 501:	84 c0                	test   %al,%al
 503:	75 da                	jne    4df <printf+0xe3>
 505:	eb 65                	jmp    56c <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 507:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 50b:	75 1d                	jne    52a <printf+0x12e>
        putc(fd, *ap);
 50d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 510:	8b 00                	mov    (%eax),%eax
 512:	0f be c0             	movsbl %al,%eax
 515:	83 ec 08             	sub    $0x8,%esp
 518:	50                   	push   %eax
 519:	ff 75 08             	pushl  0x8(%ebp)
 51c:	e8 0f fe ff ff       	call   330 <putc>
 521:	83 c4 10             	add    $0x10,%esp
        ap++;
 524:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 528:	eb 42                	jmp    56c <printf+0x170>
      } else if(c == '%'){
 52a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 52e:	75 17                	jne    547 <printf+0x14b>
        putc(fd, c);
 530:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 533:	0f be c0             	movsbl %al,%eax
 536:	83 ec 08             	sub    $0x8,%esp
 539:	50                   	push   %eax
 53a:	ff 75 08             	pushl  0x8(%ebp)
 53d:	e8 ee fd ff ff       	call   330 <putc>
 542:	83 c4 10             	add    $0x10,%esp
 545:	eb 25                	jmp    56c <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 547:	83 ec 08             	sub    $0x8,%esp
 54a:	6a 25                	push   $0x25
 54c:	ff 75 08             	pushl  0x8(%ebp)
 54f:	e8 dc fd ff ff       	call   330 <putc>
 554:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 557:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 55a:	0f be c0             	movsbl %al,%eax
 55d:	83 ec 08             	sub    $0x8,%esp
 560:	50                   	push   %eax
 561:	ff 75 08             	pushl  0x8(%ebp)
 564:	e8 c7 fd ff ff       	call   330 <putc>
 569:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 56c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 573:	ff 45 f0             	incl   -0x10(%ebp)
 576:	8b 55 0c             	mov    0xc(%ebp),%edx
 579:	8b 45 f0             	mov    -0x10(%ebp),%eax
 57c:	8d 04 02             	lea    (%edx,%eax,1),%eax
 57f:	8a 00                	mov    (%eax),%al
 581:	84 c0                	test   %al,%al
 583:	0f 85 95 fe ff ff    	jne    41e <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 589:	c9                   	leave  
 58a:	c3                   	ret    
 58b:	90                   	nop

0000058c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 58c:	55                   	push   %ebp
 58d:	89 e5                	mov    %esp,%ebp
 58f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 592:	8b 45 08             	mov    0x8(%ebp),%eax
 595:	83 e8 08             	sub    $0x8,%eax
 598:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 59b:	a1 d0 07 00 00       	mov    0x7d0,%eax
 5a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5a3:	eb 24                	jmp    5c9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5a8:	8b 00                	mov    (%eax),%eax
 5aa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5ad:	77 12                	ja     5c1 <free+0x35>
 5af:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5b2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5b5:	77 24                	ja     5db <free+0x4f>
 5b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ba:	8b 00                	mov    (%eax),%eax
 5bc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5bf:	77 1a                	ja     5db <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5c4:	8b 00                	mov    (%eax),%eax
 5c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5cc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5cf:	76 d4                	jbe    5a5 <free+0x19>
 5d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5d4:	8b 00                	mov    (%eax),%eax
 5d6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5d9:	76 ca                	jbe    5a5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 5db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5de:	8b 40 04             	mov    0x4(%eax),%eax
 5e1:	c1 e0 03             	shl    $0x3,%eax
 5e4:	89 c2                	mov    %eax,%edx
 5e6:	03 55 f8             	add    -0x8(%ebp),%edx
 5e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ec:	8b 00                	mov    (%eax),%eax
 5ee:	39 c2                	cmp    %eax,%edx
 5f0:	75 24                	jne    616 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 5f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f5:	8b 50 04             	mov    0x4(%eax),%edx
 5f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5fb:	8b 00                	mov    (%eax),%eax
 5fd:	8b 40 04             	mov    0x4(%eax),%eax
 600:	01 c2                	add    %eax,%edx
 602:	8b 45 f8             	mov    -0x8(%ebp),%eax
 605:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 608:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60b:	8b 00                	mov    (%eax),%eax
 60d:	8b 10                	mov    (%eax),%edx
 60f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 612:	89 10                	mov    %edx,(%eax)
 614:	eb 0a                	jmp    620 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 616:	8b 45 fc             	mov    -0x4(%ebp),%eax
 619:	8b 10                	mov    (%eax),%edx
 61b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 620:	8b 45 fc             	mov    -0x4(%ebp),%eax
 623:	8b 40 04             	mov    0x4(%eax),%eax
 626:	c1 e0 03             	shl    $0x3,%eax
 629:	03 45 fc             	add    -0x4(%ebp),%eax
 62c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 62f:	75 20                	jne    651 <free+0xc5>
    p->s.size += bp->s.size;
 631:	8b 45 fc             	mov    -0x4(%ebp),%eax
 634:	8b 50 04             	mov    0x4(%eax),%edx
 637:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63a:	8b 40 04             	mov    0x4(%eax),%eax
 63d:	01 c2                	add    %eax,%edx
 63f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 642:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 645:	8b 45 f8             	mov    -0x8(%ebp),%eax
 648:	8b 10                	mov    (%eax),%edx
 64a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64d:	89 10                	mov    %edx,(%eax)
 64f:	eb 08                	jmp    659 <free+0xcd>
  } else
    p->s.ptr = bp;
 651:	8b 45 fc             	mov    -0x4(%ebp),%eax
 654:	8b 55 f8             	mov    -0x8(%ebp),%edx
 657:	89 10                	mov    %edx,(%eax)
  freep = p;
 659:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65c:	a3 d0 07 00 00       	mov    %eax,0x7d0
}
 661:	c9                   	leave  
 662:	c3                   	ret    

00000663 <morecore>:

static Header*
morecore(uint nu)
{
 663:	55                   	push   %ebp
 664:	89 e5                	mov    %esp,%ebp
 666:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 669:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 670:	77 07                	ja     679 <morecore+0x16>
    nu = 4096;
 672:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 679:	8b 45 08             	mov    0x8(%ebp),%eax
 67c:	c1 e0 03             	shl    $0x3,%eax
 67f:	83 ec 0c             	sub    $0xc,%esp
 682:	50                   	push   %eax
 683:	e8 90 fc ff ff       	call   318 <sbrk>
 688:	83 c4 10             	add    $0x10,%esp
 68b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 68e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 692:	75 07                	jne    69b <morecore+0x38>
    return 0;
 694:	b8 00 00 00 00       	mov    $0x0,%eax
 699:	eb 26                	jmp    6c1 <morecore+0x5e>
  hp = (Header*)p;
 69b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 69e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6a4:	8b 55 08             	mov    0x8(%ebp),%edx
 6a7:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ad:	83 c0 08             	add    $0x8,%eax
 6b0:	83 ec 0c             	sub    $0xc,%esp
 6b3:	50                   	push   %eax
 6b4:	e8 d3 fe ff ff       	call   58c <free>
 6b9:	83 c4 10             	add    $0x10,%esp
  return freep;
 6bc:	a1 d0 07 00 00       	mov    0x7d0,%eax
}
 6c1:	c9                   	leave  
 6c2:	c3                   	ret    

000006c3 <malloc>:

void*
malloc(uint nbytes)
{
 6c3:	55                   	push   %ebp
 6c4:	89 e5                	mov    %esp,%ebp
 6c6:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6c9:	8b 45 08             	mov    0x8(%ebp),%eax
 6cc:	83 c0 07             	add    $0x7,%eax
 6cf:	c1 e8 03             	shr    $0x3,%eax
 6d2:	40                   	inc    %eax
 6d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 6d6:	a1 d0 07 00 00       	mov    0x7d0,%eax
 6db:	89 45 f0             	mov    %eax,-0x10(%ebp)
 6de:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6e2:	75 23                	jne    707 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 6e4:	c7 45 f0 c8 07 00 00 	movl   $0x7c8,-0x10(%ebp)
 6eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ee:	a3 d0 07 00 00       	mov    %eax,0x7d0
 6f3:	a1 d0 07 00 00       	mov    0x7d0,%eax
 6f8:	a3 c8 07 00 00       	mov    %eax,0x7c8
    base.s.size = 0;
 6fd:	c7 05 cc 07 00 00 00 	movl   $0x0,0x7cc
 704:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 707:	8b 45 f0             	mov    -0x10(%ebp),%eax
 70a:	8b 00                	mov    (%eax),%eax
 70c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 70f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 712:	8b 40 04             	mov    0x4(%eax),%eax
 715:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 718:	72 4d                	jb     767 <malloc+0xa4>
      if(p->s.size == nunits)
 71a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 71d:	8b 40 04             	mov    0x4(%eax),%eax
 720:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 723:	75 0c                	jne    731 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 725:	8b 45 f4             	mov    -0xc(%ebp),%eax
 728:	8b 10                	mov    (%eax),%edx
 72a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 72d:	89 10                	mov    %edx,(%eax)
 72f:	eb 26                	jmp    757 <malloc+0x94>
      else {
        p->s.size -= nunits;
 731:	8b 45 f4             	mov    -0xc(%ebp),%eax
 734:	8b 40 04             	mov    0x4(%eax),%eax
 737:	89 c2                	mov    %eax,%edx
 739:	2b 55 ec             	sub    -0x14(%ebp),%edx
 73c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 742:	8b 45 f4             	mov    -0xc(%ebp),%eax
 745:	8b 40 04             	mov    0x4(%eax),%eax
 748:	c1 e0 03             	shl    $0x3,%eax
 74b:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 74e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 751:	8b 55 ec             	mov    -0x14(%ebp),%edx
 754:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 757:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75a:	a3 d0 07 00 00       	mov    %eax,0x7d0
      return (void*)(p + 1);
 75f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 762:	83 c0 08             	add    $0x8,%eax
 765:	eb 3b                	jmp    7a2 <malloc+0xdf>
    }
    if(p == freep)
 767:	a1 d0 07 00 00       	mov    0x7d0,%eax
 76c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 76f:	75 1e                	jne    78f <malloc+0xcc>
      if((p = morecore(nunits)) == 0)
 771:	83 ec 0c             	sub    $0xc,%esp
 774:	ff 75 ec             	pushl  -0x14(%ebp)
 777:	e8 e7 fe ff ff       	call   663 <morecore>
 77c:	83 c4 10             	add    $0x10,%esp
 77f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 782:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 786:	75 07                	jne    78f <malloc+0xcc>
        return 0;
 788:	b8 00 00 00 00       	mov    $0x0,%eax
 78d:	eb 13                	jmp    7a2 <malloc+0xdf>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 78f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 792:	89 45 f0             	mov    %eax,-0x10(%ebp)
 795:	8b 45 f4             	mov    -0xc(%ebp),%eax
 798:	8b 00                	mov    (%eax),%eax
 79a:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 79d:	e9 6d ff ff ff       	jmp    70f <malloc+0x4c>
}
 7a2:	c9                   	leave  
 7a3:	c3                   	ret    
