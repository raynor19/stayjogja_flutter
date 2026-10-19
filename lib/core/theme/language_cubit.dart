import 'package:flutter_bloc/flutter_bloc.dart';

enum AppLanguage {
  indonesian('id', 'Bahasa Indonesia'),
  english('en', 'English (US)');

  final String code;
  final String displayName;
  const AppLanguage(this.code, this.displayName);
}

class LanguageCubit extends Cubit<AppLanguage> {
  LanguageCubit() : super(AppLanguage.indonesian);

  void changeLanguage(AppLanguage language) {
    emit(language);
  }

  bool get isIndonesian => state == AppLanguage.indonesian;
}
