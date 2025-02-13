class Item {
  String description;
  int id;

  Item(this.description, [this.id = -1]);

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(json['description'], json['id']);
  }

  Map<String, dynamic> toJson() {
    return {"description": description, "id": id};
  }
}

