import 'package:flutter/material.dart';

class InventoryStatusPage extends StatefulWidget {
  const InventoryStatusPage({super.key});

  @override
  State<InventoryStatusPage> createState() => _InventoryStatusPageState();
}

class _InventoryStatusPageState extends State<InventoryStatusPage> {
  Map<String, int> inventory = {
    'Tables': 10,
    'Chairs': 3,
    'Tents': 30,
    'Lights': 20,
    'Sound System': 20,
  };

  String searchQuery = '';

  void updateQuantity(String item, int change) {
    setState(() {
      inventory[item] = (inventory[item]! + change).clamp(0, 999);
    });
  }

  List<MapEntry<String, int>> get filteredInventory {
    return inventory.entries
        .where(
          (entry) =>
              entry.key.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();
  }

  Widget _getIconForItem(String item) {
    switch (item) {
      case 'Tables':
        return const Icon(Icons.table_bar, color: Colors.brown);
      case 'Chairs':
        return const Icon(Icons.chair, color: Colors.brown);
      case 'Tents':
        return const Icon(Icons.umbrella, color: Colors.blue);
      case 'Lights':
        return const Icon(Icons.lightbulb, color: Colors.amber);
      case 'Sound System':
        return const Icon(Icons.speaker, color: Colors.deepPurple);
      default:
        return const Icon(Icons.inventory);
    }
  }

  @override
  Widget build(BuildContext context) {
    int lowStockCount = inventory.values.where((qty) => qty < 5).length;
    int totalItems = inventory.length;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F0),
      appBar: AppBar(
        title: const Text("Inventory Status"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // Optional: add history dialog
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Inventory History"),
                  content: const Text("No history available yet."),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Close"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary row
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                _buildSummaryBox("Total Items", "$totalItems"),
                const SizedBox(width: 12),
                _buildSummaryBox("Low Stock", "$lowStockCount", warning: true),
              ],
            ),
          ),
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search inventory...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          const SizedBox(height: 10),
          // Inventory list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredInventory.length,
              itemBuilder: (context, index) {
                final item = filteredInventory[index].key;
                final qty = filteredInventory[index].value;

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: _getIconForItem(item),
                    title: Text(
                      item,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Row(
                      children: [
                        Text(
                          'Quantity: $qty',
                          style: TextStyle(
                            color: qty < 5 ? Colors.red : Colors.black,
                            fontWeight: qty < 5
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        if (qty < 5)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              "Low Stock",
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.remove_circle,
                            color: Colors.orange,
                          ),
                          onPressed: () => updateQuantity(item, -1),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.add_circle,
                            color: Colors.green,
                          ),
                          onPressed: () => updateQuantity(item, 1),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryBox(String title, String value, {bool warning = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: warning ? Colors.red[100] : Colors.green[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: warning ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: warning ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
