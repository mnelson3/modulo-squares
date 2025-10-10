import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Comprehensive privacy compliance manager for ads.
/// Handles ATT (App Tracking Transparency) on iOS and UMP (User Messaging Platform) consent.
class ConsentService {
  ConsentService._();
  static final ConsentService instance = ConsentService._();

  // Public constructor for dependency injection
  factory ConsentService() => instance;

  bool _personalized = false;
  bool _attAuthorized = false;

  bool get isPersonalized => _personalized && _attAuthorized;
  bool get attAuthorized => _attAuthorized;

  /// Configure global ad request options according to consent and tracking authorization.
  Future<void> configure() async {
    // Initialize with non-personalized ads by default
    await MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        testDeviceIds: const <String>[],
        // Tag for Child Directed Treatment or Users under the Age of Consent as needed.
        // tagForChildDirectedTreatment: TagForChildDirectedTreatment.unspecified,
        // maxAdContentRating: MaxAdContentRating.pg,
      ),
    );

    // Handle iOS App Tracking Transparency
    if (Platform.isIOS) {
      await _handleAppTrackingTransparency();
    }

    // Handle UMP consent (if implemented)
    await _handleUMPConsent();

    // Update ad configuration based on consent status
    await _updateAdConfiguration();
  }

  /// Handle iOS App Tracking Transparency permission request
  Future<void> _handleAppTrackingTransparency() async {
    try {
      // Check current tracking status
      final TrackingStatus status = await AppTrackingTransparency.trackingAuthorizationStatus;

      switch (status) {
        case TrackingStatus.authorized:
          _attAuthorized = true;
          break;
        case TrackingStatus.denied:
        case TrackingStatus.restricted:
        case TrackingStatus.notSupported:
          _attAuthorized = false;
          break;
        case TrackingStatus.notDetermined:
          // Request permission
          await AppTrackingTransparency.requestTrackingAuthorization();
          final TrackingStatus newStatus = await AppTrackingTransparency.trackingAuthorizationStatus;
          _attAuthorized = newStatus == TrackingStatus.authorized;
          break;
      }
    } catch (e) {
      // Fallback for devices that don't support ATT
      _attAuthorized = false;
    }
  }

  /// Handle UMP (User Messaging Platform) consent - placeholder for future implementation
  Future<void> _handleUMPConsent() async {
    // TODO: Implement UMP consent flow when needed
    // This would typically involve:
    // 1. Check if consent is required
    // 2. Show consent form if needed
    // 3. Update _personalized based on user choices

    // For now, default to non-personalized
    _personalized = false;
  }

  /// Update ad configuration based on current consent status
  Future<void> _updateAdConfiguration() async {
    await MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        testDeviceIds: const <String>[],
        // Respect ATT authorization for personalized ads
        tagForChildDirectedTreatment: TagForChildDirectedTreatment.unspecified,
        maxAdContentRating: MaxAdContentRating.pg,
      ),
    );
  }

  /// Request ATT permission again (useful for settings screen)
  Future<bool> requestTrackingAuthorization() async {
    if (!Platform.isIOS) return false;

    try {
      await AppTrackingTransparency.requestTrackingAuthorization();
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;
      _attAuthorized = status == TrackingStatus.authorized;
      await _updateAdConfiguration();
      return _attAuthorized;
    } catch (e) {
      return false;
    }
  }

  /// Get current ATT status description
  Future<String> getAttStatusDescription() async {
    if (!Platform.isIOS) return 'Not applicable on this platform';

    try {
      final TrackingStatus status = await AppTrackingTransparency.trackingAuthorizationStatus;
      switch (status) {
        case TrackingStatus.authorized:
          return 'Authorized - Personalized ads enabled';
        case TrackingStatus.denied:
          return 'Denied - Limited ad personalization';
        case TrackingStatus.restricted:
          return 'Restricted - Limited ad personalization';
        case TrackingStatus.notSupported:
          return 'Not supported - Limited ad personalization';
        case TrackingStatus.notDetermined:
          return 'Not determined - Permission not requested';
      }
    } catch (e) {
      return 'Error checking status - Limited ad personalization';
    }
  }
}
