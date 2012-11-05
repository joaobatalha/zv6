
_mkdir:     file format elf32-i386


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

  if(argc < 2){
  14:	83 3b 01             	cmpl   $0x1,(%ebx)
  17:	7f 17                	jg     30 <main+0x30>
    printf(2, "Usage: mkdir files...\n");
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 cc 07 00 00       	push   $0x7cc
  21:	6a 02                	push   $0x2
  23:	e8 fc 03 00 00       	call   424 <printf>
  28:	83 c4 10             	add    $0x10,%esp
    exit();
  2b:	e8 88 02 00 00       	call   2b8 <exit>
  }

  for(i = 1; i < argc; i++){
  30:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  37:	eb 3e                	jmp    77 <main+0x77>
    if(mkdir(argv[i]) < 0){
  39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  3c:	c1 e0 02             	shl    $0x2,%eax
  3f:	03 43 04             	add    0x4(%ebx),%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	83 ec 0c             	sub    $0xc,%esp
  47:	50                   	push   %eax
  48:	e8 d3 02 00 00       	call   320 <mkdir>
  4d:	83 c4 10             	add    $0x10,%esp
  50:	85 c0                	test   %eax,%eax
  52:	79 20                	jns    74 <main+0x74>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
  54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  57:	c1 e0 02             	shl    $0x2,%eax
  5a:	03 43 04             	add    0x4(%ebx),%eax
  5d:	8b 00                	mov    (%eax),%eax
  5f:	83 ec 04             	sub    $0x4,%esp
  62:	50                   	push   %eax
  63:	68 e3 07 00 00       	push   $0x7e3
  68:	6a 02                	push   $0x2
  6a:	e8 b5 03 00 00       	call   424 <printf>
  6f:	83 c4 10             	add    $0x10,%esp
      break;
  72:	eb 0a                	jmp    7e <main+0x7e>
  if(argc < 2){
    printf(2, "Usage: mkdir files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  74:	ff 45 f4             	incl   -0xc(%ebp)
  77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  7a:	3b 03                	cmp    (%ebx),%eax
  7c:	7c bb                	jl     39 <main+0x39>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
      break;
    }
  }

  exit();
  7e:	e8 35 02 00 00       	call   2b8 <exit>
  83:	90                   	nop

00000084 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  84:	55                   	push   %ebp
  85:	89 e5                	mov    %esp,%ebp
  87:	57                   	push   %edi
  88:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8c:	8b 55 10             	mov    0x10(%ebp),%edx
  8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  92:	89 cb                	mov    %ecx,%ebx
  94:	89 df                	mov    %ebx,%edi
  96:	89 d1                	mov    %edx,%ecx
  98:	fc                   	cld    
  99:	f3 aa                	rep stos %al,%es:(%edi)
  9b:	89 ca                	mov    %ecx,%edx
  9d:	89 fb                	mov    %edi,%ebx
  9f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  a2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  a5:	5b                   	pop    %ebx
  a6:	5f                   	pop    %edi
  a7:	c9                   	leave  
  a8:	c3                   	ret    

000000a9 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  a9:	55                   	push   %ebp
  aa:	89 e5                	mov    %esp,%ebp
  ac:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  af:	8b 45 08             	mov    0x8(%ebp),%eax
  b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  b5:	90                   	nop
  b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  b9:	8a 10                	mov    (%eax),%dl
  bb:	8b 45 08             	mov    0x8(%ebp),%eax
  be:	88 10                	mov    %dl,(%eax)
  c0:	8b 45 08             	mov    0x8(%ebp),%eax
  c3:	8a 00                	mov    (%eax),%al
  c5:	84 c0                	test   %al,%al
  c7:	0f 95 c0             	setne  %al
  ca:	ff 45 08             	incl   0x8(%ebp)
  cd:	ff 45 0c             	incl   0xc(%ebp)
  d0:	84 c0                	test   %al,%al
  d2:	75 e2                	jne    b6 <strcpy+0xd>
    ;
  return os;
  d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  d7:	c9                   	leave  
  d8:	c3                   	ret    

000000d9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d9:	55                   	push   %ebp
  da:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  dc:	eb 06                	jmp    e4 <strcmp+0xb>
    p++, q++;
  de:	ff 45 08             	incl   0x8(%ebp)
  e1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  e4:	8b 45 08             	mov    0x8(%ebp),%eax
  e7:	8a 00                	mov    (%eax),%al
  e9:	84 c0                	test   %al,%al
  eb:	74 0e                	je     fb <strcmp+0x22>
  ed:	8b 45 08             	mov    0x8(%ebp),%eax
  f0:	8a 10                	mov    (%eax),%dl
  f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  f5:	8a 00                	mov    (%eax),%al
  f7:	38 c2                	cmp    %al,%dl
  f9:	74 e3                	je     de <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  fb:	8b 45 08             	mov    0x8(%ebp),%eax
  fe:	8a 00                	mov    (%eax),%al
 100:	0f b6 d0             	movzbl %al,%edx
 103:	8b 45 0c             	mov    0xc(%ebp),%eax
 106:	8a 00                	mov    (%eax),%al
 108:	0f b6 c0             	movzbl %al,%eax
 10b:	89 d1                	mov    %edx,%ecx
 10d:	29 c1                	sub    %eax,%ecx
 10f:	89 c8                	mov    %ecx,%eax
}
 111:	c9                   	leave  
 112:	c3                   	ret    

00000113 <strlen>:

uint
strlen(char *s)
{
 113:	55                   	push   %ebp
 114:	89 e5                	mov    %esp,%ebp
 116:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 119:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 120:	eb 03                	jmp    125 <strlen+0x12>
 122:	ff 45 fc             	incl   -0x4(%ebp)
 125:	8b 45 fc             	mov    -0x4(%ebp),%eax
 128:	03 45 08             	add    0x8(%ebp),%eax
 12b:	8a 00                	mov    (%eax),%al
 12d:	84 c0                	test   %al,%al
 12f:	75 f1                	jne    122 <strlen+0xf>
    ;
  return n;
 131:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 134:	c9                   	leave  
 135:	c3                   	ret    

00000136 <memset>:

void*
memset(void *dst, int c, uint n)
{
 136:	55                   	push   %ebp
 137:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 139:	8b 45 10             	mov    0x10(%ebp),%eax
 13c:	50                   	push   %eax
 13d:	ff 75 0c             	pushl  0xc(%ebp)
 140:	ff 75 08             	pushl  0x8(%ebp)
 143:	e8 3c ff ff ff       	call   84 <stosb>
 148:	83 c4 0c             	add    $0xc,%esp
  return dst;
 14b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 14e:	c9                   	leave  
 14f:	c3                   	ret    

00000150 <strchr>:

char*
strchr(const char *s, char c)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	83 ec 04             	sub    $0x4,%esp
 156:	8b 45 0c             	mov    0xc(%ebp),%eax
 159:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 15c:	eb 12                	jmp    170 <strchr+0x20>
    if(*s == c)
 15e:	8b 45 08             	mov    0x8(%ebp),%eax
 161:	8a 00                	mov    (%eax),%al
 163:	3a 45 fc             	cmp    -0x4(%ebp),%al
 166:	75 05                	jne    16d <strchr+0x1d>
      return (char*)s;
 168:	8b 45 08             	mov    0x8(%ebp),%eax
 16b:	eb 11                	jmp    17e <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 16d:	ff 45 08             	incl   0x8(%ebp)
 170:	8b 45 08             	mov    0x8(%ebp),%eax
 173:	8a 00                	mov    (%eax),%al
 175:	84 c0                	test   %al,%al
 177:	75 e5                	jne    15e <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 179:	b8 00 00 00 00       	mov    $0x0,%eax
}
 17e:	c9                   	leave  
 17f:	c3                   	ret    

00000180 <gets>:

char*
gets(char *buf, int max)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 186:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 18d:	eb 38                	jmp    1c7 <gets+0x47>
    cc = read(0, &c, 1);
 18f:	83 ec 04             	sub    $0x4,%esp
 192:	6a 01                	push   $0x1
 194:	8d 45 ef             	lea    -0x11(%ebp),%eax
 197:	50                   	push   %eax
 198:	6a 00                	push   $0x0
 19a:	e8 31 01 00 00       	call   2d0 <read>
 19f:	83 c4 10             	add    $0x10,%esp
 1a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a9:	7e 27                	jle    1d2 <gets+0x52>
      break;
    buf[i++] = c;
 1ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ae:	03 45 08             	add    0x8(%ebp),%eax
 1b1:	8a 55 ef             	mov    -0x11(%ebp),%dl
 1b4:	88 10                	mov    %dl,(%eax)
 1b6:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 1b9:	8a 45 ef             	mov    -0x11(%ebp),%al
 1bc:	3c 0a                	cmp    $0xa,%al
 1be:	74 13                	je     1d3 <gets+0x53>
 1c0:	8a 45 ef             	mov    -0x11(%ebp),%al
 1c3:	3c 0d                	cmp    $0xd,%al
 1c5:	74 0c                	je     1d3 <gets+0x53>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ca:	40                   	inc    %eax
 1cb:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1ce:	7c bf                	jl     18f <gets+0xf>
 1d0:	eb 01                	jmp    1d3 <gets+0x53>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1d2:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d6:	03 45 08             	add    0x8(%ebp),%eax
 1d9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1dc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1df:	c9                   	leave  
 1e0:	c3                   	ret    

000001e1 <stat>:

int
stat(char *n, struct stat *st)
{
 1e1:	55                   	push   %ebp
 1e2:	89 e5                	mov    %esp,%ebp
 1e4:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e7:	83 ec 08             	sub    $0x8,%esp
 1ea:	6a 00                	push   $0x0
 1ec:	ff 75 08             	pushl  0x8(%ebp)
 1ef:	e8 04 01 00 00       	call   2f8 <open>
 1f4:	83 c4 10             	add    $0x10,%esp
 1f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1fe:	79 07                	jns    207 <stat+0x26>
    return -1;
 200:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 205:	eb 25                	jmp    22c <stat+0x4b>
  r = fstat(fd, st);
 207:	83 ec 08             	sub    $0x8,%esp
 20a:	ff 75 0c             	pushl  0xc(%ebp)
 20d:	ff 75 f4             	pushl  -0xc(%ebp)
 210:	e8 fb 00 00 00       	call   310 <fstat>
 215:	83 c4 10             	add    $0x10,%esp
 218:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 21b:	83 ec 0c             	sub    $0xc,%esp
 21e:	ff 75 f4             	pushl  -0xc(%ebp)
 221:	e8 ba 00 00 00       	call   2e0 <close>
 226:	83 c4 10             	add    $0x10,%esp
  return r;
 229:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 22c:	c9                   	leave  
 22d:	c3                   	ret    

0000022e <atoi>:

int
atoi(const char *s)
{
 22e:	55                   	push   %ebp
 22f:	89 e5                	mov    %esp,%ebp
 231:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 234:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 23b:	eb 22                	jmp    25f <atoi+0x31>
    n = n*10 + *s++ - '0';
 23d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 240:	89 d0                	mov    %edx,%eax
 242:	c1 e0 02             	shl    $0x2,%eax
 245:	01 d0                	add    %edx,%eax
 247:	d1 e0                	shl    %eax
 249:	89 c2                	mov    %eax,%edx
 24b:	8b 45 08             	mov    0x8(%ebp),%eax
 24e:	8a 00                	mov    (%eax),%al
 250:	0f be c0             	movsbl %al,%eax
 253:	8d 04 02             	lea    (%edx,%eax,1),%eax
 256:	83 e8 30             	sub    $0x30,%eax
 259:	89 45 fc             	mov    %eax,-0x4(%ebp)
 25c:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 25f:	8b 45 08             	mov    0x8(%ebp),%eax
 262:	8a 00                	mov    (%eax),%al
 264:	3c 2f                	cmp    $0x2f,%al
 266:	7e 09                	jle    271 <atoi+0x43>
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	8a 00                	mov    (%eax),%al
 26d:	3c 39                	cmp    $0x39,%al
 26f:	7e cc                	jle    23d <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 271:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 274:	c9                   	leave  
 275:	c3                   	ret    

00000276 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 276:	55                   	push   %ebp
 277:	89 e5                	mov    %esp,%ebp
 279:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 27c:	8b 45 08             	mov    0x8(%ebp),%eax
 27f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 282:	8b 45 0c             	mov    0xc(%ebp),%eax
 285:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 288:	eb 10                	jmp    29a <memmove+0x24>
    *dst++ = *src++;
 28a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 28d:	8a 10                	mov    (%eax),%dl
 28f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 292:	88 10                	mov    %dl,(%eax)
 294:	ff 45 fc             	incl   -0x4(%ebp)
 297:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 29a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 29e:	0f 9f c0             	setg   %al
 2a1:	ff 4d 10             	decl   0x10(%ebp)
 2a4:	84 c0                	test   %al,%al
 2a6:	75 e2                	jne    28a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2ab:	c9                   	leave  
 2ac:	c3                   	ret    
 2ad:	90                   	nop
 2ae:	90                   	nop
 2af:	90                   	nop

000002b0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2b0:	b8 01 00 00 00       	mov    $0x1,%eax
 2b5:	cd 40                	int    $0x40
 2b7:	c3                   	ret    

000002b8 <exit>:
SYSCALL(exit)
 2b8:	b8 02 00 00 00       	mov    $0x2,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <wait>:
SYSCALL(wait)
 2c0:	b8 03 00 00 00       	mov    $0x3,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <pipe>:
SYSCALL(pipe)
 2c8:	b8 04 00 00 00       	mov    $0x4,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <read>:
SYSCALL(read)
 2d0:	b8 05 00 00 00       	mov    $0x5,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <write>:
SYSCALL(write)
 2d8:	b8 10 00 00 00       	mov    $0x10,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <close>:
SYSCALL(close)
 2e0:	b8 15 00 00 00       	mov    $0x15,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <kill>:
SYSCALL(kill)
 2e8:	b8 06 00 00 00       	mov    $0x6,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <exec>:
SYSCALL(exec)
 2f0:	b8 07 00 00 00       	mov    $0x7,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <open>:
SYSCALL(open)
 2f8:	b8 0f 00 00 00       	mov    $0xf,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <mknod>:
SYSCALL(mknod)
 300:	b8 11 00 00 00       	mov    $0x11,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <unlink>:
SYSCALL(unlink)
 308:	b8 12 00 00 00       	mov    $0x12,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <fstat>:
SYSCALL(fstat)
 310:	b8 08 00 00 00       	mov    $0x8,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <link>:
SYSCALL(link)
 318:	b8 13 00 00 00       	mov    $0x13,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <mkdir>:
SYSCALL(mkdir)
 320:	b8 14 00 00 00       	mov    $0x14,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <chdir>:
SYSCALL(chdir)
 328:	b8 09 00 00 00       	mov    $0x9,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <dup>:
SYSCALL(dup)
 330:	b8 0a 00 00 00       	mov    $0xa,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <getpid>:
SYSCALL(getpid)
 338:	b8 0b 00 00 00       	mov    $0xb,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <sbrk>:
SYSCALL(sbrk)
 340:	b8 0c 00 00 00       	mov    $0xc,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <sleep>:
SYSCALL(sleep)
 348:	b8 0d 00 00 00       	mov    $0xd,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <uptime>:
SYSCALL(uptime)
 350:	b8 0e 00 00 00       	mov    $0xe,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 358:	55                   	push   %ebp
 359:	89 e5                	mov    %esp,%ebp
 35b:	83 ec 18             	sub    $0x18,%esp
 35e:	8b 45 0c             	mov    0xc(%ebp),%eax
 361:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 364:	83 ec 04             	sub    $0x4,%esp
 367:	6a 01                	push   $0x1
 369:	8d 45 f4             	lea    -0xc(%ebp),%eax
 36c:	50                   	push   %eax
 36d:	ff 75 08             	pushl  0x8(%ebp)
 370:	e8 63 ff ff ff       	call   2d8 <write>
 375:	83 c4 10             	add    $0x10,%esp
}
 378:	c9                   	leave  
 379:	c3                   	ret    

0000037a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 37a:	55                   	push   %ebp
 37b:	89 e5                	mov    %esp,%ebp
 37d:	83 ec 38             	sub    $0x38,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 380:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 387:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 38b:	74 17                	je     3a4 <printint+0x2a>
 38d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 391:	79 11                	jns    3a4 <printint+0x2a>
    neg = 1;
 393:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 39a:	8b 45 0c             	mov    0xc(%ebp),%eax
 39d:	f7 d8                	neg    %eax
 39f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3a2:	eb 06                	jmp    3aa <printint+0x30>
  } else {
    x = xx;
 3a4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3b1:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3b7:	ba 00 00 00 00       	mov    $0x0,%edx
 3bc:	f7 f1                	div    %ecx
 3be:	89 d0                	mov    %edx,%eax
 3c0:	8a 90 08 08 00 00    	mov    0x808(%eax),%dl
 3c6:	8d 45 dc             	lea    -0x24(%ebp),%eax
 3c9:	03 45 f4             	add    -0xc(%ebp),%eax
 3cc:	88 10                	mov    %dl,(%eax)
 3ce:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 3d1:	8b 45 10             	mov    0x10(%ebp),%eax
 3d4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 3d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3da:	ba 00 00 00 00       	mov    $0x0,%edx
 3df:	f7 75 d4             	divl   -0x2c(%ebp)
 3e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3e5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3e9:	75 c6                	jne    3b1 <printint+0x37>
  if(neg)
 3eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3ef:	74 28                	je     419 <printint+0x9f>
    buf[i++] = '-';
 3f1:	8d 45 dc             	lea    -0x24(%ebp),%eax
 3f4:	03 45 f4             	add    -0xc(%ebp),%eax
 3f7:	c6 00 2d             	movb   $0x2d,(%eax)
 3fa:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 3fd:	eb 1a                	jmp    419 <printint+0x9f>
    putc(fd, buf[i]);
 3ff:	8d 45 dc             	lea    -0x24(%ebp),%eax
 402:	03 45 f4             	add    -0xc(%ebp),%eax
 405:	8a 00                	mov    (%eax),%al
 407:	0f be c0             	movsbl %al,%eax
 40a:	83 ec 08             	sub    $0x8,%esp
 40d:	50                   	push   %eax
 40e:	ff 75 08             	pushl  0x8(%ebp)
 411:	e8 42 ff ff ff       	call   358 <putc>
 416:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 419:	ff 4d f4             	decl   -0xc(%ebp)
 41c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 420:	79 dd                	jns    3ff <printint+0x85>
    putc(fd, buf[i]);
}
 422:	c9                   	leave  
 423:	c3                   	ret    

00000424 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 424:	55                   	push   %ebp
 425:	89 e5                	mov    %esp,%ebp
 427:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 42a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 431:	8d 45 0c             	lea    0xc(%ebp),%eax
 434:	83 c0 04             	add    $0x4,%eax
 437:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 43a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 441:	e9 58 01 00 00       	jmp    59e <printf+0x17a>
    c = fmt[i] & 0xff;
 446:	8b 55 0c             	mov    0xc(%ebp),%edx
 449:	8b 45 f0             	mov    -0x10(%ebp),%eax
 44c:	8d 04 02             	lea    (%edx,%eax,1),%eax
 44f:	8a 00                	mov    (%eax),%al
 451:	0f be c0             	movsbl %al,%eax
 454:	25 ff 00 00 00       	and    $0xff,%eax
 459:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 45c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 460:	75 2c                	jne    48e <printf+0x6a>
      if(c == '%'){
 462:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 466:	75 0c                	jne    474 <printf+0x50>
        state = '%';
 468:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 46f:	e9 27 01 00 00       	jmp    59b <printf+0x177>
      } else {
        putc(fd, c);
 474:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 477:	0f be c0             	movsbl %al,%eax
 47a:	83 ec 08             	sub    $0x8,%esp
 47d:	50                   	push   %eax
 47e:	ff 75 08             	pushl  0x8(%ebp)
 481:	e8 d2 fe ff ff       	call   358 <putc>
 486:	83 c4 10             	add    $0x10,%esp
 489:	e9 0d 01 00 00       	jmp    59b <printf+0x177>
      }
    } else if(state == '%'){
 48e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 492:	0f 85 03 01 00 00    	jne    59b <printf+0x177>
      if(c == 'd'){
 498:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 49c:	75 1e                	jne    4bc <printf+0x98>
        printint(fd, *ap, 10, 1);
 49e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4a1:	8b 00                	mov    (%eax),%eax
 4a3:	6a 01                	push   $0x1
 4a5:	6a 0a                	push   $0xa
 4a7:	50                   	push   %eax
 4a8:	ff 75 08             	pushl  0x8(%ebp)
 4ab:	e8 ca fe ff ff       	call   37a <printint>
 4b0:	83 c4 10             	add    $0x10,%esp
        ap++;
 4b3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4b7:	e9 d8 00 00 00       	jmp    594 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4bc:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4c0:	74 06                	je     4c8 <printf+0xa4>
 4c2:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4c6:	75 1e                	jne    4e6 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4cb:	8b 00                	mov    (%eax),%eax
 4cd:	6a 00                	push   $0x0
 4cf:	6a 10                	push   $0x10
 4d1:	50                   	push   %eax
 4d2:	ff 75 08             	pushl  0x8(%ebp)
 4d5:	e8 a0 fe ff ff       	call   37a <printint>
 4da:	83 c4 10             	add    $0x10,%esp
        ap++;
 4dd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4e1:	e9 ae 00 00 00       	jmp    594 <printf+0x170>
      } else if(c == 's'){
 4e6:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4ea:	75 43                	jne    52f <printf+0x10b>
        s = (char*)*ap;
 4ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4ef:	8b 00                	mov    (%eax),%eax
 4f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 4f4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 4f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4fc:	75 25                	jne    523 <printf+0xff>
          s = "(null)";
 4fe:	c7 45 f4 ff 07 00 00 	movl   $0x7ff,-0xc(%ebp)
        while(*s != 0){
 505:	eb 1d                	jmp    524 <printf+0x100>
          putc(fd, *s);
 507:	8b 45 f4             	mov    -0xc(%ebp),%eax
 50a:	8a 00                	mov    (%eax),%al
 50c:	0f be c0             	movsbl %al,%eax
 50f:	83 ec 08             	sub    $0x8,%esp
 512:	50                   	push   %eax
 513:	ff 75 08             	pushl  0x8(%ebp)
 516:	e8 3d fe ff ff       	call   358 <putc>
 51b:	83 c4 10             	add    $0x10,%esp
          s++;
 51e:	ff 45 f4             	incl   -0xc(%ebp)
 521:	eb 01                	jmp    524 <printf+0x100>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 523:	90                   	nop
 524:	8b 45 f4             	mov    -0xc(%ebp),%eax
 527:	8a 00                	mov    (%eax),%al
 529:	84 c0                	test   %al,%al
 52b:	75 da                	jne    507 <printf+0xe3>
 52d:	eb 65                	jmp    594 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 52f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 533:	75 1d                	jne    552 <printf+0x12e>
        putc(fd, *ap);
 535:	8b 45 e8             	mov    -0x18(%ebp),%eax
 538:	8b 00                	mov    (%eax),%eax
 53a:	0f be c0             	movsbl %al,%eax
 53d:	83 ec 08             	sub    $0x8,%esp
 540:	50                   	push   %eax
 541:	ff 75 08             	pushl  0x8(%ebp)
 544:	e8 0f fe ff ff       	call   358 <putc>
 549:	83 c4 10             	add    $0x10,%esp
        ap++;
 54c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 550:	eb 42                	jmp    594 <printf+0x170>
      } else if(c == '%'){
 552:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 556:	75 17                	jne    56f <printf+0x14b>
        putc(fd, c);
 558:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 55b:	0f be c0             	movsbl %al,%eax
 55e:	83 ec 08             	sub    $0x8,%esp
 561:	50                   	push   %eax
 562:	ff 75 08             	pushl  0x8(%ebp)
 565:	e8 ee fd ff ff       	call   358 <putc>
 56a:	83 c4 10             	add    $0x10,%esp
 56d:	eb 25                	jmp    594 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 56f:	83 ec 08             	sub    $0x8,%esp
 572:	6a 25                	push   $0x25
 574:	ff 75 08             	pushl  0x8(%ebp)
 577:	e8 dc fd ff ff       	call   358 <putc>
 57c:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 57f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 582:	0f be c0             	movsbl %al,%eax
 585:	83 ec 08             	sub    $0x8,%esp
 588:	50                   	push   %eax
 589:	ff 75 08             	pushl  0x8(%ebp)
 58c:	e8 c7 fd ff ff       	call   358 <putc>
 591:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 594:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 59b:	ff 45 f0             	incl   -0x10(%ebp)
 59e:	8b 55 0c             	mov    0xc(%ebp),%edx
 5a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5a4:	8d 04 02             	lea    (%edx,%eax,1),%eax
 5a7:	8a 00                	mov    (%eax),%al
 5a9:	84 c0                	test   %al,%al
 5ab:	0f 85 95 fe ff ff    	jne    446 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5b1:	c9                   	leave  
 5b2:	c3                   	ret    
 5b3:	90                   	nop

000005b4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5b4:	55                   	push   %ebp
 5b5:	89 e5                	mov    %esp,%ebp
 5b7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5ba:	8b 45 08             	mov    0x8(%ebp),%eax
 5bd:	83 e8 08             	sub    $0x8,%eax
 5c0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5c3:	a1 24 08 00 00       	mov    0x824,%eax
 5c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5cb:	eb 24                	jmp    5f1 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5d0:	8b 00                	mov    (%eax),%eax
 5d2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5d5:	77 12                	ja     5e9 <free+0x35>
 5d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5da:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5dd:	77 24                	ja     603 <free+0x4f>
 5df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5e2:	8b 00                	mov    (%eax),%eax
 5e4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5e7:	77 1a                	ja     603 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ec:	8b 00                	mov    (%eax),%eax
 5ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5f7:	76 d4                	jbe    5cd <free+0x19>
 5f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5fc:	8b 00                	mov    (%eax),%eax
 5fe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 601:	76 ca                	jbe    5cd <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 603:	8b 45 f8             	mov    -0x8(%ebp),%eax
 606:	8b 40 04             	mov    0x4(%eax),%eax
 609:	c1 e0 03             	shl    $0x3,%eax
 60c:	89 c2                	mov    %eax,%edx
 60e:	03 55 f8             	add    -0x8(%ebp),%edx
 611:	8b 45 fc             	mov    -0x4(%ebp),%eax
 614:	8b 00                	mov    (%eax),%eax
 616:	39 c2                	cmp    %eax,%edx
 618:	75 24                	jne    63e <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 61a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61d:	8b 50 04             	mov    0x4(%eax),%edx
 620:	8b 45 fc             	mov    -0x4(%ebp),%eax
 623:	8b 00                	mov    (%eax),%eax
 625:	8b 40 04             	mov    0x4(%eax),%eax
 628:	01 c2                	add    %eax,%edx
 62a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 630:	8b 45 fc             	mov    -0x4(%ebp),%eax
 633:	8b 00                	mov    (%eax),%eax
 635:	8b 10                	mov    (%eax),%edx
 637:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63a:	89 10                	mov    %edx,(%eax)
 63c:	eb 0a                	jmp    648 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 63e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 641:	8b 10                	mov    (%eax),%edx
 643:	8b 45 f8             	mov    -0x8(%ebp),%eax
 646:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 648:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64b:	8b 40 04             	mov    0x4(%eax),%eax
 64e:	c1 e0 03             	shl    $0x3,%eax
 651:	03 45 fc             	add    -0x4(%ebp),%eax
 654:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 657:	75 20                	jne    679 <free+0xc5>
    p->s.size += bp->s.size;
 659:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65c:	8b 50 04             	mov    0x4(%eax),%edx
 65f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 662:	8b 40 04             	mov    0x4(%eax),%eax
 665:	01 c2                	add    %eax,%edx
 667:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 66d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 670:	8b 10                	mov    (%eax),%edx
 672:	8b 45 fc             	mov    -0x4(%ebp),%eax
 675:	89 10                	mov    %edx,(%eax)
 677:	eb 08                	jmp    681 <free+0xcd>
  } else
    p->s.ptr = bp;
 679:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 67f:	89 10                	mov    %edx,(%eax)
  freep = p;
 681:	8b 45 fc             	mov    -0x4(%ebp),%eax
 684:	a3 24 08 00 00       	mov    %eax,0x824
}
 689:	c9                   	leave  
 68a:	c3                   	ret    

0000068b <morecore>:

static Header*
morecore(uint nu)
{
 68b:	55                   	push   %ebp
 68c:	89 e5                	mov    %esp,%ebp
 68e:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 691:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 698:	77 07                	ja     6a1 <morecore+0x16>
    nu = 4096;
 69a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6a1:	8b 45 08             	mov    0x8(%ebp),%eax
 6a4:	c1 e0 03             	shl    $0x3,%eax
 6a7:	83 ec 0c             	sub    $0xc,%esp
 6aa:	50                   	push   %eax
 6ab:	e8 90 fc ff ff       	call   340 <sbrk>
 6b0:	83 c4 10             	add    $0x10,%esp
 6b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6b6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6ba:	75 07                	jne    6c3 <morecore+0x38>
    return 0;
 6bc:	b8 00 00 00 00       	mov    $0x0,%eax
 6c1:	eb 26                	jmp    6e9 <morecore+0x5e>
  hp = (Header*)p;
 6c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6cc:	8b 55 08             	mov    0x8(%ebp),%edx
 6cf:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6d5:	83 c0 08             	add    $0x8,%eax
 6d8:	83 ec 0c             	sub    $0xc,%esp
 6db:	50                   	push   %eax
 6dc:	e8 d3 fe ff ff       	call   5b4 <free>
 6e1:	83 c4 10             	add    $0x10,%esp
  return freep;
 6e4:	a1 24 08 00 00       	mov    0x824,%eax
}
 6e9:	c9                   	leave  
 6ea:	c3                   	ret    

000006eb <malloc>:

void*
malloc(uint nbytes)
{
 6eb:	55                   	push   %ebp
 6ec:	89 e5                	mov    %esp,%ebp
 6ee:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6f1:	8b 45 08             	mov    0x8(%ebp),%eax
 6f4:	83 c0 07             	add    $0x7,%eax
 6f7:	c1 e8 03             	shr    $0x3,%eax
 6fa:	40                   	inc    %eax
 6fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 6fe:	a1 24 08 00 00       	mov    0x824,%eax
 703:	89 45 f0             	mov    %eax,-0x10(%ebp)
 706:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 70a:	75 23                	jne    72f <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 70c:	c7 45 f0 1c 08 00 00 	movl   $0x81c,-0x10(%ebp)
 713:	8b 45 f0             	mov    -0x10(%ebp),%eax
 716:	a3 24 08 00 00       	mov    %eax,0x824
 71b:	a1 24 08 00 00       	mov    0x824,%eax
 720:	a3 1c 08 00 00       	mov    %eax,0x81c
    base.s.size = 0;
 725:	c7 05 20 08 00 00 00 	movl   $0x0,0x820
 72c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 72f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 732:	8b 00                	mov    (%eax),%eax
 734:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 737:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73a:	8b 40 04             	mov    0x4(%eax),%eax
 73d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 740:	72 4d                	jb     78f <malloc+0xa4>
      if(p->s.size == nunits)
 742:	8b 45 f4             	mov    -0xc(%ebp),%eax
 745:	8b 40 04             	mov    0x4(%eax),%eax
 748:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 74b:	75 0c                	jne    759 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 74d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 750:	8b 10                	mov    (%eax),%edx
 752:	8b 45 f0             	mov    -0x10(%ebp),%eax
 755:	89 10                	mov    %edx,(%eax)
 757:	eb 26                	jmp    77f <malloc+0x94>
      else {
        p->s.size -= nunits;
 759:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75c:	8b 40 04             	mov    0x4(%eax),%eax
 75f:	89 c2                	mov    %eax,%edx
 761:	2b 55 ec             	sub    -0x14(%ebp),%edx
 764:	8b 45 f4             	mov    -0xc(%ebp),%eax
 767:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 76a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76d:	8b 40 04             	mov    0x4(%eax),%eax
 770:	c1 e0 03             	shl    $0x3,%eax
 773:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 776:	8b 45 f4             	mov    -0xc(%ebp),%eax
 779:	8b 55 ec             	mov    -0x14(%ebp),%edx
 77c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 77f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 782:	a3 24 08 00 00       	mov    %eax,0x824
      return (void*)(p + 1);
 787:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78a:	83 c0 08             	add    $0x8,%eax
 78d:	eb 3b                	jmp    7ca <malloc+0xdf>
    }
    if(p == freep)
 78f:	a1 24 08 00 00       	mov    0x824,%eax
 794:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 797:	75 1e                	jne    7b7 <malloc+0xcc>
      if((p = morecore(nunits)) == 0)
 799:	83 ec 0c             	sub    $0xc,%esp
 79c:	ff 75 ec             	pushl  -0x14(%ebp)
 79f:	e8 e7 fe ff ff       	call   68b <morecore>
 7a4:	83 c4 10             	add    $0x10,%esp
 7a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7ae:	75 07                	jne    7b7 <malloc+0xcc>
        return 0;
 7b0:	b8 00 00 00 00       	mov    $0x0,%eax
 7b5:	eb 13                	jmp    7ca <malloc+0xdf>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c0:	8b 00                	mov    (%eax),%eax
 7c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7c5:	e9 6d ff ff ff       	jmp    737 <malloc+0x4c>
}
 7ca:	c9                   	leave  
 7cb:	c3                   	ret    
