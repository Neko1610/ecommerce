import { useLocation } from 'react-router-dom';

interface TopbarProps {
  onMenuClick: () => void;
}

const titles: Record<string, string> = {
  '/dashboard': 'Dashboard Overview',
  '/products': 'Product Management',
  '/vouchers': 'Voucher Management',
};

function Topbar({ onMenuClick }: TopbarProps) {
  const location = useLocation();

  return (
    <header className="sticky top-0 z-30 border-b border-white/60 bg-slate-50/80 backdrop-blur-xl">
      <div className="flex flex-col gap-4 px-4 py-4 sm:px-6 lg:flex-row lg:items-center lg:justify-between lg:px-8">
        <div className="flex items-center gap-3">
          <button
            type="button"
            onClick={onMenuClick}
            className="inline-flex h-11 w-11 items-center justify-center rounded-2xl border border-slate-200 bg-white text-slate-700 shadow-sm lg:hidden"
          >
            <span className="text-lg">≡</span>
          </button>
          <div>
            <p className="text-sm text-slate-500">Welcome back</p>
            <h2 className="text-xl font-semibold text-slate-900">
              {titles[location.pathname] ?? 'Admin Dashboard'}
            </h2>
          </div>
        </div>

        <div className="flex flex-col gap-3 sm:flex-row sm:items-center">
          <div className="flex items-center gap-3 rounded-2xl border border-slate-200 bg-white px-4 py-3 shadow-sm">
            <span className="text-slate-400">⌕</span>
            <input
              type="text"
              placeholder="Search anything..."
              className="w-full border-none bg-transparent text-sm outline-none placeholder:text-slate-400 sm:w-64"
            />
          </div>
          <div className="flex items-center gap-3 rounded-2xl border border-slate-200 bg-white px-4 py-3 shadow-sm">
            <div className="flex h-11 w-11 items-center justify-center rounded-2xl bg-slate-900 text-sm font-semibold text-white">
              AD
            </div>
            <div>
              <p className="text-sm font-medium text-slate-900">Admin User</p>
              <p className="text-xs text-slate-500">Operations Manager</p>
            </div>
          </div>
        </div>
      </div>
    </header>
  );
}

export default Topbar;
