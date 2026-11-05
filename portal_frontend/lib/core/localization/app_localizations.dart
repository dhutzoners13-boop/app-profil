import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('id'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('id'),
    Locale('en'),
  ];

  static final Map<String, Map<String, String>> _localizedValues = {
    'id': {
      'app_title': 'Portal Layanan Publik',
      'home': 'Beranda',
      'posts': 'Berita',
      'questions': 'Aspirasi',
      'faq': 'FAQ',
      'settings': 'Pengaturan',
      'language': 'Bahasa',
      'language_indonesian': 'Bahasa Indonesia',
      'language_english': 'English',
      'search': 'Pencarian...',
      'search_posts': 'Cari berita & informasi...',
      'search_faq': 'Cari pertanyaan umum...',
      'search_questions': 'Cari aspirasi masyarakat...',
      'all_categories': 'Semua Kategori',
      'all_topics': 'Semua Topik',
      'featured_news': 'Berita Utama',
      'latest_news': 'Kabar & Informasi Terkini',
      'quick_menu': 'Layanan & Menu Cepat',
      'view_all': 'Lihat Semua',
      'read_more': 'Baca Selengkapnya',
      'published_on': 'Diterbitkan',
      'views': 'dilihat',
      'author': 'Penulis',
      'official_response': 'Tanggapan Resmi Instansi',
      'answered_by': 'Dijawab oleh',
      'status_answered': 'Sudah Ditanggapi',
      'status_pending': 'Menunggu Verifikasi',
      'ask_question': 'Ajukan Pertanyaan',
      'ask_question_title': 'Formulir Pertanyaan & Aspirasi',
      'ask_question_subtitle':
          'Sampaikan pertanyaan atau permohonan informasi kepada pihak instansi secara resmi dan transparan.',
      'field_topic': 'Topik Layanan',
      'field_name': 'Nama Lengkap',
      'field_email': 'Alamat Email',
      'field_phone': 'Nomor Telepon (WhatsApp)',
      'field_subject': 'Judul Pertanyaan',
      'field_body': 'Rincian Pertanyaan / Pengaduan',
      'btn_submit': 'Kirim Pertanyaan',
      'btn_submitting': 'Mengirimkan...',
      'validation_required': 'Kolom ini wajib diisi',
      'validation_email': 'Format email tidak valid',
      'validation_min_length': 'Minimal harus 10 karakter',
      'success_submit_title': 'Pertanyaan Terkirim!',
      'success_submit_desc':
          'Terima kasih, pertanyaan Anda telah terdaftar dan akan segera ditinjau oleh petugas.',
      'server_url': 'Alamat URL Server API',
      'server_url_hint': 'Contoh: http://10.0.2.2:8000/api/v1',
      'save': 'Simpan',
      'reset': 'Reset Default',
      'no_data': 'Belum ada data tersedia',
      'no_results': 'Tidak ditemukan hasil yang cocok',
      'retry': 'Coba Lagi',
      'error_loading': 'Gagal memuat data dari server',
      'error_connection': 'Koneksi ke server gagal. Periksa koneksi atau URL API.',
      'about_us': 'Tentang Kami',
      'contact_info': 'Kontak & Alamat',
      'phone': 'Telepon',
      'email': 'Email',
      'address': 'Alamat',
    },
    'en': {
      'app_title': 'Public Service Portal',
      'home': 'Home',
      'posts': 'News',
      'questions': 'Inquiries',
      'faq': 'FAQ',
      'settings': 'Settings',
      'language': 'Language',
      'language_indonesian': 'Indonesian',
      'language_english': 'English',
      'search': 'Search...',
      'search_posts': 'Search news & articles...',
      'search_faq': 'Search frequently asked questions...',
      'search_questions': 'Search public inquiries...',
      'all_categories': 'All Categories',
      'all_topics': 'All Topics',
      'featured_news': 'Featured News',
      'latest_news': 'Latest News & Updates',
      'quick_menu': 'Quick Services & Menu',
      'view_all': 'View All',
      'read_more': 'Read More',
      'published_on': 'Published on',
      'views': 'views',
      'author': 'Author',
      'official_response': 'Official Response',
      'answered_by': 'Answered by',
      'status_answered': 'Answered',
      'status_pending': 'Pending Review',
      'ask_question': 'Submit Inquiry',
      'ask_question_title': 'Submit Public Inquiry',
      'ask_question_subtitle':
          'Submit questions or official information requests to our institution transparently.',
      'field_topic': 'Service Topic',
      'field_name': 'Full Name',
      'field_email': 'Email Address',
      'field_phone': 'Phone Number (WhatsApp)',
      'field_subject': 'Subject / Topic',
      'field_body': 'Inquiry Details / Complaint',
      'btn_submit': 'Submit Inquiry',
      'btn_submitting': 'Submitting...',
      'validation_required': 'This field is required',
      'validation_email': 'Please enter a valid email address',
      'validation_min_length': 'Must be at least 10 characters',
      'success_submit_title': 'Inquiry Submitted!',
      'success_submit_desc':
          'Thank you. Your inquiry has been submitted and will be reviewed shortly by our staff.',
      'server_url': 'Server API URL',
      'server_url_hint': 'E.g.: http://10.0.2.2:8000/api/v1',
      'save': 'Save',
      'reset': 'Reset Default',
      'no_data': 'No data available yet',
      'no_results': 'No matching results found',
      'retry': 'Retry',
      'error_loading': 'Failed to load data from server',
      'error_connection': 'Server connection failed. Please check your connection or API URL.',
      'about_us': 'About Us',
      'contact_info': 'Contact & Location',
      'phone': 'Phone',
      'email': 'Email',
      'address': 'Address',
    },
  };

  String translate(String key) {
    final lang = locale.languageCode;
    return _localizedValues[lang]?[key] ?? _localizedValues['id']?[key] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['id', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

