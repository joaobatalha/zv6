
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <runcmd>:
struct cmd *parsecmd(char*);

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
       6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
       a:	75 05                	jne    11 <runcmd+0x11>
    exit();
       c:	e8 87 0e 00 00       	call   e98 <exit>
  
  switch(cmd->type){
      11:	8b 45 08             	mov    0x8(%ebp),%eax
      14:	8b 00                	mov    (%eax),%eax
      16:	83 f8 05             	cmp    $0x5,%eax
      19:	77 09                	ja     24 <runcmd+0x24>
      1b:	8b 04 85 d8 13 00 00 	mov    0x13d8(,%eax,4),%eax
      22:	ff e0                	jmp    *%eax
  default:
    panic("runcmd");
      24:	83 ec 0c             	sub    $0xc,%esp
      27:	68 ac 13 00 00       	push   $0x13ac
      2c:	e8 69 03 00 00       	call   39a <panic>
      31:	83 c4 10             	add    $0x10,%esp

  case EXEC:
    ecmd = (struct execcmd*)cmd;
      34:	8b 45 08             	mov    0x8(%ebp),%eax
      37:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ecmd->argv[0] == 0)
      3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
      3d:	8b 40 04             	mov    0x4(%eax),%eax
      40:	85 c0                	test   %eax,%eax
      42:	75 05                	jne    49 <runcmd+0x49>
      exit();
      44:	e8 4f 0e 00 00       	call   e98 <exit>
    exec(ecmd->argv[0], ecmd->argv);
      49:	8b 45 f4             	mov    -0xc(%ebp),%eax
      4c:	8d 50 04             	lea    0x4(%eax),%edx
      4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
      52:	8b 40 04             	mov    0x4(%eax),%eax
      55:	83 ec 08             	sub    $0x8,%esp
      58:	52                   	push   %edx
      59:	50                   	push   %eax
      5a:	e8 71 0e 00 00       	call   ed0 <exec>
      5f:	83 c4 10             	add    $0x10,%esp
    printf(2, "exec %s failed\n", ecmd->argv[0]);
      62:	8b 45 f4             	mov    -0xc(%ebp),%eax
      65:	8b 40 04             	mov    0x4(%eax),%eax
      68:	83 ec 04             	sub    $0x4,%esp
      6b:	50                   	push   %eax
      6c:	68 b3 13 00 00       	push   $0x13b3
      71:	6a 02                	push   $0x2
      73:	e8 8c 0f 00 00       	call   1004 <printf>
      78:	83 c4 10             	add    $0x10,%esp
    break;
      7b:	e9 c8 01 00 00       	jmp    248 <runcmd+0x248>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
      80:	8b 45 08             	mov    0x8(%ebp),%eax
      83:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(rcmd->fd);
      86:	8b 45 f0             	mov    -0x10(%ebp),%eax
      89:	8b 40 14             	mov    0x14(%eax),%eax
      8c:	83 ec 0c             	sub    $0xc,%esp
      8f:	50                   	push   %eax
      90:	e8 2b 0e 00 00       	call   ec0 <close>
      95:	83 c4 10             	add    $0x10,%esp
    if(open(rcmd->file, rcmd->mode) < 0){
      98:	8b 45 f0             	mov    -0x10(%ebp),%eax
      9b:	8b 50 10             	mov    0x10(%eax),%edx
      9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
      a1:	8b 40 08             	mov    0x8(%eax),%eax
      a4:	83 ec 08             	sub    $0x8,%esp
      a7:	52                   	push   %edx
      a8:	50                   	push   %eax
      a9:	e8 2a 0e 00 00       	call   ed8 <open>
      ae:	83 c4 10             	add    $0x10,%esp
      b1:	85 c0                	test   %eax,%eax
      b3:	79 1e                	jns    d3 <runcmd+0xd3>
      printf(2, "open %s failed\n", rcmd->file);
      b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
      b8:	8b 40 08             	mov    0x8(%eax),%eax
      bb:	83 ec 04             	sub    $0x4,%esp
      be:	50                   	push   %eax
      bf:	68 c3 13 00 00       	push   $0x13c3
      c4:	6a 02                	push   $0x2
      c6:	e8 39 0f 00 00       	call   1004 <printf>
      cb:	83 c4 10             	add    $0x10,%esp
      exit();
      ce:	e8 c5 0d 00 00       	call   e98 <exit>
    }
    runcmd(rcmd->cmd);
      d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
      d6:	8b 40 04             	mov    0x4(%eax),%eax
      d9:	83 ec 0c             	sub    $0xc,%esp
      dc:	50                   	push   %eax
      dd:	e8 1e ff ff ff       	call   0 <runcmd>
      e2:	83 c4 10             	add    $0x10,%esp
    break;
      e5:	e9 5e 01 00 00       	jmp    248 <runcmd+0x248>

  case LIST:
    lcmd = (struct listcmd*)cmd;
      ea:	8b 45 08             	mov    0x8(%ebp),%eax
      ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fork1() == 0)
      f0:	e8 c5 02 00 00       	call   3ba <fork1>
      f5:	85 c0                	test   %eax,%eax
      f7:	75 12                	jne    10b <runcmd+0x10b>
      runcmd(lcmd->left);
      f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
      fc:	8b 40 04             	mov    0x4(%eax),%eax
      ff:	83 ec 0c             	sub    $0xc,%esp
     102:	50                   	push   %eax
     103:	e8 f8 fe ff ff       	call   0 <runcmd>
     108:	83 c4 10             	add    $0x10,%esp
    wait();
     10b:	e8 90 0d 00 00       	call   ea0 <wait>
    runcmd(lcmd->right);
     110:	8b 45 ec             	mov    -0x14(%ebp),%eax
     113:	8b 40 08             	mov    0x8(%eax),%eax
     116:	83 ec 0c             	sub    $0xc,%esp
     119:	50                   	push   %eax
     11a:	e8 e1 fe ff ff       	call   0 <runcmd>
     11f:	83 c4 10             	add    $0x10,%esp
    break;
     122:	e9 21 01 00 00       	jmp    248 <runcmd+0x248>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     127:	8b 45 08             	mov    0x8(%ebp),%eax
     12a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pipe(p) < 0)
     12d:	83 ec 0c             	sub    $0xc,%esp
     130:	8d 45 dc             	lea    -0x24(%ebp),%eax
     133:	50                   	push   %eax
     134:	e8 6f 0d 00 00       	call   ea8 <pipe>
     139:	83 c4 10             	add    $0x10,%esp
     13c:	85 c0                	test   %eax,%eax
     13e:	79 10                	jns    150 <runcmd+0x150>
      panic("pipe");
     140:	83 ec 0c             	sub    $0xc,%esp
     143:	68 d3 13 00 00       	push   $0x13d3
     148:	e8 4d 02 00 00       	call   39a <panic>
     14d:	83 c4 10             	add    $0x10,%esp
    if(fork1() == 0){
     150:	e8 65 02 00 00       	call   3ba <fork1>
     155:	85 c0                	test   %eax,%eax
     157:	75 4c                	jne    1a5 <runcmd+0x1a5>
      close(1);
     159:	83 ec 0c             	sub    $0xc,%esp
     15c:	6a 01                	push   $0x1
     15e:	e8 5d 0d 00 00       	call   ec0 <close>
     163:	83 c4 10             	add    $0x10,%esp
      dup(p[1]);
     166:	8b 45 e0             	mov    -0x20(%ebp),%eax
     169:	83 ec 0c             	sub    $0xc,%esp
     16c:	50                   	push   %eax
     16d:	e8 9e 0d 00 00       	call   f10 <dup>
     172:	83 c4 10             	add    $0x10,%esp
      close(p[0]);
     175:	8b 45 dc             	mov    -0x24(%ebp),%eax
     178:	83 ec 0c             	sub    $0xc,%esp
     17b:	50                   	push   %eax
     17c:	e8 3f 0d 00 00       	call   ec0 <close>
     181:	83 c4 10             	add    $0x10,%esp
      close(p[1]);
     184:	8b 45 e0             	mov    -0x20(%ebp),%eax
     187:	83 ec 0c             	sub    $0xc,%esp
     18a:	50                   	push   %eax
     18b:	e8 30 0d 00 00       	call   ec0 <close>
     190:	83 c4 10             	add    $0x10,%esp
      runcmd(pcmd->left);
     193:	8b 45 e8             	mov    -0x18(%ebp),%eax
     196:	8b 40 04             	mov    0x4(%eax),%eax
     199:	83 ec 0c             	sub    $0xc,%esp
     19c:	50                   	push   %eax
     19d:	e8 5e fe ff ff       	call   0 <runcmd>
     1a2:	83 c4 10             	add    $0x10,%esp
    }
    if(fork1() == 0){
     1a5:	e8 10 02 00 00       	call   3ba <fork1>
     1aa:	85 c0                	test   %eax,%eax
     1ac:	75 4c                	jne    1fa <runcmd+0x1fa>
      close(0);
     1ae:	83 ec 0c             	sub    $0xc,%esp
     1b1:	6a 00                	push   $0x0
     1b3:	e8 08 0d 00 00       	call   ec0 <close>
     1b8:	83 c4 10             	add    $0x10,%esp
      dup(p[0]);
     1bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1be:	83 ec 0c             	sub    $0xc,%esp
     1c1:	50                   	push   %eax
     1c2:	e8 49 0d 00 00       	call   f10 <dup>
     1c7:	83 c4 10             	add    $0x10,%esp
      close(p[0]);
     1ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1cd:	83 ec 0c             	sub    $0xc,%esp
     1d0:	50                   	push   %eax
     1d1:	e8 ea 0c 00 00       	call   ec0 <close>
     1d6:	83 c4 10             	add    $0x10,%esp
      close(p[1]);
     1d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1dc:	83 ec 0c             	sub    $0xc,%esp
     1df:	50                   	push   %eax
     1e0:	e8 db 0c 00 00       	call   ec0 <close>
     1e5:	83 c4 10             	add    $0x10,%esp
      runcmd(pcmd->right);
     1e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
     1eb:	8b 40 08             	mov    0x8(%eax),%eax
     1ee:	83 ec 0c             	sub    $0xc,%esp
     1f1:	50                   	push   %eax
     1f2:	e8 09 fe ff ff       	call   0 <runcmd>
     1f7:	83 c4 10             	add    $0x10,%esp
    }
    close(p[0]);
     1fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1fd:	83 ec 0c             	sub    $0xc,%esp
     200:	50                   	push   %eax
     201:	e8 ba 0c 00 00       	call   ec0 <close>
     206:	83 c4 10             	add    $0x10,%esp
    close(p[1]);
     209:	8b 45 e0             	mov    -0x20(%ebp),%eax
     20c:	83 ec 0c             	sub    $0xc,%esp
     20f:	50                   	push   %eax
     210:	e8 ab 0c 00 00       	call   ec0 <close>
     215:	83 c4 10             	add    $0x10,%esp
    wait();
     218:	e8 83 0c 00 00       	call   ea0 <wait>
    wait();
     21d:	e8 7e 0c 00 00       	call   ea0 <wait>
    break;
     222:	eb 24                	jmp    248 <runcmd+0x248>
    
  case BACK:
    bcmd = (struct backcmd*)cmd;
     224:	8b 45 08             	mov    0x8(%ebp),%eax
     227:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(fork1() == 0)
     22a:	e8 8b 01 00 00       	call   3ba <fork1>
     22f:	85 c0                	test   %eax,%eax
     231:	75 14                	jne    247 <runcmd+0x247>
      runcmd(bcmd->cmd);
     233:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     236:	8b 40 04             	mov    0x4(%eax),%eax
     239:	83 ec 0c             	sub    $0xc,%esp
     23c:	50                   	push   %eax
     23d:	e8 be fd ff ff       	call   0 <runcmd>
     242:	83 c4 10             	add    $0x10,%esp
    break;
     245:	eb 01                	jmp    248 <runcmd+0x248>
     247:	90                   	nop
  }
  exit();
     248:	e8 4b 0c 00 00       	call   e98 <exit>

0000024d <getcmd>:
}

int
getcmd(char *buf, int nbuf)
{
     24d:	55                   	push   %ebp
     24e:	89 e5                	mov    %esp,%ebp
     250:	83 ec 08             	sub    $0x8,%esp
  printf(2, "$ ");
     253:	83 ec 08             	sub    $0x8,%esp
     256:	68 f0 13 00 00       	push   $0x13f0
     25b:	6a 02                	push   $0x2
     25d:	e8 a2 0d 00 00       	call   1004 <printf>
     262:	83 c4 10             	add    $0x10,%esp
  memset(buf, 0, nbuf);
     265:	8b 45 0c             	mov    0xc(%ebp),%eax
     268:	83 ec 04             	sub    $0x4,%esp
     26b:	50                   	push   %eax
     26c:	6a 00                	push   $0x0
     26e:	ff 75 08             	pushl  0x8(%ebp)
     271:	e8 a0 0a 00 00       	call   d16 <memset>
     276:	83 c4 10             	add    $0x10,%esp
  gets(buf, nbuf);
     279:	83 ec 08             	sub    $0x8,%esp
     27c:	ff 75 0c             	pushl  0xc(%ebp)
     27f:	ff 75 08             	pushl  0x8(%ebp)
     282:	e8 d9 0a 00 00       	call   d60 <gets>
     287:	83 c4 10             	add    $0x10,%esp
  if(buf[0] == 0) // EOF
     28a:	8b 45 08             	mov    0x8(%ebp),%eax
     28d:	8a 00                	mov    (%eax),%al
     28f:	84 c0                	test   %al,%al
     291:	75 07                	jne    29a <getcmd+0x4d>
    return -1;
     293:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     298:	eb 05                	jmp    29f <getcmd+0x52>
  return 0;
     29a:	b8 00 00 00 00       	mov    $0x0,%eax
}
     29f:	c9                   	leave  
     2a0:	c3                   	ret    

000002a1 <main>:

int
main(void)
{
     2a1:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     2a5:	83 e4 f0             	and    $0xfffffff0,%esp
     2a8:	ff 71 fc             	pushl  -0x4(%ecx)
     2ab:	55                   	push   %ebp
     2ac:	89 e5                	mov    %esp,%ebp
     2ae:	51                   	push   %ecx
     2af:	83 ec 14             	sub    $0x14,%esp
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     2b2:	eb 1a                	jmp    2ce <main+0x2d>
    if(fd >= 3){
     2b4:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
     2b8:	7e 14                	jle    2ce <main+0x2d>
      close(fd);
     2ba:	83 ec 0c             	sub    $0xc,%esp
     2bd:	ff 75 f4             	pushl  -0xc(%ebp)
     2c0:	e8 fb 0b 00 00       	call   ec0 <close>
     2c5:	83 c4 10             	add    $0x10,%esp
      break;
     2c8:	90                   	nop
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     2c9:	e9 ad 00 00 00       	jmp    37b <main+0xda>
{
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     2ce:	83 ec 08             	sub    $0x8,%esp
     2d1:	6a 02                	push   $0x2
     2d3:	68 f3 13 00 00       	push   $0x13f3
     2d8:	e8 fb 0b 00 00       	call   ed8 <open>
     2dd:	83 c4 10             	add    $0x10,%esp
     2e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
     2e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     2e7:	79 cb                	jns    2b4 <main+0x13>
      break;
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     2e9:	e9 8d 00 00 00       	jmp    37b <main+0xda>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     2ee:	a0 e0 14 00 00       	mov    0x14e0,%al
     2f3:	3c 63                	cmp    $0x63,%al
     2f5:	75 57                	jne    34e <main+0xad>
     2f7:	a0 e1 14 00 00       	mov    0x14e1,%al
     2fc:	3c 64                	cmp    $0x64,%al
     2fe:	75 4e                	jne    34e <main+0xad>
     300:	a0 e2 14 00 00       	mov    0x14e2,%al
     305:	3c 20                	cmp    $0x20,%al
     307:	75 45                	jne    34e <main+0xad>
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     309:	83 ec 0c             	sub    $0xc,%esp
     30c:	68 e0 14 00 00       	push   $0x14e0
     311:	e8 dd 09 00 00       	call   cf3 <strlen>
     316:	83 c4 10             	add    $0x10,%esp
     319:	48                   	dec    %eax
     31a:	c6 80 e0 14 00 00 00 	movb   $0x0,0x14e0(%eax)
      if(chdir(buf+3) < 0)
     321:	83 ec 0c             	sub    $0xc,%esp
     324:	68 e3 14 00 00       	push   $0x14e3
     329:	e8 da 0b 00 00       	call   f08 <chdir>
     32e:	83 c4 10             	add    $0x10,%esp
     331:	85 c0                	test   %eax,%eax
     333:	79 45                	jns    37a <main+0xd9>
        printf(2, "cannot cd %s\n", buf+3);
     335:	83 ec 04             	sub    $0x4,%esp
     338:	68 e3 14 00 00       	push   $0x14e3
     33d:	68 fb 13 00 00       	push   $0x13fb
     342:	6a 02                	push   $0x2
     344:	e8 bb 0c 00 00       	call   1004 <printf>
     349:	83 c4 10             	add    $0x10,%esp
      continue;
     34c:	eb 2d                	jmp    37b <main+0xda>
    }
    if(fork1() == 0)
     34e:	e8 67 00 00 00       	call   3ba <fork1>
     353:	85 c0                	test   %eax,%eax
     355:	75 1c                	jne    373 <main+0xd2>
      runcmd(parsecmd(buf));
     357:	83 ec 0c             	sub    $0xc,%esp
     35a:	68 e0 14 00 00       	push   $0x14e0
     35f:	e8 97 03 00 00       	call   6fb <parsecmd>
     364:	83 c4 10             	add    $0x10,%esp
     367:	83 ec 0c             	sub    $0xc,%esp
     36a:	50                   	push   %eax
     36b:	e8 90 fc ff ff       	call   0 <runcmd>
     370:	83 c4 10             	add    $0x10,%esp
    wait();
     373:	e8 28 0b 00 00       	call   ea0 <wait>
     378:	eb 01                	jmp    37b <main+0xda>
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
      if(chdir(buf+3) < 0)
        printf(2, "cannot cd %s\n", buf+3);
      continue;
     37a:	90                   	nop
      break;
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     37b:	83 ec 08             	sub    $0x8,%esp
     37e:	6a 64                	push   $0x64
     380:	68 e0 14 00 00       	push   $0x14e0
     385:	e8 c3 fe ff ff       	call   24d <getcmd>
     38a:	83 c4 10             	add    $0x10,%esp
     38d:	85 c0                	test   %eax,%eax
     38f:	0f 89 59 ff ff ff    	jns    2ee <main+0x4d>
    }
    if(fork1() == 0)
      runcmd(parsecmd(buf));
    wait();
  }
  exit();
     395:	e8 fe 0a 00 00       	call   e98 <exit>

0000039a <panic>:
}

void
panic(char *s)
{
     39a:	55                   	push   %ebp
     39b:	89 e5                	mov    %esp,%ebp
     39d:	83 ec 08             	sub    $0x8,%esp
  printf(2, "%s\n", s);
     3a0:	83 ec 04             	sub    $0x4,%esp
     3a3:	ff 75 08             	pushl  0x8(%ebp)
     3a6:	68 09 14 00 00       	push   $0x1409
     3ab:	6a 02                	push   $0x2
     3ad:	e8 52 0c 00 00       	call   1004 <printf>
     3b2:	83 c4 10             	add    $0x10,%esp
  exit();
     3b5:	e8 de 0a 00 00       	call   e98 <exit>

000003ba <fork1>:
}

int
fork1(void)
{
     3ba:	55                   	push   %ebp
     3bb:	89 e5                	mov    %esp,%ebp
     3bd:	83 ec 18             	sub    $0x18,%esp
  int pid;
  
  pid = fork();
     3c0:	e8 cb 0a 00 00       	call   e90 <fork>
     3c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid == -1)
     3c8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     3cc:	75 10                	jne    3de <fork1+0x24>
    panic("fork");
     3ce:	83 ec 0c             	sub    $0xc,%esp
     3d1:	68 0d 14 00 00       	push   $0x140d
     3d6:	e8 bf ff ff ff       	call   39a <panic>
     3db:	83 c4 10             	add    $0x10,%esp
  return pid;
     3de:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     3e1:	c9                   	leave  
     3e2:	c3                   	ret    

000003e3 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     3e3:	55                   	push   %ebp
     3e4:	89 e5                	mov    %esp,%ebp
     3e6:	83 ec 18             	sub    $0x18,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3e9:	83 ec 0c             	sub    $0xc,%esp
     3ec:	6a 54                	push   $0x54
     3ee:	e8 d8 0e 00 00       	call   12cb <malloc>
     3f3:	83 c4 10             	add    $0x10,%esp
     3f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     3f9:	83 ec 04             	sub    $0x4,%esp
     3fc:	6a 54                	push   $0x54
     3fe:	6a 00                	push   $0x0
     400:	ff 75 f4             	pushl  -0xc(%ebp)
     403:	e8 0e 09 00 00       	call   d16 <memset>
     408:	83 c4 10             	add    $0x10,%esp
  cmd->type = EXEC;
     40b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     40e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  return (struct cmd*)cmd;
     414:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     417:	c9                   	leave  
     418:	c3                   	ret    

00000419 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     419:	55                   	push   %ebp
     41a:	89 e5                	mov    %esp,%ebp
     41c:	83 ec 18             	sub    $0x18,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     41f:	83 ec 0c             	sub    $0xc,%esp
     422:	6a 18                	push   $0x18
     424:	e8 a2 0e 00 00       	call   12cb <malloc>
     429:	83 c4 10             	add    $0x10,%esp
     42c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     42f:	83 ec 04             	sub    $0x4,%esp
     432:	6a 18                	push   $0x18
     434:	6a 00                	push   $0x0
     436:	ff 75 f4             	pushl  -0xc(%ebp)
     439:	e8 d8 08 00 00       	call   d16 <memset>
     43e:	83 c4 10             	add    $0x10,%esp
  cmd->type = REDIR;
     441:	8b 45 f4             	mov    -0xc(%ebp),%eax
     444:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  cmd->cmd = subcmd;
     44a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     44d:	8b 55 08             	mov    0x8(%ebp),%edx
     450:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->file = file;
     453:	8b 45 f4             	mov    -0xc(%ebp),%eax
     456:	8b 55 0c             	mov    0xc(%ebp),%edx
     459:	89 50 08             	mov    %edx,0x8(%eax)
  cmd->efile = efile;
     45c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     45f:	8b 55 10             	mov    0x10(%ebp),%edx
     462:	89 50 0c             	mov    %edx,0xc(%eax)
  cmd->mode = mode;
     465:	8b 45 f4             	mov    -0xc(%ebp),%eax
     468:	8b 55 14             	mov    0x14(%ebp),%edx
     46b:	89 50 10             	mov    %edx,0x10(%eax)
  cmd->fd = fd;
     46e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     471:	8b 55 18             	mov    0x18(%ebp),%edx
     474:	89 50 14             	mov    %edx,0x14(%eax)
  return (struct cmd*)cmd;
     477:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     47a:	c9                   	leave  
     47b:	c3                   	ret    

0000047c <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     47c:	55                   	push   %ebp
     47d:	89 e5                	mov    %esp,%ebp
     47f:	83 ec 18             	sub    $0x18,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     482:	83 ec 0c             	sub    $0xc,%esp
     485:	6a 0c                	push   $0xc
     487:	e8 3f 0e 00 00       	call   12cb <malloc>
     48c:	83 c4 10             	add    $0x10,%esp
     48f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     492:	83 ec 04             	sub    $0x4,%esp
     495:	6a 0c                	push   $0xc
     497:	6a 00                	push   $0x0
     499:	ff 75 f4             	pushl  -0xc(%ebp)
     49c:	e8 75 08 00 00       	call   d16 <memset>
     4a1:	83 c4 10             	add    $0x10,%esp
  cmd->type = PIPE;
     4a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4a7:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
  cmd->left = left;
     4ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4b0:	8b 55 08             	mov    0x8(%ebp),%edx
     4b3:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     4b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4b9:	8b 55 0c             	mov    0xc(%ebp),%edx
     4bc:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     4bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     4c2:	c9                   	leave  
     4c3:	c3                   	ret    

000004c4 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     4c4:	55                   	push   %ebp
     4c5:	89 e5                	mov    %esp,%ebp
     4c7:	83 ec 18             	sub    $0x18,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4ca:	83 ec 0c             	sub    $0xc,%esp
     4cd:	6a 0c                	push   $0xc
     4cf:	e8 f7 0d 00 00       	call   12cb <malloc>
     4d4:	83 c4 10             	add    $0x10,%esp
     4d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     4da:	83 ec 04             	sub    $0x4,%esp
     4dd:	6a 0c                	push   $0xc
     4df:	6a 00                	push   $0x0
     4e1:	ff 75 f4             	pushl  -0xc(%ebp)
     4e4:	e8 2d 08 00 00       	call   d16 <memset>
     4e9:	83 c4 10             	add    $0x10,%esp
  cmd->type = LIST;
     4ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4ef:	c7 00 04 00 00 00    	movl   $0x4,(%eax)
  cmd->left = left;
     4f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4f8:	8b 55 08             	mov    0x8(%ebp),%edx
     4fb:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     4fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
     501:	8b 55 0c             	mov    0xc(%ebp),%edx
     504:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     507:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     50a:	c9                   	leave  
     50b:	c3                   	ret    

0000050c <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     50c:	55                   	push   %ebp
     50d:	89 e5                	mov    %esp,%ebp
     50f:	83 ec 18             	sub    $0x18,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     512:	83 ec 0c             	sub    $0xc,%esp
     515:	6a 08                	push   $0x8
     517:	e8 af 0d 00 00       	call   12cb <malloc>
     51c:	83 c4 10             	add    $0x10,%esp
     51f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     522:	83 ec 04             	sub    $0x4,%esp
     525:	6a 08                	push   $0x8
     527:	6a 00                	push   $0x0
     529:	ff 75 f4             	pushl  -0xc(%ebp)
     52c:	e8 e5 07 00 00       	call   d16 <memset>
     531:	83 c4 10             	add    $0x10,%esp
  cmd->type = BACK;
     534:	8b 45 f4             	mov    -0xc(%ebp),%eax
     537:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
  cmd->cmd = subcmd;
     53d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     540:	8b 55 08             	mov    0x8(%ebp),%edx
     543:	89 50 04             	mov    %edx,0x4(%eax)
  return (struct cmd*)cmd;
     546:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     549:	c9                   	leave  
     54a:	c3                   	ret    

0000054b <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     54b:	55                   	push   %ebp
     54c:	89 e5                	mov    %esp,%ebp
     54e:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int ret;
  
  s = *ps;
     551:	8b 45 08             	mov    0x8(%ebp),%eax
     554:	8b 00                	mov    (%eax),%eax
     556:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     559:	eb 03                	jmp    55e <gettoken+0x13>
    s++;
     55b:	ff 45 f4             	incl   -0xc(%ebp)
{
  char *s;
  int ret;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     55e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     561:	3b 45 0c             	cmp    0xc(%ebp),%eax
     564:	73 1d                	jae    583 <gettoken+0x38>
     566:	8b 45 f4             	mov    -0xc(%ebp),%eax
     569:	8a 00                	mov    (%eax),%al
     56b:	0f be c0             	movsbl %al,%eax
     56e:	83 ec 08             	sub    $0x8,%esp
     571:	50                   	push   %eax
     572:	68 a4 14 00 00       	push   $0x14a4
     577:	e8 b4 07 00 00       	call   d30 <strchr>
     57c:	83 c4 10             	add    $0x10,%esp
     57f:	85 c0                	test   %eax,%eax
     581:	75 d8                	jne    55b <gettoken+0x10>
    s++;
  if(q)
     583:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     587:	74 08                	je     591 <gettoken+0x46>
    *q = s;
     589:	8b 45 10             	mov    0x10(%ebp),%eax
     58c:	8b 55 f4             	mov    -0xc(%ebp),%edx
     58f:	89 10                	mov    %edx,(%eax)
  ret = *s;
     591:	8b 45 f4             	mov    -0xc(%ebp),%eax
     594:	8a 00                	mov    (%eax),%al
     596:	0f be c0             	movsbl %al,%eax
     599:	89 45 f0             	mov    %eax,-0x10(%ebp)
  switch(*s){
     59c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     59f:	8a 00                	mov    (%eax),%al
     5a1:	0f be c0             	movsbl %al,%eax
     5a4:	83 f8 3c             	cmp    $0x3c,%eax
     5a7:	7f 1a                	jg     5c3 <gettoken+0x78>
     5a9:	83 f8 3b             	cmp    $0x3b,%eax
     5ac:	7d 1f                	jge    5cd <gettoken+0x82>
     5ae:	83 f8 29             	cmp    $0x29,%eax
     5b1:	7f 37                	jg     5ea <gettoken+0x9f>
     5b3:	83 f8 28             	cmp    $0x28,%eax
     5b6:	7d 15                	jge    5cd <gettoken+0x82>
     5b8:	85 c0                	test   %eax,%eax
     5ba:	74 7e                	je     63a <gettoken+0xef>
     5bc:	83 f8 26             	cmp    $0x26,%eax
     5bf:	74 0c                	je     5cd <gettoken+0x82>
     5c1:	eb 27                	jmp    5ea <gettoken+0x9f>
     5c3:	83 f8 3e             	cmp    $0x3e,%eax
     5c6:	74 0a                	je     5d2 <gettoken+0x87>
     5c8:	83 f8 7c             	cmp    $0x7c,%eax
     5cb:	75 1d                	jne    5ea <gettoken+0x9f>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     5cd:	ff 45 f4             	incl   -0xc(%ebp)
    break;
     5d0:	eb 72                	jmp    644 <gettoken+0xf9>
  case '>':
    s++;
     5d2:	ff 45 f4             	incl   -0xc(%ebp)
    if(*s == '>'){
     5d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5d8:	8a 00                	mov    (%eax),%al
     5da:	3c 3e                	cmp    $0x3e,%al
     5dc:	75 5f                	jne    63d <gettoken+0xf2>
      ret = '+';
     5de:	c7 45 f0 2b 00 00 00 	movl   $0x2b,-0x10(%ebp)
      s++;
     5e5:	ff 45 f4             	incl   -0xc(%ebp)
    }
    break;
     5e8:	eb 5a                	jmp    644 <gettoken+0xf9>
  default:
    ret = 'a';
     5ea:	c7 45 f0 61 00 00 00 	movl   $0x61,-0x10(%ebp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     5f1:	eb 03                	jmp    5f6 <gettoken+0xab>
      s++;
     5f3:	ff 45 f4             	incl   -0xc(%ebp)
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     5f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5f9:	3b 45 0c             	cmp    0xc(%ebp),%eax
     5fc:	73 42                	jae    640 <gettoken+0xf5>
     5fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
     601:	8a 00                	mov    (%eax),%al
     603:	0f be c0             	movsbl %al,%eax
     606:	83 ec 08             	sub    $0x8,%esp
     609:	50                   	push   %eax
     60a:	68 a4 14 00 00       	push   $0x14a4
     60f:	e8 1c 07 00 00       	call   d30 <strchr>
     614:	83 c4 10             	add    $0x10,%esp
     617:	85 c0                	test   %eax,%eax
     619:	75 28                	jne    643 <gettoken+0xf8>
     61b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     61e:	8a 00                	mov    (%eax),%al
     620:	0f be c0             	movsbl %al,%eax
     623:	83 ec 08             	sub    $0x8,%esp
     626:	50                   	push   %eax
     627:	68 aa 14 00 00       	push   $0x14aa
     62c:	e8 ff 06 00 00       	call   d30 <strchr>
     631:	83 c4 10             	add    $0x10,%esp
     634:	85 c0                	test   %eax,%eax
     636:	74 bb                	je     5f3 <gettoken+0xa8>
      s++;
    break;
     638:	eb 0a                	jmp    644 <gettoken+0xf9>
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
  case 0:
    break;
     63a:	90                   	nop
     63b:	eb 07                	jmp    644 <gettoken+0xf9>
    s++;
    if(*s == '>'){
      ret = '+';
      s++;
    }
    break;
     63d:	90                   	nop
     63e:	eb 04                	jmp    644 <gettoken+0xf9>
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
     640:	90                   	nop
     641:	eb 01                	jmp    644 <gettoken+0xf9>
     643:	90                   	nop
  }
  if(eq)
     644:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     648:	74 0d                	je     657 <gettoken+0x10c>
    *eq = s;
     64a:	8b 45 14             	mov    0x14(%ebp),%eax
     64d:	8b 55 f4             	mov    -0xc(%ebp),%edx
     650:	89 10                	mov    %edx,(%eax)
  
  while(s < es && strchr(whitespace, *s))
     652:	eb 03                	jmp    657 <gettoken+0x10c>
    s++;
     654:	ff 45 f4             	incl   -0xc(%ebp)
    break;
  }
  if(eq)
    *eq = s;
  
  while(s < es && strchr(whitespace, *s))
     657:	8b 45 f4             	mov    -0xc(%ebp),%eax
     65a:	3b 45 0c             	cmp    0xc(%ebp),%eax
     65d:	73 1d                	jae    67c <gettoken+0x131>
     65f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     662:	8a 00                	mov    (%eax),%al
     664:	0f be c0             	movsbl %al,%eax
     667:	83 ec 08             	sub    $0x8,%esp
     66a:	50                   	push   %eax
     66b:	68 a4 14 00 00       	push   $0x14a4
     670:	e8 bb 06 00 00       	call   d30 <strchr>
     675:	83 c4 10             	add    $0x10,%esp
     678:	85 c0                	test   %eax,%eax
     67a:	75 d8                	jne    654 <gettoken+0x109>
    s++;
  *ps = s;
     67c:	8b 45 08             	mov    0x8(%ebp),%eax
     67f:	8b 55 f4             	mov    -0xc(%ebp),%edx
     682:	89 10                	mov    %edx,(%eax)
  return ret;
     684:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     687:	c9                   	leave  
     688:	c3                   	ret    

00000689 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     689:	55                   	push   %ebp
     68a:	89 e5                	mov    %esp,%ebp
     68c:	83 ec 18             	sub    $0x18,%esp
  char *s;
  
  s = *ps;
     68f:	8b 45 08             	mov    0x8(%ebp),%eax
     692:	8b 00                	mov    (%eax),%eax
     694:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     697:	eb 03                	jmp    69c <peek+0x13>
    s++;
     699:	ff 45 f4             	incl   -0xc(%ebp)
peek(char **ps, char *es, char *toks)
{
  char *s;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     69c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     69f:	3b 45 0c             	cmp    0xc(%ebp),%eax
     6a2:	73 1d                	jae    6c1 <peek+0x38>
     6a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6a7:	8a 00                	mov    (%eax),%al
     6a9:	0f be c0             	movsbl %al,%eax
     6ac:	83 ec 08             	sub    $0x8,%esp
     6af:	50                   	push   %eax
     6b0:	68 a4 14 00 00       	push   $0x14a4
     6b5:	e8 76 06 00 00       	call   d30 <strchr>
     6ba:	83 c4 10             	add    $0x10,%esp
     6bd:	85 c0                	test   %eax,%eax
     6bf:	75 d8                	jne    699 <peek+0x10>
    s++;
  *ps = s;
     6c1:	8b 45 08             	mov    0x8(%ebp),%eax
     6c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
     6c7:	89 10                	mov    %edx,(%eax)
  return *s && strchr(toks, *s);
     6c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6cc:	8a 00                	mov    (%eax),%al
     6ce:	84 c0                	test   %al,%al
     6d0:	74 22                	je     6f4 <peek+0x6b>
     6d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6d5:	8a 00                	mov    (%eax),%al
     6d7:	0f be c0             	movsbl %al,%eax
     6da:	83 ec 08             	sub    $0x8,%esp
     6dd:	50                   	push   %eax
     6de:	ff 75 10             	pushl  0x10(%ebp)
     6e1:	e8 4a 06 00 00       	call   d30 <strchr>
     6e6:	83 c4 10             	add    $0x10,%esp
     6e9:	85 c0                	test   %eax,%eax
     6eb:	74 07                	je     6f4 <peek+0x6b>
     6ed:	b8 01 00 00 00       	mov    $0x1,%eax
     6f2:	eb 05                	jmp    6f9 <peek+0x70>
     6f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
     6f9:	c9                   	leave  
     6fa:	c3                   	ret    

000006fb <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
     6fb:	55                   	push   %ebp
     6fc:	89 e5                	mov    %esp,%ebp
     6fe:	53                   	push   %ebx
     6ff:	83 ec 14             	sub    $0x14,%esp
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
     702:	8b 5d 08             	mov    0x8(%ebp),%ebx
     705:	8b 45 08             	mov    0x8(%ebp),%eax
     708:	83 ec 0c             	sub    $0xc,%esp
     70b:	50                   	push   %eax
     70c:	e8 e2 05 00 00       	call   cf3 <strlen>
     711:	83 c4 10             	add    $0x10,%esp
     714:	8d 04 03             	lea    (%ebx,%eax,1),%eax
     717:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cmd = parseline(&s, es);
     71a:	83 ec 08             	sub    $0x8,%esp
     71d:	ff 75 f4             	pushl  -0xc(%ebp)
     720:	8d 45 08             	lea    0x8(%ebp),%eax
     723:	50                   	push   %eax
     724:	e8 61 00 00 00       	call   78a <parseline>
     729:	83 c4 10             	add    $0x10,%esp
     72c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  peek(&s, es, "");
     72f:	83 ec 04             	sub    $0x4,%esp
     732:	68 12 14 00 00       	push   $0x1412
     737:	ff 75 f4             	pushl  -0xc(%ebp)
     73a:	8d 45 08             	lea    0x8(%ebp),%eax
     73d:	50                   	push   %eax
     73e:	e8 46 ff ff ff       	call   689 <peek>
     743:	83 c4 10             	add    $0x10,%esp
  if(s != es){
     746:	8b 45 08             	mov    0x8(%ebp),%eax
     749:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     74c:	74 26                	je     774 <parsecmd+0x79>
    printf(2, "leftovers: %s\n", s);
     74e:	8b 45 08             	mov    0x8(%ebp),%eax
     751:	83 ec 04             	sub    $0x4,%esp
     754:	50                   	push   %eax
     755:	68 13 14 00 00       	push   $0x1413
     75a:	6a 02                	push   $0x2
     75c:	e8 a3 08 00 00       	call   1004 <printf>
     761:	83 c4 10             	add    $0x10,%esp
    panic("syntax");
     764:	83 ec 0c             	sub    $0xc,%esp
     767:	68 22 14 00 00       	push   $0x1422
     76c:	e8 29 fc ff ff       	call   39a <panic>
     771:	83 c4 10             	add    $0x10,%esp
  }
  nulterminate(cmd);
     774:	83 ec 0c             	sub    $0xc,%esp
     777:	ff 75 f0             	pushl  -0x10(%ebp)
     77a:	e8 ea 03 00 00       	call   b69 <nulterminate>
     77f:	83 c4 10             	add    $0x10,%esp
  return cmd;
     782:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     785:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     788:	c9                   	leave  
     789:	c3                   	ret    

0000078a <parseline>:

struct cmd*
parseline(char **ps, char *es)
{
     78a:	55                   	push   %ebp
     78b:	89 e5                	mov    %esp,%ebp
     78d:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     790:	83 ec 08             	sub    $0x8,%esp
     793:	ff 75 0c             	pushl  0xc(%ebp)
     796:	ff 75 08             	pushl  0x8(%ebp)
     799:	e8 99 00 00 00       	call   837 <parsepipe>
     79e:	83 c4 10             	add    $0x10,%esp
     7a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(peek(ps, es, "&")){
     7a4:	eb 23                	jmp    7c9 <parseline+0x3f>
    gettoken(ps, es, 0, 0);
     7a6:	6a 00                	push   $0x0
     7a8:	6a 00                	push   $0x0
     7aa:	ff 75 0c             	pushl  0xc(%ebp)
     7ad:	ff 75 08             	pushl  0x8(%ebp)
     7b0:	e8 96 fd ff ff       	call   54b <gettoken>
     7b5:	83 c4 10             	add    $0x10,%esp
    cmd = backcmd(cmd);
     7b8:	83 ec 0c             	sub    $0xc,%esp
     7bb:	ff 75 f4             	pushl  -0xc(%ebp)
     7be:	e8 49 fd ff ff       	call   50c <backcmd>
     7c3:	83 c4 10             	add    $0x10,%esp
     7c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
     7c9:	83 ec 04             	sub    $0x4,%esp
     7cc:	68 29 14 00 00       	push   $0x1429
     7d1:	ff 75 0c             	pushl  0xc(%ebp)
     7d4:	ff 75 08             	pushl  0x8(%ebp)
     7d7:	e8 ad fe ff ff       	call   689 <peek>
     7dc:	83 c4 10             	add    $0x10,%esp
     7df:	85 c0                	test   %eax,%eax
     7e1:	75 c3                	jne    7a6 <parseline+0x1c>
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
     7e3:	83 ec 04             	sub    $0x4,%esp
     7e6:	68 2b 14 00 00       	push   $0x142b
     7eb:	ff 75 0c             	pushl  0xc(%ebp)
     7ee:	ff 75 08             	pushl  0x8(%ebp)
     7f1:	e8 93 fe ff ff       	call   689 <peek>
     7f6:	83 c4 10             	add    $0x10,%esp
     7f9:	85 c0                	test   %eax,%eax
     7fb:	74 35                	je     832 <parseline+0xa8>
    gettoken(ps, es, 0, 0);
     7fd:	6a 00                	push   $0x0
     7ff:	6a 00                	push   $0x0
     801:	ff 75 0c             	pushl  0xc(%ebp)
     804:	ff 75 08             	pushl  0x8(%ebp)
     807:	e8 3f fd ff ff       	call   54b <gettoken>
     80c:	83 c4 10             	add    $0x10,%esp
    cmd = listcmd(cmd, parseline(ps, es));
     80f:	83 ec 08             	sub    $0x8,%esp
     812:	ff 75 0c             	pushl  0xc(%ebp)
     815:	ff 75 08             	pushl  0x8(%ebp)
     818:	e8 6d ff ff ff       	call   78a <parseline>
     81d:	83 c4 10             	add    $0x10,%esp
     820:	83 ec 08             	sub    $0x8,%esp
     823:	50                   	push   %eax
     824:	ff 75 f4             	pushl  -0xc(%ebp)
     827:	e8 98 fc ff ff       	call   4c4 <listcmd>
     82c:	83 c4 10             	add    $0x10,%esp
     82f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     832:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     835:	c9                   	leave  
     836:	c3                   	ret    

00000837 <parsepipe>:

struct cmd*
parsepipe(char **ps, char *es)
{
     837:	55                   	push   %ebp
     838:	89 e5                	mov    %esp,%ebp
     83a:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     83d:	83 ec 08             	sub    $0x8,%esp
     840:	ff 75 0c             	pushl  0xc(%ebp)
     843:	ff 75 08             	pushl  0x8(%ebp)
     846:	e8 ec 01 00 00       	call   a37 <parseexec>
     84b:	83 c4 10             	add    $0x10,%esp
     84e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(peek(ps, es, "|")){
     851:	83 ec 04             	sub    $0x4,%esp
     854:	68 2d 14 00 00       	push   $0x142d
     859:	ff 75 0c             	pushl  0xc(%ebp)
     85c:	ff 75 08             	pushl  0x8(%ebp)
     85f:	e8 25 fe ff ff       	call   689 <peek>
     864:	83 c4 10             	add    $0x10,%esp
     867:	85 c0                	test   %eax,%eax
     869:	74 35                	je     8a0 <parsepipe+0x69>
    gettoken(ps, es, 0, 0);
     86b:	6a 00                	push   $0x0
     86d:	6a 00                	push   $0x0
     86f:	ff 75 0c             	pushl  0xc(%ebp)
     872:	ff 75 08             	pushl  0x8(%ebp)
     875:	e8 d1 fc ff ff       	call   54b <gettoken>
     87a:	83 c4 10             	add    $0x10,%esp
    cmd = pipecmd(cmd, parsepipe(ps, es));
     87d:	83 ec 08             	sub    $0x8,%esp
     880:	ff 75 0c             	pushl  0xc(%ebp)
     883:	ff 75 08             	pushl  0x8(%ebp)
     886:	e8 ac ff ff ff       	call   837 <parsepipe>
     88b:	83 c4 10             	add    $0x10,%esp
     88e:	83 ec 08             	sub    $0x8,%esp
     891:	50                   	push   %eax
     892:	ff 75 f4             	pushl  -0xc(%ebp)
     895:	e8 e2 fb ff ff       	call   47c <pipecmd>
     89a:	83 c4 10             	add    $0x10,%esp
     89d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     8a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     8a3:	c9                   	leave  
     8a4:	c3                   	ret    

000008a5 <parseredirs>:

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     8a5:	55                   	push   %ebp
     8a6:	89 e5                	mov    %esp,%ebp
     8a8:	83 ec 18             	sub    $0x18,%esp
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     8ab:	e9 b6 00 00 00       	jmp    966 <parseredirs+0xc1>
    tok = gettoken(ps, es, 0, 0);
     8b0:	6a 00                	push   $0x0
     8b2:	6a 00                	push   $0x0
     8b4:	ff 75 10             	pushl  0x10(%ebp)
     8b7:	ff 75 0c             	pushl  0xc(%ebp)
     8ba:	e8 8c fc ff ff       	call   54b <gettoken>
     8bf:	83 c4 10             	add    $0x10,%esp
     8c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(gettoken(ps, es, &q, &eq) != 'a')
     8c5:	8d 45 ec             	lea    -0x14(%ebp),%eax
     8c8:	50                   	push   %eax
     8c9:	8d 45 f0             	lea    -0x10(%ebp),%eax
     8cc:	50                   	push   %eax
     8cd:	ff 75 10             	pushl  0x10(%ebp)
     8d0:	ff 75 0c             	pushl  0xc(%ebp)
     8d3:	e8 73 fc ff ff       	call   54b <gettoken>
     8d8:	83 c4 10             	add    $0x10,%esp
     8db:	83 f8 61             	cmp    $0x61,%eax
     8de:	74 10                	je     8f0 <parseredirs+0x4b>
      panic("missing file for redirection");
     8e0:	83 ec 0c             	sub    $0xc,%esp
     8e3:	68 2f 14 00 00       	push   $0x142f
     8e8:	e8 ad fa ff ff       	call   39a <panic>
     8ed:	83 c4 10             	add    $0x10,%esp
    switch(tok){
     8f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8f3:	83 f8 3c             	cmp    $0x3c,%eax
     8f6:	74 0c                	je     904 <parseredirs+0x5f>
     8f8:	83 f8 3e             	cmp    $0x3e,%eax
     8fb:	74 26                	je     923 <parseredirs+0x7e>
     8fd:	83 f8 2b             	cmp    $0x2b,%eax
     900:	74 43                	je     945 <parseredirs+0xa0>
     902:	eb 62                	jmp    966 <parseredirs+0xc1>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     904:	8b 55 ec             	mov    -0x14(%ebp),%edx
     907:	8b 45 f0             	mov    -0x10(%ebp),%eax
     90a:	83 ec 0c             	sub    $0xc,%esp
     90d:	6a 00                	push   $0x0
     90f:	6a 00                	push   $0x0
     911:	52                   	push   %edx
     912:	50                   	push   %eax
     913:	ff 75 08             	pushl  0x8(%ebp)
     916:	e8 fe fa ff ff       	call   419 <redircmd>
     91b:	83 c4 20             	add    $0x20,%esp
     91e:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     921:	eb 43                	jmp    966 <parseredirs+0xc1>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     923:	8b 55 ec             	mov    -0x14(%ebp),%edx
     926:	8b 45 f0             	mov    -0x10(%ebp),%eax
     929:	83 ec 0c             	sub    $0xc,%esp
     92c:	6a 01                	push   $0x1
     92e:	68 01 02 00 00       	push   $0x201
     933:	52                   	push   %edx
     934:	50                   	push   %eax
     935:	ff 75 08             	pushl  0x8(%ebp)
     938:	e8 dc fa ff ff       	call   419 <redircmd>
     93d:	83 c4 20             	add    $0x20,%esp
     940:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     943:	eb 21                	jmp    966 <parseredirs+0xc1>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     945:	8b 55 ec             	mov    -0x14(%ebp),%edx
     948:	8b 45 f0             	mov    -0x10(%ebp),%eax
     94b:	83 ec 0c             	sub    $0xc,%esp
     94e:	6a 01                	push   $0x1
     950:	68 01 02 00 00       	push   $0x201
     955:	52                   	push   %edx
     956:	50                   	push   %eax
     957:	ff 75 08             	pushl  0x8(%ebp)
     95a:	e8 ba fa ff ff       	call   419 <redircmd>
     95f:	83 c4 20             	add    $0x20,%esp
     962:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     965:	90                   	nop
parseredirs(struct cmd *cmd, char **ps, char *es)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     966:	83 ec 04             	sub    $0x4,%esp
     969:	68 4c 14 00 00       	push   $0x144c
     96e:	ff 75 10             	pushl  0x10(%ebp)
     971:	ff 75 0c             	pushl  0xc(%ebp)
     974:	e8 10 fd ff ff       	call   689 <peek>
     979:	83 c4 10             	add    $0x10,%esp
     97c:	85 c0                	test   %eax,%eax
     97e:	0f 85 2c ff ff ff    	jne    8b0 <parseredirs+0xb>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
     984:	8b 45 08             	mov    0x8(%ebp),%eax
}
     987:	c9                   	leave  
     988:	c3                   	ret    

00000989 <parseblock>:

struct cmd*
parseblock(char **ps, char *es)
{
     989:	55                   	push   %ebp
     98a:	89 e5                	mov    %esp,%ebp
     98c:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  if(!peek(ps, es, "("))
     98f:	83 ec 04             	sub    $0x4,%esp
     992:	68 4f 14 00 00       	push   $0x144f
     997:	ff 75 0c             	pushl  0xc(%ebp)
     99a:	ff 75 08             	pushl  0x8(%ebp)
     99d:	e8 e7 fc ff ff       	call   689 <peek>
     9a2:	83 c4 10             	add    $0x10,%esp
     9a5:	85 c0                	test   %eax,%eax
     9a7:	75 10                	jne    9b9 <parseblock+0x30>
    panic("parseblock");
     9a9:	83 ec 0c             	sub    $0xc,%esp
     9ac:	68 51 14 00 00       	push   $0x1451
     9b1:	e8 e4 f9 ff ff       	call   39a <panic>
     9b6:	83 c4 10             	add    $0x10,%esp
  gettoken(ps, es, 0, 0);
     9b9:	6a 00                	push   $0x0
     9bb:	6a 00                	push   $0x0
     9bd:	ff 75 0c             	pushl  0xc(%ebp)
     9c0:	ff 75 08             	pushl  0x8(%ebp)
     9c3:	e8 83 fb ff ff       	call   54b <gettoken>
     9c8:	83 c4 10             	add    $0x10,%esp
  cmd = parseline(ps, es);
     9cb:	83 ec 08             	sub    $0x8,%esp
     9ce:	ff 75 0c             	pushl  0xc(%ebp)
     9d1:	ff 75 08             	pushl  0x8(%ebp)
     9d4:	e8 b1 fd ff ff       	call   78a <parseline>
     9d9:	83 c4 10             	add    $0x10,%esp
     9dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!peek(ps, es, ")"))
     9df:	83 ec 04             	sub    $0x4,%esp
     9e2:	68 5c 14 00 00       	push   $0x145c
     9e7:	ff 75 0c             	pushl  0xc(%ebp)
     9ea:	ff 75 08             	pushl  0x8(%ebp)
     9ed:	e8 97 fc ff ff       	call   689 <peek>
     9f2:	83 c4 10             	add    $0x10,%esp
     9f5:	85 c0                	test   %eax,%eax
     9f7:	75 10                	jne    a09 <parseblock+0x80>
    panic("syntax - missing )");
     9f9:	83 ec 0c             	sub    $0xc,%esp
     9fc:	68 5e 14 00 00       	push   $0x145e
     a01:	e8 94 f9 ff ff       	call   39a <panic>
     a06:	83 c4 10             	add    $0x10,%esp
  gettoken(ps, es, 0, 0);
     a09:	6a 00                	push   $0x0
     a0b:	6a 00                	push   $0x0
     a0d:	ff 75 0c             	pushl  0xc(%ebp)
     a10:	ff 75 08             	pushl  0x8(%ebp)
     a13:	e8 33 fb ff ff       	call   54b <gettoken>
     a18:	83 c4 10             	add    $0x10,%esp
  cmd = parseredirs(cmd, ps, es);
     a1b:	83 ec 04             	sub    $0x4,%esp
     a1e:	ff 75 0c             	pushl  0xc(%ebp)
     a21:	ff 75 08             	pushl  0x8(%ebp)
     a24:	ff 75 f4             	pushl  -0xc(%ebp)
     a27:	e8 79 fe ff ff       	call   8a5 <parseredirs>
     a2c:	83 c4 10             	add    $0x10,%esp
     a2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  return cmd;
     a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     a35:	c9                   	leave  
     a36:	c3                   	ret    

00000a37 <parseexec>:

struct cmd*
parseexec(char **ps, char *es)
{
     a37:	55                   	push   %ebp
     a38:	89 e5                	mov    %esp,%ebp
     a3a:	83 ec 28             	sub    $0x28,%esp
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;
  
  if(peek(ps, es, "("))
     a3d:	83 ec 04             	sub    $0x4,%esp
     a40:	68 4f 14 00 00       	push   $0x144f
     a45:	ff 75 0c             	pushl  0xc(%ebp)
     a48:	ff 75 08             	pushl  0x8(%ebp)
     a4b:	e8 39 fc ff ff       	call   689 <peek>
     a50:	83 c4 10             	add    $0x10,%esp
     a53:	85 c0                	test   %eax,%eax
     a55:	74 16                	je     a6d <parseexec+0x36>
    return parseblock(ps, es);
     a57:	83 ec 08             	sub    $0x8,%esp
     a5a:	ff 75 0c             	pushl  0xc(%ebp)
     a5d:	ff 75 08             	pushl  0x8(%ebp)
     a60:	e8 24 ff ff ff       	call   989 <parseblock>
     a65:	83 c4 10             	add    $0x10,%esp
     a68:	e9 fa 00 00 00       	jmp    b67 <parseexec+0x130>

  ret = execcmd();
     a6d:	e8 71 f9 ff ff       	call   3e3 <execcmd>
     a72:	89 45 f0             	mov    %eax,-0x10(%ebp)
  cmd = (struct execcmd*)ret;
     a75:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a78:	89 45 ec             	mov    %eax,-0x14(%ebp)

  argc = 0;
     a7b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  ret = parseredirs(ret, ps, es);
     a82:	83 ec 04             	sub    $0x4,%esp
     a85:	ff 75 0c             	pushl  0xc(%ebp)
     a88:	ff 75 08             	pushl  0x8(%ebp)
     a8b:	ff 75 f0             	pushl  -0x10(%ebp)
     a8e:	e8 12 fe ff ff       	call   8a5 <parseredirs>
     a93:	83 c4 10             	add    $0x10,%esp
     a96:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(!peek(ps, es, "|)&;")){
     a99:	e9 86 00 00 00       	jmp    b24 <parseexec+0xed>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     a9e:	8d 45 e0             	lea    -0x20(%ebp),%eax
     aa1:	50                   	push   %eax
     aa2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     aa5:	50                   	push   %eax
     aa6:	ff 75 0c             	pushl  0xc(%ebp)
     aa9:	ff 75 08             	pushl  0x8(%ebp)
     aac:	e8 9a fa ff ff       	call   54b <gettoken>
     ab1:	83 c4 10             	add    $0x10,%esp
     ab4:	89 45 e8             	mov    %eax,-0x18(%ebp)
     ab7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     abb:	0f 84 83 00 00 00    	je     b44 <parseexec+0x10d>
      break;
    if(tok != 'a')
     ac1:	83 7d e8 61          	cmpl   $0x61,-0x18(%ebp)
     ac5:	74 10                	je     ad7 <parseexec+0xa0>
      panic("syntax");
     ac7:	83 ec 0c             	sub    $0xc,%esp
     aca:	68 22 14 00 00       	push   $0x1422
     acf:	e8 c6 f8 ff ff       	call   39a <panic>
     ad4:	83 c4 10             	add    $0x10,%esp
    cmd->argv[argc] = q;
     ad7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     ada:	8b 45 ec             	mov    -0x14(%ebp),%eax
     add:	8b 55 f4             	mov    -0xc(%ebp),%edx
     ae0:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
    cmd->eargv[argc] = eq;
     ae4:	8b 55 e0             	mov    -0x20(%ebp),%edx
     ae7:	8b 45 ec             	mov    -0x14(%ebp),%eax
     aea:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     aed:	83 c1 08             	add    $0x8,%ecx
     af0:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    argc++;
     af4:	ff 45 f4             	incl   -0xc(%ebp)
    if(argc >= MAXARGS)
     af7:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     afb:	7e 10                	jle    b0d <parseexec+0xd6>
      panic("too many args");
     afd:	83 ec 0c             	sub    $0xc,%esp
     b00:	68 71 14 00 00       	push   $0x1471
     b05:	e8 90 f8 ff ff       	call   39a <panic>
     b0a:	83 c4 10             	add    $0x10,%esp
    ret = parseredirs(ret, ps, es);
     b0d:	83 ec 04             	sub    $0x4,%esp
     b10:	ff 75 0c             	pushl  0xc(%ebp)
     b13:	ff 75 08             	pushl  0x8(%ebp)
     b16:	ff 75 f0             	pushl  -0x10(%ebp)
     b19:	e8 87 fd ff ff       	call   8a5 <parseredirs>
     b1e:	83 c4 10             	add    $0x10,%esp
     b21:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
     b24:	83 ec 04             	sub    $0x4,%esp
     b27:	68 7f 14 00 00       	push   $0x147f
     b2c:	ff 75 0c             	pushl  0xc(%ebp)
     b2f:	ff 75 08             	pushl  0x8(%ebp)
     b32:	e8 52 fb ff ff       	call   689 <peek>
     b37:	83 c4 10             	add    $0x10,%esp
     b3a:	85 c0                	test   %eax,%eax
     b3c:	0f 84 5c ff ff ff    	je     a9e <parseexec+0x67>
     b42:	eb 01                	jmp    b45 <parseexec+0x10e>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
     b44:	90                   	nop
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
     b45:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b48:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b4b:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
     b52:	00 
  cmd->eargv[argc] = 0;
     b53:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b56:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b59:	83 c2 08             	add    $0x8,%edx
     b5c:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
     b63:	00 
  return ret;
     b64:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     b67:	c9                   	leave  
     b68:	c3                   	ret    

00000b69 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     b69:	55                   	push   %ebp
     b6a:	89 e5                	mov    %esp,%ebp
     b6c:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     b6f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     b73:	75 0a                	jne    b7f <nulterminate+0x16>
    return 0;
     b75:	b8 00 00 00 00       	mov    $0x0,%eax
     b7a:	e9 e3 00 00 00       	jmp    c62 <nulterminate+0xf9>
  
  switch(cmd->type){
     b7f:	8b 45 08             	mov    0x8(%ebp),%eax
     b82:	8b 00                	mov    (%eax),%eax
     b84:	83 f8 05             	cmp    $0x5,%eax
     b87:	0f 87 d2 00 00 00    	ja     c5f <nulterminate+0xf6>
     b8d:	8b 04 85 84 14 00 00 	mov    0x1484(,%eax,4),%eax
     b94:	ff e0                	jmp    *%eax
  case EXEC:
    ecmd = (struct execcmd*)cmd;
     b96:	8b 45 08             	mov    0x8(%ebp),%eax
     b99:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for(i=0; ecmd->argv[i]; i++)
     b9c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     ba3:	eb 13                	jmp    bb8 <nulterminate+0x4f>
      *ecmd->eargv[i] = 0;
     ba5:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ba8:	8b 55 f4             	mov    -0xc(%ebp),%edx
     bab:	83 c2 08             	add    $0x8,%edx
     bae:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
     bb2:	c6 00 00             	movb   $0x0,(%eax)
    return 0;
  
  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     bb5:	ff 45 f4             	incl   -0xc(%ebp)
     bb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
     bbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
     bbe:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
     bc2:	85 c0                	test   %eax,%eax
     bc4:	75 df                	jne    ba5 <nulterminate+0x3c>
      *ecmd->eargv[i] = 0;
    break;
     bc6:	e9 94 00 00 00       	jmp    c5f <nulterminate+0xf6>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
     bcb:	8b 45 08             	mov    0x8(%ebp),%eax
     bce:	89 45 ec             	mov    %eax,-0x14(%ebp)
    nulterminate(rcmd->cmd);
     bd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
     bd4:	8b 40 04             	mov    0x4(%eax),%eax
     bd7:	83 ec 0c             	sub    $0xc,%esp
     bda:	50                   	push   %eax
     bdb:	e8 89 ff ff ff       	call   b69 <nulterminate>
     be0:	83 c4 10             	add    $0x10,%esp
    *rcmd->efile = 0;
     be3:	8b 45 ec             	mov    -0x14(%ebp),%eax
     be6:	8b 40 0c             	mov    0xc(%eax),%eax
     be9:	c6 00 00             	movb   $0x0,(%eax)
    break;
     bec:	eb 71                	jmp    c5f <nulterminate+0xf6>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     bee:	8b 45 08             	mov    0x8(%ebp),%eax
     bf1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nulterminate(pcmd->left);
     bf4:	8b 45 e8             	mov    -0x18(%ebp),%eax
     bf7:	8b 40 04             	mov    0x4(%eax),%eax
     bfa:	83 ec 0c             	sub    $0xc,%esp
     bfd:	50                   	push   %eax
     bfe:	e8 66 ff ff ff       	call   b69 <nulterminate>
     c03:	83 c4 10             	add    $0x10,%esp
    nulterminate(pcmd->right);
     c06:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c09:	8b 40 08             	mov    0x8(%eax),%eax
     c0c:	83 ec 0c             	sub    $0xc,%esp
     c0f:	50                   	push   %eax
     c10:	e8 54 ff ff ff       	call   b69 <nulterminate>
     c15:	83 c4 10             	add    $0x10,%esp
    break;
     c18:	eb 45                	jmp    c5f <nulterminate+0xf6>
    
  case LIST:
    lcmd = (struct listcmd*)cmd;
     c1a:	8b 45 08             	mov    0x8(%ebp),%eax
     c1d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nulterminate(lcmd->left);
     c20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c23:	8b 40 04             	mov    0x4(%eax),%eax
     c26:	83 ec 0c             	sub    $0xc,%esp
     c29:	50                   	push   %eax
     c2a:	e8 3a ff ff ff       	call   b69 <nulterminate>
     c2f:	83 c4 10             	add    $0x10,%esp
    nulterminate(lcmd->right);
     c32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c35:	8b 40 08             	mov    0x8(%eax),%eax
     c38:	83 ec 0c             	sub    $0xc,%esp
     c3b:	50                   	push   %eax
     c3c:	e8 28 ff ff ff       	call   b69 <nulterminate>
     c41:	83 c4 10             	add    $0x10,%esp
    break;
     c44:	eb 19                	jmp    c5f <nulterminate+0xf6>

  case BACK:
    bcmd = (struct backcmd*)cmd;
     c46:	8b 45 08             	mov    0x8(%ebp),%eax
     c49:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nulterminate(bcmd->cmd);
     c4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
     c4f:	8b 40 04             	mov    0x4(%eax),%eax
     c52:	83 ec 0c             	sub    $0xc,%esp
     c55:	50                   	push   %eax
     c56:	e8 0e ff ff ff       	call   b69 <nulterminate>
     c5b:	83 c4 10             	add    $0x10,%esp
    break;
     c5e:	90                   	nop
  }
  return cmd;
     c5f:	8b 45 08             	mov    0x8(%ebp),%eax
}
     c62:	c9                   	leave  
     c63:	c3                   	ret    

00000c64 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     c64:	55                   	push   %ebp
     c65:	89 e5                	mov    %esp,%ebp
     c67:	57                   	push   %edi
     c68:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     c69:	8b 4d 08             	mov    0x8(%ebp),%ecx
     c6c:	8b 55 10             	mov    0x10(%ebp),%edx
     c6f:	8b 45 0c             	mov    0xc(%ebp),%eax
     c72:	89 cb                	mov    %ecx,%ebx
     c74:	89 df                	mov    %ebx,%edi
     c76:	89 d1                	mov    %edx,%ecx
     c78:	fc                   	cld    
     c79:	f3 aa                	rep stos %al,%es:(%edi)
     c7b:	89 ca                	mov    %ecx,%edx
     c7d:	89 fb                	mov    %edi,%ebx
     c7f:	89 5d 08             	mov    %ebx,0x8(%ebp)
     c82:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     c85:	5b                   	pop    %ebx
     c86:	5f                   	pop    %edi
     c87:	c9                   	leave  
     c88:	c3                   	ret    

00000c89 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     c89:	55                   	push   %ebp
     c8a:	89 e5                	mov    %esp,%ebp
     c8c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     c8f:	8b 45 08             	mov    0x8(%ebp),%eax
     c92:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     c95:	90                   	nop
     c96:	8b 45 0c             	mov    0xc(%ebp),%eax
     c99:	8a 10                	mov    (%eax),%dl
     c9b:	8b 45 08             	mov    0x8(%ebp),%eax
     c9e:	88 10                	mov    %dl,(%eax)
     ca0:	8b 45 08             	mov    0x8(%ebp),%eax
     ca3:	8a 00                	mov    (%eax),%al
     ca5:	84 c0                	test   %al,%al
     ca7:	0f 95 c0             	setne  %al
     caa:	ff 45 08             	incl   0x8(%ebp)
     cad:	ff 45 0c             	incl   0xc(%ebp)
     cb0:	84 c0                	test   %al,%al
     cb2:	75 e2                	jne    c96 <strcpy+0xd>
    ;
  return os;
     cb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     cb7:	c9                   	leave  
     cb8:	c3                   	ret    

00000cb9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     cb9:	55                   	push   %ebp
     cba:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     cbc:	eb 06                	jmp    cc4 <strcmp+0xb>
    p++, q++;
     cbe:	ff 45 08             	incl   0x8(%ebp)
     cc1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     cc4:	8b 45 08             	mov    0x8(%ebp),%eax
     cc7:	8a 00                	mov    (%eax),%al
     cc9:	84 c0                	test   %al,%al
     ccb:	74 0e                	je     cdb <strcmp+0x22>
     ccd:	8b 45 08             	mov    0x8(%ebp),%eax
     cd0:	8a 10                	mov    (%eax),%dl
     cd2:	8b 45 0c             	mov    0xc(%ebp),%eax
     cd5:	8a 00                	mov    (%eax),%al
     cd7:	38 c2                	cmp    %al,%dl
     cd9:	74 e3                	je     cbe <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     cdb:	8b 45 08             	mov    0x8(%ebp),%eax
     cde:	8a 00                	mov    (%eax),%al
     ce0:	0f b6 d0             	movzbl %al,%edx
     ce3:	8b 45 0c             	mov    0xc(%ebp),%eax
     ce6:	8a 00                	mov    (%eax),%al
     ce8:	0f b6 c0             	movzbl %al,%eax
     ceb:	89 d1                	mov    %edx,%ecx
     ced:	29 c1                	sub    %eax,%ecx
     cef:	89 c8                	mov    %ecx,%eax
}
     cf1:	c9                   	leave  
     cf2:	c3                   	ret    

00000cf3 <strlen>:

uint
strlen(char *s)
{
     cf3:	55                   	push   %ebp
     cf4:	89 e5                	mov    %esp,%ebp
     cf6:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     cf9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     d00:	eb 03                	jmp    d05 <strlen+0x12>
     d02:	ff 45 fc             	incl   -0x4(%ebp)
     d05:	8b 45 fc             	mov    -0x4(%ebp),%eax
     d08:	03 45 08             	add    0x8(%ebp),%eax
     d0b:	8a 00                	mov    (%eax),%al
     d0d:	84 c0                	test   %al,%al
     d0f:	75 f1                	jne    d02 <strlen+0xf>
    ;
  return n;
     d11:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     d14:	c9                   	leave  
     d15:	c3                   	ret    

00000d16 <memset>:

void*
memset(void *dst, int c, uint n)
{
     d16:	55                   	push   %ebp
     d17:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
     d19:	8b 45 10             	mov    0x10(%ebp),%eax
     d1c:	50                   	push   %eax
     d1d:	ff 75 0c             	pushl  0xc(%ebp)
     d20:	ff 75 08             	pushl  0x8(%ebp)
     d23:	e8 3c ff ff ff       	call   c64 <stosb>
     d28:	83 c4 0c             	add    $0xc,%esp
  return dst;
     d2b:	8b 45 08             	mov    0x8(%ebp),%eax
}
     d2e:	c9                   	leave  
     d2f:	c3                   	ret    

00000d30 <strchr>:

char*
strchr(const char *s, char c)
{
     d30:	55                   	push   %ebp
     d31:	89 e5                	mov    %esp,%ebp
     d33:	83 ec 04             	sub    $0x4,%esp
     d36:	8b 45 0c             	mov    0xc(%ebp),%eax
     d39:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     d3c:	eb 12                	jmp    d50 <strchr+0x20>
    if(*s == c)
     d3e:	8b 45 08             	mov    0x8(%ebp),%eax
     d41:	8a 00                	mov    (%eax),%al
     d43:	3a 45 fc             	cmp    -0x4(%ebp),%al
     d46:	75 05                	jne    d4d <strchr+0x1d>
      return (char*)s;
     d48:	8b 45 08             	mov    0x8(%ebp),%eax
     d4b:	eb 11                	jmp    d5e <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     d4d:	ff 45 08             	incl   0x8(%ebp)
     d50:	8b 45 08             	mov    0x8(%ebp),%eax
     d53:	8a 00                	mov    (%eax),%al
     d55:	84 c0                	test   %al,%al
     d57:	75 e5                	jne    d3e <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     d59:	b8 00 00 00 00       	mov    $0x0,%eax
}
     d5e:	c9                   	leave  
     d5f:	c3                   	ret    

00000d60 <gets>:

char*
gets(char *buf, int max)
{
     d60:	55                   	push   %ebp
     d61:	89 e5                	mov    %esp,%ebp
     d63:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     d66:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     d6d:	eb 38                	jmp    da7 <gets+0x47>
    cc = read(0, &c, 1);
     d6f:	83 ec 04             	sub    $0x4,%esp
     d72:	6a 01                	push   $0x1
     d74:	8d 45 ef             	lea    -0x11(%ebp),%eax
     d77:	50                   	push   %eax
     d78:	6a 00                	push   $0x0
     d7a:	e8 31 01 00 00       	call   eb0 <read>
     d7f:	83 c4 10             	add    $0x10,%esp
     d82:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     d85:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     d89:	7e 27                	jle    db2 <gets+0x52>
      break;
    buf[i++] = c;
     d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d8e:	03 45 08             	add    0x8(%ebp),%eax
     d91:	8a 55 ef             	mov    -0x11(%ebp),%dl
     d94:	88 10                	mov    %dl,(%eax)
     d96:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
     d99:	8a 45 ef             	mov    -0x11(%ebp),%al
     d9c:	3c 0a                	cmp    $0xa,%al
     d9e:	74 13                	je     db3 <gets+0x53>
     da0:	8a 45 ef             	mov    -0x11(%ebp),%al
     da3:	3c 0d                	cmp    $0xd,%al
     da5:	74 0c                	je     db3 <gets+0x53>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     daa:	40                   	inc    %eax
     dab:	3b 45 0c             	cmp    0xc(%ebp),%eax
     dae:	7c bf                	jl     d6f <gets+0xf>
     db0:	eb 01                	jmp    db3 <gets+0x53>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
     db2:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     db6:	03 45 08             	add    0x8(%ebp),%eax
     db9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     dbc:	8b 45 08             	mov    0x8(%ebp),%eax
}
     dbf:	c9                   	leave  
     dc0:	c3                   	ret    

00000dc1 <stat>:

int
stat(char *n, struct stat *st)
{
     dc1:	55                   	push   %ebp
     dc2:	89 e5                	mov    %esp,%ebp
     dc4:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     dc7:	83 ec 08             	sub    $0x8,%esp
     dca:	6a 00                	push   $0x0
     dcc:	ff 75 08             	pushl  0x8(%ebp)
     dcf:	e8 04 01 00 00       	call   ed8 <open>
     dd4:	83 c4 10             	add    $0x10,%esp
     dd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     dda:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     dde:	79 07                	jns    de7 <stat+0x26>
    return -1;
     de0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     de5:	eb 25                	jmp    e0c <stat+0x4b>
  r = fstat(fd, st);
     de7:	83 ec 08             	sub    $0x8,%esp
     dea:	ff 75 0c             	pushl  0xc(%ebp)
     ded:	ff 75 f4             	pushl  -0xc(%ebp)
     df0:	e8 fb 00 00 00       	call   ef0 <fstat>
     df5:	83 c4 10             	add    $0x10,%esp
     df8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     dfb:	83 ec 0c             	sub    $0xc,%esp
     dfe:	ff 75 f4             	pushl  -0xc(%ebp)
     e01:	e8 ba 00 00 00       	call   ec0 <close>
     e06:	83 c4 10             	add    $0x10,%esp
  return r;
     e09:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     e0c:	c9                   	leave  
     e0d:	c3                   	ret    

00000e0e <atoi>:

int
atoi(const char *s)
{
     e0e:	55                   	push   %ebp
     e0f:	89 e5                	mov    %esp,%ebp
     e11:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     e14:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     e1b:	eb 22                	jmp    e3f <atoi+0x31>
    n = n*10 + *s++ - '0';
     e1d:	8b 55 fc             	mov    -0x4(%ebp),%edx
     e20:	89 d0                	mov    %edx,%eax
     e22:	c1 e0 02             	shl    $0x2,%eax
     e25:	01 d0                	add    %edx,%eax
     e27:	d1 e0                	shl    %eax
     e29:	89 c2                	mov    %eax,%edx
     e2b:	8b 45 08             	mov    0x8(%ebp),%eax
     e2e:	8a 00                	mov    (%eax),%al
     e30:	0f be c0             	movsbl %al,%eax
     e33:	8d 04 02             	lea    (%edx,%eax,1),%eax
     e36:	83 e8 30             	sub    $0x30,%eax
     e39:	89 45 fc             	mov    %eax,-0x4(%ebp)
     e3c:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     e3f:	8b 45 08             	mov    0x8(%ebp),%eax
     e42:	8a 00                	mov    (%eax),%al
     e44:	3c 2f                	cmp    $0x2f,%al
     e46:	7e 09                	jle    e51 <atoi+0x43>
     e48:	8b 45 08             	mov    0x8(%ebp),%eax
     e4b:	8a 00                	mov    (%eax),%al
     e4d:	3c 39                	cmp    $0x39,%al
     e4f:	7e cc                	jle    e1d <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     e51:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     e54:	c9                   	leave  
     e55:	c3                   	ret    

00000e56 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     e56:	55                   	push   %ebp
     e57:	89 e5                	mov    %esp,%ebp
     e59:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     e5c:	8b 45 08             	mov    0x8(%ebp),%eax
     e5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     e62:	8b 45 0c             	mov    0xc(%ebp),%eax
     e65:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     e68:	eb 10                	jmp    e7a <memmove+0x24>
    *dst++ = *src++;
     e6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
     e6d:	8a 10                	mov    (%eax),%dl
     e6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e72:	88 10                	mov    %dl,(%eax)
     e74:	ff 45 fc             	incl   -0x4(%ebp)
     e77:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     e7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     e7e:	0f 9f c0             	setg   %al
     e81:	ff 4d 10             	decl   0x10(%ebp)
     e84:	84 c0                	test   %al,%al
     e86:	75 e2                	jne    e6a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     e88:	8b 45 08             	mov    0x8(%ebp),%eax
}
     e8b:	c9                   	leave  
     e8c:	c3                   	ret    
     e8d:	90                   	nop
     e8e:	90                   	nop
     e8f:	90                   	nop

00000e90 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     e90:	b8 01 00 00 00       	mov    $0x1,%eax
     e95:	cd 40                	int    $0x40
     e97:	c3                   	ret    

00000e98 <exit>:
SYSCALL(exit)
     e98:	b8 02 00 00 00       	mov    $0x2,%eax
     e9d:	cd 40                	int    $0x40
     e9f:	c3                   	ret    

00000ea0 <wait>:
SYSCALL(wait)
     ea0:	b8 03 00 00 00       	mov    $0x3,%eax
     ea5:	cd 40                	int    $0x40
     ea7:	c3                   	ret    

00000ea8 <pipe>:
SYSCALL(pipe)
     ea8:	b8 04 00 00 00       	mov    $0x4,%eax
     ead:	cd 40                	int    $0x40
     eaf:	c3                   	ret    

00000eb0 <read>:
SYSCALL(read)
     eb0:	b8 05 00 00 00       	mov    $0x5,%eax
     eb5:	cd 40                	int    $0x40
     eb7:	c3                   	ret    

00000eb8 <write>:
SYSCALL(write)
     eb8:	b8 10 00 00 00       	mov    $0x10,%eax
     ebd:	cd 40                	int    $0x40
     ebf:	c3                   	ret    

00000ec0 <close>:
SYSCALL(close)
     ec0:	b8 15 00 00 00       	mov    $0x15,%eax
     ec5:	cd 40                	int    $0x40
     ec7:	c3                   	ret    

00000ec8 <kill>:
SYSCALL(kill)
     ec8:	b8 06 00 00 00       	mov    $0x6,%eax
     ecd:	cd 40                	int    $0x40
     ecf:	c3                   	ret    

00000ed0 <exec>:
SYSCALL(exec)
     ed0:	b8 07 00 00 00       	mov    $0x7,%eax
     ed5:	cd 40                	int    $0x40
     ed7:	c3                   	ret    

00000ed8 <open>:
SYSCALL(open)
     ed8:	b8 0f 00 00 00       	mov    $0xf,%eax
     edd:	cd 40                	int    $0x40
     edf:	c3                   	ret    

00000ee0 <mknod>:
SYSCALL(mknod)
     ee0:	b8 11 00 00 00       	mov    $0x11,%eax
     ee5:	cd 40                	int    $0x40
     ee7:	c3                   	ret    

00000ee8 <unlink>:
SYSCALL(unlink)
     ee8:	b8 12 00 00 00       	mov    $0x12,%eax
     eed:	cd 40                	int    $0x40
     eef:	c3                   	ret    

00000ef0 <fstat>:
SYSCALL(fstat)
     ef0:	b8 08 00 00 00       	mov    $0x8,%eax
     ef5:	cd 40                	int    $0x40
     ef7:	c3                   	ret    

00000ef8 <link>:
SYSCALL(link)
     ef8:	b8 13 00 00 00       	mov    $0x13,%eax
     efd:	cd 40                	int    $0x40
     eff:	c3                   	ret    

00000f00 <mkdir>:
SYSCALL(mkdir)
     f00:	b8 14 00 00 00       	mov    $0x14,%eax
     f05:	cd 40                	int    $0x40
     f07:	c3                   	ret    

00000f08 <chdir>:
SYSCALL(chdir)
     f08:	b8 09 00 00 00       	mov    $0x9,%eax
     f0d:	cd 40                	int    $0x40
     f0f:	c3                   	ret    

00000f10 <dup>:
SYSCALL(dup)
     f10:	b8 0a 00 00 00       	mov    $0xa,%eax
     f15:	cd 40                	int    $0x40
     f17:	c3                   	ret    

00000f18 <getpid>:
SYSCALL(getpid)
     f18:	b8 0b 00 00 00       	mov    $0xb,%eax
     f1d:	cd 40                	int    $0x40
     f1f:	c3                   	ret    

00000f20 <sbrk>:
SYSCALL(sbrk)
     f20:	b8 0c 00 00 00       	mov    $0xc,%eax
     f25:	cd 40                	int    $0x40
     f27:	c3                   	ret    

00000f28 <sleep>:
SYSCALL(sleep)
     f28:	b8 0d 00 00 00       	mov    $0xd,%eax
     f2d:	cd 40                	int    $0x40
     f2f:	c3                   	ret    

00000f30 <uptime>:
SYSCALL(uptime)
     f30:	b8 0e 00 00 00       	mov    $0xe,%eax
     f35:	cd 40                	int    $0x40
     f37:	c3                   	ret    

00000f38 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     f38:	55                   	push   %ebp
     f39:	89 e5                	mov    %esp,%ebp
     f3b:	83 ec 18             	sub    $0x18,%esp
     f3e:	8b 45 0c             	mov    0xc(%ebp),%eax
     f41:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     f44:	83 ec 04             	sub    $0x4,%esp
     f47:	6a 01                	push   $0x1
     f49:	8d 45 f4             	lea    -0xc(%ebp),%eax
     f4c:	50                   	push   %eax
     f4d:	ff 75 08             	pushl  0x8(%ebp)
     f50:	e8 63 ff ff ff       	call   eb8 <write>
     f55:	83 c4 10             	add    $0x10,%esp
}
     f58:	c9                   	leave  
     f59:	c3                   	ret    

00000f5a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     f5a:	55                   	push   %ebp
     f5b:	89 e5                	mov    %esp,%ebp
     f5d:	83 ec 38             	sub    $0x38,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     f60:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     f67:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     f6b:	74 17                	je     f84 <printint+0x2a>
     f6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     f71:	79 11                	jns    f84 <printint+0x2a>
    neg = 1;
     f73:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     f7a:	8b 45 0c             	mov    0xc(%ebp),%eax
     f7d:	f7 d8                	neg    %eax
     f7f:	89 45 ec             	mov    %eax,-0x14(%ebp)
     f82:	eb 06                	jmp    f8a <printint+0x30>
  } else {
    x = xx;
     f84:	8b 45 0c             	mov    0xc(%ebp),%eax
     f87:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     f8a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     f91:	8b 4d 10             	mov    0x10(%ebp),%ecx
     f94:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f97:	ba 00 00 00 00       	mov    $0x0,%edx
     f9c:	f7 f1                	div    %ecx
     f9e:	89 d0                	mov    %edx,%eax
     fa0:	8a 90 b4 14 00 00    	mov    0x14b4(%eax),%dl
     fa6:	8d 45 dc             	lea    -0x24(%ebp),%eax
     fa9:	03 45 f4             	add    -0xc(%ebp),%eax
     fac:	88 10                	mov    %dl,(%eax)
     fae:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
     fb1:	8b 45 10             	mov    0x10(%ebp),%eax
     fb4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     fb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
     fba:	ba 00 00 00 00       	mov    $0x0,%edx
     fbf:	f7 75 d4             	divl   -0x2c(%ebp)
     fc2:	89 45 ec             	mov    %eax,-0x14(%ebp)
     fc5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     fc9:	75 c6                	jne    f91 <printint+0x37>
  if(neg)
     fcb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     fcf:	74 28                	je     ff9 <printint+0x9f>
    buf[i++] = '-';
     fd1:	8d 45 dc             	lea    -0x24(%ebp),%eax
     fd4:	03 45 f4             	add    -0xc(%ebp),%eax
     fd7:	c6 00 2d             	movb   $0x2d,(%eax)
     fda:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
     fdd:	eb 1a                	jmp    ff9 <printint+0x9f>
    putc(fd, buf[i]);
     fdf:	8d 45 dc             	lea    -0x24(%ebp),%eax
     fe2:	03 45 f4             	add    -0xc(%ebp),%eax
     fe5:	8a 00                	mov    (%eax),%al
     fe7:	0f be c0             	movsbl %al,%eax
     fea:	83 ec 08             	sub    $0x8,%esp
     fed:	50                   	push   %eax
     fee:	ff 75 08             	pushl  0x8(%ebp)
     ff1:	e8 42 ff ff ff       	call   f38 <putc>
     ff6:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     ff9:	ff 4d f4             	decl   -0xc(%ebp)
     ffc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1000:	79 dd                	jns    fdf <printint+0x85>
    putc(fd, buf[i]);
}
    1002:	c9                   	leave  
    1003:	c3                   	ret    

00001004 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1004:	55                   	push   %ebp
    1005:	89 e5                	mov    %esp,%ebp
    1007:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    100a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1011:	8d 45 0c             	lea    0xc(%ebp),%eax
    1014:	83 c0 04             	add    $0x4,%eax
    1017:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    101a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1021:	e9 58 01 00 00       	jmp    117e <printf+0x17a>
    c = fmt[i] & 0xff;
    1026:	8b 55 0c             	mov    0xc(%ebp),%edx
    1029:	8b 45 f0             	mov    -0x10(%ebp),%eax
    102c:	8d 04 02             	lea    (%edx,%eax,1),%eax
    102f:	8a 00                	mov    (%eax),%al
    1031:	0f be c0             	movsbl %al,%eax
    1034:	25 ff 00 00 00       	and    $0xff,%eax
    1039:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    103c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1040:	75 2c                	jne    106e <printf+0x6a>
      if(c == '%'){
    1042:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1046:	75 0c                	jne    1054 <printf+0x50>
        state = '%';
    1048:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    104f:	e9 27 01 00 00       	jmp    117b <printf+0x177>
      } else {
        putc(fd, c);
    1054:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1057:	0f be c0             	movsbl %al,%eax
    105a:	83 ec 08             	sub    $0x8,%esp
    105d:	50                   	push   %eax
    105e:	ff 75 08             	pushl  0x8(%ebp)
    1061:	e8 d2 fe ff ff       	call   f38 <putc>
    1066:	83 c4 10             	add    $0x10,%esp
    1069:	e9 0d 01 00 00       	jmp    117b <printf+0x177>
      }
    } else if(state == '%'){
    106e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1072:	0f 85 03 01 00 00    	jne    117b <printf+0x177>
      if(c == 'd'){
    1078:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    107c:	75 1e                	jne    109c <printf+0x98>
        printint(fd, *ap, 10, 1);
    107e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1081:	8b 00                	mov    (%eax),%eax
    1083:	6a 01                	push   $0x1
    1085:	6a 0a                	push   $0xa
    1087:	50                   	push   %eax
    1088:	ff 75 08             	pushl  0x8(%ebp)
    108b:	e8 ca fe ff ff       	call   f5a <printint>
    1090:	83 c4 10             	add    $0x10,%esp
        ap++;
    1093:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1097:	e9 d8 00 00 00       	jmp    1174 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    109c:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    10a0:	74 06                	je     10a8 <printf+0xa4>
    10a2:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    10a6:	75 1e                	jne    10c6 <printf+0xc2>
        printint(fd, *ap, 16, 0);
    10a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
    10ab:	8b 00                	mov    (%eax),%eax
    10ad:	6a 00                	push   $0x0
    10af:	6a 10                	push   $0x10
    10b1:	50                   	push   %eax
    10b2:	ff 75 08             	pushl  0x8(%ebp)
    10b5:	e8 a0 fe ff ff       	call   f5a <printint>
    10ba:	83 c4 10             	add    $0x10,%esp
        ap++;
    10bd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    10c1:	e9 ae 00 00 00       	jmp    1174 <printf+0x170>
      } else if(c == 's'){
    10c6:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    10ca:	75 43                	jne    110f <printf+0x10b>
        s = (char*)*ap;
    10cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
    10cf:	8b 00                	mov    (%eax),%eax
    10d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    10d4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    10d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    10dc:	75 25                	jne    1103 <printf+0xff>
          s = "(null)";
    10de:	c7 45 f4 9c 14 00 00 	movl   $0x149c,-0xc(%ebp)
        while(*s != 0){
    10e5:	eb 1d                	jmp    1104 <printf+0x100>
          putc(fd, *s);
    10e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10ea:	8a 00                	mov    (%eax),%al
    10ec:	0f be c0             	movsbl %al,%eax
    10ef:	83 ec 08             	sub    $0x8,%esp
    10f2:	50                   	push   %eax
    10f3:	ff 75 08             	pushl  0x8(%ebp)
    10f6:	e8 3d fe ff ff       	call   f38 <putc>
    10fb:	83 c4 10             	add    $0x10,%esp
          s++;
    10fe:	ff 45 f4             	incl   -0xc(%ebp)
    1101:	eb 01                	jmp    1104 <printf+0x100>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1103:	90                   	nop
    1104:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1107:	8a 00                	mov    (%eax),%al
    1109:	84 c0                	test   %al,%al
    110b:	75 da                	jne    10e7 <printf+0xe3>
    110d:	eb 65                	jmp    1174 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    110f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1113:	75 1d                	jne    1132 <printf+0x12e>
        putc(fd, *ap);
    1115:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1118:	8b 00                	mov    (%eax),%eax
    111a:	0f be c0             	movsbl %al,%eax
    111d:	83 ec 08             	sub    $0x8,%esp
    1120:	50                   	push   %eax
    1121:	ff 75 08             	pushl  0x8(%ebp)
    1124:	e8 0f fe ff ff       	call   f38 <putc>
    1129:	83 c4 10             	add    $0x10,%esp
        ap++;
    112c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1130:	eb 42                	jmp    1174 <printf+0x170>
      } else if(c == '%'){
    1132:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1136:	75 17                	jne    114f <printf+0x14b>
        putc(fd, c);
    1138:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    113b:	0f be c0             	movsbl %al,%eax
    113e:	83 ec 08             	sub    $0x8,%esp
    1141:	50                   	push   %eax
    1142:	ff 75 08             	pushl  0x8(%ebp)
    1145:	e8 ee fd ff ff       	call   f38 <putc>
    114a:	83 c4 10             	add    $0x10,%esp
    114d:	eb 25                	jmp    1174 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    114f:	83 ec 08             	sub    $0x8,%esp
    1152:	6a 25                	push   $0x25
    1154:	ff 75 08             	pushl  0x8(%ebp)
    1157:	e8 dc fd ff ff       	call   f38 <putc>
    115c:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    115f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1162:	0f be c0             	movsbl %al,%eax
    1165:	83 ec 08             	sub    $0x8,%esp
    1168:	50                   	push   %eax
    1169:	ff 75 08             	pushl  0x8(%ebp)
    116c:	e8 c7 fd ff ff       	call   f38 <putc>
    1171:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    1174:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    117b:	ff 45 f0             	incl   -0x10(%ebp)
    117e:	8b 55 0c             	mov    0xc(%ebp),%edx
    1181:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1184:	8d 04 02             	lea    (%edx,%eax,1),%eax
    1187:	8a 00                	mov    (%eax),%al
    1189:	84 c0                	test   %al,%al
    118b:	0f 85 95 fe ff ff    	jne    1026 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1191:	c9                   	leave  
    1192:	c3                   	ret    
    1193:	90                   	nop

00001194 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1194:	55                   	push   %ebp
    1195:	89 e5                	mov    %esp,%ebp
    1197:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    119a:	8b 45 08             	mov    0x8(%ebp),%eax
    119d:	83 e8 08             	sub    $0x8,%eax
    11a0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11a3:	a1 4c 15 00 00       	mov    0x154c,%eax
    11a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    11ab:	eb 24                	jmp    11d1 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11b0:	8b 00                	mov    (%eax),%eax
    11b2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    11b5:	77 12                	ja     11c9 <free+0x35>
    11b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11ba:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    11bd:	77 24                	ja     11e3 <free+0x4f>
    11bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11c2:	8b 00                	mov    (%eax),%eax
    11c4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    11c7:	77 1a                	ja     11e3 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11cc:	8b 00                	mov    (%eax),%eax
    11ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
    11d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11d4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    11d7:	76 d4                	jbe    11ad <free+0x19>
    11d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11dc:	8b 00                	mov    (%eax),%eax
    11de:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    11e1:	76 ca                	jbe    11ad <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    11e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11e6:	8b 40 04             	mov    0x4(%eax),%eax
    11e9:	c1 e0 03             	shl    $0x3,%eax
    11ec:	89 c2                	mov    %eax,%edx
    11ee:	03 55 f8             	add    -0x8(%ebp),%edx
    11f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11f4:	8b 00                	mov    (%eax),%eax
    11f6:	39 c2                	cmp    %eax,%edx
    11f8:	75 24                	jne    121e <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
    11fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11fd:	8b 50 04             	mov    0x4(%eax),%edx
    1200:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1203:	8b 00                	mov    (%eax),%eax
    1205:	8b 40 04             	mov    0x4(%eax),%eax
    1208:	01 c2                	add    %eax,%edx
    120a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    120d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1210:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1213:	8b 00                	mov    (%eax),%eax
    1215:	8b 10                	mov    (%eax),%edx
    1217:	8b 45 f8             	mov    -0x8(%ebp),%eax
    121a:	89 10                	mov    %edx,(%eax)
    121c:	eb 0a                	jmp    1228 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
    121e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1221:	8b 10                	mov    (%eax),%edx
    1223:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1226:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1228:	8b 45 fc             	mov    -0x4(%ebp),%eax
    122b:	8b 40 04             	mov    0x4(%eax),%eax
    122e:	c1 e0 03             	shl    $0x3,%eax
    1231:	03 45 fc             	add    -0x4(%ebp),%eax
    1234:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1237:	75 20                	jne    1259 <free+0xc5>
    p->s.size += bp->s.size;
    1239:	8b 45 fc             	mov    -0x4(%ebp),%eax
    123c:	8b 50 04             	mov    0x4(%eax),%edx
    123f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1242:	8b 40 04             	mov    0x4(%eax),%eax
    1245:	01 c2                	add    %eax,%edx
    1247:	8b 45 fc             	mov    -0x4(%ebp),%eax
    124a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    124d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1250:	8b 10                	mov    (%eax),%edx
    1252:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1255:	89 10                	mov    %edx,(%eax)
    1257:	eb 08                	jmp    1261 <free+0xcd>
  } else
    p->s.ptr = bp;
    1259:	8b 45 fc             	mov    -0x4(%ebp),%eax
    125c:	8b 55 f8             	mov    -0x8(%ebp),%edx
    125f:	89 10                	mov    %edx,(%eax)
  freep = p;
    1261:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1264:	a3 4c 15 00 00       	mov    %eax,0x154c
}
    1269:	c9                   	leave  
    126a:	c3                   	ret    

0000126b <morecore>:

static Header*
morecore(uint nu)
{
    126b:	55                   	push   %ebp
    126c:	89 e5                	mov    %esp,%ebp
    126e:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1271:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1278:	77 07                	ja     1281 <morecore+0x16>
    nu = 4096;
    127a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1281:	8b 45 08             	mov    0x8(%ebp),%eax
    1284:	c1 e0 03             	shl    $0x3,%eax
    1287:	83 ec 0c             	sub    $0xc,%esp
    128a:	50                   	push   %eax
    128b:	e8 90 fc ff ff       	call   f20 <sbrk>
    1290:	83 c4 10             	add    $0x10,%esp
    1293:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1296:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    129a:	75 07                	jne    12a3 <morecore+0x38>
    return 0;
    129c:	b8 00 00 00 00       	mov    $0x0,%eax
    12a1:	eb 26                	jmp    12c9 <morecore+0x5e>
  hp = (Header*)p;
    12a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    12a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12ac:	8b 55 08             	mov    0x8(%ebp),%edx
    12af:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    12b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12b5:	83 c0 08             	add    $0x8,%eax
    12b8:	83 ec 0c             	sub    $0xc,%esp
    12bb:	50                   	push   %eax
    12bc:	e8 d3 fe ff ff       	call   1194 <free>
    12c1:	83 c4 10             	add    $0x10,%esp
  return freep;
    12c4:	a1 4c 15 00 00       	mov    0x154c,%eax
}
    12c9:	c9                   	leave  
    12ca:	c3                   	ret    

000012cb <malloc>:

void*
malloc(uint nbytes)
{
    12cb:	55                   	push   %ebp
    12cc:	89 e5                	mov    %esp,%ebp
    12ce:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    12d1:	8b 45 08             	mov    0x8(%ebp),%eax
    12d4:	83 c0 07             	add    $0x7,%eax
    12d7:	c1 e8 03             	shr    $0x3,%eax
    12da:	40                   	inc    %eax
    12db:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    12de:	a1 4c 15 00 00       	mov    0x154c,%eax
    12e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    12e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    12ea:	75 23                	jne    130f <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
    12ec:	c7 45 f0 44 15 00 00 	movl   $0x1544,-0x10(%ebp)
    12f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12f6:	a3 4c 15 00 00       	mov    %eax,0x154c
    12fb:	a1 4c 15 00 00       	mov    0x154c,%eax
    1300:	a3 44 15 00 00       	mov    %eax,0x1544
    base.s.size = 0;
    1305:	c7 05 48 15 00 00 00 	movl   $0x0,0x1548
    130c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    130f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1312:	8b 00                	mov    (%eax),%eax
    1314:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1317:	8b 45 f4             	mov    -0xc(%ebp),%eax
    131a:	8b 40 04             	mov    0x4(%eax),%eax
    131d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1320:	72 4d                	jb     136f <malloc+0xa4>
      if(p->s.size == nunits)
    1322:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1325:	8b 40 04             	mov    0x4(%eax),%eax
    1328:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    132b:	75 0c                	jne    1339 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
    132d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1330:	8b 10                	mov    (%eax),%edx
    1332:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1335:	89 10                	mov    %edx,(%eax)
    1337:	eb 26                	jmp    135f <malloc+0x94>
      else {
        p->s.size -= nunits;
    1339:	8b 45 f4             	mov    -0xc(%ebp),%eax
    133c:	8b 40 04             	mov    0x4(%eax),%eax
    133f:	89 c2                	mov    %eax,%edx
    1341:	2b 55 ec             	sub    -0x14(%ebp),%edx
    1344:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1347:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    134a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    134d:	8b 40 04             	mov    0x4(%eax),%eax
    1350:	c1 e0 03             	shl    $0x3,%eax
    1353:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1356:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1359:	8b 55 ec             	mov    -0x14(%ebp),%edx
    135c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    135f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1362:	a3 4c 15 00 00       	mov    %eax,0x154c
      return (void*)(p + 1);
    1367:	8b 45 f4             	mov    -0xc(%ebp),%eax
    136a:	83 c0 08             	add    $0x8,%eax
    136d:	eb 3b                	jmp    13aa <malloc+0xdf>
    }
    if(p == freep)
    136f:	a1 4c 15 00 00       	mov    0x154c,%eax
    1374:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1377:	75 1e                	jne    1397 <malloc+0xcc>
      if((p = morecore(nunits)) == 0)
    1379:	83 ec 0c             	sub    $0xc,%esp
    137c:	ff 75 ec             	pushl  -0x14(%ebp)
    137f:	e8 e7 fe ff ff       	call   126b <morecore>
    1384:	83 c4 10             	add    $0x10,%esp
    1387:	89 45 f4             	mov    %eax,-0xc(%ebp)
    138a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    138e:	75 07                	jne    1397 <malloc+0xcc>
        return 0;
    1390:	b8 00 00 00 00       	mov    $0x0,%eax
    1395:	eb 13                	jmp    13aa <malloc+0xdf>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1397:	8b 45 f4             	mov    -0xc(%ebp),%eax
    139a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    139d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13a0:	8b 00                	mov    (%eax),%eax
    13a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    13a5:	e9 6d ff ff ff       	jmp    1317 <malloc+0x4c>
}
    13aa:	c9                   	leave  
    13ab:	c3                   	ret    
