
import 'package:flutter/material.dart';

void main() {
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
      home: const SecurityHomePage(),
    );
  }
}

class SecurityHomePage extends StatelessWidget {
  const SecurityHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: const Color(0xFF07111F),
              floating: true,
              titleSpacing: 20,
              title: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
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
                          blurRadius: 16,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.shield_rounded,
                      color: Color(0xFF07111F),
                      size: 28,
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
                          fontSize: 12,
                          color: Colors.white60,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                  ),
                ),
              ],
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
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

                    // Security Status
                    Container(
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
                                    fontSize: 13,
                                    color: Colors.white60,
                                  ),
                                ),

                                SizedBox(height: 3),

                                Text(
                                  'Protected',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFFFFD66B),
                                  ),
                                ),

                                SizedBox(height: 4),

                                Text(
                                  'Your security center is ready.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

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

                    const SizedBox(height: 24),

                    // Quick Security
