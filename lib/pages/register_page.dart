import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmedia/component/button.dart';
import 'package:socialmedia/component/text_field.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailtextcontroller = TextEditingController();
  final pasaporttextcontroller = TextEditingController();
  final confirmpasaporttextcontroller = TextEditingController();

  // Kayıt olma kısmı

  void SignUp() async {
    // loading ekranı
    showDialog(
      context: context,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Pasaport eşleştirme
    if (pasaporttextcontroller.text != confirmpasaporttextcontroller.text) {
      Navigator.pop(context);
      // hata mesajı
      showDialogg("Parola eşleşmiyor");
      return;
    }

    try {
      //create the user

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailtextcontroller.text,
              password: pasaporttextcontroller.text);

      // Hesap oluşturulduktan sonra , yeni döküman oluştur
      FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email!)
          .set({'username': "user", 'bio': 'Empty '}); // İNİTİAL USERNAME
      if (context.mounted) {
        // başarılıysa loadingi kapat
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      // loading i kapat
      Navigator.pop(context);
      showDialogg(e.code);
    }
  }

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
                "Lets create an account for you",
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

              // confirm pasaport

              SizedBox(
                height: 10,
              ),
              MyTextField(
                  controller: confirmpasaporttextcontroller,
                  hintText: "Confirm Password",
                  obscuretext: true),

              // sign Up button
              SizedBox(
                height: 30,
              ),
              MyButton(onTap: SignUp, text: "Sign Up"),

              //go to register button
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Alreadey have an account?",
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
                      "  Login now",
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
