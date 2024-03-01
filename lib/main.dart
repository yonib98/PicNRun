import 'package:flutter/material.dart';
import 'theme.dart';
import 'homepage.dart';
import 'data_mode_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  final FireBaseManager fbManager = FireBaseManager();

  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder(
      future: fbManager.initializeFireBase(),
      builder: (context, snapshot){
      if (snapshot.hasError) {
        return Scaffold(
          body: Center(
            child: Text(snapshot.error.toString(),
            textDirection: TextDirection.ltr)));
      }
      if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
                  theme: MaterialTheme(Typography().black).light(),
                  home: HomePage(fbManager),
      );
      }
      return const Center(child: CircularProgressIndicator());
    }
    );
  }
}