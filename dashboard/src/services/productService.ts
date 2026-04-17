import api, { parseArray } from './api';
import type { Product, ProductPayload, ProductVariant, VariantPayload } from '../types';

const mapVariant = (raw: any): ProductVariant => ({
  id: Number(raw?.id || 0),
  productId: Number(raw?.productId || raw?.product?.id || 0),
  size: String(raw?.size || ''),
  color: String(raw?.color || ''),
  price: Number(raw?.price || 0),
  oldPrice: raw?.oldPrice == null ? null : Number(raw.oldPrice),
  flashSale: Boolean(raw?.flashSale),
  stock: Number(raw?.stock || 0),
  image: String(raw?.image || raw?.images?.[0] || ''),
  images: Array.isArray(raw?.images) ? raw.images.map((image: unknown) => String(image)) : [],
});

const mapProduct = (raw: any): Product => ({
  id: Number(raw?.id || 0),
  name: String(raw?.name || ''),
  description: String(raw?.description || ''),
  image: String(raw?.image || ''),
  categoryId: raw?.category?.id ? Number(raw.category.id) : raw?.categoryId ? Number(raw.categoryId) : null,
  categoryName: String(raw?.category?.name || raw?.categoryName || raw?.category || 'Uncategorized'),
  minPrice: Number(raw?.minPrice || 0),
  maxPrice: Number(raw?.maxPrice || raw?.minPrice || 0),
  variants: parseArray<any>(raw?.variants).map(mapVariant),
});

const toPayload = (payload: ProductPayload) => ({
  name: payload.name,
  description: payload.description,
  image: payload.image,
  category: payload.categoryId ? { id: payload.categoryId } : null,
});

export const productService = {
  async getProducts() {
    const { data } = await api.get('/products');
    return parseArray<any>(data).map(mapProduct);
  },

  async createProduct(payload: ProductPayload) {
    const { data } = await api.post('/admin/products', toPayload(payload));
    return mapProduct(data);
  },

  async updateProduct(id: number, payload: ProductPayload) {
    const { data } = await api.put(`/admin/products/${id}`, toPayload(payload));
    return mapProduct(data);
  },

  async deleteProduct(id: number) {
    await api.delete(`/admin/products/${id}`);
  },

  async getVariants(productId: number) {
    const { data } = await api.get(`/products/${productId}/variants`);
    return parseArray<any>(data).map(mapVariant);
  },

  async createVariant(payload: VariantPayload) {
    const body = {
      size: payload.size,
      color: payload.color,
      price: payload.price,
      oldPrice: payload.oldPrice,
      stock: payload.stock,
      image: payload.image,
    };

    const { data } = await api.post(`/admin/products/${payload.productId}/variants`, body);
    return mapVariant(data);
  },

  async updateVariant(id: number, payload: VariantPayload) {
    const body = {
      size: payload.size,
      color: payload.color,
      price: payload.price,
      oldPrice: payload.oldPrice,
      stock: payload.stock,
      image: payload.image,
      product: {
        id: payload.productId,
      },
    };

    const { data } = await api.put(`/admin/variants/${id}`, body);
    return mapVariant(data);
  },

  async deleteVariant(id: number) {
    await api.delete(`/admin/variants/${id}`);
  },
};
