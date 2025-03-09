import 'package:flutter/material.dart';
import 'package:quackacademy/screens/home_page.dart';
import 'package:quackacademy/screens/learn_page.dart';
import 'package:quackacademy/screens/leaderboard_page.dart';
import 'package:quackacademy/screens/profile_page.dart';

class MainNavigator extends StatefulWidget {
  final int initialIndex;
  const MainNavigator({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  _MainNavigatorState createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  late int _currentIndex;

  final List<Widget> _pages = [
    HomePage(),
    LearnPage(),
    LeaderboardPage(
    isTeacher: false,
    currentPlayerId: 'defaultUserID', // Replace with a valid user ID
    quizId: 'defaultQuizID',         // Replace with a valid quiz ID
     ),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A3A5F),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF1A3A5F),
          unselectedItemColor: Colors.black54,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: TextStyle(fontSize: 12),
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/Home.png',
                width: 24,
                height: 24,
                color: _currentIndex == 0 ? Color(0xFF1A3A5F) : Colors.black54,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/Courses.png',
                width: 24,
                height: 24,
                color: _currentIndex == 1 ? Color(0xFF1A3A5F) : Colors.black54,
              ),
              label: "Learn",
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/Leaderboard.png',
                width: 24,
                height: 24,
                color: _currentIndex == 2 ? Color(0xFF1A3A5F) : Colors.black54,
              ),
              label: "Leaderboard",
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/Profile.png',
                width: 24,
                height: 24,
                color: _currentIndex == 3 ? Color(0xFF1A3A5F) : Colors.black54,
              ),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
