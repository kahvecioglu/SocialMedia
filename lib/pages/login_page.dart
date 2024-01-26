import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmedia/component/button.dart';
import 'package:socialmedia/component/text_field.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailtextcontroller = TextEditingController();

  final pasaporttextcontroller = TextEditingController();

  void SignIn() async {
    // Loading şeklini göster
    showDialog(
      context: context,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      BuildContext dialogContext =
          context; // hata veriyor diye bu atamayı yaptım
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailtextcontroller.text,
          password: pasaporttextcontroller.text);

      // loading şeklinden çık
      if (dialogContext.mounted) {
        Navigator.pop(dialogContext);
      }
    } on FirebaseAuthException catch (e) {
      // loading şeklinden çık
      Navigator.pop(context);

      // hata mesajını göster
      showDialogg(e.code);
    }
  }

  // Dialog göster

  void showDialogg(String message) {
    // farklı isim olmak zorunda
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(message),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              // logo
              Icon(
                Icons.lock,
                size: 100,
              ),
              // welcome back mesajı
              SizedBox(
                height: 50,
              ),
              Text(
                "Welcome back , you've been missed",
                style: TextStyle(
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(
                height: 25,
              ),

              // email textfield
              MyTextField(
                  controller: emailtextcontroller,
                  hintText: "Email",
                  obscuretext: false),

              // pasaport textfield

              SizedBox(
                height: 10,
              ),
              MyTextField(
                  controller: pasaporttextcontroller,
                  hintText: "Password",
                  obscuretext: true),

              // sign in button
              SizedBox(
                height: 10,
              ),
              MyButton(onTap: SignIn, text: "Sign in"),

              //go to register button
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not a member?",
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      "  Register now",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  )
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
