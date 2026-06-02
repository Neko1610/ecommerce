enum PaymentType { momo, zaloPay, creditCard, bank }

extension PaymentTypeDetails on PaymentType {
  String get apiValue {
    switch (this) {
      case PaymentType.momo:
        return 'MOMO';

      case PaymentType.zaloPay:
        return 'ZALOPAY';

      case PaymentType.creditCard:
        return 'CREDIT_CARD';

      case PaymentType.bank:
        return 'BANK';
    }
  }

  String get displayTitle {
    switch (this) {
      case PaymentType.momo:
        return 'MoMo Wallet';

      case PaymentType.zaloPay:
        return 'ZaloPay';

      case PaymentType.creditCard:
        return 'Credit Card';

      case PaymentType.bank:
        return 'Bank Account';
    }
  }

  String get icon {
    switch (this) {
      case PaymentType.momo:
        return 'assets/icons/momo.png';

      case PaymentType.zaloPay:
        return 'assets/icons/zalopay.png';

      case PaymentType.creditCard:
        return 'assets/icons/card.png';

      case PaymentType.bank:
        return 'assets/icons/bank.png';
    }
  }
}

class PaymentMethodModel {
  final String id;

  final PaymentType type;

  final String title;

  final String subtitle;

  // THÊM
  final String? expiry;

  final bool isDefault;

  final bool isLinked;

  const PaymentMethodModel({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,

    // THÊM
    this.expiry,

    this.isDefault = false,
    this.isLinked = true,
  });

  PaymentMethodModel copyWith({
    bool? isDefault,
    String? title,
    String? subtitle,
    String? expiry,
    bool? isLinked,
    PaymentType? type,
  }) {
    return PaymentMethodModel(
      id: id,
      type: type ?? this.type,

      title: title ?? this.title,

      subtitle: subtitle ?? this.subtitle,

      expiry: expiry ?? this.expiry,

      isDefault: isDefault ?? this.isDefault,

      isLinked: isLinked ?? this.isLinked,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': int.tryParse(id),
      'type': type.name,
      'title': title,
      'subtitle': subtitle,
      'expiry': expiry,
      'isDefault': isDefault,
      'isLinked': isLinked,
    };
  }

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id']?.toString() ?? '',

      type: parseType(json['type']),

      title: json['title']?.toString() ?? '',

      subtitle: json['subtitle']?.toString() ?? '',

      expiry: json['expiry'],

      isDefault: json['isDefault'] ?? false,

      isLinked: json['isLinked'] ?? true,
    );
  }

  static PaymentType parseType(dynamic value) {
    final type = value.toString().toLowerCase();

    switch (type) {
      case 'momo':
        return PaymentType.momo;

      case 'zalopay':
      case 'zalo_pay':
        return PaymentType.zaloPay;

      case 'creditcard':
      case 'credit_card':
      case 'credit-card':
        return PaymentType.creditCard;

      case 'bank':
        return PaymentType.bank;

      default:
        return PaymentType.creditCard;
    }
  }
}
