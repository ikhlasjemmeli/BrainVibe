import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Brainvibe/Features/Featured/Domain/entities/category.dart';
import 'package:Brainvibe/Features/Featured/Domain/usecases/get_categories.dart';

class CategoryController extends GetxController {
  final GetCategories _getCategoryUsecase;
  CategoryController(this._getCategoryUsecase);

  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<bool> isUpdateLoading = ValueNotifier(false);
  List<Category> notifierListClass = [];

  List<Category> originalList = [];

  final nomcontroller = TextEditingController();
  final descriptioncontroller = TextEditingController();

var listcategories = <Category>[].obs;


  Future<List<Category>> getCategories() async {

    List<Category> categories = await _getCategoryUsecase();

  listcategories.assignAll(categories);
  notifierListClass = categories;
  originalList = categories;

  return categories;
}

  Future<List<Category>> listCategories() async {
    return await _getCategoryUsecase();
  }


}
