import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SetupQuizPage extends StatefulWidget {
  @override
  _SetupQuizPageState createState() => _SetupQuizPageState();
}

class _SetupQuizPageState extends State<SetupQuizPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Controllers
  final TextEditingController _quizTitleController = TextEditingController();
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answer1Controller = TextEditingController();
  final TextEditingController _answer2Controller = TextEditingController();
  final TextEditingController _answer3Controller = TextEditingController();
  final TextEditingController _answer4Controller = TextEditingController();

  /// Slides data
  final List<Map<String, dynamic>> _slides = [];
  int _currentSlideIndex = 0;

  @override
  void initState() {
    super.initState();
    _addNewSlide(); // Start with one slide
  }

  /// ✅ Add a new slide with blank question and answers
  void _addNewSlide() {
    setState(() {
      _slides.add({
        'question': '',
        'answers': ['', '', '', ''],
      });
      _currentSlideIndex = _slides.length - 1;
      _loadSlideData();
    });
  }

  /// ✅ Load the data from _slides into the text fields
  void _loadSlideData() {
    if (_slides.isNotEmpty && _currentSlideIndex < _slides.length) {
      _questionController.text = _slides[_currentSlideIndex]['question'];
      _answer1Controller.text = _slides[_currentSlideIndex]['answers'][0];
      _answer2Controller.text = _slides[_currentSlideIndex]['answers'][1];
      _answer3Controller.text = _slides[_currentSlideIndex]['answers'][2];
      _answer4Controller.text = _slides[_currentSlideIndex]['answers'][3];
    }
  }

  /// ✅ Save the current slide's data into _slides
  void _saveCurrentSlide() {
    _slides[_currentSlideIndex] = {
      'question': _questionController.text,
      'answers': [
        _answer1Controller.text,
        _answer2Controller.text,
        _answer3Controller.text,
        _answer4Controller.text,
      ],
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Slide Saved"), backgroundColor: Colors.green),
    );
  }

  /// ✅ Submit quiz to Firestore
  void _submitQuiz() async {
    if (_quizTitleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a quiz title."), backgroundColor: Colors.red),
      );
      return;
    }

    try {
      final quizRef = await _firestore.collection('quizzes').add({
        'title': _quizTitleController.text,
        'createdAt': FieldValue.serverTimestamp(),
      });

      for (var slide in _slides) {
        await quizRef.collection('slides').add({
          'question': slide['question'],
          'answers': slide['answers'],
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Quiz Saved Successfully!"), backgroundColor: Colors.green),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving quiz: $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A3A5F),
      body: SafeArea(
        child: Column(
          children: [
            /// Top Row: CANCEL + Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      "CANCEL",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "QUACKACADEMY",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// Orange title bar for Quiz Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _quizTitleController,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  decoration: InputDecoration(
                    hintText: "Enter Quiz Title...",
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),

            /// Duck Race Image
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/duck_race.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text(
                          "Unable to load asset\nassets/images/duck_race.png",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),

            /// Big Blue Rectangle for Question
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _questionController,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: "Type your Question here",
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),

            /// 4 Answer Boxes (2x2)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildAnswerBox(_answer1Controller, "Answer 1", Colors.amber)),
                      SizedBox(width: 8),
                      Expanded(child: _buildAnswerBox(_answer2Controller, "Answer 2", Colors.lightBlue)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: _buildAnswerBox(_answer3Controller, "Answer 3", Colors.green)),
                      SizedBox(width: 8),
                      Expanded(child: _buildAnswerBox(_answer4Controller, "Answer 4", Colors.red)),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),

            /// Slides Row + Add Slide + Save
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.orange.shade200, // optional background for that bar
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    /// Slides
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _slides.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              _saveCurrentSlide(); // ✅ Save before switching
                              setState(() {
                                _currentSlideIndex = index;
                                _loadSlideData(); // ✅ Load selected slide
                              });
                            },
                            child: Container(
                              width: 70,
                              margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                              decoration: BoxDecoration(
                                color: _currentSlideIndex == index ? Colors.white : Colors.white54,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Slide ${index + 1}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: _currentSlideIndex == index ? Colors.orange : Colors.black87,
                                    ),
                                  ),
                                  if (_currentSlideIndex == index)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Icon(Icons.arrow_forward, color: Colors.orange, size: 18),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    /// Add Slide
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ElevatedButton(
                        onPressed: _addNewSlide,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        ),
                        child: Text("Add Slide", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),

                    /// Save Slide
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ElevatedButton(
                        onPressed: _saveCurrentSlide,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                        child: Text("Save", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 10),

            /// Submit Quiz
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: _submitQuiz,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  "Submit Quiz",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  /// ✅ Build a single answer box
  Widget _buildAnswerBox(TextEditingController controller, String hint, Color bgColor) {
    return Container(
      height: 60,
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
