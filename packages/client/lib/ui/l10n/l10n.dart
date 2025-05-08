import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_en.dart';
import 'l10n_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L10n
/// returned by `L10n.of(context)`.
///
/// Applications need to include `L10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L10n.localizationsDelegates,
///   supportedLocales: L10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L10n.supportedLocales
/// property.
abstract class L10n {
  L10n(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L10n? of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n);
  }

  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Tentura'**
  String get appTitle;

  /// No description provided for @labelTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get labelTitle;

  /// No description provided for @labelDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get labelDescription;

  /// No description provided for @labelMe.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get labelMe;

  /// No description provided for @labelOr.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get labelOr;

  /// No description provided for @labelConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get labelConfirmation;

  /// No description provided for @labelNothingHere.
  ///
  /// In en, this message translates to:
  /// **'There is nothing here yet'**
  String get labelNothingHere;

  /// No description provided for @labelSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get labelSettings;

  /// No description provided for @buttonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get buttonCancel;

  /// No description provided for @buttonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get buttonDelete;

  /// No description provided for @buttonRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get buttonRemove;

  /// No description provided for @buttonCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get buttonCreate;

  /// No description provided for @buttonComplaint.
  ///
  /// In en, this message translates to:
  /// **'Complaint'**
  String get buttonComplaint;

  /// No description provided for @buttonYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get buttonYes;

  /// No description provided for @buttonOk.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get buttonOk;

  /// No description provided for @buttonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get buttonSave;

  /// No description provided for @buttonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get buttonClose;

  /// No description provided for @buttonSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get buttonSearch;

  /// No description provided for @buttonPaste.
  ///
  /// In en, this message translates to:
  /// **'Paste from Clipboard'**
  String get buttonPaste;

  /// No description provided for @buttonScanQR.
  ///
  /// In en, this message translates to:
  /// **'Scan QR'**
  String get buttonScanQR;

  /// No description provided for @invitationCodeTooShort.
  ///
  /// In en, this message translates to:
  /// **'Code too short'**
  String get invitationCodeTooShort;

  /// No description provided for @invitationCodeTooLong.
  ///
  /// In en, this message translates to:
  /// **'Code too long'**
  String get invitationCodeTooLong;

  /// No description provided for @invitationCodeWrongFormat.
  ///
  /// In en, this message translates to:
  /// **'Wrong Code format'**
  String get invitationCodeWrongFormat;

  /// No description provided for @titleTooShort.
  ///
  /// In en, this message translates to:
  /// **'Title too short'**
  String get titleTooShort;

  /// No description provided for @titleTooLong.
  ///
  /// In en, this message translates to:
  /// **'Title too long'**
  String get titleTooLong;

  /// No description provided for @descriptionTooLong.
  ///
  /// In en, this message translates to:
  /// **'Description too long'**
  String get descriptionTooLong;

  /// No description provided for @createNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Create new Account'**
  String get createNewAccount;

  /// No description provided for @pleaseFillTitle.
  ///
  /// In en, this message translates to:
  /// **'Please fill title'**
  String get pleaseFillTitle;

  /// No description provided for @labelInvitationCode.
  ///
  /// In en, this message translates to:
  /// **'Invitation Code'**
  String get labelInvitationCode;

  /// No description provided for @pleaseEnterCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter Invitation Code'**
  String get pleaseEnterCode;

  /// No description provided for @confirmAccountRemoval.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this account?'**
  String get confirmAccountRemoval;

  /// No description provided for @chooseAccount.
  ///
  /// In en, this message translates to:
  /// **'Choose account'**
  String get chooseAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?\nAccess it by scanning a QR code from another device\nor by using your saved seed phrase.'**
  String get alreadyHaveAccount;

  /// No description provided for @recoverFromQR.
  ///
  /// In en, this message translates to:
  /// **'Recover from QR'**
  String get recoverFromQR;

  /// No description provided for @recoverFromClipboard.
  ///
  /// In en, this message translates to:
  /// **'Recover from clipboard'**
  String get recoverFromClipboard;

  /// No description provided for @shareAccount.
  ///
  /// In en, this message translates to:
  /// **'Share Account'**
  String get shareAccount;

  /// No description provided for @showSeed.
  ///
  /// In en, this message translates to:
  /// **'Show Seed'**
  String get showSeed;

  /// No description provided for @removeFromList.
  ///
  /// In en, this message translates to:
  /// **'Remove from the list'**
  String get removeFromList;

  /// No description provided for @invitationScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Invitations'**
  String get invitationScreenTitle;

  /// No description provided for @confirmBeaconRemoval.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this beacon?'**
  String get confirmBeaconRemoval;

  /// No description provided for @beaconsTitle.
  ///
  /// In en, this message translates to:
  /// **'Beacons'**
  String get beaconsTitle;

  /// No description provided for @beaconsFilterEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get beaconsFilterEnabled;

  /// No description provided for @beaconsFilterDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get beaconsFilterDisabled;

  /// No description provided for @noBeaconsMessage.
  ///
  /// In en, this message translates to:
  /// **'There are no beacons yet'**
  String get noBeaconsMessage;

  /// No description provided for @disableBeacon.
  ///
  /// In en, this message translates to:
  /// **'Disable Beacon'**
  String get disableBeacon;

  /// No description provided for @enableBeacon.
  ///
  /// In en, this message translates to:
  /// **'Enable Beacon'**
  String get enableBeacon;

  /// No description provided for @deleteBeacon.
  ///
  /// In en, this message translates to:
  /// **'Delete Beacon'**
  String get deleteBeacon;

  /// No description provided for @showOnMap.
  ///
  /// In en, this message translates to:
  /// **'Show on the map'**
  String get showOnMap;

  /// No description provided for @confirmBeaconPublishing.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to publish this beacon?'**
  String get confirmBeaconPublishing;

  /// No description provided for @confirmBeaconPublishingHint.
  ///
  /// In en, this message translates to:
  /// **'Once the beacon is published, it will not be possible to make changes. Are you sure you want to publish this beacon?'**
  String get confirmBeaconPublishingHint;

  /// No description provided for @createNewBeacon.
  ///
  /// In en, this message translates to:
  /// **'Create new Beacon'**
  String get createNewBeacon;

  /// No description provided for @setDisplayPeriod.
  ///
  /// In en, this message translates to:
  /// **'Set display period'**
  String get setDisplayPeriod;

  /// No description provided for @beaconTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Beacon Title (required)'**
  String get beaconTitleRequired;

  /// No description provided for @buttonPublish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get buttonPublish;

  /// No description provided for @addLocation.
  ///
  /// In en, this message translates to:
  /// **'Add Location'**
  String get addLocation;

  /// No description provided for @attachImage.
  ///
  /// In en, this message translates to:
  /// **'Attach Image'**
  String get attachImage;

  /// No description provided for @labelComments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get labelComments;

  /// No description provided for @showAllComments.
  ///
  /// In en, this message translates to:
  /// **'Show all comments'**
  String get showAllComments;

  /// No description provided for @writeComment.
  ///
  /// In en, this message translates to:
  /// **'Write a comment'**
  String get writeComment;

  /// No description provided for @chatLabelToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get chatLabelToday;

  /// No description provided for @submitComplaint.
  ///
  /// In en, this message translates to:
  /// **'Submit Complaint'**
  String get submitComplaint;

  /// No description provided for @violatesCSAE.
  ///
  /// In en, this message translates to:
  /// **'Violates CSAE Policy'**
  String get violatesCSAE;

  /// No description provided for @violatesPlatformRules.
  ///
  /// In en, this message translates to:
  /// **'Violates Platform Rules'**
  String get violatesPlatformRules;

  /// No description provided for @labelComplaintType.
  ///
  /// In en, this message translates to:
  /// **'Complaint Type'**
  String get labelComplaintType;

  /// No description provided for @detailsRequired.
  ///
  /// In en, this message translates to:
  /// **'Details*'**
  String get detailsRequired;

  /// No description provided for @provideDetails.
  ///
  /// In en, this message translates to:
  /// **'Please provide details'**
  String get provideDetails;

  /// No description provided for @feedbackEmail.
  ///
  /// In en, this message translates to:
  /// **'Email for feedback (optional)'**
  String get feedbackEmail;

  /// No description provided for @emailValidationError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get emailValidationError;

  /// No description provided for @buttonSubmitComplaint.
  ///
  /// In en, this message translates to:
  /// **'SUBMIT COMPLAINT'**
  String get buttonSubmitComplaint;

  /// No description provided for @writeCodeHere.
  ///
  /// In en, this message translates to:
  /// **'If you have the Code, please write it here:'**
  String get writeCodeHere;

  /// No description provided for @codeLengthError.
  ///
  /// In en, this message translates to:
  /// **'Wrong code length!'**
  String get codeLengthError;

  /// No description provided for @codePrefixError.
  ///
  /// In en, this message translates to:
  /// **'Wrong code prefix!'**
  String get codePrefixError;

  /// No description provided for @addNewTopic.
  ///
  /// In en, this message translates to:
  /// **'Add a new topic'**
  String get addNewTopic;

  /// No description provided for @topicRemovalMessage.
  ///
  /// In en, this message translates to:
  /// **'Topic {contextName} will be removed from your list!'**
  String topicRemovalMessage(String contextName);

  /// No description provided for @allTopics.
  ///
  /// In en, this message translates to:
  /// **'All topics'**
  String get allTopics;

  /// No description provided for @confirmFriendRemoval.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {profileTitle} from friends list?'**
  String confirmFriendRemoval(String profileTitle);

  /// No description provided for @tapToChooseLocation.
  ///
  /// In en, this message translates to:
  /// **'Tap to choose location'**
  String get tapToChooseLocation;

  /// No description provided for @goToEgo.
  ///
  /// In en, this message translates to:
  /// **'Go to Ego'**
  String get goToEgo;

  /// No description provided for @showNegative.
  ///
  /// In en, this message translates to:
  /// **'Show negative'**
  String get showNegative;

  /// No description provided for @hideNegative.
  ///
  /// In en, this message translates to:
  /// **'Hide negative'**
  String get hideNegative;

  /// No description provided for @graphView.
  ///
  /// In en, this message translates to:
  /// **'Graph view'**
  String get graphView;

  /// No description provided for @myField.
  ///
  /// In en, this message translates to:
  /// **'My Field'**
  String get myField;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @friends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friends;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @introTitle.
  ///
  /// In en, this message translates to:
  /// **'Build Your Network with Clarity'**
  String get introTitle;

  /// No description provided for @introText.
  ///
  /// In en, this message translates to:
  /// **'Each post reveals the connections you share. Enjoy complete transparency and mastery over your relationships'**
  String get introText;

  /// No description provided for @buttonStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get buttonStart;

  /// No description provided for @confirmOpinionRemoval.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this opinion?'**
  String get confirmOpinionRemoval;

  /// No description provided for @noOpinions.
  ///
  /// In en, this message translates to:
  /// **'There are no opinions yet'**
  String get noOpinions;

  /// No description provided for @deleteOpinion.
  ///
  /// In en, this message translates to:
  /// **'Delete my opinion'**
  String get deleteOpinion;

  /// No description provided for @confirmProfileRemoval.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your profile?'**
  String get confirmProfileRemoval;

  /// No description provided for @profileRemovalHint.
  ///
  /// In en, this message translates to:
  /// **'All your beacons and personal data will be deleted completely.'**
  String get profileRemovalHint;

  /// No description provided for @showConnections.
  ///
  /// In en, this message translates to:
  /// **'Show Connections'**
  String get showConnections;

  /// No description provided for @showBeacons.
  ///
  /// In en, this message translates to:
  /// **'Show Beacons'**
  String get showBeacons;

  /// No description provided for @newBeacon.
  ///
  /// In en, this message translates to:
  /// **'New Beacon'**
  String get newBeacon;

  /// No description provided for @communityFeedback.
  ///
  /// In en, this message translates to:
  /// **'Community Feedback'**
  String get communityFeedback;

  /// No description provided for @addToMyField.
  ///
  /// In en, this message translates to:
  /// **'Add to My Field'**
  String get addToMyField;

  /// No description provided for @removeFromMyField.
  ///
  /// In en, this message translates to:
  /// **'Remove from my field'**
  String get removeFromMyField;

  /// No description provided for @onlyOneOpinion.
  ///
  /// In en, this message translates to:
  /// **'You can have only one opinion'**
  String get onlyOneOpinion;

  /// No description provided for @writeOpinion.
  ///
  /// In en, this message translates to:
  /// **'Write an opinion'**
  String get writeOpinion;

  /// No description provided for @positiveOrNegativeOpinion.
  ///
  /// In en, this message translates to:
  /// **'Is this opinion is positive or negative?'**
  String get positiveOrNegativeOpinion;

  /// No description provided for @positiveOpinion.
  ///
  /// In en, this message translates to:
  /// **'Positive'**
  String get positiveOpinion;

  /// No description provided for @negativeOpinion.
  ///
  /// In en, this message translates to:
  /// **'Negative'**
  String get negativeOpinion;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @searchBy.
  ///
  /// In en, this message translates to:
  /// **'Search by'**
  String get searchBy;

  /// No description provided for @showIntroAgain.
  ///
  /// In en, this message translates to:
  /// **'Show Intro Again'**
  String get showIntroAgain;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @notImplementedYet.
  ///
  /// In en, this message translates to:
  /// **'Not implemented yet'**
  String get notImplementedYet;

  /// No description provided for @markAllAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllAsRead;

  /// No description provided for @scanQrCode.
  ///
  /// In en, this message translates to:
  /// **'Scan the QR Code'**
  String get scanQrCode;

  /// No description provided for @noName.
  ///
  /// In en, this message translates to:
  /// **'No name'**
  String get noName;

  /// No description provided for @copyToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copy to clipboard'**
  String get copyToClipboard;

  /// No description provided for @seedCopied.
  ///
  /// In en, this message translates to:
  /// **'Seed copied to clipboard!'**
  String get seedCopied;

  /// No description provided for @shareLink.
  ///
  /// In en, this message translates to:
  /// **'Share Link'**
  String get shareLink;
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(lookupL10n(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_L10nDelegate old) => false;
}

L10n lookupL10n(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return L10nEn();
    case 'ru': return L10nRu();
  }

  throw FlutterError(
    'L10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
