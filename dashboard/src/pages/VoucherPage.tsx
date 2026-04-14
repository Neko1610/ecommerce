import { useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import Button from '../components/Button';
import Modal from '../components/Modal';
import SearchInput from '../components/SearchInput';
import Table, { type TableColumn } from '../components/Table';
import { voucherService } from '../services/voucherService';
import type { Voucher, VoucherPayload } from '../types';

const initialForm: VoucherPayload = {
  code: '',
  discountPercent: 0,
  expiryDate: '',
  minOrder: 0,
  active: true,
};

function VoucherPage() {
  const [vouchers, setVouchers] = useState<Voucher[]>([]);
  const [search, setSearch] = useState('');
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [modalOpen, setModalOpen] = useState(false);
  const [editingVoucher, setEditingVoucher] = useState<Voucher | null>(null);
  const [form, setForm] = useState<VoucherPayload>(initialForm);

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
    const normalized = search.toLowerCase();
    return vouchers.filter((voucher) => voucher.code.toLowerCase().includes(normalized));
  }, [vouchers, search]);

  const openCreate = () => {
    setEditingVoucher(null);
    setForm(initialForm);
    setModalOpen(true);
  };

  const openEdit = (voucher: Voucher) => {
    setEditingVoucher(voucher);
    setForm({
      code: voucher.code,
      discountPercent: voucher.discountPercent,
      expiryDate: voucher.expiryDate,
      minOrder: voucher.minOrder,
      active: voucher.active,
    });
    setModalOpen(true);
  };

  const handleSubmit = async () => {
    try {
      setSaving(true);
      if (editingVoucher) {
        await voucherService.updateVoucher(editingVoucher.id, form);
        toast.success('Voucher updated');
      } else {
        await voucherService.createVoucher(form);
        toast.success('Voucher created');
      }
      setModalOpen(false);
      setEditingVoucher(null);
      setForm(initialForm);
      await loadVouchers();
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Failed to save voucher');
    } finally {
      setSaving(false);
    }
  };

  const handleDelete = async (voucher: Voucher) => {
    const confirmed = window.confirm(`Delete voucher "${voucher.code}"?`);
    if (!confirmed) {
      return;
    }

    try {
      await voucherService.deleteVoucher(voucher.id);
      toast.success('Voucher deleted');
      await loadVouchers();
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Failed to delete voucher');
    }
  };

  const handleToggle = async (voucher: Voucher) => {
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

  const columns: TableColumn<Voucher>[] = [
    {
      key: 'code',
      header: 'Code',
      render: (voucher) => <span className="font-semibold text-slate-900">{voucher.code}</span>,
    },
    {
      key: 'discount',
      header: 'Discount',
      render: (voucher) => <span>{voucher.discountPercent}%</span>,
    },
    {
      key: 'expiry',
      header: 'Expiry Date',
      render: (voucher) => <span>{new Date(voucher.expiryDate).toLocaleDateString()}</span>,
    },
    {
      key: 'minOrder',
      header: 'Min Order',
      render: (voucher) => <span>${voucher.minOrder.toFixed(2)}</span>,
    },
    {
      key: 'active',
      header: 'Active',
      render: (voucher) => (
        <button
          type="button"
          onClick={() => handleToggle(voucher)}
          className={`relative inline-flex h-7 w-12 items-center rounded-full transition ${
            voucher.active ? 'bg-teal-500' : 'bg-slate-300'
          }`}
        >
          <span
            className={`inline-block h-5 w-5 rounded-full bg-white transition ${
              voucher.active ? 'translate-x-6' : 'translate-x-1'
            }`}
          />
        </button>
      ),
    },
    {
      key: 'actions',
      header: 'Actions',
      className: 'text-right',
      render: (voucher) => (
        <div className="flex justify-end gap-2">
          <Button size="sm" variant="secondary" onClick={() => openEdit(voucher)}>
            Edit
          </Button>
          <Button size="sm" variant="danger" onClick={() => handleDelete(voucher)}>
            Delete
          </Button>
        </div>
      ),
    },
  ];

  return (
    <div className="space-y-6">
      <section className="rounded-[32px] border border-white/70 bg-white/85 p-6 shadow-soft">
        <div className="flex flex-col gap-4 lg:flex-row lg:items-end lg:justify-between">
          <div>
            <p className="text-sm font-semibold uppercase tracking-[0.3em] text-teal-600">
              Promotions
            </p>
            <h2 className="mt-3 text-3xl font-semibold text-slate-950">Voucher management</h2>
            <p className="mt-3 max-w-3xl text-sm leading-6 text-slate-500">
              Create discount campaigns, toggle active state, and retire expired promotions.
            </p>
          </div>
          <Button onClick={openCreate}>Add Voucher</Button>
        </div>
      </section>

      <section className="rounded-[32px] border border-white/70 bg-white/90 p-6 shadow-soft">
        <div className="mb-6 flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
          <div className="max-w-md">
            <SearchInput value={search} onChange={setSearch} placeholder="Search voucher code..." />
          </div>
          <p className="text-sm text-slate-500">{filteredVouchers.length} vouchers found</p>
        </div>

        <Table
          columns={columns}
          data={filteredVouchers}
          loading={loading}
          emptyTitle="No vouchers found"
          emptyDescription="Create a voucher to start running promotions."
          keyExtractor={(voucher) => voucher.id}
        />
      </section>

      <Modal
        open={modalOpen}
        onClose={() => setModalOpen(false)}
        title={editingVoucher ? 'Edit Voucher' : 'Create Voucher'}
        description="Voucher status can also be toggled directly from the table."
        maxWidthClassName="max-w-2xl"
      >
        <div className="space-y-5">
          <div className="grid gap-4 md:grid-cols-2">
            <label className="block space-y-2">
              <span className="text-sm font-medium text-slate-700">Code</span>
              <input
                value={form.code}
                onChange={(event) => setForm((current) => ({ ...current, code: event.target.value.toUpperCase() }))}
                className="w-full rounded-2xl border border-slate-200 px-4 py-3 outline-none transition focus:border-teal-500"
              />
            </label>

            <label className="block space-y-2">
              <span className="text-sm font-medium text-slate-700">Discount %</span>
              <input
                type="number"
                min="0"
                max="100"
                value={form.discountPercent}
                onChange={(event) =>
                  setForm((current) => ({
                    ...current,
                    discountPercent: Number(event.target.value),
                  }))
                }
                className="w-full rounded-2xl border border-slate-200 px-4 py-3 outline-none transition focus:border-teal-500"
              />
            </label>
          </div>

          <div className="grid gap-4 md:grid-cols-2">
            <label className="block space-y-2">
              <span className="text-sm font-medium text-slate-700">Expiry date</span>
              <input
                type="date"
                value={form.expiryDate}
                onChange={(event) => setForm((current) => ({ ...current, expiryDate: event.target.value }))}
                className="w-full rounded-2xl border border-slate-200 px-4 py-3 outline-none transition focus:border-teal-500"
              />
            </label>

            <label className="block space-y-2">
              <span className="text-sm font-medium text-slate-700">Minimum order</span>
              <input
                type="number"
                min="0"
                value={form.minOrder}
                onChange={(event) =>
                  setForm((current) => ({ ...current, minOrder: Number(event.target.value) }))
                }
                className="w-full rounded-2xl border border-slate-200 px-4 py-3 outline-none transition focus:border-teal-500"
              />
            </label>
          </div>

          <label className="flex items-center justify-between rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3">
            <div>
              <p className="text-sm font-medium text-slate-800">Active</p>
              <p className="text-xs text-slate-500">Inactive vouchers will not be applied.</p>
            </div>
            <input
              type="checkbox"
              checked={form.active}
              onChange={(event) => setForm((current) => ({ ...current, active: event.target.checked }))}
              className="h-5 w-5 rounded border-slate-300 text-teal-600 focus:ring-teal-500"
            />
          </label>

          <div className="flex justify-end gap-3">
            <Button variant="secondary" onClick={() => setModalOpen(false)}>
              Cancel
            </Button>
            <Button onClick={handleSubmit} disabled={saving}>
              {saving ? 'Saving...' : editingVoucher ? 'Update Voucher' : 'Create Voucher'}
            </Button>
          </div>
        </div>
      </Modal>
    </div>
  );
}

export default VoucherPage;
