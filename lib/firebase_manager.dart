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
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  late FirebaseFirestore _firestore;

  Future<FirebaseApp> initializeFireBase() async {
    await _initialization;
    _firestore = FirebaseFirestore.instance;
    return _initialization;
  }

  /* API */
  Future<int> createGame(String owner) async {
    final gameId = await generateUniqueGameId();
    await _firestore
    .collection('games')
    .doc(gameId.toString())
    .set({
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
    return gameId;
  }


  Future<JoinGameStatus> joinGame(int gameId, String player) async {
    // 1. Check game id exists. Done
    // 2. Check game has not started. Done
    // 3. Check game has not finished. Done
    // 4. Chcke game is not full. Done
    // 5. Check player name is unique. Done
    // 6. update the "players" array. 
    DocumentSnapshot<Map<String, dynamic>> gameDoc = await _firestore
    .collection('games')
    .doc(gameId.toString())
    .get();
    if (gameDoc.exists) {
      print('Document exists on the database');
    } else {
      print('Document does not exist on the database');
      return JoinGameStatus.gameDoesNotExist;
    }

    final status = checkGameSettings(gameDoc.data()!, player);
    if (status != JoinGameStatus.success){
      return status;
    }

  bool playerAlreadyExists = false;
  await _firestore.runTransaction((transaction) async {
      var gameReference = _firestore.collection('games').doc(gameId.toString());
      var snapshot = await transaction.get(gameReference);
      var localPlayers = snapshot.get('players');
      if (!localPlayers.contains(player)) {
        localPlayers.add(player);
        try{ 
          transaction.update(gameReference, {"players": localPlayers});
        }
        catch (e) {
          print('Error: $e');
          return JoinGameStatus.unkownError;
        }
    }
    else {
      playerAlreadyExists = true;
    }
  });
  if (playerAlreadyExists) {
    return JoinGameStatus.nickNameAlreadyExists;
  }
  return JoinGameStatus.success;
}

  /* Helper Functions */
  Future<int> generateUniqueGameId() async {
    // Returns a 6 digit unique game id.
    bool uniqueGameId = false;
    int gameId = 0;
    while (!uniqueGameId){
      gameId = Random().nextInt(900000) + 100000;
      QuerySnapshot<Map<String, dynamic>>  gamesQuery = await _firestore
      .collection('games')
      .where('id', isEqualTo: gameId.toString())
      .get();
      if (gamesQuery.docs.isEmpty) {
        uniqueGameId = true;
      }
    }
    return gameId;
  }

  JoinGameStatus checkGameSettings(Map<String, dynamic> gameData, String player) {
    if (gameData['status']['hasStarted']) {
      return JoinGameStatus.gameHasStarted;
    }
    if (gameData['status']['hasEnded']) {
      return JoinGameStatus.gameHasEnded;
    }
    if (gameData['players'].length ==gameData['settings']['maxPlayers']) {
      return JoinGameStatus.gameIsFull;
    }

    return JoinGameStatus.success;
  }

}