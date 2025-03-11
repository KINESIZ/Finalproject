import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Miniproject/screen/details.dart';
import 'package:Miniproject/screen/home.dart';

class BlogFeedScreen extends StatefulWidget {
  @override
  State<BlogFeedScreen> createState() => _BlogFeedScreenState();
}

class _BlogFeedScreenState extends State<BlogFeedScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String displayName = "";

  void checkAdmin() {
    final User? user = auth.currentUser;
    if (user != null) {
      displayName = user.displayName ?? user.email ?? "Unknown User";
    } else {
      displayName = "Unknown User";
    }
    setState(() {});
  }

  Future<List<Map<String, dynamic>>> fetchBlogs() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('blogs')
          .orderBy('datetime', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>? ?? {};
        return {
          'id': doc.id,
          'title': data['title'] ?? 'No Title',
          'date': data['datetime'] != null
              ? DateTime.tryParse(data['datetime'].toString())
                      ?.toIso8601String() ??
                  'No Date'
              : 'No Date',
          'image': data['image'] ?? '',
          'descriptions': data['descriptions'] ?? '',
        };
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> deleteBlog(String id) async {
    try {
      await FirebaseFirestore.instance.collection('blogs').doc(id).delete();
      setState(() {}); // รีเฟรชหน้าหลังลบข้อมูล
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting blog: $e')),
      );
    }
  }

  void refreshPage() {
    setState(() {}); // รีเฟรชหน้าจอโดยโหลดข้อมูลใหม่
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
    super.initState();
    checkAdmin();
  }

  Widget menuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
      onTap: onTap,
      tileColor: Colors.black26, // สีพื้นหลังของแต่ละเมนู
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: AppBar(
            title: Text(
              'Blog Feed',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Colors.white,
              ),
            ),
            backgroundColor:
                Colors.transparent, // ต้องใช้ transparent ให้ Gradient ทำงาน
            elevation: 0, // ปิดเงา AppBar ปกติ ใช้ boxShadow แทน
            actions: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: () {
                  refreshPage(); // เรียกใช้ฟังก์ชันรีเฟรช
                },
              )
            ],
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchBlogs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child:
                    CircularProgressIndicator(color: Colors.deepPurpleAccent));
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
                  id: blogPosts[index]['id']!,
                  displayName: displayName,
                  title: blogPosts[index]['title']!,
                  date: blogPosts[index]['date']!,
                  imagePath: blogPosts[index]['image']!,
                  descriptions: blogPosts[index]['descriptions']!,
                  onDelete: deleteBlog,
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade900, Colors.blue.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.blueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.menu, color: Colors.white, size: 40),
                    SizedBox(height: 10),
                    Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black45,
                            blurRadius: 5,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              menuItem(Icons.people, 'Profile', () {
                Navigator.pushNamed(context, 'profile');
              }),
              
              menuItem(Icons.logout_sharp, 'Logout', () {
                logout();
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class BlogCard extends StatefulWidget {
  final String id;
  final String title;
  final String date;
  final String imagePath;
  final String descriptions;
  final String displayName;
  final Function(String) onDelete; // กำหนด type ให้ถูกต้อง

  BlogCard({
    required this.id,
    required this.title,
    required this.date,
    required this.imagePath,
    required this.descriptions,
    required this.displayName,
    required this.onDelete, // ใช้เป็น callback function
  });

  @override
  _BlogCardState createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogCard> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isLiked = false;
  int likeCount = 0;

  @override
  void initState() {
    super.initState();
    fetchLikeStatus();
  }

  Future<void> fetchLikeStatus() async {
    final user = auth.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('blogs')
        .doc(widget.id)
        .get();

    final data = doc.data();
    if (data != null && data.containsKey('likes')) {
      final likes = Map<String, dynamic>.from(data['likes']);
      setState(() {
        isLiked = likes.containsKey(user.uid);
        likeCount = likes.length;
      });
    }
  }

  Future<void> toggleLike() async {
    final user = auth.currentUser;
    if (user == null) return;

    final docRef =
        FirebaseFirestore.instance.collection('blogs').doc(widget.id);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) return;

      final data = snapshot.data()!;
      final likes = Map<String, dynamic>.from(data['likes'] ?? {});

      if (likes.containsKey(user.uid)) {
        likes.remove(user.uid); // Unlike
      } else {
        likes[user.uid] = true; // Like
      }

      transaction.update(docRef, {'likes': likes});
    });

    fetchLikeStatus(); // รีเฟรชค่า Like
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 10,
      shadowColor: Colors.black45,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(widget.imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 180, errorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                height: 180,
                color: Colors.grey[300],
                child: Icon(Icons.image_not_supported, color: Colors.grey[600]),
              );
            }),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5),
                Text(
                  'Published Date: ${DateFormat('dd MMM yyyy, HH:mm').format(DateTime.parse(widget.date))}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  widget.descriptions,
                  style: GoogleFonts.poppins(
                      fontSize: 14, color: Colors.grey[800]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : Colors.grey,
                          ),
                          onPressed: toggleLike,
                        ),
                        Text(
                          likeCount.toString(),
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Confirm Delete"),
                              content: Text("คุณต้องการลบบทความนี้หรือไม่?"),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(), // ปิดป๊อปอัป
                                  child: Text("ยกเลิก"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    widget.onDelete(widget.id); // ลบบทความ
                                    Navigator.of(context).pop(); // ปิดป๊อปอัป
                                  },
                                  child: Text("ยืนยัน",
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                )
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
        SnackBar(content: Text('Title and description are required!')),
      );
      return;
    }

    String userName =
        FirebaseAuth.instance.currentUser?.displayName ?? 'Anonymous';

    await FirebaseFirestore.instance.collection('blogs').add({
      'title': titleController.text,
      'datetime': DateTime.now().toIso8601String(),
      'image': imageController.text.isEmpty
          ? 'https://salonlfc.com/wp-content/uploads/2018/01/image-not-found-scaled.png'
          : imageController.text,
      'descriptions': descriptionController.text,
      'author': userName, // เพิ่มชื่อผู้เขียน
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
                'หมายเหตุ: ต้องเป็นลิงก์รูป (http หรือ https)',
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
                onPressed: () {
                  FocusScope.of(context).unfocus(); // ปิดคีย์บอร์ดก่อนบันทึก
                  saveBlog(context);
                },
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
