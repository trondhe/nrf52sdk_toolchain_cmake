# Specific settings for Nrf52832

add_compile_definitions(
    NRF52832_XXAA
)

add_compile_options(
    -mfloat-abi=softfp
)

set(NRF_CHIP_HEADER_PATHS 
    "${NRF5_SDK_PATH}/components/softdevice/mbr/nrf52832/headers"
    "${NRF5_SDK_PATH}/config/nrf52832/config"
)

set(COMPILER_LIBRARY_PATH_COMPONENT "/thumb/v7e-m+fp/softfp/")