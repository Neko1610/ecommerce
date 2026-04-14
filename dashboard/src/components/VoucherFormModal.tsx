import { FormEvent, useEffect, useState } from 'react';
import Modal from './Modal';
import { Voucher, VoucherPayload } from '../types';

interface VoucherFormModalProps {
  open: boolean;
  voucher?: Voucher | null;
  submitting: boolean;
  onClose: () => void;
  onSubmit: (payload: VoucherPayload) => Promise<void>;
}

const defaultState: VoucherPayload = {
  code: '',
  discountPercent: 0,
  expiryDate: '',
  minOrder: 0,
  active: true,
};

function VoucherFormModal({
  open,
  voucher,
  submitting,
  onClose,
  onSubmit,
}: VoucherFormModalProps) {
  const [formData, setFormData] = useState<VoucherPayload>(defaultState);

  useEffect(() => {
    if (voucher) {
      setFormData({
        code: voucher.code,
        discountPercent: voucher.discountPercent,
        expiryDate: voucher.expiryDate.split('T')[0],
        minOrder: voucher.minOrder,
        active: voucher.active,
      });
      return;
    }

    setFormData(defaultState);
  }, [voucher, open]);

  const handleSubmit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    await onSubmit(formData);
  };

  return (
    <Modal
      open={open}
      onClose={onClose}
      title={voucher ? 'Edit Voucher' : 'Create Voucher'}
      description="Launch promotions with clear discount, minimum order, and expiry rules."
      maxWidthClassName="max-w-2xl"
    >
      <form className="space-y-5" onSubmit={handleSubmit}>
        <div className="grid gap-5 md:grid-cols-2">
          <label className="space-y-2">
            <span className="text-sm font-medium text-slate-700">Voucher Code</span>
            <input
              required
              value={formData.code}
              onChange={(event) => setFormData((prev) => ({ ...prev, code: event.target.value }))}
              className="w-full rounded-2xl border border-slate-200 px-4 py-3 uppercase outline-none transition focus:border-teal-500"
            />
          </label>
          <label className="space-y-2">
            <span className="text-sm font-medium text-slate-700">Discount Percent</span>
            <input
              required
              min="0"
              max="100"
              type="number"
              value={formData.discountPercent}
              onChange={(event) =>
                setFormData((prev) => ({ ...prev, discountPercent: Number(event.target.value) }))
              }
              className="w-full rounded-2xl border border-slate-200 px-4 py-3 outline-none transition focus:border-teal-500"
            />
          </label>
        </div>

        <div className="grid gap-5 md:grid-cols-2">
          <label className="space-y-2">
            <span className="text-sm font-medium text-slate-700">Expiry Date</span>
            <input
              required
              type="date"
              value={formData.expiryDate}
              onChange={(event) =>
                setFormData((prev) => ({ ...prev, expiryDate: event.target.value }))
              }
              className="w-full rounded-2xl border border-slate-200 px-4 py-3 outline-none transition focus:border-teal-500"
            />
          </label>
          <label className="space-y-2">
            <span className="text-sm font-medium text-slate-700">Minimum Order</span>
            <input
              required
              min="0"
              type="number"
              value={formData.minOrder}
              onChange={(event) =>
                setFormData((prev) => ({ ...prev, minOrder: Number(event.target.value) }))
              }
              className="w-full rounded-2xl border border-slate-200 px-4 py-3 outline-none transition focus:border-teal-500"
            />
          </label>
        </div>

        <label className="flex items-center justify-between rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3">
          <div>
            <p className="text-sm font-medium text-slate-800">Voucher Active</p>
            <p className="text-xs text-slate-500">Disable to stop applying this voucher.</p>
          </div>
          <input
            type="checkbox"
            checked={formData.active}
            onChange={(event) => setFormData((prev) => ({ ...prev, active: event.target.checked }))}
            className="h-5 w-5 rounded border-slate-300 text-teal-600 focus:ring-teal-500"
          />
        </label>

        <div className="flex justify-end gap-3">
          <button
            type="button"
            onClick={onClose}
            className="rounded-2xl border border-slate-200 px-5 py-3 text-sm font-medium text-slate-700 transition hover:bg-slate-50"
          >
            Cancel
          </button>
          <button
            type="submit"
            disabled={submitting}
            className="rounded-2xl bg-slate-950 px-5 py-3 text-sm font-medium text-white transition hover:bg-slate-800 disabled:cursor-not-allowed disabled:opacity-70"
          >
            {submitting ? 'Saving...' : voucher ? 'Update Voucher' : 'Create Voucher'}
          </button>
        </div>
      </form>
    </Modal>
  );
}

export default VoucherFormModal;
