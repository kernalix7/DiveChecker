# DiveChecker OTA Firmware Update Test Guide

## Test Environment Setup

### 1. Key Generation (One-time)
```bash
cd 0_Pico2-Firmware/Divechecker
./generate_keys.sh
```
- `keys/divechecker_private.pem`: Private key for firmware signing
- `keys/divechecker_public.pem`: Public key for verification
- `keys/ecdsa_private_keys.h`: Key header for MCU

### 2. Firmware Build
```bash
cd 0_Pico2-Firmware/Divechecker
mkdir -p build && cd build
cmake -DPICO_SDK_PATH=$HOME/pico/pico-sdk ..
make -j4
```
Result: `Divechecker.uf2`

### 3. Firmware Signing
```bash
cd 0_Pico2-Firmware/Divechecker
./sign_firmware.sh build/Divechecker.uf2
```
Result: `build/Divechecker_signed.bin`

---

## App Testing

### 1. Regenerate l10n
```bash
cd _0_DiveChecker-APP
flutter gen-l10n
```

### 2. Run App
```bash
flutter run -d linux  # or macos, windows
```

### 3. Firmware Verification Tests

#### Test Case 1: Properly Signed Firmware
1. Copy `Divechecker_signed.bin` to Downloads folder
2. Settings → My Device → DiveChecker → Firmware Update
3. Select file → ✓ **Signature Valid** should display

#### Test Case 2: Invalid File
1. Select any `.bin` file
2. ✗ **Invalid magic header** error should appear

#### Test Case 3: Corrupted Signature
```bash
# Corrupt the file
dd if=/dev/urandom of=corrupted.bin bs=1 count=100
cat build/Divechecker_signed.bin >> corrupted.bin
```
- ✗ **Signature verification failed** should appear

#### Test Case 4: Firmware Signed with Different Key
```bash
# Generate new key and sign
openssl ecparam -genkey -name prime256v1 -noout -out fake_key.pem
# ... Firmware signed with this key will fail verification
```

---

## BOOTSEL Testing

### Test Procedure
1. With device connected, go to Settings → My Device → DiveChecker
2. Select "BOOTSEL Mode"
3. Confirm in dialog by selecting "Reboot"
4. Verify results:
   - USB connection disconnected
   - `RPI-RP2` drive appears
   - `.uf2` file can be copied

### Recovery Test
After installing corrupted firmware:
1. Disconnect device, hold BOOTSEL button while reconnecting
2. Copy working firmware to `RPI-RP2` drive

---

## Verification Checklist

### Security
- [x] ECDSA P-256 signature verification
- [x] SHA-256 hash calculation
- [x] DER signature format parsing
- [x] Reject invalid keys
- [x] Reject corrupted files
- [x] Detect size mismatch

### UI/UX
- [x] File list display
- [x] Verification result display (success/failure)
- [x] File info display (size, hash)
- [x] Version info parsing (when available)
- [x] BOOTSEL reboot confirmation dialog

### Error Handling
- [x] Handle missing files
- [x] Handle file read errors
- [x] Handle network errors (for future GitHub integration)
- [ ] Handle timeouts (large files)

---

## Limitations and Future Improvements

### Current Limitations
1. **Manual copy required**: After BOOTSEL, `.uf2` file must be copied manually
2. **Downgrade possible**: Only warning shown after version comparison
3. **Single device only**: Multiple simultaneous device connections not supported

### Planned Improvements
1. Automatic firmware download from GitHub Releases
2. Option to allow only upgrades after version comparison
3. Automatic USB Mass Storage copy (platform-specific)
4. Update rollback support

---

## Troubleshooting

### Problem: Signature verification always fails
**Cause**: App's public key differs from private key used for signing
**Solution**: Re-run `generate_keys.sh` and rebuild both app and firmware

### Problem: BOOTSEL command unresponsive
**Cause**: MIDI connection lost or firmware doesn't support command
**Solution**: Reconnect device and retry, verify firmware version

### Problem: RPI-RP2 drive not visible
**Cause**: USB connection issue or already flashed
**Solution**: Replace USB cable, reconnect device power
