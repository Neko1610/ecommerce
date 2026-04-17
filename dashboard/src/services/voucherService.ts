import api, { parseArray } from './api';
import type { Voucher, VoucherPayload } from '../types';

const mapVoucher = (raw: any): Voucher => ({
  id: Number(raw?.id || 0),
  code: String(raw?.code || ''),
  discountPercent: Number(raw?.discountPercent || 0),
  expiryDate: String(raw?.expiryDate || '').slice(0, 10),
  minOrder: Number(raw?.minOrder || 0),
  active: Boolean(raw?.active),
});

export const voucherService = {
  async getVouchers() {
    const { data } = await api.get('/admin/vouchers');
    return parseArray<any>(data).map(mapVoucher);
  },

  async createVoucher(payload: VoucherPayload) {
    const { data } = await api.post('/admin/vouchers', payload);
    return mapVoucher(data);
  },

  async updateVoucher(id: number, payload: VoucherPayload) {
    const { data } = await api.put(`/admin/vouchers/${id}`, payload);
    return mapVoucher(data);
  },

  async deleteVoucher(id: number) {
    await api.delete(`/admin/vouchers/${id}`);
  },
};
