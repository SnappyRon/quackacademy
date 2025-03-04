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

  /// Which answer index is correct (radio button)
  int? _selectedCorrectAnswerIndex;

  @override
  void initState() {
    super.initState();
    _addNewSlide(); // Start with one blank slide
  }

  /// Save current slide, then create a new blank slide
  void _addNewSlide() {
    _saveCurrentSlide();
    setState(() {
      _slides.add({
        'question': '',
        'answers': ['', '', '', ''],
        'correctAnswerIndex': 0,
      });
      _currentSlideIndex = _slides.length - 1;
      _loadSlideData();
    });
  }

  /// Load slide data into the text fields
  void _loadSlideData() {
    if (_slides.isNotEmpty && _currentSlideIndex < _slides.length) {
      final slide = _slides[_currentSlideIndex];
      _questionController.text = slide['question'];
      final answers = slide['answers'] as List<String>;
      _answer1Controller.text = answers[0];
      _answer2Controller.text = answers[1];
      _answer3Controller.text = answers[2];
      _answer4Controller.text = answers[3];
      _selectedCorrectAnswerIndex = slide['correctAnswerIndex'];
    }
  }

  /// Save current slide data into _slides
  void _saveCurrentSlide() {
    if (_slides.isEmpty) return;

    _slides[_currentSlideIndex] = {
      'question': _questionController.text,
      'answers': [
        _answer1Controller.text,
        _answer2Controller.text,
        _answer3Controller.text,
        _answer4Controller.text,
      ],
      'correctAnswerIndex': _selectedCorrectAnswerIndex ?? 0,
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Slide Saved"), backgroundColor: Colors.green),
    );
  }

  /// Submit quiz to Firestore
  void _submitQuiz() async {
    // Save final slide data
    _saveCurrentSlide();

    if (_quizTitleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter a quiz title."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Create new quiz doc
      final quizRef = await _firestore.collection('quizzes').add({
        'title': _quizTitleController.text,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // For each slide, store question, answers, correct answer
      for (var slide in _slides) {
        final correctIndex = slide['correctAnswerIndex'] as int;
        final answersList = slide['answers'] as List<String>;

        final finalCorrectAnswer = answersList[correctIndex];

        await quizRef.collection('slides').add({
          'question': slide['question'],
          'answers': answersList,
          'correctAnswer': finalCorrectAnswer,
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
            // Top Row: CANCEL + Title
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

            // Orange title bar for Quiz Title
            _buildQuizTitleInput(),
            SizedBox(height: 10),

            // Big Blue Rectangle for Question
            _buildQuestionInput(),
            SizedBox(height: 10),

            // 4 Answer Boxes (with neon green radio buttons)
            _buildAnswerBoxes(),
            SizedBox(height: 10),

            // Optional Preview
            _buildPreviewArea(),
            SizedBox(height: 10),

            // Slides Row + Add Slide + Save
            _buildSlideControls(),
            SizedBox(height: 10),

            // Submit Quiz Button
            _buildSubmitButton(),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  /// Build the Quiz Title Input Field
  Widget _buildQuizTitleInput() {
    return Padding(
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
    );
  }

  /// Build the Question Input Field
  Widget _buildQuestionInput() {
    return Padding(
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
    );
  }

  /// Build the Answer Boxes with neon green radio buttons
  Widget _buildAnswerBoxes() {
    List<TextEditingController> controllers = [
      _answer1Controller,
      _answer2Controller,
      _answer3Controller,
      _answer4Controller
    ];
    List<Color> colors = [Colors.amber, Colors.lightBlue, Colors.green, Colors.red];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: List.generate(4, (index) {
          return Row(
            children: [
              Radio<int>(
                activeColor: Colors.greenAccent, // neon green
                value: index,
                groupValue: _selectedCorrectAnswerIndex,
                onChanged: (int? value) {
                  setState(() {
                    _selectedCorrectAnswerIndex = value;
                  });
                },
              ),
              Expanded(
                child: Container(
                  height: 60,
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: colors[index],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: controllers[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: "Answer ${index + 1}",
                      hintStyle: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  /// A real-time preview (optional)
  Widget _buildPreviewArea() {
    final answers = [
      _answer1Controller.text,
      _answer2Controller.text,
      _answer3Controller.text,
      _answer4Controller.text
    ];

    String chosenRadioAnswer = '';
    if (_selectedCorrectAnswerIndex != null &&
        _selectedCorrectAnswerIndex! >= 0 &&
        _selectedCorrectAnswerIndex! < answers.length) {
      chosenRadioAnswer = answers[_selectedCorrectAnswerIndex!];
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preview Slide',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 8),
            Text('Question: ${_questionController.text}', style: TextStyle(color: Colors.white)),
            SizedBox(height: 4),
            Text('A: ${answers[0]}', style: TextStyle(color: Colors.white)),
            Text('B: ${answers[1]}', style: TextStyle(color: Colors.white)),
            Text('C: ${answers[2]}', style: TextStyle(color: Colors.white)),
            Text('D: ${answers[3]}', style: TextStyle(color: Colors.white)),
            SizedBox(height: 4),
            Text('Chosen (Radio): $chosenRadioAnswer', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  /// Slides Row + Add Slide + Save
  Widget _buildSlideControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.orange.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _saveCurrentSlide();
                      setState(() {
                        _currentSlideIndex = index;
                        _loadSlideData();
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
    );
  }

  /// Submit Quiz
  Widget _buildSubmitButton() {
    return Padding(
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
    );
  }
}
