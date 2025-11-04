import 'package:flutter/material.dart';

class SearchFilterBar extends StatefulWidget {
  final void Function(String searchText, String category, String availability)
      onFilterChanged;
  final void Function(String sortBy)? onSortChanged;

  const SearchFilterBar({
    super.key,
    required this.onFilterChanged,
    this.onSortChanged,
  });

  @override
  State<SearchFilterBar> createState() => _SearchFilterBarState();
}

class _SearchFilterBarState extends State<SearchFilterBar> {
  final TextEditingController searchCtrl = TextEditingController();
  String selectedCategory = 'All';
  String selectedAvailability = 'All';
  String selectedSort = 'None';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
      
          SizedBox(
            width: 250,
            child: TextField(
              controller: searchCtrl,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                labelText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (_) => widget.onFilterChanged(
                searchCtrl.text,
                selectedCategory,
                selectedAvailability,
              ),
            ),
          ),

         
          Row(
            children: [
       
              DropdownButton<String>(
                value: selectedCategory,
                items: ['All', 'Electronics', 'Furniture', 'Other']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  setState(() => selectedCategory = value!);
                  widget.onFilterChanged(
                    searchCtrl.text,
                    selectedCategory,
                    selectedAvailability,
                  );
                },
              ),
              const SizedBox(width: 10),

           
              DropdownButton<String>(
                value: selectedAvailability,
                items: ['All', 'In stock', 'Out of stock']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  setState(() => selectedAvailability = value!);
                  widget.onFilterChanged(
                    searchCtrl.text,
                    selectedCategory,
                    selectedAvailability,
                  );
                },
              ),
              const SizedBox(width: 10),

         
              DropdownButton<String>(
                value: selectedSort,
                items: ['None', 'Name', 'Category', 'Stock']
                    .map((e) => DropdownMenuItem(value: e, child: Text('Sort by $e')))
                    .toList(),
                onChanged: (value) {
                  setState(() => selectedSort = value!);
                  if (widget.onSortChanged != null && value != 'None') {
                    widget.onSortChanged!(
                        value?.toLowerCase() == 'stock' ? 'inStock' : value!.toLowerCase());
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
