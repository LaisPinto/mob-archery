import 'package:flutter_modular/flutter_modular.dart';
import 'package:mob_archery/accessibility/accessibility_module.dart';
import 'package:mob_archery/accessibility/services/accessibility_feedback_service.dart';
import 'package:mob_archery/accessibility/stores/accessibility_action.dart';
import 'package:mob_archery/accessibility/stores/accessibility_state.dart';
import 'package:mob_archery/auth/auth_module.dart';
import 'package:mob_archery/auth/services/auth_form_service.dart';
import 'package:mob_archery/auth/stores/auth_action.dart';
import 'package:mob_archery/auth/stores/auth_state.dart';
import 'package:mob_archery/home/home_module.dart';
import 'package:mob_archery/home/pages/launch_page.dart';
import 'package:mob_archery/home/services/home_summary_service.dart';
import 'package:mob_archery/home/stores/home_action.dart';
import 'package:mob_archery/home/stores/home_state.dart';
import 'package:mob_archery/profile/profile_module.dart';
import 'package:mob_archery/profile/services/profile_form_service.dart';
import 'package:mob_archery/profile/stores/profile_action.dart';
import 'package:mob_archery/profile/stores/profile_state.dart';
import 'package:mob_archery/services/auth_service.dart';
import 'package:mob_archery/services/firestore_service.dart';
import 'package:mob_archery/timer/services/timer_feedback_service.dart';
import 'package:mob_archery/timer/stores/timer_action.dart';
import 'package:mob_archery/timer/stores/timer_state.dart';
import 'package:mob_archery/timer/timer_module.dart';
import 'package:mob_archery/training/services/training_metrics_service.dart';
import 'package:mob_archery/training/stores/training_action.dart';
import 'package:mob_archery/training/stores/training_state.dart';
import 'package:mob_archery/training/training_module.dart';

class AppModule extends Module {
  @override
  void binds(Injector injector) {
    injector
      ..addLazySingleton<AuthServiceInterface>(AuthService.new)
      ..addLazySingleton<FirestoreServiceInterface>(FirestoreService.new)
      ..addLazySingleton(AuthFormService.new)
      ..addLazySingleton(HomeSummaryService.new)
      ..addLazySingleton(TimerFeedbackService.new)
      ..addLazySingleton(TrainingMetricsService.new)
      ..addLazySingleton(AccessibilityFeedbackService.new)
      ..addLazySingleton(ProfileFormService.new)
      ..addLazySingleton(AccessibilityState.new)
      ..addLazySingleton(
        () => AccessibilityAction(
          injector.get<AccessibilityState>(),
          injector.get<AccessibilityFeedbackService>(),
        ),
      )
      ..addLazySingleton(AuthState.new)
      ..addLazySingleton(
        () => AuthAction(
          injector.get<AuthState>(),
          injector.get<AuthServiceInterface>(),
          injector.get<FirestoreServiceInterface>(),
          injector.get<AuthFormService>(),
        ),
      )
      ..addLazySingleton(TimerState.new)
      ..addLazySingleton(
        () => TimerAction(
          injector.get<TimerState>(),
          injector.get<AccessibilityState>(),
          injector.get<TimerFeedbackService>(),
        ),
      )
      ..addLazySingleton(TrainingState.new)
      ..addLazySingleton(
        () => TrainingAction(
          injector.get<TrainingState>(),
          injector.get<AuthServiceInterface>(),
          injector.get<FirestoreServiceInterface>(),
          injector.get<TrainingMetricsService>(),
        ),
      )
      ..addLazySingleton(HomeState.new)
      ..addLazySingleton(
        () => HomeAction(
          injector.get<HomeState>(),
          injector.get<HomeSummaryService>(),
          injector.get<TrainingState>(),
        ),
      )
      ..addLazySingleton(ProfileState.new)
      ..addLazySingleton(
        () => ProfileAction(
          injector.get<ProfileState>(),
          injector.get<AuthState>(),
          injector.get<AuthServiceInterface>(),
          injector.get<FirestoreServiceInterface>(),
          injector.get<ProfileFormService>(),
        ),
      );
  }

  @override
  void routes(RouteManager routeManager) {
    routeManager
      ..child('/', child: (_) => const LaunchPage())
      ..module('/auth', module: AuthModule())
      ..module('/home', module: HomeModule())
      ..module('/timer', module: TimerModule())
      ..module('/training', module: TrainingModule())
      ..module('/accessibility', module: AccessibilityModule())
      ..module('/profile', module: ProfileModule());
  }
}
