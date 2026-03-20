import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:mob_archery/services/auth_service.dart';
import 'package:mob_archery/services/firestore_service.dart';
import 'package:mob_archery/training/enums/bow_type.dart';
import 'package:mob_archery/training/enums/registered_by.dart';
import 'package:mob_archery/training/models/training_end_model.dart';
import 'package:mob_archery/training/models/training_session_model.dart';
import 'package:mob_archery/training/services/training_metrics_service.dart';
import 'package:mob_archery/training/stores/training_state.dart';

class TrainingAction {
  TrainingAction(
    this.state,
    this.authService,
    this.firestoreService,
    this.trainingMetricsService,
  );

  final TrainingState state;
  final AuthServiceInterface authService;
  final FirestoreServiceInterface firestoreService;
  final TrainingMetricsService trainingMetricsService;

  StreamSubscription<List<TrainingSessionModel>>? sessionsSubscription;
  StreamSubscription<List<TrainingEndModel>>? endsSubscription;

  void clearMessages() {
    runInAction(() {
      state.errorMessage.value = null;
      state.successMessage.value = null;
    });
  }

  void watchSessions() {
    final authUser = authService.currentUser;
    if (authUser == null) {
      return;
    }

    sessionsSubscription?.cancel();
    sessionsSubscription =
        firestoreService.watchTrainingSessions(authUser.userId).listen((sessions) {
      runInAction(() {
        state.sessions
          ..clear()
          ..addAll(sessions);
      });
    });
  }

  void watchEnds(TrainingSessionModel session) {
    final authUser = authService.currentUser;
    if (authUser == null) {
      return;
    }

    runInAction(() => state.selectedSession.value = session);
    endsSubscription?.cancel();
    endsSubscription = firestoreService
        .watchTrainingEnds(
          userId: authUser.userId,
          sessionId: session.sessionId,
        )
        .listen((ends) {
      runInAction(() {
        state.ends
          ..clear()
          ..addAll(ends);
      });
    });
  }

  Future<TrainingSessionModel> _ensureSession() async {
    final authUser = authService.currentUser;
    if (authUser == null) {
      throw StateError('No authenticated user found.');
    }

    final existingSession = state.selectedSession.value;
    if (existingSession != null) {
      return existingSession;
    }

    final sessionId = await firestoreService.createTrainingSessionId();
    final newSession = TrainingSessionModel(
      sessionId: sessionId,
      userId: authUser.userId,
      date: DateTime.now(),
      totalArrows: 0,
      averageScore: 0,
      xCount: 0,
      tenCount: 0,
      createdAt: DateTime.now(),
    );
    await firestoreService.saveTrainingSession(newSession);
    runInAction(() => state.selectedSession.value = newSession);
    return newSession;
  }

  Future<void> registerEnd({
    required List<String> arrows,
    required double distance,
    required BowType bowType,
    required RegisteredBy registeredBy,
    required String? spotterName,
  }) async {
    clearMessages();
    final authUser = authService.currentUser;
    if (authUser == null) {
      runInAction(() => state.errorMessage.value = 'No authenticated user found.');
      return;
    }

    if (registeredBy == RegisteredBy.spotter &&
        (spotterName == null || spotterName.trim().isEmpty)) {
      runInAction(() {
        state.errorMessage.value = 'Spotter name is required.';
      });
      return;
    }

    runInAction(() => state.isLoading.value = true);
    try {
      final session = await _ensureSession();
      final endId = await firestoreService.createTrainingEndId();
      final endModel = trainingMetricsService.buildEndModel(
        endId: endId,
        sessionId: session.sessionId,
        userId: authUser.userId,
        arrows: arrows,
        distance: distance,
        bowType: bowType,
        registeredBy: registeredBy,
        spotterName: spotterName?.trim().isEmpty == true ? null : spotterName,
      );

      final updatedTotalArrows = session.totalArrows + endModel.arrows.length;
      final currentScore = session.averageScore * session.totalArrows;
      final endScore = endModel.averageScore * endModel.arrows.length;
      final updatedAverage = updatedTotalArrows == 0
          ? 0.0
          : (currentScore + endScore) / updatedTotalArrows;

      final updatedSession = session.copyWith(
        totalArrows: updatedTotalArrows,
        averageScore: updatedAverage,
        xCount: session.xCount + endModel.xCount,
        tenCount: session.tenCount + endModel.tenCount,
      );

      await firestoreService.saveTrainingEnd(endModel);
      await firestoreService.saveTrainingSession(updatedSession);

      runInAction(() {
        state.selectedSession.value = updatedSession;
        state.ends.add(endModel);
        state.successMessage.value = 'End registered successfully.';
      });
    } catch (exception) {
      runInAction(() => state.errorMessage.value = exception.toString());
    } finally {
      runInAction(() => state.isLoading.value = false);
    }
  }

  void finishSession() {
    runInAction(() {
      state.selectedSession.value = null;
      state.ends.clear();
    });
  }

  void dispose() {
    sessionsSubscription?.cancel();
    endsSubscription?.cancel();
  }
}
