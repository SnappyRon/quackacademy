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
            "Apply Basics of Java Language",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "What is an IDE?\n\n"
            "IDE stands for Integrated Development Environment. It's a tool that helps you write and build programs easily. Instead of using many separate tools, an IDE puts everything you need in one place.\n\n"
            "One good example is NetBeans. It's free and works on Windows, macOS, and Linux. You can use it to make apps for desktop, mobile, and the web.\n\n"
            "NetBeans supports many languages like Java, HTML, PHP, and C++. It also helps with the full process — from writing your code to testing and running it.\n\n"
            "It works great with Java tools like JDK 8, Java EE 7, and JavaFX. It also supports GlassFish Server, which is used for building and testing Java web apps.",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ],

        // Lesson 2 (index 1)
        [
          Text(
            "User Interface Specification: Window System",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              children: [
                TextSpan(
                    text:
                        "The window system is the part of the IDE that shows all the different windows you use while coding. It lets you arrange them the way you like so you can work more comfortably.\n\n"),
                TextSpan(text: "Key features of the window system:\n"),
                TextSpan(text: "1. "),
                TextSpan(
                    text: "Document-focused",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        " – Your code files (documents) are the main focus.\n"),
                TextSpan(text: "2. "),
                TextSpan(
                    text: "Simple",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: " – Only shows what you need. Not cluttered.\n"),
                TextSpan(text: "3. "),
                TextSpan(
                    text: "Customizable",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        " – You can adjust the layout or add your own tools/modules.\n"),
                TextSpan(text: "4. "),
                TextSpan(
                    text: "Keyboard-friendly",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        " – You can use all features with just the keyboard.\n\n"),
                TextSpan(text: "Important terms to know:\n\n"),
                TextSpan(
                    text: "Window System",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        " – Controls how windows inside the IDE behave. It does not control pop-up boxes (dialogs), which are handled by your computer’s system.\n\n"),
                TextSpan(
                    text: "Main Window",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        " – The main part of NetBeans. It includes the menu bar, toolbars, status bar, and other windows (in MDI mode). In SDI mode, it only shows the menu and toolbar.\n\n"),
                TextSpan(
                    text: "Window",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        " – A basic panel inside the IDE, also called an IDE Window. Some older versions call this a 'View.'\n\n"),
                TextSpan(
                    text: "Document Window",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        " – A special window used to edit code. It's different from other windows and may be called 'Editor' in older versions.\n\n"),
                TextSpan(
                    text: "Dialog Box",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        " – A pop-up window, like when you save a file or change settings. These are controlled by your computer, not the IDE.\n\n"),
                TextSpan(
                    text: "Window Area",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        " – The space inside the main window where other windows are placed.\n\n"),
                TextSpan(
                    text: "Document Area",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        " – A special part of the Window Area that holds your code editors (Document Windows).\n\n"),
                TextSpan(
                    text: "Status Line (Status Bar)",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        " – Shows updates and information about what the IDE is doing. It's different from status lines inside editors or tools.\n\n"),
              ],
            ),
          ),
        ],

        // Lesson 3 (index 2)
        [
          Text(
            "Detailed Descriptions",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Main Window",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "The main window is the main container of the IDE. It holds the menu bar, toolbars, status bar, and other windows.\n\n"
            "All windows stay inside the main window — you can't drag them outside. These windows are shown in two main sections:\n"
            "- The Document Area: where code and text files open.\n"
            "- The Window Area: where tools like project explorers, output panels, or search windows are displayed.",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          _clickableFlowchart("assets/images/Mainwindow.png"),
          SizedBox(height: 10),
          Text(
            "Main window features:\n\n"
            "• Title – Shows the app name and, if you're working with a project, the project name too.\n"
            "   Example format: AppName - ProjectName\n\n"
            "• Icon – The main window uses the app’s icon.",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ],

        // Netbeanslayout
        [
          Text(
            "NetBeans Layout",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              children: [
                TextSpan(
                    text:
                        "The NetBeans layout is divided into four main areas, as shown in the graphic:\n\n"),
                TextSpan(
                    text: "• ", style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: "Control Area\n"),
                TextSpan(
                    text: "• ", style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: "Reference Area\n"),
                TextSpan(
                    text: "• ", style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: "Working Area\n"),
                TextSpan(
                    text: "• ", style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: "Status Area\n"),
              ],
            ),
          ),
          SizedBox(height: 10),
          _clickableFlowchart("assets/images/Neatbean.png"),
          SizedBox(height: 10),
          Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              children: [
                TextSpan(text: "Control Area Elements:\n\n"),
                TextSpan(
                    text: "Main Menu – ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        "Located at the top of the NetBeans window. You can access it using your mouse or by pressing "),
                TextSpan(
                    text: "F10", style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: " or the "),
                TextSpan(
                    text: "Alt", style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: " key on your keyboard.\n\n"),
                TextSpan(
                    text:
                        "When the menu is active, one menu item is always selected, and you'll notice one letter in each item is underlined to help with keyboard navigation.\n\n"),
                TextSpan(
                    text:
                        "The main menu always shows the same items, and they are always active. When you open a menu item, a submenu appears. These submenus are usually consistent, but some items may be enabled or disabled depending on the context.\n\n"),
                TextSpan(
                    text: "Enabled items",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: " can be used at that moment. "),
                TextSpan(
                    text: "Disabled items",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        " are grayed out and not available based on what you're doing."),
              ],
            ),
          ),
          SizedBox(height: 10),
          _clickableFlowchart("assets/images/Mainmenuofneatbeans.png"),
        ],

        // Quick launch bar
        [
          Text(
            "Quick Launch Bar",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              children: [
                TextSpan(text: "The "),
                TextSpan(
                    text: "Quick Launch Bar",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        " gives you fast access to commonly used actions through icons.\n\n"),
                TextSpan(text: "It is located between the "),
                TextSpan(
                    text: "Main Menu",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: " and the main working areas of the IDE.\n\n"),
                TextSpan(
                    text:
                        "The Quick Launch Bar is made up of smaller sections called "),
                TextSpan(
                    text: "Toolbars",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ", each grouping related tools by function."),
              ],
            ),
          ),
          SizedBox(height: 10),
          _clickableFlowchart("assets/images/quicklaunchbar.png"),
        ],

        // Search tool
        [
          Text(
            "Search Tool",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              children: [
                TextSpan(text: "The "),
                TextSpan(
                    text: "Search Tool",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        " helps you quickly find topics within the NetBeans documentation and interface.\n\n"),
                TextSpan(
                    text:
                        "Note: This tool is for general topic searches only. To search source code or project files, NetBeans provides different tools for that."),
              ],
            ),
          ),
          SizedBox(height: 10),
          _clickableFlowchart("assets/images/searchtool.png"),
          SizedBox(height: 10),
          Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              children: [
                TextSpan(
                    text: "Reference Area – ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        "Provides related information, actions, settings, and resources connected to your current task or project. Each item is shown in its own window, called a "),
                TextSpan(
                    text: "Reference Window",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ".\n\n"),
                TextSpan(
                    text:
                        "These windows may appear or hide depending on what you're doing. Visible windows can either float or stay docked. You can control them through the "),
                TextSpan(
                    text: "Windows",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: " menu.\n\n"),
                TextSpan(
                    text: "Working Area – ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        "This is the main area of the NetBeans IDE. It usually looks like a code editor, but it can also be used as a visual interface designer.\n\n"),
                TextSpan(
                    text: "Status Area – ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        "This is the status bar at the bottom of the IDE. It shows information like text mode (insert/overwrite), cursor position, update status, and more."),
              ],
            ),
          ),
        ],

        // Lesson 7 (index 6): WHAT IS A PSEUDOCODE? (Module 2)
        [
          Text(
            "Java Programming Environment",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              children: [
                TextSpan(text: "Java is a "),
                TextSpan(
                    text: "class-based",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ", "),
                TextSpan(
                    text: "object-oriented",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ", and "),
                TextSpan(
                    text: "concurrent",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text: " programming language and runtime environment.\n\n"),
                TextSpan(
                    text:
                        "It’s a powerful, general-purpose programming language that is widely used in business and enterprise applications.\n\n"),
                TextSpan(
                    text:
                        "Because of its flexibility and ability to run programs on different platforms, Java has become one of the most popular programming environments.\n\n"),
                TextSpan(
                    text: "In this lesson, you'll learn how to create your "),
                TextSpan(
                    text: "first Java program",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: " step by step."),
              ],
            ),
          ),
          SizedBox(height: 10),
          Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              children: [
                TextSpan(
                    text: "Using a Text Editor and Console\n\n",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: "We’ll use "),
                TextSpan(
                    text: "Notepad",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        " as a basic text editor on Windows to write our Java code.\n\n"),
                TextSpan(text: "To run the program, you'll use the "),
                TextSpan(
                    text: "Command Prompt",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: " to compile and execute it.\n\n"),
                TextSpan(
                    text:
                        "Here’s a very simple Java program. You can try typing this into Notepad and running it through your command line.\n\n"),
              ],
            ),
          ),
          SizedBox(height: 10),
          _codeSnippet(
            "My First Java Program\n"
            "public class MyFirstJavaProgram {\n"
            "  public static void main(String[] args) {\n"
            "    System.out.println(\"Welcome to ICT!\");\n"
            "  }\n"
            "}",
          ),
        ],

        // Step 1: Start the text editor.
        [
          Text(
            "Step 1: Start the text editor. \n"
            "To start the text editor or Notepad in Windows, you can follow these steps:",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "1. Click “Start”. \n"
            "2. Click “All Programs”.\n"
            "3. Go to “Accessories”.\n"
            "4. Then, click “Notepad”. \n",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          _clickableFlowchart("assets/images/WindowsNotepad.png"),
        ],

        // Step 2: Open the terminal.
        [
          Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              children: [
                TextSpan(text: "Step 2: Open the Terminal\n\n"),
                TextSpan(
                  text:
                      "To open Command Prompt in Windows, follow these steps:\n",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              children: [
                TextSpan(text: "1. Click "),
                TextSpan(
                    text: "Start\n",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: "2. Click "),
                TextSpan(
                    text: "All Programs\n",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: "3. Go to "),
                TextSpan(
                    text: "Accessories\n",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: "4. Click "),
                TextSpan(
                    text: "Command Prompt\n",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          SizedBox(height: 10),
          _clickableFlowchart("assets/images/commandprompt.png"),
          SizedBox(height: 10),
          Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              children: [
                TextSpan(
                  text: "Step 3: Write the Source Code\n\n",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                    text:
                        "Open Notepad and type the Java code from your MyFirstJavaProgram example.\n\n"),
                TextSpan(
                  text: "Step 4: Save Your Java Program\n\n",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: "To save your file in Notepad:\n"),
                TextSpan(text: "1. Click "),
                TextSpan(
                    text: "File",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: " on the menu bar\n"),
                TextSpan(text: "2. Then click "),
                TextSpan(
                    text: "Save\n\n",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: "Save with the following details:\n"),
                TextSpan(
                    text: "Filename: ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: "MyFirstJavaProgram.java\n"),
                TextSpan(
                    text: "Folder Name: ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: "MYJAVAPROGRAMS\n\n"),
                TextSpan(
                  text: "Note: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: "If the folder "),
                TextSpan(
                    text: "MYJAVAPROGRAMS",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: " does not exist yet, create it before saving."),
              ],
            ),
          ),
          SizedBox(height: 10),
          _clickableFlowchart("assets/images/notepad1.png"),
        ],

        // ───────────────────────── MODULE 3 ─────────────────────────

        // Lesson 10 (index 9): Flowchart + Technical Terms
        [
          Text(
            "Step 5: Compiling Your Program",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              children: [
                TextSpan(text: "1. Open the "),
                TextSpan(
                    text: "Command Prompt",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ".\n\n"),
                TextSpan(
                    text:
                        "2. Navigate to the folder where your program is saved:\n"),
                TextSpan(
                  text: "   MYFIRSTJAVAPROGRAMS\n\n",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                    text:
                        "3. Set the path for the Java Development Kit (JDK):\n"),
                TextSpan(text: "   Type the following command:\n"),
                TextSpan(
                  text: "   PATH=C:\\Program Files\\Java\\jdk1.7.0_09\\bin\n\n",
                  style: TextStyle(fontFamily: 'monospace'),
                ),
                TextSpan(
                  text: "Note: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                    text:
                        "The path might be different based on where Java is installed on your computer.\n\n"),
                TextSpan(
                    text:
                        "4. To compile your Java program, type the following command:\n"),
                TextSpan(
                  text: "   javac MyFirstJavaProgram.java\n\n",
                  style: TextStyle(fontFamily: 'monospace'),
                ),
                TextSpan(text: "After compilation, a file named "),
                TextSpan(
                  text: "MyFirstJavaProgram.class",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                    text:
                        " will be created. This is the compiled bytecode that can be run by the Java Virtual Machine (JVM)."),
              ],
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
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "To run the Java program:",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          Text.rich(
            TextSpan(
              style: TextStyle(fontSize: 18, color: Colors.white),
              children: [
                TextSpan(text: "Type the following command in the "),
                TextSpan(
                    text: "Command Prompt",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ":\n\n"),
                TextSpan(
                  text: "   java MyFirstJavaProgram\n\n",
                  style: TextStyle(fontFamily: 'monospace'),
                ),
                TextSpan(text: "This runs the compiled Java class.\n\n"),
                TextSpan(
                    text:
                        "If everything is correct, you'll see the message:\n"),
                TextSpan(
                  text: "   Welcome to ICT!\n",
                  style: TextStyle(fontFamily: 'monospace'),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          _clickableFlowchart("assets/images/runjavacommand.png"),
          SizedBox(height: 10),
          Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
              children: [
                TextSpan(
                  text: "Java Errors\n\n",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                    text:
                        "In this example, we didn't have any errors. But in real programming, errors are common.\n\n"),
                TextSpan(text: "Java has two main types of errors:\n"),
                TextSpan(text: "• "),
                TextSpan(
                    text: "Syntax Errors",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        " – mistakes in code structure, like missing semicolons or wrong spelling.\n"),
                TextSpan(text: "• "),
                TextSpan(
                    text: "Run-time Errors",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        " – errors that occur when the program is running, like dividing by zero or accessing something that doesn’t exist."),
              ],
            ),
          ),
        ],

        // Lesson 12 (index 11): What is a Flowchart?
        [
          Text(
            "1. Syntax Errors",
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
                TextSpan(text: "Syntax errors happen "),
                TextSpan(
                    text: "during compilation",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        " of a Java program. These are mistakes in how the code is written — often caused by typos or incorrect punctuation.\n\n"),
                TextSpan(
                    text:
                        "Java helps you find these errors by showing the line of code with the issue and pointing to the first character that seems wrong. But keep in mind — the actual problem may be earlier in the code.\n\n"),
                TextSpan(text: "Common syntax errors include:\n"),
                TextSpan(text: "• Misspelled commands\n"),
                TextSpan(text: "• Missing semicolons\n"),
                TextSpan(text: "• Wrong capitalization\n"),
                TextSpan(text: "• Incorrect special characters\n"),
                TextSpan(text: "• Missing punctuation\n\n"),
                TextSpan(text: "Example:\n"),
                TextSpan(text: "In our "),
                TextSpan(
                    text: "MyFirstJavaProgram.java",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        " file, we removed a semicolon and purposely typed a command incorrectly. Let’s look at what happens."),
              ],
            ),
          ),
          SizedBox(height: 10),
          _clickableFlowchart("assets/images/MyFirstJavaProgramsInc.png"),
          SizedBox(height: 10),
          _clickableFlowchart("assets/images/MyFirstJavaProgramserrs.png"),
          SizedBox(height: 10),
          Text.rich(
            TextSpan(
              style: TextStyle(fontSize: 18, color: Colors.white),
              children: [
                TextSpan(text: "The error messages tell us:\n\n"),
                TextSpan(
                    text:
                        "• The first and second messages point to an issue with the "),
                TextSpan(
                    text: "main method declaration.\n",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: "• The third message shows there's a "),
                TextSpan(
                    text: "missing semicolon",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: " at the end of a statement.\n\n"),
                TextSpan(
                    text: "Tip:\n",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        "If you see a long list of error messages, focus on fixing the "),
                TextSpan(
                    text: "first one",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        ". Often, fixing it will make the rest of the errors disappear."),
              ],
            ),
          ),
        ],

        // Lesson 13 (index 12): A Flowchart
        [
          Text(
            "2. Run-time Errors",
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
                TextSpan(text: "Run-time errors happen "),
                TextSpan(
                    text: "while the program is running",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        ". These errors won’t show up during compilation.\n\n"),
                TextSpan(
                    text:
                        "Even if a program compiles correctly, it might still give wrong results if the logic is incorrect or the program structure isn’t well planned.\n"),
              ],
            ),
          ),
          SizedBox(height: 10),
          _clickableFlowchart("assets/images/IncrementDecrement.png"),
          SizedBox(height: 10),
          Text.rich(
            TextSpan(
              style: TextStyle(fontSize: 18, color: Colors.white),
              children: [
                TextSpan(text: "Note: "),
                TextSpan(
                    text: "The ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: "increment (++) "),
                TextSpan(text: "and "),
                TextSpan(
                    text: "decrement (--) ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text:
                        "operators can be used before or after a variable (operand). This can affect how the value changes during execution.\n\n"),
                TextSpan(
                    text:
                        "Here’s an example Java program with integer variables and output statements:"),
              ],
            ),
          ),
          SizedBox(height: 10),
          _codeSnippet("public class MySecondJavaProgram {\n"
              "  public static void main(String[] args) {\n"
              "    int a = 2;\n"
              "    int b = 5;\n\n"
              "    System.out.println(\"Variable value:\");\n"
              "    System.out.println(\"a = \" + a);\n"
              "    System.out.println(\"b = \" + b);\n"
              "    System.out.println(\"Welcome to ICT!\");\n"
              "  }\n"
              "}"),
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
              MaterialPageRoute(builder: (context) => JavaQ2FinalQuizPage()),
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
