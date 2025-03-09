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

  /// Each item in this list is ONE lesson (one page).
  /// We break Modules 1, 2, 3, and 4 into multiple lessons.
  ///
  /// Module 1 (4 lessons):
  ///  - Lesson 1: Brief Introduction
  ///  - Lesson 2: What is an Algorithm?
  ///  - Lesson 3: Programming Algorithm
  ///  - Lesson 4: Algorithm Examples
  ///
  /// Module 2 (5 lessons):
  ///  - Lesson 5: L02 + Technical
  ///  - Lesson 6: Brief Introduction
  ///  - Lesson 7: What is a Pseudocode?
  ///  - Lesson 8: Examples of Pseudocode
  ///  - Lesson 9: Practice Pseudocode
  ///
  /// Module 3 (6 lessons):
  ///  - Lesson 10: Lesson 3 Flowchart + Technical Terms
  ///  - Lesson 11: Brief Introduction
  ///  - Lesson 12: What is a Flowchart?
  ///  - Lesson 13: A Flowchart
  ///  - Lesson 14: General Rules for Flowcharting
  ///  - Lesson 15: Examples of Flowchart
  ///
  /// Module 4 (5 lessons):
  ///  - Lesson 16: L02 Data Types + Technical Terms
  ///  - Lesson 17: Brief Introduction
  ///  - Lesson 18: What is a Data Type?
  ///  - Lesson 19: Data Types Figure
  ///  - Lesson 20: Examples of Data Type
  ///
  /// After the 20th lesson (index 19), we go to the Final Quiz.
  List<List<Widget>> get _lessonContents => [
    // ───────────────────────── MODULE 1 ─────────────────────────

    // Lesson 1 (index 0)
    [
      Text(
        "BRIEF INTRODUCTION - Module 1 (Lesson 1)",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 10),
      Text(
        "Intelligence is one of the key characteristics which differentiate a human being from other living creatures on the earth. Basic intelligence covers day to day problem solving and making strategies to handle different situations which keep arising in day to day life. One person goes Bank to withdraw money. After knowing the balance in his account, he/she decides to withdraw the entire amount from his account but he/she has to leave minimum balance in his account. Here deciding about how much amount he/she may withdraw from the account is one of the examples of the basic intelligence.\n\n"
        "During the process of solving any problem, one tries to find the necessary steps to be taken in a sequence. In this unit, you will develop your understanding about problem solving and approaches. Problem solving is a part of our daily life. In computer programming, problem solving is inevitable too and it is one of the main reasons why a program is created.\n\n"
        "You can think of a programming algorithm as a recipe that describes the exact steps needed for the computer to solve a problem or reach a goal. We've all seen food recipes - they list the ingredients needed and a set of steps for how to make the described meal. Well, an algorithm is just like that. In computer lingo, the word for a recipe is a procedure, and the ingredients are called inputs. Your computer looks at your procedure, follows it to the letter, and you get to see the results, which are called outputs. A programming algorithm describes how to do something, and your computer will do it exactly that way every time. Well, it will once you convert your algorithm into a language it understands!\n\n"
        "However, it's important to note that a programming algorithm is not computer code. It's written in simple English (or whatever the programmer speaks). It doesn't beat around the bush--it has a start, a middle, and an end. In fact, you will probably label the first step 'start' and the last step 'end.' It includes only what you need to carry out the task. It does not include anything unclear, often called ambiguous in computer lingo, that someone reading it might wonder about.\n\n"
        "In this lesson, we will learn the various concepts on how to plan a program’s output, step by step using algorithm.",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    ],

    // Lesson 2 (index 1)
    [
      Text(
        "WHAT IS AN ALGORITHM? - Module 1 (Lesson 2)",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.yellow,
        ),
      ),
      SizedBox(height: 10),
      Text(
        "Generally, an algorithm is a step-by-step procedure to solve problems. A guide for installing new software, a manual for assembling appliances, and even recipes are examples of an algorithm. In programming, making an algorithm is exciting; they are expressed in a programming language or in a pseudocode.",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    ],

    // Lesson 3 (index 2)
    [
      Text(
        "PROGRAMMING ALGORITHM - Module 1 (Lesson 3)",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.yellow,
        ),
      ),
      SizedBox(height: 10),
      Text(
        "You probably wish you could see an example, right? So, what exactly does an algorithm in programming look like? Well, asking a user for an email address is probably one of the most common tasks a web-based program might need to do, so that is what we will use here for an example. An algorithm can be written as a list of steps using text. We will make one of each which you will see here: Wasn't that easy? Notice how the top of our example is just a numbered list of steps using plain English, stating exactly what we want the procedure to do (no more, no less). That's a nice thing here, because in one of our steps (step 7) a decision must be made and, depending on the result of that decision, our steps may not go in order from start to end.",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 10),
      Text(
        "Let's take a quick run through our little recipe:",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 10),
      Text(
        "1. Step 1 is really just a reminder that this is a procedure with a beginning and an end.\n"
        "2. In step 2, we make a place in the computer to store what the user types in, also called a variable.\n"
        "3. In step 3, we clear this variable because we might need to use it again and don't want the old contents mixed in with the new.\n"
        "4. In step 4, we prompt the user for an email address.\n"
        "5. In step 5, we stick it in our nifty variable.\n"
        "6. In step 6, we tell our computer to take a close look at this email address— is it really an email address?",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 10),
      _codeSnippet(
        "Step 1: Start\n"
        "Step 2: Create a variable to receive the user's email address\n"
        "Step 3: Clear the variable in case it's not empty\n"
        "Step 4: Ask the user for an email address\n"
        "Step 5: Store the response in the variable\n"
        "Step 6: Check the stored response to see if it is a valid email address\n"
        "Step 7: Not valid? Go back to Step 3.\n"
        "Step 8: End",
      ),
    ],

    // Lesson 4 (index 3)
    [
      Text(
        "ALGORITHM EXAMPLES - Module 1 (Lesson 4)",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 10),
      Text(
        "EXAMPLE 1: Write an algorithm to convert the length in feet to centimeter.",
        style: TextStyle(
          fontFamily: 'Jaro',
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
          fontFamily: 'Jaro',
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
        "L02 CODING USING STANDARD ALGORITHMS AND PSEUDOCODES - Module 2 (Lesson 5)",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.yellow,
        ),
      ),
      SizedBox(height: 10),
      Text(
        "TECHNICAL",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 10),
      Text(
        "• Pseudocode – use to describe processes using natural language.\n"
        "• Syntax – is the set of rules that defines the combinations of symbols that are considered to be a correctly structured document.\n"
        "• Task – is a basic unit of programming that an operating system controls. Depending on how the operating system defines a task, this unit may be an entire program or each successive invocation.\n"
        "• Variable – is a value that can change, depending on conditions or on information passed to the program. A program consists of instructions and data that the program uses when it is running.",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    ],

    // Lesson 6 (index 5): BRIEF INTRODUCTION (Module 2)
    [
      Text(
        "BRIEF INTRODUCTION - Module 2 (Lesson 6)",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 10),
      Text(
        "Although showing learners direct translations between block-based and text-based languages can be useful, this is not always possible. For instance, most block-based languages cannot communicate with a computer’s operating system, so file handling isn’t really possible, nor are communication between one computer and another, or access to peripheral input and output devices.\n\n"
        "Pseudocode is a way of expressing an algorithm without conforming to specific syntactic rules. By learning to read and write pseudocode, learners can more easily communicate ideas and concepts to other programmers, even though they may be using completely different languages. What’s more, algorithmic solutions to many problems are often provided, meaning an ability to translate between pseudocode and a given programming language is a valuable skill.\n\n"
        "There is no such thing as correct pseudocode, although there are a few generally accepted notations widely understood by programmers (e.g., x <-- 10 to create a variable x with a value of 10). It always leads to a solution and tries to be the most efficient we can think up.\n\n"
        "Before you write one piece of computer code, you have to know what the program is supposed to do. Before you write one line of code in any language, it is a good idea to write it in a simple way first to ensure you have included everything you need. The best way to set this up is by using pseudocode.",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    ],

    // Lesson 7 (index 6): WHAT IS A PSEUDOCODE? (Module 2)
    [
      Text(
        "WHAT IS A PSEUDOCODE? - Module 2 (Lesson 7)",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.yellow,
        ),
      ),
      SizedBox(height: 10),
      Text(
        "A pseudocode is a description of an algorithm or a computer program using natural language. Because the aim of pseudocode is to make reading the program easier, some codes that are not essential for human understanding are omitted. This language is commonly used in planning out the structure of a program or a system, like a blueprint.\n\n"
        "Although showing learners direct translations between block-based and text-based languages can be useful, this is not always possible. For instance, most block-based languages cannot communicate with a computer’s operating system, so file handling isn’t really possible. Pseudocode is a way of expressing an algorithm without conforming to specific syntactic rules. By learning to read and write pseudocode, learners can more easily communicate ideas to other programmers.\n\n"
        "There is no such thing as correct pseudocode, although there are a few generally accepted notations. It always leads to a solution and tries to be the most efficient solution we can think up. It's often a good idea to number the steps, but you don't have to. Instead of numbered steps, some folks use indentation. The main thing is simplicity.\n\n"
        "Before you write one piece of computer code, you have to know what the program is supposed to do. It's a good idea to write it in a simple way first. The best way to set this up is by using pseudocode. Pseudocode is not an actual programming language; it uses short phrases to outline code for programs before you create them in a specific language.",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    ],

    // Lesson 8 (index 7): EXAMPLES OF PSEUDOCODE (Module 2)
    [
      Text(
        "EXAMPLES OF PSEUDOCODE - Module 2 (Lesson 8)",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 10),
      Text(
        "1. Create a program to add 2 numbers together and then display the result.",
        style: TextStyle(
          fontFamily: 'Jaro',
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
          fontFamily: 'Jaro',
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
          fontFamily: 'Jaro',
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
          fontFamily: 'Jaro',
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    ],

    // Lesson 9 (index 8): PRACTICE PSEUDOCODE (Module 2)
    [
      Text(
        "PRACTICE PSEUDOCODE - Module 2 (Lesson 9)",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 10),
      Text(
        "Write your own pseudocode program to accomplish a simple task.\n\n"
        "Step 1: Choose a Task\n"
        "• Choose a simple task to accomplish with your program. You want this to be complex enough to require multiple steps while still being relatively simple.\n\n"
        "Step 2: Write the Pseudocode\n"
        "• When writing the code, remember:\n"
        "   - The language should be universal.\n"
        "   - Limit each line to one task/action.\n"
        "   - Capitalize all key words.\n"
        "   - Indent loops.\n"
        "• Don't forget to start with 'Start Program' and end with 'End Program'.\n\n"
        "Step 3: Test Your Code\n"
        "• After writing your pseudocode, put it aside for at least 1 day.\n"
        "• Follow your pseudocode exactly to see if the task is accomplished. If not, troubleshoot.\n"
        "• Alternatively, ask someone else to follow your pseudocode precisely.\n",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    ],

    // ───────────────────────── MODULE 3 ─────────────────────────

    // Lesson 10 (index 9): Flowchart + Technical Terms
    [
      Text(
        "LESSON 3 CODING USING STANDARD ALGORITHMS: FLOWCHART - Module 3 (Lesson 10)",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.yellow,
        ),
      ),
      SizedBox(height: 10),
      Text(
        "TECHNICAL TERMS",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.yellow,
        ),
      ),
      SizedBox(height: 10),
      Text(
        "Flowchart – is a graphical representation of an algorithm. Programmers often use it as a program-planning tool to solve a problem. It makes use of symbols which are connected among them to indicate the flow of information and processing.\n\n"
        "Flowchart symbols – are specific shapes used to create a visual representation of a program. They can be as simple as three separate functions with one line connecting them, or they can be an entire web of functions.\n\n"
        "Graphical Representation – is another way of analyzing numerical data. A flowchart is a graphical representation of an algorithm.",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    ],

    // Lesson 11 (index 10): Flowchart Symbols + Brief Introduction
    [
      Text(
        "FLOWCHART SYMBOLS & BRIEF INTRODUCTION - Module 3 (Lesson 11)",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.yellow,
        ),
      ),
      SizedBox(height: 10),
      Text(
        "Flowchart Symbols",
        style: TextStyle(
          fontFamily: 'Jaro',
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
          fontFamily: 'Jaro',
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
          fontFamily: 'Jaro',
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    ],

    // Lesson 12 (index 11): What is a Flowchart?
    [
      Text(
        "WHAT IS A FLOWCHART? - Module 3 (Lesson 12)",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.yellow,
        ),
      ),
      SizedBox(height: 10),
      Text(
        "Like pseudocodes, a flowchart is also a description of an algorithm or a computer program. It also serves as the program’s blueprint during development, but in graphical form. Flowcharts help in effective analysis, maintenance, and spotting potential improvements.\n\n"
        "It consists of 8 standard symbols: Terminal, Preparation/Initialization, Process, Decision, On-page Connector, Off-page Connector, Input/Output operation, and Flow lines (arrow).",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    ],

    // Lesson 13 (index 12): A Flowchart
    [
      Text(
        "A FLOWCHART - Module 3 (Lesson 13)",
        style: TextStyle(
          fontFamily: 'Jaro',
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
          fontFamily: 'Jaro',
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    ],

    // Lesson 14 (index 13): General Rules for Flowcharting
    [
      Text(
        "GENERAL RULES FOR FLOWCHARTING - Module 3 (Lesson 14)",
        style: TextStyle(
          fontFamily: 'Jaro',
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
          fontFamily: 'Jaro',
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    ],

    // Lesson 15 (index 14): Examples of Flowchart
    [
      Text(
        "EXAMPLES OF FLOWCHART - Module 3 (Lesson 15)",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 10),
      Text(
        "1. Determine whether the temperature is below freezing or above freezing point:",
        style: TextStyle(
          fontFamily: 'Jaro',
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
          fontFamily: 'Jaro',
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
          fontFamily: 'Jaro',
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
        "LO2. CODING USING STANDARD ALGORITHMS: DATA TYPES - Module 4 (Lesson 16)",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.yellow,
        ),
      ),
      SizedBox(height: 10),
      Text(
        "TECHNICAL TERMS:",
        style: TextStyle(
          fontFamily: 'Jaro',
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
          fontFamily: 'Jaro',
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    ],

    // Lesson 17: Brief Introduction
    [
      Text(
        "BRIEF INTRODUCTION - Module 4 (Lesson 17)",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.yellow,
        ),
      ),
      SizedBox(height: 10),
      Text(
        "When creating a variable, we also need to declare the data type it contains. This is because the program will use different types of data in different ways. Programming languages define data types differently. For example, almost all languages differentiate between ‘integers’ (whole numbers), ‘non-integers’ (numbers with decimals), and ‘characters’ (letters or words).\n\n"
        "In computer science and computer programming, a data type or simply type is an attribute of data which tells the compiler or interpreter how the programmer intends to use the data. This data type defines the operations that can be done on the data, the meaning of the data, and the way values of that type can be stored.\n\n"
        "A data type, in programming, is a classification that specifies which type of value a variable has and what type of mathematical, relational or logical operations can be applied to it without causing an error. A string, for example, is a data type that is used to classify text and an integer is a data type used to classify whole numbers.",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    ],

    // Lesson 18: What is a Data Type?
    [
      Text(
        "WHAT IS A DATA TYPE? - Module 4 (Lesson 18)",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.yellow,
        ),
      ),
      SizedBox(height: 10),
      Text(
        "A data type is a description of a specific data that can be stored in a variable, the amount of memory the item occupies, and the operations it can be performed.",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    ],

    // Lesson 19: Data Types Figure
    [
      Text(
        "DATA TYPES FIGURE - Module 4 (Lesson 19)",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.yellow,
        ),
      ),
      SizedBox(height: 10),
      Text(
        "Below is a reference figure/screenshot illustrating common data types:",
        style: TextStyle(
          fontFamily: 'Jaro',
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
        "EXAMPLES OF DATA TYPE - Module 4 (Lesson 20)",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.yellow,
        ),
      ),
      SizedBox(height: 10),
      Text(
        "1. A Teacher would like to create a program that will classify if a student’s grade must be marked Passed or Failed. Any grades lower than 60 is considered failed. From this given information, please provide the necessary data type.\n"
        "Answer: The float data type is the best data type for this variable since a student’s grade is usually a real number (numbers with decimal places).",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 15),
      Text(
        "2. Identify the data type to convert the length in feet to centimeter.\n"
        "Float because the possible answer is a number with a decimal point.",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 15),
      Text(
        "3. Identify the data type that will read the two sides of a rectangle and calculate its area.\n"
        "Integer because the possible answer is a whole number.",
        style: TextStyle(
          fontFamily: 'Jaro',
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
          fontFamily: 'Jaro',
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
          fontFamily: 'Jaro',
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
            child: const Icon(Icons.star, color: Colors.yellow, size: 20),
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
            color: Colors.orange,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            isLastLesson ? "Final Quiz" : "Next Lesson",
            style: const TextStyle(
              fontFamily: 'Jaro',
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
