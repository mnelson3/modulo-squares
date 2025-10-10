# AdMob Configuration Guide

## Setting up Production AdMob IDs

1. **Create AdMob Account**: Go to [AdMob](https://admob.google.com) and create an account
2. **Create Apps**: Add your Android and iOS apps to AdMob
3. **Get App IDs**: Note down the App IDs for both platforms
4. **Create Ad Units**: Create interstitial ad units for both platforms
5. **Update Configuration**: Replace the placeholder IDs in `lib/core/config/admob_config.dart`

### Android Setup
- App ID: Update `androidAppId` in `admob_config.dart`
- Ad Unit ID: Update `androidInterstitialId` in `admob_config.dart`
- Also update `AndroidManifest.xml` with the same App ID

### iOS Setup
- App ID: Update `iosAppId` in `admob_config.dart`
- Ad Unit ID: Update `iosInterstitialId` in `admob_config.dart`
- Also update `Info.plist` with the same App ID

### Privacy & Compliance
- The app automatically handles ATT (App Tracking Transparency) on iOS
- Ad personalization is controlled by user consent
- Test ads are used in debug mode, production ads in release mode

### Testing
- Debug builds use test ad units (no violations)
- Release builds use production ad units
- Check `AdMobConfig.isUsingProductionIds` to verify configuration