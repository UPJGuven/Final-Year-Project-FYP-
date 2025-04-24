import 'package:flutter/material.dart';
import 'goal_hierarchy_screen.dart';

class HelpGuidanceScreen extends StatefulWidget {
  final bool showOnComplete; // boolean for whether or not first time sign-in

  HelpGuidanceScreen({this.showOnComplete = true});

  // defaults showOnComplete to true for first time sign-ins
  // accessing HelpGuidanceScreen() from the goal hierarchy sets this to false.

  @override
  _HelpGuidanceScreenState createState() => _HelpGuidanceScreenState();
}

class _HelpGuidanceScreenState extends State<HelpGuidanceScreen> {
  final PageController _controller = PageController();
  final List<ScrollController> _scrollControllers = [];
  int _currentPage = 0;

  // controllers for the swipe page feature and scroll bar.

  @override
  void initState() {
    super.initState();
    _scrollControllers
        .addAll(List.generate(_advicePages.length, (_) => ScrollController()));
  }

  // create a ScrollController for each page to allow individual control of scrollbars

  @override
  void dispose() {
    _controller.dispose();
    _scrollControllers.forEach((c) => c.dispose());
    super.dispose();
  }

  // dispose each ScrollController to free up memory and avoid leaks

  final List<Map<String, dynamic>> _advicePages = [ // Page Information
    {
      'title': 'Welcome to Higher-Arc!',
      'image': 'assets/images/FYP Logo v1.0 No Line.png',
      'text': [
        'This screen contains help and guidance for using the app, goal-setting, goal hierarchies and how to create them!',
        'You can visit this page at anytime by pressing the "i" icon in the top right of the goal hierarchy screen.',
        'Swipe left/right to navigate through and also scroll up/down to see all information!'
      ]
    },
    {
      'title': 'What is Higher-Arc?',
      'image': 'assets/images/FYP What is Higher-Arc.png',
      'text': [
        'Higher-Arc is a hierarchical goal-setting mobile application designed to help users visualize, manage and track personal growth by organising goals into hierarchies of meaningful and actionable high, medium and low-level goals.',
        'Higher-Arc lets you set goals, create your own goal hierarchy, track your progress and create your own to-do list!'
      ]
    },
    {
      'title': 'What is a Goal Hierarchy?',
      'image': 'assets/images/FYP Chef Goal.png',
      'text': [
        'A goal hierarchy is a collection of goals that all work towards to achieving an ultimate end-goal.',
        'If done properly, creating a goal hierarchy will naturally produce an actionable plan to achieve your goals, while also prompting a potential motivation behind why.',
        'Shown above is an example of a high-level goal, this is so as it is a long-term pursuit and has some difficulty in its achievement.',
        'Swipe right to see how we can make a goal hierarchy out of this goal!'
      ]
    },
    {
      'title': 'Becoming a Professional Chef',
      'image': 'assets/images/FYP Cooking tree edit.png',
      'text': [
        'To create a hierarchy, we need to create new goals from our existing high-level goal. These are known as "Parent" and "Sub" goals.',
        'In the above example we have created 1 Parent goal and 3 Subgoals with 3 more Subgoals.',
        'This is done by asking yourself two questions:"How you are going to achieve this goal?" and "Why do you want to achieve this goal?" ...'
      ]
    },
    {
      'title': 'The "How?" and "Why?"',
      'image': 'assets/images/FYP Why and How.png',
      'text': [
        'Taking a closer look at the example, we can see that the goal "Gain real kitchen experience" is one step in HOW you "Become a professional Chef...".',
        '"Live to share joy, culture and creativity through food" is a potential "Why?" to becoming a professional chef',
        'Coming up with a High-level "Why? " is tricky but try to make them meaningful, personal and abstract'
        'Once you can\'t come up with another "Why?", you have most likely found your ultimate end-goal.',
        'If you can find your ultimate end-goal you will have hopefully unlocked a motive for all your goals.',
      ]
    },
    {
      'title': 'Goal-Setting Advice',
      'image': 'assets/images/FYP View Cooking Goal.png',
      'text': [
        'Goals should be specific, measurable, achievable, realistic and time-bound while still difficult.',
        'The goal shown above meets this criteria.',
        'However, once set, goals can fail without proper maintenance.',
        'Regularly review and revise your goals to ensure they remain relevant to you and attainable if circumstances change.',
        'It is perfectly ok, and recommended, to change, pause or stop medium/low-level goals if they no longer align with what you want!',
        'The same goes for high-level goals however deeper thought should be required.',
        'Remember to break down your goals into manageable "How?" sub-goals!'
      ]
    },
    {
      'title': 'How to use Higher-Arc',
      'image': 'assets/images/FYP Logo v1.0 No Line.png',
      'text': [
        'Now you know what Higher-Arc is all about, it is time to learn how to use the app!',
        'Swipe right to continue!'
      ]
    },
    {
      'title': 'Creating your first goal',
      'image': 'assets/images/FYP Add First Goal.png',
      'text': [
        'To create your first goal, press the orange "+" icon to start.',
        'Fill out the goal\'s name, description, start/end date and finally press "Create goal".',
        'Your goal should now be created and presented in the goal hierarchy screen!'
      ]
    },
    {
      'title': 'Viewing Goals',
      'image': 'assets/images/FYP View Goal.png',
      'text': [
        'To view a goal, simply press and hold on a goal to open up the goal.',
        'Here you can see all the goal details with the option to "Edit", create "Subgoal", create "Parent Goal" and "Delete".',
        'Here you can also see the progression meter, simply press and slide to increase your progress %'
      ]
    },
    {
      'title': 'Creating Parent and Subgoals',
      'image': 'assets/images/FYP Parent Goal .png',
      'text': [
        'To create parent and subgoals, press either "Parent goal" or "Sub goal" when viewing a goal.',
        'Fill out the new goal\'s details as outlined before to create your new parent or subgoal.',
        'Note! Each goal can only have one parent but each parent can have many subgoals!'
      ]
    },
    {
      'title': 'Progress',
      'image': 'assets/images/FYP Goal Progress Screen.png',
      'text': [
        'Pressing the "%" navigation tile at the bottom of your screen will take you to progress screen',
        'Here you can see all your progression towards your goals. You can filter by "All", "In Progress", "Completed" and "Not Started".',
        'The progression bar is also shown on each goal on the goal hierarchy screen'
        'Note! You can view each goal by pressing and holding, just like on the goal hierarchy screen.'
      ]
    },
    {
      'title': 'To-Do List',
      'image': 'assets/images/FYP To-do Task Screen.png',
      'text': [
        'Pressing the checklist navigation tile at the bottom of your screen will take you to the "To-do" screen.',
        'Here you can create to-do list items by pressing the orange "+" icon and pressing the to-do item to type out your to-do.',
        'You can re-order items by pressing and dragging up/down the drag icon. Items can also be deleted by pressing the delete icon.'
      ]
    },
  ];

  void _goToMainApp() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => GoalHierarchyScreen()),
    );
  }

 // Navigate to goal hierarchy screen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Help & Guidance",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 8),
            Image.asset('assets/images/FYP Logo No Text v1.0.png', height: 30),
          ],
        ),
        automaticallyImplyLeading:
            !widget.showOnComplete, // Show back arrow button only when not first-time user
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                  controller: _controller,
                  itemCount: _advicePages.length,
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  itemBuilder: (context, index) {
                    final page = _advicePages[index];

                    // logic to navigate through _advicePages

                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Scrollbar(
                        controller: _scrollControllers[index],
                        thumbVisibility: true,
                        thickness: 6,
                        radius: Radius.circular(8),
                        child: SingleChildScrollView(
                          controller: _scrollControllers[index],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 16),
                              Image.asset(
                                page['image'] ?? '',
                                height: 250,
                                width: double.infinity,
                                fit: BoxFit.scaleDown,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(
                                  page['title'] ?? '',
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              ...List.generate((page['text'] as List).length, // generates multiple blue advice containers
                                  (i) {
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 8),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.blue[500]!, Colors.blue[600]!],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 4)),
                                    ],
                                  ),
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    page['text'][i],
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                );
                              }),

                              if (index == _advicePages.length - 1 &&
                                  widget.showOnComplete)
                                // show Get Started button if on the last page and is first time user.
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: ElevatedButton(
                                    onPressed: _goToMainApp,
                                    child: Text("Get Started"),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),

            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _advicePages.length,
                (index) => AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 6),
                  height: 10,
                  width: _currentPage == index ? 18 : 10,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Colors.blue
                        : Colors.orange[600],
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),

            // Page indicator dots

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
