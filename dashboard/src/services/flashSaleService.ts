import api from "./api";
import type {
  FlashSale,
  FlashSaleItem,
  FlashSaleItemPayload,
  FlashSalePayload,
} from "../types";

const mapFlashSale = (raw: any): FlashSale => ({
  id: Number(raw?.id || 0),
  name: String(raw?.name || ""),
  startTime: String(raw?.startTime || ""),
  endTime: String(raw?.endTime || ""),
  active: Boolean(raw?.active),
});

const mapFlashSaleItem = (raw: any): FlashSaleItem => ({
  id: Number(raw?.id || 0),
  flashSaleId: Number(raw?.flashSaleId || 0),
  variantId: Number(raw?.variantId || 0),
  flashPrice: Number(raw?.flashPrice || 0),
  quantity: Number(raw?.quantity || 0),
  sold: Number(raw?.sold || 0),
});

export const flashSaleService = {

  createFlashSale: async (data: FlashSalePayload) => {
    const res = await api.post("/admin/flash-sales", data);
    return mapFlashSale(res.data);
  },

  addItem: async (data: FlashSaleItemPayload) => {
    const res = await api.post("/admin/flash-sale-items", data);
    return mapFlashSaleItem(res.data);
  },

  getAll: async () => {
    const res = await api.get("/admin/flash-sales");
    return Array.isArray(res.data) ? res.data.map(mapFlashSale) : [];
  }
};
