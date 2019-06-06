#pca10040 for nrf52810 and nrf52832
#pca10056 for nrf52811 and nrf52840

#s112 for nrf52810, nrf52811, nrf52832
#s132 for nrf52810, nrf52832
#s140 for nrf52840

if (NOT ARM_NONE_EABI_TOOLCHAIN_PATH)
    message(FATAL_ERROR "The path to the arm-none-eabi-gcc toolchain (ARM_NONE_EABI_TOOLCHAIN_PATH) must be set.")
endif ()

if (NOT NRF5_SDK_PATH)
    message(FATAL_ERROR "The path to the nRF5 SDK (NRF5_SDK_PATH) must be set.")
endif ()

if (NOT NRFJPROG)
    message(FATAL_ERROR "The path to the nrfjprog utility (NRFJPROG) must be set.")
endif ()

if(NRF_CHIP MATCHES "nrf52810")
elseif(NRF_CHIP MATCHES "nrf52811")
elseif(NRF_CHIP MATCHES "nrf52832")
elseif(NRF_CHIP MATCHES "nrf52840")
else()
    message(FATAL_ERROR "Non correct value set for NRF_CHIP")
endif()

if(NRF_SOFTDEVICE MATCHES "s112")
    add_compile_definitions(
        BOARD_PCA10040
        S112
        NRF52810_XXAA
    )
    set(NRF_SOFTDEVICE_PATH "${NRF5_SDK_PATH}/components/softdevice/s112/hex/s112_nrf52_6.1.1_softdevice.hex")
    set(NRF5_LINKER_SCRIPT "${CMAKE_SOURCE_DIR}/components/softdevice/s112/toolchain/armgcc/armgcc_s112_nrf52810_xxaa.ld")
elseif(NRF_SOFTDEVICE MATCHES "s132")
    add_compile_definitions(
        BOARD_PCA10040
        S132
        NRF52832_XXAA
    )
    set(NRF_SOFTDEVICE_PATH "${NRF5_SDK_PATH}/components/softdevice/s132/hex/s132_nrf52_6.1.1_softdevice.hex")
    set(NRF5_LINKER_SCRIPT "${CMAKE_SOURCE_DIR}/components/softdevice/s132/toolchain/armgcc/armgcc_s132_nrf52832_xxaa.ld")
elseif(NRF_SOFTDEVICE MATCHES "s140")
    add_compile_definitions(
        BOARD_PCA10056
        S140
        NRF52840_XXAA
    )
    set(NRF_SOFTDEVICE_PATH "${NRF5_SDK_PATH}/components/softdevice/s140/hex/s140_nrf52_6.1.1_softdevice.hex")
    set(NRF5_LINKER_SCRIPT "${CMAKE_SOURCE_DIR}/components/softdevice/s132/toolchain/armgcc/armgcc_s132_nrf52832_xxaa.ld")
else()
    message(FATAL_ERROR "Non correct value set for NRF_SOFTDEVICE [s112, s132, s140]")
endif()

add_compile_definitions(
    CONFIG_GPIO_AS_PINRESET
    FLOAT_ABI_HARD
    NRF52
    NRF52_PAN_74
    NRF_SD_BLE_API_VERSION=6
    SOFTDEVICE_PRESENT
    SWI_DISABLE0
)

add_compile_options(
    -mcpu=cortex-m4
    -mthumb
    -mabi=aapcs
    -Wall
    -mfloat-abi=hard
    -mfpu=fpv4-sp-d16
)

add_link_options(
    -X
    --omagic
    -eReset_Handler
    --defsym=__vfprintf=__vfprintf_long
    --defsym=__vfscanf=__vfscanf_long
    -EL
    --gc-sections
    --emit-relocs
    --print-memory-usage
    -T${NRF5_LINKER_SCRIPT}
)

set(CMAKE_C_COMPILER "${ARM_NONE_EABI_TOOLCHAIN_PATH}/bin/arm-none-eabi-gcc")
set(CMAKE_CXX_COMPILER "${ARM_NONE_EABI_TOOLCHAIN_PATH}/bin/arm-none-eabi-c++")
set(CMAKE_ASM_COMPILER "${ARM_NONE_EABI_TOOLCHAIN_PATH}/bin/arm-none-eabi-gcc")


set(CMAKE_C_LINK_EXECUTABLE "${CMAKE_C_COMPILER} <LINK_FLAGS> <OBJECTS> -o <TARGET>")
set(CMAKE_CXX_LINK_EXECUTABLE "${CMAKE_C_COMPILER} <LINK_FLAGS> <OBJECTS> -lstdc++ -o <TARGET>")