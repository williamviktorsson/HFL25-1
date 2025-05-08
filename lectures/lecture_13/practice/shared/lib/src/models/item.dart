import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class Item extends Equatable {
  String description;
  String id;

  Item(this.description, [String? id]) : id = id ?? Uuid().v4();

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(json['description'], json['id']);
  }

  Map<String, dynamic> toJson() {
    return {"description": description, "id": id};
  }
  
  @override
  // TODO: implement props
  List<Object?> get props => [description,id];
}
