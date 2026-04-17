import { NavLink } from 'react-router-dom';

interface SidebarProps {
  isOpen: boolean;
  onClose: () => void;
}

const links = [
  { to: '/dashboard', label: 'Dashboard' },
  { to: '/products', label: 'Products' },
  { to: '/vouchers', label: 'Vouchers' },
  { to: '/orders', label: 'Orders' },
  { to: '/categories', label: 'Categories' },
  { to: '/users', label: 'Users' },
  { to: '/flash-sale', label: 'Flash Sale' },
];

function Sidebar({ isOpen, onClose }: SidebarProps) {
  return (
    <>
      <div
        className={`fixed inset-0 z-40 bg-slate-950/45 transition lg:hidden ${
          isOpen ? 'opacity-100' : 'pointer-events-none opacity-0'
        }`}
        onClick={onClose}
      />

      <aside
        className={`fixed inset-y-0 left-0 z-50 flex w-72 transform flex-col border-r border-white/10 bg-slate-950 px-5 py-6 text-white shadow-soft transition lg:translate-x-0 ${
          isOpen ? 'translate-x-0' : '-translate-x-full'
        }`}
      >
        <div className="rounded-[28px] border border-white/10 bg-white/5 p-5">
          <p className="text-xs uppercase tracking-[0.35em] text-teal-300">Shop Control</p>
          <h2 className="mt-3 text-2xl font-semibold">Commerce Admin</h2>
          <p className="mt-3 text-sm leading-6 text-slate-300">
            Manage catalog, promotions, orders, and customers from one dashboard.
          </p>
        </div>

        <nav className="mt-8 space-y-2">
          {links.map((link) => (
            <NavLink
              key={link.to}
              to={link.to}
              onClick={onClose}
              className={({ isActive }) =>
                `flex items-center rounded-2xl px-4 py-3 text-sm font-medium transition ${
                  isActive
                    ? 'bg-teal-500 text-white shadow-lg shadow-teal-950/30'
                    : 'text-slate-300 hover:bg-white/5 hover:text-white'
                }`
              }
            >
              {link.label}
            </NavLink>
          ))}
        </nav>

        <div className="mt-auto rounded-[28px] border border-teal-400/20 bg-gradient-to-br from-teal-500/20 to-cyan-400/10 p-4">
          <p className="text-sm font-semibold text-white">Daily Ops</p>
          <p className="mt-2 text-sm leading-6 text-slate-300">
            Use search, pagination, and bulk-friendly layouts to keep admin work fast.
          </p>
        </div>
      </aside>
    </>
  );
}

export default Sidebar;
