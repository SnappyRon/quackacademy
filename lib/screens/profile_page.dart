import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider to fetch current user profile data from Firestore.
final profileDataProvider = StreamProvider<Map<String, dynamic>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map((doc) => doc.data() ?? {});
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
  }

  Future<void> setProfileImage(String path) async {
    state = path;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileImagePath', path);
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
        final fullName = data['fullName'] ?? "Full Name";
        final nickname = data['nickname'] ?? "NICKNAME";
        final email = data['email'] ?? (user?.email ?? "");
        final birthDate = data['birthDate'] ?? "";
        final role = data['role'] ?? "student";

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
                            // Profile Picture with tap to pick a new image.
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
                            // Settings Icon
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
                            // Dropdown Settings Menu
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
                                        onPressed: () async {
                                          await Navigator.of(context,
                                                  rootNavigator: false)
                                              .pushNamed('/information');
                                          // Provider will update data on changes.
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          side: const BorderSide(
                                              color: Colors.black),
                                        ),
                                        child: const Text("Information",
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ),
                                      const SizedBox(height: 8),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context,
                                                  rootNavigator: false)
                                              .pushNamed('/password');
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          side: const BorderSide(
                                              color: Colors.black),
                                        ),
                                        child: const Text("Password",
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            // Nickname, Level, and Role
                            Positioned(
                              bottom: 80,
                              left: 16,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        nickname,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Text(
                                        "17", // Replace with dynamic level if needed.
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
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
                            ),
                            // Stats Section
                            Positioned(
                              bottom: 0,
                              left: 16,
                              right: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
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
                        const SizedBox(height: 20),
                        _buildStreakSection(),
                        const SizedBox(height: 20),
                        _buildRecentCourse(),
                        const SizedBox(height: 20),
                        _buildCertificates(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                // Logout Button
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context, rootNavigator: true)
                          .pushReplacementNamed('/login');
                    },
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => Scaffold(
        backgroundColor: const Color(0xFF1A3A5F),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        backgroundColor: const Color(0xFF1A3A5F),
        body: Center(child: Text("Error loading profile: $error")),
      ),
    );
  }

  Widget _buildStats(String label, String value) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
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
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(dayLabels.length, (index) {
              bool isToday =
                  (index == dayIndex && dayIndex >= 0 && dayIndex < 5);
              return Column(
                children: [
                  CircleAvatar(
                    backgroundColor:
                        isToday ? Colors.orange : Colors.grey,
                    radius: 14,
                    child: Icon(
                      isToday ? Icons.check : Icons.circle_outlined,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(dayLabels[index],
                      style: const TextStyle(fontSize: 12)),
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
        color: Colors.orange,
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
              Image.asset('assets/images/java.png',
                  width: 40, height: 40),
              const SizedBox(width: 12),
              const Text("Java Programming",
                  style: TextStyle(
                      color: Colors.black, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCertificates() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Certificates",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          const SizedBox(height: 12),
          Row(
            children: [
              Image.asset('assets/images/certificate.png',
                  width: 40, height: 40),
              const SizedBox(width: 12),
              const Text("Java Mastery",
                  style: TextStyle(
                      color: Colors.black, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}
