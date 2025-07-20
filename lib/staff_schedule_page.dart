import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class StaffSchedulePage extends StatefulWidget {
  final Map<DateTime, List<Map<String, String>>> staffSchedule;

  const StaffSchedulePage({super.key, required this.staffSchedule});

  @override
  State<StaffSchedulePage> createState() => _StaffSchedulePageState();
}

class _StaffSchedulePageState extends State<StaffSchedulePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  String? _selectedEmployee;

  final List<String> _allEmployees = [
    'Ana',
    'Carlos',
    'Julia',
    'Miguel',
    'Sofia',
  ];

  final Map<DateTime, String> eventMap = {
    DateTime(2025, 7, 10): 'Wedding at 3PM',
    DateTime(2025, 7, 11): 'Wedding at 10AM',
    DateTime(2025, 7, 12): 'Wedding at 2PM',
  };

  DateTime _normalize(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  List<Map<String, String>> _getStaffForDay(DateTime day) {
    return widget.staffSchedule[_normalize(day)] ?? [];
  }

  void _assignStaff() {
    if (_selectedEmployee == null) return;

    DateTime normalizedSelected = _normalize(_selectedDay);

    if (normalizedSelected.isBefore(_normalize(DateTime.now()))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot assign staff in the past.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    for (var entry in widget.staffSchedule.entries) {
      final date = _normalize(entry.key);
      if (date == normalizedSelected) continue;

      final assigned = entry.value.any(
        (s) => s['name'] == _selectedEmployee && s['status'] != 'Completed',
      );

      if (assigned) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.warning, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  '$_selectedEmployee is already assigned to another event.',
                ),
              ],
            ),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
    }

    final currentList = widget.staffSchedule[normalizedSelected] ?? [];

    final alreadyAssigned = currentList.any(
      (s) => s['name'] == _selectedEmployee,
    );

    if (!alreadyAssigned) {
      setState(() {
        currentList.add({'name': _selectedEmployee!, 'status': 'Assigned'});
        widget.staffSchedule[normalizedSelected] = currentList;
        _selectedEmployee = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 10),
              const Text('Assigned successfully!'),
            ],
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning, color: Colors.white),
              const SizedBox(width: 10),
              Text('$_selectedEmployee is already assigned today.'),
            ],
          ),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _cancelAssignment(String employeeName) {
    DateTime normalized = _normalize(_selectedDay);
    final currentList = widget.staffSchedule[normalized] ?? [];

    setState(() {
      currentList.removeWhere((staff) => staff['name'] == employeeName);
      widget.staffSchedule[normalized] = currentList;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.cancel, color: Colors.white),
            const SizedBox(width: 10),
            Text('Assignment for $employeeName canceled.'),
          ],
        ),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              widget.staffSchedule[normalized]?.add({
                'name': employeeName,
                'status': 'Assigned',
              });
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final staffList = _getStaffForDay(_selectedDay);
    final normalized = _normalize(_selectedDay);
    final selectedEvent = eventMap[normalized];

    int assignedCount = staffList
        .where((s) => s['status'] == 'Assigned')
        .length;
    int completedCount = staffList
        .where((s) => s['status'] == 'Completed')
        .length;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F0),
      appBar: AppBar(
        title: Text(
          'Staff Schedule - ${_selectedDay.month}/${_selectedDay.day}',
        ),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(12),
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
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    _selectedEmployee = null;
                  });
                },
                eventLoader: (day) =>
                    widget.staffSchedule[_normalize(day)] ?? [],
                calendarStyle: CalendarStyle(
                  selectedDecoration: const BoxDecoration(
                    color: Color(0xFF66BB6A),
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  decoration: BoxDecoration(
                    color: Colors.brown[700],
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                  ),
                  titleTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (selectedEvent != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Event: $selectedEvent',
                    style: const TextStyle(color: Colors.black87),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Select staff to assign:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedEmployee,
                    hint: const Text('Choose an employee'),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    items: _allEmployees.map((String employee) {
                      DateTime? assignedDate;

                      final hasConflict = widget.staffSchedule.entries.any((
                        entry,
                      ) {
                        final date = _normalize(entry.key);
                        final selectedDate = _normalize(_selectedDay);
                        if (date == selectedDate) return false;

                        final isAssigned = entry.value.any(
                          (s) =>
                              s['name'] == employee &&
                              s['status'] != 'Completed',
                        );
                        if (isAssigned) assignedDate = date;
                        return isAssigned;
                      });

                      return DropdownMenuItem<String>(
                        value: employee,
                        enabled: !hasConflict,
                        child: Row(
                          children: [
                            Icon(
                              hasConflict ? Icons.block : Icons.person,
                              color: hasConflict ? Colors.red : Colors.black,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              hasConflict && assignedDate != null
                                  ? '$employee (Unavailable on ${assignedDate!.month}/${assignedDate?.day})'
                                  : employee,
                              style: TextStyle(
                                color: hasConflict ? Colors.grey : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedEmployee = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _assignStaff,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: const Icon(Icons.check),
                    label: const Text('Assign Staff'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Staff assigned on this day (Assigned: $assignedCount | Completed: $completedCount):",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
            staffList.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: staffList.length,
                    itemBuilder: (context, index) {
                      final staff = staffList[index];
                      final isCompleted = staff['status'] == 'Completed';

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: Icon(
                            isCompleted ? Icons.verified : Icons.person,
                            color: isCompleted ? Colors.green : null,
                          ),
                          title: Text(staff['name']!),
                          subtitle: Text('Status: ${staff['status']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (!isCompleted)
                                TextButton.icon(
                                  icon: const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  ),
                                  label: const Text(
                                    "Mark Completed",
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      staff['status'] = 'Completed';
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Row(
                                          children: [
                                            const Icon(
                                              Icons.done_all,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              '${staff['name']} marked as completed.',
                                            ),
                                          ],
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  },
                                ),
                              IconButton(
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                                onPressed: () =>
                                    _cancelAssignment(staff['name']!),
                                tooltip: "Cancel assignment",
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'No staff assigned yet.',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
