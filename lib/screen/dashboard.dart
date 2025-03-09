import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miniproject/screen/details.dart';
import 'package:miniproject/screen/home.dart';
import 'package:path_provider/path_provider.dart';

class BlogFeedScreen extends StatefulWidget {
  @override
  State<BlogFeedScreen> createState() => _BlogFeedScreenState();
}

class _BlogFeedScreenState extends State<BlogFeedScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String displayName = "";

  void checkAdmin() {
    final User user = auth.currentUser!;
    displayName = user.displayName ?? "";
    setState(() {});
  }

  Future<List<Map<String, String>>> fetchBlogs() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('blogs')
          .orderBy('datetime', descending: true)
          .get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>? ?? {};
        return {
          'title': data['title']?.toString() ?? 'No Title',
          'date': data['datetime']?.toString() ?? 'No Date',
          'image': data['image']?.toString() ?? '',
          'descriptions': data['descriptions']?.toString() ?? '',
        };
      }).toList();
    } catch (e) {
      return [];
    }
  }

  logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Home()), // หน้าใหม่
      (Route<dynamic> route) => false, // ลบทุกหน้า
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAdmin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              'Medium Blog Feed',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.deepPurpleAccent,
            elevation: 4,
            shadowColor: Colors.black45,
            actions: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.logout_sharp,
                  color: Colors.white,
                ),
                onPressed: () {
                  logout();
                },
              )
            ]),
        body: FutureBuilder<List<Map<String, String>>>(
          future: fetchBlogs(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                      color: Colors.deepPurpleAccent));
            }
            if (snapshot.hasError) {
              return Center(
                  child: Text('Error loading blogs',
                      style: TextStyle(color: Colors.redAccent)));
            }
            final blogPosts = snapshot.data ?? [];
            return ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(16),
              itemCount: blogPosts.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => Details(
                        title: blogPosts[index]['title']!,
                        date: blogPosts[index]['date']!,
                        imagePath: blogPosts[index]['image']!,
                        descriptions: blogPosts[index]['descriptions']!,
                      ),
                    ),
                  ),
                  child: BlogCard(
                    displayName: displayName,
                    title: blogPosts[index]['title']!,
                    date: blogPosts[index]['date']!,
                    imagePath: blogPosts[index]['image']!,
                    descriptions: blogPosts[index]['descriptions']!,
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var res = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateBlogScreen()),
            );
            if (res == true) {
              setState(() {});
            }
          },
          child: Icon(Icons.add, size: 28, color: Colors.white),
          backgroundColor: Colors.deepPurpleAccent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ));
  }
}

class BlogCard extends StatelessWidget {
  final String title;
  final String date;
  final String imagePath;
  final String descriptions;
  final String displayName;

  BlogCard(
      {required this.title,
      required this.date,
      required this.imagePath,
      required this.descriptions,
      required this.displayName});

  String formatDate(String dateString) {
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 6,
      shadowColor: Colors.black45,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(imagePath,
                fit: BoxFit.cover, width: double.infinity, height: 180),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple),
                ),
                SizedBox(height: 5),
                Text(
                  'Published Date: ${formatDate(date)}',
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: Colors.grey[600]),
                ),
                SizedBox(height: 8),
                Text(
                  descriptions,
                  style: GoogleFonts.poppins(
                      fontSize: 14, color: Colors.grey[800]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CreateBlogScreen extends StatefulWidget {
  @override
  _CreateBlogScreenState createState() => _CreateBlogScreenState();
}

class _CreateBlogScreenState extends State<CreateBlogScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  Future<void> saveBlog(BuildContext context) async {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Title and description are required!')));
      return;
    }

    FirebaseFirestore.instance.collection('blogs').add({
      'title': titleController.text,
      'datetime': DateTime.now().toIso8601String(),
      'image': imageController.text.isEmpty
          ? 'https://salonlfc.com/wp-content/uploads/2018/01/image-not-found-scaled.png'
          : imageController.text,
      'descriptions': descriptionController.text,
    });

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Blog', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                    labelText: 'Title', border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),
              TextField(
                controller: imageController,
                decoration: InputDecoration(
                    labelText: 'Image URL', border: OutlineInputBorder()),
              ),
              Text(
                'หมายเหตุ ต้องเป็นลิงค์รูป http or https',
                style: TextStyle(color: Colors.redAccent),
              ),
              SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                    labelText: 'Description', border: OutlineInputBorder()),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => saveBlog(context),
                child: Text('Save Blog', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
