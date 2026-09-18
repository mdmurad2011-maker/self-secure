import 'package:flutter/material.dart';

import 'screens/app_lock_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SelfSecureApp());
}

class SelfSecureApp extends StatelessWidget {
  const SelfSecureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SELF SECURE',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF07111F),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD9A441),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const AppEntry(),
    );
  }
}

class AppEntry extends StatefulWidget {
  const AppEntry({super.key});

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  bool _unlocked = false;

  @override
  Widget build(BuildContext context) {
    if (!_unlocked) {
      return AppLockScreen(
        onUnlocked: () {
          setState(() {
            _unlocked = true;
          });
        },
      );
    }

    return const SecurityHomePage();
  }
}

class SecurityHomePage extends StatelessWidget {
  const SecurityHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SELF SECURE',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: const Color(0xFF07111F),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome back',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Your security at a glance',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 22),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(
                    color: const Color(0x33D9A441),
                  ),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF182A40),
                      Color(0xFF0D1828),
                    ],
                  ),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Color(0x22D9A441),
                      child: Icon(
                        Icons.verified_user_rounded,
                        color: Color(0xFFFFD66B),
                        size: 35,
                      ),
                    ),

                    SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Security Status',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 13,
                            ),
                          ),

                          SizedBox(height: 3),

                          Text(
                            'Protected',
                            style: TextStyle(
                              color: Color(0xFFFFD66B),
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          SizedBox(height: 4),

                          Text(
                            'SELF SECURE is active.',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Security Center',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 13),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.15,
                children: const [
                  SecurityCard(
                    icon: Icons.phone_android_rounded,
                    title: 'My Device',
                    subtitle: 'Device protection',
                  ),

                  SecurityCard(
                    icon: Icons.location_on_rounded,
                    title: 'Location',
                    subtitle: 'Authorized GPS',
                  ),

                  SecurityCard(
                    icon: Icons.warning_amber_rounded,
                    title: 'Security Events',
                    subtitle: 'View activity',
                  ),

                  SecurityCard(
                    icon: Icons.settings_rounded,
                    title: 'Settings',
                    subtitle: 'Security controls',
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

class SecurityCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const SecurityCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFF101D2D),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0x1FD9A441),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0x16D9A441),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFFFD66B),
              size: 25,
            ),
          ),

          const Spacer(),

          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
