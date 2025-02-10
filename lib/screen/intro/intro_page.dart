import 'package:flutter/material.dart';
import '../login/login_page.dart';
import '../../widgets/custom_buttom.dart';
import 'intro_screen.dart';
import 'intro_content.dart';  // 🔹 Import du fichier JSON
import '../../../utils/colors.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<Widget> _buildPageContent(BuildContext context) {
    return introPages.map((page) {
      return IntroScreen(
        lightImage: page["lightImage"]!,
        darkImage: page["darkImage"]!,
        title: page["title"]!,
        description: page["description"]!,
        buttonText: page["buttonText"]!,
      );
    }).toList();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = _buildPageContent(context);

    return Scaffold(
      body: Stack(  // Remplacer 'Container' par 'Stack' pour gérer les éléments empilés
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.getGradient(context), // Dégradé dynamique depuis la méthode AppColors
            ),
          ),
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: pages,
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _currentPage != pages.length - 1
                    ? TextButton(
                  onPressed: () {
                    _pageController.jumpToPage(pages.length - 1);
                  },
                  child: const Text('Skip'),
                )
                    : const SizedBox.shrink(),
                Row(
                  children: List.generate(pages.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        color: _currentPage == index ? Colors.blue : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
                _currentPage != pages.length - 1
                    ?
                CustomButton(
                  text: "Suivant",
                  color: Colors.blue,
                  borderRadius: 8,
                    fontSize: 12.0,
                    //fontFamily: 'Arial',
                    showBorder: true,  // Affiche le contour
                    showBackground: false,  // Affiche le fond
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  textColor: Colors.blue,
                  onPressed: () {
                    _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease);
                  }
                )
                    :
                CustomButton(
                  text: "Get Started",
                  color: Colors.green,
                  borderRadius: 8,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  textColor: Colors.white,
                  route: '/LoginPage',
                  context: context,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
