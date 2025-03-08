

import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}
class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.create),
              title: const Text('Create'),
              onTap: () {
                Navigator.pushNamed(context, 'create');
              },
            ),
            ListTile(
              leading: const Icon(Icons.update),
              title: const Text('Update'),
              onTap: () {
                Navigator.pushNamed(context, 'update');
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delate'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.video_call),
              title: const Text('Video'),
              onTap: () {
                Navigator.pushNamed(context, 'videoyoutube');
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_box_outlined),
              title: const Text('Add Realtime Database'),
              onTap: () {
                Navigator.pushNamed(context, 'addrealtime');
              },
            ),
            ListTile(
              leading: const Icon(Icons.storage),
              title: const Text('Show IOT Realtime'),
              onTap: () {
                Navigator.pushNamed(context, 'showiot');
              },
            ),
          ],
        ),
      ),
    );
  }
}
