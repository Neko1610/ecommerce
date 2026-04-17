import { Navigate, Outlet, Route, Routes, useLocation } from 'react-router-dom';
import MainLayout from './layouts/MainLayout';
import { useAuth } from './hooks/useAuth';
import CategoryPage from './pages/CategoryPage';
import DashboardPage from './pages/DashboardPage';
import LoginPage from './pages/LoginPage';
import OrderPage from './pages/OrderPage';
import ProductPage from './pages/ProductPage';
import UserPage from './pages/UserPage';
import VoucherPage from './pages/VoucherPage';
import FlashSalePage from "./pages/FlashSalePage";

function ProtectedRoute() {
  const { isAuthenticated, loading } = useAuth();
  const location = useLocation();

  if (loading) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-slate-100">
        <div className="rounded-3xl border border-slate-200 bg-white px-8 py-6 shadow-soft">
          <p className="text-sm font-medium text-slate-500">Restoring admin session...</p>
        </div>
      </div>
    );
  }

  if (!isAuthenticated) {
    return <Navigate to="/login" replace state={{ from: location.pathname }} />;
  }

  return <Outlet />;
}

function PublicOnlyRoute() {
  const { isAuthenticated, loading } = useAuth();

  if (loading) {
    return null;
  }

  return isAuthenticated ? <Navigate to="/dashboard" replace /> : <Outlet />;
}

function App() {
  return (
    <Routes>
      <Route element={<PublicOnlyRoute />}>
        <Route path="/login" element={<LoginPage />} />
      </Route>

      <Route element={<ProtectedRoute />}>
        <Route element={<MainLayout />}>
          <Route path="/" element={<Navigate to="/dashboard" replace />} />
          <Route path="/dashboard" element={<DashboardPage />} />
          <Route path="/products" element={<ProductPage />} />
          <Route path="/vouchers" element={<VoucherPage />} />
          <Route path="/orders" element={<OrderPage />} />
          <Route path="/categories" element={<CategoryPage />} />
          <Route path="/users" element={<UserPage />} />
          <Route path="/flash-sale" element={<FlashSalePage />} />
        </Route>
      </Route>

      <Route path="*" element={<Navigate to="/dashboard" replace />} />
    </Routes>
  );
}

export default App;
