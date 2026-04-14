import api, { parseArray } from './api';
import type { Category, CategoryPayload } from '../types';

const mapCategory = (raw: any, parentId: number | null = null): Category => ({
  id: Number(raw?.id || 0),
  name: String(raw?.name || ''),
  banner: String(raw?.banner || ''),
  parentId,
  children: Array.isArray(raw?.children)
    ? raw.children.map((child: any) => mapCategory(child, Number(raw?.id || 0)))
    : [],
});

export const categoryService = {
  async getCategories() {
    const { data } = await api.get('/categories');
    console.log('CATEGORY DATA:', data);
    return parseArray<any>(data).map((item) => mapCategory(item));
  },

  async createCategory(payload: CategoryPayload) {
    const { data } = await api.post('/categories', payload);
    return mapCategory(data, payload.parentId);
  },

  async updateCategory(id: number, payload: CategoryPayload) {
    const { data } = await api.put(`/categories/${id}`, payload);
    return mapCategory(data, payload.parentId);
  },

  async deleteCategory(id: number) {
    await api.delete(`/categories/${id}`);
  },
};
