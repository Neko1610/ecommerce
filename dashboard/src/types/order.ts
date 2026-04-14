export const ORDER_STATUSES = ['PENDING', 'CONFIRMED', 'SHIPPED', 'DELIVERED', 'CANCELLED'] as const;
export type OrderStatus = (typeof ORDER_STATUSES)[number];

export interface OrderSummary {
  id: number;
  status: OrderStatus | string;
  total: number;
  createdAt: string;
  images: string[];
  title: string;
}

export interface OrderDetailItem {
  productName: string;
  image: string;
  quantity: number;
  price: number;
  variant: string;
}

export interface OrderDetail {
  order: {
    id: number;
    status: OrderStatus | string;
    total: number;
    subtotal: number;
    discount: number;
    shippingFee: number;
    address: string;
    phone: string;
    paymentMethod: string;
  };
  items: OrderDetailItem[];
}
