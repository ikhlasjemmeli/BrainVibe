/*import 'dart:convert';

import 'package:Brainvibe/Features/Settings/Data/models/Auth_model.dart';
import 'package:Brainvibe/Features/Settings/Domain/entities/Auth.dart';
import 'package:dio/dio.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart' as getx;
import '/Core/SharedPreferences/sharedpreferences_controller.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class CoreBinding extends getx.Bindings {

  @override
  Future<void> dependencies() async {
    await getx.Get.putAsync(() async => await SharedPreferences.getInstance(),
        permanent: true);

    getx.Get.put(getApiClient(), permanent: true);
    getx.Get.put(
      SharedPreferencesController(
        getx.Get.find(),
      ),
      permanent: true,
    );


  }

}


Dio getApiClient() {
  Dio dio = Dio();

  SharedPreferences sp = getx.Get.find();

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        options.baseUrl = dotenv.get("BASE_URL", fallback: "");

        AuthEntity? ue;
        if (sp.getString(SP_USER) != null) {
          ue = AuthModel.fromJson(jsonDecode(sp.getString(SP_USER)!));
        }
        options.headers['Authorization'] =
        ue != null ? "Bearer ${ue.token}" : "";

        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioError error, handler) async {
        print(
            "error for the path : ${error.requestOptions.path} with status code :"
                " ${error.response?.statusCode} and error is  ${error.error}");

        if (error.response?.statusCode == 401) {
        } else {
          return handler.next(error);
        }
      },
    ),
  );

  return dio;
}*/

import 'dart:convert';

import 'package:Brainvibe/Features/Settings/Data/models/Auth_model.dart';
import 'package:Brainvibe/Features/Settings/Domain/entities/Auth.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart' as getx;
import '/Core/SharedPreferences/sharedpreferences_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';

class CoreBinding extends getx.Bindings {
  @override
  Future<void> dependencies() async {
    await getx.Get.putAsync(() async => await SharedPreferences.getInstance(), permanent: true);


    getx.Get.replace<Dio>(getApiClient());
    getx.Get.put(
      SharedPreferencesController(
        getx.Get.find(),
      ),
      permanent: true,
    );
  }
}

Dio getApiClient() {
  Dio dio = Dio();

  SharedPreferences sp = getx.Get.find();

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        options.baseUrl = dotenv.get("BASE_URL", fallback: "");

        AuthEntity? ue;
        if (sp.getString(SP_USER) != null) {
          ue = AuthModel.fromJson(jsonDecode(sp.getString(SP_USER)!));
        }
        // Ajoute automatiquement le header Authorization si le token existe
        if (ue != null && ue.token.isNotEmpty) {
          options.headers['Authorization'] = "Bearer ${ue.token}";
        } else {
          options.headers.remove('Authorization');
        }

        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioError error, handler) async {
        print(
            "error for the path : ${error.requestOptions.path} with status code :"
                " ${error.response?.statusCode} and error is  ${error.error}");

        return handler.next(error);
      },
    ),
  );

  return dio;
}
