import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmedia/component/text_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  final usersCollection = FirebaseFirestore.instance.collection('Users');

  Future<void> editField(String field) async {
    String newvalue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Edit " + field,
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              hintText: "Enter new " + field,
              hintStyle: TextStyle(color: Colors.grey)),
          onChanged: (value) {
            newvalue = value;
          },
        ),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text("Save"),
            onPressed: () => Navigator.of(context).pop(newvalue),
          ),
        ],
      ),
    );

    if (newvalue.trim().length > 0) {
      await usersCollection.doc(currentUser.email).update({field: newvalue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          // get user data
          if (snapshot.hasData) {
            final userdata = snapshot.data!.data() as Map<String, dynamic>;

            return ListView(
              children: [
                SizedBox(
                  height: 50,
                ),
                // profile pic
                Icon(
                  Icons.person,
                  size: 92,
                ),
                SizedBox(
                  height: 10,
                ),
                // user email
                Text(
                  currentUser.email!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                SizedBox(
                  height: 50,
                ),

                // user details

                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(
                    "My Details",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),

                // username

                MyTextBox(
                  text: userdata['username'],
                  sectionName: 'user name',
                  onPressed: () => editField('username'),
                ),

                // bio
                MyTextBox(
                  text: userdata['bio'],
                  sectionName: 'bio',
                  onPressed: () => editField('bio'),
                ),

                SizedBox(
                  height: 50,
                ),

                // user post
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(
                    "My Posts",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error' + snapshot.error.toString()),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
