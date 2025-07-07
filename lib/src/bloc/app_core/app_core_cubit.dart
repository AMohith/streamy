import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core.dart';

class AppCoreCubit extends Cubit<AppCoreState> {
  AppCoreCubit({required ShowsRepository showsRepository})
    : _showsRepository = showsRepository,
      super(AppCoreInitial());

  final ShowsRepository _showsRepository;

  /// Initializes the app by loading the shows data.
  Future<void> initializeApp() async {
    try {
      emit(AppCoreInitializing());

      final appData = await _showsRepository.loadShowsData();

      emit(AppCoreInitialized(appData));
    } catch (e) {
      emit(AppCoreError('Failed to initialize app: ${e.toString()}'));
    }
  }
}
