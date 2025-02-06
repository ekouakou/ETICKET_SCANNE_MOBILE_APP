import 'package:flutter/material.dart';
import 'login_page.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<Widget> _buildPageContent(BuildContext context) {
    return [
      IntroScreen(
        lightImage: 'assets/images/logo_1.png',
        darkImage: 'assets/images/logo_2.png',
        title: 'Grow your wealth with our investment options',
        description: 'Enjoy peace of mind with top-notch security and high returns.',
        buttonText: 'Get Started',
      ),
      IntroScreen(
        lightImage: 'assets/images/logo_1.png',
        darkImage: 'assets/images/logo_2.png',
        title: 'Set and stick to your budget',
        description: 'With our insights and real-time tracking, take control of your spending habits today.',
        buttonText: 'Next',
      ),
      IntroScreen(
        lightImage: 'assets/images/logo_1.png',
        darkImage: 'assets/images/logo_2.png',
        title: 'Manage your finance effortlessly',
        description: 'With our secure and user-friendly app, track expenses, save smartly, and invest wisely.',
        buttonText: 'Next',
      ),
    ];
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: _buildPageContent(context),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _currentPage != _buildPageContent(context).length - 1
                    ? TextButton(
                  onPressed: () {
                    _pageController.jumpToPage(_buildPageContent(context).length - 1);
                  },
                  child: Text('Skip'),
                )
                    : SizedBox.shrink(),
                Row(
                  children: List.generate(_buildPageContent(context).length, (index) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        color: _currentPage == index ? Colors.blue : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
                _currentPage != _buildPageContent(context).length - 1
                    ? ElevatedButton(
                  onPressed: () {
                    _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
                  },
                  child: Text('Next'),
                )
                    : ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text('Get Started'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class IntroScreen extends StatelessWidget {
  final String lightImage;
  final String darkImage;
  final String title;
  final String description;
  final String buttonText;

  IntroScreen({
    required this.lightImage,
    required this.darkImage,
    required this.title,
    required this.description,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    String image = isDarkMode ? darkImage : lightImage;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 70),
          SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}
