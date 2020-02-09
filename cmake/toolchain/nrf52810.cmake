# Specific settings for Nrf52810

add_compile_definitions(
    NRF52810_XXAA
)

add_compile_options(
    -mfloat-abi=soft
)

set(NRF_CHIP_HEADER_PATHS 
    "${NRF5_SDK_PATH}/components/softdevice/mbr/nrf52810/headers"
    "${NRF5_SDK_PATH}/config/nrf52810/config"
)

set(COMPILER_LIBRARY_PATH_COMPONENT "/thumb/v7e-m/nofp/")
