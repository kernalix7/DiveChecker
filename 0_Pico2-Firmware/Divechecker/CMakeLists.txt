# Generated Cmake Pico project file

cmake_minimum_required(VERSION 3.13)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Initialise pico_sdk from installed location
# (note this can come from environment, CMake cache etc)

# == DO NOT EDIT THE FOLLOWING LINES for the Raspberry Pi Pico VS Code Extension to work ==
if(WIN32)
    set(USERHOME $ENV{USERPROFILE})
else()
    set(USERHOME $ENV{HOME})
endif()
set(sdkVersion 2.2.0)
set(toolchainVersion 14_2_Rel1)
set(picotoolVersion 2.2.0-a4)
set(picoVscode ${USERHOME}/.pico-sdk/cmake/pico-vscode.cmake)
if (EXISTS ${picoVscode})
    include(${picoVscode})
endif()
# ====================================================================================
set(PICO_BOARD pico2 CACHE STRING "Board type")

# Pull in Raspberry Pi Pico SDK (must be before project)
include(pico_sdk_import.cmake)

project(Divechecker C CXX ASM)

# Initialise the Raspberry Pi Pico SDK
pico_sdk_init()

# Add executable. Default name is the project name, version 0.1

add_executable(Divechecker Divechecker.c mbedtls_platform_impl.c)

pico_set_program_name(Divechecker "Divechecker")
pico_set_program_version(Divechecker "0.1")

# Generate PIO header from .pio file
pico_generate_pio_header(Divechecker ${CMAKE_CURRENT_LIST_DIR}/ws2812.pio)

# Modify the below lines to enable/disable output over UART/USB
pico_enable_stdio_uart(Divechecker 0)
pico_enable_stdio_usb(Divechecker 1)

# USB Device Name (shows in device manager / dmesg)
target_compile_definitions(Divechecker PRIVATE
    USBD_MANUFACTURER="kodenet.io"
    USBD_PRODUCT="DiveChecker V1"
)

# Add the standard library to the build
target_link_libraries(Divechecker
        pico_stdlib)

# Add the standard include files to the build
target_include_directories(Divechecker PRIVATE
        ${CMAKE_CURRENT_LIST_DIR}
)

# mbedtls ECDSA modules (directly from SDK source)
set(MBEDTLS_DIR ${PICO_SDK_PATH}/lib/mbedtls)

# mbedtls compile definitions - must apply globally to mbedtls sources
add_compile_definitions(
    MBEDTLS_CONFIG_FILE="${CMAKE_CURRENT_LIST_DIR}/mbedtls_config.h"
)

target_sources(Divechecker PRIVATE
        ${MBEDTLS_DIR}/library/bignum.c
        ${MBEDTLS_DIR}/library/bignum_core.c
        ${MBEDTLS_DIR}/library/bignum_mod.c
        ${MBEDTLS_DIR}/library/bignum_mod_raw.c
        ${MBEDTLS_DIR}/library/constant_time.c
        ${MBEDTLS_DIR}/library/ecp.c
        ${MBEDTLS_DIR}/library/ecp_curves.c
        ${MBEDTLS_DIR}/library/ecdsa.c
        ${MBEDTLS_DIR}/library/asn1parse.c
        ${MBEDTLS_DIR}/library/asn1write.c
        ${MBEDTLS_DIR}/library/oid.c
        ${MBEDTLS_DIR}/library/md.c
        ${MBEDTLS_DIR}/library/sha256.c
        ${MBEDTLS_DIR}/library/ctr_drbg.c
        ${MBEDTLS_DIR}/library/aes.c
        ${MBEDTLS_DIR}/library/platform.c
)
target_include_directories(Divechecker PRIVATE
        ${MBEDTLS_DIR}/include
        ${MBEDTLS_DIR}/library
        ${PICO_SDK_PATH}/src/rp2_common/pico_mbedtls/include
)

# Add any user requested libraries
target_link_libraries(Divechecker 
        hardware_i2c
        hardware_pio
        hardware_flash
        hardware_sync
        hardware_sha256
        hardware_regs  # For OTP register access
        pico_multicore
        pico_unique_id
        pico_rand
        )

# Optional: Enable USE_OTP_KEYS for production builds
# Uncomment the following line for production:
# target_compile_definitions(Divechecker PRIVATE USE_OTP_KEYS=1)

pico_add_extra_outputs(Divechecker)

# ============================================================================
# Secure Boot: Auto-sign firmware after build
# ============================================================================
# Uncomment the following to enable automatic firmware signing:

# option(SIGN_FIRMWARE "Sign firmware with Secure Boot key" OFF)
# 
# if(SIGN_FIRMWARE)
#     set(BOOT_PRIVATE_KEY "${CMAKE_CURRENT_SOURCE_DIR}/keys/secure_boot/boot_private.pem")
#     set(PICOTOOL "${USERHOME}/.pico-sdk/picotool/${picotoolVersion}/picotool/picotool")
#     
#     if(EXISTS ${BOOT_PRIVATE_KEY} AND EXISTS ${PICOTOOL})
#         add_custom_command(TARGET Divechecker POST_BUILD
#             COMMAND ${PICOTOOL} sign 
#                 ${CMAKE_CURRENT_BINARY_DIR}/Divechecker.bin
#                 ${BOOT_PRIVATE_KEY}
#                 ${CMAKE_CURRENT_BINARY_DIR}/Divechecker_signed.bin
#             COMMAND ${PICOTOOL} sign
#                 ${CMAKE_CURRENT_BINARY_DIR}/Divechecker.uf2
#                 ${BOOT_PRIVATE_KEY}
#                 ${CMAKE_CURRENT_BINARY_DIR}/Divechecker_signed.uf2
#             COMMENT "Signing firmware with Secure Boot key..."
#         )
#         message(STATUS "Secure Boot signing ENABLED")
#     else()
#         message(WARNING "Secure Boot key or picotool not found - signing disabled")
#     endif()
# endif()
