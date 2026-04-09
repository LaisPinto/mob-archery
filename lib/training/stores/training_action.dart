import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:mob_archery/services/auth_service.dart';
import 'package:mob_archery/services/firestore_service.dart';
import 'package:mob_archery/training/enums/bow_type.dart';
import 'package:mob_archery/training/enums/registered_by.dart';
import 'package:mob_archery/training/models/training_end_model.dart';
import 'package:mob_archery/training/models/training_session_model.dart';
import 'package:mob_archery/training/services/training_metrics_service.dart';
import 'package:mob_archery/training/services/training_report_service.dart';
import 'package:mob_archery/training/stores/training_state.dart';
import 'dart:typed_data';

class TrainingAction {
  TrainingAction(
    this.state,
    this.authService,
    this.firestoreService,
    this.trainingMetricsService,
    this.trainingReportService,
  );

  final TrainingState state;
  final AuthServiceInterface authService;
  final FirestoreServiceInterface firestoreService;
  final TrainingMetricsService trainingMetricsService;
  final TrainingReportService trainingReportService;

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
    if (authUser == null) return;

    sessionsSubscription?.cancel();
    sessionsSubscription = firestoreService
        .watchTrainingSessions(authUser.userId)
        .listen(
          (sessions) {
            runInAction(() {
              state.sessions
                ..clear()
                ..addAll(sessions);
            });
          },
          onError: (error) {
            runInAction(() => state.errorMessage.value = error.toString());
          },
        );
  }

  void watchEnds(TrainingSessionModel session) {
    final authUser = authService.currentUser;
    if (authUser == null) return;

    runInAction(() => state.selectedSession.value = session);
    endsSubscription?.cancel();
    endsSubscription = firestoreService
        .watchTrainingEnds(
          userId: authUser.userId,
          sessionId: session.sessionId,
        )
        .listen(
          (ends) {
            runInAction(() {
              state.ends
                ..clear()
                ..addAll(ends);
            });
          },
          onError: (error) {
            runInAction(() => state.errorMessage.value = error.toString());
          },
        );
  }

  Future<TrainingSessionModel> _ensureSession({
    String name = '',
    bool isSpotter = false,
  }) async {
    final authUser = authService.currentUser;
    if (authUser == null) throw StateError('No authenticated user found.');

    final existingSession = state.selectedSession.value;
    if (existingSession != null) return existingSession;

    final sessionId = await firestoreService.createTrainingSessionId();
    final newSession = TrainingSessionModel(
      sessionId: sessionId,
      userId: authUser.userId,
      name: name,
      date: DateTime.now(),
      totalArrows: 0,
      averageScore: 0,
      xCount: 0,
      tenCount: 0,
      createdAt: DateTime.now(),
      isSpotter: isSpotter,
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
    String name = '',
  }) async {
    clearMessages();
    final authUser = authService.currentUser;
    if (authUser == null) {
      runInAction(
        () => state.errorMessage.value = 'No authenticated user found.',
      );
      return;
    }

    if (registeredBy == RegisteredBy.spotter &&
        (spotterName == null || spotterName.trim().isEmpty)) {
      runInAction(() => state.errorMessage.value = 'Spotter name is required.');
      return;
    }

    runInAction(() => state.isLoading.value = true);
    try {
      final session = await _ensureSession(
        name: name,
        isSpotter: registeredBy == RegisteredBy.spotter,
      );
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
        isSpotter: session.isSpotter || registeredBy == RegisteredBy.spotter,
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

  Future<void> exportSessionPdf(TrainingSessionModel session) async {
    clearMessages();
    final authUser = authService.currentUser;
    if (authUser == null) {
      runInAction(
        () => state.errorMessage.value = 'No authenticated user found.',
      );
      return;
    }

    runInAction(() => state.isLoading.value = true);
    try {
      final List<TrainingEndModel> ends;
      if (state.selectedSession.value?.sessionId == session.sessionId &&
          state.ends.isNotEmpty) {
        ends = state.ends.toList();
      } else {
        ends = await firestoreService
            .watchTrainingEnds(
              userId: authUser.userId,
              sessionId: session.sessionId,
            )
            .first;
      }

      final pdfBytes = await trainingReportService.buildSessionPdf(
        session: session,
        ends: ends,
      );

      await Printing.layoutPdf(
        onLayout: (_) async => Uint8List.fromList(pdfBytes),
        name: 'mob_archery_${session.sessionId}.pdf',
      );
    } catch (e) {
      runInAction(() => state.errorMessage.value = e.toString());
    } finally {
      runInAction(() => state.isLoading.value = false);
    }
  }

  Future<void> shareSession(TrainingSessionModel session) async {
    clearMessages();
    final title = session.name.isNotEmpty ? session.name : 'Treino';
    final totalScore = (session.averageScore * session.totalArrows).round();

    final text =
        '🏹 Meu treino no Mob Archery!\n'
        '📋 $title\n'
        '📊 Total: $totalScore pts  |  Média: ${session.averageScore.toStringAsFixed(1)}  |  X Count: ${session.xCount}\n'
        '🎯 ${session.totalArrows} flechas registradas';

    try {
      await Share.share(text, subject: 'Mob Archery — Relatório de Treino');
    } catch (e) {
      runInAction(() => state.errorMessage.value = e.toString());
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
