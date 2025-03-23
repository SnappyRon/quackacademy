import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quackacademy/screens/home_page.dart';
import 'package:quackacademy/screens/learn_page.dart';
import 'package:quackacademy/screens/leaderboard_page.dart';
import 'package:quackacademy/screens/profile_page.dart';

// Riverpod StateProvider for the current bottom tab index.
final currentTabIndexProvider = StateProvider<int>((ref) => 0);

class MainNavigator extends ConsumerStatefulWidget {
  final String gameCode;
  final int initialIndex;
  const MainNavigator({Key? key, required this.gameCode, this.initialIndex = 0})
      : super(key: key);

  @override
  ConsumerState<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends ConsumerState<MainNavigator> {
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // Initialize the provider's state using the widget's initial index.
    ref.read(currentTabIndexProvider.notifier).state = widget.initialIndex;

    // Create the pages list, ensuring widget.gameCode is available.
    _pages = [
      HomePage(),
      LearnPage(),
      LeaderboardPage(
        isTeacher: false,
        currentPlayerId: 'defaultUserID', // Replace with a valid user ID
        quizId: 'defaultQuizID',          // Replace with a valid quiz ID if needed
        gameCode: widget.gameCode,
      ),
      ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Watch the current tab index from Riverpod.
    final currentIndex = ref.watch(currentTabIndexProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF1A3A5F),
      body: IndexedStack(
        index: currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF1A3A5F),
          unselectedItemColor: Colors.black54,
          selectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            // Update the provider state when a tab is tapped.
            ref.read(currentTabIndexProvider.notifier).state = index;
          },
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/Home.png',
                width: 24,
                height: 24,
                color: currentIndex == 0
                    ? const Color(0xFF1A3A5F)
                    : Colors.black54,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/Courses.png',
                width: 24,
                height: 24,
                color: currentIndex == 1
                    ? const Color(0xFF1A3A5F)
                    : Colors.black54,
              ),
              label: "Learn",
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/Leaderboard.png',
                width: 24,
                height: 24,
                color: currentIndex == 2
                    ? const Color(0xFF1A3A5F)
                    : Colors.black54,
              ),
              label: "Leaderboard",
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/Profile.png',
                width: 24,
                height: 24,
                color: currentIndex == 3
                    ? const Color(0xFF1A3A5F)
                    : Colors.black54,
              ),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
