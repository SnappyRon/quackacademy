import 'package:flutter/material.dart';

class LeaderboardPage extends StatelessWidget {
  final List<Map<String, dynamic>> players = [
    {
      "rank": 1,
      "name": "Curry",
      "score": "95%",
      "image": "assets/images/Student1.png",
    },
    {
      "rank": 2,
      "name": "Lebron",
      "score": "85%",
      "image": "assets/images/Student2.png",
    },
    {
      "rank": 3,
      "name": "Luka",
      "score": "85%",
      "image": "assets/images/Student3.png",
    },
    {
      "rank": 4,
      "name": "Durant",
      "score": "85%",
      "image": "assets/images/Student4.png",
    },
    {
      "rank": 5,
      "name": "Irving",
      "score": "85%",
      "image": "assets/images/Student2.png",
    },
    {
      "rank": 6,
      "name": "Giannis",
      "score": "85%",
      "image": "assets/images/Student3.png",
    },
    {
      "rank": 7,
      "name": "Davis",
      "score": "85%",
      "image": "assets/images/Student4.png",
    },
    {
      "rank": 8,
      "name": "Tatum",
      "score": "85%",
      "image": "assets/images/Student1.png",
    },
    {
      "rank": 9,
      "name": "Edward",
      "score": "85%",
      "image": "assets/images/Student3.png",
    },
    {
      "rank": 10,
      "name": "Thompson",
      "score": "85%",
      "image": "assets/images/Student4.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A3A5F),
      body: SafeArea(
        child: Column(
          children: [
            _buildBackButton(context),
            _buildLogoSection(),
            SizedBox(height: 10),
            _buildLeaderboardTable(),
          ],
        ),
      ),
    );
  }

  /// ✅ Back Button (Top-Left)
  Widget _buildBackButton(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: Text(
            "Back",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  /// ✅ Logo and Title
  Widget _buildLogoSection() {
    return Column(
      children: [
        Image.asset(
          'assets/images/duck_logo.png', // Ensure this asset exists
          width: 80,
        ),
        SizedBox(height: 5),
        Text(
          "QUACKACADEMY",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          "LEADERBOARDS",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  /// ✅ Leaderboard Table
  Widget _buildLeaderboardTable() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildTableHeader(),
              Expanded(
                child: ListView.builder(
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    final player = players[index];
                    final isTopPlayer = player["rank"] == 1;

                    return Container(
                      decoration: BoxDecoration(
                        color: isTopPlayer ? Colors.blue[100] : Colors.white,
                        borderRadius: isTopPlayer ? BorderRadius.circular(8) : BorderRadius.zero,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(player["image"]),
                          radius: 20,
                          onBackgroundImageError: (_, __) => Icon(Icons.error, color: Colors.red),
                        ),
                        title: Row(
                          children: [
                            SizedBox(
                              width: 30,
                              child: Text(
                                "${player["rank"]}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                player["name"],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isTopPlayer ? Colors.blue : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isTopPlayer ? Colors.blue : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: Text(
                            player["score"],
                            style: TextStyle(
                              color: isTopPlayer ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ✅ Table Header Row
  Widget _buildTableHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Text("Players", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 35),
          Text("Rank", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 35),
          Expanded(child: Text("Name", style: TextStyle(fontWeight: FontWeight.bold))),
          Text("Ave", style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
