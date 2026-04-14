import 'package:flutter/material.dart';
import 'filter_item.dart';

class SubCategoryFilter extends StatelessWidget {
  final List subs;
  final int? selectedSubId;
  final Function(int?) onSelect;

  const SubCategoryFilter({
    super.key,
    required this.subs,
    required this.selectedSubId,
    required this.onSelect,
  });

  static const int maxVisible = 5;

  @override
  Widget build(BuildContext context) {
    List visibleSubs;

    if (subs.length > maxVisible) {
      visibleSubs = subs.sublist(0, maxVisible);

      final selectedSub = subs.firstWhere(
        (s) => s.id == selectedSubId,
        orElse: () => null,
      );

      if (selectedSub != null &&
          !visibleSubs.any((s) => s.id == selectedSubId)) {
        visibleSubs[visibleSubs.length - 1] = selectedSub;
      }
    } else {
      visibleSubs = subs;
    }
    final hasMore = subs.length > maxVisible;

    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          /// 👉 ALL
          FilterItem(
            title: "All",
            isSelected: selectedSubId == null,
            onTap: () => onSelect(null),
          ),

          /// 👉 SUB (HIỂN THỊ GIỚI HẠN)
          ...visibleSubs.map(
            (sub) => FilterItem(
              title: sub.name,
              isSelected: selectedSubId == sub.id,
              onTap: () => onSelect(sub.id),
            ),
          ),

          /// 👉 OTHER
          if (hasMore)
            FilterItem(
              title: "Other",
              isSelected: false,
              onTap: () {
                _showAllSub(context);
              },
            ),
        ],
      ),
    );
  }

  void _showAllSub(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ListView(
          children: [
            /// 👉 ALL
            ListTile(
              title: Text("All"),
              onTap: () {
                Navigator.pop(context);
                onSelect(null);
              },
            ),

            ...subs.map(
              (sub) => ListTile(
                title: Text(sub.name),
                onTap: () {
                  Navigator.pop(context);
                  onSelect(sub.id);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
