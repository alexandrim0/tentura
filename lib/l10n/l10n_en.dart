// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class L10nEn extends L10n {
  L10nEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Tentura';

  @override
  String get labelTitle => 'Title';

  @override
  String get labelDescription => 'Description';

  @override
  String get labelMe => 'Me';

  @override
  String get labelOr => 'or';

  @override
  String get labelConfirmation => 'Are you sure?';

  @override
  String get labelNothingHere => 'There is nothing here yet';

  @override
  String get labelSettings => 'Settings';

  @override
  String get buttonCancel => 'Cancel';

  @override
  String get buttonDelete => 'Delete';

  @override
  String get buttonRemove => 'Remove';

  @override
  String get buttonCreate => 'Create';

  @override
  String get buttonComplaint => 'Complaint';

  @override
  String get buttonYes => 'Yes';

  @override
  String get buttonOk => 'Ok';

  @override
  String get buttonSave => 'Save';

  @override
  String get buttonClose => 'Close';

  @override
  String get buttonSearch => 'Search';

  @override
  String get buttonPaste => 'Paste from Clipboard';

  @override
  String get buttonScanQR => 'Scan QR';

  @override
  String get invitationCodeTooShort => 'Code too short';

  @override
  String get invitationCodeTooLong => 'Code too long';

  @override
  String get invitationCodeWrongFormat => 'Wrong Code format';

  @override
  String get titleTooShort => 'Title too short';

  @override
  String get titleTooLong => 'Title too long';

  @override
  String get descriptionTooLong => 'Description too long';

  @override
  String get createNewAccount => 'Create new Account';

  @override
  String get pleaseFillTitle => 'Please fill title';

  @override
  String get labelInvitationCode => 'Invitation Code';

  @override
  String get pleaseEnterCode => 'Please enter Invitation Code';

  @override
  String get confirmAccountRemoval => 'Are you sure you want to remove this account?';

  @override
  String get chooseAccount => 'Choose account';

  @override
  String get alreadyHaveAccount => 'Already have an account?\nAccess it by scanning a QR code from another device\nor by using your saved seed phrase.';

  @override
  String get recoverFromQR => 'Recover from QR';

  @override
  String get recoverFromClipboard => 'Recover from clipboard';

  @override
  String get shareAccount => 'Share Account';

  @override
  String get showSeed => 'Show Seed';

  @override
  String get removeFromList => 'Remove from the list';

  @override
  String get confirmBeaconRemoval => 'Are you sure you want to delete this beacon?';

  @override
  String get beaconsTitle => 'Beacons';

  @override
  String get beaconsFilterEnabled => 'Enabled';

  @override
  String get beaconsFilterDisabled => 'Disabled';

  @override
  String get noBeaconsMessage => 'There are no beacons yet';

  @override
  String get disableBeacon => 'Disable Beacon';

  @override
  String get enableBeacon => 'Enable Beacon';

  @override
  String get deleteBeacon => 'Delete Beacon';

  @override
  String get showOnMap => 'Show on the map';

  @override
  String get confirmBeaconPublishing => 'Are you sure you want to publish this beacon?';

  @override
  String get confirmBeaconPublishingHint => 'Once the beacon is published, it will not be possible to make changes. Are you sure you want to publish this beacon?';

  @override
  String get createNewBeacon => 'Create new Beacon';

  @override
  String get setDisplayPeriod => 'Set display period';

  @override
  String get beaconTitleRequired => 'Beacon Title (required)';

  @override
  String get buttonPublish => 'Publish';

  @override
  String get addLocation => 'Add Location';

  @override
  String get attachImage => 'Attach Image';

  @override
  String get labelComments => 'Comments';

  @override
  String get showAllComments => 'Show all comments';

  @override
  String get writeComment => 'Write a comment';

  @override
  String get chatLabelToday => 'Today';

  @override
  String get submitComplaint => 'Submit Complaint';

  @override
  String get violatesCSAE => 'Violates CSAE Policy';

  @override
  String get violatesPlatformRules => 'Violates Platform Rules';

  @override
  String get labelComplaintType => 'Complaint Type';

  @override
  String get detailsRequired => 'Details*';

  @override
  String get provideDetails => 'Please provide details';

  @override
  String get feedbackEmail => 'Email for feedback (optional)';

  @override
  String get emailValidationError => 'Please enter a valid email';

  @override
  String get buttonSubmitComplaint => 'SUBMIT COMPLAINT';

  @override
  String get writeCodeHere => 'If you have the Code, please write it here:';

  @override
  String get codeLengthError => 'Wrong code length!';

  @override
  String get codePrefixError => 'Wrong code prefix!';

  @override
  String get addNewTopic => 'Add a new topic';

  @override
  String topicRemovalMessage(String contextName) {
    return 'Topic $contextName will be removed from your list!';
  }

  @override
  String get allTopics => 'All topics';

  @override
  String confirmFriendRemoval(String profileTitle) {
    return 'Are you sure you want to delete $profileTitle from friends list?';
  }

  @override
  String get tapToChooseLocation => 'Tap to choose location';

  @override
  String get goToEgo => 'Go to Ego';

  @override
  String get showNegative => 'Show negative';

  @override
  String get hideNegative => 'Hide negative';

  @override
  String get graphView => 'Graph view';

  @override
  String get myField => 'My Field';

  @override
  String get favorites => 'Favorites';

  @override
  String get connect => 'Connect';

  @override
  String get friends => 'Friends';

  @override
  String get profile => 'Profile';

  @override
  String get introTitle => 'Build Your Network with Clarity';

  @override
  String get introText => 'Each post reveals the connections you share. Enjoy complete transparency and mastery over your relationships';

  @override
  String get buttonStart => 'Start';

  @override
  String get confirmOpinionRemoval => 'Are you sure you want to delete this opinion?';

  @override
  String get noOpinions => 'There are no opinions yet';

  @override
  String get deleteOpinion => 'Delete my opinion';

  @override
  String get confirmProfileRemoval => 'Are you sure you want to delete your profile?';

  @override
  String get profileRemovalHint => 'All your beacons and personal data will be deleted completely.';

  @override
  String get showConnections => 'Show Connections';

  @override
  String get showBeacons => 'Show Beacons';

  @override
  String get newBeacon => 'New Beacon';

  @override
  String get communityFeedback => 'Community Feedback';

  @override
  String get addToMyField => 'Add to My Field';

  @override
  String get removeFromMyField => 'Remove from my field';

  @override
  String get onlyOneOpinion => 'You can have only one opinion';

  @override
  String get writeOpinion => 'Write an opinion';

  @override
  String get positiveOrNegativeOpinion => 'Is this opinion is positive or negative?';

  @override
  String get positiveOpinion => 'Positive';

  @override
  String get negativeOpinion => 'Negative';

  @override
  String get rating => 'Rating';

  @override
  String get searchBy => 'Search by';

  @override
  String get showIntroAgain => 'Show Intro Again';

  @override
  String get logout => 'Logout';

  @override
  String get light => 'Light';

  @override
  String get system => 'System';

  @override
  String get dark => 'Dark';

  @override
  String get notImplementedYet => 'Not implemented yet';

  @override
  String get markAllAsRead => 'Mark all as read';

  @override
  String get scanQrCode => 'Scan the QR Code';

  @override
  String get noName => 'No name';

  @override
  String get copyToClipboard => 'Copy to clipboard';

  @override
  String get seedCopied => 'Seed copied to clipboard!';

  @override
  String get shareLink => 'Share Link';
}
