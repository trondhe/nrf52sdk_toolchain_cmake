#pca10040 for nrf52810 and nrf52832
#pca10056 for nrf52811 and nrf52840

#s112 for nrf52810, nrf52811, nrf52832
#s132 for nrf52810, nrf52832
#s140 for nrf52840

# Set environment variables to cmake variables

set(CMAKE_C_COMPILER_WORKS On)
set(CMAKE_CXX_COMPILER_WORKS On)

if(NOT DEFINED ENV{ARM_TOOLCHAIN_PATH})
    message(FATAL_ERROR "The path to the arm-none-eabi-gcc toolchain (ARM_TOOLCHAIN_PATH) must be set.")
endif ()

if(NOT DEFINED ENV{NRF5_SDK_PATH})
    message(FATAL_ERROR "The path to the nRF5 SDK (NRF5_SDK_PATH) must be set.")
endif ()

if(NOT DEFINED ENV{NRFJPROG})
    message(FATAL_ERROR "The path to the nrfjprog utility (NRFJPROG) must be set.")
endif ()

if(NOT DEFINED ENV{NRF_CHIP})
    message(FATAL_ERROR "The path to the nrfjprog utility (NRFJPROG) must be set.")
endif ()

if(DEFINED ENV{NRF_BOARD})
    set(NRF_BOARD "$ENV{NRF_BOARD}")
endif()

if(DEFINED ENV{NRF_SOFTDEVICE})
    set(NRF_SOFTDEVICE "$ENV{NRF_SOFTDEVICE}")
endif()

file(TO_CMAKE_PATH "$ENV{ARM_TOOLCHAIN_PATH}" ARM_TOOLCHAIN_PATH)
file(TO_CMAKE_PATH "$ENV{NRF5_SDK_PATH}" NRF5_SDK_PATH)
file(TO_CMAKE_PATH "$ENV{NRFJPROG}" NRFJPROG)

set(NRF_CHIP "$ENV{NRF_CHIP}")

# Check variable values and set corresponding values
if(NRF_CHIP MATCHES "nrf52810")
    add_compile_definitions(
        NRF52810_XXAA
    )
    set(COMPILER_LIBRARY_PATH_COMPONENT "/thumb/v7e-m+fp/softfp/")

elseif(NRF_CHIP MATCHES "nrf52811")
    add_compile_definitions(
        NRF52811_XXAA
    )
    set(COMPILER_LIBRARY_PATH_COMPONENT "/thumb/v7e-m+fp/softfp/")

elseif(NRF_CHIP MATCHES "nrf52832")
    add_compile_definitions(
        NRF52832_XXAA
    )
    set(COMPILER_LIBRARY_PATH_COMPONENT "/thumb/v7e-m+fp/softfp/")

elseif(NRF_CHIP MATCHES "nrf52840")
    add_compile_definitions(
        NRF52840_XXAA
    )
    set(COMPILER_LIBRARY_PATH_COMPONENT "/thumb/v7e-m+fp/softfp/")

else()
    message(FATAL_ERROR "Non correct value set for NRF_CHIP")
endif()

if(DEFINED NRF_BOARD)
    if(NRF_BOARD MATCHES "pca10040")
        add_compile_definitions(
            BOARD_PCA10040
        )
    elseif(NRF_BOARD MATCHES "pca10056")
        add_compile_definitions(
            BOARD_PCA10056
        )
    else()
        message(FATAL_ERROR "NRF_BOARD only supports pca10040 and pca10056")
    endif()
endif()

if(NRF_SOFTDEVICE MATCHES "s112")
    add_compile_definitions(
        S112
    )
    set(NRF_SOFTDEVICE_PATH "${NRF5_SDK_PATH}/components/softdevice/s112/hex/s112_nrf52_6.1.1_softdevice.hex")
    set(NRF5_LINKER_SCRIPT "${NRF5_SDK_PATH}/components/softdevice/s112/toolchain/armgcc/armgcc_s112_nrf52810_xxaa.ld")
elseif(NRF_SOFTDEVICE MATCHES "s132")
    add_compile_definitions(
        S132
    )
    set(NRF_SOFTDEVICE_PATH "${NRF5_SDK_PATH}/components/softdevice/s132/hex/s132_nrf52_6.1.1_softdevice.hex")
    set(NRF5_LINKER_SCRIPT "${NRF5_SDK_PATH}/components/softdevice/s132/toolchain/armgcc/armgcc_s132_nrf52832_xxaa.ld")
elseif(NRF_SOFTDEVICE MATCHES "s140")
    add_compile_definitions(
        S140
    )
    set(NRF_SOFTDEVICE_PATH "${NRF5_SDK_PATH}/components/softdevice/s140/hex/s140_nrf52_6.1.1_softdevice.hex")
    set(NRF5_LINKER_SCRIPT "${NRF5_SDK_PATH}/components/softdevice/s132/toolchain/armgcc/armgcc_s132_nrf52832_xxaa.ld")
else()
    message(FATAL_ERROR "Non correct value set for NRF_SOFTDEVICE [s112, s132, s140]")
endif()

if(CMAKE_HOST_SYSTEM_NAME MATCHES "Windows")
    set(EXECUTABLE_EXTENSION ".exe")
else()
    set(EXECUTABLE_EXTENSION "")
endif()

set(CMAKE_SYSTEM_NAME Generic)

file(TO_CMAKE_PATH "${ARM_TOOLCHAIN_PATH}/bin/arm-none-eabi-gcc${EXECUTABLE_EXTENSION}" CMAKE_C_COMPILER)
file(TO_CMAKE_PATH "${ARM_TOOLCHAIN_PATH}/bin/arm-none-eabi-c++${EXECUTABLE_EXTENSION}" CMAKE_CXX_COMPILER)
file(TO_CMAKE_PATH "${ARM_TOOLCHAIN_PATH}/bin/arm-none-eabi-gcc${EXECUTABLE_EXTENSION}" CMAKE_ASM_COMPILER)
file(TO_CMAKE_PATH "${ARM_TOOLCHAIN_PATH}/bin/arm-none-eabi-ld${EXECUTABLE_EXTENSION}" CMAKE_LINKER)

add_compile_definitions(
    CONFIG_GPIO_AS_PINRESET
    FLOAT_ABI_SOFT
    NRF52
    NRF52_PAN_74
    NRF_SD_BLE_API_VERSION=6
    SOFTDEVICE_PRESENT
    SWI_DISABLE0
)

set(CMAKE_STATIC_LINKER_FLAGS_INIT "")
set(CMAKE_EXE_LINKER_FLAGS_INIT "")

add_compile_options(
    -mcpu=cortex-m4
    -mlittle-endian
    -mthumb
    -mabi=aapcs
    -Wall
    -mfloat-abi=softfp
    -mfpu=auto
    -mtp=soft
    -munaligned-access
    -fno-builtin
    -fdata-sections
    -ffunction-sections
    -fomit-frame-pointer
    -fno-strict-aliasing
    -fshort-enums
    --specs=nano.specs
)  

set(NRF5_LINKER_SCRIPT "${PROJECT_SOURCE_DIR}/script.ld")
set(NRF5_LINKER_SCRIPT2 "${PROJECT_SOURCE_DIR}/modules/nrfx/mdk/nrf52_common.ld")

add_link_options(
    "LINKER:--omagic,
    -eReset_Handler,
    -EL,
    -nostdlib,
    --gc-sections,
    --emit-relocs,
    --print-memory-usage,
    -L${NRF5_SDK_PATH}/modules/nrfx/mdk,
    -L${ARM_TOOLCHAIN_PATH}/lib/gcc/arm-none-eabi/8.2.1/${COMPILER_LIBRARY_PATH_COMPONENT},
    -L${ARM_TOOLCHAIN_PATH}/arm-none-eabi/lib/${COMPILER_LIBRARY_PATH_COMPONENT},
    -T${NRF5_LINKER_SCRIPT},
    -T${NRF5_LINKER_SCRIPT2},
    -Map=output.map"
)
# --print-memory-usage,
link_libraries(
    -lc
    -lnosys
    -lm
    )

set(CMAKE_C_LINK_EXECUTABLE "${CMAKE_C_COMPILER} <FLAGS> <LINK_FLAGS> <OBJECTS>  -o <TARGET> <LINK_LIBRARIES>")
# set(CMAKE_C_LINK_EXECUTABLE "${CMAKE_CXX_COMPILER} <LINK_FLAGS> <OBJECTS> -o <TARGET>")
set(CMAKE_CXX_LINK_EXECUTABLE "${CMAKE_C_COMPILER} <FLAGS> <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> <OBJECTS>  -o <TARGET> <LINK_LIBRARIES>")
# set(CMAKE_CXX_LINK_EXECUTABLE "${CMAKE_CXX_COMPILER} <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES>")