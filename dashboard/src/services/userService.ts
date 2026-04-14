import api, { parseArray } from './api';
import type { User } from '../types';

const mapUser = (raw: any): User => ({
  id: Number(raw?.id || 0),
  email: String(raw?.email || ''),
  fullName: String(raw?.fullName || raw?.name || 'Admin User'),
  phone: String(raw?.phone || ''),
  avatar: String(raw?.avatar || ''),
  role: String(raw?.role || 'Customer'),
  status: String(raw?.status || 'active'),
});

export const userService = {
  async getProfile(): Promise<User> {
    const { data } = await api.get('/user/profile');
    return mapUser({ ...data, role: 'Administrator' });
  },

  async getUsers(): Promise<User[]> {
    try {
      const { data } = await api.get('/users');
      const list = parseArray<any>(data).map(mapUser);
      if (list.length) {
        return list;
      }
    } catch {
      // Fall through to profile-based fallback.
    }

    const profile = await this.getProfile();
    return [profile];
  },
};
