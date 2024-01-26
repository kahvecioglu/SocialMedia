import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmedia/component/drawer.dart';
import 'package:socialmedia/component/text_field.dart';
import 'package:socialmedia/component/wall_post.dart';
import 'package:socialmedia/helper/helper_method.dart';
import 'package:socialmedia/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // user
  final currentUser = FirebaseAuth.instance.currentUser!;

  final textcontroler = TextEditingController();

  // Sign Out
  void SignOut() {
    FirebaseAuth.instance.signOut();
  }

  void postMessage() {
    if (textcontroler.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail': currentUser.email,
        'Message': textcontroler.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });
    }

    setState(() {
      textcontroler.clear();
    });
  }

  void gotoprofiles() {
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(
          "The Wall",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[800],
      ),
      drawer: MyDrawer(
        onTapProfiles: gotoprofiles,
        onTapLogout: SignOut,
      ),
      body: Center(
        child: Column(
          children: [
            // the wall
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("User Posts")
                    .orderBy("TimeStamp", descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        // mesajı al
                        final post = snapshot.data!.docs[index];
                        return WallPage(
                          message: post['Message'],
                          user: post['UserEmail'],
                          postId: post.id,
                          time: formatdate(post['TimeStamp']),
                          likes: List<String>.from(post['Likes'] ?? []),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: " + snapshot.error.toString()),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),

            // post mesaj

            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: textcontroler,
                      hintText: "Bir şeyler yazın..",
                      obscuretext: false,
                    ),
                  ), // post button
                  IconButton(
                    onPressed: postMessage,
                    icon: Icon(Icons.arrow_circle_up),
                  ),
                ],
              ),
            ),

            // olarak giriş yaptı
            Text(
              "Kullanıcı  " + currentUser.email!,
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
