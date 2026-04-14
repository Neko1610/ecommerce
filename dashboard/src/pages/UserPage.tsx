import { useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import SearchInput from '../components/SearchInput';
import Table, { type TableColumn } from '../components/Table';
import { userService } from '../services/userService';
import type { User } from '../types';

function UserPage() {
  const [users, setUsers] = useState<User[]>([]);
  const [search, setSearch] = useState('');
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const loadUsers = async () => {
      try {
        setLoading(true);
        const data = await userService.getUsers();
        setUsers(data);
      } catch (error) {
        toast.error(error instanceof Error ? error.message : 'Failed to load users');
      } finally {
        setLoading(false);
      }
    };

    void loadUsers();
  }, []);

  const filteredUsers = useMemo(() => {
    const normalized = search.toLowerCase();
    return users.filter(
      (user) =>
        user.fullName.toLowerCase().includes(normalized) ||
        user.email.toLowerCase().includes(normalized) ||
        user.phone.toLowerCase().includes(normalized),
    );
  }, [users, search]);

  const columns: TableColumn<User>[] = [
    {
      key: 'user',
      header: 'User',
      render: (user) => (
        <div className="flex items-center gap-4">
          <img
            src={user.avatar || 'https://via.placeholder.com/64x64?text=User'}
            alt={user.fullName}
            className="h-12 w-12 rounded-full object-cover"
          />
          <div>
            <p className="font-semibold text-slate-900">{user.fullName}</p>
            <p className="mt-1 text-xs text-slate-500">{user.email}</p>
          </div>
        </div>
      ),
    },
    {
      key: 'phone',
      header: 'Phone',
      render: (user) => <span>{user.phone || 'N/A'}</span>,
    },
    {
      key: 'role',
      header: 'Role',
      render: (user) => (
        <span className="rounded-full bg-slate-100 px-3 py-1 text-xs font-medium text-slate-600">
          {user.role}
        </span>
      ),
    },
    {
      key: 'status',
      header: 'Status',
      render: (user) => (
        <span className="rounded-full bg-emerald-50 px-3 py-1 text-xs font-semibold text-emerald-600">
          {user.status}
        </span>
      ),
    },
  ];

  return (
    <div className="space-y-6">
      <section className="rounded-[32px] border border-white/70 bg-white/85 p-6 shadow-soft">
        <p className="text-sm font-semibold uppercase tracking-[0.3em] text-teal-600">Customers</p>
        <h2 className="mt-3 text-3xl font-semibold text-slate-950">User management</h2>
        <p className="mt-3 max-w-3xl text-sm leading-6 text-slate-500">
          Review user records available to the current token. If your backend only exposes profile
          data, the current authenticated user is shown here as a fallback.
        </p>
      </section>

      <section className="rounded-[32px] border border-white/70 bg-white/90 p-6 shadow-soft">
        <div className="mb-6 flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
          <div className="max-w-md">
            <SearchInput
              value={search}
              onChange={setSearch}
              placeholder="Search by name, email, or phone..."
            />
          </div>
          <p className="text-sm text-slate-500">{filteredUsers.length} users found</p>
        </div>

        <Table
          columns={columns}
          data={filteredUsers}
          loading={loading}
          emptyTitle="No users found"
          emptyDescription="User records exposed by the backend will appear here."
          keyExtractor={(user) => user.id}
        />
      </section>
    </div>
  );
}

export default UserPage;
