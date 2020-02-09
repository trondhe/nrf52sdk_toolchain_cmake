#pca10040 for nrf52810 and nrf52832
#pca10056 for nrf52811 and nrf52840

#s112 for nrf52810, nrf52811, nrf52832
#s132 for nrf52810, nrf52832
#s140 for nrf52840

include("${CMAKE_CURRENT_LIST_DIR}/support_functions.cmake")

# Set environment variables to cmake variables
checkRequiredVariables()

# Clear any variable to avoid duplicate settings
set(NRF_COMPILE_DEFINES "")
set(NRF_COMPILE_OPTIONS "")
set(NRF_LINK_OPTIONS "")
set(NRF_CHIP_HEADER_PATHS "")
set(COMPILER_LIBRARY_PATH_COMPONENT "")

set(GNU_TARGET_TRIPLET "arm-none-eabi")

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_EXECUTABLE_SUFFIX_C ".out")
set(CMAKE_EXECUTABLE_SUFFIX_CXX ".out")
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# Add mcu specific settings to this scope
if(NRF_CHIP MATCHES "nrf52810")
    include("${CMAKE_CURRENT_LIST_DIR}/nrf52810.cmake")
elseif(NRF_CHIP MATCHES "nrf52811")
    include("${CMAKE_CURRENT_LIST_DIR}/nrf52811.cmake")
elseif(NRF_CHIP MATCHES "nrf52832")
    include("${CMAKE_CURRENT_LIST_DIR}/nrf52832.cmake")
elseif(NRF_CHIP MATCHES "nrf52840")
    include("${CMAKE_CURRENT_LIST_DIR}/nrf52840.cmake")
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
    endif()
endif()

if(NRF_SOFTDEVICE MATCHES "s112")
    set(NRF_SOFTDEVICE_HEADER_PATHS
        "${PROJECT_SOURCE_DIR}/components/softdevice/s112/headers"
        "${PROJECT_SOURCE_DIR}/components/softdevice/s112/headers/nrf52"
    )
    add_compile_definitions(
        SOFTDEVICE_PRESENT
        S112
    )
    set(NRF_SOFTDEVICE_PATH "${NRF5_SDK_PATH}/components/softdevice/s112/hex/s112_nrf52_6.1.1_softdevice.hex")
    set(NRF5_LINKER_SCRIPT "${NRF5_SDK_PATH}/components/softdevice/s112/toolchain/armgcc/armgcc_s112_nrf52810_xxaa.ld")

elseif(NRF_SOFTDEVICE MATCHES "s132")
    set(NRF_SOFTDEVICE_HEADER_PATHS
        "${NRF5_SDK_PATH}/components/softdevice/s132/headers/"
        "${NRF5_SDK_PATH}/components/softdevice/s132/headers/nrf52"
    )
    add_compile_definitions(
        SOFTDEVICE_PRESENT
        S132
    )
    set(NRF_SOFTDEVICE_PATH "${NRF5_SDK_PATH}/components/softdevice/s132/hex/s132_nrf52_6.1.1_softdevice.hex")
    set(NRF5_LINKER_SCRIPT "${NRF5_SDK_PATH}/components/softdevice/s132/toolchain/armgcc/armgcc_s132_nrf52832_xxaa.ld")

elseif(NRF_SOFTDEVICE MATCHES "s140")
    set(NRF_SOFTDEVICE_HEADER_PATHS
        "${NRF5_SDK_PATH}/components/softdevice/s140/headers"
        "${NRF5_SDK_PATH}/components/softdevice/s140/headers/nrf52"
    )
    add_compile_definitions(
        SOFTDEVICE_PRESENT
        S140
    )
    set(NRF_SOFTDEVICE_PATH "${NRF5_SDK_PATH}/components/softdevice/s140/hex/s140_nrf52_6.1.1_softdevice.hex")
    set(NRF5_LINKER_SCRIPT "${NRF5_SDK_PATH}/components/softdevice/s132/toolchain/armgcc/armgcc_s132_nrf52832_xxaa.ld")
    
else()
    set(NRF_SOFTDEVICE_HEADER_PATHS
        "${NRF5_SDK_PATH}/components/drivers_nrf/nrf_soc_nosd"
    )
endif()

add_compile_definitions(
    CONFIG_GPIO_AS_PINRESET
    FLOAT_ABI_SOFT
    NRF52
    NRF52_PAN_74
    NRF_SD_BLE_API_VERSION=6
)

add_compile_options(
    -Wall
    -mcpu=cortex-m4
    -mlittle-endian
    -mthumb
    -mabi=aapcs
    -mtp=auto
    -munaligned-access
    -fno-builtin
    -fdata-sections
    -ffunction-sections
    -fomit-frame-pointer
    -fno-strict-aliasing
    -fshort-enums
    --specs=nano.specs
    --specs=nosys.specs
)

set(CMAKE_C_FLAGS_DEBUG "-Og -g" CACHE INTERNAL "c compiler flags debug")
set(CMAKE_CXX_FLAGS_DEBUG "-Og -g" CACHE INTERNAL "cxx compiler flags debug")
set(CMAKE_ASM_FLAGS_DEBUG "-g" CACHE INTERNAL "asm compiler flags debug")
set(CMAKE_EXE_LINKER_FLAGS_DEBUG "" CACHE INTERNAL "linker flags debug")

set(CMAKE_C_FLAGS_RELEASE "-Os -flto" CACHE INTERNAL "c compiler flags release")
set(CMAKE_CXX_FLAGS_RELEASE "-Os -flto" CACHE INTERNAL "cxx compiler flags release")
set(CMAKE_ASM_FLAGS_RELEASE "" CACHE INTERNAL "asm compiler flags release")
set(CMAKE_EXE_LINKER_FLAGS_RELEASE "-flto" CACHE INTERNAL "linker flags release")

if(CMAKE_HOST_SYSTEM_NAME MATCHES "Windows")
    set(EXECUTABLE_EXTENSION ".exe")
else()
    set(EXECUTABLE_EXTENSION "")
endif()

set(CMAKE_C_COMPILER    "${ARM_TOOLCHAIN_PATH}/bin/${GNU_TARGET_TRIPLET}-gcc${EXECUTABLE_EXTENSION}" CACHE INTERNAL "C compiler")
set(CMAKE_CXX_COMPILER  "${ARM_TOOLCHAIN_PATH}/bin/${GNU_TARGET_TRIPLET}-c++${EXECUTABLE_EXTENSION}" CACHE INTERNAL "Cpp compiler")
set(CMAKE_ASM_COMPILER  "${ARM_TOOLCHAIN_PATH}/bin/${GNU_TARGET_TRIPLET}-gcc${EXECUTABLE_EXTENSION}" CACHE INTERNAL "Assembly compiler")
set(CMAKE_LINKER        "${ARM_TOOLCHAIN_PATH}/bin/${GNU_TARGET_TRIPLET}-ld${EXECUTABLE_EXTENSION}" CACHE INTERNAL "Linker")

set(CMAKE_OBJCOPY       "${ARM_TOOLCHAIN_PATH}/bin/${GNU_TARGET_TRIPLET}-objcopy${EXECUTABLE_EXTENSION}" CACHE INTERNAL "Objcopy tool")
set(CMAKE_OBJDUMP       "${ARM_TOOLCHAIN_PATH}/bin/${GNU_TARGET_TRIPLET}-objdump${EXECUTABLE_EXTENSION}" CACHE INTERNAL "Objdump tool")
set(CMAKE_SIZE          "${ARM_TOOLCHAIN_PATH}/bin/${GNU_TARGET_TRIPLET}-size${EXECUTABLE_EXTENSION}" CACHE INTERNAL "Size tool")
set(CMAKE_DEBUGER       "${ARM_TOOLCHAIN_PATH}/bin/${GNU_TARGET_TRIPLET}-gdb${EXECUTABLE_EXTENSION}" CACHE INTERNAL "Debuger")
set(CMAKE_CPPFILT       "${ARM_TOOLCHAIN_PATH}/bin/${GNU_TARGET_TRIPLET}-c++filt${EXECUTABLE_EXTENSION}" CACHE INTERNAL "Cpp demangler tool")

set(CMAKE_STATIC_LINKER_FLAGS_INIT "")
set(CMAKE_EXE_LINKER_FLAGS_INIT "")

set(NRF5_LINKER_SCRIPT "${NRF5_SDK_PATH}/script.ld")

set(NRF_LINK_OPTIONS "--omagic -EL -nostdlib --gc-sections --emit-relocs --print-memory-usage -L${NRF5_SDK_PATH}/modules/nrfx/mdk -L${ARM_LIBRARY_PATH}/${COMPILER_LIBRARY_PATH_COMPONENT} -L${ARM_TOOLCHAIN_PATH}/${GNU_TARGET_TRIPLET}/lib/${COMPILER_LIBRARY_PATH_COMPONENT} -T${NRF5_LINKER_SCRIPT} -Map=output.map")

set(NRF_LINK_LIBRARIES "--start-group -lc -lnosys -lm -lgcc --end-group")

set(CMAKE_C_LINK_EXECUTABLE     "${CMAKE_LINKER} ${NRF_LINK_OPTIONS} <FLAGS> <LINK_FLAGS> <OBJECTS>  -o <TARGET> ${NRF_LINK_LIBRARIES} <LINK_LIBRARIES>")
set(CMAKE_CXX_LINK_EXECUTABLE   "${CMAKE_LINKER} ${NRF_LINK_OPTIONS} <FLAGS> <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> <OBJECTS>  -o <TARGET> ${NRF_LINK_LIBRARIES} <LINK_LIBRARIES>")

set(NRF_STARTUP_SRC 
    "${NRF5_SDK_PATH}/modules/nrfx/mdk/system_nrf52.c"
    "${NRF5_SDK_PATH}/modules/nrfx/mdk/gcc_startup_nrf52.S"
)
