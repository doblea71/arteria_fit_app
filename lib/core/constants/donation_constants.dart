enum DonationPlatform { kofi, paypal, githubSponsors }

class DonationConstants {
  static const String kofiUrl = 'https://ko-fi.com/devdoblea';
  static const String paypalUrl = 'https://www.paypal.com/paypalme/doblea71';
  static const String githubSponsorsUrl =
      'https://github.com/sponsors/DevDoblea';

  static const int showAfterCompletedSessions = 7;
  static const int showAfterHistoryRecords = 20;
  static const int minDaysBetweenPrompts = 30;

  static const String donationTitle = 'Apoya el desarrollo';
  static const String donationMessage =
      'Si Arteria Fit te ha sido útil, considera apoyarnos con una pequeña contribución.';
}
