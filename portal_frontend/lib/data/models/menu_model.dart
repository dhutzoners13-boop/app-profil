class MenuItemModel {
  final int id;
  final String label;
  final String? url;
  final String? type;
  final int sortOrder;
  final List<MenuItemModel> children;

  MenuItemModel({
    required this.id,
    required this.label,
    this.url,
    this.type,
    required this.sortOrder,
    this.children = const [],
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    var childrenList = <MenuItemModel>[];
    if (json['children'] is List) {
      childrenList = (json['children'] as List)
          .map((c) => MenuItemModel.fromJson(c as Map<String, dynamic>))
          .toList();
    }

    return MenuItemModel(
      id: json['id'] as int? ?? 0,
      label: json['label']?.toString() ?? '',
      url: json['url']?.toString(),
      type: json['type']?.toString(),
      sortOrder: json['sort_order'] as int? ?? 0,
      children: childrenList,
    );
  }
}

class MenuModel {
  final int id;
  final String name;
  final String location;
  final List<MenuItemModel> items;

  MenuModel({
    required this.id,
    required this.name,
    required this.location,
    required this.items,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    var itemsList = <MenuItemModel>[];
    if (json['items'] is List) {
      itemsList = (json['items'] as List)
          .map((i) => MenuItemModel.fromJson(i as Map<String, dynamic>))
          .toList();
    }

    return MenuModel(
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      items: itemsList,
    );
  }
}

