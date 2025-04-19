import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/item.dart';
import 'package:tboi_companion_app/utils/image_handling.dart';
import 'package:tboi_companion_app/screens/item_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Item> _allItems = [];
  List<Item> _filteredItems = [];
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadItems();
    _controller.addListener(_onSearchChanged);
  }

  void _loadItems() async {
    final items = await DatabaseHelper.instance.getAllItems();
    setState(() {
      _allItems = items;
      _filteredItems = items;
    });
  }

  void _onSearchChanged() {
    String query = _controller.text.toLowerCase();
    setState(() {
      _filteredItems =
          _allItems
              .where((item) => item.name.toLowerCase().contains(query))
              .toList();
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E),
      appBar: AppBar(
        title: Text('Search Items'),
        backgroundColor: Color(0xFF2C2C2C),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search by item name...',
                hintStyle: TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Color(0xFF2C2C2C),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: Icon(Icons.search, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child:
                  _filteredItems.isEmpty
                      ? Center(
                        child: Text(
                          'No items found.',
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                      : ListView.builder(
                        itemCount: _filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = _filteredItems[index];
                          return Card(
                            color: Color(0xFF2A2A2A),
                            child: ListTile(
                              leading: Image(
                                image: ImageUtils.getImageProvider(
                                  item.imagePath,
                                ),
                                width: 50,
                                height: 50,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 50,
                                    height: 50,
                                    color: Colors.grey[700],
                                    child: Icon(
                                      Icons.image_not_supported,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),
                              title: Text(
                                item.name,
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                item.description,
                                style: TextStyle(color: Colors.white70),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            ItemDetailScreen(item: item),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
