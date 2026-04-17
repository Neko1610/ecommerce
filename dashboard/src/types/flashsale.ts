export interface FlashSale {
  id: number;
  name: string;
  startTime: string;
  endTime: string;
  active: boolean;
}

export interface FlashSaleItem {
  id: number;
  flashSaleId: number;
  variantId: number;
  flashPrice: number;
  quantity: number;
  sold: number;
}

export interface FlashSalePayload {
  name: string;
  startTime: string;
  endTime: string;
  active?: boolean;
}

export interface FlashSaleItemPayload {
  flashSaleId: number;
  variantId: number;
  flashPrice: number;
  quantity: number;
}
