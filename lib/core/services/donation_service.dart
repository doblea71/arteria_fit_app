import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/donation_constants.dart';

class DonationService {
  static const String _keyDismissedCount = 'donation_dismissed_count';
  static const String _keyLastShown = 'donation_last_shown';
  static const String _keyDonationMade = 'donation_made';
  static const String _keyDonationConsent = 'donation_consent';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<bool> shouldShowDonationPrompt() async {
    final prefs = await _prefs;
    final consent = prefs.getBool(_keyDonationConsent) ?? true;

    if (!consent) return false;

    final donationMade = prefs.getBool(_keyDonationMade) ?? false;
    if (donationMade) return false;

    final lastShownStr = prefs.getString(_keyLastShown);
    if (lastShownStr == null) return true;

    final lastShown = DateTime.parse(lastShownStr);
    final daysSinceLastShown = DateTime.now().difference(lastShown).inDays;

    return daysSinceLastShown >= DonationConstants.minDaysBetweenPrompts;
  }

  Future<void> markDonationPromptShown() async {
    final prefs = await _prefs;
    await prefs.setString(_keyLastShown, DateTime.now().toIso8601String());
  }

  Future<void> markDonationDismissed() async {
    final prefs = await _prefs;
    final count = prefs.getInt(_keyDismissedCount) ?? 0;
    await prefs.setInt(_keyDismissedCount, count + 1);
    await prefs.setString(_keyLastShown, DateTime.now().toIso8601String());
  }

  Future<void> markAsDonor() async {
    final prefs = await _prefs;
    await prefs.setBool(_keyDonationMade, true);
  }

  Future<void> resetDonorStatus() async {
    final prefs = await _prefs;
    await prefs.setBool(_keyDonationMade, false);
  }

  Future<bool> isDonor() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyDonationMade) ?? false;
  }

  Future<bool> getDonationConsent() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyDonationConsent) ?? true;
  }

  Future<void> setDonationConsent(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyDonationConsent, value);
  }

  Future<void> openDonationUrl(DonationPlatform platform) async {
    String url;
    switch (platform) {
      case DonationPlatform.kofi:
        url = DonationConstants.kofiUrl;
        break;
      case DonationPlatform.paypal:
        url = DonationConstants.paypalUrl;
        break;
      case DonationPlatform.githubSponsors:
        url = DonationConstants.githubSponsorsUrl;
        break;
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<int> getDismissedCount() async {
    final prefs = await _prefs;
    return prefs.getInt(_keyDismissedCount) ?? 0;
  }
}
