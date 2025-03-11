import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Details extends StatefulWidget {
  final String title;
  final String date;
  final String imagePath;
  final String descriptions;

  const Details({
    super.key,
    required this.title,
    required this.date,
    required this.imagePath,
    required this.descriptions,
  });

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final TextEditingController _commentController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String formatDate(String dateString) {
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  Future<void> addComment() async {
    if (_commentController.text.trim().isEmpty) return;

    String userId = _auth.currentUser?.uid ?? "anonymous";
    String userName = _auth.currentUser?.displayName ?? "Unknown User";

    await FirebaseFirestore.instance
        .collection('blogs')
        .doc(widget.title) // ใช้ title เป็น key (ควรใช้ id จริงในแอปจริง)
        .collection('comments')
        .add({
      'userId': userId,
      'userName': userName,
      'comment': _commentController.text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Blog Details',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: widget.imagePath,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                child: Image.network(
                  widget.imagePath,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Published on ${formatDate(widget.date)}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    widget.descriptions,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 24),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  Text(
                    'Comments',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  SizedBox(height: 10),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('blogs')
                        .doc(widget.title) // ใช้ title เป็น key (ควรใช้ id จริงในแอปจริง)
                        .collection('comments')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Text(
                          'No comments yet.',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var commentData =
                              snapshot.data!.docs[index].data() as Map<String, dynamic>;

                          return ListTile(
                            leading: CircleAvatar(
                              child: Text(
                                commentData['userName'][0].toUpperCase(),
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.deepPurpleAccent,
                            ),
                            title: Text(
                              commentData['userName'],
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              commentData['comment'],
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Write a comment...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send, color: Colors.deepPurpleAccent),
                        onPressed: addComment,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
