export interface Voucher {
  id: number;
  code: string;
  discountPercent: number;
  expiryDate: string;
  minOrder: number;
  active: boolean;
}

export interface VoucherPayload {
  code: string;
  discountPercent: number;
  expiryDate: string;
  minOrder: number;
  active: boolean;
}
