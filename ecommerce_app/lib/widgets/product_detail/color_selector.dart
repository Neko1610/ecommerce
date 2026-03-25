import 'package:flutter/material.dart';

class ColorSelector extends StatelessWidget {
  final List<String> colors;
  final String selectedColor;
  final Function(String) onSelect;

  const ColorSelector({
    super.key,
    required this.colors,
    required this.selectedColor,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Wrap(
        spacing: 10,
        children: colors.map((color) {
          final isSelected = color == selectedColor;

          return GestureDetector(
            onTap: () => onSelect(color),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? Color(0xff137fec) // Màu khi được chọn
                      : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
                color: _getColorFromString(
                  color,
                ), // Màu sắc nút sẽ thay đổi theo color
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getColorFromString(String color) {
    switch (color.toLowerCase()) {
      case "đen":
        return Colors.black;
      case "trắng":
        return Colors.white;
      case "xanh":
        return Colors.blue;
      case "đỏ":
        return Colors.red;
      case "tím":
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
