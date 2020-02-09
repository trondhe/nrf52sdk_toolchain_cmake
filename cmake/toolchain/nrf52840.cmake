# Specific settings for Nrf52840

add_compile_definitions(
    NRF52840_XXAA
)

add_compile_options(
    -mfloat-abi=softfp
)

set(NRF_CHIP_HEADER_PATHS 
    "${NRF5_SDK_PATH}/components/softdevice/mbr/nrf52840/headers"
    "${NRF5_SDK_PATH}/config/nrf52840/config"
)

set(COMPILER_LIBRARY_PATH_COMPONENT "/thumb/v7e-m+fp/softfp/")