import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:babysitterapp/src/controllers.dart';
import 'package:babysitterapp/src/providers.dart';
import 'package:babysitterapp/src/services.dart';
import 'package:babysitterapp/src/models.dart';

final Provider<AuthRepository> authRepositoryProvider =
    Provider<AuthRepository>((ProviderRef<AuthRepository> ref) {
  final FirebaseAuth auth = ref.watch(firebaseAuthProvider);
  final FirebaseFirestore firestore = ref.watch(firebaseFirestoreProvider);
  final FirebaseStorage storage = ref.watch(firebaseStorageProvider);
  final LoggerService logger = ref.watch(loggerProvider);

  return AuthRepository(
    firebaseAuth: auth,
    firestore: firestore,
    storage: storage,
    logger: logger,
  );
});

final StateNotifierProvider<AuthController, AuthState> authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>(
        (StateNotifierProviderRef<AuthController, AuthState> ref) {
  final AuthRepository authRepo = ref.watch(authRepositoryProvider);
  final LoggerService logger = ref.watch(loggerProvider);
  return AuthController(authRepo, logger);
});