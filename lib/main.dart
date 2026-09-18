import 'package:flutter/material.dart';

import 'screens/app_lock_screen.dart';
import 'screens/my_device_screen.dart';
import 'screens/security_settings_screen.dart';

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

  void _unlockApp() {
    setState(() {
      _unlocked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_unlocked) {
      return AppLockScreen(
        onUnlocked: _unlockApp,
      );
    }

    return const SecurityHomePage();
  }
}

class SecurityHomePage extends StatelessWidget {
  const SecurityHomePage({super.key});

  void _openMyDevice(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const MyDeviceScreen(),
      ),
    );
  }

  void _openSecuritySettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const SecuritySettingsScreen(),
      ),
    );
  }

  void _showComingSoon(
    BuildContext context,
    String title,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title module is coming next.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07111F),

      appBar: AppBar(
        backgroundColor: const Color(0xFF07111F),
        elevation: 0,
        titleSpacing: 20,

        title: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFD66B),
                    Color(0xFF9B6A18),
                  ],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x66D9A441),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: const Icon(
                Icons.shield_rounded,
                color: Color(0xFF07111F),
                size: 27,
              ),
            ),

            const SizedBox(width: 12),

            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SELF SECURE',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
                Text(
                  'Personal Security',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ],
        ),

        actions: [
          IconButton(
            onPressed: () {
              _showComingSoon(
                context,
                'Security Notifications',
              );
            },
            icon: const Icon(
              Icons.notifications_none_rounded,
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            30,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
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

              // SECURITY STATUS
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(26),
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
                      backgroundColor:
                          Color(0x22D9A441),
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
                              fontWeight:
                                  FontWeight.w800,
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

                children: [
                  // MY DEVICE
                  SecurityCard(
                    icon:
                        Icons.phone_android_rounded,
                    title: 'My Device',
                    subtitle:
                        'Device protection',
                    onTap: () {
                      _openMyDevice(context);
                    },
                  ),

                  // LOCATION
                  SecurityCard(
                    icon:
                        Icons.location_on_rounded,
                    title: 'Location',
                    subtitle:
                        'Authorized GPS',
                    onTap: () {
                      _showComingSoon(
                        context,
                        'Location',
                      );
                    },
                  ),

                  // SECURITY EVENTS
                  SecurityCard(
                    icon:
                        Icons.warning_amber_rounded,
                    title: 'Security Events',
                    subtitle:
                        'View activity',
                    onTap: () {
                      _showComingSoon(
                        context,
                        'Security Events',
                      );
                    },
                  ),

                  // SETTINGS
                  SecurityCard(
                    icon: Icons.settings_rounded,
                    title: 'Settings',
                    subtitle:
                        'Security controls',
                    onTap: () {
                      _openSecuritySettings(
                        context,
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // QUICK SECURITY
              GestureDetector(
                onTap: () {
                  _openSecuritySettings(context);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF101D2D),
                    borderRadius:
                        BorderRadius.circular(22),
                    border: Border.all(
                      color: const Color(0x1FD9A441),
                    ),
                  ),
                  child: const Row(
                    children: [
                      SizedBox(
                        width: 46,
                        height: 46,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Color(0x16D9A441),
                            borderRadius:
                                BorderRadius.all(
                              Radius.circular(14),
                            ),
                          ),
                          child: Icon(
                            Icons.security_rounded,
                            color: Color(0xFFFFD66B),
                          ),
                        ),
                      ),

                      SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quick Security',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight:
                                    FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Open security controls',
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                    Colors.white54,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: Colors.white38,
                      ),
                    ],
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

class SecurityCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const SecurityCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(22),

        child: Ink(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: const Color(0xFF101D2D),
            borderRadius:
                BorderRadius.circular(22),
            border: Border.all(
              color: const Color(0x1FD9A441),
            ),
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0x16D9A441),
                  borderRadius:
                      BorderRadius.circular(14),
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
        ),
      ),
    );
  }
}
