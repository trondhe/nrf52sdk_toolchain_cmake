macro(checkRequiredVariables)
    if(NOT DEFINED ARM_TOOLCHAIN_PATH)
        # message( "The path to the ${GNU_TARGET_TRIPLET}-gcc toolchain (ARM_TOOLCHAIN_PATH) must be set.")
    endif ()

    if(NOT DEFINED ARM_LIBRARY_PATH)
        # message( "The path to the arm library path (ARM_LIBRARY_PATH) must be set.")
    endif ()

    if(NOT DEFINED NRF5_SDK_PATH)
        # message( "The path to the nRF5 SDK (NRF5_SDK_PATH) must be set.")
    endif ()

    if(NOT DEFINED NRFJPROG)
        # message( "The path to the nrfjprog utility (NRFJPROG) must be set.")
    endif ()

    if(NOT DEFINED NRF_CHIP)
        # message( "The path to the nrfjprog utility (NRFJPROG) must be set.")
    endif ()

    if(NOT DEFINED NRF_BOARD)
        set(NRF_BOARD "None")
    endif()

    if(NOT DEFINED NRF_SOFTDEVICE)
        set(NRF_SOFTDEVICE "None")
    endif()
    
    file(TO_CMAKE_PATH "${ARM_TOOLCHAIN_PATH}" ARM_TOOLCHAIN_PATH)
    file(TO_CMAKE_PATH "${ARM_LIBRARY_PATH}" ARM_LIBRARY_PATH)
    file(TO_CMAKE_PATH "${NRF5_SDK_PATH}" NRF5_SDK_PATH)
    file(TO_CMAKE_PATH "${NRFJPROG}" NRFJPROG)

    set(ARM_TOOLCHAIN_PATH "${ARM_TOOLCHAIN_PATH}" CACHE INTERNAL "Arm toolchain path")
    set(ARM_LIBRARY_PATH "${ARM_LIBRARY_PATH}" CACHE INTERNAL "Arm library path")
    set(NRF5_SDK_PATH "${NRF5_SDK_PATH}" CACHE INTERNAL "Nrf sdk path")
    set(NRFJPROG "${NRFJPROG}" CACHE INTERNAL "Nrfjprog path")
endmacro()
