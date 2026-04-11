import 'package:flutter_modular/flutter_modular.dart';
import 'package:mob_archery/app/modules/accessibility/accessibility_module.dart';
import 'package:mob_archery/app/modules/accessibility/services/accessibility_feedback_service.dart';
import 'package:mob_archery/app/modules/accessibility/stores/accessibility_action.dart';
import 'package:mob_archery/app/modules/accessibility/stores/accessibility_state.dart';
import 'package:mob_archery/app/modules/auth/auth_module.dart';
import 'package:mob_archery/app/modules/auth/services/auth_service.dart'
    show AuthService;
import 'package:mob_archery/app/modules/auth/stores/auth_action.dart';
import 'package:mob_archery/app/modules/auth/stores/auth_state.dart';
import 'package:mob_archery/app/modules/home/home_module.dart';
import 'package:mob_archery/app/modules/home/pages/launch_page.dart';
import 'package:mob_archery/app/modules/home/services/home_summary_service.dart';
import 'package:mob_archery/app/modules/home/stores/home_action.dart';
import 'package:mob_archery/app/modules/home/stores/home_state.dart';
import 'package:mob_archery/app/modules/profile/profile_module.dart';
import 'package:mob_archery/app/modules/profile/services/profile_form_service.dart';
import 'package:mob_archery/app/modules/profile/stores/profile_action.dart';
import 'package:mob_archery/app/modules/profile/stores/profile_state.dart';
import 'package:mob_archery/app/modules/services/auth_service.dart'
    as auth_service;
import 'package:mob_archery/app/modules/services/firestore_service.dart';
import 'package:mob_archery/app/modules/timer/services/timer_feedback_service.dart';
import 'package:mob_archery/app/modules/timer/stores/timer_action.dart';
import 'package:mob_archery/app/modules/timer/stores/timer_state.dart';
import 'package:mob_archery/app/modules/timer/timer_module.dart';
import 'package:mob_archery/app/modules/training/services/training_metrics_service.dart';
import 'package:mob_archery/app/modules/training/services/training_report_service.dart';
import 'package:mob_archery/app/modules/training/stores/training_action.dart';
import 'package:mob_archery/app/modules/training/stores/training_state.dart';
import 'package:mob_archery/app/modules/training/training_module.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    i
      ..addLazySingleton<auth_service.AuthServiceInterface>(
        auth_service.AuthService.new,
      )
      ..addLazySingleton<FirestoreServiceInterface>(FirestoreService.new)
      ..addLazySingleton(AuthService.new)
      ..addLazySingleton(HomeSummaryService.new)
      ..addLazySingleton(TimerFeedbackService.new)
      ..addLazySingleton(TrainingMetricsService.new)
      ..addLazySingleton(TrainingReportService.new)
      ..addLazySingleton(AccessibilityFeedbackService.new)
      ..addLazySingleton(ProfileFormService.new)
      ..addLazySingleton(AccessibilityState.new)
      ..addLazySingleton(
        () => AccessibilityAction(
          i.get<AccessibilityState>(),
          i.get<AccessibilityFeedbackService>(),
        ),
      )
      ..addLazySingleton(AuthState.new)
      ..addLazySingleton(
        () => AuthAction(
          i.get<auth_service.AuthServiceInterface>(),
          i.get<FirestoreServiceInterface>(),
          i.get<AuthService>(),
        ),
      )
      ..addLazySingleton(TimerState.new)
      ..addLazySingleton(
        () => TimerAction(
          i.get<TimerState>(),
          i.get<AccessibilityState>(),
          i.get<TimerFeedbackService>(),
        ),
      )
      ..addLazySingleton(TrainingState.new)
      ..addLazySingleton(
        () => TrainingAction(
          i.get<TrainingState>(),
          i.get<auth_service.AuthServiceInterface>(),
          i.get<FirestoreServiceInterface>(),
          i.get<TrainingMetricsService>(),
          i.get<TrainingReportService>(),
        ),
      )
      ..addLazySingleton(HomeState.new)
      ..addLazySingleton(
        () => HomeAction(
          i.get<HomeState>(),
          i.get<HomeSummaryService>(),
          i.get<TrainingState>(),
        ),
      )
      ..addLazySingleton(ProfileState.new)
      ..addLazySingleton(
        () => ProfileAction(
          i.get<ProfileState>(),
          i.get<AuthState>(),
          i.get<auth_service.AuthServiceInterface>(),
          i.get<FirestoreServiceInterface>(),
          i.get<ProfileFormService>(),
        ),
      );
  }

  @override
  void routes(RouteManager r) {
    r
      ..child('/', child: (_) => const LaunchPage())
      ..module('/auth', module: AuthModule())
      ..module('/home', module: HomeModule())
      ..module('/timer', module: TimerModule())
      ..module('/training', module: TrainingModule())
      ..module('/accessibility', module: AccessibilityModule())
      ..module('/profile', module: ProfileModule());
  }
}
