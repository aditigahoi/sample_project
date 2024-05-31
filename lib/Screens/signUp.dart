import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sample_project/Screens/homePage.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Sign Up"),
        backgroundColor: const Color.fromARGB(255, 136, 87, 221),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 110.0),
              child: Center(
                child: Container(
                  width: 200,
                  height: 100,
                  /*decoration: BoxDecoration( 
                        color: Colors.red, 
                        borderRadius: BorderRadius.circular(50.0)),*/
                ),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                    hintText: 'Enter Your Name'),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email or username',
                    hintText: 'Enter Email Address'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter password'),
              ),
            ),
            SizedBox(
              height: 65,
              width: 360,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ElevatedButton(
                    child: Text(
                      'Sign Up ',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 115, 72, 110),
                          fontSize: 20),
                    ),
                    onPressed: () async {
                      await _registerWithEmailPassword();
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _registerWithEmailPassword() async {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((value) {
      print("Created New Account");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(
                    email: emailController.text,
                  )));
    }).onError((error, stackTrace) {
      print("Error ${error.toString()}");
    });
  }
}


//gptco
// Future<void> _registerWithEmailPassword() async {
//     try {
//       UserCredential userCredential = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(
//         email: emailController.text,
//         password: passwordController.text,
//       );

//       User? user = userCredential.user;
//       if (user != null && !user.emailVerified) {
//         await user.sendEmailVerification();
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text(
//               "Verification email has been sent. Please check your inbox."),
//         ));
//         // You may want to sign the user out and prompt them to verify their email
//         await FirebaseAuth.instance.signOut();
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => SigninScreen()),
//         );
//       }
//     } on FirebaseAuthException catch (e) {
//       print("Error ${e.message}");
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text("Error: ${e.message}"),
//       ));
//     }
//   }