import { useLocation } from 'react-router-dom';
import Button from './Button';
import type { User } from '../types';

interface HeaderProps {
  user: User | null;
  onLogout: () => void;
  onMenuClick: () => void;
}

const pageTitles: Record<string, string> = {
  '/dashboard': 'Dashboard Overview',
  '/products': 'Products',
  '/vouchers': 'Vouchers',
  '/orders': 'Orders',
  '/categories': 'Categories',
  '/users': 'Users',
};

function Header({ user, onLogout, onMenuClick }: HeaderProps) {
  const location = useLocation();
  const title = pageTitles[location.pathname] ?? 'Admin Dashboard';
  const initials =
    user?.fullName
      ?.split(' ')
      .filter(Boolean)
      .slice(0, 2)
      .map((item) => item[0]?.toUpperCase())
      .join('') || 'AD';

  return (
    <header className="sticky top-0 z-30 border-b border-white/60 bg-slate-50/85 backdrop-blur-xl">
      <div className="flex flex-col gap-4 px-4 py-4 sm:px-6 lg:flex-row lg:items-center lg:justify-between lg:px-8">
        <div className="flex items-center gap-3">
          <button
            type="button"
            onClick={onMenuClick}
            className="inline-flex h-11 w-11 items-center justify-center rounded-2xl border border-slate-200 bg-white text-xl text-slate-700 shadow-sm lg:hidden"
          >
            =
          </button>
          <div>
            <p className="text-sm text-slate-500">Operations workspace</p>
            <h1 className="text-2xl font-semibold text-slate-950">{title}</h1>
          </div>
        </div>

        <div className="flex flex-col gap-3 sm:flex-row sm:items-center">
          <div className="rounded-2xl border border-slate-200 bg-white px-4 py-3 shadow-sm">
            <p className="text-xs uppercase tracking-[0.25em] text-slate-400">Logged in as</p>
            <div className="mt-2 flex items-center gap-3">
              <div className="flex h-11 w-11 items-center justify-center rounded-2xl bg-slate-950 text-sm font-semibold text-white">
                {initials}
              </div>
              <div>
                <p className="text-sm font-semibold text-slate-900">{user?.fullName || 'Admin User'}</p>
                <p className="text-xs text-slate-500">{user?.email || 'admin@local.dev'}</p>
              </div>
            </div>
          </div>

          <Button variant="secondary" onClick={onLogout}>
            Logout
          </Button>
        </div>
      </div>
    </header>
  );
}

export default Header;
