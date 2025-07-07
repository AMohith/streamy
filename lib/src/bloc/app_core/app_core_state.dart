import '../../core.dart';

abstract class AppCoreState {}

final class AppCoreInitial extends AppCoreState {}

final class AppCoreInitializing extends AppCoreState {}

final class AppCoreInitialized extends AppCoreState {
  final AppData appData;

  AppCoreInitialized(this.appData);
}

final class AppCoreError extends AppCoreState {
  final String message;

  AppCoreError(this.message);
}
