import axios from 'axios';

export const AUTH_TOKEN_KEY = 'admin_access_token';
export const AUTH_USER_KEY = 'admin_user';

const api = axios.create({
  baseURL: 'http://localhost:8080/api',
  headers: {
    'Content-Type': 'application/json',
  },
});

export const getStoredToken = () => localStorage.getItem(AUTH_TOKEN_KEY);

export const setStoredToken = (token: string) => {
  localStorage.setItem(AUTH_TOKEN_KEY, token);
};

export const clearStoredAuth = () => {
  localStorage.removeItem(AUTH_TOKEN_KEY);
  localStorage.removeItem(AUTH_USER_KEY);
};

export const parseArray = <T>(data: unknown): T[] => (Array.isArray(data) ? (data as T[]) : []);

const redirectToLogin = () => {
  if (window.location.pathname !== '/login') {
    window.location.href = '/login';
  }
};

api.interceptors.request.use((config) => {
  const token = getStoredToken();
   console.log("🚀 TOKEN ĐANG GỬI:", token);
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      clearStoredAuth();
      redirectToLogin();
    }

    const message =
      error.response?.data?.message ||
      error.response?.data?.error ||
      (typeof error.response?.data === 'string' ? error.response.data : '') ||
      error.message ||
      'Something went wrong';

    return Promise.reject(new Error(message));
  },
);

export default api;
