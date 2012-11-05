
_usertests:     file format elf32-i386


Disassembly of section .text:

00000000 <opentest>:

// simple file system tests

void
opentest(void)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 18             	sub    $0x18,%esp
  int fd;

  printf(stdout, "open test\n");
       6:	a1 c0 57 00 00       	mov    0x57c0,%eax
       b:	83 ec 08             	sub    $0x8,%esp
       e:	68 f6 40 00 00       	push   $0x40f6
      13:	50                   	push   %eax
      14:	e8 1f 3d 00 00       	call   3d38 <printf>
      19:	83 c4 10             	add    $0x10,%esp
  fd = open("echo", 0);
      1c:	83 ec 08             	sub    $0x8,%esp
      1f:	6a 00                	push   $0x0
      21:	68 e0 40 00 00       	push   $0x40e0
      26:	e8 e1 3b 00 00       	call   3c0c <open>
      2b:	83 c4 10             	add    $0x10,%esp
      2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
      31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
      35:	79 1b                	jns    52 <opentest+0x52>
    printf(stdout, "open echo failed!\n");
      37:	a1 c0 57 00 00       	mov    0x57c0,%eax
      3c:	83 ec 08             	sub    $0x8,%esp
      3f:	68 01 41 00 00       	push   $0x4101
      44:	50                   	push   %eax
      45:	e8 ee 3c 00 00       	call   3d38 <printf>
      4a:	83 c4 10             	add    $0x10,%esp
    exit();
      4d:	e8 7a 3b 00 00       	call   3bcc <exit>
  }
  close(fd);
      52:	83 ec 0c             	sub    $0xc,%esp
      55:	ff 75 f4             	pushl  -0xc(%ebp)
      58:	e8 97 3b 00 00       	call   3bf4 <close>
      5d:	83 c4 10             	add    $0x10,%esp
  fd = open("doesnotexist", 0);
      60:	83 ec 08             	sub    $0x8,%esp
      63:	6a 00                	push   $0x0
      65:	68 14 41 00 00       	push   $0x4114
      6a:	e8 9d 3b 00 00       	call   3c0c <open>
      6f:	83 c4 10             	add    $0x10,%esp
      72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
      75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
      79:	78 1b                	js     96 <opentest+0x96>
    printf(stdout, "open doesnotexist succeeded!\n");
      7b:	a1 c0 57 00 00       	mov    0x57c0,%eax
      80:	83 ec 08             	sub    $0x8,%esp
      83:	68 21 41 00 00       	push   $0x4121
      88:	50                   	push   %eax
      89:	e8 aa 3c 00 00       	call   3d38 <printf>
      8e:	83 c4 10             	add    $0x10,%esp
    exit();
      91:	e8 36 3b 00 00       	call   3bcc <exit>
  }
  printf(stdout, "open test ok\n");
      96:	a1 c0 57 00 00       	mov    0x57c0,%eax
      9b:	83 ec 08             	sub    $0x8,%esp
      9e:	68 3f 41 00 00       	push   $0x413f
      a3:	50                   	push   %eax
      a4:	e8 8f 3c 00 00       	call   3d38 <printf>
      a9:	83 c4 10             	add    $0x10,%esp
}
      ac:	c9                   	leave  
      ad:	c3                   	ret    

000000ae <writetest>:

void
writetest(void)
{
      ae:	55                   	push   %ebp
      af:	89 e5                	mov    %esp,%ebp
      b1:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int i;

  printf(stdout, "small file test\n");
      b4:	a1 c0 57 00 00       	mov    0x57c0,%eax
      b9:	83 ec 08             	sub    $0x8,%esp
      bc:	68 4d 41 00 00       	push   $0x414d
      c1:	50                   	push   %eax
      c2:	e8 71 3c 00 00       	call   3d38 <printf>
      c7:	83 c4 10             	add    $0x10,%esp
  fd = open("small", O_CREATE|O_RDWR);
      ca:	83 ec 08             	sub    $0x8,%esp
      cd:	68 02 02 00 00       	push   $0x202
      d2:	68 5e 41 00 00       	push   $0x415e
      d7:	e8 30 3b 00 00       	call   3c0c <open>
      dc:	83 c4 10             	add    $0x10,%esp
      df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
      e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
      e6:	78 22                	js     10a <writetest+0x5c>
    printf(stdout, "creat small succeeded; ok\n");
      e8:	a1 c0 57 00 00       	mov    0x57c0,%eax
      ed:	83 ec 08             	sub    $0x8,%esp
      f0:	68 64 41 00 00       	push   $0x4164
      f5:	50                   	push   %eax
      f6:	e8 3d 3c 00 00       	call   3d38 <printf>
      fb:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
      fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     105:	e9 8e 00 00 00       	jmp    198 <writetest+0xea>
  printf(stdout, "small file test\n");
  fd = open("small", O_CREATE|O_RDWR);
  if(fd >= 0){
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
     10a:	a1 c0 57 00 00       	mov    0x57c0,%eax
     10f:	83 ec 08             	sub    $0x8,%esp
     112:	68 7f 41 00 00       	push   $0x417f
     117:	50                   	push   %eax
     118:	e8 1b 3c 00 00       	call   3d38 <printf>
     11d:	83 c4 10             	add    $0x10,%esp
    exit();
     120:	e8 a7 3a 00 00       	call   3bcc <exit>
  }
  for(i = 0; i < 100; i++){
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     125:	83 ec 04             	sub    $0x4,%esp
     128:	6a 0a                	push   $0xa
     12a:	68 9b 41 00 00       	push   $0x419b
     12f:	ff 75 f0             	pushl  -0x10(%ebp)
     132:	e8 b5 3a 00 00       	call   3bec <write>
     137:	83 c4 10             	add    $0x10,%esp
     13a:	83 f8 0a             	cmp    $0xa,%eax
     13d:	74 1e                	je     15d <writetest+0xaf>
      printf(stdout, "error: write aa %d new file failed\n", i);
     13f:	a1 c0 57 00 00       	mov    0x57c0,%eax
     144:	83 ec 04             	sub    $0x4,%esp
     147:	ff 75 f4             	pushl  -0xc(%ebp)
     14a:	68 a8 41 00 00       	push   $0x41a8
     14f:	50                   	push   %eax
     150:	e8 e3 3b 00 00       	call   3d38 <printf>
     155:	83 c4 10             	add    $0x10,%esp
      exit();
     158:	e8 6f 3a 00 00       	call   3bcc <exit>
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     15d:	83 ec 04             	sub    $0x4,%esp
     160:	6a 0a                	push   $0xa
     162:	68 cc 41 00 00       	push   $0x41cc
     167:	ff 75 f0             	pushl  -0x10(%ebp)
     16a:	e8 7d 3a 00 00       	call   3bec <write>
     16f:	83 c4 10             	add    $0x10,%esp
     172:	83 f8 0a             	cmp    $0xa,%eax
     175:	74 1e                	je     195 <writetest+0xe7>
      printf(stdout, "error: write bb %d new file failed\n", i);
     177:	a1 c0 57 00 00       	mov    0x57c0,%eax
     17c:	83 ec 04             	sub    $0x4,%esp
     17f:	ff 75 f4             	pushl  -0xc(%ebp)
     182:	68 d8 41 00 00       	push   $0x41d8
     187:	50                   	push   %eax
     188:	e8 ab 3b 00 00       	call   3d38 <printf>
     18d:	83 c4 10             	add    $0x10,%esp
      exit();
     190:	e8 37 3a 00 00       	call   3bcc <exit>
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     195:	ff 45 f4             	incl   -0xc(%ebp)
     198:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     19c:	7e 87                	jle    125 <writetest+0x77>
    if(write(fd, "bbbbbbbbbb", 10) != 10){
      printf(stdout, "error: write bb %d new file failed\n", i);
      exit();
    }
  }
  printf(stdout, "writes ok\n");
     19e:	a1 c0 57 00 00       	mov    0x57c0,%eax
     1a3:	83 ec 08             	sub    $0x8,%esp
     1a6:	68 fc 41 00 00       	push   $0x41fc
     1ab:	50                   	push   %eax
     1ac:	e8 87 3b 00 00       	call   3d38 <printf>
     1b1:	83 c4 10             	add    $0x10,%esp
  close(fd);
     1b4:	83 ec 0c             	sub    $0xc,%esp
     1b7:	ff 75 f0             	pushl  -0x10(%ebp)
     1ba:	e8 35 3a 00 00       	call   3bf4 <close>
     1bf:	83 c4 10             	add    $0x10,%esp
  fd = open("small", O_RDONLY);
     1c2:	83 ec 08             	sub    $0x8,%esp
     1c5:	6a 00                	push   $0x0
     1c7:	68 5e 41 00 00       	push   $0x415e
     1cc:	e8 3b 3a 00 00       	call   3c0c <open>
     1d1:	83 c4 10             	add    $0x10,%esp
     1d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
     1d7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     1db:	78 3c                	js     219 <writetest+0x16b>
    printf(stdout, "open small succeeded ok\n");
     1dd:	a1 c0 57 00 00       	mov    0x57c0,%eax
     1e2:	83 ec 08             	sub    $0x8,%esp
     1e5:	68 07 42 00 00       	push   $0x4207
     1ea:	50                   	push   %eax
     1eb:	e8 48 3b 00 00       	call   3d38 <printf>
     1f0:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(stdout, "error: open small failed!\n");
    exit();
  }
  i = read(fd, buf, 2000);
     1f3:	83 ec 04             	sub    $0x4,%esp
     1f6:	68 d0 07 00 00       	push   $0x7d0
     1fb:	68 a0 7f 00 00       	push   $0x7fa0
     200:	ff 75 f0             	pushl  -0x10(%ebp)
     203:	e8 dc 39 00 00       	call   3be4 <read>
     208:	83 c4 10             	add    $0x10,%esp
     20b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(i == 2000){
     20e:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
     215:	74 1d                	je     234 <writetest+0x186>
     217:	eb 55                	jmp    26e <writetest+0x1c0>
  close(fd);
  fd = open("small", O_RDONLY);
  if(fd >= 0){
    printf(stdout, "open small succeeded ok\n");
  } else {
    printf(stdout, "error: open small failed!\n");
     219:	a1 c0 57 00 00       	mov    0x57c0,%eax
     21e:	83 ec 08             	sub    $0x8,%esp
     221:	68 20 42 00 00       	push   $0x4220
     226:	50                   	push   %eax
     227:	e8 0c 3b 00 00       	call   3d38 <printf>
     22c:	83 c4 10             	add    $0x10,%esp
    exit();
     22f:	e8 98 39 00 00       	call   3bcc <exit>
  }
  i = read(fd, buf, 2000);
  if(i == 2000){
    printf(stdout, "read succeeded ok\n");
     234:	a1 c0 57 00 00       	mov    0x57c0,%eax
     239:	83 ec 08             	sub    $0x8,%esp
     23c:	68 3b 42 00 00       	push   $0x423b
     241:	50                   	push   %eax
     242:	e8 f1 3a 00 00       	call   3d38 <printf>
     247:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(stdout, "read failed\n");
    exit();
  }
  close(fd);
     24a:	83 ec 0c             	sub    $0xc,%esp
     24d:	ff 75 f0             	pushl  -0x10(%ebp)
     250:	e8 9f 39 00 00       	call   3bf4 <close>
     255:	83 c4 10             	add    $0x10,%esp

  if(unlink("small") < 0){
     258:	83 ec 0c             	sub    $0xc,%esp
     25b:	68 5e 41 00 00       	push   $0x415e
     260:	e8 b7 39 00 00       	call   3c1c <unlink>
     265:	83 c4 10             	add    $0x10,%esp
     268:	85 c0                	test   %eax,%eax
     26a:	78 1d                	js     289 <writetest+0x1db>
     26c:	eb 36                	jmp    2a4 <writetest+0x1f6>
  }
  i = read(fd, buf, 2000);
  if(i == 2000){
    printf(stdout, "read succeeded ok\n");
  } else {
    printf(stdout, "read failed\n");
     26e:	a1 c0 57 00 00       	mov    0x57c0,%eax
     273:	83 ec 08             	sub    $0x8,%esp
     276:	68 4e 42 00 00       	push   $0x424e
     27b:	50                   	push   %eax
     27c:	e8 b7 3a 00 00       	call   3d38 <printf>
     281:	83 c4 10             	add    $0x10,%esp
    exit();
     284:	e8 43 39 00 00       	call   3bcc <exit>
  }
  close(fd);

  if(unlink("small") < 0){
    printf(stdout, "unlink small failed\n");
     289:	a1 c0 57 00 00       	mov    0x57c0,%eax
     28e:	83 ec 08             	sub    $0x8,%esp
     291:	68 5b 42 00 00       	push   $0x425b
     296:	50                   	push   %eax
     297:	e8 9c 3a 00 00       	call   3d38 <printf>
     29c:	83 c4 10             	add    $0x10,%esp
    exit();
     29f:	e8 28 39 00 00       	call   3bcc <exit>
  }
  printf(stdout, "small file test ok\n");
     2a4:	a1 c0 57 00 00       	mov    0x57c0,%eax
     2a9:	83 ec 08             	sub    $0x8,%esp
     2ac:	68 70 42 00 00       	push   $0x4270
     2b1:	50                   	push   %eax
     2b2:	e8 81 3a 00 00       	call   3d38 <printf>
     2b7:	83 c4 10             	add    $0x10,%esp
}
     2ba:	c9                   	leave  
     2bb:	c3                   	ret    

000002bc <writetest1>:

void
writetest1(void)
{
     2bc:	55                   	push   %ebp
     2bd:	89 e5                	mov    %esp,%ebp
     2bf:	83 ec 18             	sub    $0x18,%esp
  int i, fd, n;

  printf(stdout, "big files test\n");
     2c2:	a1 c0 57 00 00       	mov    0x57c0,%eax
     2c7:	83 ec 08             	sub    $0x8,%esp
     2ca:	68 84 42 00 00       	push   $0x4284
     2cf:	50                   	push   %eax
     2d0:	e8 63 3a 00 00       	call   3d38 <printf>
     2d5:	83 c4 10             	add    $0x10,%esp

  fd = open("big", O_CREATE|O_RDWR);
     2d8:	83 ec 08             	sub    $0x8,%esp
     2db:	68 02 02 00 00       	push   $0x202
     2e0:	68 94 42 00 00       	push   $0x4294
     2e5:	e8 22 39 00 00       	call   3c0c <open>
     2ea:	83 c4 10             	add    $0x10,%esp
     2ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     2f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     2f4:	79 1b                	jns    311 <writetest1+0x55>
    printf(stdout, "error: creat big failed!\n");
     2f6:	a1 c0 57 00 00       	mov    0x57c0,%eax
     2fb:	83 ec 08             	sub    $0x8,%esp
     2fe:	68 98 42 00 00       	push   $0x4298
     303:	50                   	push   %eax
     304:	e8 2f 3a 00 00       	call   3d38 <printf>
     309:	83 c4 10             	add    $0x10,%esp
    exit();
     30c:	e8 bb 38 00 00       	call   3bcc <exit>
  }

  for(i = 0; i < MAXFILE; i++){
     311:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     318:	eb 4a                	jmp    364 <writetest1+0xa8>
    ((int*)buf)[0] = i;
     31a:	b8 a0 7f 00 00       	mov    $0x7fa0,%eax
     31f:	8b 55 f4             	mov    -0xc(%ebp),%edx
     322:	89 10                	mov    %edx,(%eax)
    if(write(fd, buf, 512) != 512){
     324:	83 ec 04             	sub    $0x4,%esp
     327:	68 00 02 00 00       	push   $0x200
     32c:	68 a0 7f 00 00       	push   $0x7fa0
     331:	ff 75 ec             	pushl  -0x14(%ebp)
     334:	e8 b3 38 00 00       	call   3bec <write>
     339:	83 c4 10             	add    $0x10,%esp
     33c:	3d 00 02 00 00       	cmp    $0x200,%eax
     341:	74 1e                	je     361 <writetest1+0xa5>
      printf(stdout, "error: write big file failed\n", i);
     343:	a1 c0 57 00 00       	mov    0x57c0,%eax
     348:	83 ec 04             	sub    $0x4,%esp
     34b:	ff 75 f4             	pushl  -0xc(%ebp)
     34e:	68 b2 42 00 00       	push   $0x42b2
     353:	50                   	push   %eax
     354:	e8 df 39 00 00       	call   3d38 <printf>
     359:	83 c4 10             	add    $0x10,%esp
      exit();
     35c:	e8 6b 38 00 00       	call   3bcc <exit>
  if(fd < 0){
    printf(stdout, "error: creat big failed!\n");
    exit();
  }

  for(i = 0; i < MAXFILE; i++){
     361:	ff 45 f4             	incl   -0xc(%ebp)
     364:	8b 45 f4             	mov    -0xc(%ebp),%eax
     367:	3d 8b 00 00 00       	cmp    $0x8b,%eax
     36c:	76 ac                	jbe    31a <writetest1+0x5e>
      printf(stdout, "error: write big file failed\n", i);
      exit();
    }
  }

  close(fd);
     36e:	83 ec 0c             	sub    $0xc,%esp
     371:	ff 75 ec             	pushl  -0x14(%ebp)
     374:	e8 7b 38 00 00       	call   3bf4 <close>
     379:	83 c4 10             	add    $0x10,%esp

  fd = open("big", O_RDONLY);
     37c:	83 ec 08             	sub    $0x8,%esp
     37f:	6a 00                	push   $0x0
     381:	68 94 42 00 00       	push   $0x4294
     386:	e8 81 38 00 00       	call   3c0c <open>
     38b:	83 c4 10             	add    $0x10,%esp
     38e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     391:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     395:	79 1b                	jns    3b2 <writetest1+0xf6>
    printf(stdout, "error: open big failed!\n");
     397:	a1 c0 57 00 00       	mov    0x57c0,%eax
     39c:	83 ec 08             	sub    $0x8,%esp
     39f:	68 d0 42 00 00       	push   $0x42d0
     3a4:	50                   	push   %eax
     3a5:	e8 8e 39 00 00       	call   3d38 <printf>
     3aa:	83 c4 10             	add    $0x10,%esp
    exit();
     3ad:	e8 1a 38 00 00       	call   3bcc <exit>
  }

  n = 0;
     3b2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(;;){
    i = read(fd, buf, 512);
     3b9:	83 ec 04             	sub    $0x4,%esp
     3bc:	68 00 02 00 00       	push   $0x200
     3c1:	68 a0 7f 00 00       	push   $0x7fa0
     3c6:	ff 75 ec             	pushl  -0x14(%ebp)
     3c9:	e8 16 38 00 00       	call   3be4 <read>
     3ce:	83 c4 10             	add    $0x10,%esp
     3d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(i == 0){
     3d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     3d8:	75 4b                	jne    425 <writetest1+0x169>
      if(n == MAXFILE - 1){
     3da:	81 7d f0 8b 00 00 00 	cmpl   $0x8b,-0x10(%ebp)
     3e1:	75 1e                	jne    401 <writetest1+0x145>
        printf(stdout, "read only %d blocks from big", n);
     3e3:	a1 c0 57 00 00       	mov    0x57c0,%eax
     3e8:	83 ec 04             	sub    $0x4,%esp
     3eb:	ff 75 f0             	pushl  -0x10(%ebp)
     3ee:	68 e9 42 00 00       	push   $0x42e9
     3f3:	50                   	push   %eax
     3f4:	e8 3f 39 00 00       	call   3d38 <printf>
     3f9:	83 c4 10             	add    $0x10,%esp
        exit();
     3fc:	e8 cb 37 00 00       	call   3bcc <exit>
             n, ((int*)buf)[0]);
      exit();
    }
    n++;
  }
  close(fd);
     401:	83 ec 0c             	sub    $0xc,%esp
     404:	ff 75 ec             	pushl  -0x14(%ebp)
     407:	e8 e8 37 00 00       	call   3bf4 <close>
     40c:	83 c4 10             	add    $0x10,%esp
  if(unlink("big") < 0){
     40f:	83 ec 0c             	sub    $0xc,%esp
     412:	68 94 42 00 00       	push   $0x4294
     417:	e8 00 38 00 00       	call   3c1c <unlink>
     41c:	83 c4 10             	add    $0x10,%esp
     41f:	85 c0                	test   %eax,%eax
     421:	78 60                	js     483 <writetest1+0x1c7>
     423:	eb 79                	jmp    49e <writetest1+0x1e2>
      if(n == MAXFILE - 1){
        printf(stdout, "read only %d blocks from big", n);
        exit();
      }
      break;
    } else if(i != 512){
     425:	81 7d f4 00 02 00 00 	cmpl   $0x200,-0xc(%ebp)
     42c:	74 1e                	je     44c <writetest1+0x190>
      printf(stdout, "read failed %d\n", i);
     42e:	a1 c0 57 00 00       	mov    0x57c0,%eax
     433:	83 ec 04             	sub    $0x4,%esp
     436:	ff 75 f4             	pushl  -0xc(%ebp)
     439:	68 06 43 00 00       	push   $0x4306
     43e:	50                   	push   %eax
     43f:	e8 f4 38 00 00       	call   3d38 <printf>
     444:	83 c4 10             	add    $0x10,%esp
      exit();
     447:	e8 80 37 00 00       	call   3bcc <exit>
    }
    if(((int*)buf)[0] != n){
     44c:	b8 a0 7f 00 00       	mov    $0x7fa0,%eax
     451:	8b 00                	mov    (%eax),%eax
     453:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     456:	74 23                	je     47b <writetest1+0x1bf>
      printf(stdout, "read content of block %d is %d\n",
             n, ((int*)buf)[0]);
     458:	b8 a0 7f 00 00       	mov    $0x7fa0,%eax
    } else if(i != 512){
      printf(stdout, "read failed %d\n", i);
      exit();
    }
    if(((int*)buf)[0] != n){
      printf(stdout, "read content of block %d is %d\n",
     45d:	8b 10                	mov    (%eax),%edx
     45f:	a1 c0 57 00 00       	mov    0x57c0,%eax
     464:	52                   	push   %edx
     465:	ff 75 f0             	pushl  -0x10(%ebp)
     468:	68 18 43 00 00       	push   $0x4318
     46d:	50                   	push   %eax
     46e:	e8 c5 38 00 00       	call   3d38 <printf>
     473:	83 c4 10             	add    $0x10,%esp
             n, ((int*)buf)[0]);
      exit();
     476:	e8 51 37 00 00       	call   3bcc <exit>
    }
    n++;
     47b:	ff 45 f0             	incl   -0x10(%ebp)
  }
     47e:	e9 36 ff ff ff       	jmp    3b9 <writetest1+0xfd>
  close(fd);
  if(unlink("big") < 0){
    printf(stdout, "unlink big failed\n");
     483:	a1 c0 57 00 00       	mov    0x57c0,%eax
     488:	83 ec 08             	sub    $0x8,%esp
     48b:	68 38 43 00 00       	push   $0x4338
     490:	50                   	push   %eax
     491:	e8 a2 38 00 00       	call   3d38 <printf>
     496:	83 c4 10             	add    $0x10,%esp
    exit();
     499:	e8 2e 37 00 00       	call   3bcc <exit>
  }
  printf(stdout, "big files ok\n");
     49e:	a1 c0 57 00 00       	mov    0x57c0,%eax
     4a3:	83 ec 08             	sub    $0x8,%esp
     4a6:	68 4b 43 00 00       	push   $0x434b
     4ab:	50                   	push   %eax
     4ac:	e8 87 38 00 00       	call   3d38 <printf>
     4b1:	83 c4 10             	add    $0x10,%esp
}
     4b4:	c9                   	leave  
     4b5:	c3                   	ret    

000004b6 <createtest>:

void
createtest(void)
{
     4b6:	55                   	push   %ebp
     4b7:	89 e5                	mov    %esp,%ebp
     4b9:	83 ec 18             	sub    $0x18,%esp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
     4bc:	a1 c0 57 00 00       	mov    0x57c0,%eax
     4c1:	83 ec 08             	sub    $0x8,%esp
     4c4:	68 5c 43 00 00       	push   $0x435c
     4c9:	50                   	push   %eax
     4ca:	e8 69 38 00 00       	call   3d38 <printf>
     4cf:	83 c4 10             	add    $0x10,%esp

  name[0] = 'a';
     4d2:	c6 05 a0 9f 00 00 61 	movb   $0x61,0x9fa0
  name[2] = '\0';
     4d9:	c6 05 a2 9f 00 00 00 	movb   $0x0,0x9fa2
  for(i = 0; i < 52; i++){
     4e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     4e7:	eb 34                	jmp    51d <createtest+0x67>
    name[1] = '0' + i;
     4e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4ec:	83 c0 30             	add    $0x30,%eax
     4ef:	a2 a1 9f 00 00       	mov    %al,0x9fa1
    fd = open(name, O_CREATE|O_RDWR);
     4f4:	83 ec 08             	sub    $0x8,%esp
     4f7:	68 02 02 00 00       	push   $0x202
     4fc:	68 a0 9f 00 00       	push   $0x9fa0
     501:	e8 06 37 00 00       	call   3c0c <open>
     506:	83 c4 10             	add    $0x10,%esp
     509:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(fd);
     50c:	83 ec 0c             	sub    $0xc,%esp
     50f:	ff 75 f0             	pushl  -0x10(%ebp)
     512:	e8 dd 36 00 00       	call   3bf4 <close>
     517:	83 c4 10             	add    $0x10,%esp

  printf(stdout, "many creates, followed by unlink test\n");

  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
     51a:	ff 45 f4             	incl   -0xc(%ebp)
     51d:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     521:	7e c6                	jle    4e9 <createtest+0x33>
    name[1] = '0' + i;
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
     523:	c6 05 a0 9f 00 00 61 	movb   $0x61,0x9fa0
  name[2] = '\0';
     52a:	c6 05 a2 9f 00 00 00 	movb   $0x0,0x9fa2
  for(i = 0; i < 52; i++){
     531:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     538:	eb 1e                	jmp    558 <createtest+0xa2>
    name[1] = '0' + i;
     53a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     53d:	83 c0 30             	add    $0x30,%eax
     540:	a2 a1 9f 00 00       	mov    %al,0x9fa1
    unlink(name);
     545:	83 ec 0c             	sub    $0xc,%esp
     548:	68 a0 9f 00 00       	push   $0x9fa0
     54d:	e8 ca 36 00 00       	call   3c1c <unlink>
     552:	83 c4 10             	add    $0x10,%esp
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
     555:	ff 45 f4             	incl   -0xc(%ebp)
     558:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     55c:	7e dc                	jle    53a <createtest+0x84>
    name[1] = '0' + i;
    unlink(name);
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
     55e:	a1 c0 57 00 00       	mov    0x57c0,%eax
     563:	83 ec 08             	sub    $0x8,%esp
     566:	68 84 43 00 00       	push   $0x4384
     56b:	50                   	push   %eax
     56c:	e8 c7 37 00 00       	call   3d38 <printf>
     571:	83 c4 10             	add    $0x10,%esp
}
     574:	c9                   	leave  
     575:	c3                   	ret    

00000576 <dirtest>:

void dirtest(void)
{
     576:	55                   	push   %ebp
     577:	89 e5                	mov    %esp,%ebp
     579:	83 ec 08             	sub    $0x8,%esp
  printf(stdout, "mkdir test\n");
     57c:	a1 c0 57 00 00       	mov    0x57c0,%eax
     581:	83 ec 08             	sub    $0x8,%esp
     584:	68 aa 43 00 00       	push   $0x43aa
     589:	50                   	push   %eax
     58a:	e8 a9 37 00 00       	call   3d38 <printf>
     58f:	83 c4 10             	add    $0x10,%esp

  if(mkdir("dir0") < 0){
     592:	83 ec 0c             	sub    $0xc,%esp
     595:	68 b6 43 00 00       	push   $0x43b6
     59a:	e8 95 36 00 00       	call   3c34 <mkdir>
     59f:	83 c4 10             	add    $0x10,%esp
     5a2:	85 c0                	test   %eax,%eax
     5a4:	79 1b                	jns    5c1 <dirtest+0x4b>
    printf(stdout, "mkdir failed\n");
     5a6:	a1 c0 57 00 00       	mov    0x57c0,%eax
     5ab:	83 ec 08             	sub    $0x8,%esp
     5ae:	68 bb 43 00 00       	push   $0x43bb
     5b3:	50                   	push   %eax
     5b4:	e8 7f 37 00 00       	call   3d38 <printf>
     5b9:	83 c4 10             	add    $0x10,%esp
    exit();
     5bc:	e8 0b 36 00 00       	call   3bcc <exit>
  }

  if(chdir("dir0") < 0){
     5c1:	83 ec 0c             	sub    $0xc,%esp
     5c4:	68 b6 43 00 00       	push   $0x43b6
     5c9:	e8 6e 36 00 00       	call   3c3c <chdir>
     5ce:	83 c4 10             	add    $0x10,%esp
     5d1:	85 c0                	test   %eax,%eax
     5d3:	79 1b                	jns    5f0 <dirtest+0x7a>
    printf(stdout, "chdir dir0 failed\n");
     5d5:	a1 c0 57 00 00       	mov    0x57c0,%eax
     5da:	83 ec 08             	sub    $0x8,%esp
     5dd:	68 c9 43 00 00       	push   $0x43c9
     5e2:	50                   	push   %eax
     5e3:	e8 50 37 00 00       	call   3d38 <printf>
     5e8:	83 c4 10             	add    $0x10,%esp
    exit();
     5eb:	e8 dc 35 00 00       	call   3bcc <exit>
  }

  if(chdir("..") < 0){
     5f0:	83 ec 0c             	sub    $0xc,%esp
     5f3:	68 dc 43 00 00       	push   $0x43dc
     5f8:	e8 3f 36 00 00       	call   3c3c <chdir>
     5fd:	83 c4 10             	add    $0x10,%esp
     600:	85 c0                	test   %eax,%eax
     602:	79 1b                	jns    61f <dirtest+0xa9>
    printf(stdout, "chdir .. failed\n");
     604:	a1 c0 57 00 00       	mov    0x57c0,%eax
     609:	83 ec 08             	sub    $0x8,%esp
     60c:	68 df 43 00 00       	push   $0x43df
     611:	50                   	push   %eax
     612:	e8 21 37 00 00       	call   3d38 <printf>
     617:	83 c4 10             	add    $0x10,%esp
    exit();
     61a:	e8 ad 35 00 00       	call   3bcc <exit>
  }

  if(unlink("dir0") < 0){
     61f:	83 ec 0c             	sub    $0xc,%esp
     622:	68 b6 43 00 00       	push   $0x43b6
     627:	e8 f0 35 00 00       	call   3c1c <unlink>
     62c:	83 c4 10             	add    $0x10,%esp
     62f:	85 c0                	test   %eax,%eax
     631:	79 1b                	jns    64e <dirtest+0xd8>
    printf(stdout, "unlink dir0 failed\n");
     633:	a1 c0 57 00 00       	mov    0x57c0,%eax
     638:	83 ec 08             	sub    $0x8,%esp
     63b:	68 f0 43 00 00       	push   $0x43f0
     640:	50                   	push   %eax
     641:	e8 f2 36 00 00       	call   3d38 <printf>
     646:	83 c4 10             	add    $0x10,%esp
    exit();
     649:	e8 7e 35 00 00       	call   3bcc <exit>
  }
  printf(stdout, "mkdir test\n");
     64e:	a1 c0 57 00 00       	mov    0x57c0,%eax
     653:	83 ec 08             	sub    $0x8,%esp
     656:	68 aa 43 00 00       	push   $0x43aa
     65b:	50                   	push   %eax
     65c:	e8 d7 36 00 00       	call   3d38 <printf>
     661:	83 c4 10             	add    $0x10,%esp
}
     664:	c9                   	leave  
     665:	c3                   	ret    

00000666 <exectest>:

void
exectest(void)
{
     666:	55                   	push   %ebp
     667:	89 e5                	mov    %esp,%ebp
     669:	83 ec 08             	sub    $0x8,%esp
  printf(stdout, "exec test\n");
     66c:	a1 c0 57 00 00       	mov    0x57c0,%eax
     671:	83 ec 08             	sub    $0x8,%esp
     674:	68 04 44 00 00       	push   $0x4404
     679:	50                   	push   %eax
     67a:	e8 b9 36 00 00       	call   3d38 <printf>
     67f:	83 c4 10             	add    $0x10,%esp
  if(exec("echo", echoargv) < 0){
     682:	83 ec 08             	sub    $0x8,%esp
     685:	68 ac 57 00 00       	push   $0x57ac
     68a:	68 e0 40 00 00       	push   $0x40e0
     68f:	e8 70 35 00 00       	call   3c04 <exec>
     694:	83 c4 10             	add    $0x10,%esp
     697:	85 c0                	test   %eax,%eax
     699:	79 1b                	jns    6b6 <exectest+0x50>
    printf(stdout, "exec echo failed\n");
     69b:	a1 c0 57 00 00       	mov    0x57c0,%eax
     6a0:	83 ec 08             	sub    $0x8,%esp
     6a3:	68 0f 44 00 00       	push   $0x440f
     6a8:	50                   	push   %eax
     6a9:	e8 8a 36 00 00       	call   3d38 <printf>
     6ae:	83 c4 10             	add    $0x10,%esp
    exit();
     6b1:	e8 16 35 00 00       	call   3bcc <exit>
  }
}
     6b6:	c9                   	leave  
     6b7:	c3                   	ret    

000006b8 <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
     6b8:	55                   	push   %ebp
     6b9:	89 e5                	mov    %esp,%ebp
     6bb:	83 ec 28             	sub    $0x28,%esp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
     6be:	83 ec 0c             	sub    $0xc,%esp
     6c1:	8d 45 d8             	lea    -0x28(%ebp),%eax
     6c4:	50                   	push   %eax
     6c5:	e8 12 35 00 00       	call   3bdc <pipe>
     6ca:	83 c4 10             	add    $0x10,%esp
     6cd:	85 c0                	test   %eax,%eax
     6cf:	74 17                	je     6e8 <pipe1+0x30>
    printf(1, "pipe() failed\n");
     6d1:	83 ec 08             	sub    $0x8,%esp
     6d4:	68 21 44 00 00       	push   $0x4421
     6d9:	6a 01                	push   $0x1
     6db:	e8 58 36 00 00       	call   3d38 <printf>
     6e0:	83 c4 10             	add    $0x10,%esp
    exit();
     6e3:	e8 e4 34 00 00       	call   3bcc <exit>
  }
  pid = fork();
     6e8:	e8 d7 34 00 00       	call   3bc4 <fork>
     6ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
  seq = 0;
     6f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if(pid == 0){
     6f7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     6fb:	0f 85 83 00 00 00    	jne    784 <pipe1+0xcc>
    close(fds[0]);
     701:	8b 45 d8             	mov    -0x28(%ebp),%eax
     704:	83 ec 0c             	sub    $0xc,%esp
     707:	50                   	push   %eax
     708:	e8 e7 34 00 00       	call   3bf4 <close>
     70d:	83 c4 10             	add    $0x10,%esp
    for(n = 0; n < 5; n++){
     710:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     717:	eb 60                	jmp    779 <pipe1+0xc1>
      for(i = 0; i < 1033; i++)
     719:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     720:	eb 14                	jmp    736 <pipe1+0x7e>
        buf[i] = seq++;
     722:	8b 45 f4             	mov    -0xc(%ebp),%eax
     725:	8b 55 f0             	mov    -0x10(%ebp),%edx
     728:	81 c2 a0 7f 00 00    	add    $0x7fa0,%edx
     72e:	88 02                	mov    %al,(%edx)
     730:	ff 45 f4             	incl   -0xc(%ebp)
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
      for(i = 0; i < 1033; i++)
     733:	ff 45 f0             	incl   -0x10(%ebp)
     736:	81 7d f0 08 04 00 00 	cmpl   $0x408,-0x10(%ebp)
     73d:	7e e3                	jle    722 <pipe1+0x6a>
        buf[i] = seq++;
      if(write(fds[1], buf, 1033) != 1033){
     73f:	8b 45 dc             	mov    -0x24(%ebp),%eax
     742:	83 ec 04             	sub    $0x4,%esp
     745:	68 09 04 00 00       	push   $0x409
     74a:	68 a0 7f 00 00       	push   $0x7fa0
     74f:	50                   	push   %eax
     750:	e8 97 34 00 00       	call   3bec <write>
     755:	83 c4 10             	add    $0x10,%esp
     758:	3d 09 04 00 00       	cmp    $0x409,%eax
     75d:	74 17                	je     776 <pipe1+0xbe>
        printf(1, "pipe1 oops 1\n");
     75f:	83 ec 08             	sub    $0x8,%esp
     762:	68 30 44 00 00       	push   $0x4430
     767:	6a 01                	push   $0x1
     769:	e8 ca 35 00 00       	call   3d38 <printf>
     76e:	83 c4 10             	add    $0x10,%esp
        exit();
     771:	e8 56 34 00 00       	call   3bcc <exit>
  }
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
     776:	ff 45 ec             	incl   -0x14(%ebp)
     779:	83 7d ec 04          	cmpl   $0x4,-0x14(%ebp)
     77d:	7e 9a                	jle    719 <pipe1+0x61>
      if(write(fds[1], buf, 1033) != 1033){
        printf(1, "pipe1 oops 1\n");
        exit();
      }
    }
    exit();
     77f:	e8 48 34 00 00       	call   3bcc <exit>
  } else if(pid > 0){
     784:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     788:	0f 8e f4 00 00 00    	jle    882 <pipe1+0x1ca>
    close(fds[1]);
     78e:	8b 45 dc             	mov    -0x24(%ebp),%eax
     791:	83 ec 0c             	sub    $0xc,%esp
     794:	50                   	push   %eax
     795:	e8 5a 34 00 00       	call   3bf4 <close>
     79a:	83 c4 10             	add    $0x10,%esp
    total = 0;
     79d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    cc = 1;
     7a4:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     7ab:	eb 66                	jmp    813 <pipe1+0x15b>
      for(i = 0; i < n; i++){
     7ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     7b4:	eb 3b                	jmp    7f1 <pipe1+0x139>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     7b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
     7b9:	05 a0 7f 00 00       	add    $0x7fa0,%eax
     7be:	8a 00                	mov    (%eax),%al
     7c0:	0f be c0             	movsbl %al,%eax
     7c3:	33 45 f4             	xor    -0xc(%ebp),%eax
     7c6:	25 ff 00 00 00       	and    $0xff,%eax
     7cb:	85 c0                	test   %eax,%eax
     7cd:	0f 95 c0             	setne  %al
     7d0:	ff 45 f4             	incl   -0xc(%ebp)
     7d3:	84 c0                	test   %al,%al
     7d5:	74 17                	je     7ee <pipe1+0x136>
          printf(1, "pipe1 oops 2\n");
     7d7:	83 ec 08             	sub    $0x8,%esp
     7da:	68 3e 44 00 00       	push   $0x443e
     7df:	6a 01                	push   $0x1
     7e1:	e8 52 35 00 00       	call   3d38 <printf>
     7e6:	83 c4 10             	add    $0x10,%esp
          return;
     7e9:	e9 ab 00 00 00       	jmp    899 <pipe1+0x1e1>
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
      for(i = 0; i < n; i++){
     7ee:	ff 45 f0             	incl   -0x10(%ebp)
     7f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
     7f4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     7f7:	7c bd                	jl     7b6 <pipe1+0xfe>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
          printf(1, "pipe1 oops 2\n");
          return;
        }
      }
      total += n;
     7f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
     7fc:	01 45 e4             	add    %eax,-0x1c(%ebp)
      cc = cc * 2;
     7ff:	d1 65 e8             	shll   -0x18(%ebp)
      if(cc > sizeof(buf))
     802:	8b 45 e8             	mov    -0x18(%ebp),%eax
     805:	3d 00 20 00 00       	cmp    $0x2000,%eax
     80a:	76 07                	jbe    813 <pipe1+0x15b>
        cc = sizeof(buf);
     80c:	c7 45 e8 00 20 00 00 	movl   $0x2000,-0x18(%ebp)
    exit();
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
     813:	8b 45 d8             	mov    -0x28(%ebp),%eax
     816:	83 ec 04             	sub    $0x4,%esp
     819:	ff 75 e8             	pushl  -0x18(%ebp)
     81c:	68 a0 7f 00 00       	push   $0x7fa0
     821:	50                   	push   %eax
     822:	e8 bd 33 00 00       	call   3be4 <read>
     827:	83 c4 10             	add    $0x10,%esp
     82a:	89 45 ec             	mov    %eax,-0x14(%ebp)
     82d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     831:	0f 8f 76 ff ff ff    	jg     7ad <pipe1+0xf5>
      total += n;
      cc = cc * 2;
      if(cc > sizeof(buf))
        cc = sizeof(buf);
    }
    if(total != 5 * 1033){
     837:	81 7d e4 2d 14 00 00 	cmpl   $0x142d,-0x1c(%ebp)
     83e:	74 1a                	je     85a <pipe1+0x1a2>
      printf(1, "pipe1 oops 3 total %d\n", total);
     840:	83 ec 04             	sub    $0x4,%esp
     843:	ff 75 e4             	pushl  -0x1c(%ebp)
     846:	68 4c 44 00 00       	push   $0x444c
     84b:	6a 01                	push   $0x1
     84d:	e8 e6 34 00 00       	call   3d38 <printf>
     852:	83 c4 10             	add    $0x10,%esp
      exit();
     855:	e8 72 33 00 00       	call   3bcc <exit>
    }
    close(fds[0]);
     85a:	8b 45 d8             	mov    -0x28(%ebp),%eax
     85d:	83 ec 0c             	sub    $0xc,%esp
     860:	50                   	push   %eax
     861:	e8 8e 33 00 00       	call   3bf4 <close>
     866:	83 c4 10             	add    $0x10,%esp
    wait();
     869:	e8 66 33 00 00       	call   3bd4 <wait>
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
     86e:	83 ec 08             	sub    $0x8,%esp
     871:	68 63 44 00 00       	push   $0x4463
     876:	6a 01                	push   $0x1
     878:	e8 bb 34 00 00       	call   3d38 <printf>
     87d:	83 c4 10             	add    $0x10,%esp
     880:	eb 17                	jmp    899 <pipe1+0x1e1>
      exit();
    }
    close(fds[0]);
    wait();
  } else {
    printf(1, "fork() failed\n");
     882:	83 ec 08             	sub    $0x8,%esp
     885:	68 6d 44 00 00       	push   $0x446d
     88a:	6a 01                	push   $0x1
     88c:	e8 a7 34 00 00       	call   3d38 <printf>
     891:	83 c4 10             	add    $0x10,%esp
    exit();
     894:	e8 33 33 00 00       	call   3bcc <exit>
  }
  printf(1, "pipe1 ok\n");
}
     899:	c9                   	leave  
     89a:	c3                   	ret    

0000089b <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
     89b:	55                   	push   %ebp
     89c:	89 e5                	mov    %esp,%ebp
     89e:	83 ec 28             	sub    $0x28,%esp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
     8a1:	83 ec 08             	sub    $0x8,%esp
     8a4:	68 7c 44 00 00       	push   $0x447c
     8a9:	6a 01                	push   $0x1
     8ab:	e8 88 34 00 00       	call   3d38 <printf>
     8b0:	83 c4 10             	add    $0x10,%esp
  pid1 = fork();
     8b3:	e8 0c 33 00 00       	call   3bc4 <fork>
     8b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid1 == 0)
     8bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     8bf:	75 02                	jne    8c3 <preempt+0x28>
    for(;;)
      ;
     8c1:	eb fe                	jmp    8c1 <preempt+0x26>

  pid2 = fork();
     8c3:	e8 fc 32 00 00       	call   3bc4 <fork>
     8c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid2 == 0)
     8cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     8cf:	75 02                	jne    8d3 <preempt+0x38>
    for(;;)
      ;
     8d1:	eb fe                	jmp    8d1 <preempt+0x36>

  pipe(pfds);
     8d3:	83 ec 0c             	sub    $0xc,%esp
     8d6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     8d9:	50                   	push   %eax
     8da:	e8 fd 32 00 00       	call   3bdc <pipe>
     8df:	83 c4 10             	add    $0x10,%esp
  pid3 = fork();
     8e2:	e8 dd 32 00 00       	call   3bc4 <fork>
     8e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid3 == 0){
     8ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     8ee:	75 4d                	jne    93d <preempt+0xa2>
    close(pfds[0]);
     8f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     8f3:	83 ec 0c             	sub    $0xc,%esp
     8f6:	50                   	push   %eax
     8f7:	e8 f8 32 00 00       	call   3bf4 <close>
     8fc:	83 c4 10             	add    $0x10,%esp
    if(write(pfds[1], "x", 1) != 1)
     8ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
     902:	83 ec 04             	sub    $0x4,%esp
     905:	6a 01                	push   $0x1
     907:	68 86 44 00 00       	push   $0x4486
     90c:	50                   	push   %eax
     90d:	e8 da 32 00 00       	call   3bec <write>
     912:	83 c4 10             	add    $0x10,%esp
     915:	83 f8 01             	cmp    $0x1,%eax
     918:	74 12                	je     92c <preempt+0x91>
      printf(1, "preempt write error");
     91a:	83 ec 08             	sub    $0x8,%esp
     91d:	68 88 44 00 00       	push   $0x4488
     922:	6a 01                	push   $0x1
     924:	e8 0f 34 00 00       	call   3d38 <printf>
     929:	83 c4 10             	add    $0x10,%esp
    close(pfds[1]);
     92c:	8b 45 e8             	mov    -0x18(%ebp),%eax
     92f:	83 ec 0c             	sub    $0xc,%esp
     932:	50                   	push   %eax
     933:	e8 bc 32 00 00       	call   3bf4 <close>
     938:	83 c4 10             	add    $0x10,%esp
    for(;;)
      ;
     93b:	eb fe                	jmp    93b <preempt+0xa0>
  }

  close(pfds[1]);
     93d:	8b 45 e8             	mov    -0x18(%ebp),%eax
     940:	83 ec 0c             	sub    $0xc,%esp
     943:	50                   	push   %eax
     944:	e8 ab 32 00 00       	call   3bf4 <close>
     949:	83 c4 10             	add    $0x10,%esp
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     94c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     94f:	83 ec 04             	sub    $0x4,%esp
     952:	68 00 20 00 00       	push   $0x2000
     957:	68 a0 7f 00 00       	push   $0x7fa0
     95c:	50                   	push   %eax
     95d:	e8 82 32 00 00       	call   3be4 <read>
     962:	83 c4 10             	add    $0x10,%esp
     965:	83 f8 01             	cmp    $0x1,%eax
     968:	74 14                	je     97e <preempt+0xe3>
    printf(1, "preempt read error");
     96a:	83 ec 08             	sub    $0x8,%esp
     96d:	68 9c 44 00 00       	push   $0x449c
     972:	6a 01                	push   $0x1
     974:	e8 bf 33 00 00       	call   3d38 <printf>
     979:	83 c4 10             	add    $0x10,%esp
    return;
     97c:	eb 7e                	jmp    9fc <preempt+0x161>
  }
  close(pfds[0]);
     97e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     981:	83 ec 0c             	sub    $0xc,%esp
     984:	50                   	push   %eax
     985:	e8 6a 32 00 00       	call   3bf4 <close>
     98a:	83 c4 10             	add    $0x10,%esp
  printf(1, "kill... ");
     98d:	83 ec 08             	sub    $0x8,%esp
     990:	68 af 44 00 00       	push   $0x44af
     995:	6a 01                	push   $0x1
     997:	e8 9c 33 00 00       	call   3d38 <printf>
     99c:	83 c4 10             	add    $0x10,%esp
  kill(pid1);
     99f:	83 ec 0c             	sub    $0xc,%esp
     9a2:	ff 75 f4             	pushl  -0xc(%ebp)
     9a5:	e8 52 32 00 00       	call   3bfc <kill>
     9aa:	83 c4 10             	add    $0x10,%esp
  kill(pid2);
     9ad:	83 ec 0c             	sub    $0xc,%esp
     9b0:	ff 75 f0             	pushl  -0x10(%ebp)
     9b3:	e8 44 32 00 00       	call   3bfc <kill>
     9b8:	83 c4 10             	add    $0x10,%esp
  kill(pid3);
     9bb:	83 ec 0c             	sub    $0xc,%esp
     9be:	ff 75 ec             	pushl  -0x14(%ebp)
     9c1:	e8 36 32 00 00       	call   3bfc <kill>
     9c6:	83 c4 10             	add    $0x10,%esp
  printf(1, "wait... ");
     9c9:	83 ec 08             	sub    $0x8,%esp
     9cc:	68 b8 44 00 00       	push   $0x44b8
     9d1:	6a 01                	push   $0x1
     9d3:	e8 60 33 00 00       	call   3d38 <printf>
     9d8:	83 c4 10             	add    $0x10,%esp
  wait();
     9db:	e8 f4 31 00 00       	call   3bd4 <wait>
  wait();
     9e0:	e8 ef 31 00 00       	call   3bd4 <wait>
  wait();
     9e5:	e8 ea 31 00 00       	call   3bd4 <wait>
  printf(1, "preempt ok\n");
     9ea:	83 ec 08             	sub    $0x8,%esp
     9ed:	68 c1 44 00 00       	push   $0x44c1
     9f2:	6a 01                	push   $0x1
     9f4:	e8 3f 33 00 00       	call   3d38 <printf>
     9f9:	83 c4 10             	add    $0x10,%esp
}
     9fc:	c9                   	leave  
     9fd:	c3                   	ret    

000009fe <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
     9fe:	55                   	push   %ebp
     9ff:	89 e5                	mov    %esp,%ebp
     a01:	83 ec 18             	sub    $0x18,%esp
  int i, pid;

  for(i = 0; i < 100; i++){
     a04:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     a0b:	eb 4e                	jmp    a5b <exitwait+0x5d>
    pid = fork();
     a0d:	e8 b2 31 00 00       	call   3bc4 <fork>
     a12:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0){
     a15:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     a19:	79 14                	jns    a2f <exitwait+0x31>
      printf(1, "fork failed\n");
     a1b:	83 ec 08             	sub    $0x8,%esp
     a1e:	68 cd 44 00 00       	push   $0x44cd
     a23:	6a 01                	push   $0x1
     a25:	e8 0e 33 00 00       	call   3d38 <printf>
     a2a:	83 c4 10             	add    $0x10,%esp
      return;
     a2d:	eb 44                	jmp    a73 <exitwait+0x75>
    }
    if(pid){
     a2f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     a33:	74 1e                	je     a53 <exitwait+0x55>
      if(wait() != pid){
     a35:	e8 9a 31 00 00       	call   3bd4 <wait>
     a3a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     a3d:	74 19                	je     a58 <exitwait+0x5a>
        printf(1, "wait wrong pid\n");
     a3f:	83 ec 08             	sub    $0x8,%esp
     a42:	68 da 44 00 00       	push   $0x44da
     a47:	6a 01                	push   $0x1
     a49:	e8 ea 32 00 00       	call   3d38 <printf>
     a4e:	83 c4 10             	add    $0x10,%esp
        return;
     a51:	eb 20                	jmp    a73 <exitwait+0x75>
      }
    } else {
      exit();
     a53:	e8 74 31 00 00       	call   3bcc <exit>
void
exitwait(void)
{
  int i, pid;

  for(i = 0; i < 100; i++){
     a58:	ff 45 f4             	incl   -0xc(%ebp)
     a5b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     a5f:	7e ac                	jle    a0d <exitwait+0xf>
      }
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
     a61:	83 ec 08             	sub    $0x8,%esp
     a64:	68 ea 44 00 00       	push   $0x44ea
     a69:	6a 01                	push   $0x1
     a6b:	e8 c8 32 00 00       	call   3d38 <printf>
     a70:	83 c4 10             	add    $0x10,%esp
}
     a73:	c9                   	leave  
     a74:	c3                   	ret    

00000a75 <mem>:

void
mem(void)
{
     a75:	55                   	push   %ebp
     a76:	89 e5                	mov    %esp,%ebp
     a78:	83 ec 18             	sub    $0x18,%esp
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
     a7b:	83 ec 08             	sub    $0x8,%esp
     a7e:	68 f7 44 00 00       	push   $0x44f7
     a83:	6a 01                	push   $0x1
     a85:	e8 ae 32 00 00       	call   3d38 <printf>
     a8a:	83 c4 10             	add    $0x10,%esp
  ppid = getpid();
     a8d:	e8 ba 31 00 00       	call   3c4c <getpid>
     a92:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if((pid = fork()) == 0){
     a95:	e8 2a 31 00 00       	call   3bc4 <fork>
     a9a:	89 45 ec             	mov    %eax,-0x14(%ebp)
     a9d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     aa1:	0f 85 b7 00 00 00    	jne    b5e <mem+0xe9>
    m1 = 0;
     aa7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while((m2 = malloc(10001)) != 0){
     aae:	eb 0e                	jmp    abe <mem+0x49>
      *(char**)m2 = m1;
     ab0:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ab3:	8b 55 f4             	mov    -0xc(%ebp),%edx
     ab6:	89 10                	mov    %edx,(%eax)
      m1 = m2;
     ab8:	8b 45 e8             	mov    -0x18(%ebp),%eax
     abb:	89 45 f4             	mov    %eax,-0xc(%ebp)

  printf(1, "mem test\n");
  ppid = getpid();
  if((pid = fork()) == 0){
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
     abe:	83 ec 0c             	sub    $0xc,%esp
     ac1:	68 11 27 00 00       	push   $0x2711
     ac6:	e8 34 35 00 00       	call   3fff <malloc>
     acb:	83 c4 10             	add    $0x10,%esp
     ace:	89 45 e8             	mov    %eax,-0x18(%ebp)
     ad1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     ad5:	75 d9                	jne    ab0 <mem+0x3b>
      *(char**)m2 = m1;
      m1 = m2;
    }
    while(m1){
     ad7:	eb 1c                	jmp    af5 <mem+0x80>
      m2 = *(char**)m1;
     ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     adc:	8b 00                	mov    (%eax),%eax
     ade:	89 45 e8             	mov    %eax,-0x18(%ebp)
      free(m1);
     ae1:	83 ec 0c             	sub    $0xc,%esp
     ae4:	ff 75 f4             	pushl  -0xc(%ebp)
     ae7:	e8 dc 33 00 00       	call   3ec8 <free>
     aec:	83 c4 10             	add    $0x10,%esp
      m1 = m2;
     aef:	8b 45 e8             	mov    -0x18(%ebp),%eax
     af2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
      *(char**)m2 = m1;
      m1 = m2;
    }
    while(m1){
     af5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     af9:	75 de                	jne    ad9 <mem+0x64>
      m2 = *(char**)m1;
      free(m1);
      m1 = m2;
    }
    m1 = malloc(1024*20);
     afb:	83 ec 0c             	sub    $0xc,%esp
     afe:	68 00 50 00 00       	push   $0x5000
     b03:	e8 f7 34 00 00       	call   3fff <malloc>
     b08:	83 c4 10             	add    $0x10,%esp
     b0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(m1 == 0){
     b0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     b12:	75 25                	jne    b39 <mem+0xc4>
      printf(1, "couldn't allocate mem?!!\n");
     b14:	83 ec 08             	sub    $0x8,%esp
     b17:	68 01 45 00 00       	push   $0x4501
     b1c:	6a 01                	push   $0x1
     b1e:	e8 15 32 00 00       	call   3d38 <printf>
     b23:	83 c4 10             	add    $0x10,%esp
      kill(ppid);
     b26:	83 ec 0c             	sub    $0xc,%esp
     b29:	ff 75 f0             	pushl  -0x10(%ebp)
     b2c:	e8 cb 30 00 00       	call   3bfc <kill>
     b31:	83 c4 10             	add    $0x10,%esp
      exit();
     b34:	e8 93 30 00 00       	call   3bcc <exit>
    }
    free(m1);
     b39:	83 ec 0c             	sub    $0xc,%esp
     b3c:	ff 75 f4             	pushl  -0xc(%ebp)
     b3f:	e8 84 33 00 00       	call   3ec8 <free>
     b44:	83 c4 10             	add    $0x10,%esp
    printf(1, "mem ok\n");
     b47:	83 ec 08             	sub    $0x8,%esp
     b4a:	68 1b 45 00 00       	push   $0x451b
     b4f:	6a 01                	push   $0x1
     b51:	e8 e2 31 00 00       	call   3d38 <printf>
     b56:	83 c4 10             	add    $0x10,%esp
    exit();
     b59:	e8 6e 30 00 00       	call   3bcc <exit>
  } else {
    wait();
     b5e:	e8 71 30 00 00       	call   3bd4 <wait>
  }
}
     b63:	c9                   	leave  
     b64:	c3                   	ret    

00000b65 <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
     b65:	55                   	push   %ebp
     b66:	89 e5                	mov    %esp,%ebp
     b68:	83 ec 38             	sub    $0x38,%esp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
     b6b:	83 ec 08             	sub    $0x8,%esp
     b6e:	68 23 45 00 00       	push   $0x4523
     b73:	6a 01                	push   $0x1
     b75:	e8 be 31 00 00       	call   3d38 <printf>
     b7a:	83 c4 10             	add    $0x10,%esp

  unlink("sharedfd");
     b7d:	83 ec 0c             	sub    $0xc,%esp
     b80:	68 32 45 00 00       	push   $0x4532
     b85:	e8 92 30 00 00       	call   3c1c <unlink>
     b8a:	83 c4 10             	add    $0x10,%esp
  fd = open("sharedfd", O_CREATE|O_RDWR);
     b8d:	83 ec 08             	sub    $0x8,%esp
     b90:	68 02 02 00 00       	push   $0x202
     b95:	68 32 45 00 00       	push   $0x4532
     b9a:	e8 6d 30 00 00       	call   3c0c <open>
     b9f:	83 c4 10             	add    $0x10,%esp
     ba2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
     ba5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     ba9:	79 17                	jns    bc2 <sharedfd+0x5d>
    printf(1, "fstests: cannot open sharedfd for writing");
     bab:	83 ec 08             	sub    $0x8,%esp
     bae:	68 3c 45 00 00       	push   $0x453c
     bb3:	6a 01                	push   $0x1
     bb5:	e8 7e 31 00 00       	call   3d38 <printf>
     bba:	83 c4 10             	add    $0x10,%esp
    return;
     bbd:	e9 7a 01 00 00       	jmp    d3c <sharedfd+0x1d7>
  }
  pid = fork();
     bc2:	e8 fd 2f 00 00       	call   3bc4 <fork>
     bc7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
     bca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     bce:	75 07                	jne    bd7 <sharedfd+0x72>
     bd0:	b8 63 00 00 00       	mov    $0x63,%eax
     bd5:	eb 05                	jmp    bdc <sharedfd+0x77>
     bd7:	b8 70 00 00 00       	mov    $0x70,%eax
     bdc:	83 ec 04             	sub    $0x4,%esp
     bdf:	6a 0a                	push   $0xa
     be1:	50                   	push   %eax
     be2:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     be5:	50                   	push   %eax
     be6:	e8 5f 2e 00 00       	call   3a4a <memset>
     beb:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 1000; i++){
     bee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     bf5:	eb 30                	jmp    c27 <sharedfd+0xc2>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     bf7:	83 ec 04             	sub    $0x4,%esp
     bfa:	6a 0a                	push   $0xa
     bfc:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     bff:	50                   	push   %eax
     c00:	ff 75 e8             	pushl  -0x18(%ebp)
     c03:	e8 e4 2f 00 00       	call   3bec <write>
     c08:	83 c4 10             	add    $0x10,%esp
     c0b:	83 f8 0a             	cmp    $0xa,%eax
     c0e:	74 14                	je     c24 <sharedfd+0xbf>
      printf(1, "fstests: write sharedfd failed\n");
     c10:	83 ec 08             	sub    $0x8,%esp
     c13:	68 68 45 00 00       	push   $0x4568
     c18:	6a 01                	push   $0x1
     c1a:	e8 19 31 00 00       	call   3d38 <printf>
     c1f:	83 c4 10             	add    $0x10,%esp
      break;
     c22:	eb 0c                	jmp    c30 <sharedfd+0xcb>
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
  memset(buf, pid==0?'c':'p', sizeof(buf));
  for(i = 0; i < 1000; i++){
     c24:	ff 45 f4             	incl   -0xc(%ebp)
     c27:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
     c2e:	7e c7                	jle    bf7 <sharedfd+0x92>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
      printf(1, "fstests: write sharedfd failed\n");
      break;
    }
  }
  if(pid == 0)
     c30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     c34:	75 05                	jne    c3b <sharedfd+0xd6>
    exit();
     c36:	e8 91 2f 00 00       	call   3bcc <exit>
  else
    wait();
     c3b:	e8 94 2f 00 00       	call   3bd4 <wait>
  close(fd);
     c40:	83 ec 0c             	sub    $0xc,%esp
     c43:	ff 75 e8             	pushl  -0x18(%ebp)
     c46:	e8 a9 2f 00 00       	call   3bf4 <close>
     c4b:	83 c4 10             	add    $0x10,%esp
  fd = open("sharedfd", 0);
     c4e:	83 ec 08             	sub    $0x8,%esp
     c51:	6a 00                	push   $0x0
     c53:	68 32 45 00 00       	push   $0x4532
     c58:	e8 af 2f 00 00       	call   3c0c <open>
     c5d:	83 c4 10             	add    $0x10,%esp
     c60:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
     c63:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     c67:	79 17                	jns    c80 <sharedfd+0x11b>
    printf(1, "fstests: cannot open sharedfd for reading\n");
     c69:	83 ec 08             	sub    $0x8,%esp
     c6c:	68 88 45 00 00       	push   $0x4588
     c71:	6a 01                	push   $0x1
     c73:	e8 c0 30 00 00       	call   3d38 <printf>
     c78:	83 c4 10             	add    $0x10,%esp
    return;
     c7b:	e9 bc 00 00 00       	jmp    d3c <sharedfd+0x1d7>
  }
  nc = np = 0;
     c80:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     c87:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
     c8d:	eb 32                	jmp    cc1 <sharedfd+0x15c>
    for(i = 0; i < sizeof(buf); i++){
     c8f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     c96:	eb 21                	jmp    cb9 <sharedfd+0x154>
      if(buf[i] == 'c')
     c98:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     c9b:	03 45 f4             	add    -0xc(%ebp),%eax
     c9e:	8a 00                	mov    (%eax),%al
     ca0:	3c 63                	cmp    $0x63,%al
     ca2:	75 03                	jne    ca7 <sharedfd+0x142>
        nc++;
     ca4:	ff 45 f0             	incl   -0x10(%ebp)
      if(buf[i] == 'p')
     ca7:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     caa:	03 45 f4             	add    -0xc(%ebp),%eax
     cad:	8a 00                	mov    (%eax),%al
     caf:	3c 70                	cmp    $0x70,%al
     cb1:	75 03                	jne    cb6 <sharedfd+0x151>
        np++;
     cb3:	ff 45 ec             	incl   -0x14(%ebp)
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i = 0; i < sizeof(buf); i++){
     cb6:	ff 45 f4             	incl   -0xc(%ebp)
     cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cbc:	83 f8 09             	cmp    $0x9,%eax
     cbf:	76 d7                	jbe    c98 <sharedfd+0x133>
  if(fd < 0){
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
     cc1:	83 ec 04             	sub    $0x4,%esp
     cc4:	6a 0a                	push   $0xa
     cc6:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     cc9:	50                   	push   %eax
     cca:	ff 75 e8             	pushl  -0x18(%ebp)
     ccd:	e8 12 2f 00 00       	call   3be4 <read>
     cd2:	83 c4 10             	add    $0x10,%esp
     cd5:	89 45 e0             	mov    %eax,-0x20(%ebp)
     cd8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     cdc:	7f b1                	jg     c8f <sharedfd+0x12a>
        nc++;
      if(buf[i] == 'p')
        np++;
    }
  }
  close(fd);
     cde:	83 ec 0c             	sub    $0xc,%esp
     ce1:	ff 75 e8             	pushl  -0x18(%ebp)
     ce4:	e8 0b 2f 00 00       	call   3bf4 <close>
     ce9:	83 c4 10             	add    $0x10,%esp
  unlink("sharedfd");
     cec:	83 ec 0c             	sub    $0xc,%esp
     cef:	68 32 45 00 00       	push   $0x4532
     cf4:	e8 23 2f 00 00       	call   3c1c <unlink>
     cf9:	83 c4 10             	add    $0x10,%esp
  if(nc == 10000 && np == 10000){
     cfc:	81 7d f0 10 27 00 00 	cmpl   $0x2710,-0x10(%ebp)
     d03:	75 1d                	jne    d22 <sharedfd+0x1bd>
     d05:	81 7d ec 10 27 00 00 	cmpl   $0x2710,-0x14(%ebp)
     d0c:	75 14                	jne    d22 <sharedfd+0x1bd>
    printf(1, "sharedfd ok\n");
     d0e:	83 ec 08             	sub    $0x8,%esp
     d11:	68 b3 45 00 00       	push   $0x45b3
     d16:	6a 01                	push   $0x1
     d18:	e8 1b 30 00 00       	call   3d38 <printf>
     d1d:	83 c4 10             	add    $0x10,%esp
     d20:	eb 1a                	jmp    d3c <sharedfd+0x1d7>
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
     d22:	ff 75 ec             	pushl  -0x14(%ebp)
     d25:	ff 75 f0             	pushl  -0x10(%ebp)
     d28:	68 c0 45 00 00       	push   $0x45c0
     d2d:	6a 01                	push   $0x1
     d2f:	e8 04 30 00 00       	call   3d38 <printf>
     d34:	83 c4 10             	add    $0x10,%esp
    exit();
     d37:	e8 90 2e 00 00       	call   3bcc <exit>
  }
}
     d3c:	c9                   	leave  
     d3d:	c3                   	ret    

00000d3e <twofiles>:

// two processes write two different files at the same
// time, to test block allocation.
void
twofiles(void)
{
     d3e:	55                   	push   %ebp
     d3f:	89 e5                	mov    %esp,%ebp
     d41:	83 ec 28             	sub    $0x28,%esp
  int fd, pid, i, j, n, total;
  char *fname;

  printf(1, "twofiles test\n");
     d44:	83 ec 08             	sub    $0x8,%esp
     d47:	68 d5 45 00 00       	push   $0x45d5
     d4c:	6a 01                	push   $0x1
     d4e:	e8 e5 2f 00 00       	call   3d38 <printf>
     d53:	83 c4 10             	add    $0x10,%esp

  unlink("f1");
     d56:	83 ec 0c             	sub    $0xc,%esp
     d59:	68 e4 45 00 00       	push   $0x45e4
     d5e:	e8 b9 2e 00 00       	call   3c1c <unlink>
     d63:	83 c4 10             	add    $0x10,%esp
  unlink("f2");
     d66:	83 ec 0c             	sub    $0xc,%esp
     d69:	68 e7 45 00 00       	push   $0x45e7
     d6e:	e8 a9 2e 00 00       	call   3c1c <unlink>
     d73:	83 c4 10             	add    $0x10,%esp

  pid = fork();
     d76:	e8 49 2e 00 00       	call   3bc4 <fork>
     d7b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(pid < 0){
     d7e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     d82:	79 17                	jns    d9b <twofiles+0x5d>
    printf(1, "fork failed\n");
     d84:	83 ec 08             	sub    $0x8,%esp
     d87:	68 cd 44 00 00       	push   $0x44cd
     d8c:	6a 01                	push   $0x1
     d8e:	e8 a5 2f 00 00       	call   3d38 <printf>
     d93:	83 c4 10             	add    $0x10,%esp
    exit();
     d96:	e8 31 2e 00 00       	call   3bcc <exit>
  }

  fname = pid ? "f1" : "f2";
     d9b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     d9f:	74 07                	je     da8 <twofiles+0x6a>
     da1:	b8 e4 45 00 00       	mov    $0x45e4,%eax
     da6:	eb 05                	jmp    dad <twofiles+0x6f>
     da8:	b8 e7 45 00 00       	mov    $0x45e7,%eax
     dad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  fd = open(fname, O_CREATE | O_RDWR);
     db0:	83 ec 08             	sub    $0x8,%esp
     db3:	68 02 02 00 00       	push   $0x202
     db8:	ff 75 e4             	pushl  -0x1c(%ebp)
     dbb:	e8 4c 2e 00 00       	call   3c0c <open>
     dc0:	83 c4 10             	add    $0x10,%esp
     dc3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(fd < 0){
     dc6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     dca:	79 17                	jns    de3 <twofiles+0xa5>
    printf(1, "create failed\n");
     dcc:	83 ec 08             	sub    $0x8,%esp
     dcf:	68 ea 45 00 00       	push   $0x45ea
     dd4:	6a 01                	push   $0x1
     dd6:	e8 5d 2f 00 00       	call   3d38 <printf>
     ddb:	83 c4 10             	add    $0x10,%esp
    exit();
     dde:	e8 e9 2d 00 00       	call   3bcc <exit>
  }

  memset(buf, pid?'p':'c', 512);
     de3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     de7:	74 07                	je     df0 <twofiles+0xb2>
     de9:	b8 70 00 00 00       	mov    $0x70,%eax
     dee:	eb 05                	jmp    df5 <twofiles+0xb7>
     df0:	b8 63 00 00 00       	mov    $0x63,%eax
     df5:	83 ec 04             	sub    $0x4,%esp
     df8:	68 00 02 00 00       	push   $0x200
     dfd:	50                   	push   %eax
     dfe:	68 a0 7f 00 00       	push   $0x7fa0
     e03:	e8 42 2c 00 00       	call   3a4a <memset>
     e08:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 12; i++){
     e0b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     e12:	eb 41                	jmp    e55 <twofiles+0x117>
    if((n = write(fd, buf, 500)) != 500){
     e14:	83 ec 04             	sub    $0x4,%esp
     e17:	68 f4 01 00 00       	push   $0x1f4
     e1c:	68 a0 7f 00 00       	push   $0x7fa0
     e21:	ff 75 e0             	pushl  -0x20(%ebp)
     e24:	e8 c3 2d 00 00       	call   3bec <write>
     e29:	83 c4 10             	add    $0x10,%esp
     e2c:	89 45 dc             	mov    %eax,-0x24(%ebp)
     e2f:	81 7d dc f4 01 00 00 	cmpl   $0x1f4,-0x24(%ebp)
     e36:	74 1a                	je     e52 <twofiles+0x114>
      printf(1, "write failed %d\n", n);
     e38:	83 ec 04             	sub    $0x4,%esp
     e3b:	ff 75 dc             	pushl  -0x24(%ebp)
     e3e:	68 f9 45 00 00       	push   $0x45f9
     e43:	6a 01                	push   $0x1
     e45:	e8 ee 2e 00 00       	call   3d38 <printf>
     e4a:	83 c4 10             	add    $0x10,%esp
      exit();
     e4d:	e8 7a 2d 00 00       	call   3bcc <exit>
    printf(1, "create failed\n");
    exit();
  }

  memset(buf, pid?'p':'c', 512);
  for(i = 0; i < 12; i++){
     e52:	ff 45 f4             	incl   -0xc(%ebp)
     e55:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
     e59:	7e b9                	jle    e14 <twofiles+0xd6>
    if((n = write(fd, buf, 500)) != 500){
      printf(1, "write failed %d\n", n);
      exit();
    }
  }
  close(fd);
     e5b:	83 ec 0c             	sub    $0xc,%esp
     e5e:	ff 75 e0             	pushl  -0x20(%ebp)
     e61:	e8 8e 2d 00 00       	call   3bf4 <close>
     e66:	83 c4 10             	add    $0x10,%esp
  if(pid)
     e69:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     e6d:	74 11                	je     e80 <twofiles+0x142>
    wait();
     e6f:	e8 60 2d 00 00       	call   3bd4 <wait>
  else
    exit();

  for(i = 0; i < 2; i++){
     e74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     e7b:	e9 da 00 00 00       	jmp    f5a <twofiles+0x21c>
  }
  close(fd);
  if(pid)
    wait();
  else
    exit();
     e80:	e8 47 2d 00 00       	call   3bcc <exit>

  for(i = 0; i < 2; i++){
    fd = open(i?"f1":"f2", 0);
     e85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     e89:	74 07                	je     e92 <twofiles+0x154>
     e8b:	b8 e4 45 00 00       	mov    $0x45e4,%eax
     e90:	eb 05                	jmp    e97 <twofiles+0x159>
     e92:	b8 e7 45 00 00       	mov    $0x45e7,%eax
     e97:	83 ec 08             	sub    $0x8,%esp
     e9a:	6a 00                	push   $0x0
     e9c:	50                   	push   %eax
     e9d:	e8 6a 2d 00 00       	call   3c0c <open>
     ea2:	83 c4 10             	add    $0x10,%esp
     ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    total = 0;
     ea8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
     eaf:	eb 54                	jmp    f05 <twofiles+0x1c7>
      for(j = 0; j < n; j++){
     eb1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     eb8:	eb 3d                	jmp    ef7 <twofiles+0x1b9>
        if(buf[j] != (i?'p':'c')){
     eba:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ebd:	05 a0 7f 00 00       	add    $0x7fa0,%eax
     ec2:	8a 00                	mov    (%eax),%al
     ec4:	0f be d0             	movsbl %al,%edx
     ec7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     ecb:	74 07                	je     ed4 <twofiles+0x196>
     ecd:	b8 70 00 00 00       	mov    $0x70,%eax
     ed2:	eb 05                	jmp    ed9 <twofiles+0x19b>
     ed4:	b8 63 00 00 00       	mov    $0x63,%eax
     ed9:	39 c2                	cmp    %eax,%edx
     edb:	74 17                	je     ef4 <twofiles+0x1b6>
          printf(1, "wrong char\n");
     edd:	83 ec 08             	sub    $0x8,%esp
     ee0:	68 0a 46 00 00       	push   $0x460a
     ee5:	6a 01                	push   $0x1
     ee7:	e8 4c 2e 00 00       	call   3d38 <printf>
     eec:	83 c4 10             	add    $0x10,%esp
          exit();
     eef:	e8 d8 2c 00 00       	call   3bcc <exit>

  for(i = 0; i < 2; i++){
    fd = open(i?"f1":"f2", 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
      for(j = 0; j < n; j++){
     ef4:	ff 45 f0             	incl   -0x10(%ebp)
     ef7:	8b 45 f0             	mov    -0x10(%ebp),%eax
     efa:	3b 45 dc             	cmp    -0x24(%ebp),%eax
     efd:	7c bb                	jl     eba <twofiles+0x17c>
        if(buf[j] != (i?'p':'c')){
          printf(1, "wrong char\n");
          exit();
        }
      }
      total += n;
     eff:	8b 45 dc             	mov    -0x24(%ebp),%eax
     f02:	01 45 ec             	add    %eax,-0x14(%ebp)
    exit();

  for(i = 0; i < 2; i++){
    fd = open(i?"f1":"f2", 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
     f05:	83 ec 04             	sub    $0x4,%esp
     f08:	68 00 20 00 00       	push   $0x2000
     f0d:	68 a0 7f 00 00       	push   $0x7fa0
     f12:	ff 75 e0             	pushl  -0x20(%ebp)
     f15:	e8 ca 2c 00 00       	call   3be4 <read>
     f1a:	83 c4 10             	add    $0x10,%esp
     f1d:	89 45 dc             	mov    %eax,-0x24(%ebp)
     f20:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
     f24:	7f 8b                	jg     eb1 <twofiles+0x173>
          exit();
        }
      }
      total += n;
    }
    close(fd);
     f26:	83 ec 0c             	sub    $0xc,%esp
     f29:	ff 75 e0             	pushl  -0x20(%ebp)
     f2c:	e8 c3 2c 00 00       	call   3bf4 <close>
     f31:	83 c4 10             	add    $0x10,%esp
    if(total != 12*500){
     f34:	81 7d ec 70 17 00 00 	cmpl   $0x1770,-0x14(%ebp)
     f3b:	74 1a                	je     f57 <twofiles+0x219>
      printf(1, "wrong length %d\n", total);
     f3d:	83 ec 04             	sub    $0x4,%esp
     f40:	ff 75 ec             	pushl  -0x14(%ebp)
     f43:	68 16 46 00 00       	push   $0x4616
     f48:	6a 01                	push   $0x1
     f4a:	e8 e9 2d 00 00       	call   3d38 <printf>
     f4f:	83 c4 10             	add    $0x10,%esp
      exit();
     f52:	e8 75 2c 00 00       	call   3bcc <exit>
  if(pid)
    wait();
  else
    exit();

  for(i = 0; i < 2; i++){
     f57:	ff 45 f4             	incl   -0xc(%ebp)
     f5a:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
     f5e:	0f 8e 21 ff ff ff    	jle    e85 <twofiles+0x147>
      printf(1, "wrong length %d\n", total);
      exit();
    }
  }

  unlink("f1");
     f64:	83 ec 0c             	sub    $0xc,%esp
     f67:	68 e4 45 00 00       	push   $0x45e4
     f6c:	e8 ab 2c 00 00       	call   3c1c <unlink>
     f71:	83 c4 10             	add    $0x10,%esp
  unlink("f2");
     f74:	83 ec 0c             	sub    $0xc,%esp
     f77:	68 e7 45 00 00       	push   $0x45e7
     f7c:	e8 9b 2c 00 00       	call   3c1c <unlink>
     f81:	83 c4 10             	add    $0x10,%esp

  printf(1, "twofiles ok\n");
     f84:	83 ec 08             	sub    $0x8,%esp
     f87:	68 27 46 00 00       	push   $0x4627
     f8c:	6a 01                	push   $0x1
     f8e:	e8 a5 2d 00 00       	call   3d38 <printf>
     f93:	83 c4 10             	add    $0x10,%esp
}
     f96:	c9                   	leave  
     f97:	c3                   	ret    

00000f98 <createdelete>:

// two processes create and delete different files in same directory
void
createdelete(void)
{
     f98:	55                   	push   %ebp
     f99:	89 e5                	mov    %esp,%ebp
     f9b:	83 ec 38             	sub    $0x38,%esp
  enum { N = 20 };
  int pid, i, fd;
  char name[32];

  printf(1, "createdelete test\n");
     f9e:	83 ec 08             	sub    $0x8,%esp
     fa1:	68 34 46 00 00       	push   $0x4634
     fa6:	6a 01                	push   $0x1
     fa8:	e8 8b 2d 00 00       	call   3d38 <printf>
     fad:	83 c4 10             	add    $0x10,%esp
  pid = fork();
     fb0:	e8 0f 2c 00 00       	call   3bc4 <fork>
     fb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid < 0){
     fb8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     fbc:	79 17                	jns    fd5 <createdelete+0x3d>
    printf(1, "fork failed\n");
     fbe:	83 ec 08             	sub    $0x8,%esp
     fc1:	68 cd 44 00 00       	push   $0x44cd
     fc6:	6a 01                	push   $0x1
     fc8:	e8 6b 2d 00 00       	call   3d38 <printf>
     fcd:	83 c4 10             	add    $0x10,%esp
    exit();
     fd0:	e8 f7 2b 00 00       	call   3bcc <exit>
  }

  name[0] = pid ? 'p' : 'c';
     fd5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     fd9:	74 04                	je     fdf <createdelete+0x47>
     fdb:	b0 70                	mov    $0x70,%al
     fdd:	eb 02                	jmp    fe1 <createdelete+0x49>
     fdf:	b0 63                	mov    $0x63,%al
     fe1:	88 45 cc             	mov    %al,-0x34(%ebp)
  name[2] = '\0';
     fe4:	c6 45 ce 00          	movb   $0x0,-0x32(%ebp)
  for(i = 0; i < N; i++){
     fe8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     fef:	e9 9b 00 00 00       	jmp    108f <createdelete+0xf7>
    name[1] = '0' + i;
     ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ff7:	83 c0 30             	add    $0x30,%eax
     ffa:	88 45 cd             	mov    %al,-0x33(%ebp)
    fd = open(name, O_CREATE | O_RDWR);
     ffd:	83 ec 08             	sub    $0x8,%esp
    1000:	68 02 02 00 00       	push   $0x202
    1005:	8d 45 cc             	lea    -0x34(%ebp),%eax
    1008:	50                   	push   %eax
    1009:	e8 fe 2b 00 00       	call   3c0c <open>
    100e:	83 c4 10             	add    $0x10,%esp
    1011:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fd < 0){
    1014:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1018:	79 17                	jns    1031 <createdelete+0x99>
      printf(1, "create failed\n");
    101a:	83 ec 08             	sub    $0x8,%esp
    101d:	68 ea 45 00 00       	push   $0x45ea
    1022:	6a 01                	push   $0x1
    1024:	e8 0f 2d 00 00       	call   3d38 <printf>
    1029:	83 c4 10             	add    $0x10,%esp
      exit();
    102c:	e8 9b 2b 00 00       	call   3bcc <exit>
    }
    close(fd);
    1031:	83 ec 0c             	sub    $0xc,%esp
    1034:	ff 75 ec             	pushl  -0x14(%ebp)
    1037:	e8 b8 2b 00 00       	call   3bf4 <close>
    103c:	83 c4 10             	add    $0x10,%esp
    if(i > 0 && (i % 2 ) == 0){
    103f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1043:	7e 47                	jle    108c <createdelete+0xf4>
    1045:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1048:	83 e0 01             	and    $0x1,%eax
    104b:	85 c0                	test   %eax,%eax
    104d:	75 3d                	jne    108c <createdelete+0xf4>
      name[1] = '0' + (i / 2);
    104f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1052:	89 c2                	mov    %eax,%edx
    1054:	c1 ea 1f             	shr    $0x1f,%edx
    1057:	8d 04 02             	lea    (%edx,%eax,1),%eax
    105a:	d1 f8                	sar    %eax
    105c:	83 c0 30             	add    $0x30,%eax
    105f:	88 45 cd             	mov    %al,-0x33(%ebp)
      if(unlink(name) < 0){
    1062:	83 ec 0c             	sub    $0xc,%esp
    1065:	8d 45 cc             	lea    -0x34(%ebp),%eax
    1068:	50                   	push   %eax
    1069:	e8 ae 2b 00 00       	call   3c1c <unlink>
    106e:	83 c4 10             	add    $0x10,%esp
    1071:	85 c0                	test   %eax,%eax
    1073:	79 17                	jns    108c <createdelete+0xf4>
        printf(1, "unlink failed\n");
    1075:	83 ec 08             	sub    $0x8,%esp
    1078:	68 47 46 00 00       	push   $0x4647
    107d:	6a 01                	push   $0x1
    107f:	e8 b4 2c 00 00       	call   3d38 <printf>
    1084:	83 c4 10             	add    $0x10,%esp
        exit();
    1087:	e8 40 2b 00 00       	call   3bcc <exit>
    exit();
  }

  name[0] = pid ? 'p' : 'c';
  name[2] = '\0';
  for(i = 0; i < N; i++){
    108c:	ff 45 f4             	incl   -0xc(%ebp)
    108f:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    1093:	0f 8e 5b ff ff ff    	jle    ff4 <createdelete+0x5c>
        exit();
      }
    }
  }

  if(pid==0)
    1099:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    109d:	75 05                	jne    10a4 <createdelete+0x10c>
    exit();
    109f:	e8 28 2b 00 00       	call   3bcc <exit>
  else
    wait();
    10a4:	e8 2b 2b 00 00       	call   3bd4 <wait>

  for(i = 0; i < N; i++){
    10a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    10b0:	e9 21 01 00 00       	jmp    11d6 <createdelete+0x23e>
    name[0] = 'p';
    10b5:	c6 45 cc 70          	movb   $0x70,-0x34(%ebp)
    name[1] = '0' + i;
    10b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10bc:	83 c0 30             	add    $0x30,%eax
    10bf:	88 45 cd             	mov    %al,-0x33(%ebp)
    fd = open(name, 0);
    10c2:	83 ec 08             	sub    $0x8,%esp
    10c5:	6a 00                	push   $0x0
    10c7:	8d 45 cc             	lea    -0x34(%ebp),%eax
    10ca:	50                   	push   %eax
    10cb:	e8 3c 2b 00 00       	call   3c0c <open>
    10d0:	83 c4 10             	add    $0x10,%esp
    10d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((i == 0 || i >= N/2) && fd < 0){
    10d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    10da:	74 06                	je     10e2 <createdelete+0x14a>
    10dc:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    10e0:	7e 21                	jle    1103 <createdelete+0x16b>
    10e2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    10e6:	79 1b                	jns    1103 <createdelete+0x16b>
      printf(1, "oops createdelete %s didn't exist\n", name);
    10e8:	83 ec 04             	sub    $0x4,%esp
    10eb:	8d 45 cc             	lea    -0x34(%ebp),%eax
    10ee:	50                   	push   %eax
    10ef:	68 58 46 00 00       	push   $0x4658
    10f4:	6a 01                	push   $0x1
    10f6:	e8 3d 2c 00 00       	call   3d38 <printf>
    10fb:	83 c4 10             	add    $0x10,%esp
      exit();
    10fe:	e8 c9 2a 00 00       	call   3bcc <exit>
    } else if((i >= 1 && i < N/2) && fd >= 0){
    1103:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1107:	7e 27                	jle    1130 <createdelete+0x198>
    1109:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    110d:	7f 21                	jg     1130 <createdelete+0x198>
    110f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1113:	78 1b                	js     1130 <createdelete+0x198>
      printf(1, "oops createdelete %s did exist\n", name);
    1115:	83 ec 04             	sub    $0x4,%esp
    1118:	8d 45 cc             	lea    -0x34(%ebp),%eax
    111b:	50                   	push   %eax
    111c:	68 7c 46 00 00       	push   $0x467c
    1121:	6a 01                	push   $0x1
    1123:	e8 10 2c 00 00       	call   3d38 <printf>
    1128:	83 c4 10             	add    $0x10,%esp
      exit();
    112b:	e8 9c 2a 00 00       	call   3bcc <exit>
    }
    if(fd >= 0)
    1130:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1134:	78 0e                	js     1144 <createdelete+0x1ac>
      close(fd);
    1136:	83 ec 0c             	sub    $0xc,%esp
    1139:	ff 75 ec             	pushl  -0x14(%ebp)
    113c:	e8 b3 2a 00 00       	call   3bf4 <close>
    1141:	83 c4 10             	add    $0x10,%esp

    name[0] = 'c';
    1144:	c6 45 cc 63          	movb   $0x63,-0x34(%ebp)
    name[1] = '0' + i;
    1148:	8b 45 f4             	mov    -0xc(%ebp),%eax
    114b:	83 c0 30             	add    $0x30,%eax
    114e:	88 45 cd             	mov    %al,-0x33(%ebp)
    fd = open(name, 0);
    1151:	83 ec 08             	sub    $0x8,%esp
    1154:	6a 00                	push   $0x0
    1156:	8d 45 cc             	lea    -0x34(%ebp),%eax
    1159:	50                   	push   %eax
    115a:	e8 ad 2a 00 00       	call   3c0c <open>
    115f:	83 c4 10             	add    $0x10,%esp
    1162:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((i == 0 || i >= N/2) && fd < 0){
    1165:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1169:	74 06                	je     1171 <createdelete+0x1d9>
    116b:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    116f:	7e 21                	jle    1192 <createdelete+0x1fa>
    1171:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1175:	79 1b                	jns    1192 <createdelete+0x1fa>
      printf(1, "oops createdelete %s didn't exist\n", name);
    1177:	83 ec 04             	sub    $0x4,%esp
    117a:	8d 45 cc             	lea    -0x34(%ebp),%eax
    117d:	50                   	push   %eax
    117e:	68 58 46 00 00       	push   $0x4658
    1183:	6a 01                	push   $0x1
    1185:	e8 ae 2b 00 00       	call   3d38 <printf>
    118a:	83 c4 10             	add    $0x10,%esp
      exit();
    118d:	e8 3a 2a 00 00       	call   3bcc <exit>
    } else if((i >= 1 && i < N/2) && fd >= 0){
    1192:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1196:	7e 27                	jle    11bf <createdelete+0x227>
    1198:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    119c:	7f 21                	jg     11bf <createdelete+0x227>
    119e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    11a2:	78 1b                	js     11bf <createdelete+0x227>
      printf(1, "oops createdelete %s did exist\n", name);
    11a4:	83 ec 04             	sub    $0x4,%esp
    11a7:	8d 45 cc             	lea    -0x34(%ebp),%eax
    11aa:	50                   	push   %eax
    11ab:	68 7c 46 00 00       	push   $0x467c
    11b0:	6a 01                	push   $0x1
    11b2:	e8 81 2b 00 00       	call   3d38 <printf>
    11b7:	83 c4 10             	add    $0x10,%esp
      exit();
    11ba:	e8 0d 2a 00 00       	call   3bcc <exit>
    }
    if(fd >= 0)
    11bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    11c3:	78 0e                	js     11d3 <createdelete+0x23b>
      close(fd);
    11c5:	83 ec 0c             	sub    $0xc,%esp
    11c8:	ff 75 ec             	pushl  -0x14(%ebp)
    11cb:	e8 24 2a 00 00       	call   3bf4 <close>
    11d0:	83 c4 10             	add    $0x10,%esp
  if(pid==0)
    exit();
  else
    wait();

  for(i = 0; i < N; i++){
    11d3:	ff 45 f4             	incl   -0xc(%ebp)
    11d6:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    11da:	0f 8e d5 fe ff ff    	jle    10b5 <createdelete+0x11d>
    }
    if(fd >= 0)
      close(fd);
  }

  for(i = 0; i < N; i++){
    11e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    11e7:	eb 32                	jmp    121b <createdelete+0x283>
    name[0] = 'p';
    11e9:	c6 45 cc 70          	movb   $0x70,-0x34(%ebp)
    name[1] = '0' + i;
    11ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11f0:	83 c0 30             	add    $0x30,%eax
    11f3:	88 45 cd             	mov    %al,-0x33(%ebp)
    unlink(name);
    11f6:	83 ec 0c             	sub    $0xc,%esp
    11f9:	8d 45 cc             	lea    -0x34(%ebp),%eax
    11fc:	50                   	push   %eax
    11fd:	e8 1a 2a 00 00       	call   3c1c <unlink>
    1202:	83 c4 10             	add    $0x10,%esp
    name[0] = 'c';
    1205:	c6 45 cc 63          	movb   $0x63,-0x34(%ebp)
    unlink(name);
    1209:	83 ec 0c             	sub    $0xc,%esp
    120c:	8d 45 cc             	lea    -0x34(%ebp),%eax
    120f:	50                   	push   %eax
    1210:	e8 07 2a 00 00       	call   3c1c <unlink>
    1215:	83 c4 10             	add    $0x10,%esp
    }
    if(fd >= 0)
      close(fd);
  }

  for(i = 0; i < N; i++){
    1218:	ff 45 f4             	incl   -0xc(%ebp)
    121b:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    121f:	7e c8                	jle    11e9 <createdelete+0x251>
    unlink(name);
    name[0] = 'c';
    unlink(name);
  }

  printf(1, "createdelete ok\n");
    1221:	83 ec 08             	sub    $0x8,%esp
    1224:	68 9c 46 00 00       	push   $0x469c
    1229:	6a 01                	push   $0x1
    122b:	e8 08 2b 00 00       	call   3d38 <printf>
    1230:	83 c4 10             	add    $0x10,%esp
}
    1233:	c9                   	leave  
    1234:	c3                   	ret    

00001235 <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    1235:	55                   	push   %ebp
    1236:	89 e5                	mov    %esp,%ebp
    1238:	83 ec 18             	sub    $0x18,%esp
  int fd, fd1;

  printf(1, "unlinkread test\n");
    123b:	83 ec 08             	sub    $0x8,%esp
    123e:	68 ad 46 00 00       	push   $0x46ad
    1243:	6a 01                	push   $0x1
    1245:	e8 ee 2a 00 00       	call   3d38 <printf>
    124a:	83 c4 10             	add    $0x10,%esp
  fd = open("unlinkread", O_CREATE | O_RDWR);
    124d:	83 ec 08             	sub    $0x8,%esp
    1250:	68 02 02 00 00       	push   $0x202
    1255:	68 be 46 00 00       	push   $0x46be
    125a:	e8 ad 29 00 00       	call   3c0c <open>
    125f:	83 c4 10             	add    $0x10,%esp
    1262:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1265:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1269:	79 17                	jns    1282 <unlinkread+0x4d>
    printf(1, "create unlinkread failed\n");
    126b:	83 ec 08             	sub    $0x8,%esp
    126e:	68 c9 46 00 00       	push   $0x46c9
    1273:	6a 01                	push   $0x1
    1275:	e8 be 2a 00 00       	call   3d38 <printf>
    127a:	83 c4 10             	add    $0x10,%esp
    exit();
    127d:	e8 4a 29 00 00       	call   3bcc <exit>
  }
  write(fd, "hello", 5);
    1282:	83 ec 04             	sub    $0x4,%esp
    1285:	6a 05                	push   $0x5
    1287:	68 e3 46 00 00       	push   $0x46e3
    128c:	ff 75 f4             	pushl  -0xc(%ebp)
    128f:	e8 58 29 00 00       	call   3bec <write>
    1294:	83 c4 10             	add    $0x10,%esp
  close(fd);
    1297:	83 ec 0c             	sub    $0xc,%esp
    129a:	ff 75 f4             	pushl  -0xc(%ebp)
    129d:	e8 52 29 00 00       	call   3bf4 <close>
    12a2:	83 c4 10             	add    $0x10,%esp

  fd = open("unlinkread", O_RDWR);
    12a5:	83 ec 08             	sub    $0x8,%esp
    12a8:	6a 02                	push   $0x2
    12aa:	68 be 46 00 00       	push   $0x46be
    12af:	e8 58 29 00 00       	call   3c0c <open>
    12b4:	83 c4 10             	add    $0x10,%esp
    12b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    12ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    12be:	79 17                	jns    12d7 <unlinkread+0xa2>
    printf(1, "open unlinkread failed\n");
    12c0:	83 ec 08             	sub    $0x8,%esp
    12c3:	68 e9 46 00 00       	push   $0x46e9
    12c8:	6a 01                	push   $0x1
    12ca:	e8 69 2a 00 00       	call   3d38 <printf>
    12cf:	83 c4 10             	add    $0x10,%esp
    exit();
    12d2:	e8 f5 28 00 00       	call   3bcc <exit>
  }
  if(unlink("unlinkread") != 0){
    12d7:	83 ec 0c             	sub    $0xc,%esp
    12da:	68 be 46 00 00       	push   $0x46be
    12df:	e8 38 29 00 00       	call   3c1c <unlink>
    12e4:	83 c4 10             	add    $0x10,%esp
    12e7:	85 c0                	test   %eax,%eax
    12e9:	74 17                	je     1302 <unlinkread+0xcd>
    printf(1, "unlink unlinkread failed\n");
    12eb:	83 ec 08             	sub    $0x8,%esp
    12ee:	68 01 47 00 00       	push   $0x4701
    12f3:	6a 01                	push   $0x1
    12f5:	e8 3e 2a 00 00       	call   3d38 <printf>
    12fa:	83 c4 10             	add    $0x10,%esp
    exit();
    12fd:	e8 ca 28 00 00       	call   3bcc <exit>
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    1302:	83 ec 08             	sub    $0x8,%esp
    1305:	68 02 02 00 00       	push   $0x202
    130a:	68 be 46 00 00       	push   $0x46be
    130f:	e8 f8 28 00 00       	call   3c0c <open>
    1314:	83 c4 10             	add    $0x10,%esp
    1317:	89 45 f0             	mov    %eax,-0x10(%ebp)
  write(fd1, "yyy", 3);
    131a:	83 ec 04             	sub    $0x4,%esp
    131d:	6a 03                	push   $0x3
    131f:	68 1b 47 00 00       	push   $0x471b
    1324:	ff 75 f0             	pushl  -0x10(%ebp)
    1327:	e8 c0 28 00 00       	call   3bec <write>
    132c:	83 c4 10             	add    $0x10,%esp
  close(fd1);
    132f:	83 ec 0c             	sub    $0xc,%esp
    1332:	ff 75 f0             	pushl  -0x10(%ebp)
    1335:	e8 ba 28 00 00       	call   3bf4 <close>
    133a:	83 c4 10             	add    $0x10,%esp

  if(read(fd, buf, sizeof(buf)) != 5){
    133d:	83 ec 04             	sub    $0x4,%esp
    1340:	68 00 20 00 00       	push   $0x2000
    1345:	68 a0 7f 00 00       	push   $0x7fa0
    134a:	ff 75 f4             	pushl  -0xc(%ebp)
    134d:	e8 92 28 00 00       	call   3be4 <read>
    1352:	83 c4 10             	add    $0x10,%esp
    1355:	83 f8 05             	cmp    $0x5,%eax
    1358:	74 17                	je     1371 <unlinkread+0x13c>
    printf(1, "unlinkread read failed");
    135a:	83 ec 08             	sub    $0x8,%esp
    135d:	68 1f 47 00 00       	push   $0x471f
    1362:	6a 01                	push   $0x1
    1364:	e8 cf 29 00 00       	call   3d38 <printf>
    1369:	83 c4 10             	add    $0x10,%esp
    exit();
    136c:	e8 5b 28 00 00       	call   3bcc <exit>
  }
  if(buf[0] != 'h'){
    1371:	a0 a0 7f 00 00       	mov    0x7fa0,%al
    1376:	3c 68                	cmp    $0x68,%al
    1378:	74 17                	je     1391 <unlinkread+0x15c>
    printf(1, "unlinkread wrong data\n");
    137a:	83 ec 08             	sub    $0x8,%esp
    137d:	68 36 47 00 00       	push   $0x4736
    1382:	6a 01                	push   $0x1
    1384:	e8 af 29 00 00       	call   3d38 <printf>
    1389:	83 c4 10             	add    $0x10,%esp
    exit();
    138c:	e8 3b 28 00 00       	call   3bcc <exit>
  }
  if(write(fd, buf, 10) != 10){
    1391:	83 ec 04             	sub    $0x4,%esp
    1394:	6a 0a                	push   $0xa
    1396:	68 a0 7f 00 00       	push   $0x7fa0
    139b:	ff 75 f4             	pushl  -0xc(%ebp)
    139e:	e8 49 28 00 00       	call   3bec <write>
    13a3:	83 c4 10             	add    $0x10,%esp
    13a6:	83 f8 0a             	cmp    $0xa,%eax
    13a9:	74 17                	je     13c2 <unlinkread+0x18d>
    printf(1, "unlinkread write failed\n");
    13ab:	83 ec 08             	sub    $0x8,%esp
    13ae:	68 4d 47 00 00       	push   $0x474d
    13b3:	6a 01                	push   $0x1
    13b5:	e8 7e 29 00 00       	call   3d38 <printf>
    13ba:	83 c4 10             	add    $0x10,%esp
    exit();
    13bd:	e8 0a 28 00 00       	call   3bcc <exit>
  }
  close(fd);
    13c2:	83 ec 0c             	sub    $0xc,%esp
    13c5:	ff 75 f4             	pushl  -0xc(%ebp)
    13c8:	e8 27 28 00 00       	call   3bf4 <close>
    13cd:	83 c4 10             	add    $0x10,%esp
  unlink("unlinkread");
    13d0:	83 ec 0c             	sub    $0xc,%esp
    13d3:	68 be 46 00 00       	push   $0x46be
    13d8:	e8 3f 28 00 00       	call   3c1c <unlink>
    13dd:	83 c4 10             	add    $0x10,%esp
  printf(1, "unlinkread ok\n");
    13e0:	83 ec 08             	sub    $0x8,%esp
    13e3:	68 66 47 00 00       	push   $0x4766
    13e8:	6a 01                	push   $0x1
    13ea:	e8 49 29 00 00       	call   3d38 <printf>
    13ef:	83 c4 10             	add    $0x10,%esp
}
    13f2:	c9                   	leave  
    13f3:	c3                   	ret    

000013f4 <linktest>:

void
linktest(void)
{
    13f4:	55                   	push   %ebp
    13f5:	89 e5                	mov    %esp,%ebp
    13f7:	83 ec 18             	sub    $0x18,%esp
  int fd;

  printf(1, "linktest\n");
    13fa:	83 ec 08             	sub    $0x8,%esp
    13fd:	68 75 47 00 00       	push   $0x4775
    1402:	6a 01                	push   $0x1
    1404:	e8 2f 29 00 00       	call   3d38 <printf>
    1409:	83 c4 10             	add    $0x10,%esp

  unlink("lf1");
    140c:	83 ec 0c             	sub    $0xc,%esp
    140f:	68 7f 47 00 00       	push   $0x477f
    1414:	e8 03 28 00 00       	call   3c1c <unlink>
    1419:	83 c4 10             	add    $0x10,%esp
  unlink("lf2");
    141c:	83 ec 0c             	sub    $0xc,%esp
    141f:	68 83 47 00 00       	push   $0x4783
    1424:	e8 f3 27 00 00       	call   3c1c <unlink>
    1429:	83 c4 10             	add    $0x10,%esp

  fd = open("lf1", O_CREATE|O_RDWR);
    142c:	83 ec 08             	sub    $0x8,%esp
    142f:	68 02 02 00 00       	push   $0x202
    1434:	68 7f 47 00 00       	push   $0x477f
    1439:	e8 ce 27 00 00       	call   3c0c <open>
    143e:	83 c4 10             	add    $0x10,%esp
    1441:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1444:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1448:	79 17                	jns    1461 <linktest+0x6d>
    printf(1, "create lf1 failed\n");
    144a:	83 ec 08             	sub    $0x8,%esp
    144d:	68 87 47 00 00       	push   $0x4787
    1452:	6a 01                	push   $0x1
    1454:	e8 df 28 00 00       	call   3d38 <printf>
    1459:	83 c4 10             	add    $0x10,%esp
    exit();
    145c:	e8 6b 27 00 00       	call   3bcc <exit>
  }
  if(write(fd, "hello", 5) != 5){
    1461:	83 ec 04             	sub    $0x4,%esp
    1464:	6a 05                	push   $0x5
    1466:	68 e3 46 00 00       	push   $0x46e3
    146b:	ff 75 f4             	pushl  -0xc(%ebp)
    146e:	e8 79 27 00 00       	call   3bec <write>
    1473:	83 c4 10             	add    $0x10,%esp
    1476:	83 f8 05             	cmp    $0x5,%eax
    1479:	74 17                	je     1492 <linktest+0x9e>
    printf(1, "write lf1 failed\n");
    147b:	83 ec 08             	sub    $0x8,%esp
    147e:	68 9a 47 00 00       	push   $0x479a
    1483:	6a 01                	push   $0x1
    1485:	e8 ae 28 00 00       	call   3d38 <printf>
    148a:	83 c4 10             	add    $0x10,%esp
    exit();
    148d:	e8 3a 27 00 00       	call   3bcc <exit>
  }
  close(fd);
    1492:	83 ec 0c             	sub    $0xc,%esp
    1495:	ff 75 f4             	pushl  -0xc(%ebp)
    1498:	e8 57 27 00 00       	call   3bf4 <close>
    149d:	83 c4 10             	add    $0x10,%esp

  if(link("lf1", "lf2") < 0){
    14a0:	83 ec 08             	sub    $0x8,%esp
    14a3:	68 83 47 00 00       	push   $0x4783
    14a8:	68 7f 47 00 00       	push   $0x477f
    14ad:	e8 7a 27 00 00       	call   3c2c <link>
    14b2:	83 c4 10             	add    $0x10,%esp
    14b5:	85 c0                	test   %eax,%eax
    14b7:	79 17                	jns    14d0 <linktest+0xdc>
    printf(1, "link lf1 lf2 failed\n");
    14b9:	83 ec 08             	sub    $0x8,%esp
    14bc:	68 ac 47 00 00       	push   $0x47ac
    14c1:	6a 01                	push   $0x1
    14c3:	e8 70 28 00 00       	call   3d38 <printf>
    14c8:	83 c4 10             	add    $0x10,%esp
    exit();
    14cb:	e8 fc 26 00 00       	call   3bcc <exit>
  }
  unlink("lf1");
    14d0:	83 ec 0c             	sub    $0xc,%esp
    14d3:	68 7f 47 00 00       	push   $0x477f
    14d8:	e8 3f 27 00 00       	call   3c1c <unlink>
    14dd:	83 c4 10             	add    $0x10,%esp

  if(open("lf1", 0) >= 0){
    14e0:	83 ec 08             	sub    $0x8,%esp
    14e3:	6a 00                	push   $0x0
    14e5:	68 7f 47 00 00       	push   $0x477f
    14ea:	e8 1d 27 00 00       	call   3c0c <open>
    14ef:	83 c4 10             	add    $0x10,%esp
    14f2:	85 c0                	test   %eax,%eax
    14f4:	78 17                	js     150d <linktest+0x119>
    printf(1, "unlinked lf1 but it is still there!\n");
    14f6:	83 ec 08             	sub    $0x8,%esp
    14f9:	68 c4 47 00 00       	push   $0x47c4
    14fe:	6a 01                	push   $0x1
    1500:	e8 33 28 00 00       	call   3d38 <printf>
    1505:	83 c4 10             	add    $0x10,%esp
    exit();
    1508:	e8 bf 26 00 00       	call   3bcc <exit>
  }

  fd = open("lf2", 0);
    150d:	83 ec 08             	sub    $0x8,%esp
    1510:	6a 00                	push   $0x0
    1512:	68 83 47 00 00       	push   $0x4783
    1517:	e8 f0 26 00 00       	call   3c0c <open>
    151c:	83 c4 10             	add    $0x10,%esp
    151f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1522:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1526:	79 17                	jns    153f <linktest+0x14b>
    printf(1, "open lf2 failed\n");
    1528:	83 ec 08             	sub    $0x8,%esp
    152b:	68 e9 47 00 00       	push   $0x47e9
    1530:	6a 01                	push   $0x1
    1532:	e8 01 28 00 00       	call   3d38 <printf>
    1537:	83 c4 10             	add    $0x10,%esp
    exit();
    153a:	e8 8d 26 00 00       	call   3bcc <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    153f:	83 ec 04             	sub    $0x4,%esp
    1542:	68 00 20 00 00       	push   $0x2000
    1547:	68 a0 7f 00 00       	push   $0x7fa0
    154c:	ff 75 f4             	pushl  -0xc(%ebp)
    154f:	e8 90 26 00 00       	call   3be4 <read>
    1554:	83 c4 10             	add    $0x10,%esp
    1557:	83 f8 05             	cmp    $0x5,%eax
    155a:	74 17                	je     1573 <linktest+0x17f>
    printf(1, "read lf2 failed\n");
    155c:	83 ec 08             	sub    $0x8,%esp
    155f:	68 fa 47 00 00       	push   $0x47fa
    1564:	6a 01                	push   $0x1
    1566:	e8 cd 27 00 00       	call   3d38 <printf>
    156b:	83 c4 10             	add    $0x10,%esp
    exit();
    156e:	e8 59 26 00 00       	call   3bcc <exit>
  }
  close(fd);
    1573:	83 ec 0c             	sub    $0xc,%esp
    1576:	ff 75 f4             	pushl  -0xc(%ebp)
    1579:	e8 76 26 00 00       	call   3bf4 <close>
    157e:	83 c4 10             	add    $0x10,%esp

  if(link("lf2", "lf2") >= 0){
    1581:	83 ec 08             	sub    $0x8,%esp
    1584:	68 83 47 00 00       	push   $0x4783
    1589:	68 83 47 00 00       	push   $0x4783
    158e:	e8 99 26 00 00       	call   3c2c <link>
    1593:	83 c4 10             	add    $0x10,%esp
    1596:	85 c0                	test   %eax,%eax
    1598:	78 17                	js     15b1 <linktest+0x1bd>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    159a:	83 ec 08             	sub    $0x8,%esp
    159d:	68 0b 48 00 00       	push   $0x480b
    15a2:	6a 01                	push   $0x1
    15a4:	e8 8f 27 00 00       	call   3d38 <printf>
    15a9:	83 c4 10             	add    $0x10,%esp
    exit();
    15ac:	e8 1b 26 00 00       	call   3bcc <exit>
  }

  unlink("lf2");
    15b1:	83 ec 0c             	sub    $0xc,%esp
    15b4:	68 83 47 00 00       	push   $0x4783
    15b9:	e8 5e 26 00 00       	call   3c1c <unlink>
    15be:	83 c4 10             	add    $0x10,%esp
  if(link("lf2", "lf1") >= 0){
    15c1:	83 ec 08             	sub    $0x8,%esp
    15c4:	68 7f 47 00 00       	push   $0x477f
    15c9:	68 83 47 00 00       	push   $0x4783
    15ce:	e8 59 26 00 00       	call   3c2c <link>
    15d3:	83 c4 10             	add    $0x10,%esp
    15d6:	85 c0                	test   %eax,%eax
    15d8:	78 17                	js     15f1 <linktest+0x1fd>
    printf(1, "link non-existant succeeded! oops\n");
    15da:	83 ec 08             	sub    $0x8,%esp
    15dd:	68 2c 48 00 00       	push   $0x482c
    15e2:	6a 01                	push   $0x1
    15e4:	e8 4f 27 00 00       	call   3d38 <printf>
    15e9:	83 c4 10             	add    $0x10,%esp
    exit();
    15ec:	e8 db 25 00 00       	call   3bcc <exit>
  }

  if(link(".", "lf1") >= 0){
    15f1:	83 ec 08             	sub    $0x8,%esp
    15f4:	68 7f 47 00 00       	push   $0x477f
    15f9:	68 4f 48 00 00       	push   $0x484f
    15fe:	e8 29 26 00 00       	call   3c2c <link>
    1603:	83 c4 10             	add    $0x10,%esp
    1606:	85 c0                	test   %eax,%eax
    1608:	78 17                	js     1621 <linktest+0x22d>
    printf(1, "link . lf1 succeeded! oops\n");
    160a:	83 ec 08             	sub    $0x8,%esp
    160d:	68 51 48 00 00       	push   $0x4851
    1612:	6a 01                	push   $0x1
    1614:	e8 1f 27 00 00       	call   3d38 <printf>
    1619:	83 c4 10             	add    $0x10,%esp
    exit();
    161c:	e8 ab 25 00 00       	call   3bcc <exit>
  }

  printf(1, "linktest ok\n");
    1621:	83 ec 08             	sub    $0x8,%esp
    1624:	68 6d 48 00 00       	push   $0x486d
    1629:	6a 01                	push   $0x1
    162b:	e8 08 27 00 00       	call   3d38 <printf>
    1630:	83 c4 10             	add    $0x10,%esp
}
    1633:	c9                   	leave  
    1634:	c3                   	ret    

00001635 <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    1635:	55                   	push   %ebp
    1636:	89 e5                	mov    %esp,%ebp
    1638:	83 ec 58             	sub    $0x58,%esp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    163b:	83 ec 08             	sub    $0x8,%esp
    163e:	68 7a 48 00 00       	push   $0x487a
    1643:	6a 01                	push   $0x1
    1645:	e8 ee 26 00 00       	call   3d38 <printf>
    164a:	83 c4 10             	add    $0x10,%esp
  file[0] = 'C';
    164d:	c6 45 e5 43          	movb   $0x43,-0x1b(%ebp)
  file[2] = '\0';
    1651:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  for(i = 0; i < 40; i++){
    1655:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    165c:	e9 d5 00 00 00       	jmp    1736 <concreate+0x101>
    file[1] = '0' + i;
    1661:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1664:	83 c0 30             	add    $0x30,%eax
    1667:	88 45 e6             	mov    %al,-0x1a(%ebp)
    unlink(file);
    166a:	83 ec 0c             	sub    $0xc,%esp
    166d:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1670:	50                   	push   %eax
    1671:	e8 a6 25 00 00       	call   3c1c <unlink>
    1676:	83 c4 10             	add    $0x10,%esp
    pid = fork();
    1679:	e8 46 25 00 00       	call   3bc4 <fork>
    167e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid && (i % 3) == 1){
    1681:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1685:	74 28                	je     16af <concreate+0x7a>
    1687:	8b 45 f4             	mov    -0xc(%ebp),%eax
    168a:	b9 03 00 00 00       	mov    $0x3,%ecx
    168f:	99                   	cltd   
    1690:	f7 f9                	idiv   %ecx
    1692:	89 d0                	mov    %edx,%eax
    1694:	83 f8 01             	cmp    $0x1,%eax
    1697:	75 16                	jne    16af <concreate+0x7a>
      link("C0", file);
    1699:	83 ec 08             	sub    $0x8,%esp
    169c:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    169f:	50                   	push   %eax
    16a0:	68 8a 48 00 00       	push   $0x488a
    16a5:	e8 82 25 00 00       	call   3c2c <link>
    16aa:	83 c4 10             	add    $0x10,%esp
    16ad:	eb 74                	jmp    1723 <concreate+0xee>
    } else if(pid == 0 && (i % 5) == 1){
    16af:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    16b3:	75 28                	jne    16dd <concreate+0xa8>
    16b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16b8:	b9 05 00 00 00       	mov    $0x5,%ecx
    16bd:	99                   	cltd   
    16be:	f7 f9                	idiv   %ecx
    16c0:	89 d0                	mov    %edx,%eax
    16c2:	83 f8 01             	cmp    $0x1,%eax
    16c5:	75 16                	jne    16dd <concreate+0xa8>
      link("C0", file);
    16c7:	83 ec 08             	sub    $0x8,%esp
    16ca:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    16cd:	50                   	push   %eax
    16ce:	68 8a 48 00 00       	push   $0x488a
    16d3:	e8 54 25 00 00       	call   3c2c <link>
    16d8:	83 c4 10             	add    $0x10,%esp
    16db:	eb 46                	jmp    1723 <concreate+0xee>
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    16dd:	83 ec 08             	sub    $0x8,%esp
    16e0:	68 02 02 00 00       	push   $0x202
    16e5:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    16e8:	50                   	push   %eax
    16e9:	e8 1e 25 00 00       	call   3c0c <open>
    16ee:	83 c4 10             	add    $0x10,%esp
    16f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(fd < 0){
    16f4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    16f8:	79 1b                	jns    1715 <concreate+0xe0>
        printf(1, "concreate create %s failed\n", file);
    16fa:	83 ec 04             	sub    $0x4,%esp
    16fd:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1700:	50                   	push   %eax
    1701:	68 8d 48 00 00       	push   $0x488d
    1706:	6a 01                	push   $0x1
    1708:	e8 2b 26 00 00       	call   3d38 <printf>
    170d:	83 c4 10             	add    $0x10,%esp
        exit();
    1710:	e8 b7 24 00 00       	call   3bcc <exit>
      }
      close(fd);
    1715:	83 ec 0c             	sub    $0xc,%esp
    1718:	ff 75 e8             	pushl  -0x18(%ebp)
    171b:	e8 d4 24 00 00       	call   3bf4 <close>
    1720:	83 c4 10             	add    $0x10,%esp
    }
    if(pid == 0)
    1723:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1727:	75 05                	jne    172e <concreate+0xf9>
      exit();
    1729:	e8 9e 24 00 00       	call   3bcc <exit>
    else
      wait();
    172e:	e8 a1 24 00 00       	call   3bd4 <wait>
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    1733:	ff 45 f4             	incl   -0xc(%ebp)
    1736:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    173a:	0f 8e 21 ff ff ff    	jle    1661 <concreate+0x2c>
      exit();
    else
      wait();
  }

  memset(fa, 0, sizeof(fa));
    1740:	83 ec 04             	sub    $0x4,%esp
    1743:	6a 28                	push   $0x28
    1745:	6a 00                	push   $0x0
    1747:	8d 45 bd             	lea    -0x43(%ebp),%eax
    174a:	50                   	push   %eax
    174b:	e8 fa 22 00 00       	call   3a4a <memset>
    1750:	83 c4 10             	add    $0x10,%esp
  fd = open(".", 0);
    1753:	83 ec 08             	sub    $0x8,%esp
    1756:	6a 00                	push   $0x0
    1758:	68 4f 48 00 00       	push   $0x484f
    175d:	e8 aa 24 00 00       	call   3c0c <open>
    1762:	83 c4 10             	add    $0x10,%esp
    1765:	89 45 e8             	mov    %eax,-0x18(%ebp)
  n = 0;
    1768:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  while(read(fd, &de, sizeof(de)) > 0){
    176f:	e9 87 00 00 00       	jmp    17fb <concreate+0x1c6>
    if(de.inum == 0)
    1774:	8b 45 ac             	mov    -0x54(%ebp),%eax
    1777:	66 85 c0             	test   %ax,%ax
    177a:	74 7e                	je     17fa <concreate+0x1c5>
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    177c:	8a 45 ae             	mov    -0x52(%ebp),%al
    177f:	3c 43                	cmp    $0x43,%al
    1781:	75 78                	jne    17fb <concreate+0x1c6>
    1783:	8a 45 b0             	mov    -0x50(%ebp),%al
    1786:	84 c0                	test   %al,%al
    1788:	75 71                	jne    17fb <concreate+0x1c6>
      i = de.name[1] - '0';
    178a:	8a 45 af             	mov    -0x51(%ebp),%al
    178d:	0f be c0             	movsbl %al,%eax
    1790:	83 e8 30             	sub    $0x30,%eax
    1793:	89 45 f4             	mov    %eax,-0xc(%ebp)
      if(i < 0 || i >= sizeof(fa)){
    1796:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    179a:	78 08                	js     17a4 <concreate+0x16f>
    179c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    179f:	83 f8 27             	cmp    $0x27,%eax
    17a2:	76 1e                	jbe    17c2 <concreate+0x18d>
        printf(1, "concreate weird file %s\n", de.name);
    17a4:	83 ec 04             	sub    $0x4,%esp
    17a7:	8d 45 ac             	lea    -0x54(%ebp),%eax
    17aa:	83 c0 02             	add    $0x2,%eax
    17ad:	50                   	push   %eax
    17ae:	68 a9 48 00 00       	push   $0x48a9
    17b3:	6a 01                	push   $0x1
    17b5:	e8 7e 25 00 00       	call   3d38 <printf>
    17ba:	83 c4 10             	add    $0x10,%esp
        exit();
    17bd:	e8 0a 24 00 00       	call   3bcc <exit>
      }
      if(fa[i]){
    17c2:	8d 45 bd             	lea    -0x43(%ebp),%eax
    17c5:	03 45 f4             	add    -0xc(%ebp),%eax
    17c8:	8a 00                	mov    (%eax),%al
    17ca:	84 c0                	test   %al,%al
    17cc:	74 1e                	je     17ec <concreate+0x1b7>
        printf(1, "concreate duplicate file %s\n", de.name);
    17ce:	83 ec 04             	sub    $0x4,%esp
    17d1:	8d 45 ac             	lea    -0x54(%ebp),%eax
    17d4:	83 c0 02             	add    $0x2,%eax
    17d7:	50                   	push   %eax
    17d8:	68 c2 48 00 00       	push   $0x48c2
    17dd:	6a 01                	push   $0x1
    17df:	e8 54 25 00 00       	call   3d38 <printf>
    17e4:	83 c4 10             	add    $0x10,%esp
        exit();
    17e7:	e8 e0 23 00 00       	call   3bcc <exit>
      }
      fa[i] = 1;
    17ec:	8d 45 bd             	lea    -0x43(%ebp),%eax
    17ef:	03 45 f4             	add    -0xc(%ebp),%eax
    17f2:	c6 00 01             	movb   $0x1,(%eax)
      n++;
    17f5:	ff 45 f0             	incl   -0x10(%ebp)
    17f8:	eb 01                	jmp    17fb <concreate+0x1c6>
  memset(fa, 0, sizeof(fa));
  fd = open(".", 0);
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    if(de.inum == 0)
      continue;
    17fa:	90                   	nop
  }

  memset(fa, 0, sizeof(fa));
  fd = open(".", 0);
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    17fb:	83 ec 04             	sub    $0x4,%esp
    17fe:	6a 10                	push   $0x10
    1800:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1803:	50                   	push   %eax
    1804:	ff 75 e8             	pushl  -0x18(%ebp)
    1807:	e8 d8 23 00 00       	call   3be4 <read>
    180c:	83 c4 10             	add    $0x10,%esp
    180f:	85 c0                	test   %eax,%eax
    1811:	0f 8f 5d ff ff ff    	jg     1774 <concreate+0x13f>
      }
      fa[i] = 1;
      n++;
    }
  }
  close(fd);
    1817:	83 ec 0c             	sub    $0xc,%esp
    181a:	ff 75 e8             	pushl  -0x18(%ebp)
    181d:	e8 d2 23 00 00       	call   3bf4 <close>
    1822:	83 c4 10             	add    $0x10,%esp

  if(n != 40){
    1825:	83 7d f0 28          	cmpl   $0x28,-0x10(%ebp)
    1829:	74 17                	je     1842 <concreate+0x20d>
    printf(1, "concreate not enough files in directory listing\n");
    182b:	83 ec 08             	sub    $0x8,%esp
    182e:	68 e0 48 00 00       	push   $0x48e0
    1833:	6a 01                	push   $0x1
    1835:	e8 fe 24 00 00       	call   3d38 <printf>
    183a:	83 c4 10             	add    $0x10,%esp
    exit();
    183d:	e8 8a 23 00 00       	call   3bcc <exit>
  }

  for(i = 0; i < 40; i++){
    1842:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1849:	e9 22 01 00 00       	jmp    1970 <concreate+0x33b>
    file[1] = '0' + i;
    184e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1851:	83 c0 30             	add    $0x30,%eax
    1854:	88 45 e6             	mov    %al,-0x1a(%ebp)
    pid = fork();
    1857:	e8 68 23 00 00       	call   3bc4 <fork>
    185c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid < 0){
    185f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1863:	79 17                	jns    187c <concreate+0x247>
      printf(1, "fork failed\n");
    1865:	83 ec 08             	sub    $0x8,%esp
    1868:	68 cd 44 00 00       	push   $0x44cd
    186d:	6a 01                	push   $0x1
    186f:	e8 c4 24 00 00       	call   3d38 <printf>
    1874:	83 c4 10             	add    $0x10,%esp
      exit();
    1877:	e8 50 23 00 00       	call   3bcc <exit>
    }
    if(((i % 3) == 0 && pid == 0) ||
    187c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    187f:	b9 03 00 00 00       	mov    $0x3,%ecx
    1884:	99                   	cltd   
    1885:	f7 f9                	idiv   %ecx
    1887:	89 d0                	mov    %edx,%eax
    1889:	85 c0                	test   %eax,%eax
    188b:	75 06                	jne    1893 <concreate+0x25e>
    188d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1891:	74 18                	je     18ab <concreate+0x276>
       ((i % 3) == 1 && pid != 0)){
    1893:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1896:	b9 03 00 00 00       	mov    $0x3,%ecx
    189b:	99                   	cltd   
    189c:	f7 f9                	idiv   %ecx
    189e:	89 d0                	mov    %edx,%eax
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
      exit();
    }
    if(((i % 3) == 0 && pid == 0) ||
    18a0:	83 f8 01             	cmp    $0x1,%eax
    18a3:	75 7c                	jne    1921 <concreate+0x2ec>
       ((i % 3) == 1 && pid != 0)){
    18a5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    18a9:	74 76                	je     1921 <concreate+0x2ec>
      close(open(file, 0));
    18ab:	83 ec 08             	sub    $0x8,%esp
    18ae:	6a 00                	push   $0x0
    18b0:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    18b3:	50                   	push   %eax
    18b4:	e8 53 23 00 00       	call   3c0c <open>
    18b9:	83 c4 10             	add    $0x10,%esp
    18bc:	83 ec 0c             	sub    $0xc,%esp
    18bf:	50                   	push   %eax
    18c0:	e8 2f 23 00 00       	call   3bf4 <close>
    18c5:	83 c4 10             	add    $0x10,%esp
      close(open(file, 0));
    18c8:	83 ec 08             	sub    $0x8,%esp
    18cb:	6a 00                	push   $0x0
    18cd:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    18d0:	50                   	push   %eax
    18d1:	e8 36 23 00 00       	call   3c0c <open>
    18d6:	83 c4 10             	add    $0x10,%esp
    18d9:	83 ec 0c             	sub    $0xc,%esp
    18dc:	50                   	push   %eax
    18dd:	e8 12 23 00 00       	call   3bf4 <close>
    18e2:	83 c4 10             	add    $0x10,%esp
      close(open(file, 0));
    18e5:	83 ec 08             	sub    $0x8,%esp
    18e8:	6a 00                	push   $0x0
    18ea:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    18ed:	50                   	push   %eax
    18ee:	e8 19 23 00 00       	call   3c0c <open>
    18f3:	83 c4 10             	add    $0x10,%esp
    18f6:	83 ec 0c             	sub    $0xc,%esp
    18f9:	50                   	push   %eax
    18fa:	e8 f5 22 00 00       	call   3bf4 <close>
    18ff:	83 c4 10             	add    $0x10,%esp
      close(open(file, 0));
    1902:	83 ec 08             	sub    $0x8,%esp
    1905:	6a 00                	push   $0x0
    1907:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    190a:	50                   	push   %eax
    190b:	e8 fc 22 00 00       	call   3c0c <open>
    1910:	83 c4 10             	add    $0x10,%esp
    1913:	83 ec 0c             	sub    $0xc,%esp
    1916:	50                   	push   %eax
    1917:	e8 d8 22 00 00       	call   3bf4 <close>
    191c:	83 c4 10             	add    $0x10,%esp
    191f:	eb 3c                	jmp    195d <concreate+0x328>
    } else {
      unlink(file);
    1921:	83 ec 0c             	sub    $0xc,%esp
    1924:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1927:	50                   	push   %eax
    1928:	e8 ef 22 00 00       	call   3c1c <unlink>
    192d:	83 c4 10             	add    $0x10,%esp
      unlink(file);
    1930:	83 ec 0c             	sub    $0xc,%esp
    1933:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1936:	50                   	push   %eax
    1937:	e8 e0 22 00 00       	call   3c1c <unlink>
    193c:	83 c4 10             	add    $0x10,%esp
      unlink(file);
    193f:	83 ec 0c             	sub    $0xc,%esp
    1942:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1945:	50                   	push   %eax
    1946:	e8 d1 22 00 00       	call   3c1c <unlink>
    194b:	83 c4 10             	add    $0x10,%esp
      unlink(file);
    194e:	83 ec 0c             	sub    $0xc,%esp
    1951:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1954:	50                   	push   %eax
    1955:	e8 c2 22 00 00       	call   3c1c <unlink>
    195a:	83 c4 10             	add    $0x10,%esp
    }
    if(pid == 0)
    195d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1961:	75 05                	jne    1968 <concreate+0x333>
      exit();
    1963:	e8 64 22 00 00       	call   3bcc <exit>
    else
      wait();
    1968:	e8 67 22 00 00       	call   3bd4 <wait>
  if(n != 40){
    printf(1, "concreate not enough files in directory listing\n");
    exit();
  }

  for(i = 0; i < 40; i++){
    196d:	ff 45 f4             	incl   -0xc(%ebp)
    1970:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    1974:	0f 8e d4 fe ff ff    	jle    184e <concreate+0x219>
      exit();
    else
      wait();
  }

  printf(1, "concreate ok\n");
    197a:	83 ec 08             	sub    $0x8,%esp
    197d:	68 11 49 00 00       	push   $0x4911
    1982:	6a 01                	push   $0x1
    1984:	e8 af 23 00 00       	call   3d38 <printf>
    1989:	83 c4 10             	add    $0x10,%esp
}
    198c:	c9                   	leave  
    198d:	c3                   	ret    

0000198e <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    198e:	55                   	push   %ebp
    198f:	89 e5                	mov    %esp,%ebp
    1991:	83 ec 18             	sub    $0x18,%esp
  int pid, i;

  printf(1, "linkunlink test\n");
    1994:	83 ec 08             	sub    $0x8,%esp
    1997:	68 1f 49 00 00       	push   $0x491f
    199c:	6a 01                	push   $0x1
    199e:	e8 95 23 00 00       	call   3d38 <printf>
    19a3:	83 c4 10             	add    $0x10,%esp

  unlink("x");
    19a6:	83 ec 0c             	sub    $0xc,%esp
    19a9:	68 86 44 00 00       	push   $0x4486
    19ae:	e8 69 22 00 00       	call   3c1c <unlink>
    19b3:	83 c4 10             	add    $0x10,%esp
  pid = fork();
    19b6:	e8 09 22 00 00       	call   3bc4 <fork>
    19bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid < 0){
    19be:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    19c2:	79 17                	jns    19db <linkunlink+0x4d>
    printf(1, "fork failed\n");
    19c4:	83 ec 08             	sub    $0x8,%esp
    19c7:	68 cd 44 00 00       	push   $0x44cd
    19cc:	6a 01                	push   $0x1
    19ce:	e8 65 23 00 00       	call   3d38 <printf>
    19d3:	83 c4 10             	add    $0x10,%esp
    exit();
    19d6:	e8 f1 21 00 00       	call   3bcc <exit>
  }

  unsigned int x = (pid ? 1 : 97);
    19db:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    19df:	74 07                	je     19e8 <linkunlink+0x5a>
    19e1:	b8 01 00 00 00       	mov    $0x1,%eax
    19e6:	eb 05                	jmp    19ed <linkunlink+0x5f>
    19e8:	b8 61 00 00 00       	mov    $0x61,%eax
    19ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; i < 100; i++){
    19f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    19f7:	e9 ad 00 00 00       	jmp    1aa9 <linkunlink+0x11b>
    x = x * 1103515245 + 12345;
    19fc:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    19ff:	89 c8                	mov    %ecx,%eax
    1a01:	89 c2                	mov    %eax,%edx
    1a03:	c1 e2 09             	shl    $0x9,%edx
    1a06:	29 ca                	sub    %ecx,%edx
    1a08:	c1 e2 02             	shl    $0x2,%edx
    1a0b:	01 ca                	add    %ecx,%edx
    1a0d:	89 d0                	mov    %edx,%eax
    1a0f:	c1 e0 09             	shl    $0x9,%eax
    1a12:	29 d0                	sub    %edx,%eax
    1a14:	d1 e0                	shl    %eax
    1a16:	01 c8                	add    %ecx,%eax
    1a18:	89 c2                	mov    %eax,%edx
    1a1a:	c1 e2 05             	shl    $0x5,%edx
    1a1d:	01 d0                	add    %edx,%eax
    1a1f:	c1 e0 02             	shl    $0x2,%eax
    1a22:	29 c8                	sub    %ecx,%eax
    1a24:	c1 e0 02             	shl    $0x2,%eax
    1a27:	01 c8                	add    %ecx,%eax
    1a29:	05 39 30 00 00       	add    $0x3039,%eax
    1a2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((x % 3) == 0){
    1a31:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a34:	b9 03 00 00 00       	mov    $0x3,%ecx
    1a39:	ba 00 00 00 00       	mov    $0x0,%edx
    1a3e:	f7 f1                	div    %ecx
    1a40:	89 d0                	mov    %edx,%eax
    1a42:	85 c0                	test   %eax,%eax
    1a44:	75 23                	jne    1a69 <linkunlink+0xdb>
      close(open("x", O_RDWR | O_CREATE));
    1a46:	83 ec 08             	sub    $0x8,%esp
    1a49:	68 02 02 00 00       	push   $0x202
    1a4e:	68 86 44 00 00       	push   $0x4486
    1a53:	e8 b4 21 00 00       	call   3c0c <open>
    1a58:	83 c4 10             	add    $0x10,%esp
    1a5b:	83 ec 0c             	sub    $0xc,%esp
    1a5e:	50                   	push   %eax
    1a5f:	e8 90 21 00 00       	call   3bf4 <close>
    1a64:	83 c4 10             	add    $0x10,%esp
    1a67:	eb 3d                	jmp    1aa6 <linkunlink+0x118>
    } else if((x % 3) == 1){
    1a69:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a6c:	b9 03 00 00 00       	mov    $0x3,%ecx
    1a71:	ba 00 00 00 00       	mov    $0x0,%edx
    1a76:	f7 f1                	div    %ecx
    1a78:	89 d0                	mov    %edx,%eax
    1a7a:	83 f8 01             	cmp    $0x1,%eax
    1a7d:	75 17                	jne    1a96 <linkunlink+0x108>
      link("cat", "x");
    1a7f:	83 ec 08             	sub    $0x8,%esp
    1a82:	68 86 44 00 00       	push   $0x4486
    1a87:	68 30 49 00 00       	push   $0x4930
    1a8c:	e8 9b 21 00 00       	call   3c2c <link>
    1a91:	83 c4 10             	add    $0x10,%esp
    1a94:	eb 10                	jmp    1aa6 <linkunlink+0x118>
    } else {
      unlink("x");
    1a96:	83 ec 0c             	sub    $0xc,%esp
    1a99:	68 86 44 00 00       	push   $0x4486
    1a9e:	e8 79 21 00 00       	call   3c1c <unlink>
    1aa3:	83 c4 10             	add    $0x10,%esp
    printf(1, "fork failed\n");
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
  for(i = 0; i < 100; i++){
    1aa6:	ff 45 f4             	incl   -0xc(%ebp)
    1aa9:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
    1aad:	0f 8e 49 ff ff ff    	jle    19fc <linkunlink+0x6e>
    } else {
      unlink("x");
    }
  }

  if(pid)
    1ab3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1ab7:	74 19                	je     1ad2 <linkunlink+0x144>
    wait();
    1ab9:	e8 16 21 00 00       	call   3bd4 <wait>
  else 
    exit();

  printf(1, "linkunlink ok\n");
    1abe:	83 ec 08             	sub    $0x8,%esp
    1ac1:	68 34 49 00 00       	push   $0x4934
    1ac6:	6a 01                	push   $0x1
    1ac8:	e8 6b 22 00 00       	call   3d38 <printf>
    1acd:	83 c4 10             	add    $0x10,%esp
}
    1ad0:	c9                   	leave  
    1ad1:	c3                   	ret    
  }

  if(pid)
    wait();
  else 
    exit();
    1ad2:	e8 f5 20 00 00       	call   3bcc <exit>

00001ad7 <bigdir>:
}

// directory that uses indirect blocks
void
bigdir(void)
{
    1ad7:	55                   	push   %ebp
    1ad8:	89 e5                	mov    %esp,%ebp
    1ada:	83 ec 28             	sub    $0x28,%esp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
    1add:	83 ec 08             	sub    $0x8,%esp
    1ae0:	68 43 49 00 00       	push   $0x4943
    1ae5:	6a 01                	push   $0x1
    1ae7:	e8 4c 22 00 00       	call   3d38 <printf>
    1aec:	83 c4 10             	add    $0x10,%esp
  unlink("bd");
    1aef:	83 ec 0c             	sub    $0xc,%esp
    1af2:	68 50 49 00 00       	push   $0x4950
    1af7:	e8 20 21 00 00       	call   3c1c <unlink>
    1afc:	83 c4 10             	add    $0x10,%esp

  fd = open("bd", O_CREATE);
    1aff:	83 ec 08             	sub    $0x8,%esp
    1b02:	68 00 02 00 00       	push   $0x200
    1b07:	68 50 49 00 00       	push   $0x4950
    1b0c:	e8 fb 20 00 00       	call   3c0c <open>
    1b11:	83 c4 10             	add    $0x10,%esp
    1b14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0){
    1b17:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1b1b:	79 17                	jns    1b34 <bigdir+0x5d>
    printf(1, "bigdir create failed\n");
    1b1d:	83 ec 08             	sub    $0x8,%esp
    1b20:	68 53 49 00 00       	push   $0x4953
    1b25:	6a 01                	push   $0x1
    1b27:	e8 0c 22 00 00       	call   3d38 <printf>
    1b2c:	83 c4 10             	add    $0x10,%esp
    exit();
    1b2f:	e8 98 20 00 00       	call   3bcc <exit>
  }
  close(fd);
    1b34:	83 ec 0c             	sub    $0xc,%esp
    1b37:	ff 75 f0             	pushl  -0x10(%ebp)
    1b3a:	e8 b5 20 00 00       	call   3bf4 <close>
    1b3f:	83 c4 10             	add    $0x10,%esp

  for(i = 0; i < 500; i++){
    1b42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1b49:	eb 64                	jmp    1baf <bigdir+0xd8>
    name[0] = 'x';
    1b4b:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b52:	85 c0                	test   %eax,%eax
    1b54:	79 03                	jns    1b59 <bigdir+0x82>
    1b56:	83 c0 3f             	add    $0x3f,%eax
    1b59:	c1 f8 06             	sar    $0x6,%eax
    1b5c:	83 c0 30             	add    $0x30,%eax
    1b5f:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b65:	25 3f 00 00 80       	and    $0x8000003f,%eax
    1b6a:	85 c0                	test   %eax,%eax
    1b6c:	79 05                	jns    1b73 <bigdir+0x9c>
    1b6e:	48                   	dec    %eax
    1b6f:	83 c8 c0             	or     $0xffffffc0,%eax
    1b72:	40                   	inc    %eax
    1b73:	83 c0 30             	add    $0x30,%eax
    1b76:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1b79:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(link("bd", name) != 0){
    1b7d:	83 ec 08             	sub    $0x8,%esp
    1b80:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1b83:	50                   	push   %eax
    1b84:	68 50 49 00 00       	push   $0x4950
    1b89:	e8 9e 20 00 00       	call   3c2c <link>
    1b8e:	83 c4 10             	add    $0x10,%esp
    1b91:	85 c0                	test   %eax,%eax
    1b93:	74 17                	je     1bac <bigdir+0xd5>
      printf(1, "bigdir link failed\n");
    1b95:	83 ec 08             	sub    $0x8,%esp
    1b98:	68 69 49 00 00       	push   $0x4969
    1b9d:	6a 01                	push   $0x1
    1b9f:	e8 94 21 00 00       	call   3d38 <printf>
    1ba4:	83 c4 10             	add    $0x10,%esp
      exit();
    1ba7:	e8 20 20 00 00       	call   3bcc <exit>
    printf(1, "bigdir create failed\n");
    exit();
  }
  close(fd);

  for(i = 0; i < 500; i++){
    1bac:	ff 45 f4             	incl   -0xc(%ebp)
    1baf:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    1bb6:	7e 93                	jle    1b4b <bigdir+0x74>
      printf(1, "bigdir link failed\n");
      exit();
    }
  }

  unlink("bd");
    1bb8:	83 ec 0c             	sub    $0xc,%esp
    1bbb:	68 50 49 00 00       	push   $0x4950
    1bc0:	e8 57 20 00 00       	call   3c1c <unlink>
    1bc5:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 500; i++){
    1bc8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1bcf:	eb 5f                	jmp    1c30 <bigdir+0x159>
    name[0] = 'x';
    1bd1:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bd8:	85 c0                	test   %eax,%eax
    1bda:	79 03                	jns    1bdf <bigdir+0x108>
    1bdc:	83 c0 3f             	add    $0x3f,%eax
    1bdf:	c1 f8 06             	sar    $0x6,%eax
    1be2:	83 c0 30             	add    $0x30,%eax
    1be5:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1beb:	25 3f 00 00 80       	and    $0x8000003f,%eax
    1bf0:	85 c0                	test   %eax,%eax
    1bf2:	79 05                	jns    1bf9 <bigdir+0x122>
    1bf4:	48                   	dec    %eax
    1bf5:	83 c8 c0             	or     $0xffffffc0,%eax
    1bf8:	40                   	inc    %eax
    1bf9:	83 c0 30             	add    $0x30,%eax
    1bfc:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1bff:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(unlink(name) != 0){
    1c03:	83 ec 0c             	sub    $0xc,%esp
    1c06:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1c09:	50                   	push   %eax
    1c0a:	e8 0d 20 00 00       	call   3c1c <unlink>
    1c0f:	83 c4 10             	add    $0x10,%esp
    1c12:	85 c0                	test   %eax,%eax
    1c14:	74 17                	je     1c2d <bigdir+0x156>
      printf(1, "bigdir unlink failed");
    1c16:	83 ec 08             	sub    $0x8,%esp
    1c19:	68 7d 49 00 00       	push   $0x497d
    1c1e:	6a 01                	push   $0x1
    1c20:	e8 13 21 00 00       	call   3d38 <printf>
    1c25:	83 c4 10             	add    $0x10,%esp
      exit();
    1c28:	e8 9f 1f 00 00       	call   3bcc <exit>
      exit();
    }
  }

  unlink("bd");
  for(i = 0; i < 500; i++){
    1c2d:	ff 45 f4             	incl   -0xc(%ebp)
    1c30:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    1c37:	7e 98                	jle    1bd1 <bigdir+0xfa>
      printf(1, "bigdir unlink failed");
      exit();
    }
  }

  printf(1, "bigdir ok\n");
    1c39:	83 ec 08             	sub    $0x8,%esp
    1c3c:	68 92 49 00 00       	push   $0x4992
    1c41:	6a 01                	push   $0x1
    1c43:	e8 f0 20 00 00       	call   3d38 <printf>
    1c48:	83 c4 10             	add    $0x10,%esp
}
    1c4b:	c9                   	leave  
    1c4c:	c3                   	ret    

00001c4d <subdir>:

void
subdir(void)
{
    1c4d:	55                   	push   %ebp
    1c4e:	89 e5                	mov    %esp,%ebp
    1c50:	83 ec 18             	sub    $0x18,%esp
  int fd, cc;

  printf(1, "subdir test\n");
    1c53:	83 ec 08             	sub    $0x8,%esp
    1c56:	68 9d 49 00 00       	push   $0x499d
    1c5b:	6a 01                	push   $0x1
    1c5d:	e8 d6 20 00 00       	call   3d38 <printf>
    1c62:	83 c4 10             	add    $0x10,%esp

  unlink("ff");
    1c65:	83 ec 0c             	sub    $0xc,%esp
    1c68:	68 aa 49 00 00       	push   $0x49aa
    1c6d:	e8 aa 1f 00 00       	call   3c1c <unlink>
    1c72:	83 c4 10             	add    $0x10,%esp
  if(mkdir("dd") != 0){
    1c75:	83 ec 0c             	sub    $0xc,%esp
    1c78:	68 ad 49 00 00       	push   $0x49ad
    1c7d:	e8 b2 1f 00 00       	call   3c34 <mkdir>
    1c82:	83 c4 10             	add    $0x10,%esp
    1c85:	85 c0                	test   %eax,%eax
    1c87:	74 17                	je     1ca0 <subdir+0x53>
    printf(1, "subdir mkdir dd failed\n");
    1c89:	83 ec 08             	sub    $0x8,%esp
    1c8c:	68 b0 49 00 00       	push   $0x49b0
    1c91:	6a 01                	push   $0x1
    1c93:	e8 a0 20 00 00       	call   3d38 <printf>
    1c98:	83 c4 10             	add    $0x10,%esp
    exit();
    1c9b:	e8 2c 1f 00 00       	call   3bcc <exit>
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    1ca0:	83 ec 08             	sub    $0x8,%esp
    1ca3:	68 02 02 00 00       	push   $0x202
    1ca8:	68 c8 49 00 00       	push   $0x49c8
    1cad:	e8 5a 1f 00 00       	call   3c0c <open>
    1cb2:	83 c4 10             	add    $0x10,%esp
    1cb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1cb8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1cbc:	79 17                	jns    1cd5 <subdir+0x88>
    printf(1, "create dd/ff failed\n");
    1cbe:	83 ec 08             	sub    $0x8,%esp
    1cc1:	68 ce 49 00 00       	push   $0x49ce
    1cc6:	6a 01                	push   $0x1
    1cc8:	e8 6b 20 00 00       	call   3d38 <printf>
    1ccd:	83 c4 10             	add    $0x10,%esp
    exit();
    1cd0:	e8 f7 1e 00 00       	call   3bcc <exit>
  }
  write(fd, "ff", 2);
    1cd5:	83 ec 04             	sub    $0x4,%esp
    1cd8:	6a 02                	push   $0x2
    1cda:	68 aa 49 00 00       	push   $0x49aa
    1cdf:	ff 75 f4             	pushl  -0xc(%ebp)
    1ce2:	e8 05 1f 00 00       	call   3bec <write>
    1ce7:	83 c4 10             	add    $0x10,%esp
  close(fd);
    1cea:	83 ec 0c             	sub    $0xc,%esp
    1ced:	ff 75 f4             	pushl  -0xc(%ebp)
    1cf0:	e8 ff 1e 00 00       	call   3bf4 <close>
    1cf5:	83 c4 10             	add    $0x10,%esp
  
  if(unlink("dd") >= 0){
    1cf8:	83 ec 0c             	sub    $0xc,%esp
    1cfb:	68 ad 49 00 00       	push   $0x49ad
    1d00:	e8 17 1f 00 00       	call   3c1c <unlink>
    1d05:	83 c4 10             	add    $0x10,%esp
    1d08:	85 c0                	test   %eax,%eax
    1d0a:	78 17                	js     1d23 <subdir+0xd6>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    1d0c:	83 ec 08             	sub    $0x8,%esp
    1d0f:	68 e4 49 00 00       	push   $0x49e4
    1d14:	6a 01                	push   $0x1
    1d16:	e8 1d 20 00 00       	call   3d38 <printf>
    1d1b:	83 c4 10             	add    $0x10,%esp
    exit();
    1d1e:	e8 a9 1e 00 00       	call   3bcc <exit>
  }

  if(mkdir("/dd/dd") != 0){
    1d23:	83 ec 0c             	sub    $0xc,%esp
    1d26:	68 0a 4a 00 00       	push   $0x4a0a
    1d2b:	e8 04 1f 00 00       	call   3c34 <mkdir>
    1d30:	83 c4 10             	add    $0x10,%esp
    1d33:	85 c0                	test   %eax,%eax
    1d35:	74 17                	je     1d4e <subdir+0x101>
    printf(1, "subdir mkdir dd/dd failed\n");
    1d37:	83 ec 08             	sub    $0x8,%esp
    1d3a:	68 11 4a 00 00       	push   $0x4a11
    1d3f:	6a 01                	push   $0x1
    1d41:	e8 f2 1f 00 00       	call   3d38 <printf>
    1d46:	83 c4 10             	add    $0x10,%esp
    exit();
    1d49:	e8 7e 1e 00 00       	call   3bcc <exit>
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    1d4e:	83 ec 08             	sub    $0x8,%esp
    1d51:	68 02 02 00 00       	push   $0x202
    1d56:	68 2c 4a 00 00       	push   $0x4a2c
    1d5b:	e8 ac 1e 00 00       	call   3c0c <open>
    1d60:	83 c4 10             	add    $0x10,%esp
    1d63:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1d66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1d6a:	79 17                	jns    1d83 <subdir+0x136>
    printf(1, "create dd/dd/ff failed\n");
    1d6c:	83 ec 08             	sub    $0x8,%esp
    1d6f:	68 35 4a 00 00       	push   $0x4a35
    1d74:	6a 01                	push   $0x1
    1d76:	e8 bd 1f 00 00       	call   3d38 <printf>
    1d7b:	83 c4 10             	add    $0x10,%esp
    exit();
    1d7e:	e8 49 1e 00 00       	call   3bcc <exit>
  }
  write(fd, "FF", 2);
    1d83:	83 ec 04             	sub    $0x4,%esp
    1d86:	6a 02                	push   $0x2
    1d88:	68 4d 4a 00 00       	push   $0x4a4d
    1d8d:	ff 75 f4             	pushl  -0xc(%ebp)
    1d90:	e8 57 1e 00 00       	call   3bec <write>
    1d95:	83 c4 10             	add    $0x10,%esp
  close(fd);
    1d98:	83 ec 0c             	sub    $0xc,%esp
    1d9b:	ff 75 f4             	pushl  -0xc(%ebp)
    1d9e:	e8 51 1e 00 00       	call   3bf4 <close>
    1da3:	83 c4 10             	add    $0x10,%esp

  fd = open("dd/dd/../ff", 0);
    1da6:	83 ec 08             	sub    $0x8,%esp
    1da9:	6a 00                	push   $0x0
    1dab:	68 50 4a 00 00       	push   $0x4a50
    1db0:	e8 57 1e 00 00       	call   3c0c <open>
    1db5:	83 c4 10             	add    $0x10,%esp
    1db8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1dbb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1dbf:	79 17                	jns    1dd8 <subdir+0x18b>
    printf(1, "open dd/dd/../ff failed\n");
    1dc1:	83 ec 08             	sub    $0x8,%esp
    1dc4:	68 5c 4a 00 00       	push   $0x4a5c
    1dc9:	6a 01                	push   $0x1
    1dcb:	e8 68 1f 00 00       	call   3d38 <printf>
    1dd0:	83 c4 10             	add    $0x10,%esp
    exit();
    1dd3:	e8 f4 1d 00 00       	call   3bcc <exit>
  }
  cc = read(fd, buf, sizeof(buf));
    1dd8:	83 ec 04             	sub    $0x4,%esp
    1ddb:	68 00 20 00 00       	push   $0x2000
    1de0:	68 a0 7f 00 00       	push   $0x7fa0
    1de5:	ff 75 f4             	pushl  -0xc(%ebp)
    1de8:	e8 f7 1d 00 00       	call   3be4 <read>
    1ded:	83 c4 10             	add    $0x10,%esp
    1df0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(cc != 2 || buf[0] != 'f'){
    1df3:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
    1df7:	75 09                	jne    1e02 <subdir+0x1b5>
    1df9:	a0 a0 7f 00 00       	mov    0x7fa0,%al
    1dfe:	3c 66                	cmp    $0x66,%al
    1e00:	74 17                	je     1e19 <subdir+0x1cc>
    printf(1, "dd/dd/../ff wrong content\n");
    1e02:	83 ec 08             	sub    $0x8,%esp
    1e05:	68 75 4a 00 00       	push   $0x4a75
    1e0a:	6a 01                	push   $0x1
    1e0c:	e8 27 1f 00 00       	call   3d38 <printf>
    1e11:	83 c4 10             	add    $0x10,%esp
    exit();
    1e14:	e8 b3 1d 00 00       	call   3bcc <exit>
  }
  close(fd);
    1e19:	83 ec 0c             	sub    $0xc,%esp
    1e1c:	ff 75 f4             	pushl  -0xc(%ebp)
    1e1f:	e8 d0 1d 00 00       	call   3bf4 <close>
    1e24:	83 c4 10             	add    $0x10,%esp

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    1e27:	83 ec 08             	sub    $0x8,%esp
    1e2a:	68 90 4a 00 00       	push   $0x4a90
    1e2f:	68 2c 4a 00 00       	push   $0x4a2c
    1e34:	e8 f3 1d 00 00       	call   3c2c <link>
    1e39:	83 c4 10             	add    $0x10,%esp
    1e3c:	85 c0                	test   %eax,%eax
    1e3e:	74 17                	je     1e57 <subdir+0x20a>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    1e40:	83 ec 08             	sub    $0x8,%esp
    1e43:	68 9c 4a 00 00       	push   $0x4a9c
    1e48:	6a 01                	push   $0x1
    1e4a:	e8 e9 1e 00 00       	call   3d38 <printf>
    1e4f:	83 c4 10             	add    $0x10,%esp
    exit();
    1e52:	e8 75 1d 00 00       	call   3bcc <exit>
  }

  if(unlink("dd/dd/ff") != 0){
    1e57:	83 ec 0c             	sub    $0xc,%esp
    1e5a:	68 2c 4a 00 00       	push   $0x4a2c
    1e5f:	e8 b8 1d 00 00       	call   3c1c <unlink>
    1e64:	83 c4 10             	add    $0x10,%esp
    1e67:	85 c0                	test   %eax,%eax
    1e69:	74 17                	je     1e82 <subdir+0x235>
    printf(1, "unlink dd/dd/ff failed\n");
    1e6b:	83 ec 08             	sub    $0x8,%esp
    1e6e:	68 bd 4a 00 00       	push   $0x4abd
    1e73:	6a 01                	push   $0x1
    1e75:	e8 be 1e 00 00       	call   3d38 <printf>
    1e7a:	83 c4 10             	add    $0x10,%esp
    exit();
    1e7d:	e8 4a 1d 00 00       	call   3bcc <exit>
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1e82:	83 ec 08             	sub    $0x8,%esp
    1e85:	6a 00                	push   $0x0
    1e87:	68 2c 4a 00 00       	push   $0x4a2c
    1e8c:	e8 7b 1d 00 00       	call   3c0c <open>
    1e91:	83 c4 10             	add    $0x10,%esp
    1e94:	85 c0                	test   %eax,%eax
    1e96:	78 17                	js     1eaf <subdir+0x262>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    1e98:	83 ec 08             	sub    $0x8,%esp
    1e9b:	68 d8 4a 00 00       	push   $0x4ad8
    1ea0:	6a 01                	push   $0x1
    1ea2:	e8 91 1e 00 00       	call   3d38 <printf>
    1ea7:	83 c4 10             	add    $0x10,%esp
    exit();
    1eaa:	e8 1d 1d 00 00       	call   3bcc <exit>
  }

  if(chdir("dd") != 0){
    1eaf:	83 ec 0c             	sub    $0xc,%esp
    1eb2:	68 ad 49 00 00       	push   $0x49ad
    1eb7:	e8 80 1d 00 00       	call   3c3c <chdir>
    1ebc:	83 c4 10             	add    $0x10,%esp
    1ebf:	85 c0                	test   %eax,%eax
    1ec1:	74 17                	je     1eda <subdir+0x28d>
    printf(1, "chdir dd failed\n");
    1ec3:	83 ec 08             	sub    $0x8,%esp
    1ec6:	68 fc 4a 00 00       	push   $0x4afc
    1ecb:	6a 01                	push   $0x1
    1ecd:	e8 66 1e 00 00       	call   3d38 <printf>
    1ed2:	83 c4 10             	add    $0x10,%esp
    exit();
    1ed5:	e8 f2 1c 00 00       	call   3bcc <exit>
  }
  if(chdir("dd/../../dd") != 0){
    1eda:	83 ec 0c             	sub    $0xc,%esp
    1edd:	68 0d 4b 00 00       	push   $0x4b0d
    1ee2:	e8 55 1d 00 00       	call   3c3c <chdir>
    1ee7:	83 c4 10             	add    $0x10,%esp
    1eea:	85 c0                	test   %eax,%eax
    1eec:	74 17                	je     1f05 <subdir+0x2b8>
    printf(1, "chdir dd/../../dd failed\n");
    1eee:	83 ec 08             	sub    $0x8,%esp
    1ef1:	68 19 4b 00 00       	push   $0x4b19
    1ef6:	6a 01                	push   $0x1
    1ef8:	e8 3b 1e 00 00       	call   3d38 <printf>
    1efd:	83 c4 10             	add    $0x10,%esp
    exit();
    1f00:	e8 c7 1c 00 00       	call   3bcc <exit>
  }
  if(chdir("dd/../../../dd") != 0){
    1f05:	83 ec 0c             	sub    $0xc,%esp
    1f08:	68 33 4b 00 00       	push   $0x4b33
    1f0d:	e8 2a 1d 00 00       	call   3c3c <chdir>
    1f12:	83 c4 10             	add    $0x10,%esp
    1f15:	85 c0                	test   %eax,%eax
    1f17:	74 17                	je     1f30 <subdir+0x2e3>
    printf(1, "chdir dd/../../dd failed\n");
    1f19:	83 ec 08             	sub    $0x8,%esp
    1f1c:	68 19 4b 00 00       	push   $0x4b19
    1f21:	6a 01                	push   $0x1
    1f23:	e8 10 1e 00 00       	call   3d38 <printf>
    1f28:	83 c4 10             	add    $0x10,%esp
    exit();
    1f2b:	e8 9c 1c 00 00       	call   3bcc <exit>
  }
  if(chdir("./..") != 0){
    1f30:	83 ec 0c             	sub    $0xc,%esp
    1f33:	68 42 4b 00 00       	push   $0x4b42
    1f38:	e8 ff 1c 00 00       	call   3c3c <chdir>
    1f3d:	83 c4 10             	add    $0x10,%esp
    1f40:	85 c0                	test   %eax,%eax
    1f42:	74 17                	je     1f5b <subdir+0x30e>
    printf(1, "chdir ./.. failed\n");
    1f44:	83 ec 08             	sub    $0x8,%esp
    1f47:	68 47 4b 00 00       	push   $0x4b47
    1f4c:	6a 01                	push   $0x1
    1f4e:	e8 e5 1d 00 00       	call   3d38 <printf>
    1f53:	83 c4 10             	add    $0x10,%esp
    exit();
    1f56:	e8 71 1c 00 00       	call   3bcc <exit>
  }

  fd = open("dd/dd/ffff", 0);
    1f5b:	83 ec 08             	sub    $0x8,%esp
    1f5e:	6a 00                	push   $0x0
    1f60:	68 90 4a 00 00       	push   $0x4a90
    1f65:	e8 a2 1c 00 00       	call   3c0c <open>
    1f6a:	83 c4 10             	add    $0x10,%esp
    1f6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1f70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1f74:	79 17                	jns    1f8d <subdir+0x340>
    printf(1, "open dd/dd/ffff failed\n");
    1f76:	83 ec 08             	sub    $0x8,%esp
    1f79:	68 5a 4b 00 00       	push   $0x4b5a
    1f7e:	6a 01                	push   $0x1
    1f80:	e8 b3 1d 00 00       	call   3d38 <printf>
    1f85:	83 c4 10             	add    $0x10,%esp
    exit();
    1f88:	e8 3f 1c 00 00       	call   3bcc <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    1f8d:	83 ec 04             	sub    $0x4,%esp
    1f90:	68 00 20 00 00       	push   $0x2000
    1f95:	68 a0 7f 00 00       	push   $0x7fa0
    1f9a:	ff 75 f4             	pushl  -0xc(%ebp)
    1f9d:	e8 42 1c 00 00       	call   3be4 <read>
    1fa2:	83 c4 10             	add    $0x10,%esp
    1fa5:	83 f8 02             	cmp    $0x2,%eax
    1fa8:	74 17                	je     1fc1 <subdir+0x374>
    printf(1, "read dd/dd/ffff wrong len\n");
    1faa:	83 ec 08             	sub    $0x8,%esp
    1fad:	68 72 4b 00 00       	push   $0x4b72
    1fb2:	6a 01                	push   $0x1
    1fb4:	e8 7f 1d 00 00       	call   3d38 <printf>
    1fb9:	83 c4 10             	add    $0x10,%esp
    exit();
    1fbc:	e8 0b 1c 00 00       	call   3bcc <exit>
  }
  close(fd);
    1fc1:	83 ec 0c             	sub    $0xc,%esp
    1fc4:	ff 75 f4             	pushl  -0xc(%ebp)
    1fc7:	e8 28 1c 00 00       	call   3bf4 <close>
    1fcc:	83 c4 10             	add    $0x10,%esp

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1fcf:	83 ec 08             	sub    $0x8,%esp
    1fd2:	6a 00                	push   $0x0
    1fd4:	68 2c 4a 00 00       	push   $0x4a2c
    1fd9:	e8 2e 1c 00 00       	call   3c0c <open>
    1fde:	83 c4 10             	add    $0x10,%esp
    1fe1:	85 c0                	test   %eax,%eax
    1fe3:	78 17                	js     1ffc <subdir+0x3af>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    1fe5:	83 ec 08             	sub    $0x8,%esp
    1fe8:	68 90 4b 00 00       	push   $0x4b90
    1fed:	6a 01                	push   $0x1
    1fef:	e8 44 1d 00 00       	call   3d38 <printf>
    1ff4:	83 c4 10             	add    $0x10,%esp
    exit();
    1ff7:	e8 d0 1b 00 00       	call   3bcc <exit>
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    1ffc:	83 ec 08             	sub    $0x8,%esp
    1fff:	68 02 02 00 00       	push   $0x202
    2004:	68 b5 4b 00 00       	push   $0x4bb5
    2009:	e8 fe 1b 00 00       	call   3c0c <open>
    200e:	83 c4 10             	add    $0x10,%esp
    2011:	85 c0                	test   %eax,%eax
    2013:	78 17                	js     202c <subdir+0x3df>
    printf(1, "create dd/ff/ff succeeded!\n");
    2015:	83 ec 08             	sub    $0x8,%esp
    2018:	68 be 4b 00 00       	push   $0x4bbe
    201d:	6a 01                	push   $0x1
    201f:	e8 14 1d 00 00       	call   3d38 <printf>
    2024:	83 c4 10             	add    $0x10,%esp
    exit();
    2027:	e8 a0 1b 00 00       	call   3bcc <exit>
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    202c:	83 ec 08             	sub    $0x8,%esp
    202f:	68 02 02 00 00       	push   $0x202
    2034:	68 da 4b 00 00       	push   $0x4bda
    2039:	e8 ce 1b 00 00       	call   3c0c <open>
    203e:	83 c4 10             	add    $0x10,%esp
    2041:	85 c0                	test   %eax,%eax
    2043:	78 17                	js     205c <subdir+0x40f>
    printf(1, "create dd/xx/ff succeeded!\n");
    2045:	83 ec 08             	sub    $0x8,%esp
    2048:	68 e3 4b 00 00       	push   $0x4be3
    204d:	6a 01                	push   $0x1
    204f:	e8 e4 1c 00 00       	call   3d38 <printf>
    2054:	83 c4 10             	add    $0x10,%esp
    exit();
    2057:	e8 70 1b 00 00       	call   3bcc <exit>
  }
  if(open("dd", O_CREATE) >= 0){
    205c:	83 ec 08             	sub    $0x8,%esp
    205f:	68 00 02 00 00       	push   $0x200
    2064:	68 ad 49 00 00       	push   $0x49ad
    2069:	e8 9e 1b 00 00       	call   3c0c <open>
    206e:	83 c4 10             	add    $0x10,%esp
    2071:	85 c0                	test   %eax,%eax
    2073:	78 17                	js     208c <subdir+0x43f>
    printf(1, "create dd succeeded!\n");
    2075:	83 ec 08             	sub    $0x8,%esp
    2078:	68 ff 4b 00 00       	push   $0x4bff
    207d:	6a 01                	push   $0x1
    207f:	e8 b4 1c 00 00       	call   3d38 <printf>
    2084:	83 c4 10             	add    $0x10,%esp
    exit();
    2087:	e8 40 1b 00 00       	call   3bcc <exit>
  }
  if(open("dd", O_RDWR) >= 0){
    208c:	83 ec 08             	sub    $0x8,%esp
    208f:	6a 02                	push   $0x2
    2091:	68 ad 49 00 00       	push   $0x49ad
    2096:	e8 71 1b 00 00       	call   3c0c <open>
    209b:	83 c4 10             	add    $0x10,%esp
    209e:	85 c0                	test   %eax,%eax
    20a0:	78 17                	js     20b9 <subdir+0x46c>
    printf(1, "open dd rdwr succeeded!\n");
    20a2:	83 ec 08             	sub    $0x8,%esp
    20a5:	68 15 4c 00 00       	push   $0x4c15
    20aa:	6a 01                	push   $0x1
    20ac:	e8 87 1c 00 00       	call   3d38 <printf>
    20b1:	83 c4 10             	add    $0x10,%esp
    exit();
    20b4:	e8 13 1b 00 00       	call   3bcc <exit>
  }
  if(open("dd", O_WRONLY) >= 0){
    20b9:	83 ec 08             	sub    $0x8,%esp
    20bc:	6a 01                	push   $0x1
    20be:	68 ad 49 00 00       	push   $0x49ad
    20c3:	e8 44 1b 00 00       	call   3c0c <open>
    20c8:	83 c4 10             	add    $0x10,%esp
    20cb:	85 c0                	test   %eax,%eax
    20cd:	78 17                	js     20e6 <subdir+0x499>
    printf(1, "open dd wronly succeeded!\n");
    20cf:	83 ec 08             	sub    $0x8,%esp
    20d2:	68 2e 4c 00 00       	push   $0x4c2e
    20d7:	6a 01                	push   $0x1
    20d9:	e8 5a 1c 00 00       	call   3d38 <printf>
    20de:	83 c4 10             	add    $0x10,%esp
    exit();
    20e1:	e8 e6 1a 00 00       	call   3bcc <exit>
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    20e6:	83 ec 08             	sub    $0x8,%esp
    20e9:	68 49 4c 00 00       	push   $0x4c49
    20ee:	68 b5 4b 00 00       	push   $0x4bb5
    20f3:	e8 34 1b 00 00       	call   3c2c <link>
    20f8:	83 c4 10             	add    $0x10,%esp
    20fb:	85 c0                	test   %eax,%eax
    20fd:	75 17                	jne    2116 <subdir+0x4c9>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    20ff:	83 ec 08             	sub    $0x8,%esp
    2102:	68 54 4c 00 00       	push   $0x4c54
    2107:	6a 01                	push   $0x1
    2109:	e8 2a 1c 00 00       	call   3d38 <printf>
    210e:	83 c4 10             	add    $0x10,%esp
    exit();
    2111:	e8 b6 1a 00 00       	call   3bcc <exit>
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2116:	83 ec 08             	sub    $0x8,%esp
    2119:	68 49 4c 00 00       	push   $0x4c49
    211e:	68 da 4b 00 00       	push   $0x4bda
    2123:	e8 04 1b 00 00       	call   3c2c <link>
    2128:	83 c4 10             	add    $0x10,%esp
    212b:	85 c0                	test   %eax,%eax
    212d:	75 17                	jne    2146 <subdir+0x4f9>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    212f:	83 ec 08             	sub    $0x8,%esp
    2132:	68 78 4c 00 00       	push   $0x4c78
    2137:	6a 01                	push   $0x1
    2139:	e8 fa 1b 00 00       	call   3d38 <printf>
    213e:	83 c4 10             	add    $0x10,%esp
    exit();
    2141:	e8 86 1a 00 00       	call   3bcc <exit>
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2146:	83 ec 08             	sub    $0x8,%esp
    2149:	68 90 4a 00 00       	push   $0x4a90
    214e:	68 c8 49 00 00       	push   $0x49c8
    2153:	e8 d4 1a 00 00       	call   3c2c <link>
    2158:	83 c4 10             	add    $0x10,%esp
    215b:	85 c0                	test   %eax,%eax
    215d:	75 17                	jne    2176 <subdir+0x529>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    215f:	83 ec 08             	sub    $0x8,%esp
    2162:	68 9c 4c 00 00       	push   $0x4c9c
    2167:	6a 01                	push   $0x1
    2169:	e8 ca 1b 00 00       	call   3d38 <printf>
    216e:	83 c4 10             	add    $0x10,%esp
    exit();
    2171:	e8 56 1a 00 00       	call   3bcc <exit>
  }
  if(mkdir("dd/ff/ff") == 0){
    2176:	83 ec 0c             	sub    $0xc,%esp
    2179:	68 b5 4b 00 00       	push   $0x4bb5
    217e:	e8 b1 1a 00 00       	call   3c34 <mkdir>
    2183:	83 c4 10             	add    $0x10,%esp
    2186:	85 c0                	test   %eax,%eax
    2188:	75 17                	jne    21a1 <subdir+0x554>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    218a:	83 ec 08             	sub    $0x8,%esp
    218d:	68 be 4c 00 00       	push   $0x4cbe
    2192:	6a 01                	push   $0x1
    2194:	e8 9f 1b 00 00       	call   3d38 <printf>
    2199:	83 c4 10             	add    $0x10,%esp
    exit();
    219c:	e8 2b 1a 00 00       	call   3bcc <exit>
  }
  if(mkdir("dd/xx/ff") == 0){
    21a1:	83 ec 0c             	sub    $0xc,%esp
    21a4:	68 da 4b 00 00       	push   $0x4bda
    21a9:	e8 86 1a 00 00       	call   3c34 <mkdir>
    21ae:	83 c4 10             	add    $0x10,%esp
    21b1:	85 c0                	test   %eax,%eax
    21b3:	75 17                	jne    21cc <subdir+0x57f>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    21b5:	83 ec 08             	sub    $0x8,%esp
    21b8:	68 d9 4c 00 00       	push   $0x4cd9
    21bd:	6a 01                	push   $0x1
    21bf:	e8 74 1b 00 00       	call   3d38 <printf>
    21c4:	83 c4 10             	add    $0x10,%esp
    exit();
    21c7:	e8 00 1a 00 00       	call   3bcc <exit>
  }
  if(mkdir("dd/dd/ffff") == 0){
    21cc:	83 ec 0c             	sub    $0xc,%esp
    21cf:	68 90 4a 00 00       	push   $0x4a90
    21d4:	e8 5b 1a 00 00       	call   3c34 <mkdir>
    21d9:	83 c4 10             	add    $0x10,%esp
    21dc:	85 c0                	test   %eax,%eax
    21de:	75 17                	jne    21f7 <subdir+0x5aa>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    21e0:	83 ec 08             	sub    $0x8,%esp
    21e3:	68 f4 4c 00 00       	push   $0x4cf4
    21e8:	6a 01                	push   $0x1
    21ea:	e8 49 1b 00 00       	call   3d38 <printf>
    21ef:	83 c4 10             	add    $0x10,%esp
    exit();
    21f2:	e8 d5 19 00 00       	call   3bcc <exit>
  }
  if(unlink("dd/xx/ff") == 0){
    21f7:	83 ec 0c             	sub    $0xc,%esp
    21fa:	68 da 4b 00 00       	push   $0x4bda
    21ff:	e8 18 1a 00 00       	call   3c1c <unlink>
    2204:	83 c4 10             	add    $0x10,%esp
    2207:	85 c0                	test   %eax,%eax
    2209:	75 17                	jne    2222 <subdir+0x5d5>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    220b:	83 ec 08             	sub    $0x8,%esp
    220e:	68 11 4d 00 00       	push   $0x4d11
    2213:	6a 01                	push   $0x1
    2215:	e8 1e 1b 00 00       	call   3d38 <printf>
    221a:	83 c4 10             	add    $0x10,%esp
    exit();
    221d:	e8 aa 19 00 00       	call   3bcc <exit>
  }
  if(unlink("dd/ff/ff") == 0){
    2222:	83 ec 0c             	sub    $0xc,%esp
    2225:	68 b5 4b 00 00       	push   $0x4bb5
    222a:	e8 ed 19 00 00       	call   3c1c <unlink>
    222f:	83 c4 10             	add    $0x10,%esp
    2232:	85 c0                	test   %eax,%eax
    2234:	75 17                	jne    224d <subdir+0x600>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    2236:	83 ec 08             	sub    $0x8,%esp
    2239:	68 2d 4d 00 00       	push   $0x4d2d
    223e:	6a 01                	push   $0x1
    2240:	e8 f3 1a 00 00       	call   3d38 <printf>
    2245:	83 c4 10             	add    $0x10,%esp
    exit();
    2248:	e8 7f 19 00 00       	call   3bcc <exit>
  }
  if(chdir("dd/ff") == 0){
    224d:	83 ec 0c             	sub    $0xc,%esp
    2250:	68 c8 49 00 00       	push   $0x49c8
    2255:	e8 e2 19 00 00       	call   3c3c <chdir>
    225a:	83 c4 10             	add    $0x10,%esp
    225d:	85 c0                	test   %eax,%eax
    225f:	75 17                	jne    2278 <subdir+0x62b>
    printf(1, "chdir dd/ff succeeded!\n");
    2261:	83 ec 08             	sub    $0x8,%esp
    2264:	68 49 4d 00 00       	push   $0x4d49
    2269:	6a 01                	push   $0x1
    226b:	e8 c8 1a 00 00       	call   3d38 <printf>
    2270:	83 c4 10             	add    $0x10,%esp
    exit();
    2273:	e8 54 19 00 00       	call   3bcc <exit>
  }
  if(chdir("dd/xx") == 0){
    2278:	83 ec 0c             	sub    $0xc,%esp
    227b:	68 61 4d 00 00       	push   $0x4d61
    2280:	e8 b7 19 00 00       	call   3c3c <chdir>
    2285:	83 c4 10             	add    $0x10,%esp
    2288:	85 c0                	test   %eax,%eax
    228a:	75 17                	jne    22a3 <subdir+0x656>
    printf(1, "chdir dd/xx succeeded!\n");
    228c:	83 ec 08             	sub    $0x8,%esp
    228f:	68 67 4d 00 00       	push   $0x4d67
    2294:	6a 01                	push   $0x1
    2296:	e8 9d 1a 00 00       	call   3d38 <printf>
    229b:	83 c4 10             	add    $0x10,%esp
    exit();
    229e:	e8 29 19 00 00       	call   3bcc <exit>
  }

  if(unlink("dd/dd/ffff") != 0){
    22a3:	83 ec 0c             	sub    $0xc,%esp
    22a6:	68 90 4a 00 00       	push   $0x4a90
    22ab:	e8 6c 19 00 00       	call   3c1c <unlink>
    22b0:	83 c4 10             	add    $0x10,%esp
    22b3:	85 c0                	test   %eax,%eax
    22b5:	74 17                	je     22ce <subdir+0x681>
    printf(1, "unlink dd/dd/ff failed\n");
    22b7:	83 ec 08             	sub    $0x8,%esp
    22ba:	68 bd 4a 00 00       	push   $0x4abd
    22bf:	6a 01                	push   $0x1
    22c1:	e8 72 1a 00 00       	call   3d38 <printf>
    22c6:	83 c4 10             	add    $0x10,%esp
    exit();
    22c9:	e8 fe 18 00 00       	call   3bcc <exit>
  }
  if(unlink("dd/ff") != 0){
    22ce:	83 ec 0c             	sub    $0xc,%esp
    22d1:	68 c8 49 00 00       	push   $0x49c8
    22d6:	e8 41 19 00 00       	call   3c1c <unlink>
    22db:	83 c4 10             	add    $0x10,%esp
    22de:	85 c0                	test   %eax,%eax
    22e0:	74 17                	je     22f9 <subdir+0x6ac>
    printf(1, "unlink dd/ff failed\n");
    22e2:	83 ec 08             	sub    $0x8,%esp
    22e5:	68 7f 4d 00 00       	push   $0x4d7f
    22ea:	6a 01                	push   $0x1
    22ec:	e8 47 1a 00 00       	call   3d38 <printf>
    22f1:	83 c4 10             	add    $0x10,%esp
    exit();
    22f4:	e8 d3 18 00 00       	call   3bcc <exit>
  }
  if(unlink("dd") == 0){
    22f9:	83 ec 0c             	sub    $0xc,%esp
    22fc:	68 ad 49 00 00       	push   $0x49ad
    2301:	e8 16 19 00 00       	call   3c1c <unlink>
    2306:	83 c4 10             	add    $0x10,%esp
    2309:	85 c0                	test   %eax,%eax
    230b:	75 17                	jne    2324 <subdir+0x6d7>
    printf(1, "unlink non-empty dd succeeded!\n");
    230d:	83 ec 08             	sub    $0x8,%esp
    2310:	68 94 4d 00 00       	push   $0x4d94
    2315:	6a 01                	push   $0x1
    2317:	e8 1c 1a 00 00       	call   3d38 <printf>
    231c:	83 c4 10             	add    $0x10,%esp
    exit();
    231f:	e8 a8 18 00 00       	call   3bcc <exit>
  }
  if(unlink("dd/dd") < 0){
    2324:	83 ec 0c             	sub    $0xc,%esp
    2327:	68 b4 4d 00 00       	push   $0x4db4
    232c:	e8 eb 18 00 00       	call   3c1c <unlink>
    2331:	83 c4 10             	add    $0x10,%esp
    2334:	85 c0                	test   %eax,%eax
    2336:	79 17                	jns    234f <subdir+0x702>
    printf(1, "unlink dd/dd failed\n");
    2338:	83 ec 08             	sub    $0x8,%esp
    233b:	68 ba 4d 00 00       	push   $0x4dba
    2340:	6a 01                	push   $0x1
    2342:	e8 f1 19 00 00       	call   3d38 <printf>
    2347:	83 c4 10             	add    $0x10,%esp
    exit();
    234a:	e8 7d 18 00 00       	call   3bcc <exit>
  }
  if(unlink("dd") < 0){
    234f:	83 ec 0c             	sub    $0xc,%esp
    2352:	68 ad 49 00 00       	push   $0x49ad
    2357:	e8 c0 18 00 00       	call   3c1c <unlink>
    235c:	83 c4 10             	add    $0x10,%esp
    235f:	85 c0                	test   %eax,%eax
    2361:	79 17                	jns    237a <subdir+0x72d>
    printf(1, "unlink dd failed\n");
    2363:	83 ec 08             	sub    $0x8,%esp
    2366:	68 cf 4d 00 00       	push   $0x4dcf
    236b:	6a 01                	push   $0x1
    236d:	e8 c6 19 00 00       	call   3d38 <printf>
    2372:	83 c4 10             	add    $0x10,%esp
    exit();
    2375:	e8 52 18 00 00       	call   3bcc <exit>
  }

  printf(1, "subdir ok\n");
    237a:	83 ec 08             	sub    $0x8,%esp
    237d:	68 e1 4d 00 00       	push   $0x4de1
    2382:	6a 01                	push   $0x1
    2384:	e8 af 19 00 00       	call   3d38 <printf>
    2389:	83 c4 10             	add    $0x10,%esp
}
    238c:	c9                   	leave  
    238d:	c3                   	ret    

0000238e <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    238e:	55                   	push   %ebp
    238f:	89 e5                	mov    %esp,%ebp
    2391:	83 ec 18             	sub    $0x18,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");
    2394:	83 ec 08             	sub    $0x8,%esp
    2397:	68 ec 4d 00 00       	push   $0x4dec
    239c:	6a 01                	push   $0x1
    239e:	e8 95 19 00 00       	call   3d38 <printf>
    23a3:	83 c4 10             	add    $0x10,%esp

  unlink("bigwrite");
    23a6:	83 ec 0c             	sub    $0xc,%esp
    23a9:	68 fb 4d 00 00       	push   $0x4dfb
    23ae:	e8 69 18 00 00       	call   3c1c <unlink>
    23b3:	83 c4 10             	add    $0x10,%esp
  for(sz = 499; sz < 12*512; sz += 471){
    23b6:	c7 45 f4 f3 01 00 00 	movl   $0x1f3,-0xc(%ebp)
    23bd:	e9 a7 00 00 00       	jmp    2469 <bigwrite+0xdb>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    23c2:	83 ec 08             	sub    $0x8,%esp
    23c5:	68 02 02 00 00       	push   $0x202
    23ca:	68 fb 4d 00 00       	push   $0x4dfb
    23cf:	e8 38 18 00 00       	call   3c0c <open>
    23d4:	83 c4 10             	add    $0x10,%esp
    23d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fd < 0){
    23da:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    23de:	79 17                	jns    23f7 <bigwrite+0x69>
      printf(1, "cannot create bigwrite\n");
    23e0:	83 ec 08             	sub    $0x8,%esp
    23e3:	68 04 4e 00 00       	push   $0x4e04
    23e8:	6a 01                	push   $0x1
    23ea:	e8 49 19 00 00       	call   3d38 <printf>
    23ef:	83 c4 10             	add    $0x10,%esp
      exit();
    23f2:	e8 d5 17 00 00       	call   3bcc <exit>
    }
    int i;
    for(i = 0; i < 2; i++){
    23f7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    23fe:	eb 3e                	jmp    243e <bigwrite+0xb0>
      int cc = write(fd, buf, sz);
    2400:	83 ec 04             	sub    $0x4,%esp
    2403:	ff 75 f4             	pushl  -0xc(%ebp)
    2406:	68 a0 7f 00 00       	push   $0x7fa0
    240b:	ff 75 ec             	pushl  -0x14(%ebp)
    240e:	e8 d9 17 00 00       	call   3bec <write>
    2413:	83 c4 10             	add    $0x10,%esp
    2416:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(cc != sz){
    2419:	8b 45 e8             	mov    -0x18(%ebp),%eax
    241c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    241f:	74 1a                	je     243b <bigwrite+0xad>
        printf(1, "write(%d) ret %d\n", sz, cc);
    2421:	ff 75 e8             	pushl  -0x18(%ebp)
    2424:	ff 75 f4             	pushl  -0xc(%ebp)
    2427:	68 1c 4e 00 00       	push   $0x4e1c
    242c:	6a 01                	push   $0x1
    242e:	e8 05 19 00 00       	call   3d38 <printf>
    2433:	83 c4 10             	add    $0x10,%esp
        exit();
    2436:	e8 91 17 00 00       	call   3bcc <exit>
    if(fd < 0){
      printf(1, "cannot create bigwrite\n");
      exit();
    }
    int i;
    for(i = 0; i < 2; i++){
    243b:	ff 45 f0             	incl   -0x10(%ebp)
    243e:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
    2442:	7e bc                	jle    2400 <bigwrite+0x72>
      if(cc != sz){
        printf(1, "write(%d) ret %d\n", sz, cc);
        exit();
      }
    }
    close(fd);
    2444:	83 ec 0c             	sub    $0xc,%esp
    2447:	ff 75 ec             	pushl  -0x14(%ebp)
    244a:	e8 a5 17 00 00       	call   3bf4 <close>
    244f:	83 c4 10             	add    $0x10,%esp
    unlink("bigwrite");
    2452:	83 ec 0c             	sub    $0xc,%esp
    2455:	68 fb 4d 00 00       	push   $0x4dfb
    245a:	e8 bd 17 00 00       	call   3c1c <unlink>
    245f:	83 c4 10             	add    $0x10,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");

  unlink("bigwrite");
  for(sz = 499; sz < 12*512; sz += 471){
    2462:	81 45 f4 d7 01 00 00 	addl   $0x1d7,-0xc(%ebp)
    2469:	81 7d f4 ff 17 00 00 	cmpl   $0x17ff,-0xc(%ebp)
    2470:	0f 8e 4c ff ff ff    	jle    23c2 <bigwrite+0x34>
    }
    close(fd);
    unlink("bigwrite");
  }

  printf(1, "bigwrite ok\n");
    2476:	83 ec 08             	sub    $0x8,%esp
    2479:	68 2e 4e 00 00       	push   $0x4e2e
    247e:	6a 01                	push   $0x1
    2480:	e8 b3 18 00 00       	call   3d38 <printf>
    2485:	83 c4 10             	add    $0x10,%esp
}
    2488:	c9                   	leave  
    2489:	c3                   	ret    

0000248a <bigfile>:

void
bigfile(void)
{
    248a:	55                   	push   %ebp
    248b:	89 e5                	mov    %esp,%ebp
    248d:	83 ec 18             	sub    $0x18,%esp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
    2490:	83 ec 08             	sub    $0x8,%esp
    2493:	68 3b 4e 00 00       	push   $0x4e3b
    2498:	6a 01                	push   $0x1
    249a:	e8 99 18 00 00       	call   3d38 <printf>
    249f:	83 c4 10             	add    $0x10,%esp

  unlink("bigfile");
    24a2:	83 ec 0c             	sub    $0xc,%esp
    24a5:	68 49 4e 00 00       	push   $0x4e49
    24aa:	e8 6d 17 00 00       	call   3c1c <unlink>
    24af:	83 c4 10             	add    $0x10,%esp
  fd = open("bigfile", O_CREATE | O_RDWR);
    24b2:	83 ec 08             	sub    $0x8,%esp
    24b5:	68 02 02 00 00       	push   $0x202
    24ba:	68 49 4e 00 00       	push   $0x4e49
    24bf:	e8 48 17 00 00       	call   3c0c <open>
    24c4:	83 c4 10             	add    $0x10,%esp
    24c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    24ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    24ce:	79 17                	jns    24e7 <bigfile+0x5d>
    printf(1, "cannot create bigfile");
    24d0:	83 ec 08             	sub    $0x8,%esp
    24d3:	68 51 4e 00 00       	push   $0x4e51
    24d8:	6a 01                	push   $0x1
    24da:	e8 59 18 00 00       	call   3d38 <printf>
    24df:	83 c4 10             	add    $0x10,%esp
    exit();
    24e2:	e8 e5 16 00 00       	call   3bcc <exit>
  }
  for(i = 0; i < 20; i++){
    24e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    24ee:	eb 51                	jmp    2541 <bigfile+0xb7>
    memset(buf, i, 600);
    24f0:	83 ec 04             	sub    $0x4,%esp
    24f3:	68 58 02 00 00       	push   $0x258
    24f8:	ff 75 f4             	pushl  -0xc(%ebp)
    24fb:	68 a0 7f 00 00       	push   $0x7fa0
    2500:	e8 45 15 00 00       	call   3a4a <memset>
    2505:	83 c4 10             	add    $0x10,%esp
    if(write(fd, buf, 600) != 600){
    2508:	83 ec 04             	sub    $0x4,%esp
    250b:	68 58 02 00 00       	push   $0x258
    2510:	68 a0 7f 00 00       	push   $0x7fa0
    2515:	ff 75 ec             	pushl  -0x14(%ebp)
    2518:	e8 cf 16 00 00       	call   3bec <write>
    251d:	83 c4 10             	add    $0x10,%esp
    2520:	3d 58 02 00 00       	cmp    $0x258,%eax
    2525:	74 17                	je     253e <bigfile+0xb4>
      printf(1, "write bigfile failed\n");
    2527:	83 ec 08             	sub    $0x8,%esp
    252a:	68 67 4e 00 00       	push   $0x4e67
    252f:	6a 01                	push   $0x1
    2531:	e8 02 18 00 00       	call   3d38 <printf>
    2536:	83 c4 10             	add    $0x10,%esp
      exit();
    2539:	e8 8e 16 00 00       	call   3bcc <exit>
  fd = open("bigfile", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "cannot create bigfile");
    exit();
  }
  for(i = 0; i < 20; i++){
    253e:	ff 45 f4             	incl   -0xc(%ebp)
    2541:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    2545:	7e a9                	jle    24f0 <bigfile+0x66>
    if(write(fd, buf, 600) != 600){
      printf(1, "write bigfile failed\n");
      exit();
    }
  }
  close(fd);
    2547:	83 ec 0c             	sub    $0xc,%esp
    254a:	ff 75 ec             	pushl  -0x14(%ebp)
    254d:	e8 a2 16 00 00       	call   3bf4 <close>
    2552:	83 c4 10             	add    $0x10,%esp

  fd = open("bigfile", 0);
    2555:	83 ec 08             	sub    $0x8,%esp
    2558:	6a 00                	push   $0x0
    255a:	68 49 4e 00 00       	push   $0x4e49
    255f:	e8 a8 16 00 00       	call   3c0c <open>
    2564:	83 c4 10             	add    $0x10,%esp
    2567:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    256a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    256e:	79 17                	jns    2587 <bigfile+0xfd>
    printf(1, "cannot open bigfile\n");
    2570:	83 ec 08             	sub    $0x8,%esp
    2573:	68 7d 4e 00 00       	push   $0x4e7d
    2578:	6a 01                	push   $0x1
    257a:	e8 b9 17 00 00       	call   3d38 <printf>
    257f:	83 c4 10             	add    $0x10,%esp
    exit();
    2582:	e8 45 16 00 00       	call   3bcc <exit>
  }
  total = 0;
    2587:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(i = 0; ; i++){
    258e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    cc = read(fd, buf, 300);
    2595:	83 ec 04             	sub    $0x4,%esp
    2598:	68 2c 01 00 00       	push   $0x12c
    259d:	68 a0 7f 00 00       	push   $0x7fa0
    25a2:	ff 75 ec             	pushl  -0x14(%ebp)
    25a5:	e8 3a 16 00 00       	call   3be4 <read>
    25aa:	83 c4 10             	add    $0x10,%esp
    25ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(cc < 0){
    25b0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    25b4:	79 17                	jns    25cd <bigfile+0x143>
      printf(1, "read bigfile failed\n");
    25b6:	83 ec 08             	sub    $0x8,%esp
    25b9:	68 92 4e 00 00       	push   $0x4e92
    25be:	6a 01                	push   $0x1
    25c0:	e8 73 17 00 00       	call   3d38 <printf>
    25c5:	83 c4 10             	add    $0x10,%esp
      exit();
    25c8:	e8 ff 15 00 00       	call   3bcc <exit>
    }
    if(cc == 0)
    25cd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    25d1:	75 1c                	jne    25ef <bigfile+0x165>
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
  }
  close(fd);
    25d3:	83 ec 0c             	sub    $0xc,%esp
    25d6:	ff 75 ec             	pushl  -0x14(%ebp)
    25d9:	e8 16 16 00 00       	call   3bf4 <close>
    25de:	83 c4 10             	add    $0x10,%esp
  if(total != 20*600){
    25e1:	81 7d f0 e0 2e 00 00 	cmpl   $0x2ee0,-0x10(%ebp)
    25e8:	75 7c                	jne    2666 <bigfile+0x1dc>
    25ea:	e9 8e 00 00 00       	jmp    267d <bigfile+0x1f3>
      printf(1, "read bigfile failed\n");
      exit();
    }
    if(cc == 0)
      break;
    if(cc != 300){
    25ef:	81 7d e8 2c 01 00 00 	cmpl   $0x12c,-0x18(%ebp)
    25f6:	74 17                	je     260f <bigfile+0x185>
      printf(1, "short read bigfile\n");
    25f8:	83 ec 08             	sub    $0x8,%esp
    25fb:	68 a7 4e 00 00       	push   $0x4ea7
    2600:	6a 01                	push   $0x1
    2602:	e8 31 17 00 00       	call   3d38 <printf>
    2607:	83 c4 10             	add    $0x10,%esp
      exit();
    260a:	e8 bd 15 00 00       	call   3bcc <exit>
    }
    if(buf[0] != i/2 || buf[299] != i/2){
    260f:	a0 a0 7f 00 00       	mov    0x7fa0,%al
    2614:	0f be d0             	movsbl %al,%edx
    2617:	8b 45 f4             	mov    -0xc(%ebp),%eax
    261a:	89 c1                	mov    %eax,%ecx
    261c:	c1 e9 1f             	shr    $0x1f,%ecx
    261f:	8d 04 01             	lea    (%ecx,%eax,1),%eax
    2622:	d1 f8                	sar    %eax
    2624:	39 c2                	cmp    %eax,%edx
    2626:	75 19                	jne    2641 <bigfile+0x1b7>
    2628:	a0 cb 80 00 00       	mov    0x80cb,%al
    262d:	0f be d0             	movsbl %al,%edx
    2630:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2633:	89 c1                	mov    %eax,%ecx
    2635:	c1 e9 1f             	shr    $0x1f,%ecx
    2638:	8d 04 01             	lea    (%ecx,%eax,1),%eax
    263b:	d1 f8                	sar    %eax
    263d:	39 c2                	cmp    %eax,%edx
    263f:	74 17                	je     2658 <bigfile+0x1ce>
      printf(1, "read bigfile wrong data\n");
    2641:	83 ec 08             	sub    $0x8,%esp
    2644:	68 bb 4e 00 00       	push   $0x4ebb
    2649:	6a 01                	push   $0x1
    264b:	e8 e8 16 00 00       	call   3d38 <printf>
    2650:	83 c4 10             	add    $0x10,%esp
      exit();
    2653:	e8 74 15 00 00       	call   3bcc <exit>
    }
    total += cc;
    2658:	8b 45 e8             	mov    -0x18(%ebp),%eax
    265b:	01 45 f0             	add    %eax,-0x10(%ebp)
  if(fd < 0){
    printf(1, "cannot open bigfile\n");
    exit();
  }
  total = 0;
  for(i = 0; ; i++){
    265e:	ff 45 f4             	incl   -0xc(%ebp)
    if(buf[0] != i/2 || buf[299] != i/2){
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
  }
    2661:	e9 2f ff ff ff       	jmp    2595 <bigfile+0x10b>
  close(fd);
  if(total != 20*600){
    printf(1, "read bigfile wrong total\n");
    2666:	83 ec 08             	sub    $0x8,%esp
    2669:	68 d4 4e 00 00       	push   $0x4ed4
    266e:	6a 01                	push   $0x1
    2670:	e8 c3 16 00 00       	call   3d38 <printf>
    2675:	83 c4 10             	add    $0x10,%esp
    exit();
    2678:	e8 4f 15 00 00       	call   3bcc <exit>
  }
  unlink("bigfile");
    267d:	83 ec 0c             	sub    $0xc,%esp
    2680:	68 49 4e 00 00       	push   $0x4e49
    2685:	e8 92 15 00 00       	call   3c1c <unlink>
    268a:	83 c4 10             	add    $0x10,%esp

  printf(1, "bigfile test ok\n");
    268d:	83 ec 08             	sub    $0x8,%esp
    2690:	68 ee 4e 00 00       	push   $0x4eee
    2695:	6a 01                	push   $0x1
    2697:	e8 9c 16 00 00       	call   3d38 <printf>
    269c:	83 c4 10             	add    $0x10,%esp
}
    269f:	c9                   	leave  
    26a0:	c3                   	ret    

000026a1 <fourteen>:

void
fourteen(void)
{
    26a1:	55                   	push   %ebp
    26a2:	89 e5                	mov    %esp,%ebp
    26a4:	83 ec 18             	sub    $0x18,%esp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
    26a7:	83 ec 08             	sub    $0x8,%esp
    26aa:	68 ff 4e 00 00       	push   $0x4eff
    26af:	6a 01                	push   $0x1
    26b1:	e8 82 16 00 00       	call   3d38 <printf>
    26b6:	83 c4 10             	add    $0x10,%esp

  if(mkdir("12345678901234") != 0){
    26b9:	83 ec 0c             	sub    $0xc,%esp
    26bc:	68 0e 4f 00 00       	push   $0x4f0e
    26c1:	e8 6e 15 00 00       	call   3c34 <mkdir>
    26c6:	83 c4 10             	add    $0x10,%esp
    26c9:	85 c0                	test   %eax,%eax
    26cb:	74 17                	je     26e4 <fourteen+0x43>
    printf(1, "mkdir 12345678901234 failed\n");
    26cd:	83 ec 08             	sub    $0x8,%esp
    26d0:	68 1d 4f 00 00       	push   $0x4f1d
    26d5:	6a 01                	push   $0x1
    26d7:	e8 5c 16 00 00       	call   3d38 <printf>
    26dc:	83 c4 10             	add    $0x10,%esp
    exit();
    26df:	e8 e8 14 00 00       	call   3bcc <exit>
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    26e4:	83 ec 0c             	sub    $0xc,%esp
    26e7:	68 3c 4f 00 00       	push   $0x4f3c
    26ec:	e8 43 15 00 00       	call   3c34 <mkdir>
    26f1:	83 c4 10             	add    $0x10,%esp
    26f4:	85 c0                	test   %eax,%eax
    26f6:	74 17                	je     270f <fourteen+0x6e>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    26f8:	83 ec 08             	sub    $0x8,%esp
    26fb:	68 5c 4f 00 00       	push   $0x4f5c
    2700:	6a 01                	push   $0x1
    2702:	e8 31 16 00 00       	call   3d38 <printf>
    2707:	83 c4 10             	add    $0x10,%esp
    exit();
    270a:	e8 bd 14 00 00       	call   3bcc <exit>
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    270f:	83 ec 08             	sub    $0x8,%esp
    2712:	68 00 02 00 00       	push   $0x200
    2717:	68 8c 4f 00 00       	push   $0x4f8c
    271c:	e8 eb 14 00 00       	call   3c0c <open>
    2721:	83 c4 10             	add    $0x10,%esp
    2724:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2727:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    272b:	79 17                	jns    2744 <fourteen+0xa3>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    272d:	83 ec 08             	sub    $0x8,%esp
    2730:	68 bc 4f 00 00       	push   $0x4fbc
    2735:	6a 01                	push   $0x1
    2737:	e8 fc 15 00 00       	call   3d38 <printf>
    273c:	83 c4 10             	add    $0x10,%esp
    exit();
    273f:	e8 88 14 00 00       	call   3bcc <exit>
  }
  close(fd);
    2744:	83 ec 0c             	sub    $0xc,%esp
    2747:	ff 75 f4             	pushl  -0xc(%ebp)
    274a:	e8 a5 14 00 00       	call   3bf4 <close>
    274f:	83 c4 10             	add    $0x10,%esp
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2752:	83 ec 08             	sub    $0x8,%esp
    2755:	6a 00                	push   $0x0
    2757:	68 fc 4f 00 00       	push   $0x4ffc
    275c:	e8 ab 14 00 00       	call   3c0c <open>
    2761:	83 c4 10             	add    $0x10,%esp
    2764:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2767:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    276b:	79 17                	jns    2784 <fourteen+0xe3>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    276d:	83 ec 08             	sub    $0x8,%esp
    2770:	68 2c 50 00 00       	push   $0x502c
    2775:	6a 01                	push   $0x1
    2777:	e8 bc 15 00 00       	call   3d38 <printf>
    277c:	83 c4 10             	add    $0x10,%esp
    exit();
    277f:	e8 48 14 00 00       	call   3bcc <exit>
  }
  close(fd);
    2784:	83 ec 0c             	sub    $0xc,%esp
    2787:	ff 75 f4             	pushl  -0xc(%ebp)
    278a:	e8 65 14 00 00       	call   3bf4 <close>
    278f:	83 c4 10             	add    $0x10,%esp

  if(mkdir("12345678901234/12345678901234") == 0){
    2792:	83 ec 0c             	sub    $0xc,%esp
    2795:	68 66 50 00 00       	push   $0x5066
    279a:	e8 95 14 00 00       	call   3c34 <mkdir>
    279f:	83 c4 10             	add    $0x10,%esp
    27a2:	85 c0                	test   %eax,%eax
    27a4:	75 17                	jne    27bd <fourteen+0x11c>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    27a6:	83 ec 08             	sub    $0x8,%esp
    27a9:	68 84 50 00 00       	push   $0x5084
    27ae:	6a 01                	push   $0x1
    27b0:	e8 83 15 00 00       	call   3d38 <printf>
    27b5:	83 c4 10             	add    $0x10,%esp
    exit();
    27b8:	e8 0f 14 00 00       	call   3bcc <exit>
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    27bd:	83 ec 0c             	sub    $0xc,%esp
    27c0:	68 b4 50 00 00       	push   $0x50b4
    27c5:	e8 6a 14 00 00       	call   3c34 <mkdir>
    27ca:	83 c4 10             	add    $0x10,%esp
    27cd:	85 c0                	test   %eax,%eax
    27cf:	75 17                	jne    27e8 <fourteen+0x147>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    27d1:	83 ec 08             	sub    $0x8,%esp
    27d4:	68 d4 50 00 00       	push   $0x50d4
    27d9:	6a 01                	push   $0x1
    27db:	e8 58 15 00 00       	call   3d38 <printf>
    27e0:	83 c4 10             	add    $0x10,%esp
    exit();
    27e3:	e8 e4 13 00 00       	call   3bcc <exit>
  }

  printf(1, "fourteen ok\n");
    27e8:	83 ec 08             	sub    $0x8,%esp
    27eb:	68 05 51 00 00       	push   $0x5105
    27f0:	6a 01                	push   $0x1
    27f2:	e8 41 15 00 00       	call   3d38 <printf>
    27f7:	83 c4 10             	add    $0x10,%esp
}
    27fa:	c9                   	leave  
    27fb:	c3                   	ret    

000027fc <rmdot>:

void
rmdot(void)
{
    27fc:	55                   	push   %ebp
    27fd:	89 e5                	mov    %esp,%ebp
    27ff:	83 ec 08             	sub    $0x8,%esp
  printf(1, "rmdot test\n");
    2802:	83 ec 08             	sub    $0x8,%esp
    2805:	68 12 51 00 00       	push   $0x5112
    280a:	6a 01                	push   $0x1
    280c:	e8 27 15 00 00       	call   3d38 <printf>
    2811:	83 c4 10             	add    $0x10,%esp
  if(mkdir("dots") != 0){
    2814:	83 ec 0c             	sub    $0xc,%esp
    2817:	68 1e 51 00 00       	push   $0x511e
    281c:	e8 13 14 00 00       	call   3c34 <mkdir>
    2821:	83 c4 10             	add    $0x10,%esp
    2824:	85 c0                	test   %eax,%eax
    2826:	74 17                	je     283f <rmdot+0x43>
    printf(1, "mkdir dots failed\n");
    2828:	83 ec 08             	sub    $0x8,%esp
    282b:	68 23 51 00 00       	push   $0x5123
    2830:	6a 01                	push   $0x1
    2832:	e8 01 15 00 00       	call   3d38 <printf>
    2837:	83 c4 10             	add    $0x10,%esp
    exit();
    283a:	e8 8d 13 00 00       	call   3bcc <exit>
  }
  if(chdir("dots") != 0){
    283f:	83 ec 0c             	sub    $0xc,%esp
    2842:	68 1e 51 00 00       	push   $0x511e
    2847:	e8 f0 13 00 00       	call   3c3c <chdir>
    284c:	83 c4 10             	add    $0x10,%esp
    284f:	85 c0                	test   %eax,%eax
    2851:	74 17                	je     286a <rmdot+0x6e>
    printf(1, "chdir dots failed\n");
    2853:	83 ec 08             	sub    $0x8,%esp
    2856:	68 36 51 00 00       	push   $0x5136
    285b:	6a 01                	push   $0x1
    285d:	e8 d6 14 00 00       	call   3d38 <printf>
    2862:	83 c4 10             	add    $0x10,%esp
    exit();
    2865:	e8 62 13 00 00       	call   3bcc <exit>
  }
  if(unlink(".") == 0){
    286a:	83 ec 0c             	sub    $0xc,%esp
    286d:	68 4f 48 00 00       	push   $0x484f
    2872:	e8 a5 13 00 00       	call   3c1c <unlink>
    2877:	83 c4 10             	add    $0x10,%esp
    287a:	85 c0                	test   %eax,%eax
    287c:	75 17                	jne    2895 <rmdot+0x99>
    printf(1, "rm . worked!\n");
    287e:	83 ec 08             	sub    $0x8,%esp
    2881:	68 49 51 00 00       	push   $0x5149
    2886:	6a 01                	push   $0x1
    2888:	e8 ab 14 00 00       	call   3d38 <printf>
    288d:	83 c4 10             	add    $0x10,%esp
    exit();
    2890:	e8 37 13 00 00       	call   3bcc <exit>
  }
  if(unlink("..") == 0){
    2895:	83 ec 0c             	sub    $0xc,%esp
    2898:	68 dc 43 00 00       	push   $0x43dc
    289d:	e8 7a 13 00 00       	call   3c1c <unlink>
    28a2:	83 c4 10             	add    $0x10,%esp
    28a5:	85 c0                	test   %eax,%eax
    28a7:	75 17                	jne    28c0 <rmdot+0xc4>
    printf(1, "rm .. worked!\n");
    28a9:	83 ec 08             	sub    $0x8,%esp
    28ac:	68 57 51 00 00       	push   $0x5157
    28b1:	6a 01                	push   $0x1
    28b3:	e8 80 14 00 00       	call   3d38 <printf>
    28b8:	83 c4 10             	add    $0x10,%esp
    exit();
    28bb:	e8 0c 13 00 00       	call   3bcc <exit>
  }
  if(chdir("/") != 0){
    28c0:	83 ec 0c             	sub    $0xc,%esp
    28c3:	68 66 51 00 00       	push   $0x5166
    28c8:	e8 6f 13 00 00       	call   3c3c <chdir>
    28cd:	83 c4 10             	add    $0x10,%esp
    28d0:	85 c0                	test   %eax,%eax
    28d2:	74 17                	je     28eb <rmdot+0xef>
    printf(1, "chdir / failed\n");
    28d4:	83 ec 08             	sub    $0x8,%esp
    28d7:	68 68 51 00 00       	push   $0x5168
    28dc:	6a 01                	push   $0x1
    28de:	e8 55 14 00 00       	call   3d38 <printf>
    28e3:	83 c4 10             	add    $0x10,%esp
    exit();
    28e6:	e8 e1 12 00 00       	call   3bcc <exit>
  }
  if(unlink("dots/.") == 0){
    28eb:	83 ec 0c             	sub    $0xc,%esp
    28ee:	68 78 51 00 00       	push   $0x5178
    28f3:	e8 24 13 00 00       	call   3c1c <unlink>
    28f8:	83 c4 10             	add    $0x10,%esp
    28fb:	85 c0                	test   %eax,%eax
    28fd:	75 17                	jne    2916 <rmdot+0x11a>
    printf(1, "unlink dots/. worked!\n");
    28ff:	83 ec 08             	sub    $0x8,%esp
    2902:	68 7f 51 00 00       	push   $0x517f
    2907:	6a 01                	push   $0x1
    2909:	e8 2a 14 00 00       	call   3d38 <printf>
    290e:	83 c4 10             	add    $0x10,%esp
    exit();
    2911:	e8 b6 12 00 00       	call   3bcc <exit>
  }
  if(unlink("dots/..") == 0){
    2916:	83 ec 0c             	sub    $0xc,%esp
    2919:	68 96 51 00 00       	push   $0x5196
    291e:	e8 f9 12 00 00       	call   3c1c <unlink>
    2923:	83 c4 10             	add    $0x10,%esp
    2926:	85 c0                	test   %eax,%eax
    2928:	75 17                	jne    2941 <rmdot+0x145>
    printf(1, "unlink dots/.. worked!\n");
    292a:	83 ec 08             	sub    $0x8,%esp
    292d:	68 9e 51 00 00       	push   $0x519e
    2932:	6a 01                	push   $0x1
    2934:	e8 ff 13 00 00       	call   3d38 <printf>
    2939:	83 c4 10             	add    $0x10,%esp
    exit();
    293c:	e8 8b 12 00 00       	call   3bcc <exit>
  }
  if(unlink("dots") != 0){
    2941:	83 ec 0c             	sub    $0xc,%esp
    2944:	68 1e 51 00 00       	push   $0x511e
    2949:	e8 ce 12 00 00       	call   3c1c <unlink>
    294e:	83 c4 10             	add    $0x10,%esp
    2951:	85 c0                	test   %eax,%eax
    2953:	74 17                	je     296c <rmdot+0x170>
    printf(1, "unlink dots failed!\n");
    2955:	83 ec 08             	sub    $0x8,%esp
    2958:	68 b6 51 00 00       	push   $0x51b6
    295d:	6a 01                	push   $0x1
    295f:	e8 d4 13 00 00       	call   3d38 <printf>
    2964:	83 c4 10             	add    $0x10,%esp
    exit();
    2967:	e8 60 12 00 00       	call   3bcc <exit>
  }
  printf(1, "rmdot ok\n");
    296c:	83 ec 08             	sub    $0x8,%esp
    296f:	68 cb 51 00 00       	push   $0x51cb
    2974:	6a 01                	push   $0x1
    2976:	e8 bd 13 00 00       	call   3d38 <printf>
    297b:	83 c4 10             	add    $0x10,%esp
}
    297e:	c9                   	leave  
    297f:	c3                   	ret    

00002980 <dirfile>:

void
dirfile(void)
{
    2980:	55                   	push   %ebp
    2981:	89 e5                	mov    %esp,%ebp
    2983:	83 ec 18             	sub    $0x18,%esp
  int fd;

  printf(1, "dir vs file\n");
    2986:	83 ec 08             	sub    $0x8,%esp
    2989:	68 d5 51 00 00       	push   $0x51d5
    298e:	6a 01                	push   $0x1
    2990:	e8 a3 13 00 00       	call   3d38 <printf>
    2995:	83 c4 10             	add    $0x10,%esp

  fd = open("dirfile", O_CREATE);
    2998:	83 ec 08             	sub    $0x8,%esp
    299b:	68 00 02 00 00       	push   $0x200
    29a0:	68 e2 51 00 00       	push   $0x51e2
    29a5:	e8 62 12 00 00       	call   3c0c <open>
    29aa:	83 c4 10             	add    $0x10,%esp
    29ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    29b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    29b4:	79 17                	jns    29cd <dirfile+0x4d>
    printf(1, "create dirfile failed\n");
    29b6:	83 ec 08             	sub    $0x8,%esp
    29b9:	68 ea 51 00 00       	push   $0x51ea
    29be:	6a 01                	push   $0x1
    29c0:	e8 73 13 00 00       	call   3d38 <printf>
    29c5:	83 c4 10             	add    $0x10,%esp
    exit();
    29c8:	e8 ff 11 00 00       	call   3bcc <exit>
  }
  close(fd);
    29cd:	83 ec 0c             	sub    $0xc,%esp
    29d0:	ff 75 f4             	pushl  -0xc(%ebp)
    29d3:	e8 1c 12 00 00       	call   3bf4 <close>
    29d8:	83 c4 10             	add    $0x10,%esp
  if(chdir("dirfile") == 0){
    29db:	83 ec 0c             	sub    $0xc,%esp
    29de:	68 e2 51 00 00       	push   $0x51e2
    29e3:	e8 54 12 00 00       	call   3c3c <chdir>
    29e8:	83 c4 10             	add    $0x10,%esp
    29eb:	85 c0                	test   %eax,%eax
    29ed:	75 17                	jne    2a06 <dirfile+0x86>
    printf(1, "chdir dirfile succeeded!\n");
    29ef:	83 ec 08             	sub    $0x8,%esp
    29f2:	68 01 52 00 00       	push   $0x5201
    29f7:	6a 01                	push   $0x1
    29f9:	e8 3a 13 00 00       	call   3d38 <printf>
    29fe:	83 c4 10             	add    $0x10,%esp
    exit();
    2a01:	e8 c6 11 00 00       	call   3bcc <exit>
  }
  fd = open("dirfile/xx", 0);
    2a06:	83 ec 08             	sub    $0x8,%esp
    2a09:	6a 00                	push   $0x0
    2a0b:	68 1b 52 00 00       	push   $0x521b
    2a10:	e8 f7 11 00 00       	call   3c0c <open>
    2a15:	83 c4 10             	add    $0x10,%esp
    2a18:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2a1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2a1f:	78 17                	js     2a38 <dirfile+0xb8>
    printf(1, "create dirfile/xx succeeded!\n");
    2a21:	83 ec 08             	sub    $0x8,%esp
    2a24:	68 26 52 00 00       	push   $0x5226
    2a29:	6a 01                	push   $0x1
    2a2b:	e8 08 13 00 00       	call   3d38 <printf>
    2a30:	83 c4 10             	add    $0x10,%esp
    exit();
    2a33:	e8 94 11 00 00       	call   3bcc <exit>
  }
  fd = open("dirfile/xx", O_CREATE);
    2a38:	83 ec 08             	sub    $0x8,%esp
    2a3b:	68 00 02 00 00       	push   $0x200
    2a40:	68 1b 52 00 00       	push   $0x521b
    2a45:	e8 c2 11 00 00       	call   3c0c <open>
    2a4a:	83 c4 10             	add    $0x10,%esp
    2a4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2a50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2a54:	78 17                	js     2a6d <dirfile+0xed>
    printf(1, "create dirfile/xx succeeded!\n");
    2a56:	83 ec 08             	sub    $0x8,%esp
    2a59:	68 26 52 00 00       	push   $0x5226
    2a5e:	6a 01                	push   $0x1
    2a60:	e8 d3 12 00 00       	call   3d38 <printf>
    2a65:	83 c4 10             	add    $0x10,%esp
    exit();
    2a68:	e8 5f 11 00 00       	call   3bcc <exit>
  }
  if(mkdir("dirfile/xx") == 0){
    2a6d:	83 ec 0c             	sub    $0xc,%esp
    2a70:	68 1b 52 00 00       	push   $0x521b
    2a75:	e8 ba 11 00 00       	call   3c34 <mkdir>
    2a7a:	83 c4 10             	add    $0x10,%esp
    2a7d:	85 c0                	test   %eax,%eax
    2a7f:	75 17                	jne    2a98 <dirfile+0x118>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    2a81:	83 ec 08             	sub    $0x8,%esp
    2a84:	68 44 52 00 00       	push   $0x5244
    2a89:	6a 01                	push   $0x1
    2a8b:	e8 a8 12 00 00       	call   3d38 <printf>
    2a90:	83 c4 10             	add    $0x10,%esp
    exit();
    2a93:	e8 34 11 00 00       	call   3bcc <exit>
  }
  if(unlink("dirfile/xx") == 0){
    2a98:	83 ec 0c             	sub    $0xc,%esp
    2a9b:	68 1b 52 00 00       	push   $0x521b
    2aa0:	e8 77 11 00 00       	call   3c1c <unlink>
    2aa5:	83 c4 10             	add    $0x10,%esp
    2aa8:	85 c0                	test   %eax,%eax
    2aaa:	75 17                	jne    2ac3 <dirfile+0x143>
    printf(1, "unlink dirfile/xx succeeded!\n");
    2aac:	83 ec 08             	sub    $0x8,%esp
    2aaf:	68 61 52 00 00       	push   $0x5261
    2ab4:	6a 01                	push   $0x1
    2ab6:	e8 7d 12 00 00       	call   3d38 <printf>
    2abb:	83 c4 10             	add    $0x10,%esp
    exit();
    2abe:	e8 09 11 00 00       	call   3bcc <exit>
  }
  if(link("README", "dirfile/xx") == 0){
    2ac3:	83 ec 08             	sub    $0x8,%esp
    2ac6:	68 1b 52 00 00       	push   $0x521b
    2acb:	68 7f 52 00 00       	push   $0x527f
    2ad0:	e8 57 11 00 00       	call   3c2c <link>
    2ad5:	83 c4 10             	add    $0x10,%esp
    2ad8:	85 c0                	test   %eax,%eax
    2ada:	75 17                	jne    2af3 <dirfile+0x173>
    printf(1, "link to dirfile/xx succeeded!\n");
    2adc:	83 ec 08             	sub    $0x8,%esp
    2adf:	68 88 52 00 00       	push   $0x5288
    2ae4:	6a 01                	push   $0x1
    2ae6:	e8 4d 12 00 00       	call   3d38 <printf>
    2aeb:	83 c4 10             	add    $0x10,%esp
    exit();
    2aee:	e8 d9 10 00 00       	call   3bcc <exit>
  }
  if(unlink("dirfile") != 0){
    2af3:	83 ec 0c             	sub    $0xc,%esp
    2af6:	68 e2 51 00 00       	push   $0x51e2
    2afb:	e8 1c 11 00 00       	call   3c1c <unlink>
    2b00:	83 c4 10             	add    $0x10,%esp
    2b03:	85 c0                	test   %eax,%eax
    2b05:	74 17                	je     2b1e <dirfile+0x19e>
    printf(1, "unlink dirfile failed!\n");
    2b07:	83 ec 08             	sub    $0x8,%esp
    2b0a:	68 a7 52 00 00       	push   $0x52a7
    2b0f:	6a 01                	push   $0x1
    2b11:	e8 22 12 00 00       	call   3d38 <printf>
    2b16:	83 c4 10             	add    $0x10,%esp
    exit();
    2b19:	e8 ae 10 00 00       	call   3bcc <exit>
  }

  fd = open(".", O_RDWR);
    2b1e:	83 ec 08             	sub    $0x8,%esp
    2b21:	6a 02                	push   $0x2
    2b23:	68 4f 48 00 00       	push   $0x484f
    2b28:	e8 df 10 00 00       	call   3c0c <open>
    2b2d:	83 c4 10             	add    $0x10,%esp
    2b30:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2b33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2b37:	78 17                	js     2b50 <dirfile+0x1d0>
    printf(1, "open . for writing succeeded!\n");
    2b39:	83 ec 08             	sub    $0x8,%esp
    2b3c:	68 c0 52 00 00       	push   $0x52c0
    2b41:	6a 01                	push   $0x1
    2b43:	e8 f0 11 00 00       	call   3d38 <printf>
    2b48:	83 c4 10             	add    $0x10,%esp
    exit();
    2b4b:	e8 7c 10 00 00       	call   3bcc <exit>
  }
  fd = open(".", 0);
    2b50:	83 ec 08             	sub    $0x8,%esp
    2b53:	6a 00                	push   $0x0
    2b55:	68 4f 48 00 00       	push   $0x484f
    2b5a:	e8 ad 10 00 00       	call   3c0c <open>
    2b5f:	83 c4 10             	add    $0x10,%esp
    2b62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(write(fd, "x", 1) > 0){
    2b65:	83 ec 04             	sub    $0x4,%esp
    2b68:	6a 01                	push   $0x1
    2b6a:	68 86 44 00 00       	push   $0x4486
    2b6f:	ff 75 f4             	pushl  -0xc(%ebp)
    2b72:	e8 75 10 00 00       	call   3bec <write>
    2b77:	83 c4 10             	add    $0x10,%esp
    2b7a:	85 c0                	test   %eax,%eax
    2b7c:	7e 17                	jle    2b95 <dirfile+0x215>
    printf(1, "write . succeeded!\n");
    2b7e:	83 ec 08             	sub    $0x8,%esp
    2b81:	68 df 52 00 00       	push   $0x52df
    2b86:	6a 01                	push   $0x1
    2b88:	e8 ab 11 00 00       	call   3d38 <printf>
    2b8d:	83 c4 10             	add    $0x10,%esp
    exit();
    2b90:	e8 37 10 00 00       	call   3bcc <exit>
  }
  close(fd);
    2b95:	83 ec 0c             	sub    $0xc,%esp
    2b98:	ff 75 f4             	pushl  -0xc(%ebp)
    2b9b:	e8 54 10 00 00       	call   3bf4 <close>
    2ba0:	83 c4 10             	add    $0x10,%esp

  printf(1, "dir vs file OK\n");
    2ba3:	83 ec 08             	sub    $0x8,%esp
    2ba6:	68 f3 52 00 00       	push   $0x52f3
    2bab:	6a 01                	push   $0x1
    2bad:	e8 86 11 00 00       	call   3d38 <printf>
    2bb2:	83 c4 10             	add    $0x10,%esp
}
    2bb5:	c9                   	leave  
    2bb6:	c3                   	ret    

00002bb7 <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    2bb7:	55                   	push   %ebp
    2bb8:	89 e5                	mov    %esp,%ebp
    2bba:	83 ec 18             	sub    $0x18,%esp
  int i, fd;

  printf(1, "empty file name\n");
    2bbd:	83 ec 08             	sub    $0x8,%esp
    2bc0:	68 03 53 00 00       	push   $0x5303
    2bc5:	6a 01                	push   $0x1
    2bc7:	e8 6c 11 00 00       	call   3d38 <printf>
    2bcc:	83 c4 10             	add    $0x10,%esp

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    2bcf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2bd6:	e9 e6 00 00 00       	jmp    2cc1 <iref+0x10a>
    if(mkdir("irefd") != 0){
    2bdb:	83 ec 0c             	sub    $0xc,%esp
    2bde:	68 14 53 00 00       	push   $0x5314
    2be3:	e8 4c 10 00 00       	call   3c34 <mkdir>
    2be8:	83 c4 10             	add    $0x10,%esp
    2beb:	85 c0                	test   %eax,%eax
    2bed:	74 17                	je     2c06 <iref+0x4f>
      printf(1, "mkdir irefd failed\n");
    2bef:	83 ec 08             	sub    $0x8,%esp
    2bf2:	68 1a 53 00 00       	push   $0x531a
    2bf7:	6a 01                	push   $0x1
    2bf9:	e8 3a 11 00 00       	call   3d38 <printf>
    2bfe:	83 c4 10             	add    $0x10,%esp
      exit();
    2c01:	e8 c6 0f 00 00       	call   3bcc <exit>
    }
    if(chdir("irefd") != 0){
    2c06:	83 ec 0c             	sub    $0xc,%esp
    2c09:	68 14 53 00 00       	push   $0x5314
    2c0e:	e8 29 10 00 00       	call   3c3c <chdir>
    2c13:	83 c4 10             	add    $0x10,%esp
    2c16:	85 c0                	test   %eax,%eax
    2c18:	74 17                	je     2c31 <iref+0x7a>
      printf(1, "chdir irefd failed\n");
    2c1a:	83 ec 08             	sub    $0x8,%esp
    2c1d:	68 2e 53 00 00       	push   $0x532e
    2c22:	6a 01                	push   $0x1
    2c24:	e8 0f 11 00 00       	call   3d38 <printf>
    2c29:	83 c4 10             	add    $0x10,%esp
      exit();
    2c2c:	e8 9b 0f 00 00       	call   3bcc <exit>
    }

    mkdir("");
    2c31:	83 ec 0c             	sub    $0xc,%esp
    2c34:	68 42 53 00 00       	push   $0x5342
    2c39:	e8 f6 0f 00 00       	call   3c34 <mkdir>
    2c3e:	83 c4 10             	add    $0x10,%esp
    link("README", "");
    2c41:	83 ec 08             	sub    $0x8,%esp
    2c44:	68 42 53 00 00       	push   $0x5342
    2c49:	68 7f 52 00 00       	push   $0x527f
    2c4e:	e8 d9 0f 00 00       	call   3c2c <link>
    2c53:	83 c4 10             	add    $0x10,%esp
    fd = open("", O_CREATE);
    2c56:	83 ec 08             	sub    $0x8,%esp
    2c59:	68 00 02 00 00       	push   $0x200
    2c5e:	68 42 53 00 00       	push   $0x5342
    2c63:	e8 a4 0f 00 00       	call   3c0c <open>
    2c68:	83 c4 10             	add    $0x10,%esp
    2c6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    2c6e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2c72:	78 0e                	js     2c82 <iref+0xcb>
      close(fd);
    2c74:	83 ec 0c             	sub    $0xc,%esp
    2c77:	ff 75 f0             	pushl  -0x10(%ebp)
    2c7a:	e8 75 0f 00 00       	call   3bf4 <close>
    2c7f:	83 c4 10             	add    $0x10,%esp
    fd = open("xx", O_CREATE);
    2c82:	83 ec 08             	sub    $0x8,%esp
    2c85:	68 00 02 00 00       	push   $0x200
    2c8a:	68 43 53 00 00       	push   $0x5343
    2c8f:	e8 78 0f 00 00       	call   3c0c <open>
    2c94:	83 c4 10             	add    $0x10,%esp
    2c97:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    2c9a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2c9e:	78 0e                	js     2cae <iref+0xf7>
      close(fd);
    2ca0:	83 ec 0c             	sub    $0xc,%esp
    2ca3:	ff 75 f0             	pushl  -0x10(%ebp)
    2ca6:	e8 49 0f 00 00       	call   3bf4 <close>
    2cab:	83 c4 10             	add    $0x10,%esp
    unlink("xx");
    2cae:	83 ec 0c             	sub    $0xc,%esp
    2cb1:	68 43 53 00 00       	push   $0x5343
    2cb6:	e8 61 0f 00 00       	call   3c1c <unlink>
    2cbb:	83 c4 10             	add    $0x10,%esp
  int i, fd;

  printf(1, "empty file name\n");

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    2cbe:	ff 45 f4             	incl   -0xc(%ebp)
    2cc1:	83 7d f4 32          	cmpl   $0x32,-0xc(%ebp)
    2cc5:	0f 8e 10 ff ff ff    	jle    2bdb <iref+0x24>
    if(fd >= 0)
      close(fd);
    unlink("xx");
  }

  chdir("/");
    2ccb:	83 ec 0c             	sub    $0xc,%esp
    2cce:	68 66 51 00 00       	push   $0x5166
    2cd3:	e8 64 0f 00 00       	call   3c3c <chdir>
    2cd8:	83 c4 10             	add    $0x10,%esp
  printf(1, "empty file name OK\n");
    2cdb:	83 ec 08             	sub    $0x8,%esp
    2cde:	68 46 53 00 00       	push   $0x5346
    2ce3:	6a 01                	push   $0x1
    2ce5:	e8 4e 10 00 00       	call   3d38 <printf>
    2cea:	83 c4 10             	add    $0x10,%esp
}
    2ced:	c9                   	leave  
    2cee:	c3                   	ret    

00002cef <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    2cef:	55                   	push   %ebp
    2cf0:	89 e5                	mov    %esp,%ebp
    2cf2:	83 ec 18             	sub    $0x18,%esp
  int n, pid;

  printf(1, "fork test\n");
    2cf5:	83 ec 08             	sub    $0x8,%esp
    2cf8:	68 5a 53 00 00       	push   $0x535a
    2cfd:	6a 01                	push   $0x1
    2cff:	e8 34 10 00 00       	call   3d38 <printf>
    2d04:	83 c4 10             	add    $0x10,%esp

  for(n=0; n<1000; n++){
    2d07:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2d0e:	eb 1c                	jmp    2d2c <forktest+0x3d>
    pid = fork();
    2d10:	e8 af 0e 00 00       	call   3bc4 <fork>
    2d15:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
    2d18:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2d1c:	78 19                	js     2d37 <forktest+0x48>
      break;
    if(pid == 0)
    2d1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2d22:	75 05                	jne    2d29 <forktest+0x3a>
      exit();
    2d24:	e8 a3 0e 00 00       	call   3bcc <exit>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<1000; n++){
    2d29:	ff 45 f4             	incl   -0xc(%ebp)
    2d2c:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
    2d33:	7e db                	jle    2d10 <forktest+0x21>
    2d35:	eb 01                	jmp    2d38 <forktest+0x49>
    pid = fork();
    if(pid < 0)
      break;
    2d37:	90                   	nop
    if(pid == 0)
      exit();
  }
  
  if(n == 1000){
    2d38:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
    2d3f:	75 3a                	jne    2d7b <forktest+0x8c>
    printf(1, "fork claimed to work 1000 times!\n");
    2d41:	83 ec 08             	sub    $0x8,%esp
    2d44:	68 68 53 00 00       	push   $0x5368
    2d49:	6a 01                	push   $0x1
    2d4b:	e8 e8 0f 00 00       	call   3d38 <printf>
    2d50:	83 c4 10             	add    $0x10,%esp
    exit();
    2d53:	e8 74 0e 00 00       	call   3bcc <exit>
  }
  
  for(; n > 0; n--){
    if(wait() < 0){
    2d58:	e8 77 0e 00 00       	call   3bd4 <wait>
    2d5d:	85 c0                	test   %eax,%eax
    2d5f:	79 17                	jns    2d78 <forktest+0x89>
      printf(1, "wait stopped early\n");
    2d61:	83 ec 08             	sub    $0x8,%esp
    2d64:	68 8a 53 00 00       	push   $0x538a
    2d69:	6a 01                	push   $0x1
    2d6b:	e8 c8 0f 00 00       	call   3d38 <printf>
    2d70:	83 c4 10             	add    $0x10,%esp
      exit();
    2d73:	e8 54 0e 00 00       	call   3bcc <exit>
  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
    exit();
  }
  
  for(; n > 0; n--){
    2d78:	ff 4d f4             	decl   -0xc(%ebp)
    2d7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2d7f:	7f d7                	jg     2d58 <forktest+0x69>
      printf(1, "wait stopped early\n");
      exit();
    }
  }
  
  if(wait() != -1){
    2d81:	e8 4e 0e 00 00       	call   3bd4 <wait>
    2d86:	83 f8 ff             	cmp    $0xffffffff,%eax
    2d89:	74 17                	je     2da2 <forktest+0xb3>
    printf(1, "wait got too many\n");
    2d8b:	83 ec 08             	sub    $0x8,%esp
    2d8e:	68 9e 53 00 00       	push   $0x539e
    2d93:	6a 01                	push   $0x1
    2d95:	e8 9e 0f 00 00       	call   3d38 <printf>
    2d9a:	83 c4 10             	add    $0x10,%esp
    exit();
    2d9d:	e8 2a 0e 00 00       	call   3bcc <exit>
  }
  
  printf(1, "fork test OK\n");
    2da2:	83 ec 08             	sub    $0x8,%esp
    2da5:	68 b1 53 00 00       	push   $0x53b1
    2daa:	6a 01                	push   $0x1
    2dac:	e8 87 0f 00 00       	call   3d38 <printf>
    2db1:	83 c4 10             	add    $0x10,%esp
}
    2db4:	c9                   	leave  
    2db5:	c3                   	ret    

00002db6 <sbrktest>:

void
sbrktest(void)
{
    2db6:	55                   	push   %ebp
    2db7:	89 e5                	mov    %esp,%ebp
    2db9:	53                   	push   %ebx
    2dba:	83 ec 64             	sub    $0x64,%esp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
    2dbd:	a1 c0 57 00 00       	mov    0x57c0,%eax
    2dc2:	83 ec 08             	sub    $0x8,%esp
    2dc5:	68 bf 53 00 00       	push   $0x53bf
    2dca:	50                   	push   %eax
    2dcb:	e8 68 0f 00 00       	call   3d38 <printf>
    2dd0:	83 c4 10             	add    $0x10,%esp
  oldbrk = sbrk(0);
    2dd3:	83 ec 0c             	sub    $0xc,%esp
    2dd6:	6a 00                	push   $0x0
    2dd8:	e8 77 0e 00 00       	call   3c54 <sbrk>
    2ddd:	83 c4 10             	add    $0x10,%esp
    2de0:	89 45 ec             	mov    %eax,-0x14(%ebp)

  // can one sbrk() less than a page?
  a = sbrk(0);
    2de3:	83 ec 0c             	sub    $0xc,%esp
    2de6:	6a 00                	push   $0x0
    2de8:	e8 67 0e 00 00       	call   3c54 <sbrk>
    2ded:	83 c4 10             	add    $0x10,%esp
    2df0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int i;
  for(i = 0; i < 5000; i++){ 
    2df3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    2dfa:	eb 4c                	jmp    2e48 <sbrktest+0x92>
    b = sbrk(1);
    2dfc:	83 ec 0c             	sub    $0xc,%esp
    2dff:	6a 01                	push   $0x1
    2e01:	e8 4e 0e 00 00       	call   3c54 <sbrk>
    2e06:	83 c4 10             	add    $0x10,%esp
    2e09:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(b != a){
    2e0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2e0f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    2e12:	74 24                	je     2e38 <sbrktest+0x82>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    2e14:	a1 c0 57 00 00       	mov    0x57c0,%eax
    2e19:	83 ec 0c             	sub    $0xc,%esp
    2e1c:	ff 75 e8             	pushl  -0x18(%ebp)
    2e1f:	ff 75 f4             	pushl  -0xc(%ebp)
    2e22:	ff 75 f0             	pushl  -0x10(%ebp)
    2e25:	68 ca 53 00 00       	push   $0x53ca
    2e2a:	50                   	push   %eax
    2e2b:	e8 08 0f 00 00       	call   3d38 <printf>
    2e30:	83 c4 20             	add    $0x20,%esp
      exit();
    2e33:	e8 94 0d 00 00       	call   3bcc <exit>
    }
    *b = 1;
    2e38:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2e3b:	c6 00 01             	movb   $0x1,(%eax)
    a = b + 1;
    2e3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2e41:	40                   	inc    %eax
    2e42:	89 45 f4             	mov    %eax,-0xc(%ebp)
  oldbrk = sbrk(0);

  // can one sbrk() less than a page?
  a = sbrk(0);
  int i;
  for(i = 0; i < 5000; i++){ 
    2e45:	ff 45 f0             	incl   -0x10(%ebp)
    2e48:	81 7d f0 87 13 00 00 	cmpl   $0x1387,-0x10(%ebp)
    2e4f:	7e ab                	jle    2dfc <sbrktest+0x46>
      exit();
    }
    *b = 1;
    a = b + 1;
  }
  pid = fork();
    2e51:	e8 6e 0d 00 00       	call   3bc4 <fork>
    2e56:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(pid < 0){
    2e59:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    2e5d:	79 1b                	jns    2e7a <sbrktest+0xc4>
    printf(stdout, "sbrk test fork failed\n");
    2e5f:	a1 c0 57 00 00       	mov    0x57c0,%eax
    2e64:	83 ec 08             	sub    $0x8,%esp
    2e67:	68 e5 53 00 00       	push   $0x53e5
    2e6c:	50                   	push   %eax
    2e6d:	e8 c6 0e 00 00       	call   3d38 <printf>
    2e72:	83 c4 10             	add    $0x10,%esp
    exit();
    2e75:	e8 52 0d 00 00       	call   3bcc <exit>
  }
  c = sbrk(1);
    2e7a:	83 ec 0c             	sub    $0xc,%esp
    2e7d:	6a 01                	push   $0x1
    2e7f:	e8 d0 0d 00 00       	call   3c54 <sbrk>
    2e84:	83 c4 10             	add    $0x10,%esp
    2e87:	89 45 e0             	mov    %eax,-0x20(%ebp)
  c = sbrk(1);
    2e8a:	83 ec 0c             	sub    $0xc,%esp
    2e8d:	6a 01                	push   $0x1
    2e8f:	e8 c0 0d 00 00       	call   3c54 <sbrk>
    2e94:	83 c4 10             	add    $0x10,%esp
    2e97:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a + 1){
    2e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2e9d:	40                   	inc    %eax
    2e9e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    2ea1:	74 1b                	je     2ebe <sbrktest+0x108>
    printf(stdout, "sbrk test failed post-fork\n");
    2ea3:	a1 c0 57 00 00       	mov    0x57c0,%eax
    2ea8:	83 ec 08             	sub    $0x8,%esp
    2eab:	68 fc 53 00 00       	push   $0x53fc
    2eb0:	50                   	push   %eax
    2eb1:	e8 82 0e 00 00       	call   3d38 <printf>
    2eb6:	83 c4 10             	add    $0x10,%esp
    exit();
    2eb9:	e8 0e 0d 00 00       	call   3bcc <exit>
  }
  if(pid == 0)
    2ebe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    2ec2:	75 05                	jne    2ec9 <sbrktest+0x113>
    exit();
    2ec4:	e8 03 0d 00 00       	call   3bcc <exit>
  wait();
    2ec9:	e8 06 0d 00 00       	call   3bd4 <wait>

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
    2ece:	83 ec 0c             	sub    $0xc,%esp
    2ed1:	6a 00                	push   $0x0
    2ed3:	e8 7c 0d 00 00       	call   3c54 <sbrk>
    2ed8:	83 c4 10             	add    $0x10,%esp
    2edb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  amt = (BIG) - (uint)a;
    2ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2ee1:	ba 00 00 40 06       	mov    $0x6400000,%edx
    2ee6:	89 d1                	mov    %edx,%ecx
    2ee8:	29 c1                	sub    %eax,%ecx
    2eea:	89 c8                	mov    %ecx,%eax
    2eec:	89 45 dc             	mov    %eax,-0x24(%ebp)
  p = sbrk(amt);
    2eef:	8b 45 dc             	mov    -0x24(%ebp),%eax
    2ef2:	83 ec 0c             	sub    $0xc,%esp
    2ef5:	50                   	push   %eax
    2ef6:	e8 59 0d 00 00       	call   3c54 <sbrk>
    2efb:	83 c4 10             	add    $0x10,%esp
    2efe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  if (p != a) { 
    2f01:	8b 45 d8             	mov    -0x28(%ebp),%eax
    2f04:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    2f07:	74 1b                	je     2f24 <sbrktest+0x16e>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    2f09:	a1 c0 57 00 00       	mov    0x57c0,%eax
    2f0e:	83 ec 08             	sub    $0x8,%esp
    2f11:	68 18 54 00 00       	push   $0x5418
    2f16:	50                   	push   %eax
    2f17:	e8 1c 0e 00 00       	call   3d38 <printf>
    2f1c:	83 c4 10             	add    $0x10,%esp
    exit();
    2f1f:	e8 a8 0c 00 00       	call   3bcc <exit>
  }
  lastaddr = (char*) (BIG-1);
    2f24:	c7 45 d4 ff ff 3f 06 	movl   $0x63fffff,-0x2c(%ebp)
  *lastaddr = 99;
    2f2b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    2f2e:	c6 00 63             	movb   $0x63,(%eax)

  // can one de-allocate?
  a = sbrk(0);
    2f31:	83 ec 0c             	sub    $0xc,%esp
    2f34:	6a 00                	push   $0x0
    2f36:	e8 19 0d 00 00       	call   3c54 <sbrk>
    2f3b:	83 c4 10             	add    $0x10,%esp
    2f3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-4096);
    2f41:	83 ec 0c             	sub    $0xc,%esp
    2f44:	68 00 f0 ff ff       	push   $0xfffff000
    2f49:	e8 06 0d 00 00       	call   3c54 <sbrk>
    2f4e:	83 c4 10             	add    $0x10,%esp
    2f51:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c == (char*)0xffffffff){
    2f54:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    2f58:	75 1b                	jne    2f75 <sbrktest+0x1bf>
    printf(stdout, "sbrk could not deallocate\n");
    2f5a:	a1 c0 57 00 00       	mov    0x57c0,%eax
    2f5f:	83 ec 08             	sub    $0x8,%esp
    2f62:	68 56 54 00 00       	push   $0x5456
    2f67:	50                   	push   %eax
    2f68:	e8 cb 0d 00 00       	call   3d38 <printf>
    2f6d:	83 c4 10             	add    $0x10,%esp
    exit();
    2f70:	e8 57 0c 00 00       	call   3bcc <exit>
  }
  c = sbrk(0);
    2f75:	83 ec 0c             	sub    $0xc,%esp
    2f78:	6a 00                	push   $0x0
    2f7a:	e8 d5 0c 00 00       	call   3c54 <sbrk>
    2f7f:	83 c4 10             	add    $0x10,%esp
    2f82:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a - 4096){
    2f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2f88:	2d 00 10 00 00       	sub    $0x1000,%eax
    2f8d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    2f90:	74 1e                	je     2fb0 <sbrktest+0x1fa>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    2f92:	a1 c0 57 00 00       	mov    0x57c0,%eax
    2f97:	ff 75 e0             	pushl  -0x20(%ebp)
    2f9a:	ff 75 f4             	pushl  -0xc(%ebp)
    2f9d:	68 74 54 00 00       	push   $0x5474
    2fa2:	50                   	push   %eax
    2fa3:	e8 90 0d 00 00       	call   3d38 <printf>
    2fa8:	83 c4 10             	add    $0x10,%esp
    exit();
    2fab:	e8 1c 0c 00 00       	call   3bcc <exit>
  }

  // can one re-allocate that page?
  a = sbrk(0);
    2fb0:	83 ec 0c             	sub    $0xc,%esp
    2fb3:	6a 00                	push   $0x0
    2fb5:	e8 9a 0c 00 00       	call   3c54 <sbrk>
    2fba:	83 c4 10             	add    $0x10,%esp
    2fbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(4096);
    2fc0:	83 ec 0c             	sub    $0xc,%esp
    2fc3:	68 00 10 00 00       	push   $0x1000
    2fc8:	e8 87 0c 00 00       	call   3c54 <sbrk>
    2fcd:	83 c4 10             	add    $0x10,%esp
    2fd0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a || sbrk(0) != a + 4096){
    2fd3:	8b 45 e0             	mov    -0x20(%ebp),%eax
    2fd6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    2fd9:	75 1a                	jne    2ff5 <sbrktest+0x23f>
    2fdb:	83 ec 0c             	sub    $0xc,%esp
    2fde:	6a 00                	push   $0x0
    2fe0:	e8 6f 0c 00 00       	call   3c54 <sbrk>
    2fe5:	83 c4 10             	add    $0x10,%esp
    2fe8:	8b 55 f4             	mov    -0xc(%ebp),%edx
    2feb:	81 c2 00 10 00 00    	add    $0x1000,%edx
    2ff1:	39 d0                	cmp    %edx,%eax
    2ff3:	74 1e                	je     3013 <sbrktest+0x25d>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    2ff5:	a1 c0 57 00 00       	mov    0x57c0,%eax
    2ffa:	ff 75 e0             	pushl  -0x20(%ebp)
    2ffd:	ff 75 f4             	pushl  -0xc(%ebp)
    3000:	68 ac 54 00 00       	push   $0x54ac
    3005:	50                   	push   %eax
    3006:	e8 2d 0d 00 00       	call   3d38 <printf>
    300b:	83 c4 10             	add    $0x10,%esp
    exit();
    300e:	e8 b9 0b 00 00       	call   3bcc <exit>
  }
  if(*lastaddr == 99){
    3013:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    3016:	8a 00                	mov    (%eax),%al
    3018:	3c 63                	cmp    $0x63,%al
    301a:	75 1b                	jne    3037 <sbrktest+0x281>
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    301c:	a1 c0 57 00 00       	mov    0x57c0,%eax
    3021:	83 ec 08             	sub    $0x8,%esp
    3024:	68 d4 54 00 00       	push   $0x54d4
    3029:	50                   	push   %eax
    302a:	e8 09 0d 00 00       	call   3d38 <printf>
    302f:	83 c4 10             	add    $0x10,%esp
    exit();
    3032:	e8 95 0b 00 00       	call   3bcc <exit>
  }

  a = sbrk(0);
    3037:	83 ec 0c             	sub    $0xc,%esp
    303a:	6a 00                	push   $0x0
    303c:	e8 13 0c 00 00       	call   3c54 <sbrk>
    3041:	83 c4 10             	add    $0x10,%esp
    3044:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-(sbrk(0) - oldbrk));
    3047:	8b 5d ec             	mov    -0x14(%ebp),%ebx
    304a:	83 ec 0c             	sub    $0xc,%esp
    304d:	6a 00                	push   $0x0
    304f:	e8 00 0c 00 00       	call   3c54 <sbrk>
    3054:	83 c4 10             	add    $0x10,%esp
    3057:	89 da                	mov    %ebx,%edx
    3059:	29 c2                	sub    %eax,%edx
    305b:	89 d0                	mov    %edx,%eax
    305d:	83 ec 0c             	sub    $0xc,%esp
    3060:	50                   	push   %eax
    3061:	e8 ee 0b 00 00       	call   3c54 <sbrk>
    3066:	83 c4 10             	add    $0x10,%esp
    3069:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a){
    306c:	8b 45 e0             	mov    -0x20(%ebp),%eax
    306f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3072:	74 1e                	je     3092 <sbrktest+0x2dc>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    3074:	a1 c0 57 00 00       	mov    0x57c0,%eax
    3079:	ff 75 e0             	pushl  -0x20(%ebp)
    307c:	ff 75 f4             	pushl  -0xc(%ebp)
    307f:	68 04 55 00 00       	push   $0x5504
    3084:	50                   	push   %eax
    3085:	e8 ae 0c 00 00       	call   3d38 <printf>
    308a:	83 c4 10             	add    $0x10,%esp
    exit();
    308d:	e8 3a 0b 00 00       	call   3bcc <exit>
  }
  
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    3092:	c7 45 f4 00 00 00 80 	movl   $0x80000000,-0xc(%ebp)
    3099:	eb 75                	jmp    3110 <sbrktest+0x35a>
    ppid = getpid();
    309b:	e8 ac 0b 00 00       	call   3c4c <getpid>
    30a0:	89 45 d0             	mov    %eax,-0x30(%ebp)
    pid = fork();
    30a3:	e8 1c 0b 00 00       	call   3bc4 <fork>
    30a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(pid < 0){
    30ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    30af:	79 1b                	jns    30cc <sbrktest+0x316>
      printf(stdout, "fork failed\n");
    30b1:	a1 c0 57 00 00       	mov    0x57c0,%eax
    30b6:	83 ec 08             	sub    $0x8,%esp
    30b9:	68 cd 44 00 00       	push   $0x44cd
    30be:	50                   	push   %eax
    30bf:	e8 74 0c 00 00       	call   3d38 <printf>
    30c4:	83 c4 10             	add    $0x10,%esp
      exit();
    30c7:	e8 00 0b 00 00       	call   3bcc <exit>
    }
    if(pid == 0){
    30cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    30d0:	75 32                	jne    3104 <sbrktest+0x34e>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    30d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    30d5:	8a 00                	mov    (%eax),%al
    30d7:	0f be d0             	movsbl %al,%edx
    30da:	a1 c0 57 00 00       	mov    0x57c0,%eax
    30df:	52                   	push   %edx
    30e0:	ff 75 f4             	pushl  -0xc(%ebp)
    30e3:	68 25 55 00 00       	push   $0x5525
    30e8:	50                   	push   %eax
    30e9:	e8 4a 0c 00 00       	call   3d38 <printf>
    30ee:	83 c4 10             	add    $0x10,%esp
      kill(ppid);
    30f1:	83 ec 0c             	sub    $0xc,%esp
    30f4:	ff 75 d0             	pushl  -0x30(%ebp)
    30f7:	e8 00 0b 00 00       	call   3bfc <kill>
    30fc:	83 c4 10             	add    $0x10,%esp
      exit();
    30ff:	e8 c8 0a 00 00       	call   3bcc <exit>
    }
    wait();
    3104:	e8 cb 0a 00 00       	call   3bd4 <wait>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    exit();
  }
  
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    3109:	81 45 f4 50 c3 00 00 	addl   $0xc350,-0xc(%ebp)
    3110:	81 7d f4 7f 84 1e 80 	cmpl   $0x801e847f,-0xc(%ebp)
    3117:	76 82                	jbe    309b <sbrktest+0x2e5>
    wait();
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    3119:	83 ec 0c             	sub    $0xc,%esp
    311c:	8d 45 c8             	lea    -0x38(%ebp),%eax
    311f:	50                   	push   %eax
    3120:	e8 b7 0a 00 00       	call   3bdc <pipe>
    3125:	83 c4 10             	add    $0x10,%esp
    3128:	85 c0                	test   %eax,%eax
    312a:	74 17                	je     3143 <sbrktest+0x38d>
    printf(1, "pipe() failed\n");
    312c:	83 ec 08             	sub    $0x8,%esp
    312f:	68 21 44 00 00       	push   $0x4421
    3134:	6a 01                	push   $0x1
    3136:	e8 fd 0b 00 00       	call   3d38 <printf>
    313b:	83 c4 10             	add    $0x10,%esp
    exit();
    313e:	e8 89 0a 00 00       	call   3bcc <exit>
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3143:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    314a:	e9 87 00 00 00       	jmp    31d6 <sbrktest+0x420>
    if((pids[i] = fork()) == 0){
    314f:	e8 70 0a 00 00       	call   3bc4 <fork>
    3154:	8b 55 f0             	mov    -0x10(%ebp),%edx
    3157:	89 44 95 a0          	mov    %eax,-0x60(%ebp,%edx,4)
    315b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    315e:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    3162:	85 c0                	test   %eax,%eax
    3164:	75 4c                	jne    31b2 <sbrktest+0x3fc>
      // allocate a lot of memory
      sbrk(BIG - (uint)sbrk(0));
    3166:	83 ec 0c             	sub    $0xc,%esp
    3169:	6a 00                	push   $0x0
    316b:	e8 e4 0a 00 00       	call   3c54 <sbrk>
    3170:	83 c4 10             	add    $0x10,%esp
    3173:	ba 00 00 40 06       	mov    $0x6400000,%edx
    3178:	89 d1                	mov    %edx,%ecx
    317a:	29 c1                	sub    %eax,%ecx
    317c:	89 c8                	mov    %ecx,%eax
    317e:	83 ec 0c             	sub    $0xc,%esp
    3181:	50                   	push   %eax
    3182:	e8 cd 0a 00 00       	call   3c54 <sbrk>
    3187:	83 c4 10             	add    $0x10,%esp
      write(fds[1], "x", 1);
    318a:	8b 45 cc             	mov    -0x34(%ebp),%eax
    318d:	83 ec 04             	sub    $0x4,%esp
    3190:	6a 01                	push   $0x1
    3192:	68 86 44 00 00       	push   $0x4486
    3197:	50                   	push   %eax
    3198:	e8 4f 0a 00 00       	call   3bec <write>
    319d:	83 c4 10             	add    $0x10,%esp
      // sit around until killed
      for(;;) sleep(1000);
    31a0:	83 ec 0c             	sub    $0xc,%esp
    31a3:	68 e8 03 00 00       	push   $0x3e8
    31a8:	e8 af 0a 00 00       	call   3c5c <sleep>
    31ad:	83 c4 10             	add    $0x10,%esp
    31b0:	eb ee                	jmp    31a0 <sbrktest+0x3ea>
    }
    if(pids[i] != -1)
    31b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    31b5:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    31b9:	83 f8 ff             	cmp    $0xffffffff,%eax
    31bc:	74 15                	je     31d3 <sbrktest+0x41d>
      read(fds[0], &scratch, 1);
    31be:	8b 45 c8             	mov    -0x38(%ebp),%eax
    31c1:	83 ec 04             	sub    $0x4,%esp
    31c4:	6a 01                	push   $0x1
    31c6:	8d 55 9f             	lea    -0x61(%ebp),%edx
    31c9:	52                   	push   %edx
    31ca:	50                   	push   %eax
    31cb:	e8 14 0a 00 00       	call   3be4 <read>
    31d0:	83 c4 10             	add    $0x10,%esp
  // failed allocation?
  if(pipe(fds) != 0){
    printf(1, "pipe() failed\n");
    exit();
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    31d3:	ff 45 f0             	incl   -0x10(%ebp)
    31d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    31d9:	83 f8 09             	cmp    $0x9,%eax
    31dc:	0f 86 6d ff ff ff    	jbe    314f <sbrktest+0x399>
    if(pids[i] != -1)
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
    31e2:	83 ec 0c             	sub    $0xc,%esp
    31e5:	68 00 10 00 00       	push   $0x1000
    31ea:	e8 65 0a 00 00       	call   3c54 <sbrk>
    31ef:	83 c4 10             	add    $0x10,%esp
    31f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    31f5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    31fc:	eb 2a                	jmp    3228 <sbrktest+0x472>
    if(pids[i] == -1)
    31fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3201:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    3205:	83 f8 ff             	cmp    $0xffffffff,%eax
    3208:	74 1a                	je     3224 <sbrktest+0x46e>
      continue;
    kill(pids[i]);
    320a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    320d:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    3211:	83 ec 0c             	sub    $0xc,%esp
    3214:	50                   	push   %eax
    3215:	e8 e2 09 00 00       	call   3bfc <kill>
    321a:	83 c4 10             	add    $0x10,%esp
    wait();
    321d:	e8 b2 09 00 00       	call   3bd4 <wait>
    3222:	eb 01                	jmp    3225 <sbrktest+0x46f>
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    if(pids[i] == -1)
      continue;
    3224:	90                   	nop
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3225:	ff 45 f0             	incl   -0x10(%ebp)
    3228:	8b 45 f0             	mov    -0x10(%ebp),%eax
    322b:	83 f8 09             	cmp    $0x9,%eax
    322e:	76 ce                	jbe    31fe <sbrktest+0x448>
    if(pids[i] == -1)
      continue;
    kill(pids[i]);
    wait();
  }
  if(c == (char*)0xffffffff){
    3230:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    3234:	75 1b                	jne    3251 <sbrktest+0x49b>
    printf(stdout, "failed sbrk leaked memory\n");
    3236:	a1 c0 57 00 00       	mov    0x57c0,%eax
    323b:	83 ec 08             	sub    $0x8,%esp
    323e:	68 3e 55 00 00       	push   $0x553e
    3243:	50                   	push   %eax
    3244:	e8 ef 0a 00 00       	call   3d38 <printf>
    3249:	83 c4 10             	add    $0x10,%esp
    exit();
    324c:	e8 7b 09 00 00       	call   3bcc <exit>
  }

  if(sbrk(0) > oldbrk)
    3251:	83 ec 0c             	sub    $0xc,%esp
    3254:	6a 00                	push   $0x0
    3256:	e8 f9 09 00 00       	call   3c54 <sbrk>
    325b:	83 c4 10             	add    $0x10,%esp
    325e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    3261:	76 22                	jbe    3285 <sbrktest+0x4cf>
    sbrk(-(sbrk(0) - oldbrk));
    3263:	8b 5d ec             	mov    -0x14(%ebp),%ebx
    3266:	83 ec 0c             	sub    $0xc,%esp
    3269:	6a 00                	push   $0x0
    326b:	e8 e4 09 00 00       	call   3c54 <sbrk>
    3270:	83 c4 10             	add    $0x10,%esp
    3273:	89 da                	mov    %ebx,%edx
    3275:	29 c2                	sub    %eax,%edx
    3277:	89 d0                	mov    %edx,%eax
    3279:	83 ec 0c             	sub    $0xc,%esp
    327c:	50                   	push   %eax
    327d:	e8 d2 09 00 00       	call   3c54 <sbrk>
    3282:	83 c4 10             	add    $0x10,%esp

  printf(stdout, "sbrk test OK\n");
    3285:	a1 c0 57 00 00       	mov    0x57c0,%eax
    328a:	83 ec 08             	sub    $0x8,%esp
    328d:	68 59 55 00 00       	push   $0x5559
    3292:	50                   	push   %eax
    3293:	e8 a0 0a 00 00       	call   3d38 <printf>
    3298:	83 c4 10             	add    $0x10,%esp
}
    329b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    329e:	c9                   	leave  
    329f:	c3                   	ret    

000032a0 <validateint>:

void
validateint(int *p)
{
    32a0:	55                   	push   %ebp
    32a1:	89 e5                	mov    %esp,%ebp
    32a3:	56                   	push   %esi
    32a4:	53                   	push   %ebx
    32a5:	83 ec 14             	sub    $0x14,%esp
  int res;
  asm("mov %%esp, %%ebx\n\t"
    32a8:	c7 45 e4 0d 00 00 00 	movl   $0xd,-0x1c(%ebp)
    32af:	8b 55 08             	mov    0x8(%ebp),%edx
    32b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    32b5:	89 d1                	mov    %edx,%ecx
    32b7:	89 e3                	mov    %esp,%ebx
    32b9:	89 cc                	mov    %ecx,%esp
    32bb:	cd 40                	int    $0x40
    32bd:	89 dc                	mov    %ebx,%esp
    32bf:	89 c6                	mov    %eax,%esi
    32c1:	89 75 f4             	mov    %esi,-0xc(%ebp)
      "int %2\n\t"
      "mov %%ebx, %%esp" :
      "=a" (res) :
      "a" (SYS_sleep), "n" (T_SYSCALL), "c" (p) :
      "ebx");
}
    32c4:	83 c4 14             	add    $0x14,%esp
    32c7:	5b                   	pop    %ebx
    32c8:	5e                   	pop    %esi
    32c9:	c9                   	leave  
    32ca:	c3                   	ret    

000032cb <validatetest>:

void
validatetest(void)
{
    32cb:	55                   	push   %ebp
    32cc:	89 e5                	mov    %esp,%ebp
    32ce:	83 ec 18             	sub    $0x18,%esp
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
    32d1:	a1 c0 57 00 00       	mov    0x57c0,%eax
    32d6:	83 ec 08             	sub    $0x8,%esp
    32d9:	68 67 55 00 00       	push   $0x5567
    32de:	50                   	push   %eax
    32df:	e8 54 0a 00 00       	call   3d38 <printf>
    32e4:	83 c4 10             	add    $0x10,%esp
  hi = 1100*1024;
    32e7:	c7 45 f0 00 30 11 00 	movl   $0x113000,-0x10(%ebp)

  for(p = 0; p <= (uint)hi; p += 4096){
    32ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    32f5:	e9 8a 00 00 00       	jmp    3384 <validatetest+0xb9>
    if((pid = fork()) == 0){
    32fa:	e8 c5 08 00 00       	call   3bc4 <fork>
    32ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
    3302:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3306:	75 14                	jne    331c <validatetest+0x51>
      // try to crash the kernel by passing in a badly placed integer
      validateint((int*)p);
    3308:	8b 45 f4             	mov    -0xc(%ebp),%eax
    330b:	83 ec 0c             	sub    $0xc,%esp
    330e:	50                   	push   %eax
    330f:	e8 8c ff ff ff       	call   32a0 <validateint>
    3314:	83 c4 10             	add    $0x10,%esp
      exit();
    3317:	e8 b0 08 00 00       	call   3bcc <exit>
    }
    sleep(0);
    331c:	83 ec 0c             	sub    $0xc,%esp
    331f:	6a 00                	push   $0x0
    3321:	e8 36 09 00 00       	call   3c5c <sleep>
    3326:	83 c4 10             	add    $0x10,%esp
    sleep(0);
    3329:	83 ec 0c             	sub    $0xc,%esp
    332c:	6a 00                	push   $0x0
    332e:	e8 29 09 00 00       	call   3c5c <sleep>
    3333:	83 c4 10             	add    $0x10,%esp
    kill(pid);
    3336:	83 ec 0c             	sub    $0xc,%esp
    3339:	ff 75 ec             	pushl  -0x14(%ebp)
    333c:	e8 bb 08 00 00       	call   3bfc <kill>
    3341:	83 c4 10             	add    $0x10,%esp
    wait();
    3344:	e8 8b 08 00 00       	call   3bd4 <wait>

    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    3349:	8b 45 f4             	mov    -0xc(%ebp),%eax
    334c:	83 ec 08             	sub    $0x8,%esp
    334f:	50                   	push   %eax
    3350:	68 76 55 00 00       	push   $0x5576
    3355:	e8 d2 08 00 00       	call   3c2c <link>
    335a:	83 c4 10             	add    $0x10,%esp
    335d:	83 f8 ff             	cmp    $0xffffffff,%eax
    3360:	74 1b                	je     337d <validatetest+0xb2>
      printf(stdout, "link should not succeed\n");
    3362:	a1 c0 57 00 00       	mov    0x57c0,%eax
    3367:	83 ec 08             	sub    $0x8,%esp
    336a:	68 81 55 00 00       	push   $0x5581
    336f:	50                   	push   %eax
    3370:	e8 c3 09 00 00       	call   3d38 <printf>
    3375:	83 c4 10             	add    $0x10,%esp
      exit();
    3378:	e8 4f 08 00 00       	call   3bcc <exit>
  uint p;

  printf(stdout, "validate test\n");
  hi = 1100*1024;

  for(p = 0; p <= (uint)hi; p += 4096){
    337d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    3384:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3387:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    338a:	0f 83 6a ff ff ff    	jae    32fa <validatetest+0x2f>
      printf(stdout, "link should not succeed\n");
      exit();
    }
  }

  printf(stdout, "validate ok\n");
    3390:	a1 c0 57 00 00       	mov    0x57c0,%eax
    3395:	83 ec 08             	sub    $0x8,%esp
    3398:	68 9a 55 00 00       	push   $0x559a
    339d:	50                   	push   %eax
    339e:	e8 95 09 00 00       	call   3d38 <printf>
    33a3:	83 c4 10             	add    $0x10,%esp
}
    33a6:	c9                   	leave  
    33a7:	c3                   	ret    

000033a8 <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    33a8:	55                   	push   %ebp
    33a9:	89 e5                	mov    %esp,%ebp
    33ab:	83 ec 18             	sub    $0x18,%esp
  int i;

  printf(stdout, "bss test\n");
    33ae:	a1 c0 57 00 00       	mov    0x57c0,%eax
    33b3:	83 ec 08             	sub    $0x8,%esp
    33b6:	68 a7 55 00 00       	push   $0x55a7
    33bb:	50                   	push   %eax
    33bc:	e8 77 09 00 00       	call   3d38 <printf>
    33c1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(uninit); i++){
    33c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    33cb:	eb 2c                	jmp    33f9 <bsstest+0x51>
    if(uninit[i] != '\0'){
    33cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    33d0:	05 80 58 00 00       	add    $0x5880,%eax
    33d5:	8a 00                	mov    (%eax),%al
    33d7:	84 c0                	test   %al,%al
    33d9:	74 1b                	je     33f6 <bsstest+0x4e>
      printf(stdout, "bss test failed\n");
    33db:	a1 c0 57 00 00       	mov    0x57c0,%eax
    33e0:	83 ec 08             	sub    $0x8,%esp
    33e3:	68 b1 55 00 00       	push   $0x55b1
    33e8:	50                   	push   %eax
    33e9:	e8 4a 09 00 00       	call   3d38 <printf>
    33ee:	83 c4 10             	add    $0x10,%esp
      exit();
    33f1:	e8 d6 07 00 00       	call   3bcc <exit>
bsstest(void)
{
  int i;

  printf(stdout, "bss test\n");
  for(i = 0; i < sizeof(uninit); i++){
    33f6:	ff 45 f4             	incl   -0xc(%ebp)
    33f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    33fc:	3d 0f 27 00 00       	cmp    $0x270f,%eax
    3401:	76 ca                	jbe    33cd <bsstest+0x25>
    if(uninit[i] != '\0'){
      printf(stdout, "bss test failed\n");
      exit();
    }
  }
  printf(stdout, "bss test ok\n");
    3403:	a1 c0 57 00 00       	mov    0x57c0,%eax
    3408:	83 ec 08             	sub    $0x8,%esp
    340b:	68 c2 55 00 00       	push   $0x55c2
    3410:	50                   	push   %eax
    3411:	e8 22 09 00 00       	call   3d38 <printf>
    3416:	83 c4 10             	add    $0x10,%esp
}
    3419:	c9                   	leave  
    341a:	c3                   	ret    

0000341b <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    341b:	55                   	push   %ebp
    341c:	89 e5                	mov    %esp,%ebp
    341e:	83 ec 18             	sub    $0x18,%esp
  int pid, fd;

  unlink("bigarg-ok");
    3421:	83 ec 0c             	sub    $0xc,%esp
    3424:	68 cf 55 00 00       	push   $0x55cf
    3429:	e8 ee 07 00 00       	call   3c1c <unlink>
    342e:	83 c4 10             	add    $0x10,%esp
  pid = fork();
    3431:	e8 8e 07 00 00       	call   3bc4 <fork>
    3436:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid == 0){
    3439:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    343d:	0f 85 96 00 00 00    	jne    34d9 <bigargtest+0xbe>
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    3443:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    344a:	eb 11                	jmp    345d <bigargtest+0x42>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    344c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    344f:	c7 04 85 e0 57 00 00 	movl   $0x55dc,0x57e0(,%eax,4)
    3456:	dc 55 00 00 
  unlink("bigarg-ok");
  pid = fork();
  if(pid == 0){
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    345a:	ff 45 f4             	incl   -0xc(%ebp)
    345d:	83 7d f4 1e          	cmpl   $0x1e,-0xc(%ebp)
    3461:	7e e9                	jle    344c <bigargtest+0x31>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    args[MAXARG-1] = 0;
    3463:	c7 05 5c 58 00 00 00 	movl   $0x0,0x585c
    346a:	00 00 00 
    printf(stdout, "bigarg test\n");
    346d:	a1 c0 57 00 00       	mov    0x57c0,%eax
    3472:	83 ec 08             	sub    $0x8,%esp
    3475:	68 b9 56 00 00       	push   $0x56b9
    347a:	50                   	push   %eax
    347b:	e8 b8 08 00 00       	call   3d38 <printf>
    3480:	83 c4 10             	add    $0x10,%esp
    exec("echo", args);
    3483:	83 ec 08             	sub    $0x8,%esp
    3486:	68 e0 57 00 00       	push   $0x57e0
    348b:	68 e0 40 00 00       	push   $0x40e0
    3490:	e8 6f 07 00 00       	call   3c04 <exec>
    3495:	83 c4 10             	add    $0x10,%esp
    printf(stdout, "bigarg test ok\n");
    3498:	a1 c0 57 00 00       	mov    0x57c0,%eax
    349d:	83 ec 08             	sub    $0x8,%esp
    34a0:	68 c6 56 00 00       	push   $0x56c6
    34a5:	50                   	push   %eax
    34a6:	e8 8d 08 00 00       	call   3d38 <printf>
    34ab:	83 c4 10             	add    $0x10,%esp
    fd = open("bigarg-ok", O_CREATE);
    34ae:	83 ec 08             	sub    $0x8,%esp
    34b1:	68 00 02 00 00       	push   $0x200
    34b6:	68 cf 55 00 00       	push   $0x55cf
    34bb:	e8 4c 07 00 00       	call   3c0c <open>
    34c0:	83 c4 10             	add    $0x10,%esp
    34c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    close(fd);
    34c6:	83 ec 0c             	sub    $0xc,%esp
    34c9:	ff 75 ec             	pushl  -0x14(%ebp)
    34cc:	e8 23 07 00 00       	call   3bf4 <close>
    34d1:	83 c4 10             	add    $0x10,%esp
    exit();
    34d4:	e8 f3 06 00 00       	call   3bcc <exit>
  } else if(pid < 0){
    34d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    34dd:	79 1b                	jns    34fa <bigargtest+0xdf>
    printf(stdout, "bigargtest: fork failed\n");
    34df:	a1 c0 57 00 00       	mov    0x57c0,%eax
    34e4:	83 ec 08             	sub    $0x8,%esp
    34e7:	68 d6 56 00 00       	push   $0x56d6
    34ec:	50                   	push   %eax
    34ed:	e8 46 08 00 00       	call   3d38 <printf>
    34f2:	83 c4 10             	add    $0x10,%esp
    exit();
    34f5:	e8 d2 06 00 00       	call   3bcc <exit>
  }
  wait();
    34fa:	e8 d5 06 00 00       	call   3bd4 <wait>
  fd = open("bigarg-ok", 0);
    34ff:	83 ec 08             	sub    $0x8,%esp
    3502:	6a 00                	push   $0x0
    3504:	68 cf 55 00 00       	push   $0x55cf
    3509:	e8 fe 06 00 00       	call   3c0c <open>
    350e:	83 c4 10             	add    $0x10,%esp
    3511:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    3514:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3518:	79 1b                	jns    3535 <bigargtest+0x11a>
    printf(stdout, "bigarg test failed!\n");
    351a:	a1 c0 57 00 00       	mov    0x57c0,%eax
    351f:	83 ec 08             	sub    $0x8,%esp
    3522:	68 ef 56 00 00       	push   $0x56ef
    3527:	50                   	push   %eax
    3528:	e8 0b 08 00 00       	call   3d38 <printf>
    352d:	83 c4 10             	add    $0x10,%esp
    exit();
    3530:	e8 97 06 00 00       	call   3bcc <exit>
  }
  close(fd);
    3535:	83 ec 0c             	sub    $0xc,%esp
    3538:	ff 75 ec             	pushl  -0x14(%ebp)
    353b:	e8 b4 06 00 00       	call   3bf4 <close>
    3540:	83 c4 10             	add    $0x10,%esp
  unlink("bigarg-ok");
    3543:	83 ec 0c             	sub    $0xc,%esp
    3546:	68 cf 55 00 00       	push   $0x55cf
    354b:	e8 cc 06 00 00       	call   3c1c <unlink>
    3550:	83 c4 10             	add    $0x10,%esp
}
    3553:	c9                   	leave  
    3554:	c3                   	ret    

00003555 <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    3555:	55                   	push   %ebp
    3556:	89 e5                	mov    %esp,%ebp
    3558:	53                   	push   %ebx
    3559:	83 ec 64             	sub    $0x64,%esp
  int nfiles;
  int fsblocks = 0;
    355c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  printf(1, "fsfull test\n");
    3563:	83 ec 08             	sub    $0x8,%esp
    3566:	68 04 57 00 00       	push   $0x5704
    356b:	6a 01                	push   $0x1
    356d:	e8 c6 07 00 00       	call   3d38 <printf>
    3572:	83 c4 10             	add    $0x10,%esp

  for(nfiles = 0; ; nfiles++){
    3575:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char name[64];
    name[0] = 'f';
    357c:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    3580:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3583:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    3588:	f7 e9                	imul   %ecx
    358a:	c1 fa 06             	sar    $0x6,%edx
    358d:	89 c8                	mov    %ecx,%eax
    358f:	c1 f8 1f             	sar    $0x1f,%eax
    3592:	89 d1                	mov    %edx,%ecx
    3594:	29 c1                	sub    %eax,%ecx
    3596:	89 c8                	mov    %ecx,%eax
    3598:	83 c0 30             	add    $0x30,%eax
    359b:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    359e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    35a1:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    35a6:	f7 eb                	imul   %ebx
    35a8:	c1 fa 06             	sar    $0x6,%edx
    35ab:	89 d8                	mov    %ebx,%eax
    35ad:	c1 f8 1f             	sar    $0x1f,%eax
    35b0:	89 d1                	mov    %edx,%ecx
    35b2:	29 c1                	sub    %eax,%ecx
    35b4:	89 c8                	mov    %ecx,%eax
    35b6:	c1 e0 02             	shl    $0x2,%eax
    35b9:	01 c8                	add    %ecx,%eax
    35bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    35c2:	01 d0                	add    %edx,%eax
    35c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    35cb:	01 d0                	add    %edx,%eax
    35cd:	c1 e0 03             	shl    $0x3,%eax
    35d0:	89 d9                	mov    %ebx,%ecx
    35d2:	29 c1                	sub    %eax,%ecx
    35d4:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    35d9:	f7 e9                	imul   %ecx
    35db:	c1 fa 05             	sar    $0x5,%edx
    35de:	89 c8                	mov    %ecx,%eax
    35e0:	c1 f8 1f             	sar    $0x1f,%eax
    35e3:	89 d1                	mov    %edx,%ecx
    35e5:	29 c1                	sub    %eax,%ecx
    35e7:	89 c8                	mov    %ecx,%eax
    35e9:	83 c0 30             	add    $0x30,%eax
    35ec:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    35ef:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    35f2:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    35f7:	f7 eb                	imul   %ebx
    35f9:	c1 fa 05             	sar    $0x5,%edx
    35fc:	89 d8                	mov    %ebx,%eax
    35fe:	c1 f8 1f             	sar    $0x1f,%eax
    3601:	89 d1                	mov    %edx,%ecx
    3603:	29 c1                	sub    %eax,%ecx
    3605:	89 c8                	mov    %ecx,%eax
    3607:	c1 e0 02             	shl    $0x2,%eax
    360a:	01 c8                	add    %ecx,%eax
    360c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3613:	01 d0                	add    %edx,%eax
    3615:	c1 e0 02             	shl    $0x2,%eax
    3618:	89 d9                	mov    %ebx,%ecx
    361a:	29 c1                	sub    %eax,%ecx
    361c:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3621:	89 c8                	mov    %ecx,%eax
    3623:	f7 ea                	imul   %edx
    3625:	c1 fa 02             	sar    $0x2,%edx
    3628:	89 c8                	mov    %ecx,%eax
    362a:	c1 f8 1f             	sar    $0x1f,%eax
    362d:	89 d1                	mov    %edx,%ecx
    362f:	29 c1                	sub    %eax,%ecx
    3631:	89 c8                	mov    %ecx,%eax
    3633:	83 c0 30             	add    $0x30,%eax
    3636:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    3639:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    363c:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3641:	89 c8                	mov    %ecx,%eax
    3643:	f7 ea                	imul   %edx
    3645:	c1 fa 02             	sar    $0x2,%edx
    3648:	89 c8                	mov    %ecx,%eax
    364a:	c1 f8 1f             	sar    $0x1f,%eax
    364d:	29 c2                	sub    %eax,%edx
    364f:	89 d0                	mov    %edx,%eax
    3651:	c1 e0 02             	shl    $0x2,%eax
    3654:	01 d0                	add    %edx,%eax
    3656:	d1 e0                	shl    %eax
    3658:	89 ca                	mov    %ecx,%edx
    365a:	29 c2                	sub    %eax,%edx
    365c:	88 d0                	mov    %dl,%al
    365e:	83 c0 30             	add    $0x30,%eax
    3661:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    3664:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    printf(1, "writing %s\n", name);
    3668:	83 ec 04             	sub    $0x4,%esp
    366b:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    366e:	50                   	push   %eax
    366f:	68 11 57 00 00       	push   $0x5711
    3674:	6a 01                	push   $0x1
    3676:	e8 bd 06 00 00       	call   3d38 <printf>
    367b:	83 c4 10             	add    $0x10,%esp
    int fd = open(name, O_CREATE|O_RDWR);
    367e:	83 ec 08             	sub    $0x8,%esp
    3681:	68 02 02 00 00       	push   $0x202
    3686:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3689:	50                   	push   %eax
    368a:	e8 7d 05 00 00       	call   3c0c <open>
    368f:	83 c4 10             	add    $0x10,%esp
    3692:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(fd < 0){
    3695:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    3699:	79 18                	jns    36b3 <fsfull+0x15e>
      printf(1, "open %s failed\n", name);
    369b:	83 ec 04             	sub    $0x4,%esp
    369e:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    36a1:	50                   	push   %eax
    36a2:	68 1d 57 00 00       	push   $0x571d
    36a7:	6a 01                	push   $0x1
    36a9:	e8 8a 06 00 00       	call   3d38 <printf>
    36ae:	83 c4 10             	add    $0x10,%esp
      break;
    36b1:	eb 6b                	jmp    371e <fsfull+0x1c9>
    }
    int total = 0;
    36b3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while(1){
      int cc = write(fd, buf, 512);
    36ba:	83 ec 04             	sub    $0x4,%esp
    36bd:	68 00 02 00 00       	push   $0x200
    36c2:	68 a0 7f 00 00       	push   $0x7fa0
    36c7:	ff 75 e8             	pushl  -0x18(%ebp)
    36ca:	e8 1d 05 00 00       	call   3bec <write>
    36cf:	83 c4 10             	add    $0x10,%esp
    36d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(cc < 512)
    36d5:	81 7d e4 ff 01 00 00 	cmpl   $0x1ff,-0x1c(%ebp)
    36dc:	7f 2b                	jg     3709 <fsfull+0x1b4>
        break;
      total += cc;
      fsblocks++;
    }
    printf(1, "wrote %d bytes\n", total);
    36de:	83 ec 04             	sub    $0x4,%esp
    36e1:	ff 75 ec             	pushl  -0x14(%ebp)
    36e4:	68 2d 57 00 00       	push   $0x572d
    36e9:	6a 01                	push   $0x1
    36eb:	e8 48 06 00 00       	call   3d38 <printf>
    36f0:	83 c4 10             	add    $0x10,%esp
    close(fd);
    36f3:	83 ec 0c             	sub    $0xc,%esp
    36f6:	ff 75 e8             	pushl  -0x18(%ebp)
    36f9:	e8 f6 04 00 00       	call   3bf4 <close>
    36fe:	83 c4 10             	add    $0x10,%esp
    if(total == 0)
    3701:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3705:	74 0d                	je     3714 <fsfull+0x1bf>
    3707:	eb 0d                	jmp    3716 <fsfull+0x1c1>
    int total = 0;
    while(1){
      int cc = write(fd, buf, 512);
      if(cc < 512)
        break;
      total += cc;
    3709:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    370c:	01 45 ec             	add    %eax,-0x14(%ebp)
      fsblocks++;
    370f:	ff 45 f0             	incl   -0x10(%ebp)
    }
    3712:	eb a6                	jmp    36ba <fsfull+0x165>
    printf(1, "wrote %d bytes\n", total);
    close(fd);
    if(total == 0)
      break;
    3714:	eb 08                	jmp    371e <fsfull+0x1c9>
  int nfiles;
  int fsblocks = 0;

  printf(1, "fsfull test\n");

  for(nfiles = 0; ; nfiles++){
    3716:	ff 45 f4             	incl   -0xc(%ebp)
    }
    printf(1, "wrote %d bytes\n", total);
    close(fd);
    if(total == 0)
      break;
  }
    3719:	e9 5e fe ff ff       	jmp    357c <fsfull+0x27>

  while(nfiles >= 0){
    371e:	e9 fe 00 00 00       	jmp    3821 <fsfull+0x2cc>
    char name[64];
    name[0] = 'f';
    3723:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    3727:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    372a:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    372f:	f7 e9                	imul   %ecx
    3731:	c1 fa 06             	sar    $0x6,%edx
    3734:	89 c8                	mov    %ecx,%eax
    3736:	c1 f8 1f             	sar    $0x1f,%eax
    3739:	89 d1                	mov    %edx,%ecx
    373b:	29 c1                	sub    %eax,%ecx
    373d:	89 c8                	mov    %ecx,%eax
    373f:	83 c0 30             	add    $0x30,%eax
    3742:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    3745:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3748:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    374d:	f7 eb                	imul   %ebx
    374f:	c1 fa 06             	sar    $0x6,%edx
    3752:	89 d8                	mov    %ebx,%eax
    3754:	c1 f8 1f             	sar    $0x1f,%eax
    3757:	89 d1                	mov    %edx,%ecx
    3759:	29 c1                	sub    %eax,%ecx
    375b:	89 c8                	mov    %ecx,%eax
    375d:	c1 e0 02             	shl    $0x2,%eax
    3760:	01 c8                	add    %ecx,%eax
    3762:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3769:	01 d0                	add    %edx,%eax
    376b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3772:	01 d0                	add    %edx,%eax
    3774:	c1 e0 03             	shl    $0x3,%eax
    3777:	89 d9                	mov    %ebx,%ecx
    3779:	29 c1                	sub    %eax,%ecx
    377b:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    3780:	f7 e9                	imul   %ecx
    3782:	c1 fa 05             	sar    $0x5,%edx
    3785:	89 c8                	mov    %ecx,%eax
    3787:	c1 f8 1f             	sar    $0x1f,%eax
    378a:	89 d1                	mov    %edx,%ecx
    378c:	29 c1                	sub    %eax,%ecx
    378e:	89 c8                	mov    %ecx,%eax
    3790:	83 c0 30             	add    $0x30,%eax
    3793:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3796:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3799:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    379e:	f7 eb                	imul   %ebx
    37a0:	c1 fa 05             	sar    $0x5,%edx
    37a3:	89 d8                	mov    %ebx,%eax
    37a5:	c1 f8 1f             	sar    $0x1f,%eax
    37a8:	89 d1                	mov    %edx,%ecx
    37aa:	29 c1                	sub    %eax,%ecx
    37ac:	89 c8                	mov    %ecx,%eax
    37ae:	c1 e0 02             	shl    $0x2,%eax
    37b1:	01 c8                	add    %ecx,%eax
    37b3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    37ba:	01 d0                	add    %edx,%eax
    37bc:	c1 e0 02             	shl    $0x2,%eax
    37bf:	89 d9                	mov    %ebx,%ecx
    37c1:	29 c1                	sub    %eax,%ecx
    37c3:	ba 67 66 66 66       	mov    $0x66666667,%edx
    37c8:	89 c8                	mov    %ecx,%eax
    37ca:	f7 ea                	imul   %edx
    37cc:	c1 fa 02             	sar    $0x2,%edx
    37cf:	89 c8                	mov    %ecx,%eax
    37d1:	c1 f8 1f             	sar    $0x1f,%eax
    37d4:	89 d1                	mov    %edx,%ecx
    37d6:	29 c1                	sub    %eax,%ecx
    37d8:	89 c8                	mov    %ecx,%eax
    37da:	83 c0 30             	add    $0x30,%eax
    37dd:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    37e0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    37e3:	ba 67 66 66 66       	mov    $0x66666667,%edx
    37e8:	89 c8                	mov    %ecx,%eax
    37ea:	f7 ea                	imul   %edx
    37ec:	c1 fa 02             	sar    $0x2,%edx
    37ef:	89 c8                	mov    %ecx,%eax
    37f1:	c1 f8 1f             	sar    $0x1f,%eax
    37f4:	29 c2                	sub    %eax,%edx
    37f6:	89 d0                	mov    %edx,%eax
    37f8:	c1 e0 02             	shl    $0x2,%eax
    37fb:	01 d0                	add    %edx,%eax
    37fd:	d1 e0                	shl    %eax
    37ff:	89 ca                	mov    %ecx,%edx
    3801:	29 c2                	sub    %eax,%edx
    3803:	88 d0                	mov    %dl,%al
    3805:	83 c0 30             	add    $0x30,%eax
    3808:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    380b:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    unlink(name);
    380f:	83 ec 0c             	sub    $0xc,%esp
    3812:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3815:	50                   	push   %eax
    3816:	e8 01 04 00 00       	call   3c1c <unlink>
    381b:	83 c4 10             	add    $0x10,%esp
    nfiles--;
    381e:	ff 4d f4             	decl   -0xc(%ebp)
    close(fd);
    if(total == 0)
      break;
  }

  while(nfiles >= 0){
    3821:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3825:	0f 89 f8 fe ff ff    	jns    3723 <fsfull+0x1ce>
    name[5] = '\0';
    unlink(name);
    nfiles--;
  }

  printf(1, "fsfull test finished\n");
    382b:	83 ec 08             	sub    $0x8,%esp
    382e:	68 3d 57 00 00       	push   $0x573d
    3833:	6a 01                	push   $0x1
    3835:	e8 fe 04 00 00       	call   3d38 <printf>
    383a:	83 c4 10             	add    $0x10,%esp
}
    383d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    3840:	c9                   	leave  
    3841:	c3                   	ret    

00003842 <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
    3842:	55                   	push   %ebp
    3843:	89 e5                	mov    %esp,%ebp
  randstate = randstate * 1664525 + 1013904223;
    3845:	8b 15 c4 57 00 00    	mov    0x57c4,%edx
    384b:	89 d0                	mov    %edx,%eax
    384d:	d1 e0                	shl    %eax
    384f:	01 d0                	add    %edx,%eax
    3851:	c1 e0 02             	shl    $0x2,%eax
    3854:	01 d0                	add    %edx,%eax
    3856:	c1 e0 08             	shl    $0x8,%eax
    3859:	01 d0                	add    %edx,%eax
    385b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
    3862:	01 c8                	add    %ecx,%eax
    3864:	c1 e0 02             	shl    $0x2,%eax
    3867:	01 d0                	add    %edx,%eax
    3869:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3870:	01 d0                	add    %edx,%eax
    3872:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3879:	01 d0                	add    %edx,%eax
    387b:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    3880:	a3 c4 57 00 00       	mov    %eax,0x57c4
  return randstate;
    3885:	a1 c4 57 00 00       	mov    0x57c4,%eax
}
    388a:	c9                   	leave  
    388b:	c3                   	ret    

0000388c <main>:

int
main(int argc, char *argv[])
{
    388c:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    3890:	83 e4 f0             	and    $0xfffffff0,%esp
    3893:	ff 71 fc             	pushl  -0x4(%ecx)
    3896:	55                   	push   %ebp
    3897:	89 e5                	mov    %esp,%ebp
    3899:	51                   	push   %ecx
    389a:	83 ec 04             	sub    $0x4,%esp
  printf(1, "usertests starting\n");
    389d:	83 ec 08             	sub    $0x8,%esp
    38a0:	68 53 57 00 00       	push   $0x5753
    38a5:	6a 01                	push   $0x1
    38a7:	e8 8c 04 00 00       	call   3d38 <printf>
    38ac:	83 c4 10             	add    $0x10,%esp

  if(open("usertests.ran", 0) >= 0){
    38af:	83 ec 08             	sub    $0x8,%esp
    38b2:	6a 00                	push   $0x0
    38b4:	68 67 57 00 00       	push   $0x5767
    38b9:	e8 4e 03 00 00       	call   3c0c <open>
    38be:	83 c4 10             	add    $0x10,%esp
    38c1:	85 c0                	test   %eax,%eax
    38c3:	78 17                	js     38dc <main+0x50>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    38c5:	83 ec 08             	sub    $0x8,%esp
    38c8:	68 78 57 00 00       	push   $0x5778
    38cd:	6a 01                	push   $0x1
    38cf:	e8 64 04 00 00       	call   3d38 <printf>
    38d4:	83 c4 10             	add    $0x10,%esp
    exit();
    38d7:	e8 f0 02 00 00       	call   3bcc <exit>
  }
  close(open("usertests.ran", O_CREATE));
    38dc:	83 ec 08             	sub    $0x8,%esp
    38df:	68 00 02 00 00       	push   $0x200
    38e4:	68 67 57 00 00       	push   $0x5767
    38e9:	e8 1e 03 00 00       	call   3c0c <open>
    38ee:	83 c4 10             	add    $0x10,%esp
    38f1:	83 ec 0c             	sub    $0xc,%esp
    38f4:	50                   	push   %eax
    38f5:	e8 fa 02 00 00       	call   3bf4 <close>
    38fa:	83 c4 10             	add    $0x10,%esp

  bigargtest();
    38fd:	e8 19 fb ff ff       	call   341b <bigargtest>
  bigwrite();
    3902:	e8 87 ea ff ff       	call   238e <bigwrite>
  bigargtest();
    3907:	e8 0f fb ff ff       	call   341b <bigargtest>
  bsstest();
    390c:	e8 97 fa ff ff       	call   33a8 <bsstest>
  sbrktest();
    3911:	e8 a0 f4 ff ff       	call   2db6 <sbrktest>
  validatetest();
    3916:	e8 b0 f9 ff ff       	call   32cb <validatetest>

  opentest();
    391b:	e8 e0 c6 ff ff       	call   0 <opentest>
  writetest();
    3920:	e8 89 c7 ff ff       	call   ae <writetest>
  writetest1();
    3925:	e8 92 c9 ff ff       	call   2bc <writetest1>
  createtest();
    392a:	e8 87 cb ff ff       	call   4b6 <createtest>

  mem();
    392f:	e8 41 d1 ff ff       	call   a75 <mem>
  pipe1();
    3934:	e8 7f cd ff ff       	call   6b8 <pipe1>
  preempt();
    3939:	e8 5d cf ff ff       	call   89b <preempt>
  exitwait();
    393e:	e8 bb d0 ff ff       	call   9fe <exitwait>

  rmdot();
    3943:	e8 b4 ee ff ff       	call   27fc <rmdot>
  fourteen();
    3948:	e8 54 ed ff ff       	call   26a1 <fourteen>
  bigfile();
    394d:	e8 38 eb ff ff       	call   248a <bigfile>
  subdir();
    3952:	e8 f6 e2 ff ff       	call   1c4d <subdir>
  concreate();
    3957:	e8 d9 dc ff ff       	call   1635 <concreate>
  linkunlink();
    395c:	e8 2d e0 ff ff       	call   198e <linkunlink>
  linktest();
    3961:	e8 8e da ff ff       	call   13f4 <linktest>
  unlinkread();
    3966:	e8 ca d8 ff ff       	call   1235 <unlinkread>
  createdelete();
    396b:	e8 28 d6 ff ff       	call   f98 <createdelete>
  twofiles();
    3970:	e8 c9 d3 ff ff       	call   d3e <twofiles>
  sharedfd();
    3975:	e8 eb d1 ff ff       	call   b65 <sharedfd>
  dirfile();
    397a:	e8 01 f0 ff ff       	call   2980 <dirfile>
  iref();
    397f:	e8 33 f2 ff ff       	call   2bb7 <iref>
  forktest();
    3984:	e8 66 f3 ff ff       	call   2cef <forktest>
  bigdir(); // slow
    3989:	e8 49 e1 ff ff       	call   1ad7 <bigdir>

  exectest();
    398e:	e8 d3 cc ff ff       	call   666 <exectest>

  exit();
    3993:	e8 34 02 00 00       	call   3bcc <exit>

00003998 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    3998:	55                   	push   %ebp
    3999:	89 e5                	mov    %esp,%ebp
    399b:	57                   	push   %edi
    399c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    399d:	8b 4d 08             	mov    0x8(%ebp),%ecx
    39a0:	8b 55 10             	mov    0x10(%ebp),%edx
    39a3:	8b 45 0c             	mov    0xc(%ebp),%eax
    39a6:	89 cb                	mov    %ecx,%ebx
    39a8:	89 df                	mov    %ebx,%edi
    39aa:	89 d1                	mov    %edx,%ecx
    39ac:	fc                   	cld    
    39ad:	f3 aa                	rep stos %al,%es:(%edi)
    39af:	89 ca                	mov    %ecx,%edx
    39b1:	89 fb                	mov    %edi,%ebx
    39b3:	89 5d 08             	mov    %ebx,0x8(%ebp)
    39b6:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    39b9:	5b                   	pop    %ebx
    39ba:	5f                   	pop    %edi
    39bb:	c9                   	leave  
    39bc:	c3                   	ret    

000039bd <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    39bd:	55                   	push   %ebp
    39be:	89 e5                	mov    %esp,%ebp
    39c0:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    39c3:	8b 45 08             	mov    0x8(%ebp),%eax
    39c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    39c9:	90                   	nop
    39ca:	8b 45 0c             	mov    0xc(%ebp),%eax
    39cd:	8a 10                	mov    (%eax),%dl
    39cf:	8b 45 08             	mov    0x8(%ebp),%eax
    39d2:	88 10                	mov    %dl,(%eax)
    39d4:	8b 45 08             	mov    0x8(%ebp),%eax
    39d7:	8a 00                	mov    (%eax),%al
    39d9:	84 c0                	test   %al,%al
    39db:	0f 95 c0             	setne  %al
    39de:	ff 45 08             	incl   0x8(%ebp)
    39e1:	ff 45 0c             	incl   0xc(%ebp)
    39e4:	84 c0                	test   %al,%al
    39e6:	75 e2                	jne    39ca <strcpy+0xd>
    ;
  return os;
    39e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    39eb:	c9                   	leave  
    39ec:	c3                   	ret    

000039ed <strcmp>:

int
strcmp(const char *p, const char *q)
{
    39ed:	55                   	push   %ebp
    39ee:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    39f0:	eb 06                	jmp    39f8 <strcmp+0xb>
    p++, q++;
    39f2:	ff 45 08             	incl   0x8(%ebp)
    39f5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    39f8:	8b 45 08             	mov    0x8(%ebp),%eax
    39fb:	8a 00                	mov    (%eax),%al
    39fd:	84 c0                	test   %al,%al
    39ff:	74 0e                	je     3a0f <strcmp+0x22>
    3a01:	8b 45 08             	mov    0x8(%ebp),%eax
    3a04:	8a 10                	mov    (%eax),%dl
    3a06:	8b 45 0c             	mov    0xc(%ebp),%eax
    3a09:	8a 00                	mov    (%eax),%al
    3a0b:	38 c2                	cmp    %al,%dl
    3a0d:	74 e3                	je     39f2 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    3a0f:	8b 45 08             	mov    0x8(%ebp),%eax
    3a12:	8a 00                	mov    (%eax),%al
    3a14:	0f b6 d0             	movzbl %al,%edx
    3a17:	8b 45 0c             	mov    0xc(%ebp),%eax
    3a1a:	8a 00                	mov    (%eax),%al
    3a1c:	0f b6 c0             	movzbl %al,%eax
    3a1f:	89 d1                	mov    %edx,%ecx
    3a21:	29 c1                	sub    %eax,%ecx
    3a23:	89 c8                	mov    %ecx,%eax
}
    3a25:	c9                   	leave  
    3a26:	c3                   	ret    

00003a27 <strlen>:

uint
strlen(char *s)
{
    3a27:	55                   	push   %ebp
    3a28:	89 e5                	mov    %esp,%ebp
    3a2a:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    3a2d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    3a34:	eb 03                	jmp    3a39 <strlen+0x12>
    3a36:	ff 45 fc             	incl   -0x4(%ebp)
    3a39:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3a3c:	03 45 08             	add    0x8(%ebp),%eax
    3a3f:	8a 00                	mov    (%eax),%al
    3a41:	84 c0                	test   %al,%al
    3a43:	75 f1                	jne    3a36 <strlen+0xf>
    ;
  return n;
    3a45:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3a48:	c9                   	leave  
    3a49:	c3                   	ret    

00003a4a <memset>:

void*
memset(void *dst, int c, uint n)
{
    3a4a:	55                   	push   %ebp
    3a4b:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
    3a4d:	8b 45 10             	mov    0x10(%ebp),%eax
    3a50:	50                   	push   %eax
    3a51:	ff 75 0c             	pushl  0xc(%ebp)
    3a54:	ff 75 08             	pushl  0x8(%ebp)
    3a57:	e8 3c ff ff ff       	call   3998 <stosb>
    3a5c:	83 c4 0c             	add    $0xc,%esp
  return dst;
    3a5f:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3a62:	c9                   	leave  
    3a63:	c3                   	ret    

00003a64 <strchr>:

char*
strchr(const char *s, char c)
{
    3a64:	55                   	push   %ebp
    3a65:	89 e5                	mov    %esp,%ebp
    3a67:	83 ec 04             	sub    $0x4,%esp
    3a6a:	8b 45 0c             	mov    0xc(%ebp),%eax
    3a6d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    3a70:	eb 12                	jmp    3a84 <strchr+0x20>
    if(*s == c)
    3a72:	8b 45 08             	mov    0x8(%ebp),%eax
    3a75:	8a 00                	mov    (%eax),%al
    3a77:	3a 45 fc             	cmp    -0x4(%ebp),%al
    3a7a:	75 05                	jne    3a81 <strchr+0x1d>
      return (char*)s;
    3a7c:	8b 45 08             	mov    0x8(%ebp),%eax
    3a7f:	eb 11                	jmp    3a92 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    3a81:	ff 45 08             	incl   0x8(%ebp)
    3a84:	8b 45 08             	mov    0x8(%ebp),%eax
    3a87:	8a 00                	mov    (%eax),%al
    3a89:	84 c0                	test   %al,%al
    3a8b:	75 e5                	jne    3a72 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    3a8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
    3a92:	c9                   	leave  
    3a93:	c3                   	ret    

00003a94 <gets>:

char*
gets(char *buf, int max)
{
    3a94:	55                   	push   %ebp
    3a95:	89 e5                	mov    %esp,%ebp
    3a97:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3a9a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3aa1:	eb 38                	jmp    3adb <gets+0x47>
    cc = read(0, &c, 1);
    3aa3:	83 ec 04             	sub    $0x4,%esp
    3aa6:	6a 01                	push   $0x1
    3aa8:	8d 45 ef             	lea    -0x11(%ebp),%eax
    3aab:	50                   	push   %eax
    3aac:	6a 00                	push   $0x0
    3aae:	e8 31 01 00 00       	call   3be4 <read>
    3ab3:	83 c4 10             	add    $0x10,%esp
    3ab6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    3ab9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3abd:	7e 27                	jle    3ae6 <gets+0x52>
      break;
    buf[i++] = c;
    3abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3ac2:	03 45 08             	add    0x8(%ebp),%eax
    3ac5:	8a 55 ef             	mov    -0x11(%ebp),%dl
    3ac8:	88 10                	mov    %dl,(%eax)
    3aca:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
    3acd:	8a 45 ef             	mov    -0x11(%ebp),%al
    3ad0:	3c 0a                	cmp    $0xa,%al
    3ad2:	74 13                	je     3ae7 <gets+0x53>
    3ad4:	8a 45 ef             	mov    -0x11(%ebp),%al
    3ad7:	3c 0d                	cmp    $0xd,%al
    3ad9:	74 0c                	je     3ae7 <gets+0x53>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3ade:	40                   	inc    %eax
    3adf:	3b 45 0c             	cmp    0xc(%ebp),%eax
    3ae2:	7c bf                	jl     3aa3 <gets+0xf>
    3ae4:	eb 01                	jmp    3ae7 <gets+0x53>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    3ae6:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    3ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3aea:	03 45 08             	add    0x8(%ebp),%eax
    3aed:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    3af0:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3af3:	c9                   	leave  
    3af4:	c3                   	ret    

00003af5 <stat>:

int
stat(char *n, struct stat *st)
{
    3af5:	55                   	push   %ebp
    3af6:	89 e5                	mov    %esp,%ebp
    3af8:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    3afb:	83 ec 08             	sub    $0x8,%esp
    3afe:	6a 00                	push   $0x0
    3b00:	ff 75 08             	pushl  0x8(%ebp)
    3b03:	e8 04 01 00 00       	call   3c0c <open>
    3b08:	83 c4 10             	add    $0x10,%esp
    3b0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    3b0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3b12:	79 07                	jns    3b1b <stat+0x26>
    return -1;
    3b14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    3b19:	eb 25                	jmp    3b40 <stat+0x4b>
  r = fstat(fd, st);
    3b1b:	83 ec 08             	sub    $0x8,%esp
    3b1e:	ff 75 0c             	pushl  0xc(%ebp)
    3b21:	ff 75 f4             	pushl  -0xc(%ebp)
    3b24:	e8 fb 00 00 00       	call   3c24 <fstat>
    3b29:	83 c4 10             	add    $0x10,%esp
    3b2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    3b2f:	83 ec 0c             	sub    $0xc,%esp
    3b32:	ff 75 f4             	pushl  -0xc(%ebp)
    3b35:	e8 ba 00 00 00       	call   3bf4 <close>
    3b3a:	83 c4 10             	add    $0x10,%esp
  return r;
    3b3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    3b40:	c9                   	leave  
    3b41:	c3                   	ret    

00003b42 <atoi>:

int
atoi(const char *s)
{
    3b42:	55                   	push   %ebp
    3b43:	89 e5                	mov    %esp,%ebp
    3b45:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    3b48:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    3b4f:	eb 22                	jmp    3b73 <atoi+0x31>
    n = n*10 + *s++ - '0';
    3b51:	8b 55 fc             	mov    -0x4(%ebp),%edx
    3b54:	89 d0                	mov    %edx,%eax
    3b56:	c1 e0 02             	shl    $0x2,%eax
    3b59:	01 d0                	add    %edx,%eax
    3b5b:	d1 e0                	shl    %eax
    3b5d:	89 c2                	mov    %eax,%edx
    3b5f:	8b 45 08             	mov    0x8(%ebp),%eax
    3b62:	8a 00                	mov    (%eax),%al
    3b64:	0f be c0             	movsbl %al,%eax
    3b67:	8d 04 02             	lea    (%edx,%eax,1),%eax
    3b6a:	83 e8 30             	sub    $0x30,%eax
    3b6d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    3b70:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    3b73:	8b 45 08             	mov    0x8(%ebp),%eax
    3b76:	8a 00                	mov    (%eax),%al
    3b78:	3c 2f                	cmp    $0x2f,%al
    3b7a:	7e 09                	jle    3b85 <atoi+0x43>
    3b7c:	8b 45 08             	mov    0x8(%ebp),%eax
    3b7f:	8a 00                	mov    (%eax),%al
    3b81:	3c 39                	cmp    $0x39,%al
    3b83:	7e cc                	jle    3b51 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    3b85:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3b88:	c9                   	leave  
    3b89:	c3                   	ret    

00003b8a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    3b8a:	55                   	push   %ebp
    3b8b:	89 e5                	mov    %esp,%ebp
    3b8d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    3b90:	8b 45 08             	mov    0x8(%ebp),%eax
    3b93:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    3b96:	8b 45 0c             	mov    0xc(%ebp),%eax
    3b99:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    3b9c:	eb 10                	jmp    3bae <memmove+0x24>
    *dst++ = *src++;
    3b9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3ba1:	8a 10                	mov    (%eax),%dl
    3ba3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3ba6:	88 10                	mov    %dl,(%eax)
    3ba8:	ff 45 fc             	incl   -0x4(%ebp)
    3bab:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    3bae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    3bb2:	0f 9f c0             	setg   %al
    3bb5:	ff 4d 10             	decl   0x10(%ebp)
    3bb8:	84 c0                	test   %al,%al
    3bba:	75 e2                	jne    3b9e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    3bbc:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3bbf:	c9                   	leave  
    3bc0:	c3                   	ret    
    3bc1:	90                   	nop
    3bc2:	90                   	nop
    3bc3:	90                   	nop

00003bc4 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    3bc4:	b8 01 00 00 00       	mov    $0x1,%eax
    3bc9:	cd 40                	int    $0x40
    3bcb:	c3                   	ret    

00003bcc <exit>:
SYSCALL(exit)
    3bcc:	b8 02 00 00 00       	mov    $0x2,%eax
    3bd1:	cd 40                	int    $0x40
    3bd3:	c3                   	ret    

00003bd4 <wait>:
SYSCALL(wait)
    3bd4:	b8 03 00 00 00       	mov    $0x3,%eax
    3bd9:	cd 40                	int    $0x40
    3bdb:	c3                   	ret    

00003bdc <pipe>:
SYSCALL(pipe)
    3bdc:	b8 04 00 00 00       	mov    $0x4,%eax
    3be1:	cd 40                	int    $0x40
    3be3:	c3                   	ret    

00003be4 <read>:
SYSCALL(read)
    3be4:	b8 05 00 00 00       	mov    $0x5,%eax
    3be9:	cd 40                	int    $0x40
    3beb:	c3                   	ret    

00003bec <write>:
SYSCALL(write)
    3bec:	b8 10 00 00 00       	mov    $0x10,%eax
    3bf1:	cd 40                	int    $0x40
    3bf3:	c3                   	ret    

00003bf4 <close>:
SYSCALL(close)
    3bf4:	b8 15 00 00 00       	mov    $0x15,%eax
    3bf9:	cd 40                	int    $0x40
    3bfb:	c3                   	ret    

00003bfc <kill>:
SYSCALL(kill)
    3bfc:	b8 06 00 00 00       	mov    $0x6,%eax
    3c01:	cd 40                	int    $0x40
    3c03:	c3                   	ret    

00003c04 <exec>:
SYSCALL(exec)
    3c04:	b8 07 00 00 00       	mov    $0x7,%eax
    3c09:	cd 40                	int    $0x40
    3c0b:	c3                   	ret    

00003c0c <open>:
SYSCALL(open)
    3c0c:	b8 0f 00 00 00       	mov    $0xf,%eax
    3c11:	cd 40                	int    $0x40
    3c13:	c3                   	ret    

00003c14 <mknod>:
SYSCALL(mknod)
    3c14:	b8 11 00 00 00       	mov    $0x11,%eax
    3c19:	cd 40                	int    $0x40
    3c1b:	c3                   	ret    

00003c1c <unlink>:
SYSCALL(unlink)
    3c1c:	b8 12 00 00 00       	mov    $0x12,%eax
    3c21:	cd 40                	int    $0x40
    3c23:	c3                   	ret    

00003c24 <fstat>:
SYSCALL(fstat)
    3c24:	b8 08 00 00 00       	mov    $0x8,%eax
    3c29:	cd 40                	int    $0x40
    3c2b:	c3                   	ret    

00003c2c <link>:
SYSCALL(link)
    3c2c:	b8 13 00 00 00       	mov    $0x13,%eax
    3c31:	cd 40                	int    $0x40
    3c33:	c3                   	ret    

00003c34 <mkdir>:
SYSCALL(mkdir)
    3c34:	b8 14 00 00 00       	mov    $0x14,%eax
    3c39:	cd 40                	int    $0x40
    3c3b:	c3                   	ret    

00003c3c <chdir>:
SYSCALL(chdir)
    3c3c:	b8 09 00 00 00       	mov    $0x9,%eax
    3c41:	cd 40                	int    $0x40
    3c43:	c3                   	ret    

00003c44 <dup>:
SYSCALL(dup)
    3c44:	b8 0a 00 00 00       	mov    $0xa,%eax
    3c49:	cd 40                	int    $0x40
    3c4b:	c3                   	ret    

00003c4c <getpid>:
SYSCALL(getpid)
    3c4c:	b8 0b 00 00 00       	mov    $0xb,%eax
    3c51:	cd 40                	int    $0x40
    3c53:	c3                   	ret    

00003c54 <sbrk>:
SYSCALL(sbrk)
    3c54:	b8 0c 00 00 00       	mov    $0xc,%eax
    3c59:	cd 40                	int    $0x40
    3c5b:	c3                   	ret    

00003c5c <sleep>:
SYSCALL(sleep)
    3c5c:	b8 0d 00 00 00       	mov    $0xd,%eax
    3c61:	cd 40                	int    $0x40
    3c63:	c3                   	ret    

00003c64 <uptime>:
SYSCALL(uptime)
    3c64:	b8 0e 00 00 00       	mov    $0xe,%eax
    3c69:	cd 40                	int    $0x40
    3c6b:	c3                   	ret    

00003c6c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    3c6c:	55                   	push   %ebp
    3c6d:	89 e5                	mov    %esp,%ebp
    3c6f:	83 ec 18             	sub    $0x18,%esp
    3c72:	8b 45 0c             	mov    0xc(%ebp),%eax
    3c75:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    3c78:	83 ec 04             	sub    $0x4,%esp
    3c7b:	6a 01                	push   $0x1
    3c7d:	8d 45 f4             	lea    -0xc(%ebp),%eax
    3c80:	50                   	push   %eax
    3c81:	ff 75 08             	pushl  0x8(%ebp)
    3c84:	e8 63 ff ff ff       	call   3bec <write>
    3c89:	83 c4 10             	add    $0x10,%esp
}
    3c8c:	c9                   	leave  
    3c8d:	c3                   	ret    

00003c8e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    3c8e:	55                   	push   %ebp
    3c8f:	89 e5                	mov    %esp,%ebp
    3c91:	83 ec 38             	sub    $0x38,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    3c94:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    3c9b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    3c9f:	74 17                	je     3cb8 <printint+0x2a>
    3ca1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    3ca5:	79 11                	jns    3cb8 <printint+0x2a>
    neg = 1;
    3ca7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    3cae:	8b 45 0c             	mov    0xc(%ebp),%eax
    3cb1:	f7 d8                	neg    %eax
    3cb3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    3cb6:	eb 06                	jmp    3cbe <printint+0x30>
  } else {
    x = xx;
    3cb8:	8b 45 0c             	mov    0xc(%ebp),%eax
    3cbb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    3cbe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    3cc5:	8b 4d 10             	mov    0x10(%ebp),%ecx
    3cc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3ccb:	ba 00 00 00 00       	mov    $0x0,%edx
    3cd0:	f7 f1                	div    %ecx
    3cd2:	89 d0                	mov    %edx,%eax
    3cd4:	8a 90 c8 57 00 00    	mov    0x57c8(%eax),%dl
    3cda:	8d 45 dc             	lea    -0x24(%ebp),%eax
    3cdd:	03 45 f4             	add    -0xc(%ebp),%eax
    3ce0:	88 10                	mov    %dl,(%eax)
    3ce2:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
    3ce5:	8b 45 10             	mov    0x10(%ebp),%eax
    3ce8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    3ceb:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3cee:	ba 00 00 00 00       	mov    $0x0,%edx
    3cf3:	f7 75 d4             	divl   -0x2c(%ebp)
    3cf6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    3cf9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3cfd:	75 c6                	jne    3cc5 <printint+0x37>
  if(neg)
    3cff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3d03:	74 28                	je     3d2d <printint+0x9f>
    buf[i++] = '-';
    3d05:	8d 45 dc             	lea    -0x24(%ebp),%eax
    3d08:	03 45 f4             	add    -0xc(%ebp),%eax
    3d0b:	c6 00 2d             	movb   $0x2d,(%eax)
    3d0e:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
    3d11:	eb 1a                	jmp    3d2d <printint+0x9f>
    putc(fd, buf[i]);
    3d13:	8d 45 dc             	lea    -0x24(%ebp),%eax
    3d16:	03 45 f4             	add    -0xc(%ebp),%eax
    3d19:	8a 00                	mov    (%eax),%al
    3d1b:	0f be c0             	movsbl %al,%eax
    3d1e:	83 ec 08             	sub    $0x8,%esp
    3d21:	50                   	push   %eax
    3d22:	ff 75 08             	pushl  0x8(%ebp)
    3d25:	e8 42 ff ff ff       	call   3c6c <putc>
    3d2a:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    3d2d:	ff 4d f4             	decl   -0xc(%ebp)
    3d30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3d34:	79 dd                	jns    3d13 <printint+0x85>
    putc(fd, buf[i]);
}
    3d36:	c9                   	leave  
    3d37:	c3                   	ret    

00003d38 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    3d38:	55                   	push   %ebp
    3d39:	89 e5                	mov    %esp,%ebp
    3d3b:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    3d3e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    3d45:	8d 45 0c             	lea    0xc(%ebp),%eax
    3d48:	83 c0 04             	add    $0x4,%eax
    3d4b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    3d4e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3d55:	e9 58 01 00 00       	jmp    3eb2 <printf+0x17a>
    c = fmt[i] & 0xff;
    3d5a:	8b 55 0c             	mov    0xc(%ebp),%edx
    3d5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3d60:	8d 04 02             	lea    (%edx,%eax,1),%eax
    3d63:	8a 00                	mov    (%eax),%al
    3d65:	0f be c0             	movsbl %al,%eax
    3d68:	25 ff 00 00 00       	and    $0xff,%eax
    3d6d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    3d70:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3d74:	75 2c                	jne    3da2 <printf+0x6a>
      if(c == '%'){
    3d76:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    3d7a:	75 0c                	jne    3d88 <printf+0x50>
        state = '%';
    3d7c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    3d83:	e9 27 01 00 00       	jmp    3eaf <printf+0x177>
      } else {
        putc(fd, c);
    3d88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3d8b:	0f be c0             	movsbl %al,%eax
    3d8e:	83 ec 08             	sub    $0x8,%esp
    3d91:	50                   	push   %eax
    3d92:	ff 75 08             	pushl  0x8(%ebp)
    3d95:	e8 d2 fe ff ff       	call   3c6c <putc>
    3d9a:	83 c4 10             	add    $0x10,%esp
    3d9d:	e9 0d 01 00 00       	jmp    3eaf <printf+0x177>
      }
    } else if(state == '%'){
    3da2:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    3da6:	0f 85 03 01 00 00    	jne    3eaf <printf+0x177>
      if(c == 'd'){
    3dac:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    3db0:	75 1e                	jne    3dd0 <printf+0x98>
        printint(fd, *ap, 10, 1);
    3db2:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3db5:	8b 00                	mov    (%eax),%eax
    3db7:	6a 01                	push   $0x1
    3db9:	6a 0a                	push   $0xa
    3dbb:	50                   	push   %eax
    3dbc:	ff 75 08             	pushl  0x8(%ebp)
    3dbf:	e8 ca fe ff ff       	call   3c8e <printint>
    3dc4:	83 c4 10             	add    $0x10,%esp
        ap++;
    3dc7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    3dcb:	e9 d8 00 00 00       	jmp    3ea8 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    3dd0:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    3dd4:	74 06                	je     3ddc <printf+0xa4>
    3dd6:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    3dda:	75 1e                	jne    3dfa <printf+0xc2>
        printint(fd, *ap, 16, 0);
    3ddc:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3ddf:	8b 00                	mov    (%eax),%eax
    3de1:	6a 00                	push   $0x0
    3de3:	6a 10                	push   $0x10
    3de5:	50                   	push   %eax
    3de6:	ff 75 08             	pushl  0x8(%ebp)
    3de9:	e8 a0 fe ff ff       	call   3c8e <printint>
    3dee:	83 c4 10             	add    $0x10,%esp
        ap++;
    3df1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    3df5:	e9 ae 00 00 00       	jmp    3ea8 <printf+0x170>
      } else if(c == 's'){
    3dfa:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    3dfe:	75 43                	jne    3e43 <printf+0x10b>
        s = (char*)*ap;
    3e00:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3e03:	8b 00                	mov    (%eax),%eax
    3e05:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    3e08:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    3e0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3e10:	75 25                	jne    3e37 <printf+0xff>
          s = "(null)";
    3e12:	c7 45 f4 a2 57 00 00 	movl   $0x57a2,-0xc(%ebp)
        while(*s != 0){
    3e19:	eb 1d                	jmp    3e38 <printf+0x100>
          putc(fd, *s);
    3e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3e1e:	8a 00                	mov    (%eax),%al
    3e20:	0f be c0             	movsbl %al,%eax
    3e23:	83 ec 08             	sub    $0x8,%esp
    3e26:	50                   	push   %eax
    3e27:	ff 75 08             	pushl  0x8(%ebp)
    3e2a:	e8 3d fe ff ff       	call   3c6c <putc>
    3e2f:	83 c4 10             	add    $0x10,%esp
          s++;
    3e32:	ff 45 f4             	incl   -0xc(%ebp)
    3e35:	eb 01                	jmp    3e38 <printf+0x100>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    3e37:	90                   	nop
    3e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3e3b:	8a 00                	mov    (%eax),%al
    3e3d:	84 c0                	test   %al,%al
    3e3f:	75 da                	jne    3e1b <printf+0xe3>
    3e41:	eb 65                	jmp    3ea8 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    3e43:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    3e47:	75 1d                	jne    3e66 <printf+0x12e>
        putc(fd, *ap);
    3e49:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3e4c:	8b 00                	mov    (%eax),%eax
    3e4e:	0f be c0             	movsbl %al,%eax
    3e51:	83 ec 08             	sub    $0x8,%esp
    3e54:	50                   	push   %eax
    3e55:	ff 75 08             	pushl  0x8(%ebp)
    3e58:	e8 0f fe ff ff       	call   3c6c <putc>
    3e5d:	83 c4 10             	add    $0x10,%esp
        ap++;
    3e60:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    3e64:	eb 42                	jmp    3ea8 <printf+0x170>
      } else if(c == '%'){
    3e66:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    3e6a:	75 17                	jne    3e83 <printf+0x14b>
        putc(fd, c);
    3e6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3e6f:	0f be c0             	movsbl %al,%eax
    3e72:	83 ec 08             	sub    $0x8,%esp
    3e75:	50                   	push   %eax
    3e76:	ff 75 08             	pushl  0x8(%ebp)
    3e79:	e8 ee fd ff ff       	call   3c6c <putc>
    3e7e:	83 c4 10             	add    $0x10,%esp
    3e81:	eb 25                	jmp    3ea8 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    3e83:	83 ec 08             	sub    $0x8,%esp
    3e86:	6a 25                	push   $0x25
    3e88:	ff 75 08             	pushl  0x8(%ebp)
    3e8b:	e8 dc fd ff ff       	call   3c6c <putc>
    3e90:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    3e93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3e96:	0f be c0             	movsbl %al,%eax
    3e99:	83 ec 08             	sub    $0x8,%esp
    3e9c:	50                   	push   %eax
    3e9d:	ff 75 08             	pushl  0x8(%ebp)
    3ea0:	e8 c7 fd ff ff       	call   3c6c <putc>
    3ea5:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    3ea8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    3eaf:	ff 45 f0             	incl   -0x10(%ebp)
    3eb2:	8b 55 0c             	mov    0xc(%ebp),%edx
    3eb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3eb8:	8d 04 02             	lea    (%edx,%eax,1),%eax
    3ebb:	8a 00                	mov    (%eax),%al
    3ebd:	84 c0                	test   %al,%al
    3ebf:	0f 85 95 fe ff ff    	jne    3d5a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    3ec5:	c9                   	leave  
    3ec6:	c3                   	ret    
    3ec7:	90                   	nop

00003ec8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    3ec8:	55                   	push   %ebp
    3ec9:	89 e5                	mov    %esp,%ebp
    3ecb:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    3ece:	8b 45 08             	mov    0x8(%ebp),%eax
    3ed1:	83 e8 08             	sub    $0x8,%eax
    3ed4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3ed7:	a1 68 58 00 00       	mov    0x5868,%eax
    3edc:	89 45 fc             	mov    %eax,-0x4(%ebp)
    3edf:	eb 24                	jmp    3f05 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    3ee1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3ee4:	8b 00                	mov    (%eax),%eax
    3ee6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    3ee9:	77 12                	ja     3efd <free+0x35>
    3eeb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3eee:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    3ef1:	77 24                	ja     3f17 <free+0x4f>
    3ef3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3ef6:	8b 00                	mov    (%eax),%eax
    3ef8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    3efb:	77 1a                	ja     3f17 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3efd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3f00:	8b 00                	mov    (%eax),%eax
    3f02:	89 45 fc             	mov    %eax,-0x4(%ebp)
    3f05:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3f08:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    3f0b:	76 d4                	jbe    3ee1 <free+0x19>
    3f0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3f10:	8b 00                	mov    (%eax),%eax
    3f12:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    3f15:	76 ca                	jbe    3ee1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    3f17:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3f1a:	8b 40 04             	mov    0x4(%eax),%eax
    3f1d:	c1 e0 03             	shl    $0x3,%eax
    3f20:	89 c2                	mov    %eax,%edx
    3f22:	03 55 f8             	add    -0x8(%ebp),%edx
    3f25:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3f28:	8b 00                	mov    (%eax),%eax
    3f2a:	39 c2                	cmp    %eax,%edx
    3f2c:	75 24                	jne    3f52 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
    3f2e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3f31:	8b 50 04             	mov    0x4(%eax),%edx
    3f34:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3f37:	8b 00                	mov    (%eax),%eax
    3f39:	8b 40 04             	mov    0x4(%eax),%eax
    3f3c:	01 c2                	add    %eax,%edx
    3f3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3f41:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    3f44:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3f47:	8b 00                	mov    (%eax),%eax
    3f49:	8b 10                	mov    (%eax),%edx
    3f4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3f4e:	89 10                	mov    %edx,(%eax)
    3f50:	eb 0a                	jmp    3f5c <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
    3f52:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3f55:	8b 10                	mov    (%eax),%edx
    3f57:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3f5a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    3f5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3f5f:	8b 40 04             	mov    0x4(%eax),%eax
    3f62:	c1 e0 03             	shl    $0x3,%eax
    3f65:	03 45 fc             	add    -0x4(%ebp),%eax
    3f68:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    3f6b:	75 20                	jne    3f8d <free+0xc5>
    p->s.size += bp->s.size;
    3f6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3f70:	8b 50 04             	mov    0x4(%eax),%edx
    3f73:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3f76:	8b 40 04             	mov    0x4(%eax),%eax
    3f79:	01 c2                	add    %eax,%edx
    3f7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3f7e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    3f81:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3f84:	8b 10                	mov    (%eax),%edx
    3f86:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3f89:	89 10                	mov    %edx,(%eax)
    3f8b:	eb 08                	jmp    3f95 <free+0xcd>
  } else
    p->s.ptr = bp;
    3f8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3f90:	8b 55 f8             	mov    -0x8(%ebp),%edx
    3f93:	89 10                	mov    %edx,(%eax)
  freep = p;
    3f95:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3f98:	a3 68 58 00 00       	mov    %eax,0x5868
}
    3f9d:	c9                   	leave  
    3f9e:	c3                   	ret    

00003f9f <morecore>:

static Header*
morecore(uint nu)
{
    3f9f:	55                   	push   %ebp
    3fa0:	89 e5                	mov    %esp,%ebp
    3fa2:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    3fa5:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    3fac:	77 07                	ja     3fb5 <morecore+0x16>
    nu = 4096;
    3fae:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    3fb5:	8b 45 08             	mov    0x8(%ebp),%eax
    3fb8:	c1 e0 03             	shl    $0x3,%eax
    3fbb:	83 ec 0c             	sub    $0xc,%esp
    3fbe:	50                   	push   %eax
    3fbf:	e8 90 fc ff ff       	call   3c54 <sbrk>
    3fc4:	83 c4 10             	add    $0x10,%esp
    3fc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    3fca:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    3fce:	75 07                	jne    3fd7 <morecore+0x38>
    return 0;
    3fd0:	b8 00 00 00 00       	mov    $0x0,%eax
    3fd5:	eb 26                	jmp    3ffd <morecore+0x5e>
  hp = (Header*)p;
    3fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3fda:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    3fdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3fe0:	8b 55 08             	mov    0x8(%ebp),%edx
    3fe3:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    3fe6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3fe9:	83 c0 08             	add    $0x8,%eax
    3fec:	83 ec 0c             	sub    $0xc,%esp
    3fef:	50                   	push   %eax
    3ff0:	e8 d3 fe ff ff       	call   3ec8 <free>
    3ff5:	83 c4 10             	add    $0x10,%esp
  return freep;
    3ff8:	a1 68 58 00 00       	mov    0x5868,%eax
}
    3ffd:	c9                   	leave  
    3ffe:	c3                   	ret    

00003fff <malloc>:

void*
malloc(uint nbytes)
{
    3fff:	55                   	push   %ebp
    4000:	89 e5                	mov    %esp,%ebp
    4002:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    4005:	8b 45 08             	mov    0x8(%ebp),%eax
    4008:	83 c0 07             	add    $0x7,%eax
    400b:	c1 e8 03             	shr    $0x3,%eax
    400e:	40                   	inc    %eax
    400f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    4012:	a1 68 58 00 00       	mov    0x5868,%eax
    4017:	89 45 f0             	mov    %eax,-0x10(%ebp)
    401a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    401e:	75 23                	jne    4043 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
    4020:	c7 45 f0 60 58 00 00 	movl   $0x5860,-0x10(%ebp)
    4027:	8b 45 f0             	mov    -0x10(%ebp),%eax
    402a:	a3 68 58 00 00       	mov    %eax,0x5868
    402f:	a1 68 58 00 00       	mov    0x5868,%eax
    4034:	a3 60 58 00 00       	mov    %eax,0x5860
    base.s.size = 0;
    4039:	c7 05 64 58 00 00 00 	movl   $0x0,0x5864
    4040:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4043:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4046:	8b 00                	mov    (%eax),%eax
    4048:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    404b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    404e:	8b 40 04             	mov    0x4(%eax),%eax
    4051:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    4054:	72 4d                	jb     40a3 <malloc+0xa4>
      if(p->s.size == nunits)
    4056:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4059:	8b 40 04             	mov    0x4(%eax),%eax
    405c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    405f:	75 0c                	jne    406d <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
    4061:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4064:	8b 10                	mov    (%eax),%edx
    4066:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4069:	89 10                	mov    %edx,(%eax)
    406b:	eb 26                	jmp    4093 <malloc+0x94>
      else {
        p->s.size -= nunits;
    406d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4070:	8b 40 04             	mov    0x4(%eax),%eax
    4073:	89 c2                	mov    %eax,%edx
    4075:	2b 55 ec             	sub    -0x14(%ebp),%edx
    4078:	8b 45 f4             	mov    -0xc(%ebp),%eax
    407b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    407e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4081:	8b 40 04             	mov    0x4(%eax),%eax
    4084:	c1 e0 03             	shl    $0x3,%eax
    4087:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    408a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    408d:	8b 55 ec             	mov    -0x14(%ebp),%edx
    4090:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    4093:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4096:	a3 68 58 00 00       	mov    %eax,0x5868
      return (void*)(p + 1);
    409b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    409e:	83 c0 08             	add    $0x8,%eax
    40a1:	eb 3b                	jmp    40de <malloc+0xdf>
    }
    if(p == freep)
    40a3:	a1 68 58 00 00       	mov    0x5868,%eax
    40a8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    40ab:	75 1e                	jne    40cb <malloc+0xcc>
      if((p = morecore(nunits)) == 0)
    40ad:	83 ec 0c             	sub    $0xc,%esp
    40b0:	ff 75 ec             	pushl  -0x14(%ebp)
    40b3:	e8 e7 fe ff ff       	call   3f9f <morecore>
    40b8:	83 c4 10             	add    $0x10,%esp
    40bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    40be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    40c2:	75 07                	jne    40cb <malloc+0xcc>
        return 0;
    40c4:	b8 00 00 00 00       	mov    $0x0,%eax
    40c9:	eb 13                	jmp    40de <malloc+0xdf>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    40cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    40ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
    40d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    40d4:	8b 00                	mov    (%eax),%eax
    40d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    40d9:	e9 6d ff ff ff       	jmp    404b <malloc+0x4c>
}
    40de:	c9                   	leave  
    40df:	c3                   	ret    
