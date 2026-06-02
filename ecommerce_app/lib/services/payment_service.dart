import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/payment_method_model.dart';
import 'auth_service.dart';

class PaymentService {
  static const String baseUrl =
      'http://10.0.2.2:8080/api/payments';

  static const Duration _timeout =
      Duration(seconds: 15);

  final AuthService _authService =
      AuthService();

  Future<Map<String, String>>
  _headers() async {
    final token =
        await _authService.getToken();

    return {
      'Content-Type': 'application/json',

      'Authorization':
          'Bearer $token',
    };
  }

  Future<List<PaymentMethodModel>>
  getMethods() async {
    final response = await http
        .get(
          Uri.parse(baseUrl),

          headers: await _headers(),
        )
        .timeout(_timeout);

    final data = _decodeResponse(
      response,
    );

    if (data is! List) {
      throw Exception(
        'Invalid payment response',
      );
    }

    return data
        .map(
          (e) =>
              PaymentMethodModel.fromJson(
                e as Map<String, dynamic>,
              ),
        )
        .where(
          (method) => method.isLinked,
        )
        .toList();
  }

  Future<void> addMethod(
    PaymentMethodModel method,
  ) async {
    final response = await http
        .post(
          Uri.parse(baseUrl),

          headers: await _headers(),

          body: jsonEncode(
            method.toJson(),
          ),
        )
        .timeout(_timeout);

    _decodeResponse(response);
  }

  Future<void> updateMethod(
    PaymentMethodModel method,
  ) async {
    final response = await http
        .put(
          Uri.parse(
            '$baseUrl/${method.id}',
          ),

          headers: await _headers(),

          body: jsonEncode(
            method.toJson(),
          ),
        )
        .timeout(_timeout);

    _decodeResponse(response);
  }

  Future<void> removeMethod(
    String id,
  ) async {
    final response = await http
        .delete(
          Uri.parse('$baseUrl/$id'),

          headers: await _headers(),
        )
        .timeout(_timeout);

    _decodeResponse(response);
  }

  Future<void> setDefaultMethod(
    String id,
  ) async {
    final response = await http
        .put(
          Uri.parse(
            '$baseUrl/default/$id',
          ),

          headers: await _headers(),
        )
        .timeout(_timeout);

    _decodeResponse(response);
  }

  Future<void> unlinkMethod(
    String id,
  ) async {
    final response = await http
        .put(
          Uri.parse(
            '$baseUrl/unlink/$id',
          ),

          headers: await _headers(),
        )
        .timeout(_timeout);

    _decodeResponse(response);
  }

  dynamic _decodeResponse(
    http.Response response,
  ) {
    dynamic data;

    try {
      data =
          response.body.isEmpty
              ? null
              : jsonDecode(
                response.body,
              );
    } catch (_) {
      throw Exception(
        'Invalid JSON response from payment API',
      );
    }

    if (response.statusCode >= 400) {
      if (data is Map &&
          data['message'] != null) {
        throw Exception(
          data['message'],
        );
      }

      throw Exception(
        'Payment API error ${response.statusCode}',
      );
    }

    return data;
  }
}