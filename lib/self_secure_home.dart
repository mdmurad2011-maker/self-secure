import 'package:flutter/material.dart';

import 'screens/my_device_screen.dart';
import 'screens/location_screen.dart';
import 'screens/security_settings_screen.dart';
import 'screens/app_lock_screen.dart';

import 'screens/anti_theft/anti_theft_screen.dart';
import 'screens/anti_theft/lost_mode_screen.dart';

import 'screens/cctv/cctv_screen.dart';
import 'screens/cctv/cctv_devices_screen.dart';

import 'screens/router/router_screen.dart';
import 'screens/router/router_devices_screen.dart';

import 'screens/location/location_history_screen.dart';
import 'screens/location/map_screen.dart';

import 'screens/personal/diary_screen.dart';
import 'screens/personal/reminders_screen.dart';

import 'screens/private/my_disk_screen.dart';
import 'screens/private/private_apps_screen.dart';
import 'screens/private/private_websites_screen.dart';

import 'screens/security/security_events_screen.dart';
import 'screens/security/security_notifications_screen.dart';

import 'screens/optimal/optimal_mep_screen.dart';
import 'screens/optimal/optimal_office_screen.dart';

class SelfSecureHome extends StatelessWidget {
  const SelfSecureHome({super.key});

  void _open(
    BuildContext context,
    Widget screen,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final modules = <Widget>[
      ListTile(
        leading: const Icon(Icons.phone_android),
        title: const Text('My Device'),
        subtitle: const Text(
          'Device information and status',
        ),
        onTap: () => _open(
          context,
          const MyDeviceScreen(),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.location_on),
        title: const Text('My Location'),
        subtitle: const Text(
          'Current GPS location',
        ),
        onTap: () => _open(
          context,
          const LocationScreen(),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.history),
        title: const Text('Location History'),
        onTap: () => _open(
          context,
          const LocationHistoryScreen(),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.security),
        title: const Text('Security Settings'),
        onTap: () => _open(
          context,
          const SecuritySettingsScreen(),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.lock),
        title: const Text('App Lock'),
        onTap: () => _open(
          context,
          AppLockScreen(
            onUnlocked: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.shield),
        title: const Text('Anti-Theft'),
        onTap: () => _open(
          context,
          const AntiTheftScreen(),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.warning),
        title: const Text('Lost Mode'),
        onTap: () => _open(
          context,
          const LostModeScreen(),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.videocam),
        title: const Text('CCTV'),
        onTap: () => _open(
          context,
          const CctvScreen(),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.camera_alt),
        title: const Text('CCTV Devices'),
        onTap: () => _open(
          context,
          const CctvDevicesScreen(),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.router),
        title: const Text('Router'),
        onTap: () => _open(
          context,
          const RouterScreen(),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.devices),
        title: const Text('Router Devices'),
        onTap: () => _open(
          context,
          const RouterDevicesScreen(),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.map),
        title: const Text('Map'),
        onTap: () => _open(
          context,
          const MapScreen(),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.menu_book),
        title: const Text('Diary'),
        onTap: () => _open(
          context,
          const DiaryScreen(),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.alarm),
        title: const Text('Reminders'),
        onTap: () => _open(
          context,
          const RemindersScreen(),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.lock),
        title: const Text('My Disk'),
        onTap: () => _open(
          context,
          const MyDiskScreen(),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.apps),
        title: const Text('Private Apps'),
        onTap: () => _open(
          context,
          const PrivateAppsScreen(),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.language),
        title: const Text('Private Websites'),
        onTap: () => _open(
          context,
          const PrivateWebsitesScreen(),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.event),
        title: const Text('Security Events'),
        onTap: () => _open(
          context,
          const SecurityEventsScreen(),
        ),
      ),
      ListTile(
        leading: const Icon(
          Icons.notifications_active,
        ),
        title: const Text(
          'Security Notifications',
        ),
        onTap: () => _open(
          context,
          const SecurityNotificationsScreen(),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.engineering),
        title: const Text('OPTIMAL MEP'),
        onTap: () => _open(
          context,
          const OptimalMepScreen(),
        ),
      ),
      ListTile(
        leading: const Icon(
          Icons.business_center,
        ),
        title: const Text('OPTIMAL OFFICE'),
        onTap: () => _open(
          context,
          const OptimalOfficeScreen(),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('SELF SECURE'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(
                    Icons.shield,
                    size: 64,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'SELF SECURE',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Personal Security & Device Protection',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          ...modules,
        ],
      ),
    );
  }
}


