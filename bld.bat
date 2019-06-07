@echo off
rd /s /q build
set ARM_TOOLCHAIN_PATH=C:/Programs/gnu_arm/8_2018_q4
set NRF5_SDK_PATH=C:/ws/nrf52sdk_toolchain_cmake/
set NRFJPROG=C:/Program Files/Nordic Semiconductor/nrf5x/bin/nrfjprog.exe
set NRF_CHIP=nrf52832
set NRF_BOARD=pca10040
set NRF_SOFTDEVICE=s132
cmake -DCMAKE_TOOLCHAIN_FILE=C:/ws/nrf52sdk_toolchain_cmake/cmake/toolchain/nrf52_toolchain.cmake -Bbuild -GNinja .