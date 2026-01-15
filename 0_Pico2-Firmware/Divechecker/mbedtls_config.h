/**
 * mbedtls configuration for DiveChecker ECDSA
 * Minimal config for ECDSA P-256 signing only
 */

#ifndef MBEDTLS_CONFIG_H
#define MBEDTLS_CONFIG_H

/* System support */
#define MBEDTLS_HAVE_ASM
#define MBEDTLS_HAVE_TIME

/* mbed TLS feature support */
#define MBEDTLS_ECP_DP_SECP256R1_ENABLED

/* mbed TLS modules */
#define MBEDTLS_ASN1_PARSE_C
#define MBEDTLS_ASN1_WRITE_C
#define MBEDTLS_BIGNUM_C
#define MBEDTLS_CTR_DRBG_C
#define MBEDTLS_ECDSA_C
#define MBEDTLS_ECP_C
#define MBEDTLS_MD_C
#define MBEDTLS_OID_C
#define MBEDTLS_SHA256_C
#define MBEDTLS_SHA224_C
#define MBEDTLS_AES_C

/* Platform */
#define MBEDTLS_PLATFORM_C
#define MBEDTLS_NO_PLATFORM_ENTROPY

/* For mbedtls 3.x compatibility - allow direct struct access */
#define MBEDTLS_ALLOW_PRIVATE_ACCESS

/* Memory optimization for embedded */
#define MBEDTLS_ECP_FIXED_POINT_OPTIM 0
#define MBEDTLS_ECP_WINDOW_SIZE 2
#define MBEDTLS_MPI_MAX_SIZE 64

#endif /* MBEDTLS_CONFIG_H */
