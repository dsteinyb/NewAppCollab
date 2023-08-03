import 'package:flutter/material.dart';
import 'package:new_flutter_app/auth_service.dart';
import 'package:new_flutter_app/notificationservice.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:new_flutter_app/meditations.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
// to ensure all the widgets are initialized.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

// to initialize the notificationservice.
  NotificationService().initNotification();
  Meditations().listMeds();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'GeeksForGeeks'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final player = AudioPlayer();
  final urls = Meditations().listMeds();

  @override
  void initState() {
    super.initState();
    //tz.initializeTimeZones();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
        future: Meditations().listMeds(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If we got an error
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error} occurred',
                  style: TextStyle(fontSize: 18),
                ),
              );

              // if we got our data
            } else if (snapshot.hasData) {
              // Extracting data from snapshot object
              final urls = snapshot.data;
              return Material(
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text('You have ${urls!.length} sounds:'),
                    ),
                    for (var url in urls)
                      Row(children: [
                        IconButton(
                            icon: Icon(Icons.play_circle_outline),
                            onPressed: () => player.play(UrlSource(url))),
                        Text(FirebaseStorage.instance.refFromURL(url).name)
                        //Text(url)
                      ]),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text('Google Sign In:'),
                    ),
                    const Text("Hello, \nGoogle Sign In",
                      style: TextStyle(
                        fontSize: 30
                      )),
                    GestureDetector(
                      onTap: () {
                        AuthService().signInWithGoogle();
                      },
                      child: const Image(width: 100, image: AssetImage('assets/google.png'))),
                  ],
                ),
              );
            } else {
              return Placeholder();
            }
          }
          // Displaying LoadingSpinner to indicate waiting state
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
