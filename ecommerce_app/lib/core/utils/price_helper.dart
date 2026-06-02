import '../../models/cart_item.dart';
import '../../models/product.dart';
import '../../models/variant.dart';

class PriceHelper {
  const PriceHelper._();

  static double getEffectivePrice(Product product, Variant? variant) {
    if (variant == null) return product.minPrice;
    return variant.flashSale ? variant.price : variant.price;
  }

  static double getOriginalPrice(Product product, Variant? variant) {
    if (variant == null) return product.minPrice;
    if (variant.flashSale) return variant.oldPrice ?? variant.price;
    return variant.price;
  }

  static int? getDiscountPercent(Product product, Variant? variant) {
    final effective = getEffectivePrice(product, variant);
    final original = getOriginalPrice(product, variant);
    if (original <= effective || original <= 0) return null;
    return (((original - effective) / original) * 100).round();
  }

  static double cartSubtotal(List<CartItem> items) {
    return items.fold(0, (sum, item) => sum + item.price * item.quantity);
  }

  static double voucherDiscount(double subtotal, double discountPercent) {
    return subtotal * discountPercent / 100;
  }
}
