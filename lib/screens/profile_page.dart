import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  bool _showSettingsMenu = false;

  String _fullName = "Full Name";
  String _nickname = "NICKNAME";
  String _email = "";
  String _birthDate = "";
  /// ✅ New: role
  String _role = "student";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            _fullName = userDoc['fullName'] ?? 'Full Name';
            _nickname = userDoc['nickname'] ?? 'NICKNAME';
            _email = userDoc['email'] ?? user!.email!;
            _birthDate = userDoc['birthDate'] ?? 'N/A';
            _role = userDoc['role'] ?? 'student'; // <-- fetch role
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetching user data: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _navigateToInformation() async {
    await Navigator.of(context, rootNavigator: false).pushNamed('/information');
    _fetchUserData(); // Refresh data after returning
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A3A5F),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        /// Profile Picture
                        Container(
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                            image: DecorationImage(
                              image: AssetImage('assets/images/Userprofile.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        /// Settings Icon with Dropdown
                        Positioned(
                          top: 16,
                          right: 16,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _showSettingsMenu = !_showSettingsMenu;
                              });
                            },
                            child: Image.asset(
                              'assets/images/settings.png',
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ),

                        /// Dropdown Settings Menu
                        if (_showSettingsMenu)
                          Positioned(
                            top: 50,
                            right: 16,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: _navigateToInformation,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      side: BorderSide(color: Colors.black),
                                    ),
                                    child: Text("Information", style: TextStyle(color: Colors.black)),
                                  ),
                                  SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: false).pushNamed('/password');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      side: BorderSide(color: Colors.black),
                                    ),
                                    child: Text("Password", style: TextStyle(color: Colors.black)),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        /// Nickname, ID, and Role
                        Positioned(
                          bottom: 80,
                          left: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    _nickname,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    "17", // Replace with dynamic level if needed
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              /// ✅ Display Role below Nickname
                              SizedBox(height: 4),
                              Text(
                                _role.toUpperCase(), // e.g. STUDENT or TEACHER
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// Stats (Course, Rank, Level)
                        Positioned(
                          bottom: 0,
                          left: 16,
                          right: 16,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStats("Course", "4"),
                                _buildStats("Rank", "1"),
                                _buildStats("Level", "30"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),
                    _buildStreakSection(),
                    SizedBox(height: 20),
                    _buildAverageSection(),
                    SizedBox(height: 20),
                    _buildRecentCourse(),
                    SizedBox(height: 20),
                    _buildCertificates(),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            /// Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context, rootNavigator: true).pushReplacementNamed('/login');
                },
                icon: Icon(Icons.logout, color: Colors.white),
                label: Text(
                  "Logout",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Stats Box
  Widget _buildStats(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14)),
        SizedBox(height: 4),
        Text(value, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _buildStreakSection() {
    List<String> days = ["M", "T", "W", "TH", "F", "SAT", "SUN"];
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Streak", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: days.map((day) {
              return Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.orange,
                    radius: 14,
                    child: Icon(Icons.check, color: Colors.white, size: 16),
                  ),
                  SizedBox(height: 4),
                  Text(day, style: TextStyle(fontSize: 12)),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAverageSection() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Average", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 8),
          LinearProgressIndicator(
            value: 0.65,
            backgroundColor: Colors.white,
            color: Colors.yellow,
            minHeight: 10,
          ),
          SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text("65%", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentCourse() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Recent Course", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 12),
          Row(
            children: [
              Image.asset('assets/images/java.png', width: 40, height: 40),
              SizedBox(width: 12),
              Text("Java Programming", style: TextStyle(color: Colors.black, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCertificates() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Certificates", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 12),
          Row(
            children: [
              Image.asset('assets/images/certificate.png', width: 40, height: 40),
              SizedBox(width: 12),
              Text("Java Mastery", style: TextStyle(color: Colors.black, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}
