# macOS App Store Connect 배포 설정 TODO

CI/CD 파이프라인은 준비 완료 (`.github/workflows/build.yml`, `macos/ExportOptions.plist`).
아래 항목을 Apple Developer 계정에서 처리 후 GitHub Secrets에 등록하면 자동 업로드 활성화됨.

## Apple Developer 계정 작업

- [ ] **3rd Party Mac Developer Application 인증서 발급**
  - Apple Developer → Certificates → `+` → 3rd Party Mac Developer Application
  - .p12로 내보내기 → `base64 -i cert.p12 | pbcopy`

- [ ] **3rd Party Mac Developer Installer 인증서 발급**
  - Apple Developer → Certificates → `+` → 3rd Party Mac Developer Installer
  - .p12로 내보내기 → `base64 -i cert.p12 | pbcopy`

- [ ] **macOS App Store 프로비저닝 프로파일 생성**
  - Apple Developer → Profiles → `+` → Mac App Store
  - App ID: `io.kodenet.divechecker`
  - 위에서 만든 Application 인증서 선택
  - 다운로드 → `base64 -i profile.provisionprofile | pbcopy`

## GitHub Secrets 등록

- [ ] `MACOS_CERTIFICATE_APP_P12` — Application 인증서 (base64)
- [ ] `MACOS_CERTIFICATE_APP_PASSWORD` — Application 인증서 비밀번호
- [ ] `MACOS_CERTIFICATE_INSTALLER_P12` — Installer 인증서 (base64)
- [ ] `MACOS_CERTIFICATE_INSTALLER_PASSWORD` — Installer 인증서 비밀번호
- [ ] `MACOS_PROVISIONING_PROFILE` — 프로비저닝 프로파일 (base64)

> API Key (`APPLE_API_KEY_ID`, `APPLE_API_ISSUER_ID`, `APPLE_API_KEY_P8`)는 iOS와 공유 — 추가 등록 불필요.

## 검증

- [ ] 시크릿 등록 후 테스트 태그 push (`v8.1.0-rc1` 등)로 ASC 업로드 확인
- [ ] codesign identity 이름 확인: `KODENET (AWD2F2J9GP)` — 실제 팀 이름과 다르면 `build.yml` 수정 필요
