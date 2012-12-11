#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"

int
main(int argc, char *argv[])
{

  int r;
  if(argc != 3){
    printf(1, "usage: idesignate [PATH] [IMPORTANCE]\n");
    exit();
  }
  if(hasdittos(argv[1]) == 0){
    r = duplicate(argv[1], atoi(argv[2]));
    if(r == 0){
	printf(1,"Something went wrong with duplicate\n"); 
    }
  }
  else{
    printf(1, "Inode already has ditto inodes\n");
  }


  exit();
}
