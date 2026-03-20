import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mob_archery/auth/models/user_model.dart';
import 'package:mob_archery/training/models/training_end_model.dart';
import 'package:mob_archery/training/models/training_session_model.dart';

abstract interface class FirestoreServiceInterface {
  Future<UserModel?> getUserProfile(String userId);

  Stream<UserModel?> watchUserProfile(String userId);

  Future<UserModel> upsertUserProfile(UserModel userModel);

  Future<TrainingSessionModel> saveTrainingSession(
    TrainingSessionModel trainingSession,
  );

  Future<TrainingEndModel> saveTrainingEnd(TrainingEndModel trainingEnd);

  Future<String> createTrainingSessionId();

  Future<String> createTrainingEndId();

  Stream<List<TrainingSessionModel>> watchTrainingSessions(String userId);

  Stream<List<TrainingEndModel>> watchTrainingEnds({
    required String userId,
    required String sessionId,
  });
}

class FirestoreService implements FirestoreServiceInterface {
  bool get isFirebaseConfigured => Firebase.apps.isNotEmpty;

  FirebaseFirestore get firestore {
    if (!isFirebaseConfigured) {
      throw FirebaseException(
        plugin: 'firebase_core',
        code: 'no-app',
        message:
            'Firebase is not configured. Add the platform Firebase files and initialize the default app.',
      );
    }
    return FirebaseFirestore.instance;
  }

  @override
  Future<UserModel?> getUserProfile(String userId) async {
    if (!isFirebaseConfigured) {
      return null;
    }
    final documentSnapshot = await firestore.collection('users').doc(userId).get();
    if (!documentSnapshot.exists || documentSnapshot.data() == null) {
      return null;
    }

    return UserModel.fromMap(documentSnapshot.id, documentSnapshot.data()!);
  }

  @override
  Stream<UserModel?> watchUserProfile(String userId) {
    if (!isFirebaseConfigured) {
      return Stream<UserModel?>.value(null);
    }
    return firestore.collection('users').doc(userId).snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        return null;
      }
      return UserModel.fromMap(snapshot.id, snapshot.data()!);
    });
  }

  @override
  Future<UserModel> upsertUserProfile(UserModel userModel) async {
    await firestore.collection('users').doc(userModel.userId).set(
          userModel.toMap(),
          SetOptions(merge: true),
        );
    return userModel;
  }

  @override
  Future<TrainingSessionModel> saveTrainingSession(
    TrainingSessionModel trainingSession,
  ) async {
    await firestore
        .collection('training_sessions')
        .doc(trainingSession.sessionId)
        .set(trainingSession.toMap());
    return trainingSession;
  }

  @override
  Future<TrainingEndModel> saveTrainingEnd(TrainingEndModel trainingEnd) async {
    await firestore
        .collection('training_ends')
        .doc(trainingEnd.endId)
        .set(trainingEnd.toMap());
    return trainingEnd;
  }

  @override
  Future<String> createTrainingSessionId() async {
    return firestore.collection('training_sessions').doc().id;
  }

  @override
  Future<String> createTrainingEndId() async {
    return firestore.collection('training_ends').doc().id;
  }

  @override
  Stream<List<TrainingSessionModel>> watchTrainingSessions(String userId) {
    if (!isFirebaseConfigured) {
      return Stream<List<TrainingSessionModel>>.value(const []);
    }
    return firestore
        .collection('training_sessions')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (querySnapshot) => querySnapshot.docs
              .map(
                (documentSnapshot) => TrainingSessionModel.fromMap(
                  documentSnapshot.id,
                  documentSnapshot.data(),
                ),
              )
              .toList(),
        );
  }

  @override
  Stream<List<TrainingEndModel>> watchTrainingEnds({
    required String userId,
    required String sessionId,
  }) {
    if (!isFirebaseConfigured) {
      return Stream<List<TrainingEndModel>>.value(const []);
    }
    return firestore
        .collection('training_ends')
        .where('userId', isEqualTo: userId)
        .where('sessionId', isEqualTo: sessionId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map(
          (querySnapshot) => querySnapshot.docs
              .map(
                (documentSnapshot) => TrainingEndModel.fromMap(
                  documentSnapshot.id,
                  documentSnapshot.data(),
                ),
              )
              .toList(),
        );
  }
}
