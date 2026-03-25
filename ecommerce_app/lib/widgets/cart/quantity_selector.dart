import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const QuantitySelector({
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _btn(Icons.remove, onDecrease, disabled: quantity <= 1),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text("$quantity"),
        ),
        _btn(Icons.add, onIncrease),
      ],
    );
  }

  Widget _btn(IconData icon, VoidCallback onTap, {bool disabled = false}) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: 28,
        height: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: disabled ? Colors.grey[300] : Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }
}
