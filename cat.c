#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"

char buf[512];

void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
    write(1, buf, n);
  if(n < 0){
    printf(1, "cat: read error\n");
    exit();
  }
}

int
main(int argc, char *argv[])
{
  int fd;

  if(argc <= 1){
    cat(0);
    exit();
  }

	if (argc == 2) {
		fd = open(argv[1], 0);
		if(fd == E_CORRUPTED){
      printf(1, "cat: %s is corrupted\n", argv[1]);
      exit();
   	} else if (fd < 0) {
     	printf(1, "cat: cannot open %s\n", argv[1]);
     	exit();
		}
   	cat(fd);
   	close(fd);
	} else if (argc == 3) {
		if (argv[1][0] == '-' && argv[1][1] == 'f') {
			fd = forceopen(argv[2], 0);
			if (fd < 0) {
 	    	printf(1, "cat: cannot open %s\n", argv[2]);
 	    	exit();
			}
 	  	cat(fd);
 	  	close(fd);
		} else {
      printf(1, "usage: cat [-f]? [PATH]\n");
      exit();
		}
	}

  exit();
}
