import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'DiveChecker'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @measurement.
  ///
  /// In en, this message translates to:
  /// **'Measurement'**
  String get measurement;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @deviceConnected.
  ///
  /// In en, this message translates to:
  /// **'DIVECHECKER CONNECTED'**
  String get deviceConnected;

  /// No description provided for @deviceNotConnected.
  ///
  /// In en, this message translates to:
  /// **'NOT CONNECTED'**
  String get deviceNotConnected;

  /// No description provided for @deviceDiscovery.
  ///
  /// In en, this message translates to:
  /// **'DEVICE DISCOVERY'**
  String get deviceDiscovery;

  /// No description provided for @searchingDevice.
  ///
  /// In en, this message translates to:
  /// **'Searching for Divechecker device...'**
  String get searchingDevice;

  /// No description provided for @measurementReady.
  ///
  /// In en, this message translates to:
  /// **'Ready for measurement'**
  String get measurementReady;

  /// No description provided for @tapToConnect.
  ///
  /// In en, this message translates to:
  /// **'Tap connect to start'**
  String get tapToConnect;

  /// No description provided for @connectDevice.
  ///
  /// In en, this message translates to:
  /// **'CONNECT'**
  String get connectDevice;

  /// No description provided for @disconnect.
  ///
  /// In en, this message translates to:
  /// **'DISCONNECT'**
  String get disconnect;

  /// No description provided for @searching.
  ///
  /// In en, this message translates to:
  /// **'SEARCHING...'**
  String get searching;

  /// No description provided for @makeSureDevicePowered.
  ///
  /// In en, this message translates to:
  /// **'Make sure your Divechecker device is powered on'**
  String get makeSureDevicePowered;

  /// No description provided for @sensorError.
  ///
  /// In en, this message translates to:
  /// **'Sensor Connection Error'**
  String get sensorError;

  /// No description provided for @sensorErrorDescription.
  ///
  /// In en, this message translates to:
  /// **'Measurement sensor not detected. Please check the connection.'**
  String get sensorErrorDescription;

  /// No description provided for @connectionRequired.
  ///
  /// In en, this message translates to:
  /// **'Connection Required'**
  String get connectionRequired;

  /// No description provided for @connectionRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'To start measurement, please connect to Divechecker device first.\n\nGo to Home tab and connect the device.'**
  String get connectionRequiredMessage;

  /// No description provided for @goToHome.
  ///
  /// In en, this message translates to:
  /// **'Go to Home'**
  String get goToHome;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @connectedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Divechecker connected successfully!'**
  String get connectedSuccess;

  /// No description provided for @disconnected.
  ///
  /// In en, this message translates to:
  /// **'Divechecker disconnected'**
  String get disconnected;

  /// No description provided for @startMeasurement.
  ///
  /// In en, this message translates to:
  /// **'START MEASUREMENT'**
  String get startMeasurement;

  /// No description provided for @stopMeasurement.
  ///
  /// In en, this message translates to:
  /// **'STOP MEASUREMENT'**
  String get stopMeasurement;

  /// No description provided for @pauseMeasurement.
  ///
  /// In en, this message translates to:
  /// **'PAUSE'**
  String get pauseMeasurement;

  /// No description provided for @resumeMeasurement.
  ///
  /// In en, this message translates to:
  /// **'RESUME'**
  String get resumeMeasurement;

  /// No description provided for @measurementStarted.
  ///
  /// In en, this message translates to:
  /// **'Measurement started'**
  String get measurementStarted;

  /// No description provided for @measurementPaused.
  ///
  /// In en, this message translates to:
  /// **'Measurement paused'**
  String get measurementPaused;

  /// No description provided for @measurementResumed.
  ///
  /// In en, this message translates to:
  /// **'Measurement resumed'**
  String get measurementResumed;

  /// No description provided for @measurementComplete.
  ///
  /// In en, this message translates to:
  /// **'Measurement Complete'**
  String get measurementComplete;

  /// No description provided for @measurementSaved.
  ///
  /// In en, this message translates to:
  /// **'Measurement saved successfully'**
  String get measurementSaved;

  /// No description provided for @measurementSettings.
  ///
  /// In en, this message translates to:
  /// **'MEASUREMENT'**
  String get measurementSettings;

  /// No description provided for @measurementNumber.
  ///
  /// In en, this message translates to:
  /// **'Measurement #{number}'**
  String measurementNumber(int number);

  /// No description provided for @currentPressure.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get currentPressure;

  /// No description provided for @maxPressure.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get maxPressure;

  /// No description provided for @avgPressure.
  ///
  /// In en, this message translates to:
  /// **'Avg'**
  String get avgPressure;

  /// No description provided for @elapsedTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get elapsedTime;

  /// No description provided for @pressureUnit.
  ///
  /// In en, this message translates to:
  /// **'Pressure Unit'**
  String get pressureUnit;

  /// No description provided for @sampleRate.
  ///
  /// In en, this message translates to:
  /// **'Sample Rate'**
  String get sampleRate;

  /// No description provided for @msInterval.
  ///
  /// In en, this message translates to:
  /// **'ms interval'**
  String get msInterval;

  /// No description provided for @maxPressureLabel.
  ///
  /// In en, this message translates to:
  /// **'Max Pressure'**
  String get maxPressureLabel;

  /// No description provided for @avgPressureLabel.
  ///
  /// In en, this message translates to:
  /// **'Avg Pressure'**
  String get avgPressureLabel;

  /// No description provided for @durationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get durationLabel;

  /// No description provided for @pressureAnalysis.
  ///
  /// In en, this message translates to:
  /// **'PRESSURE ANALYSIS'**
  String get pressureAnalysis;

  /// No description provided for @saveSession.
  ///
  /// In en, this message translates to:
  /// **'Save Session'**
  String get saveSession;

  /// No description provided for @saveSessionQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you want to save this measurement session?'**
  String get saveSessionQuestion;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @sessionSaved.
  ///
  /// In en, this message translates to:
  /// **'Session saved successfully'**
  String get sessionSaved;

  /// No description provided for @sessionDiscarded.
  ///
  /// In en, this message translates to:
  /// **'Session discarded'**
  String get sessionDiscarded;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No Data'**
  String get noData;

  /// No description provided for @awaitingData.
  ///
  /// In en, this message translates to:
  /// **'Awaiting measurement data'**
  String get awaitingData;

  /// No description provided for @noMeasurements.
  ///
  /// In en, this message translates to:
  /// **'No measurements yet'**
  String get noMeasurements;

  /// No description provided for @startMeasuringHint.
  ///
  /// In en, this message translates to:
  /// **'Start measuring in the Measurement tab'**
  String get startMeasuringHint;

  /// No description provided for @sessionHistory.
  ///
  /// In en, this message translates to:
  /// **'Session History'**
  String get sessionHistory;

  /// No description provided for @noSessions.
  ///
  /// In en, this message translates to:
  /// **'No sessions yet'**
  String get noSessions;

  /// No description provided for @startMeasuringToSee.
  ///
  /// In en, this message translates to:
  /// **'Start measuring to see your history here'**
  String get startMeasuringToSee;

  /// No description provided for @deleteSession.
  ///
  /// In en, this message translates to:
  /// **'Delete Session'**
  String get deleteSession;

  /// No description provided for @deleteSessionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this session?'**
  String get deleteSessionConfirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @sessionDeleted.
  ///
  /// In en, this message translates to:
  /// **'Session deleted'**
  String get sessionDeleted;

  /// No description provided for @deleteRecord.
  ///
  /// In en, this message translates to:
  /// **'Delete Record'**
  String get deleteRecord;

  /// No description provided for @deleteRecordConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this measurement record?'**
  String get deleteRecordConfirm;

  /// No description provided for @recordDeleted.
  ///
  /// In en, this message translates to:
  /// **'Record deleted'**
  String get recordDeleted;

  /// No description provided for @graphDetails.
  ///
  /// In en, this message translates to:
  /// **'Graph Details'**
  String get graphDetails;

  /// No description provided for @zoomIn.
  ///
  /// In en, this message translates to:
  /// **'Zoom In'**
  String get zoomIn;

  /// No description provided for @zoomOut.
  ///
  /// In en, this message translates to:
  /// **'Zoom Out'**
  String get zoomOut;

  /// No description provided for @resetZoom.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetZoom;

  /// No description provided for @panLeft.
  ///
  /// In en, this message translates to:
  /// **'Pan Left'**
  String get panLeft;

  /// No description provided for @panRight.
  ///
  /// In en, this message translates to:
  /// **'Pan Right'**
  String get panRight;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add Note'**
  String get addNote;

  /// No description provided for @editNote.
  ///
  /// In en, this message translates to:
  /// **'Edit Note'**
  String get editNote;

  /// No description provided for @noteOptional.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get noteOptional;

  /// No description provided for @noteHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a note for this session'**
  String get noteHint;

  /// No description provided for @noteContent.
  ///
  /// In en, this message translates to:
  /// **'Note content'**
  String get noteContent;

  /// No description provided for @noteAdded.
  ///
  /// In en, this message translates to:
  /// **'Note added'**
  String get noteAdded;

  /// No description provided for @noteUpdated.
  ///
  /// In en, this message translates to:
  /// **'Note updated'**
  String get noteUpdated;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @noteInfo.
  ///
  /// In en, this message translates to:
  /// **'Note Info'**
  String get noteInfo;

  /// No description provided for @noNotes.
  ///
  /// In en, this message translates to:
  /// **'No notes'**
  String get noNotes;

  /// No description provided for @tapGraphToAddNote.
  ///
  /// In en, this message translates to:
  /// **'Tap the graph to add notes'**
  String get tapGraphToAddNote;

  /// No description provided for @timePoint.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s mark'**
  String timePoint(int seconds);

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @dataPoints.
  ///
  /// In en, this message translates to:
  /// **'Data Points'**
  String get dataPoints;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @korean.
  ///
  /// In en, this message translates to:
  /// **'Korean'**
  String get korean;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'APPEARANCE'**
  String get appearance;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred theme'**
  String get themeDescription;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'NOTIFICATIONS'**
  String get notifications;

  /// No description provided for @enableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications;

  /// No description provided for @getAlertsForMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Get alerts for measurements'**
  String get getAlertsForMeasurements;

  /// No description provided for @hapticFeedback.
  ///
  /// In en, this message translates to:
  /// **'Haptic Feedback'**
  String get hapticFeedback;

  /// No description provided for @vibrateOnKeyActions.
  ///
  /// In en, this message translates to:
  /// **'Vibrate on key actions'**
  String get vibrateOnKeyActions;

  /// No description provided for @editTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Title'**
  String get editTitle;

  /// No description provided for @sessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Session Title'**
  String get sessionTitle;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'ABOUT'**
  String get about;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpAndSupport;

  /// No description provided for @licenses.
  ///
  /// In en, this message translates to:
  /// **'Licenses'**
  String get licenses;

  /// No description provided for @liveMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Live monitoring'**
  String get liveMonitoring;

  /// No description provided for @currentPressureLabel.
  ///
  /// In en, this message translates to:
  /// **'CURRENT PRESSURE'**
  String get currentPressureLabel;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @minutesSeconds.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m {seconds}s'**
  String minutesSeconds(int minutes, int seconds);

  /// No description provided for @secondsOnly.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s'**
  String secondsOnly(int seconds);

  /// No description provided for @tapToExpand.
  ///
  /// In en, this message translates to:
  /// **'Tap to expand'**
  String get tapToExpand;

  /// No description provided for @measurementHistory.
  ///
  /// In en, this message translates to:
  /// **'MEASUREMENT HISTORY'**
  String get measurementHistory;

  /// No description provided for @filterByDevice.
  ///
  /// In en, this message translates to:
  /// **'Filter by Device'**
  String get filterByDevice;

  /// No description provided for @selectDevice.
  ///
  /// In en, this message translates to:
  /// **'Select Device'**
  String get selectDevice;

  /// No description provided for @allDevices.
  ///
  /// In en, this message translates to:
  /// **'All Devices'**
  String get allDevices;

  /// No description provided for @sessionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} sessions'**
  String sessionsCount(int count);

  /// No description provided for @deviceSettings.
  ///
  /// In en, this message translates to:
  /// **'Device Settings'**
  String get deviceSettings;

  /// No description provided for @deviceName.
  ///
  /// In en, this message translates to:
  /// **'Device Name'**
  String get deviceName;

  /// No description provided for @changeDeviceName.
  ///
  /// In en, this message translates to:
  /// **'Change Device Name'**
  String get changeDeviceName;

  /// No description provided for @enterNewDeviceName.
  ///
  /// In en, this message translates to:
  /// **'Enter new device name'**
  String get enterNewDeviceName;

  /// No description provided for @devicePin.
  ///
  /// In en, this message translates to:
  /// **'Device PIN'**
  String get devicePin;

  /// No description provided for @changeDevicePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changeDevicePin;

  /// No description provided for @enterCurrentPin.
  ///
  /// In en, this message translates to:
  /// **'Enter current PIN'**
  String get enterCurrentPin;

  /// No description provided for @enterNewPin.
  ///
  /// In en, this message translates to:
  /// **'Enter new PIN (4 digits)'**
  String get enterNewPin;

  /// No description provided for @confirmNewPin.
  ///
  /// In en, this message translates to:
  /// **'Confirm new PIN'**
  String get confirmNewPin;

  /// No description provided for @wrongPin.
  ///
  /// In en, this message translates to:
  /// **'Wrong PIN'**
  String get wrongPin;

  /// No description provided for @pinChanged.
  ///
  /// In en, this message translates to:
  /// **'PIN changed successfully'**
  String get pinChanged;

  /// No description provided for @nameChanged.
  ///
  /// In en, this message translates to:
  /// **'Device name changed'**
  String get nameChanged;

  /// No description provided for @pinMustBe4Digits.
  ///
  /// In en, this message translates to:
  /// **'PIN must be 4 digits'**
  String get pinMustBe4Digits;

  /// No description provided for @pinsMustMatch.
  ///
  /// In en, this message translates to:
  /// **'PINs do not match'**
  String get pinsMustMatch;

  /// No description provided for @nameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Name too long (max 8 Korean chars or 24 English chars)'**
  String get nameTooLong;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @liveSensorData.
  ///
  /// In en, this message translates to:
  /// **'LIVE SENSOR DATA'**
  String get liveSensorData;

  /// No description provided for @recording.
  ///
  /// In en, this message translates to:
  /// **'REC'**
  String get recording;

  /// No description provided for @openSourceLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open Source Licenses'**
  String get openSourceLicenses;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'Freediving Equalizing Tool'**
  String get appDescription;

  /// No description provided for @samples.
  ///
  /// In en, this message translates to:
  /// **'SAMPLES'**
  String get samples;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'points'**
  String get points;

  /// No description provided for @analyticsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Advanced analytics coming soon'**
  String get analyticsComingSoon;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @pressureWaveform.
  ///
  /// In en, this message translates to:
  /// **'PRESSURE WAVEFORM'**
  String get pressureWaveform;

  /// No description provided for @peak.
  ///
  /// In en, this message translates to:
  /// **'PEAK'**
  String get peak;

  /// No description provided for @average.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get average;

  /// No description provided for @sec.
  ///
  /// In en, this message translates to:
  /// **'sec'**
  String get sec;

  /// No description provided for @deviceConnectedReady.
  ///
  /// In en, this message translates to:
  /// **'Device Connected - Ready to measure'**
  String get deviceConnectedReady;

  /// No description provided for @deviceNotConnectedShort.
  ///
  /// In en, this message translates to:
  /// **'Device Not Connected'**
  String get deviceNotConnectedShort;

  /// No description provided for @tapToBeginMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Tap to begin pressure monitoring'**
  String get tapToBeginMonitoring;

  /// No description provided for @sampleCount.
  ///
  /// In en, this message translates to:
  /// **'{count} samples'**
  String sampleCount(int count);

  /// No description provided for @noNotesYetTapEdit.
  ///
  /// In en, this message translates to:
  /// **'No notes yet. Tap edit to add one or add notes on the graph.'**
  String get noNotesYetTapEdit;

  /// No description provided for @madeWithFlutter.
  ///
  /// In en, this message translates to:
  /// **'Made with Flutter'**
  String get madeWithFlutter;

  /// No description provided for @mitLicense.
  ///
  /// In en, this message translates to:
  /// **'Apache License 2.0'**
  String get mitLicense;

  /// No description provided for @mitLicenseContent.
  ///
  /// In en, this message translates to:
  /// **'You may use, modify, and distribute with proper attribution and inclusion of the license and NOTICE file; provided \"AS IS\" without warranty.'**
  String get mitLicenseContent;

  /// No description provided for @bleConnectivity.
  ///
  /// In en, this message translates to:
  /// **'BLE connectivity'**
  String get bleConnectivity;

  /// No description provided for @chartVisualization.
  ///
  /// In en, this message translates to:
  /// **'Chart visualization'**
  String get chartVisualization;

  /// No description provided for @sqliteDatabase.
  ///
  /// In en, this message translates to:
  /// **'SQLite database'**
  String get sqliteDatabase;

  /// No description provided for @stateManagement.
  ///
  /// In en, this message translates to:
  /// **'State management'**
  String get stateManagement;

  /// No description provided for @localStorage.
  ///
  /// In en, this message translates to:
  /// **'Local storage'**
  String get localStorage;

  /// No description provided for @internationalization.
  ///
  /// In en, this message translates to:
  /// **'Internationalization'**
  String get internationalization;

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'Copyright'**
  String get copyright;

  /// No description provided for @allRightsReserved.
  ///
  /// In en, this message translates to:
  /// **'All Rights Reserved'**
  String get allRightsReserved;

  /// No description provided for @tapToViewFullLicense.
  ///
  /// In en, this message translates to:
  /// **'Tap to view full license'**
  String get tapToViewFullLicense;

  /// No description provided for @analysis.
  ///
  /// In en, this message translates to:
  /// **'Analysis'**
  String get analysis;

  /// No description provided for @advancedAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Advanced Analysis'**
  String get advancedAnalysis;

  /// No description provided for @peakAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Peak Analysis'**
  String get peakAnalysis;

  /// No description provided for @peakAnalysisDesc.
  ///
  /// In en, this message translates to:
  /// **'Detect peaks and analyze equalization patterns'**
  String get peakAnalysisDesc;

  /// No description provided for @statisticsDashboard.
  ///
  /// In en, this message translates to:
  /// **'Statistics Dashboard'**
  String get statisticsDashboard;

  /// No description provided for @statisticsDashboardDesc.
  ///
  /// In en, this message translates to:
  /// **'View daily/weekly/monthly statistics'**
  String get statisticsDashboardDesc;

  /// No description provided for @segmentAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Segment Analysis'**
  String get segmentAnalysis;

  /// No description provided for @segmentAnalysisDesc.
  ///
  /// In en, this message translates to:
  /// **'Analyze and compare specific time segments'**
  String get segmentAnalysisDesc;

  /// No description provided for @trendGraph.
  ///
  /// In en, this message translates to:
  /// **'Trend Graph'**
  String get trendGraph;

  /// No description provided for @trendGraphDesc.
  ///
  /// In en, this message translates to:
  /// **'Track your progress over time'**
  String get trendGraphDesc;

  /// No description provided for @patternRecognition.
  ///
  /// In en, this message translates to:
  /// **'Pattern Recognition'**
  String get patternRecognition;

  /// No description provided for @patternRecognitionDesc.
  ///
  /// In en, this message translates to:
  /// **'Compare with ideal Frenzel patterns'**
  String get patternRecognitionDesc;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @featureInDevelopment.
  ///
  /// In en, this message translates to:
  /// **'This feature is currently under development.'**
  String get featureInDevelopment;

  /// No description provided for @noSessionsForAnalysis.
  ///
  /// In en, this message translates to:
  /// **'No sessions available for analysis'**
  String get noSessionsForAnalysis;

  /// No description provided for @selectSession.
  ///
  /// In en, this message translates to:
  /// **'Select Session'**
  String get selectSession;

  /// No description provided for @backToMenu.
  ///
  /// In en, this message translates to:
  /// **'Back to Menu'**
  String get backToMenu;

  /// No description provided for @keyMetrics.
  ///
  /// In en, this message translates to:
  /// **'Key Metrics'**
  String get keyMetrics;

  /// No description provided for @totalPeaks.
  ///
  /// In en, this message translates to:
  /// **'Total Peaks'**
  String get totalPeaks;

  /// No description provided for @peaksUnit.
  ///
  /// In en, this message translates to:
  /// **'peaks'**
  String get peaksUnit;

  /// No description provided for @peakFrequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get peakFrequency;

  /// No description provided for @perMinute.
  ///
  /// In en, this message translates to:
  /// **'/min'**
  String get perMinute;

  /// No description provided for @avgPeakInterval.
  ///
  /// In en, this message translates to:
  /// **'Avg Interval'**
  String get avgPeakInterval;

  /// No description provided for @avgPeakPressure.
  ///
  /// In en, this message translates to:
  /// **'Avg Peak'**
  String get avgPeakPressure;

  /// No description provided for @performanceScores.
  ///
  /// In en, this message translates to:
  /// **'Performance Scores'**
  String get performanceScores;

  /// No description provided for @consistencyScore.
  ///
  /// In en, this message translates to:
  /// **'Consistency Score'**
  String get consistencyScore;

  /// No description provided for @fatigueIndex.
  ///
  /// In en, this message translates to:
  /// **'Fatigue Index'**
  String get fatigueIndex;

  /// No description provided for @consistencyExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent! Very consistent equalization technique.'**
  String get consistencyExcellent;

  /// No description provided for @consistencyGood.
  ///
  /// In en, this message translates to:
  /// **'Good. Minor variations in pressure and timing.'**
  String get consistencyGood;

  /// No description provided for @consistencyFair.
  ///
  /// In en, this message translates to:
  /// **'Fair. Room for improvement in consistency.'**
  String get consistencyFair;

  /// No description provided for @consistencyNeedsWork.
  ///
  /// In en, this message translates to:
  /// **'Needs work. Practice for more consistent technique.'**
  String get consistencyNeedsWork;

  /// No description provided for @fatigueMinimal.
  ///
  /// In en, this message translates to:
  /// **'Minimal fatigue detected. Great endurance!'**
  String get fatigueMinimal;

  /// No description provided for @fatigueLow.
  ///
  /// In en, this message translates to:
  /// **'Low fatigue. Performance maintained well.'**
  String get fatigueLow;

  /// No description provided for @fatigueModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate fatigue. Consider shorter sessions.'**
  String get fatigueModerate;

  /// No description provided for @fatigueHigh.
  ///
  /// In en, this message translates to:
  /// **'High fatigue. Pressure decreased significantly.'**
  String get fatigueHigh;

  /// No description provided for @detailedStats.
  ///
  /// In en, this message translates to:
  /// **'Detailed Statistics'**
  String get detailedStats;

  /// No description provided for @maxPeakPressure.
  ///
  /// In en, this message translates to:
  /// **'Max Peak Pressure'**
  String get maxPeakPressure;

  /// No description provided for @minPeakPressure.
  ///
  /// In en, this message translates to:
  /// **'Min Peak Pressure'**
  String get minPeakPressure;

  /// No description provided for @pressureRange.
  ///
  /// In en, this message translates to:
  /// **'Pressure Range'**
  String get pressureRange;

  /// No description provided for @peakVisualization.
  ///
  /// In en, this message translates to:
  /// **'Peak Visualization'**
  String get peakVisualization;

  /// No description provided for @detectedPeaks.
  ///
  /// In en, this message translates to:
  /// **'Detected Peaks'**
  String get detectedPeaks;

  /// No description provided for @dataManagement.
  ///
  /// In en, this message translates to:
  /// **'DATA MANAGEMENT'**
  String get dataManagement;

  /// No description provided for @backupData.
  ///
  /// In en, this message translates to:
  /// **'Backup Data'**
  String get backupData;

  /// No description provided for @backupDataDescription.
  ///
  /// In en, this message translates to:
  /// **'Export all data as JSON file'**
  String get backupDataDescription;

  /// No description provided for @restoreData.
  ///
  /// In en, this message translates to:
  /// **'Restore Data'**
  String get restoreData;

  /// No description provided for @restoreDataDescription.
  ///
  /// In en, this message translates to:
  /// **'Import data from backup file'**
  String get restoreDataDescription;

  /// No description provided for @backupSuccess.
  ///
  /// In en, this message translates to:
  /// **'Backup completed successfully'**
  String get backupSuccess;

  /// No description provided for @backupFailed.
  ///
  /// In en, this message translates to:
  /// **'Backup failed'**
  String get backupFailed;

  /// No description provided for @restoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'Restore completed successfully'**
  String get restoreSuccess;

  /// No description provided for @restoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Restore failed'**
  String get restoreFailed;

  /// No description provided for @restoreConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm Restore'**
  String get restoreConfirm;

  /// No description provided for @restoreConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This will replace all existing data. Continue?'**
  String get restoreConfirmMessage;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @invalidBackupFile.
  ///
  /// In en, this message translates to:
  /// **'Invalid backup file'**
  String get invalidBackupFile;

  /// No description provided for @dataPointsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} data points'**
  String dataPointsCount(int count);

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'DiveChecker'**
  String get appName;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Equalizing Pressure Monitor'**
  String get appSubtitle;

  /// No description provided for @appTitleFull.
  ///
  /// In en, this message translates to:
  /// **'DiveChecker Pro'**
  String get appTitleFull;

  /// No description provided for @statusOnline.
  ///
  /// In en, this message translates to:
  /// **'ONLINE'**
  String get statusOnline;

  /// No description provided for @statusOffline.
  ///
  /// In en, this message translates to:
  /// **'OFFLINE'**
  String get statusOffline;

  /// No description provided for @statusScanning.
  ///
  /// In en, this message translates to:
  /// **'SCANNING...'**
  String get statusScanning;

  /// No description provided for @statusRecording.
  ///
  /// In en, this message translates to:
  /// **'REC'**
  String get statusRecording;

  /// No description provided for @measurementScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'PRESSURE MEASUREMENT'**
  String get measurementScreenTitle;

  /// No description provided for @historyScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'MEASUREMENT HISTORY'**
  String get historyScreenTitle;

  /// No description provided for @settingsScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get settingsScreenTitle;

  /// No description provided for @segmentAvgPressureComparison.
  ///
  /// In en, this message translates to:
  /// **'Segment Average Pressure Comparison'**
  String get segmentAvgPressureComparison;

  /// No description provided for @segmentDetailedAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Segment Detailed Analysis'**
  String get segmentDetailedAnalysis;

  /// No description provided for @segmentChangeAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Segment Change Analysis'**
  String get segmentChangeAnalysis;

  /// No description provided for @segmentNumber.
  ///
  /// In en, this message translates to:
  /// **'Segment {number}'**
  String segmentNumber(int number);

  /// No description provided for @segmentTooltip.
  ///
  /// In en, this message translates to:
  /// **'Segment {index}\\nAvg: {avgPressure} hPa\\nPeaks: {peakCount}'**
  String segmentTooltip(int index, String avgPressure, int peakCount);

  /// No description provided for @avgLabel.
  ///
  /// In en, this message translates to:
  /// **'Avg'**
  String get avgLabel;

  /// No description provided for @maxLabel.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get maxLabel;

  /// No description provided for @peakLabel.
  ///
  /// In en, this message translates to:
  /// **'Peak'**
  String get peakLabel;

  /// No description provided for @countUnit.
  ///
  /// In en, this message translates to:
  /// **'times'**
  String get countUnit;

  /// No description provided for @variabilityLabel.
  ///
  /// In en, this message translates to:
  /// **'Variability'**
  String get variabilityLabel;

  /// No description provided for @notEnoughSegments.
  ///
  /// In en, this message translates to:
  /// **'Not enough segments'**
  String get notEnoughSegments;

  /// No description provided for @stablePressureAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Stable pressure! Consistent performance from start to finish.'**
  String get stablePressureAnalysis;

  /// No description provided for @pressureIncreaseAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Pressure increased by {percent}% towards the end. Warmup effect or stronger equalization.'**
  String pressureIncreaseAnalysis(String percent);

  /// No description provided for @pressureDecreaseAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Pressure decreased by {percent}% towards the end. Fatigue may be accumulating. Consider rest.'**
  String pressureDecreaseAnalysis(String percent);

  /// No description provided for @trendStable.
  ///
  /// In en, this message translates to:
  /// **'Stable'**
  String get trendStable;

  /// No description provided for @trendRising.
  ///
  /// In en, this message translates to:
  /// **'Rising trend'**
  String get trendRising;

  /// No description provided for @trendFalling.
  ///
  /// In en, this message translates to:
  /// **'Falling trend'**
  String get trendFalling;

  /// No description provided for @firstToLast.
  ///
  /// In en, this message translates to:
  /// **'First → Last'**
  String get firstToLast;

  /// No description provided for @peakCountChange.
  ///
  /// In en, this message translates to:
  /// **'Peak count change'**
  String get peakCountChange;

  /// No description provided for @trendRising2.
  ///
  /// In en, this message translates to:
  /// **'Rising'**
  String get trendRising2;

  /// No description provided for @trendFalling2.
  ///
  /// In en, this message translates to:
  /// **'Falling'**
  String get trendFalling2;

  /// No description provided for @trendMaintained.
  ///
  /// In en, this message translates to:
  /// **'Maintained'**
  String get trendMaintained;

  /// No description provided for @overallTrend.
  ///
  /// In en, this message translates to:
  /// **'Overall trend: {trend}'**
  String overallTrend(String trend);

  /// No description provided for @slopeLabel.
  ///
  /// In en, this message translates to:
  /// **'Slope: {slope} hPa/sec'**
  String slopeLabel(String slope);

  /// No description provided for @pressureTrendGraph.
  ///
  /// In en, this message translates to:
  /// **'Pressure Trend Graph'**
  String get pressureTrendGraph;

  /// No description provided for @originalData.
  ///
  /// In en, this message translates to:
  /// **'Original data'**
  String get originalData;

  /// No description provided for @movingAverage.
  ///
  /// In en, this message translates to:
  /// **'Moving average'**
  String get movingAverage;

  /// No description provided for @trendLine.
  ///
  /// In en, this message translates to:
  /// **'Trend line'**
  String get trendLine;

  /// No description provided for @trendAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Trend Analysis'**
  String get trendAnalysis;

  /// No description provided for @startPressureTrend.
  ///
  /// In en, this message translates to:
  /// **'Start pressure (trend)'**
  String get startPressureTrend;

  /// No description provided for @endPressureTrend.
  ///
  /// In en, this message translates to:
  /// **'End pressure (trend)'**
  String get endPressureTrend;

  /// No description provided for @changeAmount.
  ///
  /// In en, this message translates to:
  /// **'Change amount'**
  String get changeAmount;

  /// No description provided for @changeRate.
  ///
  /// In en, this message translates to:
  /// **'Change rate'**
  String get changeRate;

  /// No description provided for @strongRisingTrend.
  ///
  /// In en, this message translates to:
  /// **'Strong rising trend'**
  String get strongRisingTrend;

  /// No description provided for @strongRisingDesc.
  ///
  /// In en, this message translates to:
  /// **'Pressure increases significantly over time. Muscles may be warmed up or you are applying more force.'**
  String get strongRisingDesc;

  /// No description provided for @moderateRisingTrend.
  ///
  /// In en, this message translates to:
  /// **'Moderate rising trend'**
  String get moderateRisingTrend;

  /// No description provided for @moderateRisingDesc.
  ///
  /// In en, this message translates to:
  /// **'Pressure gradually increases. Good warmup pattern.'**
  String get moderateRisingDesc;

  /// No description provided for @stableMaintained.
  ///
  /// In en, this message translates to:
  /// **'Stable maintenance'**
  String get stableMaintained;

  /// No description provided for @stableMaintainedDesc.
  ///
  /// In en, this message translates to:
  /// **'Pressure maintained consistently. Shows excellent endurance and consistency!'**
  String get stableMaintainedDesc;

  /// No description provided for @moderateFallingTrend.
  ///
  /// In en, this message translates to:
  /// **'Moderate falling trend'**
  String get moderateFallingTrend;

  /// No description provided for @moderateFallingDesc.
  ///
  /// In en, this message translates to:
  /// **'Pressure gradually decreases. Some fatigue may be accumulating. Consider rest.'**
  String get moderateFallingDesc;

  /// No description provided for @strongFallingTrend.
  ///
  /// In en, this message translates to:
  /// **'Strong falling trend'**
  String get strongFallingTrend;

  /// No description provided for @strongFallingDesc.
  ///
  /// In en, this message translates to:
  /// **'Pressure decreases significantly. Fatigue has accumulated. Sufficient rest is needed.'**
  String get strongFallingDesc;

  /// No description provided for @continuousPerformanceAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Continuous Performance Analysis'**
  String get continuousPerformanceAnalysis;

  /// No description provided for @patternComparison.
  ///
  /// In en, this message translates to:
  /// **'Pattern Comparison'**
  String get patternComparison;

  /// No description provided for @peakQualityHeatmap.
  ///
  /// In en, this message translates to:
  /// **'Peak Quality Heatmap'**
  String get peakQualityHeatmap;

  /// No description provided for @patternCharacteristics.
  ///
  /// In en, this message translates to:
  /// **'Pattern Characteristics'**
  String get patternCharacteristics;

  /// No description provided for @customTrainingSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Custom Training Suggestions'**
  String get customTrainingSuggestions;

  /// No description provided for @maxConsecutive.
  ///
  /// In en, this message translates to:
  /// **'Max consecutive'**
  String get maxConsecutive;

  /// No description provided for @avgConsecutive.
  ///
  /// In en, this message translates to:
  /// **'Avg consecutive'**
  String get avgConsecutive;

  /// No description provided for @qualityPeaks.
  ///
  /// In en, this message translates to:
  /// **'Quality peaks'**
  String get qualityPeaks;

  /// No description provided for @excellentConsistency.
  ///
  /// In en, this message translates to:
  /// **'Excellent! Maintaining consistent quality over time. Keep up this level.'**
  String get excellentConsistency;

  /// No description provided for @goodConsistency.
  ///
  /// In en, this message translates to:
  /// **'Good! Nice continuity. Aim for longer consecutive streaks.'**
  String get goodConsistency;

  /// No description provided for @moderateConsistency.
  ///
  /// In en, this message translates to:
  /// **'Moderate. Maintain focus to increase consecutive quality peaks.'**
  String get moderateConsistency;

  /// No description provided for @needsImprovementConsistency.
  ///
  /// In en, this message translates to:
  /// **'Needs improvement. Focus more on each equalization.'**
  String get needsImprovementConsistency;

  /// No description provided for @masterPhase.
  ///
  /// In en, this message translates to:
  /// **'Master phase'**
  String get masterPhase;

  /// No description provided for @masterPhaseDesc.
  ///
  /// In en, this message translates to:
  /// **'Advanced technique refinement and special situation preparation'**
  String get masterPhaseDesc;

  /// No description provided for @masterFocuses.
  ///
  /// In en, this message translates to:
  /// **'Dynamic equalization,High pressure simulation,Duration extension'**
  String get masterFocuses;

  /// No description provided for @advancedPhase.
  ///
  /// In en, this message translates to:
  /// **'Advanced phase'**
  String get advancedPhase;

  /// No description provided for @advancedPhaseDesc.
  ///
  /// In en, this message translates to:
  /// **'Consistency improvement and advanced technique acquisition'**
  String get advancedPhaseDesc;

  /// No description provided for @advancedFocuses.
  ///
  /// In en, this message translates to:
  /// **'Pressure consistency enhancement,Rhythm optimization,Fatigue resistance training'**
  String get advancedFocuses;

  /// No description provided for @intermediatePhase.
  ///
  /// In en, this message translates to:
  /// **'Intermediate phase'**
  String get intermediatePhase;

  /// No description provided for @intermediatePhaseDesc.
  ///
  /// In en, this message translates to:
  /// **'Basic skill stabilization and quality improvement'**
  String get intermediatePhaseDesc;

  /// No description provided for @intermediateFocuses.
  ///
  /// In en, this message translates to:
  /// **'Accurate timing,Finding optimal pressure,Repeated practice'**
  String get intermediateFocuses;

  /// No description provided for @basicPhase.
  ///
  /// In en, this message translates to:
  /// **'Basic phase'**
  String get basicPhase;

  /// No description provided for @basicPhaseDesc.
  ///
  /// In en, this message translates to:
  /// **'Basic movement acquisition and sensory development'**
  String get basicPhaseDesc;

  /// No description provided for @basicFocuses.
  ///
  /// In en, this message translates to:
  /// **'Basic posture,Breathing control,Low pressure practice'**
  String get basicFocuses;

  /// No description provided for @currentFocusAreas.
  ///
  /// In en, this message translates to:
  /// **'Current focus areas:'**
  String get currentFocusAreas;

  /// No description provided for @peakScore.
  ///
  /// In en, this message translates to:
  /// **'Peak {index}: {score} points'**
  String peakScore(int index, String score);

  /// No description provided for @rhythmImprovementTraining.
  ///
  /// In en, this message translates to:
  /// **'Rhythm improvement training'**
  String get rhythmImprovementTraining;

  /// No description provided for @rhythmTip1.
  ///
  /// In en, this message translates to:
  /// **'Use a metronome app to practice at a steady beat'**
  String get rhythmTip1;

  /// No description provided for @rhythmTip2.
  ///
  /// In en, this message translates to:
  /// **'Count: Equalize to a 1-2-3-4 rhythm'**
  String get rhythmTip2;

  /// No description provided for @rhythmTip3.
  ///
  /// In en, this message translates to:
  /// **'Start slowly and gradually increase speed'**
  String get rhythmTip3;

  /// No description provided for @pressureConsistencyTraining.
  ///
  /// In en, this message translates to:
  /// **'Pressure consistency training'**
  String get pressureConsistencyTraining;

  /// No description provided for @pressureTip1.
  ///
  /// In en, this message translates to:
  /// **'Aim for 10 consecutive equalizations with the same force'**
  String get pressureTip1;

  /// No description provided for @pressureTip2.
  ///
  /// In en, this message translates to:
  /// **'Watch your cheek and tongue movements in a mirror to keep them consistent'**
  String get pressureTip2;

  /// No description provided for @pressureTip3.
  ///
  /// In en, this message translates to:
  /// **'Find a comfortable pressure without pushing too hard'**
  String get pressureTip3;

  /// No description provided for @frequencyOptimizationTraining.
  ///
  /// In en, this message translates to:
  /// **'Frequency optimization training'**
  String get frequencyOptimizationTraining;

  /// No description provided for @frequencyTip1.
  ///
  /// In en, this message translates to:
  /// **'Ideal frequency is 20-40 times per minute'**
  String get frequencyTip1;

  /// No description provided for @frequencyTip2.
  ///
  /// In en, this message translates to:
  /// **'Make each equalization sufficient'**
  String get frequencyTip2;

  /// No description provided for @frequencyTip3.
  ///
  /// In en, this message translates to:
  /// **'Avoid unnecessarily rapid equalizations'**
  String get frequencyTip3;

  /// No description provided for @enduranceTraining.
  ///
  /// In en, this message translates to:
  /// **'Endurance improvement training'**
  String get enduranceTraining;

  /// No description provided for @enduranceTip1.
  ///
  /// In en, this message translates to:
  /// **'Gradually increase practice time'**
  String get enduranceTip1;

  /// No description provided for @enduranceTip2.
  ///
  /// In en, this message translates to:
  /// **'Balance rest and training'**
  String get enduranceTip2;

  /// No description provided for @enduranceTip3.
  ///
  /// In en, this message translates to:
  /// **'Regular practice is key to endurance improvement'**
  String get enduranceTip3;

  /// No description provided for @irregularIntervalSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Equalization intervals are irregular. Practice with a consistent rhythm.'**
  String get irregularIntervalSuggestion;

  /// No description provided for @irregularPressureSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Peak pressure is irregular. Practice equalizing with consistent force.'**
  String get irregularPressureSuggestion;

  /// No description provided for @lowFrequencySuggestion.
  ///
  /// In en, this message translates to:
  /// **'Equalization frequency is low. Practice equalizing more frequently.'**
  String get lowFrequencySuggestion;

  /// No description provided for @highFrequencySuggestion.
  ///
  /// In en, this message translates to:
  /// **'Equalization is too frequent. Focus more on each equalization.'**
  String get highFrequencySuggestion;

  /// No description provided for @fatigueDetectedSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Pressure decreases towards the end. Endurance training may help.'**
  String get fatigueDetectedSuggestion;

  /// No description provided for @excellentPattern.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get excellentPattern;

  /// No description provided for @excellentPatternDesc.
  ///
  /// In en, this message translates to:
  /// **'Close to ideal Frenzel pattern!'**
  String get excellentPatternDesc;

  /// No description provided for @minPressureLabel.
  ///
  /// In en, this message translates to:
  /// **'Min pressure'**
  String get minPressureLabel;

  /// No description provided for @goodPattern.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get goodPattern;

  /// No description provided for @goodPatternDesc.
  ///
  /// In en, this message translates to:
  /// **'Good basics. There are some improvements.'**
  String get goodPatternDesc;

  /// No description provided for @averagePattern.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get averagePattern;

  /// No description provided for @averagePatternDesc.
  ///
  /// In en, this message translates to:
  /// **'Basic pattern formed but needs improvement.'**
  String get averagePatternDesc;

  /// No description provided for @needsPractice.
  ///
  /// In en, this message translates to:
  /// **'Needs practice'**
  String get needsPractice;

  /// No description provided for @needsPracticeDesc.
  ///
  /// In en, this message translates to:
  /// **'More practice needed. See suggestions below.'**
  String get needsPracticeDesc;

  /// No description provided for @excellentPatternKeepUp.
  ///
  /// In en, this message translates to:
  /// **'Your current pattern is excellent! Keep it up.'**
  String get excellentPatternKeepUp;

  /// No description provided for @patternGrade.
  ///
  /// In en, this message translates to:
  /// **'Pattern grade: {grade}'**
  String patternGrade(String grade);

  /// No description provided for @rhythmLabel.
  ///
  /// In en, this message translates to:
  /// **'Rhythm'**
  String get rhythmLabel;

  /// No description provided for @pressureLabel.
  ///
  /// In en, this message translates to:
  /// **'Pressure'**
  String get pressureLabel;

  /// No description provided for @frequencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequencyLabel;

  /// No description provided for @enduranceLabel.
  ///
  /// In en, this message translates to:
  /// **'Endurance'**
  String get enduranceLabel;

  /// No description provided for @currentPattern.
  ///
  /// In en, this message translates to:
  /// **'Current pattern'**
  String get currentPattern;

  /// No description provided for @idealPattern.
  ///
  /// In en, this message translates to:
  /// **'Ideal pattern'**
  String get idealPattern;

  /// No description provided for @peakNumber.
  ///
  /// In en, this message translates to:
  /// **'Peak number'**
  String get peakNumber;

  /// No description provided for @rhythmConsistency.
  ///
  /// In en, this message translates to:
  /// **'Rhythm consistency'**
  String get rhythmConsistency;

  /// No description provided for @pressureConsistency.
  ///
  /// In en, this message translates to:
  /// **'Pressure consistency'**
  String get pressureConsistency;

  /// No description provided for @frequencyAdequacy.
  ///
  /// In en, this message translates to:
  /// **'Frequency adequacy'**
  String get frequencyAdequacy;

  /// No description provided for @veryGood.
  ///
  /// In en, this message translates to:
  /// **'Very good'**
  String get veryGood;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @needsImprovement.
  ///
  /// In en, this message translates to:
  /// **'Needs improvement'**
  String get needsImprovement;

  /// No description provided for @needsMorePractice.
  ///
  /// In en, this message translates to:
  /// **'Needs more practice'**
  String get needsMorePractice;

  /// No description provided for @noPeaksDetected.
  ///
  /// In en, this message translates to:
  /// **'No peaks detected'**
  String get noPeaksDetected;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get selectAll;

  /// No description provided for @deselectAll.
  ///
  /// In en, this message translates to:
  /// **'Deselect'**
  String get deselectAll;

  /// No description provided for @avgRiseTime.
  ///
  /// In en, this message translates to:
  /// **'Avg rise time'**
  String get avgRiseTime;

  /// No description provided for @avgFallTime.
  ///
  /// In en, this message translates to:
  /// **'Avg fall time'**
  String get avgFallTime;

  /// No description provided for @avgPeakWidth.
  ///
  /// In en, this message translates to:
  /// **'Avg peak width'**
  String get avgPeakWidth;

  /// No description provided for @outliers.
  ///
  /// In en, this message translates to:
  /// **'Outliers'**
  String get outliers;

  /// No description provided for @peakIntensityDistribution.
  ///
  /// In en, this message translates to:
  /// **'Peak intensity distribution'**
  String get peakIntensityDistribution;

  /// No description provided for @rhythmScore.
  ///
  /// In en, this message translates to:
  /// **'Rhythm score'**
  String get rhythmScore;

  /// No description provided for @pressureScoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Pressure score'**
  String get pressureScoreTitle;

  /// No description provided for @techniqueScore.
  ///
  /// In en, this message translates to:
  /// **'Technique score'**
  String get techniqueScore;

  /// No description provided for @fatigueResistance.
  ///
  /// In en, this message translates to:
  /// **'Fatigue resistance'**
  String get fatigueResistance;

  /// No description provided for @strongPeaks.
  ///
  /// In en, this message translates to:
  /// **'Strong peaks'**
  String get strongPeaks;

  /// No description provided for @moderatePeaks.
  ///
  /// In en, this message translates to:
  /// **'Moderate peaks'**
  String get moderatePeaks;

  /// No description provided for @weakPeaks.
  ///
  /// In en, this message translates to:
  /// **'Weak peaks'**
  String get weakPeaks;

  /// No description provided for @countWithPercent.
  ///
  /// In en, this message translates to:
  /// **'{count} ({percent}%)'**
  String countWithPercent(int count, String percent);

  /// No description provided for @overallGrade.
  ///
  /// In en, this message translates to:
  /// **'Overall grade'**
  String get overallGrade;

  /// No description provided for @excellentFrenzel.
  ///
  /// In en, this message translates to:
  /// **'Excellent Frenzel technique!'**
  String get excellentFrenzel;

  /// No description provided for @veryGoodTechnique.
  ///
  /// In en, this message translates to:
  /// **'Very good technique'**
  String get veryGoodTechnique;

  /// No description provided for @satisfactoryLevel.
  ///
  /// In en, this message translates to:
  /// **'Satisfactory level'**
  String get satisfactoryLevel;

  /// No description provided for @roomForImprovement.
  ///
  /// In en, this message translates to:
  /// **'Room for improvement'**
  String get roomForImprovement;

  /// No description provided for @moreTrainingNeeded.
  ///
  /// In en, this message translates to:
  /// **'More training needed'**
  String get moreTrainingNeeded;

  /// No description provided for @startFromBasics.
  ///
  /// In en, this message translates to:
  /// **'Start from basics'**
  String get startFromBasics;

  /// No description provided for @weak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get weak;

  /// No description provided for @moderate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get moderate;

  /// No description provided for @strong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get strong;

  /// No description provided for @weakIntensity.
  ///
  /// In en, this message translates to:
  /// **'Weak (<50hPa)'**
  String get weakIntensity;

  /// No description provided for @moderateIntensity.
  ///
  /// In en, this message translates to:
  /// **'Moderate (50-100)'**
  String get moderateIntensity;

  /// No description provided for @strongIntensity.
  ///
  /// In en, this message translates to:
  /// **'Strong (>100)'**
  String get strongIntensity;

  /// No description provided for @stabilityImproving.
  ///
  /// In en, this message translates to:
  /// **'Stability improving'**
  String get stabilityImproving;

  /// No description provided for @stabilityDecreasing.
  ///
  /// In en, this message translates to:
  /// **'Stability decreasing'**
  String get stabilityDecreasing;

  /// No description provided for @stabilityMaintained.
  ///
  /// In en, this message translates to:
  /// **'Stability maintained'**
  String get stabilityMaintained;

  /// No description provided for @stabilityTrend.
  ///
  /// In en, this message translates to:
  /// **'Stability trend'**
  String get stabilityTrend;

  /// No description provided for @pressureDistribution.
  ///
  /// In en, this message translates to:
  /// **'Pressure distribution'**
  String get pressureDistribution;

  /// No description provided for @basicStats.
  ///
  /// In en, this message translates to:
  /// **'Basic statistics'**
  String get basicStats;

  /// No description provided for @dataPointsLabel.
  ///
  /// In en, this message translates to:
  /// **'Data points'**
  String get dataPointsLabel;

  /// No description provided for @countUnitItems.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get countUnitItems;

  /// No description provided for @measurementTime.
  ///
  /// In en, this message translates to:
  /// **'Measurement time'**
  String get measurementTime;

  /// No description provided for @standardDeviation.
  ///
  /// In en, this message translates to:
  /// **'Standard deviation'**
  String get standardDeviation;

  /// No description provided for @advancedStats.
  ///
  /// In en, this message translates to:
  /// **'Advanced statistics'**
  String get advancedStats;

  /// No description provided for @coefficientOfVariation.
  ///
  /// In en, this message translates to:
  /// **'Coefficient of variation'**
  String get coefficientOfVariation;

  /// No description provided for @skewness.
  ///
  /// In en, this message translates to:
  /// **'Skewness'**
  String get skewness;

  /// No description provided for @kurtosis.
  ///
  /// In en, this message translates to:
  /// **'Kurtosis'**
  String get kurtosis;

  /// No description provided for @interquartileRange.
  ///
  /// In en, this message translates to:
  /// **'Interquartile range'**
  String get interquartileRange;

  /// No description provided for @dataDispersionIndicator.
  ///
  /// In en, this message translates to:
  /// **'Data dispersion indicator'**
  String get dataDispersionIndicator;

  /// No description provided for @pressureRangeLabel.
  ///
  /// In en, this message translates to:
  /// **'Pressure range'**
  String get pressureRangeLabel;

  /// No description provided for @rangeLabel.
  ///
  /// In en, this message translates to:
  /// **'Range'**
  String get rangeLabel;

  /// No description provided for @outlierCount.
  ///
  /// In en, this message translates to:
  /// **'{count} ({percent}%)'**
  String outlierCount(int count, String percent);

  /// No description provided for @percentiles.
  ///
  /// In en, this message translates to:
  /// **'Percentiles'**
  String get percentiles;

  /// No description provided for @median50.
  ///
  /// In en, this message translates to:
  /// **'Median (50%)'**
  String get median50;

  /// No description provided for @peakSummary.
  ///
  /// In en, this message translates to:
  /// **'Peak summary'**
  String get peakSummary;

  /// No description provided for @strongPeakRatio.
  ///
  /// In en, this message translates to:
  /// **'Strong peak ratio'**
  String get strongPeakRatio;

  /// No description provided for @dataQuality.
  ///
  /// In en, this message translates to:
  /// **'Data quality'**
  String get dataQuality;

  /// No description provided for @outliersLabel.
  ///
  /// In en, this message translates to:
  /// **'Outliers'**
  String get outliersLabel;

  /// No description provided for @samplingLabel.
  ///
  /// In en, this message translates to:
  /// **'Sampling'**
  String get samplingLabel;

  /// No description provided for @dataLabel.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get dataLabel;

  /// No description provided for @veryConsistent.
  ///
  /// In en, this message translates to:
  /// **'Very consistent'**
  String get veryConsistent;

  /// No description provided for @consistent.
  ///
  /// In en, this message translates to:
  /// **'Consistent'**
  String get consistent;

  /// No description provided for @averageVariation.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get averageVariation;

  /// No description provided for @highVariation.
  ///
  /// In en, this message translates to:
  /// **'High variation'**
  String get highVariation;

  /// No description provided for @leftSkewed.
  ///
  /// In en, this message translates to:
  /// **'Left-skewed distribution'**
  String get leftSkewed;

  /// No description provided for @rightSkewed.
  ///
  /// In en, this message translates to:
  /// **'Right-skewed distribution'**
  String get rightSkewed;

  /// No description provided for @normalDistribution.
  ///
  /// In en, this message translates to:
  /// **'Normal distribution'**
  String get normalDistribution;

  /// No description provided for @excellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get excellent;

  /// No description provided for @satisfactory.
  ///
  /// In en, this message translates to:
  /// **'Satisfactory'**
  String get satisfactory;

  /// No description provided for @caution.
  ///
  /// In en, this message translates to:
  /// **'Caution'**
  String get caution;

  /// No description provided for @symmetricDistribution.
  ///
  /// In en, this message translates to:
  /// **'Symmetric distribution'**
  String get symmetricDistribution;

  /// No description provided for @flatDistribution.
  ///
  /// In en, this message translates to:
  /// **'Flat distribution'**
  String get flatDistribution;

  /// No description provided for @peakedDistribution.
  ///
  /// In en, this message translates to:
  /// **'Peaked distribution'**
  String get peakedDistribution;

  /// No description provided for @normalPressureInterpretation.
  ///
  /// In en, this message translates to:
  /// **'Pressure distribution is normal. Performing consistent Frenzel movements.'**
  String get normalPressureInterpretation;

  /// No description provided for @highPressureInterpretation.
  ///
  /// In en, this message translates to:
  /// **'High pressure values appear frequently. Force control during peaks may be needed.'**
  String get highPressureInterpretation;

  /// No description provided for @lowPressureInterpretation.
  ///
  /// In en, this message translates to:
  /// **'Low pressure values are common. Practice applying stronger pressure.'**
  String get lowPressureInterpretation;

  /// No description provided for @concentratedInterpretation.
  ///
  /// In en, this message translates to:
  /// **'Concentrated in specific pressure range. Shows good consistency.'**
  String get concentratedInterpretation;

  /// No description provided for @dispersedInterpretation.
  ///
  /// In en, this message translates to:
  /// **'Pressure is widely dispersed. Consistency improvement needed.'**
  String get dispersedInterpretation;

  /// No description provided for @medianLabel.
  ///
  /// In en, this message translates to:
  /// **'Median: {value} hPa'**
  String medianLabel(String value);

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selected;

  /// No description provided for @excluded.
  ///
  /// In en, this message translates to:
  /// **'Excluded'**
  String get excluded;

  /// No description provided for @keyMetricsWithPeaks.
  ///
  /// In en, this message translates to:
  /// **'{metrics} ({count} peaks)'**
  String keyMetricsWithPeaks(String metrics, int count);

  /// No description provided for @scorePoints.
  ///
  /// In en, this message translates to:
  /// **'{score} pts'**
  String scorePoints(String score);

  /// No description provided for @secondsValue.
  ///
  /// In en, this message translates to:
  /// **'{value}s'**
  String secondsValue(String value);

  /// No description provided for @histogramTooltip.
  ///
  /// In en, this message translates to:
  /// **'{rangeStart}-{rangeEnd} hPa\n{count}'**
  String histogramTooltip(String rangeStart, String rangeEnd, int count);

  /// No description provided for @selectUsbDevice.
  ///
  /// In en, this message translates to:
  /// **'SELECT USB DEVICE'**
  String get selectUsbDevice;

  /// No description provided for @rescan.
  ///
  /// In en, this message translates to:
  /// **'Rescan'**
  String get rescan;

  /// No description provided for @availableDevices.
  ///
  /// In en, this message translates to:
  /// **'Available Devices'**
  String get availableDevices;

  /// No description provided for @noDevicesFound.
  ///
  /// In en, this message translates to:
  /// **'No USB serial devices found'**
  String get noDevicesFound;

  /// No description provided for @connecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get connecting;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection error'**
  String get connectionError;

  /// No description provided for @scanningForDevices.
  ///
  /// In en, this message translates to:
  /// **'Scanning for USB devices...'**
  String get scanningForDevices;

  /// No description provided for @scanAgain.
  ///
  /// In en, this message translates to:
  /// **'Scan Again'**
  String get scanAgain;

  /// No description provided for @deviceConnectedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Device connected successfully!'**
  String get deviceConnectedSuccessfully;

  /// No description provided for @clearData.
  ///
  /// In en, this message translates to:
  /// **'Clear Data'**
  String get clearData;

  /// No description provided for @deleteAllMeasurementData.
  ///
  /// In en, this message translates to:
  /// **'Delete all measurement data'**
  String get deleteAllMeasurementData;

  /// No description provided for @exportDbToFile.
  ///
  /// In en, this message translates to:
  /// **'Export DB to File'**
  String get exportDbToFile;

  /// No description provided for @exportDatabaseForDebugging.
  ///
  /// In en, this message translates to:
  /// **'Export database for debugging'**
  String get exportDatabaseForDebugging;

  /// No description provided for @deviceAuthenticated.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get deviceAuthenticated;

  /// No description provided for @deviceNotAuthenticated.
  ///
  /// In en, this message translates to:
  /// **'Not Verified'**
  String get deviceNotAuthenticated;

  /// No description provided for @counterfeitWarning.
  ///
  /// In en, this message translates to:
  /// **'Unverified Device'**
  String get counterfeitWarning;

  /// No description provided for @counterfeitWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Device Verification Failed'**
  String get counterfeitWarningTitle;

  /// No description provided for @counterfeitWarningMessage.
  ///
  /// In en, this message translates to:
  /// **'The connected device could not be verified as a genuine DiveChecker.\n\nUsing counterfeit devices may result in inaccurate measurements and limited technical support.'**
  String get counterfeitWarningMessage;

  /// No description provided for @continueAnyway.
  ///
  /// In en, this message translates to:
  /// **'Continue Anyway'**
  String get continueAnyway;

  /// No description provided for @verifyingDevice.
  ///
  /// In en, this message translates to:
  /// **'Verifying device...'**
  String get verifyingDevice;

  /// No description provided for @firmwareUpdate.
  ///
  /// In en, this message translates to:
  /// **'Firmware Update'**
  String get firmwareUpdate;

  /// No description provided for @firmwareUpdateDescription.
  ///
  /// In en, this message translates to:
  /// **'Check and update device firmware'**
  String get firmwareUpdateDescription;

  /// No description provided for @firmwareVerificationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Signature verified'**
  String get firmwareVerificationSuccess;

  /// No description provided for @firmwareVerificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Signature verification failed'**
  String get firmwareVerificationFailed;

  /// No description provided for @firmwareInstall.
  ///
  /// In en, this message translates to:
  /// **'Install'**
  String get firmwareInstall;

  /// No description provided for @firmwareRebootToBootsel.
  ///
  /// In en, this message translates to:
  /// **'Reboot to BOOTSEL'**
  String get firmwareRebootToBootsel;

  /// No description provided for @firmwareRebootDescription.
  ///
  /// In en, this message translates to:
  /// **'The device will reboot into BOOTSEL mode.\n\nAfter rebooting:\n1. A new drive \"RPI-RP2\" will appear\n2. Copy the .uf2 firmware file to it\n3. Device will automatically restart'**
  String get firmwareRebootDescription;

  /// No description provided for @currentFirmware.
  ///
  /// In en, this message translates to:
  /// **'Current Firmware'**
  String get currentFirmware;

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get dangerZone;

  /// No description provided for @rebootDevice.
  ///
  /// In en, this message translates to:
  /// **'Reboot Device'**
  String get rebootDevice;

  /// No description provided for @rebootDeviceDescription.
  ///
  /// In en, this message translates to:
  /// **'Restart the device'**
  String get rebootDeviceDescription;

  /// No description provided for @rebootConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Reboot the device? Connection will be lost.'**
  String get rebootConfirmMessage;

  /// No description provided for @reboot.
  ///
  /// In en, this message translates to:
  /// **'Reboot'**
  String get reboot;

  /// No description provided for @bootselMode.
  ///
  /// In en, this message translates to:
  /// **'BOOTSEL Mode'**
  String get bootselMode;

  /// No description provided for @bootselModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Manual firmware update mode'**
  String get bootselModeDescription;

  /// No description provided for @bootselRebootSent.
  ///
  /// In en, this message translates to:
  /// **'BOOTSEL reboot command sent'**
  String get bootselRebootSent;

  /// No description provided for @deviceDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Device disconnected'**
  String get deviceDisconnected;

  /// No description provided for @pinMismatch.
  ///
  /// In en, this message translates to:
  /// **'PINs do not match'**
  String get pinMismatch;

  /// No description provided for @pinChangeRequested.
  ///
  /// In en, this message translates to:
  /// **'PIN change requested'**
  String get pinChangeRequested;

  /// No description provided for @nameChangeRequested.
  ///
  /// In en, this message translates to:
  /// **'Name change requested'**
  String get nameChangeRequested;

  /// No description provided for @currentPin.
  ///
  /// In en, this message translates to:
  /// **'Current PIN'**
  String get currentPin;

  /// No description provided for @newPin.
  ///
  /// In en, this message translates to:
  /// **'New PIN'**
  String get newPin;

  /// No description provided for @confirmPin.
  ///
  /// In en, this message translates to:
  /// **'Confirm PIN'**
  String get confirmPin;

  /// No description provided for @newDeviceName.
  ///
  /// In en, this message translates to:
  /// **'New Device Name'**
  String get newDeviceName;

  /// No description provided for @pinRequiredForChange.
  ///
  /// In en, this message translates to:
  /// **'PIN required for changes'**
  String get pinRequiredForChange;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @myDevices.
  ///
  /// In en, this message translates to:
  /// **'My Devices'**
  String get myDevices;

  /// No description provided for @connectedDevices.
  ///
  /// In en, this message translates to:
  /// **'Connected Devices'**
  String get connectedDevices;

  /// No description provided for @noDeviceConnected.
  ///
  /// In en, this message translates to:
  /// **'No device connected'**
  String get noDeviceConnected;

  /// No description provided for @displayResolution.
  ///
  /// In en, this message translates to:
  /// **'Display Rate'**
  String get displayResolution;

  /// No description provided for @displayResolutionDescription.
  ///
  /// In en, this message translates to:
  /// **'Chart display update rate'**
  String get displayResolutionDescription;

  /// No description provided for @outputRate.
  ///
  /// In en, this message translates to:
  /// **'Output Rate'**
  String get outputRate;

  /// No description provided for @outputRateDescription.
  ///
  /// In en, this message translates to:
  /// **'Sensor output frequency'**
  String get outputRateDescription;

  /// No description provided for @tapToChange.
  ///
  /// In en, this message translates to:
  /// **'Tap to change'**
  String get tapToChange;

  /// No description provided for @connectDeviceFirst.
  ///
  /// In en, this message translates to:
  /// **'Connect device first'**
  String get connectDeviceFirst;

  /// No description provided for @outputRateChanged.
  ///
  /// In en, this message translates to:
  /// **'Output rate changed to {rate} Hz'**
  String outputRateChanged(Object rate);

  /// No description provided for @noiseFilter.
  ///
  /// In en, this message translates to:
  /// **'Noise Filter'**
  String get noiseFilter;

  /// No description provided for @noiseFilterDescription.
  ///
  /// In en, this message translates to:
  /// **'Software filter to reduce noise'**
  String get noiseFilterDescription;

  /// No description provided for @filterStrength.
  ///
  /// In en, this message translates to:
  /// **'Filter Strength'**
  String get filterStrength;

  /// No description provided for @filterStrengthDescription.
  ///
  /// In en, this message translates to:
  /// **'Higher values = more smoothing'**
  String get filterStrengthDescription;

  /// No description provided for @atmosphericCalibrating.
  ///
  /// In en, this message translates to:
  /// **'Calibrating atmospheric pressure...'**
  String get atmosphericCalibrating;

  /// No description provided for @atmosphericRecalibrate.
  ///
  /// In en, this message translates to:
  /// **'Recalibrate Atmosphere'**
  String get atmosphericRecalibrate;

  /// No description provided for @atmosphericKeepSensorStill.
  ///
  /// In en, this message translates to:
  /// **'Keep sensor still in open air'**
  String get atmosphericKeepSensorStill;

  /// No description provided for @secondsRemaining.
  ///
  /// In en, this message translates to:
  /// **'{seconds} seconds remaining'**
  String secondsRemaining(int seconds);

  /// No description provided for @selectFile.
  ///
  /// In en, this message translates to:
  /// **'Select File'**
  String get selectFile;

  /// No description provided for @backToFileList.
  ///
  /// In en, this message translates to:
  /// **'Back to file list'**
  String get backToFileList;

  /// No description provided for @readyToInstall.
  ///
  /// In en, this message translates to:
  /// **'Ready to install'**
  String get readyToInstall;

  /// No description provided for @verificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Verification failed'**
  String get verificationFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
