import { useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import Button from '../components/Button';
import Modal from '../components/Modal';
import Pagination from '../components/Pagination';
import SearchInput from '../components/SearchInput';
import Table, { type TableColumn } from '../components/Table';
import { categoryService } from '../services/categoryService';
import { productService } from '../services/productService';
import type { Category, Product, ProductPayload, ProductVariant, VariantPayload } from '../types';

const PAGE_SIZE = 6;

const initialForm: ProductPayload = {
  name: '',
  description: '',
  image: '',
  categoryId: null,
};

const initialVariantForm: VariantPayload = {
  productId: 0,
  size: '',
  color: '',
  price: 0,
  oldPrice: null,
  stock: 0,
  image: '',
};

function ProductPage() {
  const [products, setProducts] = useState<Product[]>([]);
  const [categories, setCategories] = useState<Category[]>([]);
  const [search, setSearch] = useState('');
  const [page, setPage] = useState(1);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [productModalOpen, setProductModalOpen] = useState(false);
  const [variantModalOpen, setVariantModalOpen] = useState(false);
  const [editingProduct, setEditingProduct] = useState<Product | null>(null);
  const [editingVariant, setEditingVariant] = useState<ProductVariant | null>(null);
  const [variantProduct, setVariantProduct] = useState<Product | null>(null);
  const [productForm, setProductForm] = useState<ProductPayload>(initialForm);
  const [variantForm, setVariantForm] = useState<VariantPayload>(initialVariantForm);

  const categoryOptions = useMemo(() => {
    const options: Category[] = [];

    const walk = (items: Category[]) => {
      items.forEach((item) => {
        if (item.children.length) {
          walk(item.children);
          return;
        }
        options.push(item);
      });
    };

    walk(categories);
    return options;
  }, [categories]);

  const loadProducts = async () => {
    try {
      setLoading(true);
      const [productList, categoryTree] = await Promise.all([
        productService.getProducts(),
        categoryService.getCategories(),
      ]);
      setProducts(productList);
      setCategories(categoryTree);
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Failed to load products');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    void loadProducts();
  }, []);

  useEffect(() => {
    setPage(1);
  }, [search]);

  const filteredProducts = useMemo(() => {
    const normalized = search.toLowerCase();
    return products.filter(
      (product) =>
        product.name.toLowerCase().includes(normalized) ||
        product.categoryName.toLowerCase().includes(normalized),
    );
  }, [products, search]);

  const totalPages = Math.max(1, Math.ceil(filteredProducts.length / PAGE_SIZE));

  const paginatedProducts = useMemo(() => {
    const start = (page - 1) * PAGE_SIZE;
    return filteredProducts.slice(start, start + PAGE_SIZE);
  }, [filteredProducts, page]);

  useEffect(() => {
    if (page > totalPages) {
      setPage(totalPages);
    }
  }, [page, totalPages]);

  const resetProductForm = () => {
    setEditingProduct(null);
    setProductForm(initialForm);
  };

  const openCreateModal = () => {
    resetProductForm();
    setProductModalOpen(true);
  };

  const openEditModal = (product: Product) => {
    setEditingProduct(product);
    setProductForm({
      name: product.name,
      description: product.description,
      image: product.image,
      categoryId: product.categoryId,
    });
    setProductModalOpen(true);
  };

  const openVariantModal = (product: Product) => {
    setVariantProduct(product);
    setEditingVariant(null);
    setVariantForm({ ...initialVariantForm, productId: product.id });
    setVariantModalOpen(true);
  };

  const populateVariantForm = (variant: ProductVariant, productId: number) => {
    setEditingVariant(variant);
    setVariantForm({
      productId,
      size: variant.size,
      color: variant.color,
      price: variant.price,
      oldPrice: variant.oldPrice,
      stock: variant.stock,
      image: variant.image || variant.images[0] || '',
    });
  };

  const resetVariantForm = (productId = variantProduct?.id || 0) => {
    setEditingVariant(null);
    setVariantForm({ ...initialVariantForm, productId });
  };

  const handleProductSubmit = async () => {
    try {
      setSaving(true);
      if (editingProduct) {
        await productService.updateProduct(editingProduct.id, productForm);
        toast.success('Product updated');
      } else {
        await productService.createProduct(productForm);
        toast.success('Product created');
      }
      setProductModalOpen(false);
      resetProductForm();
      await loadProducts();
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Failed to save product');
    } finally {
      setSaving(false);
    }
  };

  const handleDelete = async (product: Product) => {
    const confirmed = window.confirm(`Delete "${product.name}"?`);
    if (!confirmed) {
      return;
    }

    try {
      await productService.deleteProduct(product.id);
      toast.success('Product deleted');
      await loadProducts();
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Failed to delete product');
    }
  };

  const handleVariantCreate = async () => {
    if (!variantProduct) {
      return;
    }

    try {
      setSaving(true);
      if (editingVariant) {
        await productService.updateVariant(editingVariant.id, {
          ...variantForm,
          productId: variantProduct.id,
        });
        toast.success('Variant updated');
      } else {
        await productService.createVariant({
          ...variantForm,
          productId: variantProduct.id,
        });
        toast.success('Variant created');
      }

      resetVariantForm(variantProduct.id);
      const freshProducts = await productService.getProducts();
      setProducts(freshProducts);
      setVariantProduct(freshProducts.find((item) => item.id === variantProduct.id) || null);
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Failed to save variant');
    } finally {
      setSaving(false);
    }
  };

  const handleVariantDelete = async (variant: ProductVariant) => {
    const confirmed = window.confirm(`Delete variant ${variant.color} / ${variant.size}?`);
    if (!confirmed || !variantProduct) {
      return;
    }

    try {
      setSaving(true);
      await productService.deleteVariant(variant.id);
      toast.success('Variant deleted');
      resetVariantForm(variantProduct.id);
      const freshProducts = await productService.getProducts();
      setProducts(freshProducts);
      setVariantProduct(freshProducts.find((item) => item.id === variantProduct.id) || null);
    } catch (error) {
      toast.error(error instanceof Error ? error.message : 'Failed to delete variant');
    } finally {
      setSaving(false);
    }
  };

  const handleVariantImageUpload = async (file: File | null) => {
    if (!file) {
      return;
    }

    const dataUrl = await new Promise<string>((resolve, reject) => {
      const reader = new FileReader();
      reader.onload = () => resolve(String(reader.result || ''));
      reader.onerror = () => reject(new Error('Failed to read image file'));
      reader.readAsDataURL(file);
    });

    setVariantForm((current) => ({ ...current, image: dataUrl }));
  };

  const productColumns: TableColumn<Product>[] = [
    {
      key: 'product',
      header: 'Product',
      render: (product) => (
        <div className="flex items-center gap-4">
          <img
            src={product.image || 'https://via.placeholder.com/80x80?text=Item'}
            alt={product.name}
            className="h-14 w-14 rounded-2xl object-cover"
          />
          <div>
            <p className="font-semibold text-slate-900">{product.name}</p>
            <p className="mt-1 max-w-sm text-xs leading-5 text-slate-500">{product.description}</p>
          </div>
        </div>
      ),
    },
    {
      key: 'category',
      header: 'Category',
      render: (product) => <span>{product.categoryName}</span>,
    },
    {
      key: 'price',
      header: 'Price Range',
      render: (product) => (
        <span className="font-medium text-slate-900">
          ${product.minPrice.toFixed(2)} - ${product.maxPrice.toFixed(2)}
        </span>
      ),
    },
    {
      key: 'variants',
      header: 'Variants',
      render: (product) => (
        <span className="rounded-full bg-slate-100 px-3 py-1 text-xs font-medium text-slate-600">
          {product.variants.length} variants
        </span>
      ),
    },
    {
      key: 'actions',
      header: 'Actions',
      className: 'text-right',
      render: (product) => (
        <div className="flex justify-end gap-2">
          <Button size="sm" variant="secondary" onClick={() => openVariantModal(product)}>
            Variants
          </Button>
          <Button size="sm" variant="secondary" onClick={() => openEditModal(product)}>
            Edit
          </Button>
          <Button size="sm" variant="danger" onClick={() => handleDelete(product)}>
            Delete
          </Button>
        </div>
      ),
    },
  ];

  return (
    <div className="space-y-6">
      <section className="rounded-[32px] border border-white/70 bg-white/85 p-6 shadow-soft">
        <div className="flex flex-col gap-4 lg:flex-row lg:items-end lg:justify-between">
          <div>
            <p className="text-sm font-semibold uppercase tracking-[0.3em] text-teal-600">Catalog</p>
            <h2 className="mt-3 text-3xl font-semibold text-slate-950">Product management</h2>
            <p className="mt-3 max-w-3xl text-sm leading-6 text-slate-500">
              Browse products, search quickly, and manage product variants from one admin flow.
            </p>
          </div>
          <Button onClick={openCreateModal}>Add Product</Button>
        </div>
      </section>

      <section className="rounded-[32px] border border-white/70 bg-white/90 p-6 shadow-soft">
        <div className="mb-6 flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
          <div className="max-w-md">
            <SearchInput
              value={search}
              onChange={setSearch}
              placeholder="Search by product name or category..."
            />
          </div>
          <p className="text-sm text-slate-500">{filteredProducts.length} products found</p>
        </div>

        <Table
          columns={productColumns}
          data={paginatedProducts}
          loading={loading}
          emptyTitle="No products found"
          emptyDescription="Create the first product to start managing your catalog."
          keyExtractor={(product) => product.id}
        />

        {!loading && filteredProducts.length > 0 ? (
          <Pagination currentPage={page} totalPages={totalPages} onPageChange={setPage} />
        ) : null}
      </section>

      <Modal
        open={productModalOpen}
        onClose={() => {
          setProductModalOpen(false);
          resetProductForm();
        }}
        title={editingProduct ? 'Edit Product' : 'Create Product'}
        description="Use a leaf category so the backend accepts the payload correctly."
        maxWidthClassName="max-w-2xl"
      >
        <div className="space-y-5">
          <label className="block space-y-2">
            <span className="text-sm font-medium text-slate-700">Product name</span>
            <input
              value={productForm.name}
              onChange={(event) => setProductForm((current) => ({ ...current, name: event.target.value }))}
              className="w-full rounded-2xl border border-slate-200 px-4 py-3 outline-none transition focus:border-teal-500"
            />
          </label>

          <label className="block space-y-2">
            <span className="text-sm font-medium text-slate-700">Category</span>
            <select
              value={productForm.categoryId ?? ''}
              onChange={(event) =>
                setProductForm((current) => ({
                  ...current,
                  categoryId: event.target.value ? Number(event.target.value) : null,
                }))
              }
              className="w-full rounded-2xl border border-slate-200 px-4 py-3 outline-none transition focus:border-teal-500"
            >
              <option value="">Select a subcategory</option>
              {categoryOptions.map((category) => (
                <option key={category.id} value={category.id}>
                  {category.name}
                </option>
              ))}
            </select>
          </label>

          <label className="block space-y-2">
            <span className="text-sm font-medium text-slate-700">Image URL</span>
            <input
              value={productForm.image}
              onChange={(event) => setProductForm((current) => ({ ...current, image: event.target.value }))}
              className="w-full rounded-2xl border border-slate-200 px-4 py-3 outline-none transition focus:border-teal-500"
            />
          </label>

          <label className="block space-y-2">
            <span className="text-sm font-medium text-slate-700">Description</span>
            <textarea
              rows={4}
              value={productForm.description}
              onChange={(event) =>
                setProductForm((current) => ({ ...current, description: event.target.value }))
              }
              className="w-full rounded-2xl border border-slate-200 px-4 py-3 outline-none transition focus:border-teal-500"
            />
          </label>

          <div className="flex justify-end gap-3">
            <Button variant="secondary" onClick={() => setProductModalOpen(false)}>
              Cancel
            </Button>
            <Button onClick={handleProductSubmit} disabled={saving}>
              {saving ? 'Saving...' : editingProduct ? 'Update Product' : 'Create Product'}
            </Button>
          </div>
        </div>
      </Modal>

      <Modal
        open={variantModalOpen}
        onClose={() => setVariantModalOpen(false)}
        title={variantProduct ? `${variantProduct.name} variants` : 'Variants'}
        description="Current backend supports listing and creating variants from this panel."
        maxWidthClassName="max-w-5xl"
      >
        <div className="grid gap-6 xl:grid-cols-[1.2fr,0.8fr]">
          <div className="space-y-4">
            <div className="rounded-3xl border border-slate-200 bg-slate-50 p-4">
              <p className="text-sm font-medium text-slate-500">Variant list</p>
              <div className="mt-4 space-y-3">
                {(variantProduct?.variants || []).map((variant: ProductVariant) => (
                  <div
                    key={variant.id}
                    className="flex items-center justify-between gap-4 rounded-2xl border border-slate-200 bg-white px-4 py-3"
                  >
                    <div className="flex items-center gap-4">
                      <img
                        src={variant.image || variant.images[0] || 'https://via.placeholder.com/72x72?text=Variant'}
                        alt={`${variant.color} ${variant.size}`}
                        className="h-14 w-14 rounded-2xl object-cover"
                      />
                      <div>
                        <p className="font-medium text-slate-900">
                          {variant.color} / {variant.size}
                        </p>
                        <p className="mt-1 text-xs text-slate-500">
                          ${variant.price.toFixed(2)} | Stock: {variant.stock}
                        </p>
                      </div>
                    </div>
                    <div className="flex items-center gap-2">
                      <Button
                        size="sm"
                        variant="secondary"
                        onClick={() => populateVariantForm(variant, variantProduct?.id || variant.productId)}
                      >
                        Edit
                      </Button>
                      <Button size="sm" variant="danger" onClick={() => handleVariantDelete(variant)}>
                        Delete
                      </Button>
                      <span className="rounded-full bg-slate-100 px-3 py-1 text-xs font-medium text-slate-600">
                        #{variant.id}
                      </span>
                    </div>
                  </div>
                ))}

                {!variantProduct?.variants.length ? (
                  <p className="text-sm text-slate-500">No variants yet for this product.</p>
                ) : null}
              </div>
            </div>
          </div>

          <div className="space-y-4 rounded-3xl border border-slate-200 bg-slate-50 p-4">
            <div className="flex items-center justify-between gap-3">
              <p className="text-sm font-medium text-slate-500">
                {editingVariant ? `Edit variant #${editingVariant.id}` : 'Add variant'}
              </p>
              {editingVariant ? (
                <Button size="sm" variant="secondary" onClick={() => resetVariantForm()}>
                  Clear
                </Button>
              ) : null}
            </div>

            <label className="block space-y-2">
              <span className="text-sm font-medium text-slate-700">Size</span>
              <input
                value={variantForm.size}
                onChange={(event) =>
                  setVariantForm((current) => ({ ...current, size: event.target.value }))
                }
                className="w-full rounded-2xl border border-slate-200 px-4 py-3 outline-none transition focus:border-teal-500"
              />
            </label>

            <label className="block space-y-2">
              <span className="text-sm font-medium text-slate-700">Color</span>
              <input
                value={variantForm.color}
                onChange={(event) =>
                  setVariantForm((current) => ({ ...current, color: event.target.value }))
                }
                className="w-full rounded-2xl border border-slate-200 px-4 py-3 outline-none transition focus:border-teal-500"
              />
            </label>

            <div className="grid gap-4 md:grid-cols-2">
              <label className="block space-y-2">
                <span className="text-sm font-medium text-slate-700">Price</span>
                <input
                  type="number"
                  min="0"
                  value={variantForm.price}
                  onChange={(event) =>
                    setVariantForm((current) => ({
                      ...current,
                      price: Number(event.target.value),
                    }))
                  }
                  className="w-full rounded-2xl border border-slate-200 px-4 py-3 outline-none transition focus:border-teal-500"
                />
              </label>

              <label className="block space-y-2">
                <span className="text-sm font-medium text-slate-700">Stock</span>
                <input
                  type="number"
                  min="0"
                  value={variantForm.stock}
                  onChange={(event) =>
                    setVariantForm((current) => ({
                      ...current,
                      stock: Number(event.target.value),
                    }))
                  }
                  className="w-full rounded-2xl border border-slate-200 px-4 py-3 outline-none transition focus:border-teal-500"
                />
              </label>
            </div>

            <label className="block space-y-2">
              <span className="text-sm font-medium text-slate-700">Image URL</span>
              <input
                value={variantForm.image}
                onChange={(event) =>
                  setVariantForm((current) => ({ ...current, image: event.target.value }))
                }
                className="w-full rounded-2xl border border-slate-200 px-4 py-3 outline-none transition focus:border-teal-500"
              />
            </label>

            <label className="block space-y-2">
              <span className="text-sm font-medium text-slate-700">Upload image</span>
              <input
                type="file"
                accept="image/*"
                onChange={(event) => {
                  const [file] = Array.from(event.target.files || []);
                  void handleVariantImageUpload(file || null).catch((error: unknown) => {
                    toast.error(error instanceof Error ? error.message : 'Failed to load image');
                  });
                }}
                className="w-full rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm outline-none transition focus:border-teal-500"
              />
            </label>

            <div className="rounded-3xl border border-dashed border-slate-300 bg-white p-4">
              <p className="text-xs uppercase tracking-[0.2em] text-slate-400">Preview</p>
              <img
                src={variantForm.image || 'https://via.placeholder.com/240x180?text=Variant'}
                alt="Variant preview"
                className="mt-3 h-40 w-full rounded-2xl object-cover"
              />
            </div>

            <div className="flex justify-end gap-3">
              <Button variant="secondary" onClick={() => setVariantModalOpen(false)}>
                Close
              </Button>
              <Button onClick={handleVariantCreate} disabled={saving}>
                {saving ? 'Saving...' : editingVariant ? 'Update Variant' : 'Add Variant'}
              </Button>
            </div>
          </div>
        </div>
      </Modal>
    </div>
  );
}

export default ProductPage;
