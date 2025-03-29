import 'package:flutter/material.dart';
import 'package:quackacademy/screens/courses/java_course/Java_Q1/java_q1_final_quiz.dart';

class JavaAllLessonsPage extends StatefulWidget {
  @override
  _JavaAllLessonsPageState createState() => _JavaAllLessonsPageState();
}

class _JavaAllLessonsPageState extends State<JavaAllLessonsPage> {
  /// We now have 20 total lessons across Modules 1, 2, 3, and 4.
  /// After lesson index 19 (the 20th lesson), we go to Final Quiz.
  final int _totalLessons = 20;

  /// Current lesson index (0-based).
  int _currentLessonIndex = 0;

  /// Returns progress fraction (e.g., 1/20 = 0.05, 2/20 = 0.1, etc.).
  double get _progress => (_currentLessonIndex + 1) / _totalLessons;

  /// A helper widget for showing code/pseudocode examples in a 'code snippet' style.
  static Widget _codeSnippet(String code) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        code,
        style: const TextStyle(
          color: Colors.greenAccent,
          fontFamily: 'monospace',
          fontSize: 14,
        ),
      ),
    );
  }

  /// Builds a clickable flowchart image. When tapped, shows a dialog with the full-size image.
  Widget _clickableFlowchart(String imagePath) {
    return GestureDetector(
      onTap: () {
        // Show a dialog with the full-size image
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: InteractiveViewer(
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Container(
        width: 200, // Adjust the thumbnail width as needed
        height: 200,
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  List<List<Widget>> get _lessonContents => [
        [
          Text(
            "BRIEF INTRODUCTION",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text.rich(
            TextSpan(
              style: TextStyle(fontSize: 18, color: Colors.white),
              children: [
                TextSpan(text: "Humans are unique because of their "),
                TextSpan(
                    text: "intelligence",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text: ", especially in handling everyday problems.\n\n"),
                TextSpan(text: "In programming, "),
                TextSpan(
                    text: "problem-solving",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        " is key. We break problems down into steps to find solutions.\n\n"),
                TextSpan(text: "A "),
                TextSpan(
                    text: "programming algorithm",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: " is like a recipe — a set of steps (called "),
                TextSpan(
                    text: "procedures",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ") that take "),
                TextSpan(
                    text: "inputs",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: " and produce "),
                TextSpan(
                    text: "outputs",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ".\n\n"),
                TextSpan(
                    text:
                        "An algorithm is not actual code — it's written in plain language with a clear "),
                TextSpan(
                    text: "start",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ", middle, and "),
                TextSpan(
                    text: "end", style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ".\n\n"),
                TextSpan(
                    text:
                        "In this lesson, you'll learn how to plan a program's output using "),
                TextSpan(
                    text: "algorithms",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: " step by step."),
              ],
            ),
          ),
        ],

        // Lesson 2 (index 1)
        [
          Text(
            "WHAT IS AN ALGORITHM?",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Generally, an algorithm is a step-by-step procedure to solve problems. A guide for installing new software, a manual for assembling appliances, and even recipes are examples of an algorithm. In programming, making an algorithm is exciting; they are expressed in a programming language or in a pseudocode.",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ],

        // Lesson 3 (index 2)
        [
          Text(
            "PROGRAMMING ALGORITHM",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 16, color: Colors.white),
              children: [
                TextSpan(text: "An "),
                TextSpan(
                  text: "algorithm",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                TextSpan(
                    text:
                        " is a step-by-step method to solve a task. A common example is asking a user for an "),
                TextSpan(
                  text: "email address",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                TextSpan(text: "."),
              ],
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Here’s a simple breakdown:",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 16, color: Colors.white),
              children: [
                TextSpan(
                    text: "Step 1:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: " Begin the process\n"),
                TextSpan(
                    text: "Step 2:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: " Create a "),
                TextSpan(
                    text: "variable",
                    style: TextStyle(fontStyle: FontStyle.italic)),
                TextSpan(text: "\n"),
                TextSpan(
                    text: "Step 3:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: " Clear any old data\n"),
                TextSpan(
                    text: "Step 4:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: " Ask the user for input\n"),
                TextSpan(
                    text: "Step 5:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: " Store the response\n"),
                TextSpan(
                    text: "Step 6:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: " Check if it's a "),
                TextSpan(
                    text: "valid email",
                    style: TextStyle(fontStyle: FontStyle.italic)),
                TextSpan(text: "\n"),
                TextSpan(
                    text: "Step 7:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: " If invalid, go back to Step 3\n"),
                TextSpan(
                    text: "Step 8:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: " End"),
              ],
            ),
          ),
          SizedBox(height: 10),
          _codeSnippet(
            "Step 1: Start\n"
            "Step 2: Create a *variable* to receive the user's email\n"
            "Step 3: *Clear* the variable\n"
            "Step 4: *Prompt* the user for an email\n"
            "Step 5: *Store* the input\n"
            "Step 6: *Validate* the email format\n"
            "Step 7: If invalid, *repeat* from Step 3\n"
            "Step 8: End",
          ),
        ],

        // Lesson 4 (index 3)
        [
          Text(
            "ALGORITHM EXAMPLES",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "EXAMPLE 1: Write an algorithm to convert the length in feet to centimeter.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          _codeSnippet(
            "Step 1: Input W, L\n"
            "Step 2: A = L x W\n"
            "Step 3: Print A",
          ),
          SizedBox(height: 20),
          Text(
            "EXAMPLE 2: Write an algorithm that will read the two sides of a rectangle and calculate its area.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          _codeSnippet(
            "Step 1: Input Lft\n"
            "Step 2: Lcm = Lft x 30\n"
            "Step 3: Print Lcm",
          ),
        ],

        // ───────────────────────── MODULE 2 ─────────────────────────

        // Lesson 5 (index 4): L02 + Technical
        [
          Text(
            "CODING USING STANDARD ALGORITHMS AND PSEUDOCODES",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "TECHNICAL TERMS",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 18, color: Colors.white),
              children: [
                TextSpan(
                  text: "Pseudocode: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      "A way to describe a process using natural, everyday language.\n\n",
                ),
                TextSpan(
                  text: "Syntax: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      "A set of rules that defines the correct structure and combinations of symbols in programming.\n\n",
                ),
                TextSpan(
                  text: "Task: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      "A basic unit of programming managed by the operating system. It can be a full program or a single function being run.\n\n",
                ),
                TextSpan(
                  text: "Variable: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      "A data value that can change depending on conditions or input. Programs use variables to store and work with data while running.",
                ),
              ],
            ),
          ),
        ],

        // Lesson 6 (index 5): BRIEF INTRODUCTION (Module 2)
        [
          Text(
            "BRIEF INTRODUCTION",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 16, color: Colors.white),
              children: [
                TextSpan(
                  text:
                      "While showing learners how block-based code translates to text-based code can be helpful, it's not always possible. For example, most block-based languages can't interact directly with a computer’s operating system. This means things like file handling, device input/output, or communication between computers are often not supported.\n\n",
                ),
                TextSpan(
                  text: "Pseudocode ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      "is a way to express an algorithm without following strict syntax rules. It's useful for planning and explaining code logic clearly, especially when working across different programming languages.\n\n",
                ),
                TextSpan(
                  text:
                      "Being able to read and write pseudocode makes it easier to share ideas with other programmers. It's also a key skill when translating algorithmic solutions into real code.\n\n",
                ),
                TextSpan(
                  text:
                      "There is no single 'correct' way to write pseudocode. However, there are common formats understood by many programmers—for example: ",
                ),
                TextSpan(
                  text: "x <-- 10 ",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                TextSpan(
                  text: "to assign the value 10 to a variable named x.\n\n",
                ),
                TextSpan(
                  text:
                      "Before writing real code, it's a good idea to first describe what your program should do. Writing in pseudocode helps ensure you include everything needed before jumping into actual programming.",
                ),
              ],
            ),
          ),
        ],

        // Lesson 7 (index 6): WHAT IS A PSEUDOCODE? (Module 2)
        [
          Text(
            "WHAT IS A PSEUDOCODE?",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 16, color: Colors.white),
              children: [
                TextSpan(
                  text: "Pseudocode ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      "is a way to describe an algorithm or a program using plain, natural language. It focuses on making the steps easy to read and understand—so anything unnecessary for human understanding is often left out. Think of it like a blueprint for your code.\n\n",
                ),
                TextSpan(
                  text:
                      "While translating between block-based and text-based code is helpful, it’s not always possible. For example, block-based languages usually can’t handle tasks like file operations or device communication. ",
                ),
                TextSpan(
                  text: "Pseudocode ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      "solves this by letting you plan out logic without worrying about the exact syntax of a language.\n\n",
                ),
                TextSpan(
                  text: "There’s no such thing as 'correct' pseudocode. ",
                ),
                TextSpan(
                  text:
                      "However, some notations are commonly used and understood ",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                TextSpan(
                  text:
                      "(like using arrows to assign values: x ← 10). The goal is always to be simple and efficient.\n\n",
                ),
                TextSpan(
                  text:
                      "You can write pseudocode as numbered steps or just use indentation. Either way, the main idea is to keep it clear and easy to follow.\n\n",
                ),
                TextSpan(
                  text:
                      "Before writing any real code, it's important to understand what your program should do. ",
                ),
                TextSpan(
                  text: "Writing pseudocode first ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      "helps you make sure all the important steps are included—before you begin coding in any specific language.",
                ),
              ],
            ),
          ),
        ],

        // Lesson 8 (index 7): EXAMPLES OF PSEUDOCODE (Module 2)
        [
          Text(
            "EXAMPLES OF PSEUDOCODE",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "1. Create a program to add 2 numbers together and then display the result.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          _codeSnippet(
            "Start Program\n"
            "Enter two numbers, A, B\n"
            "Add the numbers together\n"
            "Print Sum\n"
            "End Program",
          ),
          SizedBox(height: 20),
          Text(
            "2. Compute the area of a rectangle.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          _codeSnippet(
            "Get the length, l, and width, w\n"
            "Compute the area = l * w\n"
            "Display the area",
          ),
          SizedBox(height: 20),
          Text(
            "3. Compute the perimeter of a rectangle.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          _codeSnippet(
            "Enter length, l\n"
            "Enter width, w\n"
            "Compute Perimeter = 2*l + 2*w\n"
            "Display Perimeter of a rectangle",
          ),
          SizedBox(height: 20),
          Text(
            "Remember, writing basic pseudocode is not like writing an actual coding language. It cannot be compiled or run like a regular program. Some companies use specific pseudocode syntax to keep everyone on the same page. By adhering to a specific syntax, everyone can read and understand the flow more easily.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],

        // Lesson 9 (index 8): PRACTICE PSEUDOCODE (Module 2)
        [
          Text(
            "PRACTICE PSEUDOCODE",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 16, color: Colors.white),
              children: [
                TextSpan(
                  text: "Create a simple pseudocode for a basic task.\n\n",
                ),
                TextSpan(
                  text: "Step 1: Choose a Task\n",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: "Pick a task with a few clear steps.\n\n",
                ),
                TextSpan(
                  text: "Step 2: Write the Pseudocode\n",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: "Use clear, universal instructions.\n"
                      "One action per line.\n"
                      "Capitalize keywords (e.g., IF, THEN, ELSE).\n"
                      "Indent loops/conditions.\n"
                      "Start with ",
                ),
                TextSpan(
                  text: "'Start Program'",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                TextSpan(
                  text: " and end with ",
                ),
                TextSpan(
                  text: "'End Program'.\n\n",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                TextSpan(
                  text: "Step 3: Test\n",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      "Follow your pseudocode exactly or ask someone else to.\n"
                      "Fix and improve if needed.\n",
                ),
              ],
            ),
          ),
        ],

        // ───────────────────────── MODULE 3 ─────────────────────────

        // Lesson 10 (index 9): Flowchart + Technical Terms
        [
          Text(
            "CODING USING STANDARD ALGORITHMS: FLOWCHART",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "TECHNICAL TERMS",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 16, color: Colors.white),
              children: [
                TextSpan(
                  text: "Flowchart: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      "A graphical way to represent an algorithm. Programmers use it to plan how a program solves a problem. It shows the sequence of actions using connected symbols.\n\n",
                ),
                TextSpan(
                  text: "Flowchart symbols: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      "These are standard shapes used to represent steps, actions, or decisions in a flowchart. They can represent simple sequences or complex systems of functions linked together.\n\n",
                ),
                TextSpan(
                  text: "Graphical representation: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      "A way to visually analyze and present data or processes. In this context, a flowchart is used to visually represent how an algorithm works.",
                ),
              ],
            ),
          ),
        ],

        // Lesson 11 (index 10): Flowchart Symbols + Brief Introduction
        [
          Text(
            "FLOWCHART SYMBOLS & BRIEF INTRODUCTION",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Flowchart Symbols",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          _clickableFlowchart("assets/images/flowchart1.png"),
          SizedBox(height: 20),
          Text(
            "BRIEF INTRODUCTION",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Flowcharts to document business processes came into use in the 1920s and ‘30s. In 1921, industrial engineers Frank and Lillian Gilbreth introduced the “Flow Process Chart” to ASME. In the early 1930s, industrial engineer Allan H. Morgensen used Gilbreth’s tools to make work more efficient.\n\n"
            "In the 1940s, Art Spinanger and Ben S. Graham spread these methods more widely. In 1947, ASME adopted a symbol system for Flow Process Charts, derived from the Gilbreths’ original work. Also in the late ‘40s, Herman Goldstine and John Van Neumann used flowcharts to develop computer programs. Flowcharts are still used today, although pseudocode is often used for deeper detail.\n\n"
            "In Japan, Kaoru Ishikawa named flowcharts as one of the key tools of quality control. For years, flowcharts were used to map out programs before writing code. However, they were difficult to modify and couldn’t display all parts of a modern program easily.\n\n"
            "A flowchart is a type of diagram that represents an algorithm or process. It shows steps as boxes and uses arrows to connect them, illustrating a solution model to a given problem.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],

        // Lesson 12 (index 11): What is a Flowchart?
        [
          Text(
            "WHAT IS A FLOWCHART?",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Like pseudocodes, a flowchart is also a description of an algorithm or a computer program. It also serves as the program’s blueprint during development, but in graphical form. Flowcharts help in effective analysis, maintenance, and spotting potential improvements.\n\n"
            "It consists of 8 standard symbols: Terminal, Preparation/Initialization, Process, Decision, On-page Connector, Off-page Connector, Input/Output operation, and Flow lines (arrow).",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],

        // Lesson 13 (index 12): A Flowchart
        [
          Text(
            "A FLOWCHART",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "• Shows logic of an algorithm\n"
            "• Emphasizes individual steps and their interconnections\n"
            "• e.g., control flow from one action to the next",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],

        // Lesson 14 (index 13): General Rules for Flowcharting
        [
          Text(
            "GENERAL RULES FOR FLOWCHARTING",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "1. All boxes of the flowchart are connected with flow lines.\n"
            "2. Flowchart symbols have an entry point on the top (no other entry points). The exit point is on the bottom (except for Decision symbols).\n"
            "3. Decision symbols have two exit points; these can be on the sides or bottom.\n"
            "4. Generally, flowcharts flow top to bottom. An upward flow can be shown if it does not exceed 3 symbols.\n"
            "5. Connectors are used to connect breaks in the flowchart (e.g., from one page to another).\n"
            "6. Subroutines and Interrupt programs have their own independent flowcharts.\n"
            "7. All flowcharts start with a Terminal or Predefined Process symbol.\n"
            "8. All flowcharts end with a terminal or a contentious loop.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],

        // Lesson 15 (index 14): Examples of Flowchart
        [
          Text(
            "EXAMPLES OF FLOWCHART",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "1. Determine whether the temperature is below freezing or above freezing point:",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          _clickableFlowchart("assets/images/flowchart2.png"),
          SizedBox(height: 20),
          Text(
            "2. Draw a flowchart to convert the length in feet to centimeter:",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          _clickableFlowchart("assets/images/flowchart3.png"),
          SizedBox(height: 20),
          Text(
            "3. Draw a flowchart that will read the two sides of a rectangle and calculate its area:",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          _clickableFlowchart("assets/images/flowchart4.png"),
        ],

        // ───────────────────────── MODULE 4 ─────────────────────────

        // Lesson 16: LO2 Data Types + Technical Terms
        [
          Text(
            "CODING USING STANDARD ALGORITHMS: DATA TYPES",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "TECHNICAL TERMS:",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Data Type – description of a specific data that can be stored in a variable, the amount memory the item occupies, and the operations it can be performed.\n\n"
            "Logical Operation – an operation that acts on binary numbers to produce a result according to the laws of Boolean logic.\n\n"
            "Rational Operation – is nothing more than a fraction in which the numerator and/or the denominator are polynomials.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],

        // Lesson 17: Brief Introduction
        [
          Text(
            "BRIEF INTRODUCTION",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "When creating a variable, we also need to declare the data type it contains. This is because the program will use different types of data in different ways. Programming languages define data types differently. For example, almost all languages differentiate between ‘integers’ (whole numbers), ‘non-integers’ (numbers with decimals), and ‘characters’ (letters or words).\n\n"
            "In computer science and computer programming, a data type or simply type is an attribute of data which tells the compiler or interpreter how the programmer intends to use the data. This data type defines the operations that can be done on the data, the meaning of the data, and the way values of that type can be stored.\n\n"
            "A data type, in programming, is a classification that specifies which type of value a variable has and what type of mathematical, relational or logical operations can be applied to it without causing an error. A string, for example, is a data type that is used to classify text and an integer is a data type used to classify whole numbers.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],

        // Lesson 18: What is a Data Type?
        [
          Text(
            "WHAT IS A DATA TYPE?",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "A data type is a description of a specific data that can be stored in a variable, the amount of memory the item occupies, and the operations it can be performed.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],

        // Lesson 19: Data Types Figure
        [
          Text(
            "DATA TYPES FIGURE",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Below is a reference figure/screenshot illustrating common data types:",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          // Add your screenshot here
          // Example placeholder:
          _clickableFlowchart("assets/images/datatype1.png"),
          SizedBox(height: 20),
          _clickableFlowchart("assets/images/datatype2.png")
        ],

        // Lesson 20: Examples of Data Type
        [
          Text(
            "EXAMPLES OF DATA TYPE",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "1. A Teacher would like to create a program that will classify if a student’s grade must be marked Passed or Failed. Any grades lower than 60 is considered failed. From this given information, please provide the necessary data type.\n"
            "Answer: The float data type is the best data type for this variable since a student’s grade is usually a real number (numbers with decimal places).",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 15),
          Text(
            "2. Identify the data type to convert the length in feet to centimeter.\n"
            "Float because the possible answer is a number with a decimal point.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 15),
          Text(
            "3. Identify the data type that will read the two sides of a rectangle and calculate its area.\n"
            "Integer because the possible answer is a whole number.",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 15),
          Text(
            "4. Identify what data type that will calculate the roots of a quadratic equation ax^2 + bx + c = 0.\n"
            "Hint: d = sqrt(b^2 - 4ac), and the roots are: x1 = (-b + d)/(2a) and x2 = (-b - d)/(2a)\n\n"
            "Void because it has no values and is used to represent nothing.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 15),
          Text(
            "5. Identify what data type that will determine the largest value and prints the largest value with an identifying message.\n"
            "Integer because the possible answer may be a whole number.\n"
            "Float because the possible answer may be a number with a decimal point.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A5F),
      body: SafeArea(
        child: Column(
          children: [
            // ────────────────────── PROGRESS BAR ──────────────────────
            _buildProgressBar(context, _progress),

            // ────────────────────── LESSON CONTENT ──────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: _lessonContents[_currentLessonIndex],
              ),
            ),

            // ────────────────────── BOTTOM BUTTON ──────────────────────
            _buildBottomButton(context),
          ],
        ),
      ),
    );
  }

  /// Builds the progress bar at the top.
  Widget _buildProgressBar(BuildContext context, double progress) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          // Background track
          Container(
            height: 8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          // Animated progress
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: 8,
            width: MediaQuery.of(context).size.width * progress,
            decoration: BoxDecoration(
              color: Colors.greenAccent,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          // Star indicator
          Positioned(
            left: MediaQuery.of(context).size.width * progress - 16,
            child: const Icon(Icons.star, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  /// Builds the bottom button that goes to the next lesson or final quiz.
  Widget _buildBottomButton(BuildContext context) {
    // The last lesson index is 19 (since we have 20 total).
    bool isLastLesson = _currentLessonIndex == _totalLessons - 1;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () {
          if (!isLastLesson) {
            // Go to next lesson
            setState(() {
              _currentLessonIndex++;
            });
          } else {
            // On the final lesson, navigate to the Final Quiz page.
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => JavaQ1FinalQuizPage()),
            );
          }
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: Color(0xFF476F95),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            isLastLesson ? "Final Quiz" : "Next Lesson",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
