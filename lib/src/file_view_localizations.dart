// ignore_for_file: public_member_api_docs

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FileViewLocalizationsDelegate
    extends LocalizationsDelegate<FileViewLocalizations> {
  const FileViewLocalizationsDelegate();

  /// Provided to [MaterialApp] for use.
  static const FileViewLocalizationsDelegate delegate =
      FileViewLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      FileViewLocalizations.languages.contains(locale.languageCode);

  @override
  Future<FileViewLocalizations> load(Locale locale) {
    return SynchronousFuture<FileViewLocalizations>(
      FileViewLocalizations(locale),
    );
  }

  @override
  bool shouldReload(FileViewLocalizationsDelegate old) => false;
}

/// Localizations
abstract class FileViewLocalizationsBase {
  const FileViewLocalizationsBase(this.locale);

  final Locale? locale;

  Object? getItem(String key);

  String get unSupportedPlatformTip =>
      getItem('unSupportedPlatformTip').toString();

  String get nonExistentTip => getItem('nonExistentTip').toString();

  String get unSupportedType => getItem('unSupportedType').toString();

  String get retry => getItem('retry').toString();

  String get engineFail => getItem('engineFail').toString();

  String get engineDownloadSuccess =>
      getItem('engineDownloadSuccess').toString();

  String get engineDownloadFail => getItem('engineDownloadFail').toString();

  String get engineDownloading => getItem('engineDownloading').toString();

  String get engineDownloadNonRequired =>
      getItem('engineDownloadNonRequired').toString();

  String get engineDownloadCancelNotWifi =>
      getItem('engineDownloadCancelNotWifi').toString();

  String get engineDownloadCancelRequesting =>
      getItem('engineDownloadCancelRequesting').toString();

  String get engineDownloadNoNeedRequest =>
      getItem('engineDownloadNoNeedRequest').toString();

  String get engineDownloadFlowCancel =>
      getItem('engineDownloadFlowCancel').toString();

  String get engineDownloadOutOfOne =>
      getItem('engineDownloadOutOfOne').toString();

  String get engineInstallSuccess => getItem('engineInstallSuccess').toString();

  String get engineInstallFail => getItem('engineInstallFail').toString();

  String get engineLoading => getItem('engineLoading').toString();
}

/// localizations
class FileViewLocalizations extends FileViewLocalizationsBase {
  const FileViewLocalizations(super.locale);

  static const FileViewLocalizations _static = FileViewLocalizations(null);

  @override
  Object? getItem(String key) {
    Map<String, Object>? localData;
    if (locale != null) {
      localData = localizedValues[locale!.languageCode];
    }
    if (localData == null) {
      return localizedValues['en']![key];
    }
    return localData[key];
  }

  static FileViewLocalizations of(BuildContext context) {
    return Localizations.of<FileViewLocalizations>(
          context,
          FileViewLocalizations,
        ) ??
        _static;
  }

  /// Language Support
  static const List<String> languages = <String>['en', 'zh'];

  /// Language Values
  static const Map<String, Map<String, Object>> localizedValues =
      <String, Map<String, Object>>{
    'en': <String, String>{
      'unSupportedPlatformTip': 'Only supports iOS platforms.',
      'nonExistentTip': 'Non-existent file.',
      'unSupportedType': 'Does not support opening files of type %s.',
      'retry': 'Retry',
      'engineFail': 'Failed to initialize engine.',
      'engineDownloadSuccess':
          'Engine download is complete, please wait for installation.',
      'engineDownloadFail': 'Engine download failed, please try again.',
      'engineDownloading': 'Engine downloading, please wait.',
      'engineDownloadNonRequired':
          'The engine cannot be downloaded temporarily, please restart.',
      'engineDownloadCancelNotWifi': 'The engine has canceled the download,'
          ' please switch to a wireless network',
      'engineDownloadCancelRequesting': 'The engine has canceled the download,'
          ' please do not repeat the request.',
      'engineDownloadNoNeedRequest': 'Engine not downloading, please try again'
          ' later.',
      'engineDownloadFlowCancel': 'The download of the engine has been '
          'canceled, and the current network is abnormal.',
      'engineDownloadOutOfOne':
          'The engine has retried too many times, please restart.',
      'engineInstallSuccess':
          'Engine installation is complete, please wait for initialization.',
      'engineInstallFail': 'Engine installation failed, please try again.',
      'engineLoading': 'Engine initialization, please wait.',
    },
  };
}
