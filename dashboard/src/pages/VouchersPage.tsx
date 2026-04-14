import { useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import EmptyState from '../components/EmptyState';
import LoadingSpinner from '../components/LoadingSpinner';
import PageHeader from '../components/PageHeader';
import SearchInput from '../components/SearchInput';
import VoucherFormModal from '../components/VoucherFormModal';
import { voucherService } from '../services/voucherService';
import { Voucher, VoucherPayload } from '../types';

function VouchersPage() {
  const [vouchers, setVouchers] = useState<Voucher[]>([]);
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [search, setSearch] = useState('');
  const [formOpen, setFormOpen] = useState(false);
  const [editingVoucher, setEditingVoucher] = useState<Voucher | null>(null);

  const loadVouchers = async () => {
    try {
      setLoading(true);
      const data = await voucherService.getVouchers();
      setVouchers(data);
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Failed to load vouchers');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    void loadVouchers();
  }, []);

  const filteredVouchers = useMemo(() => {
    const normalizedSearch = search.toLowerCase();
    return vouchers.filter((voucher) => voucher.code.toLowerCase().includes(normalizedSearch));
  }, [vouchers, search]);

  const handleSubmit = async (payload: VoucherPayload) => {
    try {
      setSubmitting(true);
      if (editingVoucher) {
        await voucherService.updateVoucher(editingVoucher.id, payload);
        toast.success('Voucher updated');
      } else {
        await voucherService.createVoucher(payload);
        toast.success('Voucher created');
      }
      setFormOpen(false);
      setEditingVoucher(null);
      await loadVouchers();
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Failed to save voucher');
    } finally {
      setSubmitting(false);
    }
  };

  const handleDelete = async (voucher: Voucher) => {
    const confirmed = window.confirm(`Delete voucher "${voucher.code}"?`);
    if (!confirmed) return;

    try {
      await voucherService.deleteVoucher(voucher.id);
      toast.success('Voucher deleted');
      await loadVouchers();
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Failed to delete voucher');
    }
  };

  const handleToggleActive = async (voucher: Voucher) => {
    try {
      await voucherService.updateVoucher(voucher.id, {
        code: voucher.code,
        discountPercent: voucher.discountPercent,
        expiryDate: voucher.expiryDate,
        minOrder: voucher.minOrder,
        active: !voucher.active,
      });
      toast.success('Voucher status updated');
      await loadVouchers();
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Failed to update voucher');
    }
  };

  if (loading) {
    return <LoadingSpinner label="Loading vouchers..." />;
  }

  return (
    <div className="space-y-6">
      <PageHeader
        eyebrow="Promotions"
        title="Vouchers"
        description="Create and control discount campaigns with instant status toggles and quick edits."
        action={
          <button
            type="button"
            onClick={() => {
              setEditingVoucher(null);
              setFormOpen(true);
            }}
            className="rounded-2xl bg-slate-950 px-5 py-3 text-sm font-medium text-white transition hover:bg-slate-800"
          >
            Add Voucher
          </button>
        }
      />

      <div className="rounded-[28px] border border-white/60 bg-white/90 p-6 shadow-soft">
        <div className="mb-6 flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
          <div className="max-w-md">
            <SearchInput value={search} onChange={setSearch} placeholder="Search voucher code..." />
          </div>
          <p className="text-sm text-slate-500">{filteredVouchers.length} vouchers found</p>
        </div>

        {filteredVouchers.length === 0 ? (
          <EmptyState
            title="No vouchers found"
            description="Create your first voucher to start running promotions for customers."
          />
        ) : (
          <div className="overflow-hidden rounded-[28px] border border-slate-200">
            <div className="overflow-x-auto">
              <table className="min-w-full divide-y divide-slate-200">
                <thead className="bg-slate-50">
                  <tr className="text-left text-sm font-semibold text-slate-600">
                    <th className="px-6 py-4">Code</th>
                    <th className="px-6 py-4">Discount</th>
                    <th className="px-6 py-4">Expiry Date</th>
                    <th className="px-6 py-4">Min Order</th>
                    <th className="px-6 py-4">Active</th>
                    <th className="px-6 py-4 text-right">Actions</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-100 bg-white">
                  {filteredVouchers.map((voucher) => (
                    <tr key={voucher.id} className="text-sm text-slate-600">
                      <td className="px-6 py-4 font-semibold text-slate-900">{voucher.code}</td>
                      <td className="px-6 py-4">{voucher.discountPercent}%</td>
                      <td className="px-6 py-4">
                        {new Date(voucher.expiryDate).toLocaleDateString()}
                      </td>
                      <td className="px-6 py-4">${voucher.minOrder.toFixed(2)}</td>
                      <td className="px-6 py-4">
                        <button
                          type="button"
                          onClick={() => handleToggleActive(voucher)}
                          className={`relative inline-flex h-7 w-12 items-center rounded-full transition ${
                            voucher.active ? 'bg-teal-500' : 'bg-slate-300'
                          }`}
                        >
                          <span
                            className={`inline-block h-5 w-5 transform rounded-full bg-white transition ${
                              voucher.active ? 'translate-x-6' : 'translate-x-1'
                            }`}
                          />
                        </button>
                      </td>
                      <td className="px-6 py-4">
                        <div className="flex justify-end gap-2">
                          <button
                            type="button"
                            onClick={() => {
                              setEditingVoucher(voucher);
                              setFormOpen(true);
                            }}
                            className="rounded-2xl border border-slate-200 px-4 py-2 font-medium text-slate-700 transition hover:bg-slate-50"
                          >
                            Edit
                          </button>
                          <button
                            type="button"
                            onClick={() => handleDelete(voucher)}
                            className="rounded-2xl border border-rose-200 px-4 py-2 font-medium text-rose-600 transition hover:bg-rose-50"
                          >
                            Delete
                          </button>
                        </div>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        )}
      </div>

      <VoucherFormModal
        open={formOpen}
        voucher={editingVoucher}
        submitting={submitting}
        onClose={() => {
          setFormOpen(false);
          setEditingVoucher(null);
        }}
        onSubmit={handleSubmit}
      />
    </div>
  );
}

export default VouchersPage;
