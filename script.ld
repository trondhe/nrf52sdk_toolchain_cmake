
MEMORY
{
  FLASH (wx) : ORIGIN = 0x26000, LENGTH = 0x5a000
  RAM (rwx) : ORIGIN = 0x200057b8, LENGTH = 0xa848
}


INCLUDE "nrf_common.ld"