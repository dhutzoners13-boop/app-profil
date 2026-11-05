class SettingModel {
  final Map<String, dynamic> raw;

  SettingModel({required this.raw});

  String get siteName => raw['site_name']?.toString() ?? 'Portal Layanan Publik';
  String get siteTagline =>
      raw['site_tagline']?.toString() ?? 'Transparan, Akuntabel, dan Melayani';
  String get siteDescription => raw['site_description']?.toString() ?? '';
  String get contactEmail => raw['contact_email']?.toString() ?? '';
  String get contactPhone => raw['contact_phone']?.toString() ?? '';
  String get contactAddress => raw['contact_address']?.toString() ?? '';
  String get instagram => raw['social_instagram']?.toString() ?? '';
  String get facebook => raw['social_facebook']?.toString() ?? '';

  factory SettingModel.fromJson(Map<String, dynamic> json) {
    return SettingModel(raw: json);
  }
}

