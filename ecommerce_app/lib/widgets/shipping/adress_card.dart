import 'package:flutter/material.dart';

class AddressCard extends StatelessWidget {
  final Map address;
  final VoidCallback onSetDefault;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AddressCard({
    super.key,
    required this.address,
    required this.onSetDefault,
    this.onEdit,
    this.onDelete,
  });
  bool parseBool(dynamic value) {
    if (value == true) return true;
    if (value == 1) return true;
    if (value == "true") return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final isDefault = parseBool(address['isDefault']);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(
          color: isDefault ? Colors.blue : Colors.grey.shade300,
          width: isDefault ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: isDefault ? Colors.blue.shade50 : Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.blue),
                  const SizedBox(width: 6),
                  Text(
                    address['label'] ?? "Address",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 6),
                  if (isDefault)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "DEFAULT",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),

              /// ✏️ + 🗑
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),

          /// ADDRESS
          Text(
            address['fullAddress'] ?? "",
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
