import type { ReactNode } from 'react';

interface ModalProps {
  open: boolean;
  title: string;
  description?: string;
  onClose: () => void;
  children: ReactNode;
  maxWidthClassName?: string;
}

function Modal({
  open,
  title,
  description,
  onClose,
  children,
  maxWidthClassName = 'max-w-3xl',
}: ModalProps) {
  if (!open) {
    return null;
  }

  return (
    <div className="fixed inset-0 z-[70] flex items-center justify-center bg-slate-950/60 p-4">
      <div className={`w-full ${maxWidthClassName} rounded-[30px] bg-white shadow-soft`}>
        <div className="flex items-start justify-between border-b border-slate-200 px-6 py-5">
          <div>
            <h3 className="text-xl font-semibold text-slate-950">{title}</h3>
            {description ? <p className="mt-2 text-sm text-slate-500">{description}</p> : null}
          </div>
          <button
            type="button"
            onClick={onClose}
            className="inline-flex h-10 w-10 items-center justify-center rounded-2xl bg-slate-100 text-xl text-slate-600 transition hover:bg-slate-200"
          >
            x
          </button>
        </div>

        <div className="max-h-[78vh] overflow-y-auto px-6 py-5">{children}</div>
      </div>
    </div>
  );
}

export default Modal;
