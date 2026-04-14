import { useEffect, useMemo, useState } from 'react';
import { categoryService } from '../services/categoryService';
import { orderService } from '../services/orderService';
import { productService } from '../services/productService';
import { userService } from '../services/userService';
import { voucherService } from '../services/voucherService';

interface MetricCard {
  label: string;
  value: string | number;
  hint: string;
}

const chartData = [42, 51, 48, 67, 62, 79, 74];

function DashboardPage() {
  const [metrics, setMetrics] = useState<MetricCard[]>([
    { label: 'Products', value: 0, hint: 'Catalog entries in the backend.' },
    { label: 'Vouchers', value: 0, hint: 'Discount campaigns in circulation.' },
    { label: 'Orders', value: 0, hint: 'Orders returned by the secured API.' },
    { label: 'Users', value: 0, hint: 'User records visible to the current token.' },
  ]);

  useEffect(() => {
    const load = async () => {
      const [products, vouchers, orders, categories, users] = await Promise.allSettled([
        productService.getProducts(),
        voucherService.getVouchers(),
        orderService.getOrders(),
        categoryService.getCategories(),
        userService.getUsers(),
      ]);

      setMetrics([
        {
          label: 'Products',
          value: products.status === 'fulfilled' ? products.value.length : 0,
          hint: 'Catalog entries in the backend.',
        },
        {
          label: 'Vouchers',
          value: vouchers.status === 'fulfilled' ? vouchers.value.length : 0,
          hint: 'Discount campaigns in circulation.',
        },
        {
          label: 'Orders',
          value: orders.status === 'fulfilled' ? orders.value.length : 0,
          hint: 'Orders returned by the secured API.',
        },
        {
          label: 'Categories',
          value: categories.status === 'fulfilled' ? categories.value.length : 0,
          hint: 'Top-level category groups.',
        },
        {
          label: 'Users',
          value: users.status === 'fulfilled' ? users.value.length : 0,
          hint: 'User records visible to the current token.',
        },
      ]);
    };

    void load();
  }, []);

  const maxValue = useMemo(() => Math.max(...chartData), []);

  return (
    <div className="space-y-6">
      <section className="rounded-[32px] border border-white/70 bg-white/85 p-6 shadow-soft">
        <p className="text-sm font-semibold uppercase tracking-[0.3em] text-teal-600">Overview</p>
        <div className="mt-3 flex flex-col gap-4 lg:flex-row lg:items-end lg:justify-between">
          <div>
            <h2 className="text-3xl font-semibold text-slate-950">Retail command center</h2>
            <p className="mt-3 max-w-3xl text-sm leading-6 text-slate-500">
              Keep daily admin work clear and fast with one workspace for catalog operations,
              promotions, order tracking, and customer visibility.
            </p>
          </div>
          <div className="rounded-3xl bg-slate-950 px-5 py-4 text-white">
            <p className="text-xs uppercase tracking-[0.3em] text-teal-300">Health</p>
            <p className="mt-2 text-2xl font-semibold">All systems ready</p>
          </div>
        </div>
      </section>

      <section className="grid gap-6 md:grid-cols-2 xl:grid-cols-5">
        {metrics.map((metric) => (
          <article
            key={metric.label}
            className="rounded-[28px] border border-white/70 bg-white/90 p-5 shadow-soft"
          >
            <p className="text-sm font-medium text-slate-500">{metric.label}</p>
            <p className="mt-4 text-3xl font-semibold text-slate-950">{metric.value}</p>
            <p className="mt-3 text-sm leading-6 text-slate-500">{metric.hint}</p>
          </article>
        ))}
      </section>

      <section className="grid gap-6 xl:grid-cols-[1.4fr,1fr]">
        <article className="rounded-[32px] border border-white/70 bg-white/90 p-6 shadow-soft">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-slate-500">Weekly trend</p>
              <h3 className="mt-2 text-2xl font-semibold text-slate-950">Sales pulse</h3>
            </div>
            <span className="rounded-full bg-emerald-50 px-3 py-1 text-xs font-semibold text-emerald-600">
              +14.2%
            </span>
          </div>

          <div className="mt-8 flex h-72 items-end gap-4">
            {chartData.map((value, index) => (
              <div key={`${value}-${index}`} className="flex flex-1 flex-col items-center gap-3">
                <div className="flex h-60 w-full items-end rounded-3xl bg-slate-100 p-2">
                  <div
                    className="w-full rounded-2xl bg-gradient-to-t from-slate-950 via-teal-600 to-cyan-400"
                    style={{ height: `${(value / maxValue) * 100}%` }}
                  />
                </div>
                <span className="text-xs font-medium text-slate-400">
                  {['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][index]}
                </span>
              </div>
            ))}
          </div>
        </article>

        <article className="rounded-[32px] border border-white/70 bg-white/90 p-6 shadow-soft">
          <p className="text-sm font-medium text-slate-500">Workflow highlights</p>
          <h3 className="mt-2 text-2xl font-semibold text-slate-950">What this dashboard covers</h3>

          <div className="mt-6 space-y-4">
            {[
              {
                title: 'Catalog ops',
                description: 'Browse products, search quickly, and manage variants in a modal.',
              },
              {
                title: 'Promotion control',
                description: 'Create vouchers, toggle active state, and delete old campaigns.',
              },
              {
                title: 'Customer and order visibility',
                description: 'Inspect order payloads and surface user records through the JWT session.',
              },
            ].map((item) => (
              <div key={item.title} className="rounded-3xl border border-slate-200 bg-slate-50 p-4">
                <h4 className="text-sm font-semibold text-slate-900">{item.title}</h4>
                <p className="mt-2 text-sm leading-6 text-slate-500">{item.description}</p>
              </div>
            ))}
          </div>
        </article>
      </section>
    </div>
  );
}

export default DashboardPage;
