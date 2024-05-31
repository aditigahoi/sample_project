import 'package:flutter/material.dart';
import 'package:sample_project/Screens/signIn.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyD4FinvrzSLtgikmynxJamYn8deMtXvzks",
      projectId: "sample-project-ab174",
      storageBucket: "sample-project-ab174.appspot.com",
      messagingSenderId: "580047618568",
      appId: "1:580047618568:android:df3ec1549393a9c27587bd",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SigninScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
