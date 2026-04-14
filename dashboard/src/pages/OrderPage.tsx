import { useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import Button from '../components/Button';
import Modal from '../components/Modal';
import SearchInput from '../components/SearchInput';
import Table, { type TableColumn } from '../components/Table';
import { orderService } from '../services/orderService';
import { ORDER_STATUSES, type OrderDetail, type OrderSummary } from '../types';

const statusClassName: Record<string, string> = {
  PENDING: 'bg-amber-50 text-amber-600',
  CONFIRMED: 'bg-sky-50 text-sky-600',
  SHIPPED: 'bg-indigo-50 text-indigo-600',
  DELIVERED: 'bg-emerald-50 text-emerald-600',
  CANCELLED: 'bg-rose-50 text-rose-600',
};

function OrderPage() {
  const [orders, setOrders] = useState<OrderSummary[]>([]);
  const [search, setSearch] = useState('');
  const [loading, setLoading] = useState(true);
  const [detailLoading, setDetailLoading] = useState(false);
  const [updatingOrderId, setUpdatingOrderId] = useState<number | null>(null);
  const [selectedOrder, setSelectedOrder] = useState<OrderDetail | null>(null);
  const [detailOpen, setDetailOpen] = useState(false);

  const loadOrders = async () => {
    try {
      setLoading(true);
      const data = await orderService.getOrders();
      setOrders(data);
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Failed to load orders');
    } finally {
      setLoading(false);
    }
  };

  const applyStatusLocally = (orderId: number, status: string) => {
    setOrders((current) =>
      current.map((order) => (order.id === orderId ? { ...order, status } : order)),
    );
    setSelectedOrder((current) =>
      current && current.order.id === orderId
        ? { ...current, order: { ...current.order, status } }
        : current,
    );
  };

  const handleStatusChange = async (orderId: number, status: string) => {
    try {
      setUpdatingOrderId(orderId);
      const updated = await orderService.updateOrderStatus(orderId, status);
      applyStatusLocally(orderId, updated.status);
      toast.success('Order status updated');
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Failed to update order status');
    } finally {
      setUpdatingOrderId(null);
    }
  };

  useEffect(() => {
    void loadOrders();
  }, []);

  const filteredOrders = useMemo(() => {
    const normalized = search.toLowerCase();
    return orders.filter(
      (order) =>
        order.title.toLowerCase().includes(normalized) ||
        order.status.toLowerCase().includes(normalized) ||
        String(order.id).includes(normalized),
    );
  }, [orders, search]);

  const handleView = async (orderId: number) => {
    try {
      setDetailLoading(true);
      const detail = await orderService.getOrderDetail(orderId);
      setSelectedOrder(detail);
      setDetailOpen(true);
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Failed to load order detail');
    } finally {
      setDetailLoading(false);
    }
  };

  const columns: TableColumn<OrderSummary>[] = [
    {
      key: 'order',
      header: 'Order',
      render: (order) => (
        <div>
          <p className="font-semibold text-slate-900">{order.title}</p>
          <p className="mt-1 text-xs text-slate-500">Placed: {order.createdAt}</p>
        </div>
      ),
    },
    {
      key: 'preview',
      header: 'Preview',
      render: (order) => (
        <div className="flex -space-x-2">
          {order.images.slice(0, 3).map((image, index) => (
            <img
              key={`${image}-${index}`}
              src={image}
              alt={`Order ${order.id}`}
              className="h-10 w-10 rounded-full border-2 border-white object-cover"
            />
          ))}
        </div>
      ),
    },
    {
      key: 'status',
      header: 'Status',
      render: (order) => (
        <span
          className={`rounded-full px-3 py-1 text-xs font-semibold ${
            statusClassName[order.status] || 'bg-slate-100 text-slate-600'
          }`}
        >
          {order.status}
        </span>
      ),
    },
    {
      key: 'updateStatus',
      header: 'Update Status',
      render: (order) => (
        <select
          value={order.status}
          disabled={updatingOrderId === order.id}
          onChange={(event) => void handleStatusChange(order.id, event.target.value)}
          className="w-full min-w-[160px] rounded-2xl border border-slate-200 bg-white px-3 py-2 text-sm outline-none transition focus:border-teal-500"
        >
          {ORDER_STATUSES.map((status) => (
            <option key={status} value={status}>
              {status}
            </option>
          ))}
        </select>
      ),
    },
    {
      key: 'total',
      header: 'Total',
      render: (order) => <span className="font-medium text-slate-900">${order.total.toFixed(2)}</span>,
    },
    {
      key: 'actions',
      header: 'Actions',
      className: 'text-right',
      render: (order) => (
        <Button size="sm" variant="secondary" onClick={() => handleView(order.id)}>
          View detail
        </Button>
      ),
    },
  ];

  return (
    <div className="space-y-6">
      <section className="rounded-[32px] border border-white/70 bg-white/85 p-6 shadow-soft">
        <p className="text-sm font-semibold uppercase tracking-[0.3em] text-teal-600">Orders</p>
        <h2 className="mt-3 text-3xl font-semibold text-slate-950">Order management</h2>
        <p className="mt-3 max-w-3xl text-sm leading-6 text-slate-500">
          Review recent orders and inspect their line items, payment method, shipping address,
          totals, and status.
        </p>
      </section>

      <section className="rounded-[32px] border border-white/70 bg-white/90 p-6 shadow-soft">
        <div className="mb-6 flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
          <div className="max-w-md">
            <SearchInput
              value={search}
              onChange={setSearch}
              placeholder="Search by order id, title, or status..."
            />
          </div>
          <p className="text-sm text-slate-500">{filteredOrders.length} orders found</p>
        </div>

        <Table
          columns={columns}
          data={filteredOrders}
          loading={loading}
          emptyTitle="No orders found"
          emptyDescription="Orders returned by the backend will appear here."
          keyExtractor={(order) => order.id}
        />
      </section>

      <Modal
        open={detailOpen}
        onClose={() => setDetailOpen(false)}
        title={selectedOrder ? `Order #${selectedOrder.order.id}` : 'Order detail'}
        description="Detailed payload returned by the backend for the selected order."
        maxWidthClassName="max-w-4xl"
      >
        {detailLoading ? (
          <p className="text-sm text-slate-500">Loading order detail...</p>
        ) : selectedOrder ? (
          <div className="space-y-6">
            <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-4">
              <div className="rounded-3xl border border-slate-200 bg-slate-50 p-4">
                <p className="text-xs uppercase tracking-[0.2em] text-slate-400">Status</p>
                <div className="mt-3 space-y-3">
                  <span
                    className={`inline-flex rounded-full px-3 py-1 text-xs font-semibold ${
                      statusClassName[selectedOrder.order.status] || 'bg-slate-100 text-slate-600'
                    }`}
                  >
                    {selectedOrder.order.status}
                  </span>
                  <select
                    value={selectedOrder.order.status}
                    disabled={updatingOrderId === selectedOrder.order.id}
                    onChange={(event) =>
                      void handleStatusChange(selectedOrder.order.id, event.target.value)
                    }
                    className="w-full rounded-2xl border border-slate-200 bg-white px-3 py-2 text-sm outline-none transition focus:border-teal-500"
                  >
                    {ORDER_STATUSES.map((status) => (
                      <option key={status} value={status}>
                        {status}
                      </option>
                    ))}
                  </select>
                </div>
              </div>
              <div className="rounded-3xl border border-slate-200 bg-slate-50 p-4">
                <p className="text-xs uppercase tracking-[0.2em] text-slate-400">Payment</p>
                <p className="mt-2 text-lg font-semibold text-slate-900">
                  {selectedOrder.order.paymentMethod || 'N/A'}
                </p>
              </div>
              <div className="rounded-3xl border border-slate-200 bg-slate-50 p-4">
                <p className="text-xs uppercase tracking-[0.2em] text-slate-400">Shipping Fee</p>
                <p className="mt-2 text-lg font-semibold text-slate-900">
                  ${selectedOrder.order.shippingFee.toFixed(2)}
                </p>
              </div>
              <div className="rounded-3xl border border-slate-200 bg-slate-50 p-4">
                <p className="text-xs uppercase tracking-[0.2em] text-slate-400">Total</p>
                <p className="mt-2 text-lg font-semibold text-slate-900">
                  ${selectedOrder.order.total.toFixed(2)}
                </p>
              </div>
            </div>

            <div className="rounded-3xl border border-slate-200 p-4">
              <p className="text-sm font-medium text-slate-500">Shipping address</p>
              <p className="mt-2 text-base text-slate-900">{selectedOrder.order.address || 'N/A'}</p>
              <p className="mt-1 text-sm text-slate-500">Phone: {selectedOrder.order.phone || 'N/A'}</p>
            </div>

            <div className="space-y-3">
              {selectedOrder.items.map((item, index) => (
                <div
                  key={`${item.productName}-${index}`}
                  className="flex items-center gap-4 rounded-3xl border border-slate-200 bg-slate-50 p-4"
                >
                  <img
                    src={item.image}
                    alt={item.productName}
                    className="h-16 w-16 rounded-2xl object-cover"
                  />
                  <div className="flex-1">
                    <p className="font-semibold text-slate-900">{item.productName}</p>
                    <p className="mt-1 text-xs text-slate-500">{item.variant}</p>
                  </div>
                  <div className="text-right">
                    <p className="text-sm font-medium text-slate-900">x{item.quantity}</p>
                    <p className="mt-1 text-xs text-slate-500">${item.price.toFixed(2)}</p>
                  </div>
                </div>
              ))}
            </div>
          </div>
        ) : (
          <p className="text-sm text-slate-500">No order detail selected.</p>
        )}
      </Modal>
    </div>
  );
}

export default OrderPage;
