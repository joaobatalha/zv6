
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int n, m;
  char *p, *q;
  
  m = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
   d:	e9 ad 00 00 00       	jmp    bf <grep+0xbf>
    m += n;
  12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  15:	01 45 f4             	add    %eax,-0xc(%ebp)
    p = buf;
  18:	c7 45 f0 e0 0a 00 00 	movl   $0xae0,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  1f:	eb 48                	jmp    69 <grep+0x69>
      *q = 0;
  21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  24:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
  27:	83 ec 08             	sub    $0x8,%esp
  2a:	ff 75 f0             	pushl  -0x10(%ebp)
  2d:	ff 75 08             	pushl  0x8(%ebp)
  30:	e8 91 01 00 00       	call   1c6 <match>
  35:	83 c4 10             	add    $0x10,%esp
  38:	85 c0                	test   %eax,%eax
  3a:	74 26                	je     62 <grep+0x62>
        *q = '\n';
  3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  3f:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
  42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  45:	40                   	inc    %eax
  46:	89 c2                	mov    %eax,%edx
  48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  4b:	89 d1                	mov    %edx,%ecx
  4d:	29 c1                	sub    %eax,%ecx
  4f:	89 c8                	mov    %ecx,%eax
  51:	83 ec 04             	sub    $0x4,%esp
  54:	50                   	push   %eax
  55:	ff 75 f0             	pushl  -0x10(%ebp)
  58:	6a 01                	push   $0x1
  5a:	e8 05 05 00 00       	call   564 <write>
  5f:	83 c4 10             	add    $0x10,%esp
      }
      p = q+1;
  62:	8b 45 e8             	mov    -0x18(%ebp),%eax
  65:	40                   	inc    %eax
  66:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
    m += n;
    p = buf;
    while((q = strchr(p, '\n')) != 0){
  69:	83 ec 08             	sub    $0x8,%esp
  6c:	6a 0a                	push   $0xa
  6e:	ff 75 f0             	pushl  -0x10(%ebp)
  71:	e8 66 03 00 00       	call   3dc <strchr>
  76:	83 c4 10             	add    $0x10,%esp
  79:	89 45 e8             	mov    %eax,-0x18(%ebp)
  7c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80:	75 9f                	jne    21 <grep+0x21>
        *q = '\n';
        write(1, p, q+1 - p);
      }
      p = q+1;
    }
    if(p == buf)
  82:	81 7d f0 e0 0a 00 00 	cmpl   $0xae0,-0x10(%ebp)
  89:	75 07                	jne    92 <grep+0x92>
      m = 0;
  8b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
  92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  96:	7e 27                	jle    bf <grep+0xbf>
      m -= p - buf;
  98:	ba e0 0a 00 00       	mov    $0xae0,%edx
  9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  a0:	89 d1                	mov    %edx,%ecx
  a2:	29 c1                	sub    %eax,%ecx
  a4:	89 c8                	mov    %ecx,%eax
  a6:	01 45 f4             	add    %eax,-0xc(%ebp)
      memmove(buf, p, m);
  a9:	83 ec 04             	sub    $0x4,%esp
  ac:	ff 75 f4             	pushl  -0xc(%ebp)
  af:	ff 75 f0             	pushl  -0x10(%ebp)
  b2:	68 e0 0a 00 00       	push   $0xae0
  b7:	e8 46 04 00 00       	call   502 <memmove>
  bc:	83 c4 10             	add    $0x10,%esp
{
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
  bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  c2:	ba 00 04 00 00       	mov    $0x400,%edx
  c7:	89 d1                	mov    %edx,%ecx
  c9:	29 c1                	sub    %eax,%ecx
  cb:	89 c8                	mov    %ecx,%eax
  cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  d0:	81 c2 e0 0a 00 00    	add    $0xae0,%edx
  d6:	83 ec 04             	sub    $0x4,%esp
  d9:	50                   	push   %eax
  da:	52                   	push   %edx
  db:	ff 75 0c             	pushl  0xc(%ebp)
  de:	e8 79 04 00 00       	call   55c <read>
  e3:	83 c4 10             	add    $0x10,%esp
  e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  ed:	0f 8f 1f ff ff ff    	jg     12 <grep+0x12>
    if(m > 0){
      m -= p - buf;
      memmove(buf, p, m);
    }
  }
}
  f3:	c9                   	leave  
  f4:	c3                   	ret    

000000f5 <main>:

int
main(int argc, char *argv[])
{
  f5:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  f9:	83 e4 f0             	and    $0xfffffff0,%esp
  fc:	ff 71 fc             	pushl  -0x4(%ecx)
  ff:	55                   	push   %ebp
 100:	89 e5                	mov    %esp,%ebp
 102:	53                   	push   %ebx
 103:	51                   	push   %ecx
 104:	83 ec 10             	sub    $0x10,%esp
 107:	89 cb                	mov    %ecx,%ebx
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
 109:	83 3b 01             	cmpl   $0x1,(%ebx)
 10c:	7f 17                	jg     125 <main+0x30>
    printf(2, "usage: grep pattern [file ...]\n");
 10e:	83 ec 08             	sub    $0x8,%esp
 111:	68 58 0a 00 00       	push   $0xa58
 116:	6a 02                	push   $0x2
 118:	e8 93 05 00 00       	call   6b0 <printf>
 11d:	83 c4 10             	add    $0x10,%esp
    exit();
 120:	e8 1f 04 00 00       	call   544 <exit>
  }
  pattern = argv[1];
 125:	8b 43 04             	mov    0x4(%ebx),%eax
 128:	83 c0 04             	add    $0x4,%eax
 12b:	8b 00                	mov    (%eax),%eax
 12d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  if(argc <= 2){
 130:	83 3b 02             	cmpl   $0x2,(%ebx)
 133:	7f 15                	jg     14a <main+0x55>
    grep(pattern, 0);
 135:	83 ec 08             	sub    $0x8,%esp
 138:	6a 00                	push   $0x0
 13a:	ff 75 f0             	pushl  -0x10(%ebp)
 13d:	e8 be fe ff ff       	call   0 <grep>
 142:	83 c4 10             	add    $0x10,%esp
    exit();
 145:	e8 fa 03 00 00       	call   544 <exit>
  }

  for(i = 2; i < argc; i++){
 14a:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
 151:	eb 67                	jmp    1ba <main+0xc5>
    if((fd = open(argv[i], 0)) < 0){
 153:	8b 45 f4             	mov    -0xc(%ebp),%eax
 156:	c1 e0 02             	shl    $0x2,%eax
 159:	03 43 04             	add    0x4(%ebx),%eax
 15c:	8b 00                	mov    (%eax),%eax
 15e:	83 ec 08             	sub    $0x8,%esp
 161:	6a 00                	push   $0x0
 163:	50                   	push   %eax
 164:	e8 1b 04 00 00       	call   584 <open>
 169:	83 c4 10             	add    $0x10,%esp
 16c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 16f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 173:	79 23                	jns    198 <main+0xa3>
      printf(1, "grep: cannot open %s\n", argv[i]);
 175:	8b 45 f4             	mov    -0xc(%ebp),%eax
 178:	c1 e0 02             	shl    $0x2,%eax
 17b:	03 43 04             	add    0x4(%ebx),%eax
 17e:	8b 00                	mov    (%eax),%eax
 180:	83 ec 04             	sub    $0x4,%esp
 183:	50                   	push   %eax
 184:	68 78 0a 00 00       	push   $0xa78
 189:	6a 01                	push   $0x1
 18b:	e8 20 05 00 00       	call   6b0 <printf>
 190:	83 c4 10             	add    $0x10,%esp
      exit();
 193:	e8 ac 03 00 00       	call   544 <exit>
    }
    grep(pattern, fd);
 198:	83 ec 08             	sub    $0x8,%esp
 19b:	ff 75 ec             	pushl  -0x14(%ebp)
 19e:	ff 75 f0             	pushl  -0x10(%ebp)
 1a1:	e8 5a fe ff ff       	call   0 <grep>
 1a6:	83 c4 10             	add    $0x10,%esp
    close(fd);
 1a9:	83 ec 0c             	sub    $0xc,%esp
 1ac:	ff 75 ec             	pushl  -0x14(%ebp)
 1af:	e8 b8 03 00 00       	call   56c <close>
 1b4:	83 c4 10             	add    $0x10,%esp
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
 1b7:	ff 45 f4             	incl   -0xc(%ebp)
 1ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1bd:	3b 03                	cmp    (%ebx),%eax
 1bf:	7c 92                	jl     153 <main+0x5e>
      exit();
    }
    grep(pattern, fd);
    close(fd);
  }
  exit();
 1c1:	e8 7e 03 00 00       	call   544 <exit>

000001c6 <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 1c6:	55                   	push   %ebp
 1c7:	89 e5                	mov    %esp,%ebp
 1c9:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '^')
 1cc:	8b 45 08             	mov    0x8(%ebp),%eax
 1cf:	8a 00                	mov    (%eax),%al
 1d1:	3c 5e                	cmp    $0x5e,%al
 1d3:	75 15                	jne    1ea <match+0x24>
    return matchhere(re+1, text);
 1d5:	8b 45 08             	mov    0x8(%ebp),%eax
 1d8:	40                   	inc    %eax
 1d9:	83 ec 08             	sub    $0x8,%esp
 1dc:	ff 75 0c             	pushl  0xc(%ebp)
 1df:	50                   	push   %eax
 1e0:	e8 39 00 00 00       	call   21e <matchhere>
 1e5:	83 c4 10             	add    $0x10,%esp
 1e8:	eb 32                	jmp    21c <match+0x56>
  do{  // must look at empty string
    if(matchhere(re, text))
 1ea:	83 ec 08             	sub    $0x8,%esp
 1ed:	ff 75 0c             	pushl  0xc(%ebp)
 1f0:	ff 75 08             	pushl  0x8(%ebp)
 1f3:	e8 26 00 00 00       	call   21e <matchhere>
 1f8:	83 c4 10             	add    $0x10,%esp
 1fb:	85 c0                	test   %eax,%eax
 1fd:	74 07                	je     206 <match+0x40>
      return 1;
 1ff:	b8 01 00 00 00       	mov    $0x1,%eax
 204:	eb 16                	jmp    21c <match+0x56>
  }while(*text++ != '\0');
 206:	8b 45 0c             	mov    0xc(%ebp),%eax
 209:	8a 00                	mov    (%eax),%al
 20b:	84 c0                	test   %al,%al
 20d:	0f 95 c0             	setne  %al
 210:	ff 45 0c             	incl   0xc(%ebp)
 213:	84 c0                	test   %al,%al
 215:	75 d3                	jne    1ea <match+0x24>
  return 0;
 217:	b8 00 00 00 00       	mov    $0x0,%eax
}
 21c:	c9                   	leave  
 21d:	c3                   	ret    

0000021e <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
 21e:	55                   	push   %ebp
 21f:	89 e5                	mov    %esp,%ebp
 221:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '\0')
 224:	8b 45 08             	mov    0x8(%ebp),%eax
 227:	8a 00                	mov    (%eax),%al
 229:	84 c0                	test   %al,%al
 22b:	75 0a                	jne    237 <matchhere+0x19>
    return 1;
 22d:	b8 01 00 00 00       	mov    $0x1,%eax
 232:	e9 8a 00 00 00       	jmp    2c1 <matchhere+0xa3>
  if(re[1] == '*')
 237:	8b 45 08             	mov    0x8(%ebp),%eax
 23a:	40                   	inc    %eax
 23b:	8a 00                	mov    (%eax),%al
 23d:	3c 2a                	cmp    $0x2a,%al
 23f:	75 20                	jne    261 <matchhere+0x43>
    return matchstar(re[0], re+2, text);
 241:	8b 45 08             	mov    0x8(%ebp),%eax
 244:	8d 50 02             	lea    0x2(%eax),%edx
 247:	8b 45 08             	mov    0x8(%ebp),%eax
 24a:	8a 00                	mov    (%eax),%al
 24c:	0f be c0             	movsbl %al,%eax
 24f:	83 ec 04             	sub    $0x4,%esp
 252:	ff 75 0c             	pushl  0xc(%ebp)
 255:	52                   	push   %edx
 256:	50                   	push   %eax
 257:	e8 67 00 00 00       	call   2c3 <matchstar>
 25c:	83 c4 10             	add    $0x10,%esp
 25f:	eb 60                	jmp    2c1 <matchhere+0xa3>
  if(re[0] == '$' && re[1] == '\0')
 261:	8b 45 08             	mov    0x8(%ebp),%eax
 264:	8a 00                	mov    (%eax),%al
 266:	3c 24                	cmp    $0x24,%al
 268:	75 19                	jne    283 <matchhere+0x65>
 26a:	8b 45 08             	mov    0x8(%ebp),%eax
 26d:	40                   	inc    %eax
 26e:	8a 00                	mov    (%eax),%al
 270:	84 c0                	test   %al,%al
 272:	75 0f                	jne    283 <matchhere+0x65>
    return *text == '\0';
 274:	8b 45 0c             	mov    0xc(%ebp),%eax
 277:	8a 00                	mov    (%eax),%al
 279:	84 c0                	test   %al,%al
 27b:	0f 94 c0             	sete   %al
 27e:	0f b6 c0             	movzbl %al,%eax
 281:	eb 3e                	jmp    2c1 <matchhere+0xa3>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 283:	8b 45 0c             	mov    0xc(%ebp),%eax
 286:	8a 00                	mov    (%eax),%al
 288:	84 c0                	test   %al,%al
 28a:	74 30                	je     2bc <matchhere+0x9e>
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
 28f:	8a 00                	mov    (%eax),%al
 291:	3c 2e                	cmp    $0x2e,%al
 293:	74 0e                	je     2a3 <matchhere+0x85>
 295:	8b 45 08             	mov    0x8(%ebp),%eax
 298:	8a 10                	mov    (%eax),%dl
 29a:	8b 45 0c             	mov    0xc(%ebp),%eax
 29d:	8a 00                	mov    (%eax),%al
 29f:	38 c2                	cmp    %al,%dl
 2a1:	75 19                	jne    2bc <matchhere+0x9e>
    return matchhere(re+1, text+1);
 2a3:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a6:	8d 50 01             	lea    0x1(%eax),%edx
 2a9:	8b 45 08             	mov    0x8(%ebp),%eax
 2ac:	40                   	inc    %eax
 2ad:	83 ec 08             	sub    $0x8,%esp
 2b0:	52                   	push   %edx
 2b1:	50                   	push   %eax
 2b2:	e8 67 ff ff ff       	call   21e <matchhere>
 2b7:	83 c4 10             	add    $0x10,%esp
 2ba:	eb 05                	jmp    2c1 <matchhere+0xa3>
  return 0;
 2bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2c1:	c9                   	leave  
 2c2:	c3                   	ret    

000002c3 <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
 2c3:	55                   	push   %ebp
 2c4:	89 e5                	mov    %esp,%ebp
 2c6:	83 ec 08             	sub    $0x8,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 2c9:	83 ec 08             	sub    $0x8,%esp
 2cc:	ff 75 10             	pushl  0x10(%ebp)
 2cf:	ff 75 0c             	pushl  0xc(%ebp)
 2d2:	e8 47 ff ff ff       	call   21e <matchhere>
 2d7:	83 c4 10             	add    $0x10,%esp
 2da:	85 c0                	test   %eax,%eax
 2dc:	74 07                	je     2e5 <matchstar+0x22>
      return 1;
 2de:	b8 01 00 00 00       	mov    $0x1,%eax
 2e3:	eb 29                	jmp    30e <matchstar+0x4b>
  }while(*text!='\0' && (*text++==c || c=='.'));
 2e5:	8b 45 10             	mov    0x10(%ebp),%eax
 2e8:	8a 00                	mov    (%eax),%al
 2ea:	84 c0                	test   %al,%al
 2ec:	74 1b                	je     309 <matchstar+0x46>
 2ee:	8b 45 10             	mov    0x10(%ebp),%eax
 2f1:	8a 00                	mov    (%eax),%al
 2f3:	0f be c0             	movsbl %al,%eax
 2f6:	3b 45 08             	cmp    0x8(%ebp),%eax
 2f9:	0f 94 c0             	sete   %al
 2fc:	ff 45 10             	incl   0x10(%ebp)
 2ff:	84 c0                	test   %al,%al
 301:	75 c6                	jne    2c9 <matchstar+0x6>
 303:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
 307:	74 c0                	je     2c9 <matchstar+0x6>
  return 0;
 309:	b8 00 00 00 00       	mov    $0x0,%eax
}
 30e:	c9                   	leave  
 30f:	c3                   	ret    

00000310 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	57                   	push   %edi
 314:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 315:	8b 4d 08             	mov    0x8(%ebp),%ecx
 318:	8b 55 10             	mov    0x10(%ebp),%edx
 31b:	8b 45 0c             	mov    0xc(%ebp),%eax
 31e:	89 cb                	mov    %ecx,%ebx
 320:	89 df                	mov    %ebx,%edi
 322:	89 d1                	mov    %edx,%ecx
 324:	fc                   	cld    
 325:	f3 aa                	rep stos %al,%es:(%edi)
 327:	89 ca                	mov    %ecx,%edx
 329:	89 fb                	mov    %edi,%ebx
 32b:	89 5d 08             	mov    %ebx,0x8(%ebp)
 32e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 331:	5b                   	pop    %ebx
 332:	5f                   	pop    %edi
 333:	c9                   	leave  
 334:	c3                   	ret    

00000335 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 335:	55                   	push   %ebp
 336:	89 e5                	mov    %esp,%ebp
 338:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 33b:	8b 45 08             	mov    0x8(%ebp),%eax
 33e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 341:	90                   	nop
 342:	8b 45 0c             	mov    0xc(%ebp),%eax
 345:	8a 10                	mov    (%eax),%dl
 347:	8b 45 08             	mov    0x8(%ebp),%eax
 34a:	88 10                	mov    %dl,(%eax)
 34c:	8b 45 08             	mov    0x8(%ebp),%eax
 34f:	8a 00                	mov    (%eax),%al
 351:	84 c0                	test   %al,%al
 353:	0f 95 c0             	setne  %al
 356:	ff 45 08             	incl   0x8(%ebp)
 359:	ff 45 0c             	incl   0xc(%ebp)
 35c:	84 c0                	test   %al,%al
 35e:	75 e2                	jne    342 <strcpy+0xd>
    ;
  return os;
 360:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 363:	c9                   	leave  
 364:	c3                   	ret    

00000365 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 365:	55                   	push   %ebp
 366:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 368:	eb 06                	jmp    370 <strcmp+0xb>
    p++, q++;
 36a:	ff 45 08             	incl   0x8(%ebp)
 36d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 370:	8b 45 08             	mov    0x8(%ebp),%eax
 373:	8a 00                	mov    (%eax),%al
 375:	84 c0                	test   %al,%al
 377:	74 0e                	je     387 <strcmp+0x22>
 379:	8b 45 08             	mov    0x8(%ebp),%eax
 37c:	8a 10                	mov    (%eax),%dl
 37e:	8b 45 0c             	mov    0xc(%ebp),%eax
 381:	8a 00                	mov    (%eax),%al
 383:	38 c2                	cmp    %al,%dl
 385:	74 e3                	je     36a <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 387:	8b 45 08             	mov    0x8(%ebp),%eax
 38a:	8a 00                	mov    (%eax),%al
 38c:	0f b6 d0             	movzbl %al,%edx
 38f:	8b 45 0c             	mov    0xc(%ebp),%eax
 392:	8a 00                	mov    (%eax),%al
 394:	0f b6 c0             	movzbl %al,%eax
 397:	89 d1                	mov    %edx,%ecx
 399:	29 c1                	sub    %eax,%ecx
 39b:	89 c8                	mov    %ecx,%eax
}
 39d:	c9                   	leave  
 39e:	c3                   	ret    

0000039f <strlen>:

uint
strlen(char *s)
{
 39f:	55                   	push   %ebp
 3a0:	89 e5                	mov    %esp,%ebp
 3a2:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3ac:	eb 03                	jmp    3b1 <strlen+0x12>
 3ae:	ff 45 fc             	incl   -0x4(%ebp)
 3b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3b4:	03 45 08             	add    0x8(%ebp),%eax
 3b7:	8a 00                	mov    (%eax),%al
 3b9:	84 c0                	test   %al,%al
 3bb:	75 f1                	jne    3ae <strlen+0xf>
    ;
  return n;
 3bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3c0:	c9                   	leave  
 3c1:	c3                   	ret    

000003c2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3c2:	55                   	push   %ebp
 3c3:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 3c5:	8b 45 10             	mov    0x10(%ebp),%eax
 3c8:	50                   	push   %eax
 3c9:	ff 75 0c             	pushl  0xc(%ebp)
 3cc:	ff 75 08             	pushl  0x8(%ebp)
 3cf:	e8 3c ff ff ff       	call   310 <stosb>
 3d4:	83 c4 0c             	add    $0xc,%esp
  return dst;
 3d7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3da:	c9                   	leave  
 3db:	c3                   	ret    

000003dc <strchr>:

char*
strchr(const char *s, char c)
{
 3dc:	55                   	push   %ebp
 3dd:	89 e5                	mov    %esp,%ebp
 3df:	83 ec 04             	sub    $0x4,%esp
 3e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e5:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 3e8:	eb 12                	jmp    3fc <strchr+0x20>
    if(*s == c)
 3ea:	8b 45 08             	mov    0x8(%ebp),%eax
 3ed:	8a 00                	mov    (%eax),%al
 3ef:	3a 45 fc             	cmp    -0x4(%ebp),%al
 3f2:	75 05                	jne    3f9 <strchr+0x1d>
      return (char*)s;
 3f4:	8b 45 08             	mov    0x8(%ebp),%eax
 3f7:	eb 11                	jmp    40a <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 3f9:	ff 45 08             	incl   0x8(%ebp)
 3fc:	8b 45 08             	mov    0x8(%ebp),%eax
 3ff:	8a 00                	mov    (%eax),%al
 401:	84 c0                	test   %al,%al
 403:	75 e5                	jne    3ea <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 405:	b8 00 00 00 00       	mov    $0x0,%eax
}
 40a:	c9                   	leave  
 40b:	c3                   	ret    

0000040c <gets>:

char*
gets(char *buf, int max)
{
 40c:	55                   	push   %ebp
 40d:	89 e5                	mov    %esp,%ebp
 40f:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 412:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 419:	eb 38                	jmp    453 <gets+0x47>
    cc = read(0, &c, 1);
 41b:	83 ec 04             	sub    $0x4,%esp
 41e:	6a 01                	push   $0x1
 420:	8d 45 ef             	lea    -0x11(%ebp),%eax
 423:	50                   	push   %eax
 424:	6a 00                	push   $0x0
 426:	e8 31 01 00 00       	call   55c <read>
 42b:	83 c4 10             	add    $0x10,%esp
 42e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 431:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 435:	7e 27                	jle    45e <gets+0x52>
      break;
    buf[i++] = c;
 437:	8b 45 f4             	mov    -0xc(%ebp),%eax
 43a:	03 45 08             	add    0x8(%ebp),%eax
 43d:	8a 55 ef             	mov    -0x11(%ebp),%dl
 440:	88 10                	mov    %dl,(%eax)
 442:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 445:	8a 45 ef             	mov    -0x11(%ebp),%al
 448:	3c 0a                	cmp    $0xa,%al
 44a:	74 13                	je     45f <gets+0x53>
 44c:	8a 45 ef             	mov    -0x11(%ebp),%al
 44f:	3c 0d                	cmp    $0xd,%al
 451:	74 0c                	je     45f <gets+0x53>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 453:	8b 45 f4             	mov    -0xc(%ebp),%eax
 456:	40                   	inc    %eax
 457:	3b 45 0c             	cmp    0xc(%ebp),%eax
 45a:	7c bf                	jl     41b <gets+0xf>
 45c:	eb 01                	jmp    45f <gets+0x53>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 45e:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 45f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 462:	03 45 08             	add    0x8(%ebp),%eax
 465:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 468:	8b 45 08             	mov    0x8(%ebp),%eax
}
 46b:	c9                   	leave  
 46c:	c3                   	ret    

0000046d <stat>:

int
stat(char *n, struct stat *st)
{
 46d:	55                   	push   %ebp
 46e:	89 e5                	mov    %esp,%ebp
 470:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 473:	83 ec 08             	sub    $0x8,%esp
 476:	6a 00                	push   $0x0
 478:	ff 75 08             	pushl  0x8(%ebp)
 47b:	e8 04 01 00 00       	call   584 <open>
 480:	83 c4 10             	add    $0x10,%esp
 483:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 486:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 48a:	79 07                	jns    493 <stat+0x26>
    return -1;
 48c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 491:	eb 25                	jmp    4b8 <stat+0x4b>
  r = fstat(fd, st);
 493:	83 ec 08             	sub    $0x8,%esp
 496:	ff 75 0c             	pushl  0xc(%ebp)
 499:	ff 75 f4             	pushl  -0xc(%ebp)
 49c:	e8 fb 00 00 00       	call   59c <fstat>
 4a1:	83 c4 10             	add    $0x10,%esp
 4a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4a7:	83 ec 0c             	sub    $0xc,%esp
 4aa:	ff 75 f4             	pushl  -0xc(%ebp)
 4ad:	e8 ba 00 00 00       	call   56c <close>
 4b2:	83 c4 10             	add    $0x10,%esp
  return r;
 4b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 4b8:	c9                   	leave  
 4b9:	c3                   	ret    

000004ba <atoi>:

int
atoi(const char *s)
{
 4ba:	55                   	push   %ebp
 4bb:	89 e5                	mov    %esp,%ebp
 4bd:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 4c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 4c7:	eb 22                	jmp    4eb <atoi+0x31>
    n = n*10 + *s++ - '0';
 4c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4cc:	89 d0                	mov    %edx,%eax
 4ce:	c1 e0 02             	shl    $0x2,%eax
 4d1:	01 d0                	add    %edx,%eax
 4d3:	d1 e0                	shl    %eax
 4d5:	89 c2                	mov    %eax,%edx
 4d7:	8b 45 08             	mov    0x8(%ebp),%eax
 4da:	8a 00                	mov    (%eax),%al
 4dc:	0f be c0             	movsbl %al,%eax
 4df:	8d 04 02             	lea    (%edx,%eax,1),%eax
 4e2:	83 e8 30             	sub    $0x30,%eax
 4e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
 4e8:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4eb:	8b 45 08             	mov    0x8(%ebp),%eax
 4ee:	8a 00                	mov    (%eax),%al
 4f0:	3c 2f                	cmp    $0x2f,%al
 4f2:	7e 09                	jle    4fd <atoi+0x43>
 4f4:	8b 45 08             	mov    0x8(%ebp),%eax
 4f7:	8a 00                	mov    (%eax),%al
 4f9:	3c 39                	cmp    $0x39,%al
 4fb:	7e cc                	jle    4c9 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 4fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 500:	c9                   	leave  
 501:	c3                   	ret    

00000502 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 502:	55                   	push   %ebp
 503:	89 e5                	mov    %esp,%ebp
 505:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 508:	8b 45 08             	mov    0x8(%ebp),%eax
 50b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 50e:	8b 45 0c             	mov    0xc(%ebp),%eax
 511:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 514:	eb 10                	jmp    526 <memmove+0x24>
    *dst++ = *src++;
 516:	8b 45 f8             	mov    -0x8(%ebp),%eax
 519:	8a 10                	mov    (%eax),%dl
 51b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 51e:	88 10                	mov    %dl,(%eax)
 520:	ff 45 fc             	incl   -0x4(%ebp)
 523:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 526:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 52a:	0f 9f c0             	setg   %al
 52d:	ff 4d 10             	decl   0x10(%ebp)
 530:	84 c0                	test   %al,%al
 532:	75 e2                	jne    516 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 534:	8b 45 08             	mov    0x8(%ebp),%eax
}
 537:	c9                   	leave  
 538:	c3                   	ret    
 539:	90                   	nop
 53a:	90                   	nop
 53b:	90                   	nop

0000053c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 53c:	b8 01 00 00 00       	mov    $0x1,%eax
 541:	cd 40                	int    $0x40
 543:	c3                   	ret    

00000544 <exit>:
SYSCALL(exit)
 544:	b8 02 00 00 00       	mov    $0x2,%eax
 549:	cd 40                	int    $0x40
 54b:	c3                   	ret    

0000054c <wait>:
SYSCALL(wait)
 54c:	b8 03 00 00 00       	mov    $0x3,%eax
 551:	cd 40                	int    $0x40
 553:	c3                   	ret    

00000554 <pipe>:
SYSCALL(pipe)
 554:	b8 04 00 00 00       	mov    $0x4,%eax
 559:	cd 40                	int    $0x40
 55b:	c3                   	ret    

0000055c <read>:
SYSCALL(read)
 55c:	b8 05 00 00 00       	mov    $0x5,%eax
 561:	cd 40                	int    $0x40
 563:	c3                   	ret    

00000564 <write>:
SYSCALL(write)
 564:	b8 10 00 00 00       	mov    $0x10,%eax
 569:	cd 40                	int    $0x40
 56b:	c3                   	ret    

0000056c <close>:
SYSCALL(close)
 56c:	b8 15 00 00 00       	mov    $0x15,%eax
 571:	cd 40                	int    $0x40
 573:	c3                   	ret    

00000574 <kill>:
SYSCALL(kill)
 574:	b8 06 00 00 00       	mov    $0x6,%eax
 579:	cd 40                	int    $0x40
 57b:	c3                   	ret    

0000057c <exec>:
SYSCALL(exec)
 57c:	b8 07 00 00 00       	mov    $0x7,%eax
 581:	cd 40                	int    $0x40
 583:	c3                   	ret    

00000584 <open>:
SYSCALL(open)
 584:	b8 0f 00 00 00       	mov    $0xf,%eax
 589:	cd 40                	int    $0x40
 58b:	c3                   	ret    

0000058c <mknod>:
SYSCALL(mknod)
 58c:	b8 11 00 00 00       	mov    $0x11,%eax
 591:	cd 40                	int    $0x40
 593:	c3                   	ret    

00000594 <unlink>:
SYSCALL(unlink)
 594:	b8 12 00 00 00       	mov    $0x12,%eax
 599:	cd 40                	int    $0x40
 59b:	c3                   	ret    

0000059c <fstat>:
SYSCALL(fstat)
 59c:	b8 08 00 00 00       	mov    $0x8,%eax
 5a1:	cd 40                	int    $0x40
 5a3:	c3                   	ret    

000005a4 <link>:
SYSCALL(link)
 5a4:	b8 13 00 00 00       	mov    $0x13,%eax
 5a9:	cd 40                	int    $0x40
 5ab:	c3                   	ret    

000005ac <mkdir>:
SYSCALL(mkdir)
 5ac:	b8 14 00 00 00       	mov    $0x14,%eax
 5b1:	cd 40                	int    $0x40
 5b3:	c3                   	ret    

000005b4 <chdir>:
SYSCALL(chdir)
 5b4:	b8 09 00 00 00       	mov    $0x9,%eax
 5b9:	cd 40                	int    $0x40
 5bb:	c3                   	ret    

000005bc <dup>:
SYSCALL(dup)
 5bc:	b8 0a 00 00 00       	mov    $0xa,%eax
 5c1:	cd 40                	int    $0x40
 5c3:	c3                   	ret    

000005c4 <getpid>:
SYSCALL(getpid)
 5c4:	b8 0b 00 00 00       	mov    $0xb,%eax
 5c9:	cd 40                	int    $0x40
 5cb:	c3                   	ret    

000005cc <sbrk>:
SYSCALL(sbrk)
 5cc:	b8 0c 00 00 00       	mov    $0xc,%eax
 5d1:	cd 40                	int    $0x40
 5d3:	c3                   	ret    

000005d4 <sleep>:
SYSCALL(sleep)
 5d4:	b8 0d 00 00 00       	mov    $0xd,%eax
 5d9:	cd 40                	int    $0x40
 5db:	c3                   	ret    

000005dc <uptime>:
SYSCALL(uptime)
 5dc:	b8 0e 00 00 00       	mov    $0xe,%eax
 5e1:	cd 40                	int    $0x40
 5e3:	c3                   	ret    

000005e4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5e4:	55                   	push   %ebp
 5e5:	89 e5                	mov    %esp,%ebp
 5e7:	83 ec 18             	sub    $0x18,%esp
 5ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 5ed:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5f0:	83 ec 04             	sub    $0x4,%esp
 5f3:	6a 01                	push   $0x1
 5f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5f8:	50                   	push   %eax
 5f9:	ff 75 08             	pushl  0x8(%ebp)
 5fc:	e8 63 ff ff ff       	call   564 <write>
 601:	83 c4 10             	add    $0x10,%esp
}
 604:	c9                   	leave  
 605:	c3                   	ret    

00000606 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 606:	55                   	push   %ebp
 607:	89 e5                	mov    %esp,%ebp
 609:	83 ec 38             	sub    $0x38,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 60c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 613:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 617:	74 17                	je     630 <printint+0x2a>
 619:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 61d:	79 11                	jns    630 <printint+0x2a>
    neg = 1;
 61f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 626:	8b 45 0c             	mov    0xc(%ebp),%eax
 629:	f7 d8                	neg    %eax
 62b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 62e:	eb 06                	jmp    636 <printint+0x30>
  } else {
    x = xx;
 630:	8b 45 0c             	mov    0xc(%ebp),%eax
 633:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 636:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 63d:	8b 4d 10             	mov    0x10(%ebp),%ecx
 640:	8b 45 ec             	mov    -0x14(%ebp),%eax
 643:	ba 00 00 00 00       	mov    $0x0,%edx
 648:	f7 f1                	div    %ecx
 64a:	89 d0                	mov    %edx,%eax
 64c:	8a 90 98 0a 00 00    	mov    0xa98(%eax),%dl
 652:	8d 45 dc             	lea    -0x24(%ebp),%eax
 655:	03 45 f4             	add    -0xc(%ebp),%eax
 658:	88 10                	mov    %dl,(%eax)
 65a:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 65d:	8b 45 10             	mov    0x10(%ebp),%eax
 660:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 663:	8b 45 ec             	mov    -0x14(%ebp),%eax
 666:	ba 00 00 00 00       	mov    $0x0,%edx
 66b:	f7 75 d4             	divl   -0x2c(%ebp)
 66e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 671:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 675:	75 c6                	jne    63d <printint+0x37>
  if(neg)
 677:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 67b:	74 28                	je     6a5 <printint+0x9f>
    buf[i++] = '-';
 67d:	8d 45 dc             	lea    -0x24(%ebp),%eax
 680:	03 45 f4             	add    -0xc(%ebp),%eax
 683:	c6 00 2d             	movb   $0x2d,(%eax)
 686:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 689:	eb 1a                	jmp    6a5 <printint+0x9f>
    putc(fd, buf[i]);
 68b:	8d 45 dc             	lea    -0x24(%ebp),%eax
 68e:	03 45 f4             	add    -0xc(%ebp),%eax
 691:	8a 00                	mov    (%eax),%al
 693:	0f be c0             	movsbl %al,%eax
 696:	83 ec 08             	sub    $0x8,%esp
 699:	50                   	push   %eax
 69a:	ff 75 08             	pushl  0x8(%ebp)
 69d:	e8 42 ff ff ff       	call   5e4 <putc>
 6a2:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6a5:	ff 4d f4             	decl   -0xc(%ebp)
 6a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6ac:	79 dd                	jns    68b <printint+0x85>
    putc(fd, buf[i]);
}
 6ae:	c9                   	leave  
 6af:	c3                   	ret    

000006b0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6b0:	55                   	push   %ebp
 6b1:	89 e5                	mov    %esp,%ebp
 6b3:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6b6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 6bd:	8d 45 0c             	lea    0xc(%ebp),%eax
 6c0:	83 c0 04             	add    $0x4,%eax
 6c3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6c6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6cd:	e9 58 01 00 00       	jmp    82a <printf+0x17a>
    c = fmt[i] & 0xff;
 6d2:	8b 55 0c             	mov    0xc(%ebp),%edx
 6d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6d8:	8d 04 02             	lea    (%edx,%eax,1),%eax
 6db:	8a 00                	mov    (%eax),%al
 6dd:	0f be c0             	movsbl %al,%eax
 6e0:	25 ff 00 00 00       	and    $0xff,%eax
 6e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 6e8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6ec:	75 2c                	jne    71a <printf+0x6a>
      if(c == '%'){
 6ee:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6f2:	75 0c                	jne    700 <printf+0x50>
        state = '%';
 6f4:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 6fb:	e9 27 01 00 00       	jmp    827 <printf+0x177>
      } else {
        putc(fd, c);
 700:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 703:	0f be c0             	movsbl %al,%eax
 706:	83 ec 08             	sub    $0x8,%esp
 709:	50                   	push   %eax
 70a:	ff 75 08             	pushl  0x8(%ebp)
 70d:	e8 d2 fe ff ff       	call   5e4 <putc>
 712:	83 c4 10             	add    $0x10,%esp
 715:	e9 0d 01 00 00       	jmp    827 <printf+0x177>
      }
    } else if(state == '%'){
 71a:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 71e:	0f 85 03 01 00 00    	jne    827 <printf+0x177>
      if(c == 'd'){
 724:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 728:	75 1e                	jne    748 <printf+0x98>
        printint(fd, *ap, 10, 1);
 72a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 72d:	8b 00                	mov    (%eax),%eax
 72f:	6a 01                	push   $0x1
 731:	6a 0a                	push   $0xa
 733:	50                   	push   %eax
 734:	ff 75 08             	pushl  0x8(%ebp)
 737:	e8 ca fe ff ff       	call   606 <printint>
 73c:	83 c4 10             	add    $0x10,%esp
        ap++;
 73f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 743:	e9 d8 00 00 00       	jmp    820 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 748:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 74c:	74 06                	je     754 <printf+0xa4>
 74e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 752:	75 1e                	jne    772 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 754:	8b 45 e8             	mov    -0x18(%ebp),%eax
 757:	8b 00                	mov    (%eax),%eax
 759:	6a 00                	push   $0x0
 75b:	6a 10                	push   $0x10
 75d:	50                   	push   %eax
 75e:	ff 75 08             	pushl  0x8(%ebp)
 761:	e8 a0 fe ff ff       	call   606 <printint>
 766:	83 c4 10             	add    $0x10,%esp
        ap++;
 769:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 76d:	e9 ae 00 00 00       	jmp    820 <printf+0x170>
      } else if(c == 's'){
 772:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 776:	75 43                	jne    7bb <printf+0x10b>
        s = (char*)*ap;
 778:	8b 45 e8             	mov    -0x18(%ebp),%eax
 77b:	8b 00                	mov    (%eax),%eax
 77d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 780:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 784:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 788:	75 25                	jne    7af <printf+0xff>
          s = "(null)";
 78a:	c7 45 f4 8e 0a 00 00 	movl   $0xa8e,-0xc(%ebp)
        while(*s != 0){
 791:	eb 1d                	jmp    7b0 <printf+0x100>
          putc(fd, *s);
 793:	8b 45 f4             	mov    -0xc(%ebp),%eax
 796:	8a 00                	mov    (%eax),%al
 798:	0f be c0             	movsbl %al,%eax
 79b:	83 ec 08             	sub    $0x8,%esp
 79e:	50                   	push   %eax
 79f:	ff 75 08             	pushl  0x8(%ebp)
 7a2:	e8 3d fe ff ff       	call   5e4 <putc>
 7a7:	83 c4 10             	add    $0x10,%esp
          s++;
 7aa:	ff 45 f4             	incl   -0xc(%ebp)
 7ad:	eb 01                	jmp    7b0 <printf+0x100>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7af:	90                   	nop
 7b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b3:	8a 00                	mov    (%eax),%al
 7b5:	84 c0                	test   %al,%al
 7b7:	75 da                	jne    793 <printf+0xe3>
 7b9:	eb 65                	jmp    820 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7bb:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7bf:	75 1d                	jne    7de <printf+0x12e>
        putc(fd, *ap);
 7c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7c4:	8b 00                	mov    (%eax),%eax
 7c6:	0f be c0             	movsbl %al,%eax
 7c9:	83 ec 08             	sub    $0x8,%esp
 7cc:	50                   	push   %eax
 7cd:	ff 75 08             	pushl  0x8(%ebp)
 7d0:	e8 0f fe ff ff       	call   5e4 <putc>
 7d5:	83 c4 10             	add    $0x10,%esp
        ap++;
 7d8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7dc:	eb 42                	jmp    820 <printf+0x170>
      } else if(c == '%'){
 7de:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7e2:	75 17                	jne    7fb <printf+0x14b>
        putc(fd, c);
 7e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7e7:	0f be c0             	movsbl %al,%eax
 7ea:	83 ec 08             	sub    $0x8,%esp
 7ed:	50                   	push   %eax
 7ee:	ff 75 08             	pushl  0x8(%ebp)
 7f1:	e8 ee fd ff ff       	call   5e4 <putc>
 7f6:	83 c4 10             	add    $0x10,%esp
 7f9:	eb 25                	jmp    820 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7fb:	83 ec 08             	sub    $0x8,%esp
 7fe:	6a 25                	push   $0x25
 800:	ff 75 08             	pushl  0x8(%ebp)
 803:	e8 dc fd ff ff       	call   5e4 <putc>
 808:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 80b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 80e:	0f be c0             	movsbl %al,%eax
 811:	83 ec 08             	sub    $0x8,%esp
 814:	50                   	push   %eax
 815:	ff 75 08             	pushl  0x8(%ebp)
 818:	e8 c7 fd ff ff       	call   5e4 <putc>
 81d:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 820:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 827:	ff 45 f0             	incl   -0x10(%ebp)
 82a:	8b 55 0c             	mov    0xc(%ebp),%edx
 82d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 830:	8d 04 02             	lea    (%edx,%eax,1),%eax
 833:	8a 00                	mov    (%eax),%al
 835:	84 c0                	test   %al,%al
 837:	0f 85 95 fe ff ff    	jne    6d2 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 83d:	c9                   	leave  
 83e:	c3                   	ret    
 83f:	90                   	nop

00000840 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 840:	55                   	push   %ebp
 841:	89 e5                	mov    %esp,%ebp
 843:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 846:	8b 45 08             	mov    0x8(%ebp),%eax
 849:	83 e8 08             	sub    $0x8,%eax
 84c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 84f:	a1 c8 0a 00 00       	mov    0xac8,%eax
 854:	89 45 fc             	mov    %eax,-0x4(%ebp)
 857:	eb 24                	jmp    87d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 859:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85c:	8b 00                	mov    (%eax),%eax
 85e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 861:	77 12                	ja     875 <free+0x35>
 863:	8b 45 f8             	mov    -0x8(%ebp),%eax
 866:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 869:	77 24                	ja     88f <free+0x4f>
 86b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86e:	8b 00                	mov    (%eax),%eax
 870:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 873:	77 1a                	ja     88f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 875:	8b 45 fc             	mov    -0x4(%ebp),%eax
 878:	8b 00                	mov    (%eax),%eax
 87a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 87d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 880:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 883:	76 d4                	jbe    859 <free+0x19>
 885:	8b 45 fc             	mov    -0x4(%ebp),%eax
 888:	8b 00                	mov    (%eax),%eax
 88a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 88d:	76 ca                	jbe    859 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 88f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 892:	8b 40 04             	mov    0x4(%eax),%eax
 895:	c1 e0 03             	shl    $0x3,%eax
 898:	89 c2                	mov    %eax,%edx
 89a:	03 55 f8             	add    -0x8(%ebp),%edx
 89d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a0:	8b 00                	mov    (%eax),%eax
 8a2:	39 c2                	cmp    %eax,%edx
 8a4:	75 24                	jne    8ca <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 8a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8a9:	8b 50 04             	mov    0x4(%eax),%edx
 8ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8af:	8b 00                	mov    (%eax),%eax
 8b1:	8b 40 04             	mov    0x4(%eax),%eax
 8b4:	01 c2                	add    %eax,%edx
 8b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b9:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8bf:	8b 00                	mov    (%eax),%eax
 8c1:	8b 10                	mov    (%eax),%edx
 8c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c6:	89 10                	mov    %edx,(%eax)
 8c8:	eb 0a                	jmp    8d4 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 8ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8cd:	8b 10                	mov    (%eax),%edx
 8cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d2:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d7:	8b 40 04             	mov    0x4(%eax),%eax
 8da:	c1 e0 03             	shl    $0x3,%eax
 8dd:	03 45 fc             	add    -0x4(%ebp),%eax
 8e0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8e3:	75 20                	jne    905 <free+0xc5>
    p->s.size += bp->s.size;
 8e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e8:	8b 50 04             	mov    0x4(%eax),%edx
 8eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ee:	8b 40 04             	mov    0x4(%eax),%eax
 8f1:	01 c2                	add    %eax,%edx
 8f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f6:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8fc:	8b 10                	mov    (%eax),%edx
 8fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 901:	89 10                	mov    %edx,(%eax)
 903:	eb 08                	jmp    90d <free+0xcd>
  } else
    p->s.ptr = bp;
 905:	8b 45 fc             	mov    -0x4(%ebp),%eax
 908:	8b 55 f8             	mov    -0x8(%ebp),%edx
 90b:	89 10                	mov    %edx,(%eax)
  freep = p;
 90d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 910:	a3 c8 0a 00 00       	mov    %eax,0xac8
}
 915:	c9                   	leave  
 916:	c3                   	ret    

00000917 <morecore>:

static Header*
morecore(uint nu)
{
 917:	55                   	push   %ebp
 918:	89 e5                	mov    %esp,%ebp
 91a:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 91d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 924:	77 07                	ja     92d <morecore+0x16>
    nu = 4096;
 926:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 92d:	8b 45 08             	mov    0x8(%ebp),%eax
 930:	c1 e0 03             	shl    $0x3,%eax
 933:	83 ec 0c             	sub    $0xc,%esp
 936:	50                   	push   %eax
 937:	e8 90 fc ff ff       	call   5cc <sbrk>
 93c:	83 c4 10             	add    $0x10,%esp
 93f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 942:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 946:	75 07                	jne    94f <morecore+0x38>
    return 0;
 948:	b8 00 00 00 00       	mov    $0x0,%eax
 94d:	eb 26                	jmp    975 <morecore+0x5e>
  hp = (Header*)p;
 94f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 952:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 955:	8b 45 f0             	mov    -0x10(%ebp),%eax
 958:	8b 55 08             	mov    0x8(%ebp),%edx
 95b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 95e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 961:	83 c0 08             	add    $0x8,%eax
 964:	83 ec 0c             	sub    $0xc,%esp
 967:	50                   	push   %eax
 968:	e8 d3 fe ff ff       	call   840 <free>
 96d:	83 c4 10             	add    $0x10,%esp
  return freep;
 970:	a1 c8 0a 00 00       	mov    0xac8,%eax
}
 975:	c9                   	leave  
 976:	c3                   	ret    

00000977 <malloc>:

void*
malloc(uint nbytes)
{
 977:	55                   	push   %ebp
 978:	89 e5                	mov    %esp,%ebp
 97a:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 97d:	8b 45 08             	mov    0x8(%ebp),%eax
 980:	83 c0 07             	add    $0x7,%eax
 983:	c1 e8 03             	shr    $0x3,%eax
 986:	40                   	inc    %eax
 987:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 98a:	a1 c8 0a 00 00       	mov    0xac8,%eax
 98f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 992:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 996:	75 23                	jne    9bb <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 998:	c7 45 f0 c0 0a 00 00 	movl   $0xac0,-0x10(%ebp)
 99f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9a2:	a3 c8 0a 00 00       	mov    %eax,0xac8
 9a7:	a1 c8 0a 00 00       	mov    0xac8,%eax
 9ac:	a3 c0 0a 00 00       	mov    %eax,0xac0
    base.s.size = 0;
 9b1:	c7 05 c4 0a 00 00 00 	movl   $0x0,0xac4
 9b8:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9be:	8b 00                	mov    (%eax),%eax
 9c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c6:	8b 40 04             	mov    0x4(%eax),%eax
 9c9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9cc:	72 4d                	jb     a1b <malloc+0xa4>
      if(p->s.size == nunits)
 9ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d1:	8b 40 04             	mov    0x4(%eax),%eax
 9d4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9d7:	75 0c                	jne    9e5 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 9d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9dc:	8b 10                	mov    (%eax),%edx
 9de:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9e1:	89 10                	mov    %edx,(%eax)
 9e3:	eb 26                	jmp    a0b <malloc+0x94>
      else {
        p->s.size -= nunits;
 9e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e8:	8b 40 04             	mov    0x4(%eax),%eax
 9eb:	89 c2                	mov    %eax,%edx
 9ed:	2b 55 ec             	sub    -0x14(%ebp),%edx
 9f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f3:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f9:	8b 40 04             	mov    0x4(%eax),%eax
 9fc:	c1 e0 03             	shl    $0x3,%eax
 9ff:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a05:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a08:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a0e:	a3 c8 0a 00 00       	mov    %eax,0xac8
      return (void*)(p + 1);
 a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a16:	83 c0 08             	add    $0x8,%eax
 a19:	eb 3b                	jmp    a56 <malloc+0xdf>
    }
    if(p == freep)
 a1b:	a1 c8 0a 00 00       	mov    0xac8,%eax
 a20:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a23:	75 1e                	jne    a43 <malloc+0xcc>
      if((p = morecore(nunits)) == 0)
 a25:	83 ec 0c             	sub    $0xc,%esp
 a28:	ff 75 ec             	pushl  -0x14(%ebp)
 a2b:	e8 e7 fe ff ff       	call   917 <morecore>
 a30:	83 c4 10             	add    $0x10,%esp
 a33:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a3a:	75 07                	jne    a43 <malloc+0xcc>
        return 0;
 a3c:	b8 00 00 00 00       	mov    $0x0,%eax
 a41:	eb 13                	jmp    a56 <malloc+0xdf>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a46:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4c:	8b 00                	mov    (%eax),%eax
 a4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a51:	e9 6d ff ff ff       	jmp    9c3 <malloc+0x4c>
}
 a56:	c9                   	leave  
 a57:	c3                   	ret    
