import '../../Domain/entities/category.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import '../models/category_model.dart';
abstract class CategoryRemoteDataSource {
  Future<List<Category>> getCategoriesFromApi();
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final Dio client;
  final baseUrl = dotenv.env['BASE_URL'];
  CategoryRemoteDataSourceImpl(this.client);



  @override
  Future<List<Category>> getCategoriesFromApi() async {

    final response = await client.get('$baseUrl/api/Category');

    print("response : ${response.statusCode}");
    if (response.statusCode == 200) {

      List<dynamic> l = jsonDecode(response.data);
      List<Category> list = [];
      for (var element in l) {
        list.add(CategoryModel.fromJson(element) as Category);
      
      }
      return list;

    } else {
      throw Exception('Erreur lors de la récupération des catégories');
    }
  }


}
