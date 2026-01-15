/**
 * mbedtls platform implementation for Pico SDK
 * Replaces platform_util.c with Pico-compatible implementations
 */

#include "pico/stdlib.h"
#include <string.h>
#include <stdint.h>
#include <stddef.h>
#include <stdlib.h>

#include "mbedtls/build_info.h"
#include "mbedtls/platform_time.h"
#include "mbedtls/platform_util.h"

/* Millisecond time for mbedtls 3.x */
mbedtls_ms_time_t mbedtls_ms_time(void) {
    return (mbedtls_ms_time_t)to_ms_since_boot(get_absolute_time());
}

/* Secure memory zeroing */
void mbedtls_platform_zeroize(void *buf, size_t len) {
    if (buf == NULL || len == 0) return;
    volatile unsigned char *p = (volatile unsigned char *)buf;
    while (len--) {
        *p++ = 0;
    }
}

/* Secure free with zeroing */
void mbedtls_zeroize_and_free(void *buf, size_t len) {
    if (buf != NULL) {
        mbedtls_platform_zeroize(buf, len);
        free(buf);
    }
}
