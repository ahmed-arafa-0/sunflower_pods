// lib/l10n/app_localizations.dart
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // General
      'app_name': 'Dr. Veuolla\'s Pods',
      'continue': 'Continue',
      'back': 'Back',
      'connected': 'Connected',
      'disconnected': 'Disconnected',
      'connecting': 'Connecting...',

      // Home Screen
      'hello_veuolla': 'Hello Veuolla ☀️',
      'left': 'Left',
      'right': 'Right',
      'case': 'Case',
      'signal': 'Signal',
      'strong_signal': 'Strong Signal',
      'medium_signal': 'Medium Signal',
      'weak_signal': 'Weak Signal',

      // Connection
      'your_sunshine_away': 'Your sunshine went away... 🌻',
      'pods_disconnected': 'Your pods are disconnected',
      'connect_first':
          'Please connect your Funpods 2 via Bluetooth settings first',
      'checking_connection': 'Checking for connected pods...',

      // Bottom Navigation
      'home': 'Home',
      'eq': 'EQ',
      'settings': 'Settings',

      // Sound EQ
      'sound_profiles': 'Sound Profiles',
      'eq_disclaimer': '🎵 Fun Feature Only',
      'eq_note':
          'Note: This is a visual customization feature and does not change the actual audio settings of your Funpods.',
      'bass_boost': 'Bass Boost',
      'vocal_clarity': 'Vocal Clarity',
      'mango_warmth': 'Mango Warmth',
      'sea_breeze': 'Sea Breeze',
      'sunflower_balance': 'Sunflower Balance',
      'activated': 'activated!',

      // Settings
      'settings': 'Settings',
      'personalization': 'Personalization',
      'theme': 'Theme',
      'language': 'Language',
      'notifications': 'Notifications',
      'enable_notifications': 'Enable Notifications',
      'low_battery_alerts': 'Low Battery Alerts',
      'connection_alerts': 'Connection Alerts',
      'about': 'About',
      'made_with_love': 'Made with love for Veuolla',
      'version': 'Version 1.0.0',
      'personalized_app': 'A personalized app for your Jayroom Funpods 2',
      'reset_onboarding': 'Show Welcome Screen',
      'onboarding_reset': 'Welcome screen will show on next launch',

      // Touch Controls
      'touch_controls': 'Touch Controls',
      'sunflower_tap': 'Sunflower Tap 🌻',
      'single_tap': 'Single tap',
      'play_pause': 'Play / Pause music',
      'mango_double': 'Mango Double 🥭',
      'double_tap': 'Double tap',
      'next_track': 'Next track',
      'violet_trio': 'Violet Trio 💜',
      'triple_tap': 'Triple tap',
      'previous_track': 'Previous track',
      'sea_wave_hold': 'Sea Wave Hold 🌊',
      'long_press': 'Long press',
      'voice_assistant': 'Voice assistant',

      // Cleaning Tips
      'cleaning_tips': 'Cleaning & Care Tips',
      'tip1_title': 'Give your sunflowers some love 💛',
      'tip1_desc': 'Gently wipe earbuds with a soft, dry cloth after each use.',
      'tip2_title': 'Keep those mango vibes crystal clear 🥭',
      'tip2_desc': 'Use a cotton swab to clean the mesh screens carefully.',
      'tip3_title': 'Protect your violet dreams 💜',
      'tip3_desc':
          'Avoid water and cleaning solutions directly on the earbuds.',
      'tip4_title': 'Clear sea, clear sound 🌊',
      'tip4_desc': 'Clean the charging case regularly with a soft brush.',
      'tip5_title': 'Store with care 🌻',
      'tip5_desc': 'Always keep your Funpods in their case when not in use.',

      // Device Info
      'device_info': 'Device Information',
      'device_name': 'Device Name',
      'device_id': 'Device ID',
      'model': 'Model',
      'firmware': 'Firmware',
      'connection_status': 'Connection Status',
      'signal_strength': 'Signal Strength',
      'copy_device_info': 'Copy Device Info',
      'info_copied': 'Device info copied to clipboard!',

      // Onboarding
      'choose_vibe': 'Choose Your Vibe',
      'bluetooth_permission': 'Bluetooth Permission',
      'bluetooth_desc':
          'We need this to connect to your Funpods and make magic happen!',
      'location_permission': 'Location Permission',
      'location_desc':
          'Required on Android for Bluetooth scanning. Don\'t worry, we keep your privacy safe!',
      'notification_permission': 'Notifications',
      'notification_desc':
          'Get notified when your pods connect or need charging!',

      // Themes
      'sunflower': 'Sunflower',
      'sea': 'Sea',
      'mango': 'Mango',
      'violet': 'Violet',

      // Notifications
      'low_battery_title': 'Low Battery',
      'connected_title': 'Connected',
      'disconnected_title': 'Disconnected',

      // Theme-based messages
      'sunflower_low_battery': 'Sunflower needs some sunlight! (Low battery)',
      'sunflower_connected': 'Your sunshine is connected, Veuolla! 🌻',
      'sea_low_battery': 'The sea is getting calm... battery low',
      'sea_connected': 'Dive into your sea of music! 🌊',
      'mango_low_battery': 'Mango is getting sleepy... time to recharge',
      'mango_connected': 'Mango magic in the air! ✨',
      'violet_low_battery': 'Violet dreams need more energy 💜',
      'violet_connected': 'Violet frequencies aligned! 💫',
    },
    'it': {
      // Generale
      'app_name': 'Pod di Dr. Veuolla',
      'continue': 'Continua',
      'back': 'Indietro',
      'connected': 'Connesso',
      'disconnected': 'Disconnesso',
      'connecting': 'Connessione...',

      // Schermata Home
      'hello_veuolla': 'Ciao Veuolla ☀️',
      'left': 'Sinistro',
      'right': 'Destro',
      'case': 'Custodia',
      'signal': 'Segnale',
      'strong_signal': 'Segnale Forte',
      'medium_signal': 'Segnale Medio',
      'weak_signal': 'Segnale Debole',

      // Connessione
      'your_sunshine_away': 'Il tuo sole se n\'è andato... 🌻',
      'pods_disconnected': 'I tuoi pod sono disconnessi',
      'connect_first':
          'Connetti prima i tuoi Funpods 2 tramite le impostazioni Bluetooth',
      'checking_connection': 'Controllo dei pod connessi...',

      // Navigazione Inferiore
      'home': 'Home',
      'eq': 'EQ',
      'settings': 'Impostazioni',

      // EQ Audio
      'sound_profiles': 'Profili Audio',
      'eq_disclaimer': '🎵 Solo Funzione Divertente',
      'eq_note':
          'Nota: Questa è una funzione di personalizzazione visiva e non modifica le impostazioni audio effettive dei tuoi Funpods.',
      'bass_boost': 'Potenziamento Bassi',
      'vocal_clarity': 'Chiarezza Vocale',
      'mango_warmth': 'Calore Mango',
      'sea_breeze': 'Brezza Marina',
      'sunflower_balance': 'Equilibrio Girasole',
      'activated': 'attivato!',

      // Impostazioni
      'settings': 'Impostazioni',
      'personalization': 'Personalizzazione',
      'theme': 'Tema',
      'language': 'Lingua',
      'notifications': 'Notifiche',
      'enable_notifications': 'Abilita Notifiche',
      'low_battery_alerts': 'Avvisi Batteria Scarica',
      'connection_alerts': 'Avvisi di Connessione',
      'about': 'Informazioni',
      'made_with_love': 'Fatto con amore per Veuolla',
      'version': 'Versione 1.0.0',
      'personalized_app': 'Un\'app personalizzata per i tuoi Jayroom Funpods 2',
      'reset_onboarding': 'Mostra Schermata di Benvenuto',
      'onboarding_reset':
          'La schermata di benvenuto verrà mostrata al prossimo avvio',

      // Controlli Touch
      'touch_controls': 'Controlli Touch',
      'sunflower_tap': 'Tocco Girasole 🌻',
      'single_tap': 'Tocco singolo',
      'play_pause': 'Play / Pausa musica',
      'mango_double': 'Doppio Mango 🥭',
      'double_tap': 'Doppio tocco',
      'next_track': 'Traccia successiva',
      'violet_trio': 'Trio Viola 💜',
      'triple_tap': 'Triplo tocco',
      'previous_track': 'Traccia precedente',
      'sea_wave_hold': 'Onda Marina Lunga 🌊',
      'long_press': 'Pressione lunga',
      'voice_assistant': 'Assistente vocale',

      // Consigli Pulizia
      'cleaning_tips': 'Consigli per la Pulizia',
      'tip1_title': 'Dai amore ai tuoi girasoli 💛',
      'tip1_desc':
          'Pulisci delicatamente gli auricolari con un panno morbido e asciutto dopo ogni uso.',
      'tip2_title': 'Mantieni le vibrazioni mango cristalline 🥭',
      'tip2_desc': 'Usa un cotton fioc per pulire delicatamente le griglie.',
      'tip3_title': 'Proteggi i tuoi sogni viola 💜',
      'tip3_desc':
          'Evita acqua e soluzioni detergenti direttamente sugli auricolari.',
      'tip4_title': 'Mare pulito, suono chiaro 🌊',
      'tip4_desc':
          'Pulisci regolarmente la custodia di ricarica con una spazzola morbida.',
      'tip5_title': 'Conserva con cura 🌻',
      'tip5_desc':
          'Tieni sempre i tuoi Funpods nella custodia quando non li usi.',

      // Informazioni Dispositivo
      'device_info': 'Informazioni Dispositivo',
      'device_name': 'Nome Dispositivo',
      'device_id': 'ID Dispositivo',
      'model': 'Modello',
      'firmware': 'Firmware',
      'connection_status': 'Stato Connessione',
      'signal_strength': 'Potenza Segnale',
      'copy_device_info': 'Copia Info Dispositivo',
      'info_copied': 'Info dispositivo copiate negli appunti!',

      // Onboarding
      'choose_vibe': 'Scegli la Tua Atmosfera',
      'bluetooth_permission': 'Permesso Bluetooth',
      'bluetooth_desc':
          'Ne abbiamo bisogno per connetterci ai tuoi Funpods e creare magia!',
      'location_permission': 'Permesso Posizione',
      'location_desc':
          'Richiesto su Android per la scansione Bluetooth. Non preoccuparti, manteniamo la tua privacy al sicuro!',
      'notification_permission': 'Notifiche',
      'notification_desc':
          'Ricevi notifiche quando i tuoi pod si connettono o necessitano di ricarica!',

      // Temi
      'sunflower': 'Girasole',
      'sea': 'Mare',
      'mango': 'Mango',
      'violet': 'Viola',

      // Notifiche
      'low_battery_title': 'Batteria Scarica',
      'connected_title': 'Connesso',
      'disconnected_title': 'Disconnesso',

      // Messaggi basati sul tema
      'sunflower_low_battery':
          'Il girasole ha bisogno di sole! (Batteria scarica)',
      'sunflower_connected': 'Il tuo sole è connesso, Veuolla! 🌻',
      'sea_low_battery': 'Il mare si sta calmando... batteria scarica',
      'sea_connected': 'Tuffati nel tuo mare di musica! 🌊',
      'mango_low_battery':
          'Il mango sta diventando assonnato... ora di ricaricare',
      'mango_connected': 'Magia mango nell\'aria! ✨',
      'violet_low_battery': 'I sogni viola hanno bisogno di più energia 💜',
      'violet_connected': 'Frequenze viola allineate! 💫',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  // Shorthand access
  String get appName => translate('app_name');
  String get continueBtn => translate('continue');
  String get back => translate('back');
  String get connected => translate('connected');
  String get disconnected => translate('disconnected');

  String get helloVeuolla => translate('hello_veuolla');
  String get left => translate('left');
  String get right => translate('right');
  String get case_ => translate('case');
  String get signal => translate('signal');

  String get yourSunshineAway => translate('your_sunshine_away');
  String get podsDisconnected => translate('pods_disconnected');
  String get connectFirst => translate('connect_first');

  String get home => translate('home');
  String get eq => translate('eq');
  String get settings => translate('settings');

  String get soundProfiles => translate('sound_profiles');
  String get eqDisclaimer => translate('eq_disclaimer');
  String get eqNote => translate('eq_note');

  String get personalization => translate('personalization');
  String get theme => translate('theme');
  String get language => translate('language');
  String get notifications => translate('notifications');

  String get touchControls => translate('touch_controls');
  String get cleaningTips => translate('cleaning_tips');
  String get deviceInfo => translate('device_info');

  String get about => translate('about');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'it'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
