# Security Policy

**English** | [한국어](docs/SECURITY.ko.md)

## Supported Versions

| Version | Supported          |
|---------|--------------------|
| latest  | :white_check_mark: |

As DiveChecker is in active development, security updates are applied to the latest version on the `main` branch.

## Reporting a Vulnerability

**Please do NOT report security vulnerabilities through public GitHub issues.**

Instead, please report them through [GitHub Security Advisories](https://github.com/kernalix7/DiveChecker/security/advisories/new).

### What to Include

When reporting a vulnerability, please include:

1. **Description** — A clear description of the vulnerability
2. **Steps to Reproduce** — Detailed steps to reproduce the issue
3. **Impact** — The potential impact of the vulnerability
4. **Affected Components** — Which parts of DiveChecker are affected (App, Firmware, Hardware)
5. **Environment** — OS, Flutter version, firmware version, device model

### Response Timeline

- **Acknowledgment** — Within 48 hours of the report
- **Initial Assessment** — Within 7 days
- **Fix & Disclosure** — Coordinated with the reporter; typically within 30 days for critical issues

### Scope

The following areas are considered in-scope for security reports:

- ECDSA device authentication bypass or key extraction
- USB MIDI SysEx protocol injection or buffer overflow
- Firmware memory corruption or code execution
- Flutter app data leakage (session data, device keys)
- Cross-platform database (SQLite/IndexedDB) injection
- OTP key storage vulnerabilities on RP2350
- Insecure firmware update mechanisms
- Bluetooth/USB communication interception

### Out of Scope

- Bugs that require physical access to the user's machine
- Social engineering attacks
- Issues in third-party dependencies (please report these upstream, but let us know)

## Security Best Practices

DiveChecker follows these security practices:

- **ECDSA P-256 Device Authentication** — Cryptographic verification of genuine hardware
- **OTP Key Storage** — Production keys stored in RP2350 one-time programmable memory
- **No Dynamic Memory in Firmware** — Fixed-size buffers to prevent heap-based attacks
- **Input Validation** — All SysEx commands validated before processing
- **PIN-Protected Configuration** — Device settings require PIN authentication
- **No Network Communication** — Pure USB connection, no cloud or internet dependency

## Acknowledgments

We appreciate the security research community's efforts in responsibly disclosing vulnerabilities. Contributors who report valid security issues will be acknowledged (with permission) in our release notes.

---

*This security policy is subject to change as the project matures.*
