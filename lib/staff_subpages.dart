import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

List<DateTime> confirmedAvailabilityDates = [];

// Calendar View
class ConfirmedAvailability {
  final String event;
  final DateTime date;
  final String time;
  final String location;
  final String instructions;

  ConfirmedAvailability({
    required this.event,
    required this.date,
    required this.time,
    required this.location,
    required this.instructions,
  });
}

// Shared list to sync between AvailabilityPage and CalendarViewPage
List<ConfirmedAvailability> confirmedAvailabilityList = [];

//Calendar View Page
class CalendarViewPage extends StatefulWidget {
  const CalendarViewPage({super.key});

  @override
  State<CalendarViewPage> createState() => _CalendarViewPageState();
}

class _CalendarViewPageState extends State<CalendarViewPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    return confirmedAvailabilityList
        .where((event) {
          return event.date.year == day.year &&
              event.date.month == day.month &&
              event.date.day == day.day;
        })
        .map(
          (e) => {
            'event': e.event,
            'date': e.date.toString().split(' ')[0],
            'time': e.time,
            'location': e.location,
            'instructions': e.instructions,
          },
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final events = _selectedDay != null ? _getEventsForDay(_selectedDay!) : [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar View'),
        backgroundColor: AppColors.deepMaroon,
      ),
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: AppColors.oliveGreen,
                shape: BoxShape.circle,
              ),
            ),
            eventLoader: _getEventsForDay,
          ),
          const SizedBox(height: 12),
          const Text(
            "Events for selected day:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (_, index) {
                final event = events[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Text(event['event']),
                    subtitle: Text('${event['time']} • ${event['location']}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// MySchedulesPage
class MySchedulesPage extends StatelessWidget {
  const MySchedulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Schedules')),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ScheduleCard(
            title: 'Wedding Setup',
            date: 'July 21, 2025',
            location: 'La Mesa, QC',
          ),
          SizedBox(height: 12),
          ScheduleCard(
            title: 'Corporate Event',
            date: 'July 22, 2025',
            location: 'Ortigas Center',
          ),
        ],
      ),
    );
  }
}

class ScheduleCard extends StatelessWidget {
  final String title;
  final String date;
  final String location;

  const ScheduleCard({
    super.key,
    required this.title,
    required this.date,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.deepMaroon,
              ),
            ),
            const SizedBox(height: 8),
            Text(date),
            Text(location),
          ],
        ),
      ),
    );
  }
}

// Availability Page
class AvailabilityPage extends StatefulWidget {
  const AvailabilityPage({super.key});

  @override
  State<AvailabilityPage> createState() => _AvailabilityPageState();
}

class _AvailabilityPageState extends State<AvailabilityPage> {
  final List<ConfirmedAvailability> allEvents = [
    ConfirmedAvailability(
      event: 'Wedding Catering',
      date: DateTime(2025, 7, 21),
      time: '3:00 PM',
      location: 'Tagaytay Highlands',
      instructions: 'Arrive 1 hour early',
    ),
    ConfirmedAvailability(
      event: 'Corporate Lunch',
      date: DateTime(2025, 7, 22),
      time: '11:00 AM',
      location: 'BGC, Taguig',
      instructions: 'Wear uniform',
    ),
    ConfirmedAvailability(
      event: 'Birthday Party',
      date: DateTime(2025, 7, 23),
      time: '5:00 PM',
      location: 'Quezon City',
      instructions: 'Bring extra utensils',
    ),
    ConfirmedAvailability(
      event: 'Anniversary Dinner',
      date: DateTime(2025, 7, 24),
      time: '7:00 PM',
      location: 'Makati City',
      instructions: 'Formal attire required',
    ),
    // Add more if needed
  ];

  void handleAvailabilityResponse(int index, String response) {
    final event = allEvents[index];
    final alreadyConfirmed = confirmedAvailabilityList.any(
      (e) =>
          e.event == event.event &&
          e.date == event.date &&
          e.time == event.time,
    );

    setState(() {
      if (response == 'Available' && !alreadyConfirmed) {
        confirmedAvailabilityList.add(event);
      } else if (response == 'Unavailable') {
        confirmedAvailabilityList.removeWhere(
          (e) =>
              e.event == event.event &&
              e.date == event.date &&
              e.time == event.time,
        );
      }
    });
  }

  void removeConfirmedEvent(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Remove Confirmation'),
        content: const Text('Are you sure you want to remove this event?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                confirmedAvailabilityList.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Availability')),
    backgroundColor: AppColors.cream,
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          const Text(
            'Confirm Availability',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...allEvents.asMap().entries.map((entry) {
            int index = entry.key;
            var event = entry.value;
            return AvailabilityCard(
              event: event.event,
              date: event.date,
              time: event.time,
              location: event.location,
              instructions: event.instructions,
              onResponse: (response) =>
                  handleAvailabilityResponse(index, response),
            );
          }),
          const SizedBox(height: 24),
          const Text(
            'Confirmed Availability',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...confirmedAvailabilityList.asMap().entries.map((entry) {
            int index = entry.key;
            var event = entry.value;
            return Card(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                title: Text(event.event),
                subtitle: Text(
                  '${event.date.toLocal().toString().split(' ')[0]} • ${event.time}\n${event.location}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => removeConfirmedEvent(index),
                ),
              ),
            );
          }),
        ],
      ),
    ),
  );
}

// AvailabilityCard
class AvailabilityCard extends StatelessWidget {
  final String event;
  final DateTime date;
  final String time;
  final String location;
  final String instructions;
  final void Function(String) onResponse;

  const AvailabilityCard({
    super.key,
    required this.event,
    required this.date,
    required this.time,
    required this.location,
    required this.instructions,
    required this.onResponse,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat.yMMMMd().format(date);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Date: $formattedDate'),
            Text('Time: $time'),
            Text('Location: $location'),
            Text('Instructions: $instructions'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => onResponse("Available"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text("Confirm"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => onResponse("Unavailable"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Unavailable"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// DayAvailabilityCard

// NotificationsPage
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> notifications = [
      'New schedule available for July 23!',
      'Team meeting at 5PM today.',
      'Event venue changed for July 22.',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) => ListTile(
          leading: const Icon(Icons.notifications, color: AppColors.oliveGreen),
          title: Text(notifications[index]),
        ),
      ),
    );
  }
}

// EventDetailsPage
class EventDetailsPage extends StatelessWidget {
  const EventDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event Details')),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Wedding - July 21, 2025',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepMaroon,
                  ),
                ),
                SizedBox(height: 8),
                Text('Location: La Mesa Eco Park, QC'),
                Text('Call Time: 6:00 AM'),
                Text('Uniform: White long sleeves, black slacks'),

                Text(
                  'Corporate Event - Aug 15, 2025',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepMaroon,
                  ),
                ),
                SizedBox(height: 8),
                Text('Location: Lemery, Batangas'),
                Text('Call Time: 6:00 AM'),
                Text('Uniform: White long sleeves, black slacks'),
                Text(
                  'Birthday Party - Sep 10, 2025',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepMaroon,
                  ),
                ),
                SizedBox(height: 8),
                Text('Location: Batangas City'),
                Text('Call Time: 6:00 AM'),
                Text('Uniform: White long sleeves, black slacks'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// StaffListPage
class StaffListPage extends StatelessWidget {
  const StaffListPage({super.key});

  final List<Map<String, String>> _staffMembers = const [
    {
      'name': 'Valerie Gonzaga',
      'role': 'Event Coordinator',
      'email': 'valerie@kylescatering.com',
    },
    {
      'name': 'Michael Reyes',
      'role': 'Chef',
      'email': 'michael@kylescatering.com',
    },
    {
      'name': 'Samantha Cruz',
      'role': 'Wait Staff',
      'email': 'samantha@kylescatering.com',
    },
    {
      'name': 'David Lee',
      'role': 'Logistics',
      'email': 'david@kylescatering.com',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List of Staff Members')),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _staffMembers.length,
        itemBuilder: (context, index) {
          final staff = _staffMembers[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Text(
                staff['name']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${staff['role']} • ${staff['email']}'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Optional: handle tap event
              },
            ),
          );
        },
      ),
    );
  }
}
