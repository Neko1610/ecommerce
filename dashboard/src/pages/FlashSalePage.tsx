import { useEffect, useState } from "react";
import toast from "react-hot-toast";
import Button from "../components/Button";
import LoadingSpinner from "../components/LoadingSpinner";
import { flashSaleService } from "../services/flashSaleService";
import { productService } from "../services/productService";
import type {
  FlashSale,
  FlashSaleItemPayload,
  FlashSalePayload,
  Product,
  ProductVariant,
} from "../types";

const initialSaleForm: FlashSalePayload = {
  name: "",
  startTime: "",
  endTime: "",
  active: true,
};

const initialItemForm: FlashSaleItemPayload = {
  flashSaleId: 0,
  variantId: 0,
  flashPrice: 0,
  quantity: 0,
};

export default function FlashSalePage() {
  const [sales, setSales] = useState<FlashSale[]>([]);
  const [products, setProducts] = useState<Product[]>([]);
  const [variants, setVariants] = useState<ProductVariant[]>([]);
  const [selectedProductId, setSelectedProductId] = useState<number>(0);
  const [saleForm, setSaleForm] = useState<FlashSalePayload>(initialSaleForm);
  const [itemForm, setItemForm] = useState<FlashSaleItemPayload>(initialItemForm);
  const [loading, setLoading] = useState(true);
  const [productsLoading, setProductsLoading] = useState(true);
  const [variantsLoading, setVariantsLoading] = useState(false);
  const [savingSale, setSavingSale] = useState(false);
  const [savingItem, setSavingItem] = useState(false);

  const loadSales = async () => {
    try {
      setLoading(true);
      const data = await flashSaleService.getAll();
      setSales(data);
      if (data.length > 0) {
        setItemForm((current) => ({
          ...current,
          flashSaleId: current.flashSaleId || data[0].id,
        }));
      }
    } catch (error) {
      toast.error(error instanceof Error ? error.message : "Failed to load flash sales");
    } finally {
      setLoading(false);
    }
  };

  const loadProducts = async () => {
    try {
      setProductsLoading(true);
      const data = await productService.getProducts();
      setProducts(data);
    } catch (error) {
      toast.error(error instanceof Error ? error.message : "Failed to load products");
    } finally {
      setProductsLoading(false);
    }
  };

  const loadVariants = async (productId: number) => {
    if (!productId) {
      setVariants([]);
      setItemForm((current) => ({ ...current, variantId: 0 }));
      return;
    }

    try {
      setVariantsLoading(true);
      const data = await productService.getVariants(productId);
      setVariants(data);
      setItemForm((current) => ({
        ...current,
        variantId: 0,
      }));
    } catch (error) {
      setVariants([]);
      toast.error(error instanceof Error ? error.message : "Failed to load variants");
    } finally {
      setVariantsLoading(false);
    }
  };

  useEffect(() => {
    void Promise.all([loadSales(), loadProducts()]);
  }, []);

  const handleCreateSale = async () => {
    try {
      setSavingSale(true);
      const created = await flashSaleService.createFlashSale(saleForm);
      toast.success("Flash sale created");
      setSaleForm(initialSaleForm);
      setItemForm((current) => ({ ...current, flashSaleId: created.id }));
      await loadSales();
    } catch (error) {
      toast.error(error instanceof Error ? error.message : "Failed to create flash sale");
    } finally {
      setSavingSale(false);
    }
  };

  const handleAddItem = async () => {
    try {
      setSavingItem(true);
      await flashSaleService.addItem(itemForm);
      toast.success("Flash sale item added");
      setSelectedProductId(0);
      setVariants([]);
      setItemForm((current) => ({
        ...initialItemForm,
        flashSaleId: current.flashSaleId,
      }));
    } catch (error) {
      toast.error(error instanceof Error ? error.message : "Failed to add flash sale item");
    } finally {
      setSavingItem(false);
    }
  };

  return (
    <div className="space-y-6">
      <section className="rounded-[32px] border border-white/70 bg-white/85 p-6 shadow-soft">
        <div>
          <p className="text-sm font-semibold uppercase tracking-[0.3em] text-rose-500">
            Promotions
          </p>
          <h2 className="mt-3 text-3xl font-semibold text-slate-950">Flash sale management</h2>
          <p className="mt-3 max-w-3xl text-sm leading-6 text-slate-500">
            Create time-boxed sale windows and attach variants with limited flash inventory.
          </p>
        </div>
      </section>

      <section className="grid gap-6 xl:grid-cols-[1.1fr,0.9fr]">
        <div className="rounded-[32px] border border-white/70 bg-white/90 p-6 shadow-soft">
          <h3 className="text-xl font-semibold text-slate-950">Create flash sale</h3>
          <div className="mt-5 space-y-4">
            <label className="block space-y-2">
              <span className="text-sm font-medium text-slate-700">Name</span>
              <input
                value={saleForm.name}
                onChange={(event) =>
                  setSaleForm((current) => ({ ...current, name: event.target.value }))
                }
                className="w-full rounded-2xl border border-slate-200 px-4 py-3 outline-none transition focus:border-rose-400"
              />
            </label>

            <div className="grid gap-4 md:grid-cols-2">
              <label className="block space-y-2">
                <span className="text-sm font-medium text-slate-700">Start time</span>
                <input
                  type="datetime-local"
                  value={saleForm.startTime}
                  onChange={(event) =>
                    setSaleForm((current) => ({ ...current, startTime: event.target.value }))
                  }
                  className="w-full rounded-2xl border border-slate-200 px-4 py-3 outline-none transition focus:border-rose-400"
                />
              </label>

              <label className="block space-y-2">
                <span className="text-sm font-medium text-slate-700">End time</span>
                <input
                  type="datetime-local"
                  value={saleForm.endTime}
                  onChange={(event) =>
                    setSaleForm((current) => ({ ...current, endTime: event.target.value }))
                  }
                  className="w-full rounded-2xl border border-slate-200 px-4 py-3 outline-none transition focus:border-rose-400"
                />
              </label>
            </div>

            <label className="flex items-center justify-between rounded-2xl border border-slate-200 bg-rose-50/60 px-4 py-3">
              <div>
                <p className="text-sm font-medium text-slate-800">Active now</p>
                <p className="text-xs text-slate-500">Inactive sales stay saved but do not apply.</p>
              </div>
              <input
                type="checkbox"
                checked={Boolean(saleForm.active)}
                onChange={(event) =>
                  setSaleForm((current) => ({ ...current, active: event.target.checked }))
                }
                className="h-5 w-5 rounded border-slate-300 text-rose-500 focus:ring-rose-400"
              />
            </label>

            <div className="flex justify-end">
              <Button onClick={handleCreateSale} disabled={savingSale}>
                {savingSale ? "Saving..." : "Create Flash Sale"}
              </Button>
            </div>
          </div>
        </div>

        <div className="rounded-[32px] border border-white/70 bg-white/90 p-6 shadow-soft">
          <h3 className="text-xl font-semibold text-slate-950">Add sale item</h3>
          <div className="mt-5 space-y-4">
            <label className="block space-y-2">
              <span className="text-sm font-medium text-slate-700">Flash sale</span>
              <select
                value={itemForm.flashSaleId || ""}
                onChange={(event) =>
                  setItemForm((current) => ({
                    ...current,
                    flashSaleId: Number(event.target.value),
                  }))
                }
                className="w-full rounded-2xl border border-slate-200 px-4 py-3 outline-none transition focus:border-rose-400"
              >
                <option value="">Select flash sale</option>
                {sales.map((sale) => (
                  <option key={sale.id} value={sale.id}>
                    {sale.name} #{sale.id}
                  </option>
                ))}
              </select>
            </label>

            <label className="block space-y-2">
              <span className="text-sm font-medium text-slate-700">Product</span>
              <select
                value={selectedProductId || ""}
                onChange={(event) => {
                  const productId = Number(event.target.value);
                  setSelectedProductId(productId);
                  void loadVariants(productId);
                }}
                disabled={productsLoading}
                className="w-full rounded-2xl border border-slate-200 px-4 py-3 outline-none transition focus:border-rose-400"
              >
                <option value="">Select product</option>
                {products.map((product) => (
                  <option key={product.id} value={product.id}>
                    {product.name}
                  </option>
                ))}
              </select>
            </label>

            <label className="block space-y-2">
              <span className="text-sm font-medium text-slate-700">Variant</span>
              <select
                value={itemForm.variantId || ""}
                onChange={(event) =>
                  setItemForm((current) => ({
                    ...current,
                    variantId: Number(event.target.value),
                  }))
                }
                disabled={!selectedProductId || variantsLoading}
                className="w-full rounded-2xl border border-slate-200 px-4 py-3 outline-none transition focus:border-rose-400"
              >
                <option value="">
                  {variantsLoading ? "Loading variants..." : "Select variant"}
                </option>
                {variants.map((variant) => (
                  <option key={variant.id} value={variant.id}>
                    {variant.size} / {variant.color} / ${variant.price.toFixed(2)}
                  </option>
                ))}
              </select>
            </label>

            <div className="grid gap-4 md:grid-cols-2">
              <label className="block space-y-2">
                <span className="text-sm font-medium text-slate-700">Quantity</span>
                <input
                  type="number"
                  min="1"
                  value={itemForm.quantity || ""}
                  onChange={(event) =>
                    setItemForm((current) => ({
                      ...current,
                      quantity: Number(event.target.value),
                    }))
                  }
                  className="w-full rounded-2xl border border-slate-200 px-4 py-3 outline-none transition focus:border-rose-400"
                />
              </label>

              <label className="block space-y-2">
                <span className="text-sm font-medium text-slate-700">Flash price</span>
                <input
                  type="number"
                  min="0"
                  step="0.01"
                  value={itemForm.flashPrice || ""}
                  onChange={(event) =>
                    setItemForm((current) => ({
                      ...current,
                      flashPrice: Number(event.target.value),
                    }))
                  }
                  className="w-full rounded-2xl border border-slate-200 px-4 py-3 outline-none transition focus:border-rose-400"
                />
              </label>
            </div>

            <div className="flex justify-end">
              <Button
                onClick={handleAddItem}
                disabled={savingItem || sales.length === 0 || !itemForm.variantId}
              >
                {savingItem ? "Saving..." : "Add Flash Item"}
              </Button>
            </div>
          </div>
        </div>
      </section>

      <section className="rounded-[32px] border border-white/70 bg-white/90 p-6 shadow-soft">
        <div className="mb-5 flex items-center justify-between gap-4">
          <div>
            <h3 className="text-xl font-semibold text-slate-950">Existing flash sales</h3>
            <p className="mt-2 text-sm text-slate-500">
              Review campaign timing before attaching more items.
            </p>
          </div>
          <span className="rounded-full bg-rose-50 px-3 py-1 text-xs font-semibold text-rose-500">
            {sales.length} sales
          </span>
        </div>

        {loading ? (
          <LoadingSpinner label="Loading flash sales..." />
        ) : sales.length === 0 ? (
          <div className="rounded-3xl border border-dashed border-slate-300 bg-slate-50 p-8 text-center text-sm text-slate-500">
            No flash sales yet.
          </div>
        ) : (
          <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-3">
            {sales.map((sale) => (
              <article
                key={sale.id}
                className="rounded-3xl border border-slate-200 bg-slate-50 p-5"
              >
                <div className="flex items-start justify-between gap-3">
                  <div>
                    <p className="text-lg font-semibold text-slate-950">{sale.name}</p>
                    <p className="mt-1 text-xs text-slate-500">ID #{sale.id}</p>
                  </div>
                  <span
                    className={`rounded-full px-3 py-1 text-xs font-semibold ${
                      sale.active
                        ? "bg-emerald-100 text-emerald-700"
                        : "bg-slate-200 text-slate-600"
                    }`}
                  >
                    {sale.active ? "Active" : "Inactive"}
                  </span>
                </div>

                <dl className="mt-4 space-y-3 text-sm text-slate-600">
                  <div className="flex items-center justify-between gap-3">
                    <dt>Starts</dt>
                    <dd>{new Date(sale.startTime).toLocaleString()}</dd>
                  </div>
                  <div className="flex items-center justify-between gap-3">
                    <dt>Ends</dt>
                    <dd>{new Date(sale.endTime).toLocaleString()}</dd>
                  </div>
                </dl>

                <div className="mt-4">
                  <Button
                    size="sm"
                    variant="secondary"
                    onClick={() =>
                      setItemForm((current) => ({ ...current, flashSaleId: sale.id }))
                    }
                  >
                    Use For Item Form
                  </Button>
                </div>
              </article>
            ))}
          </div>
        )}
      </section>
    </div>
  );
}
