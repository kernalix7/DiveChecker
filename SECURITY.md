# Security Policy

**English** | [한국어](docs/SECURITY.ko.md)

## Supported Versions

| Version | Supported |
|---------|-----------|
| Latest  | Yes       |

As DiveChecker is in active development, security updates are applied to the latest version on the `main` branch.

## Reporting a Vulnerability

Please report security vulnerabilities through GitHub Security Advisories:

**[Report a vulnerability](https://github.com/kernalix7/DiveChecker/security/advisories/new)**

**Do NOT open a public issue for security vulnerabilities.**

### What to Include

- **Description**: A clear description of the vulnerability
- **Steps to Reproduce**: Detailed steps to reproduce the issue
- **Impact**: The potential impact of the vulnerability
- **Affected Components**: App, Firmware, Hardware, or Marketing Site
- **Environment**:
  - Operating System and version
  - App version (Flutter)
  - Firmware version (RP2350)
  - Device model (DC-EQ01 / Vent)
  - Connection type (USB-C / Lightning adapter)

## Response Timeline

| Step | Timeframe |
|------|-----------|
| Acknowledgment | Within 48 hours |
| Assessment | Within 7 days |
| Fix | Within 30 days |

## Scope

In-scope:

- ECDSA P-256 device authentication bypass or key extraction
- USB MIDI SysEx protocol injection or buffer overflow
- Firmware memory corruption or code execution
- Flutter app data leakage (session data, device keys)
- Cross-platform database (SQLite/IndexedDB) injection
- OTP key storage vulnerabilities on RP2350
- Insecure firmware update mechanisms
- USB communication interception or replay
- Marketing site (divechecker.createch.kr): XSS, CSP bypass, supply chain (CDN/dep)

Out of scope:

- Bugs requiring physical access to the user's host machine
- Social engineering attacks
- Issues in third-party dependencies (please report upstream, but let us know)

## Security Best Practices

DiveChecker follows these practices:

- **ECDSA P-256 Device Authentication** — Cryptographic verification of genuine hardware
- **OTP Key Storage** — Production keys stored in RP2350 one-time programmable memory
- **No Dynamic Memory in Firmware** — Fixed-size buffers to prevent heap-based attacks
- **Input Validation** — All SysEx commands validated before processing
- **PIN-Protected Configuration** — Device settings require PIN authentication
- **No Network Communication** — Pure USB connection, no cloud or internet dependency
- **Site CSP + canonical URLs** — Marketing site uses canonical hrefs and OG/Twitter meta only

## Acknowledgments

We appreciate the security research community's efforts in responsibly disclosing vulnerabilities. Contributors who report valid security issues will be acknowledged (with permission) in our release notes.
