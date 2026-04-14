class Category {
  final int id;
  final String name;
  final String? banner;
  final List<Category> children;

  Category({
    required this.id,
    required this.name,
    this.banner,
    required this.children,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      banner: json['banner'],
      children: (json['children'] as List? ?? [])
          .map((e) => Category.fromJson(e))
          .toList(),
    );
  }
}