## 1. Donation Constants

- [x] 1.1 Create `lib/core/constants/donation_constants.dart`
- [x] 1.2 Define kofiUrl, paypalUrl, githubSponsorsUrl
- [x] 1.3 Define showAfterCompletedSessions (7)
- [x] 1.4 Define showAfterHistoryRecords (20)
- [x] 1.5 Define minDaysBetweenPrompts (30)
- [x] 1.6 Define donationTitle and donationMessage

## 2. Donation Service

- [x] 2.1 Create `lib/core/services/donation_service.dart`
- [x] 2.2 Implement SharedPreferences keys (donation_dismissed_count, donation_last_shown, donation_made, donation_consent)
- [x] 2.3 Implement shouldShowDonationPrompt() with rate limiting
- [x] 2.4 Implement markDonationPromptShown()
- [x] 2.5 Implement markDonationDismissed()
- [x] 2.6 Implement markAsDonor()
- [x] 2.7 Implement openDonationUrl() using url_launcher
- [x] 2.8 Implement getDonationConsent() and setDonationConsent()

## 3. Donation Sheet Widget

- [x] 3.1 Create `lib/widgets/donation_sheet.dart`
- [x] 3.2 Create showDonationSheet() function
- [x] 3.3 Display title and message
- [x] 3.4 Add Ko-fi option button
- [x] 3.5 Add PayPal option button
- [x] 3.6 Add "Ya doné" button
- [x] 3.7 Add "Quizás más tarde" dismiss button
- [x] 3.8 Style with consistent design language

## 4. Aha Moments Integration

- [x] 4.1 Modify `lib/screens/bp_session_screen.dart`
- [x] 4.2 Add trigger after completing session #7
- [x] 4.3 Check shouldShowDonationPrompt() before showing
- [x] 4.4 Modify `lib/screens/bp_history_screen.dart`
- [x] 4.5 Add trigger when viewing history with 20+ records
- [x] 4.6 Count total readings from database

## 5. Donation Settings Section

- [x] 5.1 Modify `lib/features/settings/settings_screen.dart`
- [x] 5.2 Add "Apoyar el desarrollo" section
- [x] 5.3 Add tap handler to open donation sheet
- [x] 5.4 Add "Ya donaste" badge when donation_made == true
- [x] 5.5 Add option to reset donor status

## 6. Testing & Verification

- [x] 6.1 Run `flutter analyze` to verify no issues
- [x] 6.2 Test donation sheet opens from settings ✓
- [x] 6.3 Test Ko-fi button opens browser ✓
- [x] 6.4 Test PayPal button opens browser ✓
- [x] 6.5 Test "Quizás más tarde" dismisses and records ✓
- [x] 6.6 Test "Ya doné" marks as donor and shows badge ✓
- [ ] 6.7 Test rate limiting (don't show within 30 days)
- [ ] 6.8 Test session #7 trigger
- [ ] 6.9 Test history 20+ records trigger
- [ ] 6.10 Test Light/Dark theme consistency

**Nota:** GitHub Sponsors removido (URL 404)
