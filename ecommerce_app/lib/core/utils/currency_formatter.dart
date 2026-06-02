import 'package:intl/intl.dart';

const double vndExchangeRate = 26000;

final NumberFormat _vndFormatter = NumberFormat.decimalPattern('vi_VN');

double toVND(num price) => price.toDouble() * vndExchangeRate;

String formatVND(num price) => formatRawVND(toVND(price));

String formatRawVND(num amount) {
  final value = amount.round();
  final sign = value < 0 ? '-' : '';
  return '$sign${_vndFormatter.format(value.abs())}₫';
}
