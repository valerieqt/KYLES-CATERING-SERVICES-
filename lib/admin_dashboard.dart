import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'staff_schedule_page.dart';
import 'inventory_status_page.dart';
import 'staff_availability_page.dart';

class AdminDashboardPage extends StatefulWidget {
  final String? userName;
  final String? userEmail;
  const AdminDashboardPage({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  DateTime _normalizeDate(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  final Map<DateTime, List<Map<String, dynamic>>> _events = {
    DateTime(2025, 7, 10): [
      {'title': 'Wedding at Garden Venue – 3:00 PM', 'complete': false},
    ],
    DateTime(2025, 7, 11): [
      {'title': 'Wedding at Church – 10:00 AM', 'complete': false},
    ],
    DateTime(2025, 7, 12): [
      {'title': 'Wedding at Beach Resort – 2:00 PM', 'complete': false},
    ],
  };

  final Map<DateTime, List<Map<String, String>>> _staffSchedule = {
    DateTime(2025, 7, 10): [
      {'name': 'Ana', 'status': 'Available'},
      {'name': 'Carlos', 'status': 'Unavailable'},
    ],
    DateTime(2025, 7, 11): [
      {'name': 'Ana', 'status': 'Available'},
      {'name': 'Carlos', 'status': 'Available'},
    ],
    DateTime(2025, 7, 12): [
      {'name': 'Ana', 'status': 'Unavailable'},
      {'name': 'Carlos', 'status': 'Available'},
    ],
  };

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    return _events[_normalizeDate(day)] ?? [];
  }

  void _showEventFormDialog({
    bool isEdit = false,
    int? index,
    Map<String, dynamic>? currentEvent,
  }) {
    final formKey = GlobalKey<FormState>();
    final selected = _selectedDay ?? _focusedDay;
    final normalizedDate = _normalizeDate(selected);

    String? selectedType;
    String? selectedLocation;
    TimeOfDay? selectedTime;

    if (isEdit && currentEvent != null) {
      final parts = currentEvent['title'].split(' at ');
      if (parts.length == 2) {
        selectedType = parts[0];
        final subParts = parts[1].split(' – ');
        if (subParts.length == 2) {
          selectedLocation = subParts[0];
          final timeString = subParts[1];
          final timeParts = timeString.split(RegExp(r'[: ]'));
          if (timeParts.length >= 2) {
            int hour = int.parse(timeParts[0]);
            int minute = int.parse(timeParts[1]);
            final isPM = timeString.contains('PM');
            if (isPM && hour < 12) hour += 12;
            if (!isPM && hour == 12) hour = 0;
            selectedTime = TimeOfDay(hour: hour, minute: minute);
          }
        }
      }
    }

    final TextEditingController locationController = TextEditingController(
      text: selectedLocation ?? '',
    );

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(isEdit ? 'Edit Event' : 'Add New Event'),
          content: StatefulBuilder(
            builder: (context, setModalState) {
              return Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      hint: const Text('Select event type'),
                      items: ['Wedding', 'Birthday', 'Corporate', 'Other']
                          .map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setModalState(() {
                          selectedType = value!;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Please select a type' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: locationController,
                      decoration: const InputDecoration(labelText: 'Location'),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Enter a location'
                          : null,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            selectedTime != null
                                ? 'Time: ${selectedTime!.format(context)}'
                                : 'Select Time',
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.access_time),
                          onPressed: () async {
                            final pickedTime = await showTimePicker(
                              context: context,
                              initialTime: selectedTime ?? TimeOfDay.now(),
                            );
                            if (pickedTime != null) {
                              setModalState(() {
                                selectedTime = pickedTime;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate() && selectedTime != null) {
                  final eventTitle =
                      '$selectedType at ${locationController.text} – ${selectedTime!.format(context)}';
                  final eventData = {'title': eventTitle, 'complete': false};

                  setState(() {
                    if (isEdit && index != null) {
                      _events[normalizedDate]![index] = eventData;
                    } else {
                      _events
                          .putIfAbsent(normalizedDate, () => [])
                          .add(eventData);
                    }
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                }
              },
              child: Text(isEdit ? 'Save' : 'Add'),
            ),
          ],
        );
      },
    );
  }

  Widget buildMenuButton(String label, IconData icon, VoidCallback onTap) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 22,
      child: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Opening $label...')));
          onTap();
        },
        child: Container(
          margin: const EdgeInsets.all(6),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFEBD8CB),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.red[800]),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDF8F0),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: CircleAvatar(
            backgroundColor: Colors.red[100],
            child: const Text("K", style: TextStyle(color: Colors.red)),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.restaurant_menu, color: Colors.red),
            SizedBox(width: 6),
            Text(
              "Kyle’s Catering Services",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.brown),
            onSelected: (value) {
              if (value == 'logout') {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop(); // close dialog
                          },
                        ),
                        TextButton(
                          child: const Text('Logout'),
                          onPressed: () {
                            Navigator.of(context).pop(); // close dialog
                            Navigator.of(
                              context,
                            ).pushReplacementNamed('/'); // back to login
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },

            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Admin Dashboard",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'Welcome, ${widget.userName}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              widget.userEmail ?? 'No email provided',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 10),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                buildMenuButton('Event Calendar', Icons.calendar_month, () {}),
                buildMenuButton('Manage Staff\nSchedule', Icons.schedule, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          StaffSchedulePage(staffSchedule: _staffSchedule),
                    ),
                  );
                }),
                buildMenuButton('Staff\nAvailability', Icons.people, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          StaffAvailabilityPage(staffSchedule: _staffSchedule),
                    ),
                  );
                }),
                buildMenuButton('Inventory\nStatus', Icons.inventory, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const InventoryStatusPage(),
                    ),
                  );
                }),
              ],
            ),

            const SizedBox(height: 20),
            Divider(thickness: 1.2, color: Colors.brown),
            const SizedBox(height: 10),
            const Text(
              "Event Calendar",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                eventLoader: (day) =>
                    _getEventsForDay(day).map((e) => e['title']).toList(),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: CalendarStyle(
                  selectedDecoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.green[300],
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  markerDecoration: BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.brown[700],
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),
            const Text(
              "Events for selected day:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),

            ElevatedButton.icon(
              onPressed: () {
                _showEventFormDialog();
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Event'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 10),

            Builder(
              builder: (_) {
                final selected = _selectedDay ?? today;
                final events = _getEventsForDay(selected);
                if (events.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'No events for this day.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                } else {
                  return Column(
                    children: events.asMap().entries.map((entry) {
                      final index = entry.key;
                      final event = entry.value;
                      final title = event['title'];
                      final complete = event['complete'];

                      return Card(
                        color: complete ? Colors.green[50] : Colors.white,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: Icon(
                            complete ? Icons.check_circle : Icons.event_note,
                            color: complete ? Colors.green : Colors.redAccent,
                          ),
                          title: Text(
                            title,
                            style: TextStyle(
                              decoration: complete
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: complete ? Colors.grey : Colors.black,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  complete ? Icons.undo : Icons.check,
                                  color: Colors.green,
                                ),
                                tooltip: complete
                                    ? 'Mark as Incomplete'
                                    : 'Mark as Complete',
                                onPressed: () {
                                  setState(() {
                                    _events[_normalizeDate(
                                          selected,
                                        )]![index]['complete'] =
                                        !complete;
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.orange,
                                ),
                                onPressed: () {
                                  _showEventFormDialog(
                                    isEdit: true,
                                    index: index,
                                    currentEvent: event,
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text('Delete Event'),
                                      content: const Text(
                                        'Are you sure you want to delete this event?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              _events[_normalizeDate(selected)]!
                                                  .removeAt(index);
                                              if (_events[_normalizeDate(
                                                    selected,
                                                  )]!
                                                  .isEmpty) {
                                                _events.remove(
                                                  _normalizeDate(selected),
                                                );
                                              }
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
