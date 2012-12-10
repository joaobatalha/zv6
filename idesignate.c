#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"

int
main(int argc, char *argv[])
{

  if(argc != 3){
    printf(1, "usage: idesignate [PATH] [IMPORTANCE]\n");
    exit();
  }

  duplicate(argv[1], atoi(argv[2]));
  exit();
}
