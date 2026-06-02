import 'package:flutter/material.dart';

import '../models/payment_method_model.dart';
import '../services/payment_service.dart';

class PaymentProvider extends ChangeNotifier {
  final PaymentService _service = PaymentService();

  List<PaymentMethodModel> paymentMethods = [];

  PaymentMethodModel? selectedMethod;

  bool isLoading = false;

  PaymentProvider() {
    loadMethods();
  }

  Future<void> loadMethods() async {
    try {
      isLoading = true;

      notifyListeners();

      paymentMethods = await _service.getMethods();

      paymentMethods.sort((a, b) {
        int getPriority(PaymentType type) {
          switch (type) {
            case PaymentType.creditCard:
              return 0;

            case PaymentType.momo:
            case PaymentType.zaloPay:
              return 1;

            case PaymentType.bank:
              return 2;
          }
        }

        return getPriority(a.type).compareTo(getPriority(b.type));
      });

      try {
        selectedMethod = paymentMethods.firstWhere((e) => e.isDefault);
      } catch (_) {
        selectedMethod = null;
      }
    } catch (e) {
      debugPrint('LOAD PAYMENT ERROR: $e');
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  Future<void> addMethod(PaymentMethodModel method) async {
    try {
      final shouldSetDefault = paymentMethods.isEmpty;

      final normalizedMethod = method.copyWith(isDefault: shouldSetDefault);

      await _service.addMethod(normalizedMethod);

      await loadMethods();
    } catch (e) {
      debugPrint('ADD PAYMENT ERROR: $e');
    }
  }

  Future<void> updateMethod(PaymentMethodModel method) async {
    try {
      await _service.updateMethod(method);

      await loadMethods();
    } catch (e) {
      debugPrint('UPDATE PAYMENT ERROR: $e');
    }
  }

  Future<void> removeMethod(String id) async {
    try {
      await _service.removeMethod(id);

      await loadMethods();
    } catch (e) {
      debugPrint('REMOVE PAYMENT ERROR: $e');
    }
  }

  Future<void> unlinkMethod(String id) async {
    try {
      await _service.unlinkMethod(id);

      await loadMethods();
    } catch (e) {
      debugPrint('UNLINK PAYMENT ERROR: $e');
    }
  }

  Future<void> setDefaultMethod(String id) async {
    try {
      await _service.setDefaultMethod(id);

      await Future.delayed(const Duration(milliseconds: 150));

      await loadMethods();
    } catch (e) {
      debugPrint('DEFAULT PAYMENT ERROR: $e');
    }
  }

  void selectMethod(PaymentMethodModel method) {
    selectedMethod = method;

    notifyListeners();
  }

  void clearSelectedMethod() {
    selectedMethod = null;

    notifyListeners();
  }
}
