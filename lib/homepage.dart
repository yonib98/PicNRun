import 'package:flutter/material.dart';
import 'package:pic_n_run/data_mode_impl.dart';
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
  final fbManager;
  const HomePage(this.fbManager);
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
                      onPressed: () async {
                        // Firebase stuff
                        // print('Trying to create a game');
                        //await fbManager.createGame("hello firesbase !");
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
                        // print('Trying to join a game');
                        // JoinGameStatus status = await fbManager.joinGame(754978, "yonib");
                        // print(status);
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
 