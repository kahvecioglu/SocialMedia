import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmedia/component/comment.dart';
import 'package:socialmedia/component/comment_button.dart';
import 'package:socialmedia/component/delete_button.dart';
import 'package:socialmedia/component/like_button.dart';
import 'package:socialmedia/helper/helper_method.dart';

class WallPage extends StatefulWidget {
  final String message;
  final String user;
  final String time;
  final String postId;
  final List<String> likes;
  const WallPage(
      {super.key,
      required this.message,
      required this.user,
      required this.postId,
      required this.likes,
      required this.time});

  @override
  State<WallPage> createState() => _WallPageState();
}

class _WallPageState extends State<WallPage> {
  // user
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  final _commentTextField = TextEditingController();

  void initState() {
    isLiked = widget.likes.contains(currentUser.email);
    super.initState();
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference postReferance =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

    if (isLiked) {
      postReferance.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postReferance.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  // add a comment

  void addcomment(String commenttext) {
    FirebaseFirestore.instance
        .collection("User Posts")
        .doc(widget.postId)
        .collection("Comments")
        .add({
      "CommentText": commenttext,
      "CommentBy": currentUser.email,
      "CommentTime": Timestamp.now()
    });
  }

  // show a dialog box for adding comment

  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add comment"),
        content: TextField(
          controller: _commentTextField,
          decoration: InputDecoration(hintText: "Write a comment ..."),
        ),
        actions: [
          // post button
          TextButton(
            onPressed: () {
              addcomment(_commentTextField.text);
              Navigator.pop(context);
              _commentTextField.clear();
            },
            child: Text("Post"),
          ),
          // cancel button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _commentTextField.clear();
            },
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void deletepost() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete post"),
        content: Text("Silmek istiyor musun ?"),
        actions: [
          // cancel button
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text("Cancel")),

          // delete button
          TextButton(
              onPressed: () async {
                final commentdocs = await FirebaseFirestore.instance
                    .collection("User Posts")
                    .doc(widget.postId)
                    .collection("Comments")
                    .get();

                for (var doc in commentdocs.docs) {
                  await FirebaseFirestore.instance
                      .collection("User Posts")
                      .doc(widget.postId)
                      .collection("Comments")
                      .doc(doc.id)
                      .delete();
                }

                FirebaseFirestore.instance
                    .collection("User Posts")
                    .doc(widget.postId)
                    .delete()
                    .then((value) => print("Post deleted"))
                    .catchError((error) => print("Failed deleted:$error"));

                Navigator.pop(context);
              },
              child: Text("Delete")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // group of text (mail + message)

              Column(
                // wallpost
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.user,
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      Text("  "),
                      Text(widget.time,
                          style: TextStyle(color: Colors.grey[400])),
                    ],
                  ),
                  SizedBox(height: 10),

                  // message
                  Text(widget.message),
                ],
              ),
              // delete button

              if (widget.user == currentUser.email)
                DeleteButton(onTap: deletepost),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // LIKE
              Column(
                children: [
                  // like button
                  LikeButton(isLiked: isLiked, onTap: toggleLike),
                  SizedBox(width: 5),
                  Text(widget.likes.length.toString()),
                ],
              ),
              SizedBox(
                width: 10,
              ),

              // COMMENT
              Column(
                children: [
                  // COMMENT button
                  CommentButton(onTap: showCommentDialog),
                  SizedBox(width: 5),
                  // comment  count
                  Text("0"),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          // comments under the post
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("User Posts")
                .doc(widget.postId)
                .collection("Comments")
                .orderBy("CommentTime", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              // data yüklenmediyse loading ekranı göster

              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc) {
                  // get the comment
                  final commentdata = doc.data() as Map<String, dynamic>;

                  // return the comment
                  return comment(
                      text: commentdata["CommentText"],
                      time: commentdata["CommentBy"],
                      user: formatdate(commentdata["CommentTime"]));
                }).toList(),
              );
            },
          )
        ],
      ),
    );
  }
}
