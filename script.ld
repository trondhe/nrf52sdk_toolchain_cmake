/* Linker script to configure memory regions. */

/* Linker script to configure memory regions. */

SEARCH_DIR(.)
/*GROUP(-lgcc -lc -lnosys)*/

MEMORY
{
  FLASH (wx) : ORIGIN = 0x00000000, LENGTH = 0x0007F000
  RAM (rwx) : ORIGIN = 0x20000000, LENGTH = 0x0000F000
}

INCLUDE "nrf_common.ld"