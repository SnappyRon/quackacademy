import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quackacademy/main.dart';
import 'package:quackacademy/screens/home_page.dart';
import 'package:quackacademy/screens/login_page.dart';
import 'package:quackacademy/screens/signup_page.dart';
import 'package:quackacademy/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider to fetch current user profile data from Firestore.
final profileDataProvider = StreamProvider<Map<String, dynamic>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  print("profileDataProvider: current user: $user");
  if (user != null) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .handleError((error) {
      print("profileDataProvider error: $error");
    }).map((doc) {
      print("profileDataProvider snapshot: ${doc.data()}");
      return doc.data() ?? {};
    });
  }
  return Stream.value({});
});

/// StateNotifier to manage the profile image path.
class ProfileImageNotifier extends StateNotifier<String> {
  ProfileImageNotifier() : super("") {
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString('profileImagePath') ?? "";
    print("ProfileImageNotifier: Loaded profileImagePath: $state");
  }

  Future<void> setProfileImage(String path) async {
    state = path;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileImagePath', path);
    print("ProfileImageNotifier: Set profileImagePath: $path");
  }
}

/// Provider for profile image.
final profileImageProvider =
    StateNotifierProvider<ProfileImageNotifier, String>((ref) {
  return ProfileImageNotifier();
});

/// Provider to manage settings menu toggle.
final showSettingsMenuProvider = StateProvider<bool>((ref) => false);

class ProfilePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final profileDataAsync = ref.watch(profileDataProvider);
    final profileImagePath = ref.watch(profileImageProvider);
    final showSettingsMenu = ref.watch(showSettingsMenuProvider);

    return profileDataAsync.when(
      data: (data) {
        // Required keys check
        final requiredKeys = [
          'firstName',
          'lastName',
          'username',
          'email',
          'role',
          'level',
          'exp',
        ];
        final allKeysPresent =
            requiredKeys.every((key) => data.containsKey(key));
        if (!allKeysPresent) {
          return Scaffold(
            backgroundColor: const Color(0xFF1A3A5F),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final firstName = data['firstName'] ?? "";
        final lastName = data['lastName'] ?? "";
        final fullName = (firstName.isNotEmpty || lastName.isNotEmpty)
            ? "$firstName $lastName".trim()
            : "";
        final username = data['username'] ?? "USERNAME";
        final email = data['email'] ?? (user?.email ?? "");
        final role = data['role'] ?? "student";
        final level = (data['level'] ?? 1);
        final exp = (data['exp'] ?? 0);

        if (role.toLowerCase() == 'teacher') {
          return _buildTeacherProfile(
              context, ref, fullName, username, role, user!.uid);
        } else {
          return Scaffold(
            backgroundColor: const Color(0xFF1A3A5F),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final picker = ImagePicker();
                                  final pickedFile = await picker.pickImage(
                                      source: ImageSource.gallery);
                                  if (pickedFile != null) {
                                    ref
                                        .read(profileImageProvider.notifier)
                                        .setProfileImage(pickedFile.path);
                                  }
                                },
                                child: Container(
                                  height: 250,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(30),
                                      bottomRight: Radius.circular(30),
                                    ),
                                    image: DecorationImage(
                                      image: profileImagePath.isNotEmpty
                                          ? FileImage(File(profileImagePath))
                                          : const AssetImage(
                                                  'assets/images/Userprofile.png')
                                              as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 16,
                                right: 16,
                                child: GestureDetector(
                                  onTap: () {
                                    ref
                                        .read(showSettingsMenuProvider.notifier)
                                        .state = !showSettingsMenu;
                                  },
                                  child: Image.asset(
                                    'assets/images/settings.png',
                                    width: 30,
                                    height: 30,
                                  ),
                                ),
                              ),
                              if (showSettingsMenu)
                                Positioned(
                                  top: 50,
                                  right: 16,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushNamed('/information');
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            side: const BorderSide(
                                                color: Colors.black),
                                          ),
                                          child: const Text("Information",
                                              style: TextStyle(
                                                  color: Colors.black)),
                                        ),
                                        const SizedBox(height: 8),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushNamed('/password');
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            side: const BorderSide(
                                                color: Colors.black),
                                          ),
                                          child: const Text("Password",
                                              style: TextStyle(
                                                  color: Colors.black)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              Positioned(
                                bottom: 80,
                                left: 16,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      fullName.isNotEmpty ? fullName : username,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          "Level: $level",
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          role.toUpperCase(),
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 16,
                                right: 16,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      _buildStats("Course", "4"),
                                      _buildStats("EXP", "$exp"),
                                      _buildStats("Level", "$level"),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildStreakSection(),
                          const SizedBox(height: 20),
                          _buildRecentCourse(),
                          const SizedBox(height: 20),
                          _buildCertificates(level),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 24),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
                        await AuthService().signOut();
                        if (!context.mounted) return;
                        ref
                          ..invalidate(authStateChangesProvider)
                          ..invalidate(userDataProvider)
                          ..invalidate(profileDataProvider)
                          ..invalidate(signUpLoadingProvider)
                          ..invalidate(loginLoadingProvider);
                        Navigator.of(context, rootNavigator: true)
                            .pushNamedAndRemoveUntil(
                                '/login', (route) => false);
                      },
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text("Logout",
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
      loading: () => Scaffold(
        backgroundColor: const Color(0xFF1A3A5F),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        backgroundColor: const Color(0xFF1A3A5F),
        body: Center(child: Text("Error loading profile: $error")),
      ),
    );
  }

  Widget _buildStats(String label, String value) => Column(
        children: [
          Text(label,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
        ],
      );
}

Widget _buildStreakSection() {
  final dayLabels = ["M", "T", "W", "TH", "F"];
  final currentWeekday = DateTime.now().weekday;
  final dayIndex = currentWeekday - 1;
  return Container(
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.grey[300],
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Streak",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(dayLabels.length, (index) {
            bool isToday = (index == dayIndex && dayIndex >= 0 && dayIndex < 5);
            return Column(
              children: [
                CircleAvatar(
                  backgroundColor: isToday ? Colors.white : Colors.grey,
                  radius: 14,
                  child: Icon(
                    isToday ? Icons.check : Icons.circle_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(dayLabels[index], style: const TextStyle(fontSize: 12)),
              ],
            );
          }),
        ),
      ],
    ),
  );
}

Widget _buildRecentCourse() {
  return Container(
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Recent Course",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
        const SizedBox(height: 12),
        Row(
          children: [
            Image.asset('assets/images/java.png', width: 40, height: 40),
            const SizedBox(width: 12),
            const Text("Java Programming",
                style: TextStyle(color: Colors.black, fontSize: 14)),
          ],
        ),
      ],
    ),
  );
}

Widget _buildCertificates(int userLevel) {
  bool isUnlocked = userLevel >= 10;

  return Container(
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              "Certificates",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 10),
            if (!isUnlocked)
              const Icon(Icons.lock, color: Colors.grey, size: 18),
          ],
        ),
        const SizedBox(height: 12),
        Opacity(
          opacity: isUnlocked ? 1.0 : 0.4,
          child: Row(
            children: [
              Image.asset('assets/images/certificate.png',
                  width: 40, height: 40),
              const SizedBox(width: 12),
              Text(
                "Java Mastery",
                style: const TextStyle(color: Colors.black, fontSize: 14),
              ),
            ],
          ),
        ),
        if (!isUnlocked)
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              "Unlocks at Level 10",
              style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 13,
                  fontWeight: FontWeight.bold),
            ),
          ),
      ],
    ),
  );
}

Widget _buildTeacherProfile(
  BuildContext context,
  WidgetRef ref,
  String fullName,
  String username,
  String role,
  String uid,
) {
  final showSettingsMenu = ref.watch(showSettingsMenuProvider);

  return Scaffold(
    backgroundColor: const Color(0xFF1A3A5F),
    body: SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Header Row with Name + Settings Icon
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fullName.isNotEmpty ? fullName : username,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text("Role: ${role.toUpperCase()}",
                                style: const TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          ref.read(showSettingsMenuProvider.notifier).state =
                              !showSettingsMenu;
                        },
                        child: Image.asset(
                          'assets/images/settings.png',
                          width: 28,
                          height: 28,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Stats Section
                buildDynamicStats(uid),

                const SizedBox(height: 20),
                _buildAchievements(),
                const SizedBox(height: 20),
                _buildYourCourses(uid),
                const SizedBox(height: 20),

                // Logout Button
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 24),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      await AuthService().signOut();
                      if (!context.mounted) return;
                      ref
                        ..invalidate(authStateChangesProvider)
                        ..invalidate(userDataProvider)
                        ..invalidate(profileDataProvider)
                        ..invalidate(signUpLoadingProvider)
                        ..invalidate(loginLoadingProvider);
                      Navigator.of(context, rootNavigator: true)
                          .pushNamedAndRemoveUntil('/login', (route) => false);
                    },
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text("Logout",
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),

          // Settings Menu Overlay
          if (showSettingsMenu)
            Positioned(
              top: 50,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/information');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.black),
                      ),
                      child: const Text("Information",
                          style: TextStyle(color: Colors.black)),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/password');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.black),
                      ),
                      child: const Text("Password",
                          style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

Widget _buildStudentProfile(
  BuildContext context,
  WidgetRef ref,
  String fullName,
  String username,
  String role,
  int level,
  int exp,
) {
  return Scaffold(
    backgroundColor: const Color(0xFF1A3A5F),
    body: SafeArea(
      child: Column(
        children: [
          // 👇 Use your existing student UI code here!
          // I recommend copy/pasting everything you already had here before we did role checking
        ],
      ),
    ),
  );
}

Widget _buildAchievements() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Achievements",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: const [
            _Badge(title: "First Course Published", unlocked: true),
            _Badge(title: "100 Students Enrolled", unlocked: true),
            _Badge(title: "Top Rated Instructor", unlocked: true),
            _Badge(title: "500 Students Enrolled", unlocked: false),
            _Badge(title: "10 Courses Created", unlocked: false),
          ],
        )
      ],
    ),
  );
}

class _Badge extends StatelessWidget {
  final String title;
  final bool unlocked;

  const _Badge({required this.title, required this.unlocked});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(unlocked ? Icons.verified : Icons.lock,
            color: unlocked ? Colors.green : Colors.grey),
        const SizedBox(width: 6),
        Text(title,
            style: TextStyle(
              color: unlocked ? Colors.black : Colors.grey,
              fontWeight: FontWeight.w500,
            )),
      ],
    );
  }
}

Widget _buildYourCourses(String teacherUid) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('courses')
        .where('createdBy', isEqualTo: teacherUid)
        .snapshots(),
    builder: (context, snapshot) {
      final isLoading = snapshot.connectionState == ConnectionState.waiting;
      final docs = snapshot.data?.docs ?? [];

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Courses",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            if (isLoading) const Center(child: CircularProgressIndicator()),
            if (!isLoading && docs.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  children: const [
                    Icon(Icons.info_outline, size: 20, color: Colors.grey),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "You haven't created any courses yet.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            for (final doc in docs)
              _buildCourseCard(
                context,
                doc.id,
                doc['title'] ?? 'Untitled',
                (doc['learners'] ?? []).length,
              ),
          ],
        ),
      );
    },
  );
}

Widget _buildCourseCard(
    BuildContext context, String courseId, String title, int enrolled) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Text("Enrolled: $enrolled"),
          ],
        ),
        ElevatedButton(
          onPressed: () => _showEnrolledLearners(courseId, title, context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF476F95),
            foregroundColor: Colors.white,
            minimumSize: const Size(100, 40),
          ),
          child: const Text("View Learners"),
        ),
      ],
    ),
  );
}

void _showEnrolledLearners(
    String courseId, String courseTitle, BuildContext context) async {
  final courseDoc = await FirebaseFirestore.instance
      .collection('courses')
      .doc(courseId)
      .get();

  final learnerIds = List<String>.from(courseDoc['learners'] ?? []);
  List<Map<String, dynamic>> learnerProfiles = [];

  for (final uid in learnerIds) {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDoc.exists) {
      learnerProfiles.add(userDoc.data()!);
    }
  }

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text("Learners in $courseTitle"),
      content: SizedBox(
        width: double.maxFinite,
        child: learnerProfiles.isEmpty
            ? const Text("No learners enrolled yet.")
            : ListView.builder(
                shrinkWrap: true,
                itemCount: learnerProfiles.length,
                itemBuilder: (context, index) {
                  final learner = learnerProfiles[index];
                  final username = learner['username'] ?? 'No Name';
                  final email = learner['email'] ?? 'No Email';

                  return ListTile(
                    leading: Text("${index + 1}.",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    title: Text(username),
                    subtitle: Text(email),
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        )
      ],
    ),
  );
}

Widget _buildStats(String label, String value) => Column(
      children: [
        Text(label,
            style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
      ],
    );
Widget buildDynamicStats(String teacherUid) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('courses')
        .where('createdBy', isEqualTo: teacherUid)
        .snapshots(),
    builder: (context, snapshot) {
      final isLoading = snapshot.connectionState == ConnectionState.waiting;

      if (isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      final docs = snapshot.data?.docs ?? [];

      final totalCourses = docs.length;
      final totalLearners = docs.fold<int>(0, (sum, doc) {
        final learners = (doc['learners'] ?? []) as List;
        return sum + learners.length;
      });

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStats("Courses Created", "$totalCourses"),
            _buildStats("Learners Enrolled", "$totalLearners"),
          ],
        ),
      );
    },
  );
}
