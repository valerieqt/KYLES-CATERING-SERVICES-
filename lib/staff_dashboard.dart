import 'package:flutter/material.dart';
import 'staff_subpages.dart';
import 'theme/app_theme.dart';

class KylesCateringApp extends StatefulWidget {
  final String userName;
  final String userEmail;

  const KylesCateringApp({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<KylesCateringApp> createState() => _KylesCateringAppState();
}

class _KylesCateringAppState extends State<KylesCateringApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: AppColors.cream,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: AppColors.deepMaroon),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/avatar.jpg'),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.userName,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    widget.userEmail,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile Info'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileInfoPage(
                      userName: widget.userName,
                      userEmail: widget.userEmail,
                    ),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Change Password'),
              onTap: () {
                Navigator.pop(context);
                final _newPasswordController = TextEditingController();
                final _confirmPasswordController = TextEditingController();

                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Change Password'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: _newPasswordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'New Password',
                            ),
                          ),
                          TextField(
                            controller: _confirmPasswordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Confirm Password',
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_newPasswordController.text ==
                                _confirmPasswordController.text) {
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Success'),
                                  content: const Text(
                                    'Password successfully changed!',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Passwords do not match'),
                                ),
                              );
                            }
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Confirm Sign Out'),
                    content: const Text('Are you sure you want to sign out?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, '/');
                        },
                        child: const Text('Sign Out'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Kyle’s Catering'),
        backgroundColor: AppColors.deepMaroon,
      ),
      body: StaffHomePage(userName: widget.userName),
    );
  }
}

class StaffHomePage extends StatelessWidget {
  final String userName;

  const StaffHomePage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // White background
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/avatar.jpg'),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, $userName',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepMaroon,
                      ),
                    ),
                    const Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.deepMaroon,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _DashboardCard(
                    icon: Icons.calendar_month,
                    title: 'Calendar View',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CalendarViewPage(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _DashboardCard(
                    icon: Icons.group,
                    title: 'View Staff',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const StaffListPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Categories',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Wrap(
                spacing: 40,
                alignment: WrapAlignment.center,
                children: [
                  _CategoryCircle(
                    icon: Icons.schedule,
                    label: 'My Schedules',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MySchedulesPage(),
                        ),
                      );
                    },
                  ),
                  _CategoryCircle(
                    icon: Icons.event_available,
                    label: 'Availability',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AvailabilityPage(),
                        ),
                      );
                    },
                  ),
                  _CategoryCircle(
                    icon: Icons.notifications,
                    label: 'Notifications',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Event Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepMaroon,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EventDetailsPage(),
                      ),
                    );
                  },
                  child: const Text('See All'),
                ),
              ],
            ),
            EventDetailsCard(eventTitle: 'Wedding', date: 'July 21, 2025'),
            EventDetailsCard(
              eventTitle: 'Corporate Event',
              date: 'August 15, 2025',
            ),
            EventDetailsCard(
              eventTitle: 'Birthday Party',
              date: 'September 10, 2025',
            ),
          ],
        ),
      ),
    );
  }
}

// NEW: Circular category button widget
class _CategoryCircle extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _CategoryCircle({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.oliveGreen,
            ),
            child: Icon(icon, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 14), // Slightly bigger font
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

//EVENT DETAILS CARD WIDGET
class EventDetailsCard extends StatelessWidget {
  final String eventTitle;
  final String date;

  const EventDetailsCard({
    super.key,
    required this.eventTitle,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.event, color: AppColors.deepMaroon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eventTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepMaroon,
                  ),
                ),
                const SizedBox(height: 4),
                Text(date, style: const TextStyle(color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//DASHBOARD CARD WIDGET

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120, // Slightly increased height
        padding: const EdgeInsets.all(18), // Slightly more padding
        decoration: BoxDecoration(
          color: AppColors.deepMaroon,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 34), // Bigger icon
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileInfoPage extends StatefulWidget {
  final String userName;
  final String userEmail;

  const ProfileInfoPage({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<ProfileInfoPage> createState() => _ProfileInfoPageState();
}

class _ProfileInfoPageState extends State<ProfileInfoPage> {
  late TextEditingController contactController;
  late TextEditingController addressController;
  late TextEditingController roleController;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    contactController = TextEditingController(text: "09123456789");
    addressController = TextEditingController(text: "123 Sample Street");
    roleController = TextEditingController(text: "Staff");
  }

  @override
  void dispose() {
    contactController.dispose();
    addressController.dispose();
    roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Info"),
        backgroundColor: const Color(0xFF741D1F), // deep maroon
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
              });
              if (!isEditing) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile info updated.')),
                );
              }
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF2E3D4), // cream background
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: const AssetImage('assets/avatar.jpg'),
            ),
            const SizedBox(height: 16),
            Text(
              widget.userName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              widget.userEmail,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            _buildEditableField("Contact Number", contactController),
            const SizedBox(height: 16),
            _buildEditableField("Address", addressController),
            const SizedBox(height: 16),
            _buildEditableField("Role", roleController),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      enabled: isEditing,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: isEditing ? Colors.white : Colors.grey[200],
      ),
    );
  }
}
