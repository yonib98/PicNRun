import 'package:flutter/material.dart';
import 'package:pic_n_run/firebase_manager.dart';
import 'package:pic_n_run/pick_username.dart';
import 'theme.dart';

class Header extends StatelessWidget {

  const Header({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/images/logo.png'),
        Image.asset('assets/images/wallpaper.png'),
      ],
    );
  }
}

class HomePage extends StatelessWidget {
  final FireBaseManager fbManager = FireBaseManager();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Center(
        child:
        Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Header(),
              Container(
              child: Column(
                children:
                  [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.70,
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to "PickUserNameScreen" and pass the fbManager
                        Navigator.pushNamed(context, '/pick_username',  arguments: {"creatingGame": true});
                      },
                      child: const Text('Create Game',
                                        style: TextStyle(fontSize: 16)),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: const BorderSide(color: Colors.black, width: 1.0),
                          ),
                        ),
                        elevation: MaterialStateProperty.all(5.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.70,
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Firebase stuff
                        Navigator.pushNamed(context, '/pick_username', arguments: {"creatingGame": false});

                      },
                      child: const Text('Join Game',
                              style: TextStyle(fontSize: 16)),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: const BorderSide(color: Colors.black, width: 1.0),
                          ),
                        ),
                        elevation: MaterialStateProperty.all(5.0),
                      ),
                    ),
                  ),
                  ],
              ),
              ),
            ],
          )
      )
    );
  }
}
 