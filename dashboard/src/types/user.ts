export interface User {
  id: number;
  email: string;
  fullName: string;
  phone: string;
  avatar: string;
  role: string;
  status: string;
}

export interface LoginPayload {
  email: string;
  password: string;
  token?: string;
}

export interface AuthSession {
  token: string;
  user: User;
}
