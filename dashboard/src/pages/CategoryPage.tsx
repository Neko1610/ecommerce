import { useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import Button from '../components/Button';
import Modal from '../components/Modal';
import SearchInput from '../components/SearchInput';
import Table, { type TableColumn } from '../components/Table';
import { categoryService } from '../services/categoryService';
import type { Category, CategoryPayload } from '../types';

const initialForm: CategoryPayload = {
  name: '',
  parentId: null,
  banner: '',
};

function CategoryPage() {
  const [categories, setCategories] = useState<Category[]>([]);
  const [search, setSearch] = useState('');
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [modalOpen, setModalOpen] = useState(false);
  const [editingCategory, setEditingCategory] = useState<Category | null>(null);
  const [form, setForm] = useState<CategoryPayload>(initialForm);
  const [openId, setOpenId] = useState<number | null>(null);

  const loadCategories = async () => {
    try {
      setLoading(true);
      const data = await categoryService.getCategories();
      setCategories(data);
    } catch (error) {
      toast.error('Failed to load categories');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    void loadCategories();
  }, []);

  // 🔥 LOGIC HIỂN THỊ ĐÓNG/MỞ TRONG TABLE
  const displayCategories = useMemo(() => {
    const normalized = search.toLowerCase();
    const results: Category[] = [];

    // Lọc danh mục cha theo search
    const roots = categories.filter(
      (c) => !c.parentId && c.name.toLowerCase().includes(normalized)
    );

    roots.forEach((root) => {
      results.push(root);
      // Nếu cha đang mở, "đẩy" các con vào ngay sau cha
      if (openId === root.id && root.children) {
        root.children.forEach((child) => {
          results.push(child);
        });
      }
    });

    return results;
  }, [categories, search, openId]);

  const handleSubmit = async () => {
    if (!form.name.trim()) return toast.error('Name is required');
    try {
      setSaving(true);
      if (editingCategory) {
        await categoryService.updateCategory(editingCategory.id, form);
        toast.success('Category updated');
      } else {
        await categoryService.createCategory(form);
        toast.success('Category created');
      }
      setModalOpen(false);
      void loadCategories();
    } catch {
      toast.error('Operation failed');
    } finally {
      setSaving(false);
    }
  };

  const handleDelete = async (e: React.MouseEvent, category: Category) => {
    e.stopPropagation(); // Không cho trigger đóng/mở row khi bấm xóa
    if (!confirm(`Are you sure you want to delete "${category.name}"?`)) return;
    try {
      await categoryService.deleteCategory(category.id);
      toast.success('Deleted');
      void loadCategories();
    } catch {
      toast.error('Delete failed');
    }
  };

  const openEdit = (e: React.MouseEvent, c: Category) => {
    e.stopPropagation(); // Không cho trigger đóng/mở row khi bấm edit
    setEditingCategory(c);
    setForm({ name: c.name, parentId: c.parentId, banner: c.banner || '' });
    setModalOpen(true);
  };

  const columns: TableColumn<Category>[] = [
    {
      key: 'name',
      header: 'Category Name',
      render: (cate) => {
        const isParent = !cate.parentId;
        const hasChildren = cate.children && cate.children.length > 0;
        const isOpen = openId === cate.id;

        return (
          <div
            className={`flex items-center gap-2 ${isParent ? 'cursor-pointer select-none' : 'ml-8'}`}
            onClick={() => isParent && setOpenId(isOpen ? null : cate.id)}
          >
            {isParent ? (
              <>
                <span className="text-teal-500 text-xs w-4">
                  {hasChildren ? (isOpen ? '▼' : '▶') : '•'}
                </span>
                <div className="flex items-center gap-3">
                  {!cate.parentId && cate.banner && (
                    <img
                      src={cate.banner}
                      className="w-8 h-8 rounded object-cover border"
                    />
                  )}

                  <span className="font-semibold text-slate-900">{cate.name}</span>
                </div>
              </>
            ) : (
              <>
                <span className="text-slate-300">└</span>
                <span className="text-slate-600 text-sm">{cate.name}</span>
              </>
            )}
          </div>
        );
      },
    },
    {
      key: 'type',
      header: 'Level',
      render: (cate) => (
        <span
          className={`rounded-full px-2.5 py-1 text-[10px] font-bold uppercase tracking-wider ${!cate.parentId ? 'bg-teal-50 text-teal-700' : 'bg-slate-50 text-slate-500'
            }`}
        >
          {!cate.parentId ? 'Root' : 'Sub'}
        </span>
      ),
    },
    {
      key: 'items',
      header: 'Products',
      render: (cate) => (
        <span className="text-sm text-slate-500">
          {cate.children?.length || 0} sub-categories
        </span>
      ),
    },
    {
      key: 'actions',
      header: 'Actions',
      className: 'text-right',
      render: (cate) => (
        <div className="flex justify-end gap-2">
          <Button size="sm" variant="secondary" onClick={(e) => openEdit(e, cate)}>
            Edit
          </Button>
          <Button size="sm" variant="danger" onClick={(e) => handleDelete(e, cate)}>
            Delete
          </Button>
        </div>
      ),
    },
  ];

  return (
    <div className="space-y-6">
      {/* HEADER SECTION - Glassmorphism style từ OrderPage */}
      <section className="rounded-[32px] border border-white/70 bg-white/85 p-8 shadow-soft flex justify-between items-center">
        <div>
          <p className="text-sm font-semibold uppercase tracking-[0.3em] text-teal-600">Inventory</p>
          <h2 className="mt-2 text-3xl font-semibold text-slate-950">Category management</h2>
          <p className="mt-3 max-w-xl text-sm leading-6 text-slate-500">
            Manage your product hierarchy. Click on a root category to view its sub-categories.
          </p>
        </div>
        <Button
          onClick={() => {
            setEditingCategory(null);
            setForm(initialForm);
            setModalOpen(true);
          }}
          className="rounded-2xl bg-slate-950 px-6 py-3 text-white shadow-xl transition hover:bg-slate-800"
        >
          Add Category
        </Button>
      </section>

      {/* TABLE SECTION */}
      <section className="rounded-[32px] border border-white/70 bg-white/90 p-6 shadow-soft">
        <div className="mb-6 flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
          <div className="max-w-md w-full">
            <SearchInput
              value={search}
              onChange={setSearch}
              placeholder="Search categories..."
            />
          </div>
          <p className="text-sm text-slate-500">{displayCategories.length} items visible</p>
        </div>

        <Table
          columns={columns}
          data={displayCategories}
          loading={loading}
          emptyTitle="No categories found"
          emptyDescription="Start by creating a new category for your products."
          keyExtractor={(cate) => cate.id}
        />
      </section>

      {/* MODAL SECTION */}
      <Modal
        open={modalOpen}
        onClose={() => setModalOpen(false)}
        title={editingCategory ? 'Edit Category' : 'Create Category'}
        description="Categories help organize your products for better customer experience."
      >
        <div className="space-y-5 py-2">
          <div className="space-y-2">
            <label className="text-sm font-medium text-slate-700 ml-1">Category Name</label>
            <input
              placeholder="e.g. Electronics"
              value={form.name}
              onChange={(e) => setForm((p) => ({ ...p, name: e.target.value }))}
              className="w-full rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm outline-none transition focus:border-teal-500 focus:ring-4 focus:ring-teal-500/5"
            />
          </div>

          <div className="space-y-2">
            <label className="text-sm font-medium text-slate-700 ml-1">Parent Category</label>

            <select
              value={form.parentId ?? ''}
              onChange={(e) =>
                setForm((p) => ({
                  ...p,
                  parentId: e.target.value ? Number(e.target.value) : null,
                }))
              }
              className="w-full rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm outline-none transition focus:border-teal-500"
            >
              <option value="">None (Top Level)</option>
              {categories
                .filter((c) => !c.parentId && c.id !== editingCategory?.id)
                .map((c) => (
                  <option key={c.id} value={c.id}>
                    {c.name}
                  </option>
                ))}
            </select>
          </div>
          {/* 🔥 Banner URL */}
          {!form.parentId && (
            <div className="space-y-2">
              <label className="text-sm font-medium text-slate-700 ml-1">
                Banner Image
              </label>

              <input
                placeholder="Paste image URL (https://...)"
                value={form.banner || ''}
                onChange={(e) =>
                  setForm((p) => ({ ...p, banner: e.target.value }))
                }
                className="w-full rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm outline-none focus:border-teal-500 focus:ring-4 focus:ring-teal-500/5"
              />

              {/* 🔥 Preview */}
              {form.banner && (
                <img
                  src={form.banner}
                  alt="preview"
                  className="w-full h-32 object-cover rounded-xl border"
                />
              )}
            </div>
          )}
          <div className="flex justify-end gap-3 pt-6">
            <Button variant="secondary" onClick={() => setModalOpen(false)} className="rounded-xl">
              Cancel
            </Button>
            <Button onClick={handleSubmit} disabled={saving} className="rounded-xl min-w-[120px]">
              {saving ? 'Saving...' : 'Save Category'}
            </Button>
          </div>
        </div>
      </Modal>
    </div>
  );
}

export default CategoryPage;