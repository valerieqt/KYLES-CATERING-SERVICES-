import 'package:flutter/material.dart';

class StaffAvailabilityPage extends StatelessWidget {
  final Map<DateTime, List<Map<String, String>>> staffSchedule;

  StaffAvailabilityPage({super.key, required this.staffSchedule});

  final List<String> _allEmployees = [
    'Ana',
    'Carlos',
    'Julia',
    'Miguel',
    'Sofia',
  ];

  DateTime _normalize(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return const Color.fromARGB(255, 0, 128, 0);
      case 'Assigned':
        return const Color.fromARGB(255, 255, 0, 0);
      case 'Available':
        return Colors.green;
      case 'Unavailable':
        return const Color.fromARGB(255, 114, 20, 4);
      default:
        return const Color.fromARGB(255, 163, 163, 163);
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Completed':
        return Icons.verified;
      case 'Assigned':
        return Icons.schedule;
      case 'Available':
        return Icons.check_circle;
      case 'Unavailable':
        return Icons.cancel;
      default:
        return Icons.block;
    }
  }

  Widget _buildEmployeeStatus(String employee, String status) {
    final color = _getStatusColor(status);
    final icon = _getStatusIcon(status);

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(employee),
      subtitle: Text(status),
      textColor: color,
      dense: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final sortedDates = staffSchedule.keys.toList()
      ..sort((a, b) => _normalize(a).compareTo(_normalize(b)));

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F0),
      appBar: AppBar(
        title: const Text('Staff Availability'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Export/Print not implemented yet"),
                ),
              );
            },
          ),
        ],
      ),
      body: sortedDates.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'No staff schedules found.',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sortedDates.length,
              itemBuilder: (context, index) {
                final date = sortedDates[index];
                final formattedDate =
                    "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                final staffList = staffSchedule[date] ?? [];

                final Map<String, String> assignedMap = {
                  for (var s in staffList) s['name']!: s['status']!,
                };

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 18,
                              color: Colors.brown,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              formattedDate,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ..._allEmployees.map((employee) {
                          final status =
                              assignedMap[employee] ?? 'Not Assigned';
                          return _buildEmployeeStatus(employee, status);
                        }),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
