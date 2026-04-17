import api, { parseArray } from './api';
import type { OrderDetail, OrderDetailItem, OrderSummary } from '../types';

const mapOrderSummary = (raw: any): OrderSummary => ({
  id: Number(raw?.id || 0),
  status: String(raw?.status || 'UNKNOWN'),
  total: Number(raw?.total || 0),
  createdAt: String(raw?.createdAt || ''),
  images: Array.isArray(raw?.images) ? raw.images.map((image: unknown) => String(image)) : [],
  title: String(raw?.title || `Order #${raw?.id || ''}`),
});

const mapOrderDetailItem = (raw: any): OrderDetailItem => ({
  productName: String(raw?.productName || ''),
  image: String(raw?.image || 'https://via.placeholder.com/80x80?text=Item'),
  quantity: Number(raw?.quantity || 0),
  price: Number(raw?.price || 0),
  variant: String(raw?.variant || ''),
});

export const orderService = {
  async getOrders() {
    try {
      const { data } = await api.get('/admin/orders');
      return parseArray<any>(data).map(mapOrderSummary);
    } catch {
      const { data } = await api.get('/orders');
      return parseArray<any>(data).map(mapOrderSummary);
    }
  },

  async getOrderDetail(id: number): Promise<OrderDetail> {
    let data: any;
    try {
      ({ data } = await api.get(`/admin/orders/${id}`));
    } catch {
      ({ data } = await api.get(`/orders/${id}`));
    }

    return {
      order: {
        id: Number(data?.order?.id || id),
        status: String(data?.order?.status || 'UNKNOWN'),
        total: Number(data?.order?.total || 0),
        subtotal: Number(data?.order?.subtotal || 0),
        discount: Number(data?.order?.discount || 0),
        shippingFee: Number(data?.order?.shippingFee || 0),
        address: String(data?.order?.address || ''),
        phone: String(data?.order?.phone || ''),
        paymentMethod: String(data?.order?.paymentMethod || ''),
      },
      items: parseArray<any>(data?.items).map(mapOrderDetailItem),
    };
  },

  async updateOrderStatus(id: number, status: string) {
    let data: any;
    try {
      ({ data } = await api.put(`/admin/orders/${id}/status`, { status }));
    } catch {
      ({ data } = await api.put(`/orders/${id}/status`, { status }));
    }

    return {
      id: Number(data?.id || id),
      status: String(data?.status || status),
    };
  },
};
