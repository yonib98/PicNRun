import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pic_n_run/firebase_manager.dart';
import 'package:pic_n_run/homepage.dart' show Header;

/* Helper function for the player preview string in the WaitingScreen Widget */
List<String> getRandomUniquePlayers(List<String> players, int count) {
  if (count > players.length) {
    throw ArgumentError("Count should not exceed the length of the array.");
  }

  Set<String> selectedPlayers = Set<String>();
  Random random = Random();

  while (selectedPlayers.length < count) {
    int randomIndex = random.nextInt(players.length);
    selectedPlayers.add(players[randomIndex]);
  }

  return selectedPlayers.toList();
}

class WaitingScreen extends StatelessWidget {
  final FireBaseManager fbManager = FireBaseManager();

  @override
  Widget build(BuildContext context) {
    // final creatingGame = (ModalRoute.of(context)?.settings.arguments as Map)['creatingGame'];

    return StreamBuilder(
      stream: fbManager.getGameStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData == false) {
          return const Center(child: CircularProgressIndicator());
        }
        final maxPlayers = snapshot.data!['settings']['maxPlayers'];
        final players = snapshot.data!['players'].cast<String>();// TODO: FIX this is weird not sure this is how you cast dynamic list to string.
        final playersPreview = getRandomUniquePlayers(players, min(3, players.length));
        return Scaffold(
          body:
          Stack(
            children: [
              AppBar(),
              Expanded(
              child:
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Center(child: Header()),
                  // GamePinWidget(fbManager.gameId),
                  Container(
                    child: Column(
                      children: [
                        Text('${players.length} / $maxPlayers Players:',
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
            )
            )
            ],
          ) 
        );
      },
      );
  }
}