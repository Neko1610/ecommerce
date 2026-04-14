import { useEffect, useState } from 'react';
import { authService } from '../services/authService';
import type { LoginPayload, User } from '../types';

interface UseAuthResult {
  user: User | null;
  loading: boolean;
  isAuthenticated: boolean;
  login: (payload: LoginPayload) => Promise<void>;
  logout: () => void;
}

const authEvent = 'admin-auth-changed';

function readUser() {
  return authService.getStoredUser();
}

export function useAuth(): UseAuthResult {
  const [user, setUser] = useState<User | null>(() => readUser());
  const [loading, setLoading] = useState<boolean>(() => authService.hasToken() && !readUser());

  useEffect(() => {
    const sync = async () => {
      if (!authService.hasToken()) {
        setUser(null);
        setLoading(false);
        return;
      }

      const storedUser = readUser();
      if (storedUser) {
        setUser(storedUser);
        setLoading(false);
        return;
      }

      try {
        setLoading(true);
        const profile = await authService.restoreSession();
        setUser(profile);
      } finally {
        setLoading(false);
      }
    };

    void sync();

    const handleStorage = () => {
      setUser(readUser());
      setLoading(false);
    };

    window.addEventListener(authEvent, handleStorage);
    window.addEventListener('storage', handleStorage);

    return () => {
      window.removeEventListener(authEvent, handleStorage);
      window.removeEventListener('storage', handleStorage);
    };
  }, []);

  const login = async (payload: LoginPayload) => {
    setLoading(true);
    try {
      const session = await authService.login(payload);
      setUser(session.user);
    } finally {
      setLoading(false);
    }
  };

  const logout = () => {
    authService.logout();
    setUser(null);
    setLoading(false);
  };

  return {
    user,
    loading,
    isAuthenticated: authService.hasToken(),
    login,
    logout,
  };
}

export const AUTH_EVENT_NAME = authEvent;
