# Production Release Checklist

## Pre-Release Preparation

### ✅ Privacy & Compliance
- [x] Implement App Tracking Transparency (ATT) for iOS
- [x] Add ATT permission strings to Info.plist
- [x] Test ATT permission flow
- [ ] Create privacy policy (if required)
- [ ] Verify GDPR compliance

### ✅ AdMob Configuration
- [x] Create AdMob account
- [ ] Create Android app in AdMob
- [ ] Create iOS app in AdMob
- [ ] Get production App IDs
- [ ] Create interstitial ad units
- [ ] Update `lib/core/config/admob_config.dart`
- [ ] Update AndroidManifest.xml
- [ ] Update Info.plist
- [ ] Test ads in release mode

### ✅ Store Assets
- [ ] Design app icon (1024x1024 PNG)
- [ ] Generate platform-specific icons
- [ ] Take high-quality screenshots:
  - [ ] Android: 8 phone screenshots (1080x1920)
  - [ ] iOS: 3-5 screenshots per device type
- [ ] Create feature graphic (1024x500 for Play Store)
- [ ] Write store descriptions
- [ ] Prepare keywords and metadata

### ✅ Code Quality
- [x] Run `flutter analyze` - no issues
- [x] Run `flutter test` - all tests pass
- [ ] Test on physical devices
- [ ] Performance testing
- [ ] Memory leak testing

## Android Release Setup

### ✅ Signing Configuration
- [ ] Generate keystore: `keytool -genkey -v -keystore modulo_keystore.jks`
- [ ] Create `android/local.properties` with signing info
- [ ] Update `.gitignore` to exclude keystore files
- [ ] Test release build: `flutter build appbundle --release`

### ✅ Play Store Preparation
- [ ] Create Google Play Console account
- [ ] Create app listing
- [ ] Upload store assets
- [ ] Fill in store listing information
- [ ] Set up pricing and distribution
- [ ] Configure content rating

## iOS Release Setup

### ✅ Signing Configuration
- [ ] Enroll in Apple Developer Program
- [ ] Create App ID in developer portal
- [ ] Configure Xcode signing (automatic recommended)
- [ ] Test release build: `flutter build ios --release`

### ✅ App Store Preparation
- [ ] Create App Store Connect account
- [ ] Create app record
- [ ] Upload store assets
- [ ] Fill in app information
- [ ] Set up pricing and availability

## Release Process

### Android
1. [ ] Build: `flutter build appbundle --release`
2. [ ] Upload to Play Store (Internal/Beta first)
3. [ ] Test internal release
4. [ ] Promote to production

### iOS
1. [ ] Build: `flutter build ios --release`
2. [ ] Open Xcode and archive
3. [ ] Upload to App Store Connect
4. [ ] Submit for review

## Post-Release

### Monitoring
- [ ] Monitor crash reports (Firebase Crashlytics)
- [ ] Track analytics events
- [ ] Monitor ad performance
- [ ] Check user reviews and ratings

### Updates
- [ ] Plan update schedule
- [ ] Prepare changelog for each release
- [ ] Maintain version consistency across platforms

## Emergency Contacts

- **Google Play Support**: play.google.com/console
- **App Store Connect**: appstoreconnect.apple.com
- **AdMob Support**: support.google.com/admob
- **Firebase Support**: firebase.google.com/support

## Version Information

- **Current Version**: 0.0.1+1
- **Target Release Date**: [Set date]
- **Release Type**: [Major/Minor/Patch]

---

**Note**: This checklist ensures a smooth production release. Complete all items before submitting to app stores.