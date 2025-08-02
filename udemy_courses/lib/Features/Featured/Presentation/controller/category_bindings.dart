import 'package:get/get.dart';
import 'package:Brainvibe/Features/Featured/Data/datasources/category_remote_data_source.dart';
import 'package:Brainvibe/Features/Featured/Data/repositories/category_repository_impl.dart';
import 'package:Brainvibe/Features/Featured/Domain/repositories/category_repository.dart';

import 'package:Brainvibe/Features/Featured/Domain/usecases/get_categories.dart';

import '../controller/category_controller.dart';

class CategoryBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<CategoryRemoteDataSource>(
        CategoryRemoteDataSourceImpl(Get.find()));
    Get.put<CategoryRepository>(
        CategoryRepositoryImpl(Get.find()));
    Get.put(GetCategories(Get.find()));


    Get.put(CategoryController(
      Get.find(),

    ));
  }
}
