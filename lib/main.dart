// CHECKPOINT 4 — Interact (StatefulWidget, setState, GestureDetector)
// FINAL VERSION — copy this into lib/main.dart
//
// BEFORE RUNNING: add your photo to the project (see the profile picture
// section below and the pubspec.yaml steps).

// Gives us all of Flutter's Material widgets: Text, Card, Icon, Scaffold...
// Nothing below works without this line.
import 'package:flutter/material.dart';

// main() is where every Dart program starts.
// runApp() takes our root widget (MyApp) and puts it on the screen.
void main() {
  runApp(const MyApp());
}

// ─────────────────────────────────────────────────────────────
// MyApp: the root of the app.
// It never changes, so it's a StatelessWidget.
// ─────────────────────────────────────────────────────────────
class MyApp extends StatelessWidget {
  // Constructor. "super.key" passes an optional key to the parent class.
  // You can ignore it for now: every widget has this line.
  const MyApp({super.key});

  // build() describes what this widget looks like.
  // Flutter calls it whenever it needs to draw the widget.
  @override
  Widget build(BuildContext context) {
    // MaterialApp sets up the whole app: theme, navigation, first screen.
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // hides the red "DEBUG" ribbon
      home: BusinessCard(), // the first screen the app shows
    );
  }
}

// ─────────────────────────────────────────────────────────────
// BusinessCard: our screen.
// Things on it change (dark mode, the email, the likes),
// so it's a StatefulWidget.
// A StatefulWidget is always made of TWO classes:
//   1. the widget itself (this one), which only creates its State
//   2. the State class (below), which holds the data and the build()
// ─────────────────────────────────────────────────────────────
class BusinessCard extends StatefulWidget {
  const BusinessCard({super.key});

  // Creates the State object that will hold our changing data.
  @override
  State<BusinessCard> createState() => _BusinessCardState();
}

// The underscore (_) at the start of the name makes the class private:
// it can only be used inside this file.
class _BusinessCardState extends State<BusinessCard> {
  // ── THE STATE ──────────────────────────────────────────────
  // Data that can change while the app runs.
  // When it changes (inside setState), build() runs again.
  bool isDark = true; // dark mode on or off? starts in dark mode
  bool showEmail = false; // is the email visible? starts hidden
  int likes = 0; // how many times the heart was tapped

  @override
  Widget build(BuildContext context) {
    // ── COLORS FOR EACH MODE ─────────────────────────────────
    // Each color is chosen with the conditional operator:
    //   condition ? valueIfTrue : valueIfFalse
    // Every time isDark changes, build() runs again and
    // all these colors are recalculated.
    final Color backgroundColor =
        isDark ? const Color(0xFF0E1B33) : const Color(0xFFF4F7FB);
    final Color textColor =
        isDark ? Colors.white : const Color(0xFF0E1B33);
    final Color accentColor =
        isDark ? const Color(0xFF5BC8F5) : const Color(0xFF0468D7);
    final Color cardColor =
        isDark ? const Color(0xFF1B2A47) : Colors.white;

    // Scaffold = the skeleton of one screen.
    return Scaffold(
      // Background color of the whole screen, depends on the mode.
      backgroundColor: backgroundColor,

      // ── TOP BAR WITH THE DARK MODE BUTTON ──────────────────
      // A transparent AppBar: we only use it to hold the button.
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, // no shadow under the bar
        // actions = widgets shown on the right side of the AppBar
        actions: [
          IconButton(
            // Show a sun in dark mode (tap to go light),
            // and a moon in light mode (tap to go dark).
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: textColor,
            ),
            onPressed: () {
              // setState tells Flutter: "the data changed, redraw!"
              setState(() {
                isDark = !isDark; // ! flips true <-> false
              });
            },
          ),
        ],
      ),

      // SafeArea keeps content away from the notch and the status bar.
      body: SafeArea(
        // Center puts its child in the middle of the screen.
        child: Center(
          // Column stacks its children vertically, top to bottom.
          child: Column(
            // Centers the children vertically inside the Column.
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── PROFILE PICTURE ──────────────────────────────
              // Two CircleAvatars, one inside the other:
              // the outer one (radius 64) is slightly bigger and
              // makes a colored ring around the photo.
              CircleAvatar(
                radius: 64,
                backgroundColor: accentColor,
                // The inner one shows the photo. radius 60 = 120 px wide.
                child: const CircleAvatar(
                  radius: 60,
                  // AssetImage loads a picture stored IN the project.
                  // 1. Create a folder named "assets" at the project root
                  //    (next to lib/ and pubspec.yaml)
                  // 2. Put your photo inside it, named luffy.jpg
                  // 3. Declare it in pubspec.yaml (see the steps)
                  backgroundImage: AssetImage('luffy.jpg'),
                  // Alternative, a picture from the internet (no setup):
                  // backgroundImage: NetworkImage('https://picsum.photos/300'),
                ),
              ),

              // An empty box used as a 16-pixel vertical gap.
              const SizedBox(height: 16),

              // ── NAME ─────────────────────────────────────────
              // Not const anymore: its color depends on the mode.  
              Text(
                'Your Name',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),

              // ── JOB TITLE ────────────────────────────────────
              Text(
                'FLUTTER DEVELOPER',
                style: TextStyle(
                  fontSize: 16,
                  letterSpacing: 2.5, // space between the letters
                  fontWeight: FontWeight.w600, // semi-bold
                  color: accentColor,
                ),
              ),

              const SizedBox(height: 24),

              // ── PHONE CARD ───────────────────────────────────
              Card(
                color: cardColor, // card background, depends on the mode
                // margin = space OUTSIDE the card
                // (32 left and right, 8 above and below)
                margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                // Padding = space INSIDE the card, around the content
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  // Row places its children side by side, left to right.
                  child: Row(
                    children: [
                      Icon(Icons.phone, color: accentColor),
                      const SizedBox(width: 16), // horizontal gap this time
                      Text(
                        '+216 12 345 678',
                        style: TextStyle(fontSize: 18, color: textColor),
                      ),
                    ],
                  ),
                ),
              ),

              // ── EMAIL CARD (interactive) ─────────────────────
              // GestureDetector makes any widget react to touches.
              // Here, a tap anywhere on the card shows or hides the email.
              GestureDetector(
                onTap: () {
                  // Without setState, showEmail would change
                  // but the screen would NOT update.
                  setState(() {
                    showEmail = !showEmail;
                  });
                },
                child: Card(
                  color: cardColor,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.email, color: accentColor),
                        const SizedBox(width: 16),
                        Text(
                          // Show the email, or a hint, depending on showEmail
                          showEmail ? 'you@example.com' : 'Tap to show email',
                          style: TextStyle(fontSize: 18, color: textColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── LIKE COUNTER ─────────────────────────────────
              Row(
                // Centers the heart and the number horizontally.
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // IconButton = an icon you can tap, with a ripple effect.
                  IconButton(
                    iconSize: 36,
                    icon: Icon(
                      // Empty heart at 0 likes, filled heart after that.
                      likes > 0 ? Icons.favorite : Icons.favorite_border,
                      color: const Color(0xFFFF8A4C),
                    ),
                    // What happens on tap: add 1 to likes and redraw.
                    onPressed: () {
                      setState(() {
                        likes++; // same as likes = likes + 1
                      });
                    },
                  ),

                  // Shows the number of likes.
                  // '$likes' puts the variable's value inside the text.
                  Text(
                    '$likes',
                    style: TextStyle(fontSize: 22, color: textColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}