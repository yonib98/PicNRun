import 'package:flutter/material.dart';
import 'package:pic_n_run/firebase_manager.dart';
import 'package:pic_n_run/header.dart';

class HomePage extends StatelessWidget {
  final FireBaseManager fbManager = FireBaseManager();

  HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Header(),
        Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.70,
              height: MediaQuery.of(context).size.height * 0.07,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to "PickUserNameScreen" and pass the fbManager
                  Navigator.pushNamed(context, '/pick_username',
                      arguments: {"creatingGame": true});
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: const BorderSide(color: Colors.black, width: 1.0),
                    ),
                  ),
                  elevation: MaterialStateProperty.all(5.0),
                ),
                child:
                    const Text('Create Game', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.70,
              height: MediaQuery.of(context).size.height * 0.07,
              child: ElevatedButton(
                onPressed: () async {
                  // Firebase stuff
                  Navigator.pushNamed(context, '/pick_username',
                      arguments: {"creatingGame": false});
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: const BorderSide(color: Colors.black, width: 1.0),
                    ),
                  ),
                  elevation: MaterialStateProperty.all(5.0),
                ),
                child: const Text('Join Game', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ],
    )));
  }
}
