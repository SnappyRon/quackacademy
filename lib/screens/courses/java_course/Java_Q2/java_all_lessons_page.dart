import 'package:flutter/material.dart';
import 'package:quackacademy/screens/courses/java_course/Java_Q2/java_q2_final_quiz.dart';

class JavaAllLessonsPage2 extends StatefulWidget {
  @override
  _JavaAllLessonsPageState2 createState() => _JavaAllLessonsPageState2();
}


class _JavaAllLessonsPageState2 extends State<JavaAllLessonsPage2> {
  /// We now have 20 total lessons across Modules 1, 2, 3, and 4.
  /// After lesson index 19 (the 20th lesson), we go to Final Quiz.
  final int _totalLessons = 13;

  /// Current lesson index (0-based).
  int _currentLessonIndex = 0;

  /// Returns progress fraction (e.g., 1/13 = 0.05, 2/13 = 0.1, etc.).
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
    // ───────────────────────── MODULE 1 ─────────────────────────

    // Lesson 1 (index 0)
    [
      Text(
        "Apply Basics of Java Language - Module 2 (Lesson 1)",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.yellow,
        ),
      ),
      SizedBox(height: 10),
      Text(
        "What is Integrated Development Environment (IDE)? \n\n"
        "An integrated development environment (IDE) is an application that enables development of an application.\n\n"
        "They are designed to include all programming tasks in one application. Thus, IDEs gives all the tools you need in programming.\n\n"
        "An example of a free, open source, integrated development environment that enables you to develop desktop, mobile and web applications is NetBeans IDE.\n\n" 
        "The IDE supports application development in various languages, including Java, HTML5, PHP and C++. The IDE provides integrated support for the complete development cycle, from project creationthrough debugging, profiling and deployment.\n\n"
        "The IDE runs on Windows, Linux, Mac OS X, and other UNIX-based systems. The IDE provides comprehensive support for JDK 8 technologies and the most recent Java enhancements.\n\n"
        "It is the first IDE that provides support for JDK 8, Java EE 7, and JavaFX 2. The IDE fully supports Java EE using the latest standards for Java, XML, Web services, and SQL and fully supports the GlassFish Server, the reference implementation of Java EE.\n\n",
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
        "User Interface Specification: Window System, Final Draft",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.yellow,
        ),
      ),
      SizedBox(height: 10),
      Text(
        "The window system is a visual framework of the IDE. It displays windows and allows to manage them to suit the user needs while performing a concrete task.\n\n"

        "Attributes of the new design: \n"
        
        "1. document centric– documents are the center of windowing system.\n\n"
        "2. simple– provides only necessary features\n\n"
        "3. open– open to the user customization; allows an easy module integration to the default layout \n\n"
        "4. keyboard accessible– all features are fully keyboard accessible \n\n"

        "The following are key terms that you should get familiar with in learning IDE. These are the following:\n\n"

        "Window System – a framework controlling behavior of windows and document windows. Window system doesn't control behavior of dialog boxes, which are native windows controlled by native window manager.\n\n"
        "Main Window – the main NetBeans window containing main menu, toolbars, status line and in MDI mode also windows and document windows. In SDI the main window doesn't contain windows, neither document windows.\n\n"
        "Window– basic window system element, also called ""IDE Window"" in SDI. Note: Some images below use the old terminology and refer to Window as View.\n\n"
        "Document Window– a special type of window with different behavior and characteristics than regular window. Document Window is part of the window system. Some images below use the old terminology and refer to Document Window as Editor. \n\n"
        "Dialog Box – a special native window controlled by native window manager. Dialog boxes are not part on NetBeans window system, and are not covered by this spec. \n\n"
        "Window Area (View Area): The section within the main window used for arranging windows.\n\n"
        "Document Area (Editor Area): A part of the main window, within the Window Area, specifically for organizing Document Windows.\n\n"
        "Status Line (Status Bar): Displays the status of IDE actions — separate from status lines inside editor or explorer windows.\n\n",
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
        "Detailed Descriptions",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.yellow,
        ),
      ),
      SizedBox(height: 10),
      Text(
        "Main Window",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 16,
          color: Colors.yellow,
        ),
      ),
      SizedBox(height: 10),
      Text(
        "Main window is a container for application menu, toolbars, status line and windows which are provided and controlled by the window system. All of the windows are always displayed inside the main window, neither user can separate them out of the main window. The windows are shown in two areas depending on a type of displayed window. The areas are a document area and window area. The document area is used for document windows, and the window area lays out all of the other windows.",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 10),
      _clickableFlowchart("assets/images/Mainwindow.png"),
      SizedBox(height: 10),
      Text(
        "The main windows characteristics are following: \n\n"
        "title - title of main window contains the application name and might contain current project name if the project module is part of IDE distribution. The title pattern is following: ""<application_name> - <project_name>."" \n\n"
        "icon - icon of main window is the application icon \n\n",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    ],

    // Netbeanslayout
    [
      Text(
        "Netbeanslayout",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.yellow,
        ),
      ),
      SizedBox(height: 10),
      Text(
        "NetBeans layout is distributed in 4 main areas identified by itsnumbers in the graphic: \n\n"
        "o Control area \n\n"
        "o Reference area \n\n"
        "o Working area \n\n"
        "o Status area ",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 10),
      _clickableFlowchart("assets/images/Neatbean.png"),

      SizedBox(height: 10),
      Text(
        "a. Control Area Elements: \n\n"
        "Main menu –NetBeans main menu is located in the top of the NetBeans windows. You can access to it either by mouse or keyboard pressing F10 or Alt key, whatever of both. In any case notice as, when the main menu is activated, only one of its items is selected at the same time but all item words became with one letter underlined.\n\n"
        "Main menu offers always the same items and they are always active. When a main menu item is activated its associated submenu is unfolded. Submenu items are almost the same with very few changes but its state depends of the context. If an item can be applied in a certain context then it will appear enabled, if not it will be disabled, appearing in grey. This rule is the same for all submenus.",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 10),
      _clickableFlowchart("assets/images/Mainmenuofneatbeans.png"),
    ],


    // Quick launch bar
    [
      Text(
        "Quick launch bar",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.yellow,
        ),
      ),
      SizedBox(height: 10),
      Text(
        "Few of the most common used actions are available through quick launch bar icons. It is located between main menu and the other working areas. It is integrated by smaller and thematic quick launch bars called Toolbars.\n",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 10),
      _clickableFlowchart("assets/images/quicklaunchbar.png"),
      
    ],

    // Search tool
    [
      Text(
        "Search tool",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.yellow,
        ),
      ),
      SizedBox(height: 10),
      Text(
        "This tool let you find topic inside NetBeans topics. For source code or project searches there are other tools. You can find more information out here.",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 10),
      _clickableFlowchart("assets/images/searchtool.png"),
      SizedBox(height: 10),
      Text(
        "Reference Area - offers you related information/ resources/actions/ references/settings about the task/project you are working in. Each one of these items are represented by its own window called Reference Window. \n\n"
        "These windows are visible or not depending of circumstances but visible windows can float or stay docked in the framework. Visibility and access management of Reference Windows are available through Windows main menu item.\n\n"
        "Working area- it’s the main area of NetBeans IDE. Usually looks like and code edition area, but it’s also an User Interface visual compositor.\n\n"
        "Status area- it is basically a status bar at the bottom of NetBeans windows. It shows you the insert/overwriting status, cursor coordinates, upgrading status and some other info.\n\n",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    ],

    // Lesson 7 (index 6): WHAT IS A PSEUDOCODE? (Module 2)
    [
      Text(
        "Java Programming Environment",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.yellow,
        ),
      ),
      SizedBox(height: 10),
      Text(
        "Java is a recently developed, concurrent, class-based, object-oriented programming and runtime environment. \n\n" 
        "It is a powerful and an all-purpose programming environment that is in-demand as programming languages. \n\n" 
        "With its flexible features to create and run a program, it has been exceptionally successful in business and enterprise computing. \n\n" 
        "In this lesson, you will learn how to code your first Java Program in a simple and step-by-step manner. \n",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 10),
      Text(
        "Using a Text Editor and Console\n\n"
        
        "We will now use Notepad as our text editor in windows to save the code in the First Java Program. \n\n" 
        "We will also need to open the command prompt to compile and run the program. Take a look at the following codes. \n\n"
        "This is an example of a very simple program that you can run on your computer. Do you know how to do this? \n",  
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 10),
      _codeSnippet(
        "My First Java Program \n"
          " public class MyFirstJavaPrograms\n"
            " {\n"
              "  public static void main(String[] args) \n"
              " { \n"
                "  System.out.println (“Welcome to ICT!”); \n"
              " } \n"
            "} \n"
        ,
      ),
    ],

    // Step 1: Start the text editor.
    [
      Text(
        "Step 1: Start the text editor. \n"
        "To start the text editor or Notepad in Windows, you can follow these steps:",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.yellow,
        ),
      ),
      SizedBox(height: 10),
      Text(
        "1. Click “Start”. \n"
        "2. Click “All Programs”.\n"
        "3. Go to “Accessories”.\n"
        "4. Then, click “Notepad”. \n",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      
      SizedBox(height: 10),
      _clickableFlowchart("assets/images/WindowsNotepad.png"),
      
      
      
    ],

    // Step 2: Open the terminal.
    [
      Text(
        "Step 2: Open the terminal.\n"
        "To open Command Prompt in Windows, you can follow these steps: \n",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.yellow,
        ),
      ),
      Text(
        "1. Click “Start”. \n"
        "2. Click “All Programs”. \n"
        "3. Go to “Accessories”. \n"
        "4. Then, click “Command Prompt”."
        ,
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 10),
      _clickableFlowchart("assets/images/commandprompt.png"),
      SizedBox(height: 10),
      Text(
        "Step 3: Write the source code. \n"
        "In writing the source code, type the code found in MyFirstJavaPrograms in the Notepad. \n\n"

        "Step 4: Save your Java Program. \n"
        "To open the Save dialog box, follow this: \n"
        "1. Click “File” which is found on the menu bar. \n"
        "2. Then, click on “Save”. \n\n"

        "Filename: MyFirstJavaProgram.java \n"
        "Folder Name: MYJAVAPROGRAMS \n\n"

        "Note: If the folder MYFIRSTJAVAPROGRAMS does not exist yet, you will have to create the folder. "
        ,
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 10),
      _clickableFlowchart("assets/images/notepad1.png"),
      
    ],

    // ───────────────────────── MODULE 3 ─────────────────────────

    // Lesson 10 (index 9): Flowchart + Technical Terms
    [
      Text(
        "Step 5: Compiling your program. \n\n"
        "Go to the Command Prompt window \n"
        "Go to the folder MYFIRSTJAVAPROGRAMS where you saved the program \n\n"
        
        "Specify the path for the Java Development Kit \n\n" 
        "    TypePATH C:\Program Files\Java\jdk1.7.0_09\bin \n",
        
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.yellow,
        ),
      ),
      SizedBox(height: 10),
      Text(
        "Note: The path may vary for the specified folder in the installation of Java in your machine. \n\n"
        "To compile a Java Program, type in the command: javac[filename]\n\n" 
        "So, in this case, type in: javac MyFirstJavaPrograms.java during compilation, javac adds a file to the disk called [filename].class, or in this case, MyFirstJavaPrograms.class, which is the actual bytecode.\n\n"
        ,
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 10),
      _clickableFlowchart("assets/images/firstjavacommand.png"),
      
    ],

    // Lesson 11 (index 10): Flowchart Symbols + Brief Introduction
    [
      Text(
        "Step 6: Running the Program",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.yellow,
        ),
      ),
      SizedBox(height: 10),
      Text(
        "To run the Java Program:",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 20),
      Text(
        "Type java[filename without the extension] In the case of our example, type in:javaMyFirstJavaPrograms. You can see on the screen after running the program: “Welcome to ICT!” \n",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 10),
      _clickableFlowchart("assets/images/runjavacommand.png"),
      SizedBox(height: 10),
      Text(
        "Java Errors \n\n"
        
        "In MyFirstJavaPrograms example, we didn’t encounter any problems in compiling and running the program. However, in programming this is not always the case. In Java, there are two types of errors: Syntax Errors and Run-time Errors.",
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
        "1. Syntax Errors \n",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.yellow,
        ),
      ),
      SizedBox(height: 10),
      Text(
        "Syntax Errors occur after compilation of a Java Program. They are usually typing errors of the syntax of the Java source code. Java attempts to isolate the error by displaying the line of code and pointing to the first incorrect character in that line. However, the problem may not be at the exact point. \n\n"
        "Common syntax errors in Java are misspelled Java commands, or forgotten semicolon at the end of a statement. Other common mistakes are capitalization, spelling, use of incorrect special characters, and omission of correct punctuation. \n\n"
        "Example: In our MyFirstJavaProgram.java code, we intentionally omit one semicolon at the end of one statement and type a command incorrectly. The error messages are then generated after compiling the pr ogram.",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 10),
      _clickableFlowchart("assets/images/MyFirstJavaProgramsInc.png"),
      SizedBox(height: 10),
      _clickableFlowchart("assets/images/MyFirstJavaProgramserrs.png"),
      SizedBox(height: 10),
      Text(
        "The first and second error message suggests that there is an error on the declaration of an identifier of the main method. The third error message suggests that there is a missing semicolon by the end of a Java statement. \n\n"
        "As a rule of thumb, if you encounter a lot of error messages, try to connect the first mistake in a long list, and try to compile the program again. Doing so may reduce the total number of errors dramatically.",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    ],

    // Lesson 13 (index 12): A Flowchart
    [
      Text(
        "2. Run-time Errors",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 10),
      Text(
        "Run-time Errors are errors that will not display until you run or execute the program. Even programs that compile successfully may display wrong answers if the programmer has not thought the logical processes and structures of the program. \n",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 10),
      _clickableFlowchart("assets/images/IncrementDecrement.png"),
      SizedBox(height: 10),
      Text(
        "The increment and decrement operators can be placed before or after anoperand.",
        style: TextStyle(
          fontFamily: 'Jaro',
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 10),
      _codeSnippet(
          "public class MySecondJavaProgram\n"
            " {\n"
              "  public static void main (String[] args) \n"
              " { \n"
              "  int a= 2;"
              "  int b= 5;"
              "  System.out.println (“Variable value:”);"
              "  System.out.println (“a=” + a);"
              "  System.out.println (“b=” + b);" 
                "  System.out.println (“Welcome to ICT!”); \n"
              " } \n"
            "} \n"
        ,
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
              MaterialPageRoute(builder: (context) => JavaQ2FinalQuizPage()),
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
