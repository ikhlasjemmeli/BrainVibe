import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../Domain/entities/Auth.dart';
import '../models/Auth_model.dart';
import '../models/Update_profile.dart';
import '../models/change_password_model.dart';
import '../models/login_model.dart';
import '../models/user_model.dart';

abstract class UserRemoteDatasource {
  Future<void> register(UserModel user);
  Future<AuthEntity> login(LoginModel user);
  Future<String> disableAccount();
  Future<String> updateProfile(UpdateProfileModel profile);
  Future<String> changePassword(ChangePasswordModel model);
}

class UserRemoteDatasourceImpl implements UserRemoteDatasource {
  final baseUrl = dotenv.env['BASE_URL'];
  final Dio client;
  UserRemoteDatasourceImpl(this.client);

  @override
  Future<void> register(UserModel user) async {
    final response = await client.post(
      '$baseUrl/api/User/register',
      data: user.toRegisterDto(),
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );
    if (response.statusCode != 200) {
      throw Exception(response.data['message'] ?? 'Registration failed');
    }
  }

  @override
  Future<AuthEntity> login(LoginModel user) async {
    final response = await client.post(
      '$baseUrl/api/User/login',
      data: user.toRegisterDto(),
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );
   /* if (response.statusCode != 200) {
      throw Exception(response.data['message'] ?? 'login failed');
    }*/
    if (response.statusCode == 200) {
     // return response.data is String ? response.data : "connexion avec succès.";
      return AuthModel.fromJson(response.data);
    }
    else if (response.statusCode == 401) {
  throw Exception(response.data ?? "Non autorisé.");
  } else {
  throw Exception(response.data ?? "Erreur lors de la connexion .");
  }

  }

  @override
  Future<String> disableAccount() async {
    final response = await client.put(
      '$baseUrl/api/User/disable-account',
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );
    if (response.statusCode == 200) {
      return response.data is String ? response.data : "Compte désactivé.";
    } else if (response.statusCode == 401) {
      throw Exception(response.data ?? "Non autorisé.");
    } else {
      throw Exception(response.data ?? "Erreur lors de la désactivation.");
    }
  }

  @override
  Future<String> updateProfile(UpdateProfileModel profile) async {
    final response = await client.put(
      '$baseUrl/api/User/update-profile',
      data: profile.toJson(),
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );
    if (response.statusCode == 200) {
      return response.data is String ? response.data : "Profil mis à jour avec succès.";
    } else if (response.statusCode == 401) {
      throw Exception(response.data ?? "Non autorisé.");
    } else {
      throw Exception(response.data ?? "Erreur lors de la mise à jour du profil.");
    }
  }

  @override
  Future<String> changePassword(ChangePasswordModel model) async {
    final response = await client.put(
      '$baseUrl/api/User/change-password',
      data: model.toJson(),
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );
    if (response.statusCode == 200) {
      return response.data is String ? response.data : "Mot de passe modifié avec succès.";
    } else if (response.statusCode == 401) {
      throw Exception(response.data ?? "Non autorisé.");
    } else {
      throw Exception(response.data ?? "Erreur lors du changement de mot de passe.");
    }
  }
}