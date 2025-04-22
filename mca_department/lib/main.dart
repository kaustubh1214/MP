import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:expandable/expandable.dart';

void main() {
  runApp(MCAApp());
}

class MCAApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MCA Department App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  final bool isInitial;
  const SplashScreen({super.key, this.isInitial = true});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _opacityAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    Future.delayed(Duration(seconds: widget.isInitial ? 3 : 2), () {
      _controller.stop();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => widget.isInitial ? LoginScreen() : HomeScreen(),
        ),
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2A5C82), Color(0xFF5BA4D7), Color(0xFF8EC5F4)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(
                      opacity: _opacityAnimation.value,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/college_logo.jpg',
                          height: 120,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              const Text(
                'MCA Department',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Excellence in Computer Applications',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 40),
              CircularProgressIndicator(
                color: Colors.white.withOpacity(0.8),
                strokeWidth: 3,
              ),
              const SizedBox(height: 20),
              AnimatedText(
                texts: ['Loading...', 'Preparing...', 'Initializing...'],
                textStyle: const TextStyle(color: Colors.white60, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedText extends StatefulWidget {
  final List<String> texts;
  final TextStyle textStyle;

  const AnimatedText({super.key, required this.texts, required this.textStyle});

  @override
  _AnimatedTextState createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.texts.length;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _controller.value,
      duration: const Duration(milliseconds: 500),
      child: Text(widget.texts[_currentIndex], style: widget.textStyle),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    if (_usernameController.text == 'admin' &&
        _passwordController.text == 'password') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Invalid username or password')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2A5C82), Color(0xFF5BA4D7)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Welcome Back',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _login,
                        child: const Text('Sign In'),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Forgot Password?'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    FacultyInfo(),
    DeptInfo(),
    Notifications(),
    WebViewPage(),
    FeedbackForm(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MCA Department',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        elevation: 2,
      ),
      drawer: _buildModernDrawer(context),
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildModernDrawer(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      elevation: 10,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.95),
              Theme.of(context).primaryColor.withOpacity(0.8),
            ],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.background.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Image.asset('assets/college_logo.jpg', height: 40),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'MCA Department',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'SPIT, Mumbai',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(0, Icons.people_alt_outlined, 'Faculty'),
            _buildDrawerItem(1, Icons.school_outlined, 'Department Info'),
            _buildDrawerItem(2, Icons.notifications_outlined, 'Notifications'),
            _buildDrawerItem(3, Icons.public_outlined, 'Web Portal'),
            _buildDrawerItem(4, Icons.feedback_outlined, 'Feedback'),
            const Divider(color: Colors.white24, height: 40),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'v1.0.0',
                style: GoogleFonts.poppins(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(int index, IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color:
            _selectedIndex == index
                ? Colors.white.withOpacity(0.15)
                : Colors.transparent,
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        selected: _selectedIndex == index,
        onTap: () => _onItemTapped(index),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        hoverColor: Colors.white.withOpacity(0.1),
      ),
    );
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onBottomNavTapped,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.people_alt_outlined),
          activeIcon: Icon(Icons.people_alt),
          label: 'Faculty',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school_outlined),
          activeIcon: Icon(Icons.school),
          label: 'Dept',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_outlined),
          activeIcon: Icon(Icons.notifications),
          label: 'Updates',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.public_outlined),
          activeIcon: Icon(Icons.public),
          label: 'Web',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.feedback_outlined),
          activeIcon: Icon(Icons.feedback),
          label: 'Feedback',
        ),
      ],
    );
  }
}

class FacultyInfo extends StatelessWidget {
  final List<Map<String, String>> faculty = [
    {
      'name': 'Prof. Dr. Dhananjay Kalbande',
      'position': 'Head Of Department',
      'image': 'assets/prof_kalbande.jpeg',
    },
    {
      'name': 'Prof. Dr. Pooja Raundale',
      'position': 'Professor',
      'image': 'assets/prof_raundale.jpg',
    },
    {
      'name': 'Prof. Dr. Aarti Karande',
      'position': 'Assistant Professor',
      'image': 'assets/prof_karande.png',
    },
    {
      'name': 'Prof. Harshil Kanakia',
      'position': 'Assistant Professor',
      'image': 'assets/prof_kanakia.png',
    },
    {
      'name': 'Prof. Nikhita Mangaonkar',
      'position': 'Assistant Professor',
      'image': 'assets/prof_mangaonkar.jpg',
    },
    {
      'name': 'Prof. Sakina Shaikh',
      'position': 'Assistant Professor',
      'image': 'assets/prof_shaikh.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemCount: faculty.length,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(faculty[index]['image']!),
                  ),
                  SizedBox(height: 10),
                  Text(
                    faculty[index]['name']!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    faculty[index]['position']!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class DeptInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildVisionCard(context),
        const SizedBox(height: 20),
        _buildMissionSection(context),
      ],
    );
  }

  Widget _buildVisionCard(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.remove_red_eye_outlined,
              size: 40,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 15),
            Text('Vision', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 10),
            Text(
              'To create a center of excellence which will produce cutting edge technologies to cater needs of Business and Society.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            'Mission Statements',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        ...List.generate(4, (index) => _buildMissionPoint(context, index + 1)),
      ],
    );
  }

  Widget _buildMissionPoint(BuildContext context, int number) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 2,
      child: ExpandablePanel(
        header: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  'M$number',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  'Mission Statement $number - Brief description...',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ),
        collapsed: const SizedBox(),
        expanded: const Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            'Detailed mission description text goes here... Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
          ),
        ),
      ),
    );
  }
}

class Notifications extends StatelessWidget {
  final List<Map<String, String>> events = [
    {'name': 'Oculus', 'image': 'assets/oculus.png'},
    {'name': 'Coeadthon', 'image': 'assets/coeadthon.png'},
    {'name': 'HackInfiy', 'image': 'assets/hackinfi.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Notifications Header
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Icon(
                  Icons.notifications_active,
                  color: Theme.of(context).primaryColor,
                  size: 28,
                ),
                const SizedBox(width: 10),
                Text(
                  'Notifications',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          // Notifications List
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildNotificationItem(
                    context,
                    "Parents Teacher Meeting, November 2022",
                  ),
                  _buildDivider(),
                  _buildNotificationItem(
                    context,
                    "Parents Teacher Meeting, April 2023",
                  ),
                  _buildDivider(),
                  _buildNotificationItem(
                    context,
                    "Parents Teacher Meeting Notice, 2023",
                  ),
                  _buildNotificationItem(
                    context,
                    "Parents Teacher Meeting, November 2023",
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 25),

          // Events Header
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              children: [
                Icon(
                  Icons.event,
                  color: Theme.of(context).primaryColor,
                  size: 28,
                ),
                const SizedBox(width: 10),
                Text(
                  'Upcoming Events',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          // Events Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.8,
            ),
            itemCount: events.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      Image.asset(
                        events[index]['image']!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 15,
                        left: 15,
                        right: 15,
                        child: Text(
                          events[index]['name']!,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6, right: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: Colors.grey[300],
      indent: 20,
      endIndent: 20,
    );
  }
}

class WebViewPage extends StatefulWidget {
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    WebViewController controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse('https://mca.spit.ac.in/'));
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}

class FeedbackForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Color scheme (60-30-10 rule)
    const primaryColor = Color(0xFFF8F9FA); // 60% (Light grey background)
    const secondaryColor = Color(0xFF2A5C82); // 30% (Dark blue)
    const accentColor = Color(0xFFFFC107); // 10% (Amber accent)

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: secondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(Icons.feedback, size: 40, color: secondaryColor),
                    const SizedBox(height: 10),
                    Text(
                      "Share Your Feedback",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Rating Section
              Text(
                "How would you rate our services?",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                glowColor: accentColor,
                unratedColor: Colors.grey[300],
                itemSize: 40,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemBuilder:
                    (context, _) =>
                        Icon(Icons.star_rounded, color: accentColor),
                onRatingUpdate: (rating) {},
              ),

              const SizedBox(height: 30),

              // Feedback Input
              TextField(
                decoration: InputDecoration(
                  labelText: "Your Feedback",
                  labelStyle: TextStyle(color: secondaryColor),
                  floatingLabelStyle: TextStyle(color: secondaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: secondaryColor!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: secondaryColor, width: 2),
                  ),
                  prefixIcon: Icon(Icons.edit, color: secondaryColor),
                ),
                maxLines: 4,
                style: TextStyle(color: Colors.grey[800]),
              ),

              const SizedBox(height: 30),

              // Submit Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.send, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      "Submit Feedback",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpandableCard extends StatelessWidget {
  final String title, subtitle, content;
  ExpandableCard(this.title, this.subtitle, this.content);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: ExpandablePanel(
          header: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          collapsed: Text(
            subtitle,
            softWrap: true,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          expanded: Text(content, softWrap: true),
        ),
      ),
    );
  }
}
