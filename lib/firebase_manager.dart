import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum JoinGameStatus {
  gameDoesNotExist,
  gameHasStarted,
  gameHasEnded,
  gameIsFull,
  nickNameAlreadyExists,
  unkownError,
  success,
}

// TODO: We may need alot more of these "firestore transaction".

class FireBaseManager {
  // Private constructor
  FireBaseManager._privateConstructor();

  // Static instance
  static final FireBaseManager _instance =
      FireBaseManager._privateConstructor();

  // Factory constructor
  factory FireBaseManager() {
    return _instance;
  }

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  late FirebaseFirestore _firestore;
  late int gameId;

  Future<FirebaseApp> initializeFireBase() async {
    await _initialization;
    _firestore = FirebaseFirestore.instance;
    return _initialization;
  }

  /* API */
  Future<int> createGame(String owner) async {
    return await _firestore.runTransaction((transaction) async {
      bool uniqueGameId = false;
      DocumentReference? gameReference;
      DocumentSnapshot? snapshot;
      int gameId = 0;
      while (!uniqueGameId) {
        gameId = generateGameId();
        gameReference = _firestore.collection('games').doc(gameId.toString());
        snapshot = await transaction.get(gameReference);
        uniqueGameId = !snapshot.exists;
      }
      print("After unique game id");
      transaction.set(gameReference!, {
        'owner': owner,
        'players': [owner],
        'status': {
          'hasStarted': false,
          'hasEnded': false,
        },
        'settings': {
          'maxPlayers': 10,
          'timeLimit': 60,
          'gameDuration': 300,
        }
      });
      print("After transaction set");
      this.gameId = gameId;
      return gameId;
    });
  }

  Future<JoinGameStatus> joinGame(int gameId, String player) async {
    // 1. Check game id exists. Done
    // 2. Check game has not started. Done
    // 3. Check game has not finished. Done
    // 4. Chcke game is not full. Done
    // 5. Check player name is unique. Done
    // 6. update the "players" array.

    // Check that the game actually exists.
    DocumentSnapshot<Map<String, dynamic>> gameDoc =
        await _firestore.collection('games').doc(gameId.toString()).get();
    if (gameDoc.exists) {
      print('Document exists on the database');
    } else {
      print('Document does not exist on the database');
      return JoinGameStatus.gameDoesNotExist;
    }

    // Try to join the game
    return await _firestore.runTransaction((transaction) async {
      var gameReference = _firestore.collection('games').doc(gameId.toString());
      var snapshot = await transaction.get(gameReference);

      // Validate that the game setttings allows you to join the game.
      final status = checkGameSettings(snapshot.data()!, player);
      if (status != JoinGameStatus.success) {
        return status;
      }

      // Try to add yourself to the game.
      var localPlayers = snapshot.get('players');
      if (!localPlayers.contains(player)) {
        localPlayers.add(player);
        try {
          transaction.update(gameReference, {"players": localPlayers});
          this.gameId = gameId;
          return JoinGameStatus.success;
        } catch (e) {
          print('Error: $e');
          return JoinGameStatus.unkownError;
        }
      } else {
        return JoinGameStatus.nickNameAlreadyExists;
      }
    });
  }

  Stream<DocumentSnapshot> getGameStream() =>
      _firestore.collection('games').doc(gameId.toString()).snapshots();

  /// Generate a 6-digit random number.
  int generateGameId() => Random().nextInt(900000) + 100000;

  JoinGameStatus checkGameSettings(
      Map<String, dynamic> gameData, String player) {
    if (gameData['status']['hasStarted']) {
      return JoinGameStatus.gameHasStarted;
    }
    if (gameData['status']['hasEnded']) {
      return JoinGameStatus.gameHasEnded;
    }
    if (gameData['players'].length == gameData['settings']['maxPlayers']) {
      return JoinGameStatus.gameIsFull;
    }

    return JoinGameStatus.success;
  }
}
