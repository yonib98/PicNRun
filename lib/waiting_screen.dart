import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pic_n_run/firebase_manager.dart';
import 'package:pic_n_run/header.dart';

/* Helper function for the player preview string in the WaitingScreen Widget */
List<String> getRandomUniquePlayers(List<String> players, int count) {
  if (count > players.length) {
    throw ArgumentError("Count should not exceed the length of the array.");
  }

  final selectedPlayers = <String>{};
  final random = Random();

  while (selectedPlayers.length < count) {
    int randomIndex = random.nextInt(players.length);
    selectedPlayers.add(players[randomIndex]);
  }

  return selectedPlayers.toList();
}

class WaitingScreen extends StatelessWidget {
  final FireBaseManager fbManager = FireBaseManager();

  WaitingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final creatingGame = (ModalRoute.of(context)?.settings.arguments as Map)['creatingGame'];

    return StreamBuilder(
      stream: fbManager.getGameStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData == false) {
          return const Center(child: CircularProgressIndicator());
        }
        final maxPlayers = snapshot.data!['settings']['maxPlayers'] as int;
        final players = snapshot.data!['players'] as List<String>;
        final playersPreview =
            getRandomUniquePlayers(players, min(3, players.length));
        return Scaffold(
            body: Stack(
          children: [
            AppBar(),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Center(child: Header()),
                // GamePinWidget(fbManager.gameId),
                Container(
                  child: Column(
                    children: [
                      Text(
                        '${players.length} / $maxPlayers Players:',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ), // Label bold
                      Text(
                        playersPreview.join(', '),
                      ),
                    ],
                  ),
                ),
              ],
            ))
          ],
        ));
      },
    );
  }
}
