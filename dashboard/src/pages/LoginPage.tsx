import { FormEvent, useState } from 'react';
import toast from 'react-hot-toast';
import { useLocation, useNavigate } from 'react-router-dom';
import Button from '../components/Button';
import { useAuth } from '../hooks/useAuth';

function LoginPage() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [token, setToken] = useState('');
  const [submitting, setSubmitting] = useState(false);
  const auth = useAuth();
  const navigate = useNavigate();
  const location = useLocation();
  const redirectTo = (location.state as { from?: string } | null)?.from || '/dashboard';

  const handleSubmit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();

    try {
      setSubmitting(true);
      await auth.login({ email, password, token });
      toast.success('Welcome back');
      navigate(redirectTo, { replace: true });
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Login failed');
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <div className="flex min-h-screen items-center justify-center px-4 py-10">
      <div className="grid w-full max-w-6xl overflow-hidden rounded-[36px] border border-white/70 bg-white/90 shadow-soft lg:grid-cols-[1.15fr,0.85fr]">
        <section className="hidden bg-slate-950 px-10 py-12 text-white lg:block">
          <p className="text-xs uppercase tracking-[0.4em] text-teal-300">Admin Dashboard</p>
          <h1 className="mt-5 max-w-md text-4xl font-semibold leading-tight">
            Run your storefront like a calm, organized control room.
          </h1>
          <p className="mt-5 max-w-lg text-base leading-7 text-slate-300">
            Track products, vouchers, categories, orders, and users with a production-ready admin
            workspace wired to your Spring backend.
          </p>

          <div className="mt-10 grid gap-4">
            {[
              'Reusable table, modal, and form patterns',
              'JWT persistence with automatic 401 redirect',
              'Search, pagination, and action toasts across modules',
            ].map((item) => (
              <div key={item} className="rounded-3xl border border-white/10 bg-white/5 px-5 py-4">
                <p className="text-sm text-slate-200">{item}</p>
              </div>
            ))}
          </div>
        </section>

        <section className="px-6 py-10 sm:px-10 lg:px-12">
          <div className="mx-auto max-w-md">
            <p className="text-sm font-semibold uppercase tracking-[0.3em] text-teal-600">
              Sign in
            </p>
            <h2 className="mt-3 text-3xl font-semibold text-slate-950">Access admin workspace</h2>
            <p className="mt-3 text-sm leading-6 text-slate-500">
              Use your normal admin credentials. If your backend only exposes an existing JWT,
              paste it into the token field and leave the password flow empty.
            </p>

            <form className="mt-8 space-y-5" onSubmit={handleSubmit}>
              <label className="block space-y-2">
                <span className="text-sm font-medium text-slate-700">Email</span>
                <input
                  type="email"
                  value={email}
                  onChange={(event) => setEmail(event.target.value)}
                  className="w-full rounded-2xl border border-slate-200 px-4 py-3 outline-none transition focus:border-teal-500"
                  placeholder="admin@shop.com"
                />
              </label>

              <label className="block space-y-2">
                <span className="text-sm font-medium text-slate-700">Password</span>
                <input
                  type="password"
                  value={password}
                  onChange={(event) => setPassword(event.target.value)}
                  className="w-full rounded-2xl border border-slate-200 px-4 py-3 outline-none transition focus:border-teal-500"
                  placeholder="Enter your password"
                />
              </label>

              <label className="block space-y-2">
                <span className="text-sm font-medium text-slate-700">JWT Token (optional)</span>
                <textarea
                  rows={4}
                  value={token}
                  onChange={(event) => setToken(event.target.value)}
                  className="w-full rounded-2xl border border-slate-200 px-4 py-3 outline-none transition focus:border-teal-500"
                  placeholder="Paste an existing Bearer token if needed"
                />
              </label>

              <Button type="submit" fullWidth disabled={submitting}>
                {submitting ? 'Signing in...' : 'Sign In'}
              </Button>
            </form>
          </div>
        </section>
      </div>
    </div>
  );
}

export default LoginPage;
