export const VND_EXCHANGE_RATE = 26000;

const vndFormatter = new Intl.NumberFormat('vi-VN');

export const toVND = (price: number) => price * VND_EXCHANGE_RATE;

export const formatVND = (price: number) => formatRawVND(toVND(price));

export const formatRawVND = (amount: number) => `${vndFormatter.format(Math.round(amount))}₫`;

export const formatOrderTotalVND = (subtotal: number, discount: number, shippingFee: number) =>
  formatRawVND(toVND(subtotal - discount) + shippingFee);
