import 'package:flutter/material.dart';

class SizeSelector extends StatelessWidget {
  final List<String> sizes;
  final List<String> availableSizes;
  final String selectedSize;
  final Function(String) onSelect;

  const SizeSelector({
    super.key,
    required this.sizes,
    required this.availableSizes,
    required this.selectedSize,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Wrap(
        spacing: 10,
        children: sizes.map((s) {
          final isSelected = s == selectedSize;
          final isAvailable = availableSizes.contains(
            s,
          ); // Kiểm tra size có sẵn

          return GestureDetector(
            onTap: isAvailable ? () => onSelect(s) : null,
            // Disable if not available
            child: Container(
              width: 60,
              height: 45,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected
                      ? Color(0xff137fec)
                      : (isAvailable
                            ? Colors.grey.shade300
                            : Colors.grey), // Nếu không có size sẽ mờ
                  width: isSelected ? 2 : 1,
                ),
                color: isSelected
                    ? Color(0xff137fec).withOpacity(0.1)
                    : Colors.white,
              ),
              child: Text(
                s,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? Color(0xff137fec)
                      : (isAvailable
                            ? Colors.black
                            : Colors
                                  .grey), // Màu chữ thay đổi khi không có size
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
