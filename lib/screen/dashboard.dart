import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BlogFeedScreen extends StatefulWidget {
  @override
  State<BlogFeedScreen> createState() => _BlogFeedScreenState();
}

class _BlogFeedScreenState extends State<BlogFeedScreen> {
  Future<List<Map<String, String>>> fetchBlogs() async {
    print('data PEACE');
    setState(() {});
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('blogs').get();
      print('จำนวนเอกสารใน Firestore: ${snapshot.docs.length}');
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>? ?? {};
        print(data['image']?.toString());
        return {
          'title': data['title']?.toString() ?? 'No Title',
          'date': data['datetime']?.toString() ?? 'No Date',
          'image': data['image']?.toString() ?? '',
          'descriptions': data['descriptions']?.toString() ?? '',
        };
      }).toList();
    } catch (e) {
      print('Error fetching data: $e');
      return []; // หรือ throw error หากต้องการให้เกิดการแจ้งเตือน
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medium Blog Feed'),
        backgroundColor: const Color.fromARGB(255, 246, 246, 246),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: fetchBlogs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading blogs'));
          }
          final blogPosts = snapshot.data ?? [];
          return ListView.builder(
            itemCount: blogPosts.length,
            itemBuilder: (context, index) {
              print('date ${blogPosts[index]['date']!}');

              return BlogCard(
                title: blogPosts[index]['title']!,
                date: blogPosts[index]['date']!,
                imagePath: blogPosts[index]['image']!,
                descriptions: blogPosts[index]['descriptions']!,
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
          print(res);
          if (res == true) {
            await fetchBlogs();
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class BlogCard extends StatefulWidget {
  final String title;
  final String date;
  final String imagePath;
  final String descriptions;

  BlogCard(
      {required this.title,
      required this.date,
      required this.imagePath,
      required this.descriptions});

  @override
  State<BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogCard> {
  String formatDate(String dateString) {
    try {
      DateTime dateTime = DateTime.parse(dateString);
      print('ยัยบ้า $dateString');
      print('ยัยบ้า2 $dateTime');
      return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.network(widget.imagePath,
                fit: BoxFit.cover, width: double.infinity, height: 150),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'Published Date: ${formatDate(widget.date)}',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  widget.title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.descriptions,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
  class CreateBlogScreen extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController imageController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  void saveBlog() {
    DateTime now = DateTime.now();

    String dateString =
        now.toIso8601String(); 
    FirebaseFirestore.instance.collection('blogs').add({
      'title': titleController.text,
      'datetime': dateString,
      'image': imageController.text,
      'descriptions': descriptionController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Blog')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title')),
            TextField(
                controller: imageController,
                decoration: InputDecoration(labelText: 'Image URL')),
            TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                saveBlog();
                Navigator.pop(context, true);
              },
              child: Text('Save Blog'),
            ),
          ],
        ),
      ),
    );
  }
}
