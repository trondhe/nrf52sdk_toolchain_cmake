cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

project(nrf_sdk C CXX ASM)

set(BLINKY_SRC 
    ${NRF5_SDK_PATH}/components/boards/boards.c
    ${NRF5_SDK_PATH}/components/libraries/atomic/nrf_atomic.c
    ${NRF5_SDK_PATH}/components/libraries/balloc/nrf_balloc.c
    ${NRF5_SDK_PATH}/components/libraries/experimental_section_vars/nrf_section_iter.c
    ${NRF5_SDK_PATH}/components/libraries/log/src/nrf_log_frontend.c
    ${NRF5_SDK_PATH}/components/libraries/log/src/nrf_log_str_formatter.c
    ${NRF5_SDK_PATH}/components/libraries/memobj/nrf_memobj.c
    ${NRF5_SDK_PATH}/components/libraries/ringbuf/nrf_ringbuf.c
    ${NRF5_SDK_PATH}/components/libraries/strerror/nrf_strerror.c
    ${NRF5_SDK_PATH}/components/libraries/util/app_error.c
    ${NRF5_SDK_PATH}/components/libraries/util/app_error_handler_gcc.c
    ${NRF5_SDK_PATH}/components/libraries/util/app_error_weak.c
    ${NRF5_SDK_PATH}/components/libraries/util/app_util_platform.c
    ${NRF5_SDK_PATH}/components/libraries/util/nrf_assert.c
    ${NRF5_SDK_PATH}/components/softdevice/common/nrf_sdh.c
    ${NRF5_SDK_PATH}/components/softdevice/common/nrf_sdh_soc.c
    ${NRF5_SDK_PATH}/external/fprintf/nrf_fprintf.c
    ${NRF5_SDK_PATH}/external/fprintf/nrf_fprintf_format.c
    ${NRF5_SDK_PATH}/modules/nrfx/mdk/gcc_startup_nrf52.S
    ${NRF5_SDK_PATH}/modules/nrfx/mdk/system_nrf52.c
    ${NRF5_SDK_PATH}/modules/nrfx/soc/nrfx_atomic.c
)

set(BLINKY_HEADERS
    ${NRF5_SDK_PATH}/components
    ${NRF5_SDK_PATH}/components/boards
    ${NRF5_SDK_PATH}/components/libraries/atomic
    ${NRF5_SDK_PATH}/components/libraries/balloc
    ${NRF5_SDK_PATH}/components/libraries/bsp
    ${NRF5_SDK_PATH}/components/libraries/delay
    ${NRF5_SDK_PATH}/components/libraries/experimental_section_vars
    ${NRF5_SDK_PATH}/components/libraries/log
    ${NRF5_SDK_PATH}/components/libraries/log/src
    ${NRF5_SDK_PATH}/components/libraries/memobj
    ${NRF5_SDK_PATH}/components/libraries/ringbuf
    ${NRF5_SDK_PATH}/components/libraries/strerror
    ${NRF5_SDK_PATH}/components/libraries/util
    ${NRF5_SDK_PATH}/components/softdevice/common
    ${NRF5_SDK_PATH}/components/softdevice/s132/headers
    ${NRF5_SDK_PATH}/components/softdevice/s132/headers/nrf52
    ${NRF5_SDK_PATH}/components/toolchain/cmsis/include
    ${NRF5_SDK_PATH}/external/fprintf
    ${NRF5_SDK_PATH}/integration/nrfx
    ${NRF5_SDK_PATH}/modules/nrfx
    ${NRF5_SDK_PATH}/modules/nrfx/hal
    ${NRF5_SDK_PATH}/modules/nrfx/mdk
)

add_library(${PROJECT_NAME} STATIC ${BLINKY_SRC})

target_include_directories(${PROJECT_NAME}
    PUBLIC
        ${NRF_CHIP_HEADER_PATHS}
        ${NRF_SOFTDEVICE_HEADER_PATHS}
        ${BLINKY_HEADERS}
)


set(NRF_EXE blinky)

add_executable(${NRF_EXE}
    myexe.cpp
    ${NRF_STARTUP_SRC}
)

target_link_libraries(${NRF_EXE}
    PUBLIC
        ${PROJECT_NAME}
)

add_custom_command(TARGET ${NRF_EXE}
POST_BUILD
COMMAND ${ARM_TOOLCHAIN_PATH}/bin/arm-none-eabi-objcopy -O binary ${NRF_EXE}.out "${NRF_EXE}.bin"
COMMAND ${ARM_TOOLCHAIN_PATH}/bin/arm-none-eabi-objcopy -O ihex ${NRF_EXE}.out "${NRF_EXE}.hex"
COMMENT "convert executable to hex file")

add_custom_target(flash_build
COMMAND ${NRFJPROG} -f NRF52 --program ${NRF_EXE}.hex --verify --sectorerase
DEPENDS ${NRF_EXE}
COMMENT "uploading ${NRF_EXE}.hex"
)

add_custom_target(flash_softdevice
COMMAND ${NRFJPROG} -f NRF52 --program ${NRF_SOFTDEVICE_PATH} --verify --sectorerase
COMMAND ${NRFJPROG} --reset -f NRF52
COMMENT "flashing softdevice ${NRF_SOFTDEVICE}"
)

add_custom_target(nrf_reset
COMMAND ${NRFJPROG} --reset -f NRF52
COMMENT "reseting nrf chip"
)