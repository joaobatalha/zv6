#include "types.h"
#include "stat.h"
#include "user.h"

void
pinode(char *devnum, char *inum)
{
	struct stat st;
	int fd;
	int iint, dev;

	dev = atoi(devnum);
	iint = atoi(inum);

	if ((fd = iopen(dev, iint)) < 0) {
		printf(2, "pinode: cannot open inode %d on dev %d\n", iint, dev);
		return;
	}

	if (fstat(fd, &st) < 0) {
		printf(2, "pinode: cannot stat inode %d on dev %d (fd=%d)\n", iint, dev, fd);
		close(fd);
		return;
	}

	close(fd);

	printf(1, "%d  %d  %d  %x\n", iint, st.child1, st.child2, st.checksum);
}

int
main(int argc, char *argv[])
{
  int i;

	if (argc < 2 || (argc & 1) != 1) {
		printf(1, "Usage: pinode ([DEV] [FILE/DIR])+\n");
		exit();
	}

	for (i = 1; i < argc; i+=2)
		pinode(argv[i], argv[i+1]);

  exit();
}
