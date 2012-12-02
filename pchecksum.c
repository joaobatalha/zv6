#include "types.h"
#include "stat.h"
#include "user.h"

void
pchecksum(char *devnum, char *inum)
{
	int checksum;
	int iint, dev;

	dev = atoi(devnum);
	iint = atoi(inum);

	if ((checksum = ichecksum(dev, iint)) < 0) {
		printf(2, "checksum: cannont open inode %d on dev %d\n", iint, dev);
		return;
	}
	
	printf(1, "%d  %d:  %x\n", dev, iint, checksum);
}

int
main(int argc, char *argv[])
{
  int i;

	if (argc < 2 || (argc & 1) != 1) {
		printf(1, "Usage: checksum ([DEV] [FILE/DIR])+\n");
		exit();
	}

	printf(1, "%s\n", argv[0]);

	for (i = 1; i < argc; i+=2)
		pchecksum(argv[i], argv[i+1]);

  exit();
}
