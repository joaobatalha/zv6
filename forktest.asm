
_forktest:     file format elf32-i386


Disassembly of section .text:

00000000 <printf>:

#define N  1000

void
printf(int fd, char *s, ...)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 08             	sub    $0x8,%esp
  write(fd, s, strlen(s));
   6:	83 ec 0c             	sub    $0xc,%esp
   9:	ff 75 0c             	pushl  0xc(%ebp)
   c:	e8 8e 01 00 00       	call   19f <strlen>
  11:	83 c4 10             	add    $0x10,%esp
  14:	83 ec 04             	sub    $0x4,%esp
  17:	50                   	push   %eax
  18:	ff 75 0c             	pushl  0xc(%ebp)
  1b:	ff 75 08             	pushl  0x8(%ebp)
  1e:	e8 41 03 00 00       	call   364 <write>
  23:	83 c4 10             	add    $0x10,%esp
}
  26:	c9                   	leave  
  27:	c3                   	ret    

00000028 <forktest>:

void
forktest(void)
{
  28:	55                   	push   %ebp
  29:	89 e5                	mov    %esp,%ebp
  2b:	83 ec 18             	sub    $0x18,%esp
  int n, pid;

  printf(1, "fork test\n");
  2e:	83 ec 08             	sub    $0x8,%esp
  31:	68 e4 03 00 00       	push   $0x3e4
  36:	6a 01                	push   $0x1
  38:	e8 c3 ff ff ff       	call   0 <printf>
  3d:	83 c4 10             	add    $0x10,%esp

  for(n=0; n<N; n++){
  40:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  47:	eb 1c                	jmp    65 <forktest+0x3d>
    pid = fork();
  49:	e8 ee 02 00 00       	call   33c <fork>
  4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
  51:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  55:	78 19                	js     70 <forktest+0x48>
      break;
    if(pid == 0)
  57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  5b:	75 05                	jne    62 <forktest+0x3a>
      exit();
  5d:	e8 e2 02 00 00       	call   344 <exit>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<N; n++){
  62:	ff 45 f4             	incl   -0xc(%ebp)
  65:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
  6c:	7e db                	jle    49 <forktest+0x21>
  6e:	eb 01                	jmp    71 <forktest+0x49>
    pid = fork();
    if(pid < 0)
      break;
  70:	90                   	nop
    if(pid == 0)
      exit();
  }
  
  if(n == N){
  71:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
  78:	75 3f                	jne    b9 <forktest+0x91>
    printf(1, "fork claimed to work N times!\n", N);
  7a:	83 ec 04             	sub    $0x4,%esp
  7d:	68 e8 03 00 00       	push   $0x3e8
  82:	68 f0 03 00 00       	push   $0x3f0
  87:	6a 01                	push   $0x1
  89:	e8 72 ff ff ff       	call   0 <printf>
  8e:	83 c4 10             	add    $0x10,%esp
    exit();
  91:	e8 ae 02 00 00       	call   344 <exit>
  }
  
  for(; n > 0; n--){
    if(wait() < 0){
  96:	e8 b1 02 00 00       	call   34c <wait>
  9b:	85 c0                	test   %eax,%eax
  9d:	79 17                	jns    b6 <forktest+0x8e>
      printf(1, "wait stopped early\n");
  9f:	83 ec 08             	sub    $0x8,%esp
  a2:	68 0f 04 00 00       	push   $0x40f
  a7:	6a 01                	push   $0x1
  a9:	e8 52 ff ff ff       	call   0 <printf>
  ae:	83 c4 10             	add    $0x10,%esp
      exit();
  b1:	e8 8e 02 00 00       	call   344 <exit>
  if(n == N){
    printf(1, "fork claimed to work N times!\n", N);
    exit();
  }
  
  for(; n > 0; n--){
  b6:	ff 4d f4             	decl   -0xc(%ebp)
  b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  bd:	7f d7                	jg     96 <forktest+0x6e>
      printf(1, "wait stopped early\n");
      exit();
    }
  }
  
  if(wait() != -1){
  bf:	e8 88 02 00 00       	call   34c <wait>
  c4:	83 f8 ff             	cmp    $0xffffffff,%eax
  c7:	74 17                	je     e0 <forktest+0xb8>
    printf(1, "wait got too many\n");
  c9:	83 ec 08             	sub    $0x8,%esp
  cc:	68 23 04 00 00       	push   $0x423
  d1:	6a 01                	push   $0x1
  d3:	e8 28 ff ff ff       	call   0 <printf>
  d8:	83 c4 10             	add    $0x10,%esp
    exit();
  db:	e8 64 02 00 00       	call   344 <exit>
  }
  
  printf(1, "fork test OK\n");
  e0:	83 ec 08             	sub    $0x8,%esp
  e3:	68 36 04 00 00       	push   $0x436
  e8:	6a 01                	push   $0x1
  ea:	e8 11 ff ff ff       	call   0 <printf>
  ef:	83 c4 10             	add    $0x10,%esp
}
  f2:	c9                   	leave  
  f3:	c3                   	ret    

000000f4 <main>:

int
main(void)
{
  f4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  f8:	83 e4 f0             	and    $0xfffffff0,%esp
  fb:	ff 71 fc             	pushl  -0x4(%ecx)
  fe:	55                   	push   %ebp
  ff:	89 e5                	mov    %esp,%ebp
 101:	51                   	push   %ecx
 102:	83 ec 04             	sub    $0x4,%esp
  forktest();
 105:	e8 1e ff ff ff       	call   28 <forktest>
  exit();
 10a:	e8 35 02 00 00       	call   344 <exit>
 10f:	90                   	nop

00000110 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	57                   	push   %edi
 114:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 115:	8b 4d 08             	mov    0x8(%ebp),%ecx
 118:	8b 55 10             	mov    0x10(%ebp),%edx
 11b:	8b 45 0c             	mov    0xc(%ebp),%eax
 11e:	89 cb                	mov    %ecx,%ebx
 120:	89 df                	mov    %ebx,%edi
 122:	89 d1                	mov    %edx,%ecx
 124:	fc                   	cld    
 125:	f3 aa                	rep stos %al,%es:(%edi)
 127:	89 ca                	mov    %ecx,%edx
 129:	89 fb                	mov    %edi,%ebx
 12b:	89 5d 08             	mov    %ebx,0x8(%ebp)
 12e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 131:	5b                   	pop    %ebx
 132:	5f                   	pop    %edi
 133:	c9                   	leave  
 134:	c3                   	ret    

00000135 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
 13e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 141:	90                   	nop
 142:	8b 45 0c             	mov    0xc(%ebp),%eax
 145:	8a 10                	mov    (%eax),%dl
 147:	8b 45 08             	mov    0x8(%ebp),%eax
 14a:	88 10                	mov    %dl,(%eax)
 14c:	8b 45 08             	mov    0x8(%ebp),%eax
 14f:	8a 00                	mov    (%eax),%al
 151:	84 c0                	test   %al,%al
 153:	0f 95 c0             	setne  %al
 156:	ff 45 08             	incl   0x8(%ebp)
 159:	ff 45 0c             	incl   0xc(%ebp)
 15c:	84 c0                	test   %al,%al
 15e:	75 e2                	jne    142 <strcpy+0xd>
    ;
  return os;
 160:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 163:	c9                   	leave  
 164:	c3                   	ret    

00000165 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 165:	55                   	push   %ebp
 166:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 168:	eb 06                	jmp    170 <strcmp+0xb>
    p++, q++;
 16a:	ff 45 08             	incl   0x8(%ebp)
 16d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 170:	8b 45 08             	mov    0x8(%ebp),%eax
 173:	8a 00                	mov    (%eax),%al
 175:	84 c0                	test   %al,%al
 177:	74 0e                	je     187 <strcmp+0x22>
 179:	8b 45 08             	mov    0x8(%ebp),%eax
 17c:	8a 10                	mov    (%eax),%dl
 17e:	8b 45 0c             	mov    0xc(%ebp),%eax
 181:	8a 00                	mov    (%eax),%al
 183:	38 c2                	cmp    %al,%dl
 185:	74 e3                	je     16a <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 187:	8b 45 08             	mov    0x8(%ebp),%eax
 18a:	8a 00                	mov    (%eax),%al
 18c:	0f b6 d0             	movzbl %al,%edx
 18f:	8b 45 0c             	mov    0xc(%ebp),%eax
 192:	8a 00                	mov    (%eax),%al
 194:	0f b6 c0             	movzbl %al,%eax
 197:	89 d1                	mov    %edx,%ecx
 199:	29 c1                	sub    %eax,%ecx
 19b:	89 c8                	mov    %ecx,%eax
}
 19d:	c9                   	leave  
 19e:	c3                   	ret    

0000019f <strlen>:

uint
strlen(char *s)
{
 19f:	55                   	push   %ebp
 1a0:	89 e5                	mov    %esp,%ebp
 1a2:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1ac:	eb 03                	jmp    1b1 <strlen+0x12>
 1ae:	ff 45 fc             	incl   -0x4(%ebp)
 1b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 1b4:	03 45 08             	add    0x8(%ebp),%eax
 1b7:	8a 00                	mov    (%eax),%al
 1b9:	84 c0                	test   %al,%al
 1bb:	75 f1                	jne    1ae <strlen+0xf>
    ;
  return n;
 1bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1c0:	c9                   	leave  
 1c1:	c3                   	ret    

000001c2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c2:	55                   	push   %ebp
 1c3:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1c5:	8b 45 10             	mov    0x10(%ebp),%eax
 1c8:	50                   	push   %eax
 1c9:	ff 75 0c             	pushl  0xc(%ebp)
 1cc:	ff 75 08             	pushl  0x8(%ebp)
 1cf:	e8 3c ff ff ff       	call   110 <stosb>
 1d4:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1d7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1da:	c9                   	leave  
 1db:	c3                   	ret    

000001dc <strchr>:

char*
strchr(const char *s, char c)
{
 1dc:	55                   	push   %ebp
 1dd:	89 e5                	mov    %esp,%ebp
 1df:	83 ec 04             	sub    $0x4,%esp
 1e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e5:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1e8:	eb 12                	jmp    1fc <strchr+0x20>
    if(*s == c)
 1ea:	8b 45 08             	mov    0x8(%ebp),%eax
 1ed:	8a 00                	mov    (%eax),%al
 1ef:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1f2:	75 05                	jne    1f9 <strchr+0x1d>
      return (char*)s;
 1f4:	8b 45 08             	mov    0x8(%ebp),%eax
 1f7:	eb 11                	jmp    20a <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1f9:	ff 45 08             	incl   0x8(%ebp)
 1fc:	8b 45 08             	mov    0x8(%ebp),%eax
 1ff:	8a 00                	mov    (%eax),%al
 201:	84 c0                	test   %al,%al
 203:	75 e5                	jne    1ea <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 205:	b8 00 00 00 00       	mov    $0x0,%eax
}
 20a:	c9                   	leave  
 20b:	c3                   	ret    

0000020c <gets>:

char*
gets(char *buf, int max)
{
 20c:	55                   	push   %ebp
 20d:	89 e5                	mov    %esp,%ebp
 20f:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 212:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 219:	eb 38                	jmp    253 <gets+0x47>
    cc = read(0, &c, 1);
 21b:	83 ec 04             	sub    $0x4,%esp
 21e:	6a 01                	push   $0x1
 220:	8d 45 ef             	lea    -0x11(%ebp),%eax
 223:	50                   	push   %eax
 224:	6a 00                	push   $0x0
 226:	e8 31 01 00 00       	call   35c <read>
 22b:	83 c4 10             	add    $0x10,%esp
 22e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 231:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 235:	7e 27                	jle    25e <gets+0x52>
      break;
    buf[i++] = c;
 237:	8b 45 f4             	mov    -0xc(%ebp),%eax
 23a:	03 45 08             	add    0x8(%ebp),%eax
 23d:	8a 55 ef             	mov    -0x11(%ebp),%dl
 240:	88 10                	mov    %dl,(%eax)
 242:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 245:	8a 45 ef             	mov    -0x11(%ebp),%al
 248:	3c 0a                	cmp    $0xa,%al
 24a:	74 13                	je     25f <gets+0x53>
 24c:	8a 45 ef             	mov    -0x11(%ebp),%al
 24f:	3c 0d                	cmp    $0xd,%al
 251:	74 0c                	je     25f <gets+0x53>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 253:	8b 45 f4             	mov    -0xc(%ebp),%eax
 256:	40                   	inc    %eax
 257:	3b 45 0c             	cmp    0xc(%ebp),%eax
 25a:	7c bf                	jl     21b <gets+0xf>
 25c:	eb 01                	jmp    25f <gets+0x53>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 25e:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 25f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 262:	03 45 08             	add    0x8(%ebp),%eax
 265:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 268:	8b 45 08             	mov    0x8(%ebp),%eax
}
 26b:	c9                   	leave  
 26c:	c3                   	ret    

0000026d <stat>:

int
stat(char *n, struct stat *st)
{
 26d:	55                   	push   %ebp
 26e:	89 e5                	mov    %esp,%ebp
 270:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 273:	83 ec 08             	sub    $0x8,%esp
 276:	6a 00                	push   $0x0
 278:	ff 75 08             	pushl  0x8(%ebp)
 27b:	e8 04 01 00 00       	call   384 <open>
 280:	83 c4 10             	add    $0x10,%esp
 283:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 286:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 28a:	79 07                	jns    293 <stat+0x26>
    return -1;
 28c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 291:	eb 25                	jmp    2b8 <stat+0x4b>
  r = fstat(fd, st);
 293:	83 ec 08             	sub    $0x8,%esp
 296:	ff 75 0c             	pushl  0xc(%ebp)
 299:	ff 75 f4             	pushl  -0xc(%ebp)
 29c:	e8 fb 00 00 00       	call   39c <fstat>
 2a1:	83 c4 10             	add    $0x10,%esp
 2a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2a7:	83 ec 0c             	sub    $0xc,%esp
 2aa:	ff 75 f4             	pushl  -0xc(%ebp)
 2ad:	e8 ba 00 00 00       	call   36c <close>
 2b2:	83 c4 10             	add    $0x10,%esp
  return r;
 2b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2b8:	c9                   	leave  
 2b9:	c3                   	ret    

000002ba <atoi>:

int
atoi(const char *s)
{
 2ba:	55                   	push   %ebp
 2bb:	89 e5                	mov    %esp,%ebp
 2bd:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2c7:	eb 22                	jmp    2eb <atoi+0x31>
    n = n*10 + *s++ - '0';
 2c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2cc:	89 d0                	mov    %edx,%eax
 2ce:	c1 e0 02             	shl    $0x2,%eax
 2d1:	01 d0                	add    %edx,%eax
 2d3:	d1 e0                	shl    %eax
 2d5:	89 c2                	mov    %eax,%edx
 2d7:	8b 45 08             	mov    0x8(%ebp),%eax
 2da:	8a 00                	mov    (%eax),%al
 2dc:	0f be c0             	movsbl %al,%eax
 2df:	8d 04 02             	lea    (%edx,%eax,1),%eax
 2e2:	83 e8 30             	sub    $0x30,%eax
 2e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
 2e8:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2eb:	8b 45 08             	mov    0x8(%ebp),%eax
 2ee:	8a 00                	mov    (%eax),%al
 2f0:	3c 2f                	cmp    $0x2f,%al
 2f2:	7e 09                	jle    2fd <atoi+0x43>
 2f4:	8b 45 08             	mov    0x8(%ebp),%eax
 2f7:	8a 00                	mov    (%eax),%al
 2f9:	3c 39                	cmp    $0x39,%al
 2fb:	7e cc                	jle    2c9 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 300:	c9                   	leave  
 301:	c3                   	ret    

00000302 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 302:	55                   	push   %ebp
 303:	89 e5                	mov    %esp,%ebp
 305:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 308:	8b 45 08             	mov    0x8(%ebp),%eax
 30b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 30e:	8b 45 0c             	mov    0xc(%ebp),%eax
 311:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 314:	eb 10                	jmp    326 <memmove+0x24>
    *dst++ = *src++;
 316:	8b 45 f8             	mov    -0x8(%ebp),%eax
 319:	8a 10                	mov    (%eax),%dl
 31b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 31e:	88 10                	mov    %dl,(%eax)
 320:	ff 45 fc             	incl   -0x4(%ebp)
 323:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 326:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 32a:	0f 9f c0             	setg   %al
 32d:	ff 4d 10             	decl   0x10(%ebp)
 330:	84 c0                	test   %al,%al
 332:	75 e2                	jne    316 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 334:	8b 45 08             	mov    0x8(%ebp),%eax
}
 337:	c9                   	leave  
 338:	c3                   	ret    
 339:	90                   	nop
 33a:	90                   	nop
 33b:	90                   	nop

0000033c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 33c:	b8 01 00 00 00       	mov    $0x1,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <exit>:
SYSCALL(exit)
 344:	b8 02 00 00 00       	mov    $0x2,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <wait>:
SYSCALL(wait)
 34c:	b8 03 00 00 00       	mov    $0x3,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <pipe>:
SYSCALL(pipe)
 354:	b8 04 00 00 00       	mov    $0x4,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <read>:
SYSCALL(read)
 35c:	b8 05 00 00 00       	mov    $0x5,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <write>:
SYSCALL(write)
 364:	b8 10 00 00 00       	mov    $0x10,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <close>:
SYSCALL(close)
 36c:	b8 15 00 00 00       	mov    $0x15,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <kill>:
SYSCALL(kill)
 374:	b8 06 00 00 00       	mov    $0x6,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <exec>:
SYSCALL(exec)
 37c:	b8 07 00 00 00       	mov    $0x7,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <open>:
SYSCALL(open)
 384:	b8 0f 00 00 00       	mov    $0xf,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <mknod>:
SYSCALL(mknod)
 38c:	b8 11 00 00 00       	mov    $0x11,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <unlink>:
SYSCALL(unlink)
 394:	b8 12 00 00 00       	mov    $0x12,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <fstat>:
SYSCALL(fstat)
 39c:	b8 08 00 00 00       	mov    $0x8,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <link>:
SYSCALL(link)
 3a4:	b8 13 00 00 00       	mov    $0x13,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <mkdir>:
SYSCALL(mkdir)
 3ac:	b8 14 00 00 00       	mov    $0x14,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <chdir>:
SYSCALL(chdir)
 3b4:	b8 09 00 00 00       	mov    $0x9,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <dup>:
SYSCALL(dup)
 3bc:	b8 0a 00 00 00       	mov    $0xa,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <getpid>:
SYSCALL(getpid)
 3c4:	b8 0b 00 00 00       	mov    $0xb,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <sbrk>:
SYSCALL(sbrk)
 3cc:	b8 0c 00 00 00       	mov    $0xc,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <sleep>:
SYSCALL(sleep)
 3d4:	b8 0d 00 00 00       	mov    $0xd,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <uptime>:
SYSCALL(uptime)
 3dc:	b8 0e 00 00 00       	mov    $0xe,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    
