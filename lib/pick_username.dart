import 'package:flutter/material.dart';
import 'package:pic_n_run/firebase_manager.dart';
import 'package:pic_n_run/header.dart';

double calculateContainerHeight(MediaQueryData mediaQuery) {
  bool isKeyboardOpen = mediaQuery.viewInsets.bottom > 0.0;
  return isKeyboardOpen
      ? mediaQuery.size.height * 0.05
      : mediaQuery.size.height * 0.07;
}

class JoinGameForm extends StatefulWidget {
  const JoinGameForm({super.key});

  @override
  JoinGameFormState createState() {
    return JoinGameFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class JoinGameFormState extends State<JoinGameForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  //final gameIdFieldRequired;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController gameIdController = TextEditingController();
  final FireBaseManager fbManager = FireBaseManager();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final containerHeight = calculateContainerHeight(mediaQuery);

    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: mediaQuery.size.width * 0.80,
            height: containerHeight,
            child: TextFormField(
              // The validator receives the text that the user has entered.
              controller: gameIdController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(width: 2.0),
                ),
                labelText: 'Game ID',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              validator: (value) {
                return null;
              },
            ),
          ),
          const SizedBox(height: 20), // TODO: This is bad Remove.

          SizedBox(
            width: mediaQuery.size.width * 0.80,
            height: containerHeight,
            child: TextFormField(
              // The validator receives the text that the user has entered.
              controller: usernameController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(width: 2.0),
                ),
                labelText: 'Username',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              validator: (value) {
                return null;
              },
            ),
          ),

          const SizedBox(height: 20), // TODO: This is bad Remove.
          SizedBox(
            width: mediaQuery.size.width * 0.70,
            height: containerHeight,
            child: ElevatedButton(
              onPressed: () async {
                print(
                    "username is ${usernameController.text}, game id is ${gameIdController.text}");
                await fbManager.joinGame(
                    int.parse(gameIdController.text), usernameController.text);
                Navigator.pushNamed(context, '/waiting_screen');
                // TODO: error checking, show snackbars.
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
              child: const Text('Go'),
            ),
          ),
        ],
      ),
    );
  }
}

// Create a Form widget.
class CreateGameForm extends StatefulWidget {
  const CreateGameForm({super.key});

  @override
  CreateGameFormState createState() {
    return CreateGameFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class CreateGameFormState extends State<CreateGameForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  //final gameIdFieldRequired;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController gameIdController = TextEditingController();
  final FireBaseManager fbManager = FireBaseManager();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final containerHeight = calculateContainerHeight(mediaQuery);

    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: mediaQuery.size.width * 0.80,
            height: containerHeight,
            child: TextFormField(
              // The validator receives the text that the user has entered.
              controller: usernameController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(width: 2.0),
                ),
                labelText: 'Username',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              validator: (value) {
                return null;
              },
            ),
          ),
          const SizedBox(height: 20), // TODO: This is bad Remove.
          SizedBox(
            width: mediaQuery.size.width * 0.70,
            height: containerHeight,
            child: ElevatedButton(
              onPressed: () async {
                print("username is ${usernameController.text}");
                await fbManager.createGame(usernameController.text);
                Navigator.pushNamed(context, '/waiting_screen',
                    arguments: {"creatingGame": true});

                // TODO: error checking, show snack bar accordingly.
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
              child: const Text('Go'),
            ),
          ),
        ],
      ),
    );
  }
}

class PickUserNameScreen extends StatelessWidget {
  final FireBaseManager fbManager = FireBaseManager();

  PickUserNameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final creatingGame =
        (ModalRoute.of(context)?.settings.arguments as Map)['creatingGame'];
    final form = creatingGame ? const CreateGameForm() : const JoinGameForm();

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
            form,
          ],
        ))
      ],
    ));
  }
}
