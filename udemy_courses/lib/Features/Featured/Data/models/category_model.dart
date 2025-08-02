import 'dart:convert';
import '../../Domain/entities/category.dart';

class CategoryModel extends Category {
  CategoryModel({
    required int id,
    required String name,
    required String coverImage,
    required int noOfCourse,
  }) : super(
    id: id,
    name: name,
    coverImage: coverImage,
    noOfCourse: noOfCourse,
  );

  factory CategoryModel.fromRawJson(String str) =>
      CategoryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json['id'],
    name: json['name'],
    coverImage: json['coverImage'],
    noOfCourse: json['noOfCourse'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'coverImage': coverImage,
    'noOfCourse' :noOfCourse
  };

  static Map<String, dynamic> toJsonStatic(Category e) => {
    'id': e.id,
    'name': e.name,
    'coverImage': e.coverImage,
    'noOfCourse' :e.noOfCourse
  };
}
