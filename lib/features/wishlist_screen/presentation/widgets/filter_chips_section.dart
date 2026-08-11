import 'package:flutter/material.dart';

class FilterChipsSection extends StatefulWidget {
  final List<String> filters;

  const FilterChipsSection({Key? key, required this.filters}) : super(key: key);

  @override
  State<FilterChipsSection> createState() => _FilterChipsSectionState();
}

class _FilterChipsSectionState extends State<FilterChipsSection> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        itemCount: widget.filters.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12.0),
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFD3C8C4) : Colors.transparent, // Beige if selected
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.2),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                widget.filters[index],
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
