import 'package:feedback_app/mainloginpage.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _speakerAnimation;
  late Animation<Offset> _textAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    // Define animation for the speaker icon
    _speakerAnimation = Tween<Offset>(
      begin:
          Offset(-8.5, -0.2), // Start at the center with slight upward offset
      end: Offset(1.5, -0.2), // Move to the right off-screen
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Define animation for the text
    _textAnimation = Tween<Offset>(
      begin: Offset(-10.5,
          0.2), // Start off-screen on the left with slight downward offset
      end: Offset(0, 0.2), // Move to the center
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Start the animation
    _startAnimation();
  }
  void _startAnimation() async {
    await _controller.forward();
    // After the animation completes, navigate to the login page
    Future.delayed(Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => LoginButtons()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xEBFFFFFF),
      body: Center(
        child: OverflowBox(
          maxWidth: double.infinity,
          maxHeight: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none, // Ensures nothing is cut off
            children: [
              SlideTransition(
                position: _speakerAnimation,
                child: Transform.translate(
                  offset: Offset(40, 0), // Top-right positioning
                  child: Icon(
                    Icons.campaign, // Speaker symbol
                    size: 60, // Keep the original size
                    color: Color(0xff2e73ae),
                  ),
                ),
              ),
              SlideTransition(
                position: _textAnimation,
                child: Text(
                  "CampusVoices",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff2e73ae),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

