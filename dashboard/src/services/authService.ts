import api, {
  AUTH_USER_KEY,
  clearStoredAuth,
  getStoredToken,
  setStoredToken,
} from './api';

import { AUTH_EVENT_NAME } from '../hooks/useAuth';
import { userService } from './userService';
import type { AuthSession, LoginPayload, User } from '../types';
import "../firebase";
import { getAuth, signInWithEmailAndPassword } from "firebase/auth";

const dispatchAuthEvent = () => {
  window.dispatchEvent(new Event(AUTH_EVENT_NAME));
};

const storeUser = (user: User) => {
  localStorage.setItem(AUTH_USER_KEY, JSON.stringify(user));
};

const parseStoredUser = (): User | null => {
  const raw = localStorage.getItem(AUTH_USER_KEY);
  if (!raw) {
    return null;
  }

  try {
    return JSON.parse(raw) as User;
  } catch {
    return null;
  }
};

const normalizeToken = (data: unknown) => {
  if (!data || typeof data !== 'object') {
    return '';
  }

  const candidate = data as Record<string, unknown>;
  return String(candidate.token || candidate.accessToken || '');
};

const normalizeFallbackUser = (payload: LoginPayload): User => ({
  id: 0,
  email: payload.email || 'admin@local.dev',
  fullName: payload.email ? payload.email.split('@')[0] : 'Admin User',
  phone: '',
  avatar: '',
  role: 'Administrator',
  status: 'active',
});

export const authService = {
  hasToken() {
    return Boolean(getStoredToken());
  },

  getStoredUser() {
    return parseStoredUser();
  },

  async login(payload: LoginPayload): Promise<AuthSession> {
    let token = payload.token?.trim() || '';

    if (!token) {
      const auth = getAuth();

      // 🔥 login Firebase trước
      const userCredential = await signInWithEmailAndPassword(
        auth,
        payload.email!,
        payload.password!
      );

      const firebaseToken = await userCredential.user.getIdToken();

      console.log("FIREBASE TOKEN:", firebaseToken); // debug

      // 🔥 gửi token lên backend
      const { data } = await api.post('/auth/firebase', {
        token: firebaseToken,
        
      });
console.log("🔥 BACKEND JWT:", data.token); 
      token = data.token;

      if (!token) {
        throw new Error('Login response did not include a token');
      }
    }

    setStoredToken(token);

    const user = (await userService.getProfile().catch(() => null)) || normalizeFallbackUser(payload);
    storeUser(user);
    dispatchAuthEvent();

    return { token, user };
  },

  async restoreSession() {
    const user = await userService.getProfile();
    storeUser(user);
    dispatchAuthEvent();
    return user;
  },

  logout() {
    clearStoredAuth();
    dispatchAuthEvent();
  },
};
