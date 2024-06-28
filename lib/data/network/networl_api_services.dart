import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:getx_constants/data/app_exceptions.dart';
import 'package:getx_constants/data/network/base_api_services.dart';
import 'package:http/http.dart' as http;

class NetworkApiServices extends BaseApiServices {
  @override
  Future<dynamic> getApi(String url) async {
    if (kDebugMode) {
      print('url: $url');
    }
    dynamic responseJson;
    try {
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw NoInternetException('');
    } on RequestTimeoutException {
      throw RequestTimeoutException('');
    } on UnauthorisedException {
      throw UnauthorisedException('');
    } on BadRequestException {
      throw BadRequestException('');
    } on FetchDataException {
      throw FetchDataException('');
    } on UnknownException {
      throw UnknownException('');
    } on NoDataException {
      throw NoDataException('');
    } on NoMoreDataException {
      throw NoMoreDataException('');
    } on NoDataFoundException {
      throw NoDataFoundException('');
    } on NoServiceFoundException {
      throw NoServiceFoundException('');
    } on InvalidFormatException {
      throw InvalidFormatException('');
    } on InvalidInputException {
      throw InvalidInputException('');
    } catch (e) {
      throw UnknownException('');
    }
    return responseJson;
  }

  @override
  Future<dynamic> postApi(String url, var data) async {
    if (kDebugMode) {
      print('url: $url');
      print('data: $data');
    }
    dynamic responseJson;
    try {
      final response = await http
          .post(Uri.parse(url), body: jsonEncode(data))
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw NoInternetException('');
    } on RequestTimeoutException {
      throw RequestTimeoutException('');
    } on UnauthorisedException {
      throw UnauthorisedException('');
    } on BadRequestException {
      throw BadRequestException('');
    } on FetchDataException {
      throw FetchDataException('');
    } on UnknownException {
      throw UnknownException('');
    } on NoDataException {
      throw NoDataException('');
    } on NoMoreDataException {
      throw NoMoreDataException('');
    } on NoDataFoundException {
      throw NoDataFoundException('');
    } on NoServiceFoundException {
      throw NoServiceFoundException('');
    } on InvalidFormatException {
      throw InvalidFormatException('');
    } on InvalidInputException {
      throw InvalidInputException('');
    } catch (e) {
      throw UnknownException('');
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException('');
      case 401:
      case 403:
        throw UnauthorisedException('');
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
