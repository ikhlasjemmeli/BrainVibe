import 'package:Brainvibe/Features/Featured/Domain/entities/category.dart';
import 'package:Brainvibe/Features/Featured/Domain/repositories/category_repository.dart';
import '../datasources/category_remote_data_source.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Category>> getCategories() async {
    final models = await remoteDataSource.getCategoriesFromApi();
    return models.map((model) => Category(id: model.id, name: model.name, coverImage: model.coverImage, noOfCourse: model.noOfCourse)).toList();
  }


}
