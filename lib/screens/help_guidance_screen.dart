import 'package:flutter/material.dart';
import '../main.dart';
import 'goal_hierarchy_screen.dart';
import 'main_screen.dart';

class HelpGuidanceScreen extends StatefulWidget {
  final bool showOnComplete;

  HelpGuidanceScreen({this.showOnComplete = true});

  @override
  _HelpGuidanceScreenState createState() => _HelpGuidanceScreenState();
}

class _HelpGuidanceScreenState extends State<HelpGuidanceScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _advicePages = [
    {
      'title': 'Welcome to Higher-Arc!',
      'image': 'assets/images/FYP Logo v1.0 No Line.png',
      'text': [
        'This page contains help and guidance for using the app, setting goals and creating goal hierarchies!',
        'Second box!'
      ]
    },
    {
      'title': 'What is Higher-Arch?',
      'image': 'assets/images/ShmooMoo_2025.png',
      'text': [
        'To create your first goal, click the orange "+" icon to start your goal hierarchy. Fill out the goal\'s name, description, start and end date.',
        'Your goal should now be created and presented in the goal hierarchy screen!'
      ]
    },
    {
      'title': 'Creating your first goal',
      'image': 'assets/images/ShmooMoo_2025.png',
      'text': [
        'To create your first goal, click the orange "+" icon to start your goal hierarchy.\nFill out the goal\'s name, description, start and end date.\n\nYour goal should now be created and presented in the goal hierarchy screen!',
        'Second box!'
      ]
    },
    {
      'title': 'Creating Parent and Subgoals',
      'image': 'assets/images/ShmooMoo_2025.png',
      'text': [
        'To create parent and subgoals, press and hold an existing goal to open the goal menu options and select the respective option.\n\nFill out the goal and your new goal should be connected.',
        'Second box!'
      ]
    },
    {
      'title': 'Stay Realistic',
      'image': 'assets/images/ShmooMoo_2025.png',
      'text': [
        'Set realistic timeframes. Deadlines help you stay motivated and on track.',
        'Second box!'
      ]
    },
    {
      'title': 'Be Flexible',
      'image': 'assets/images/ShmooMoo_2025.png',
      'text': [
        'Revisit and revise goals regularly. Flexibility is part of growth.',
        'Second box!'
      ]
    },
  ];

  void _goToMainApp() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => GoalHierarchyScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Help & Guidance"),
        automaticallyImplyLeading:
            !widget.showOnComplete, // Show back only when not first-time
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

                    return SingleChildScrollView(
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
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              page['title'] ?? '',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          // Multiple orange cards
                          ...List.generate((page['text'] as List).length, (i) {
                            return Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 12),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(12),
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
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: ElevatedButton(
                                onPressed: _goToMainApp,
                                child: Text("Get Started"),
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
            ),

            SizedBox(height: 10),

            // Page indicator dots
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
                    color: _currentPage == index ? Colors.black : Colors.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
