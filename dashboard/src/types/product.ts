export interface ProductVariant {
  id: number;
  productId: number;
  size: string;
  color: string;
  price: number;
  oldPrice: number | null;
  stock: number;
  image: string;
  images: string[];
}

export interface VariantPayload {
  productId: number;
  size: string;
  color: string;
  price: number;
  oldPrice: number | null;
  stock: number;
  image: string;
}

export interface Product {
  id: number;
  name: string;
  description: string;
  image: string;
  categoryId: number | null;
  categoryName: string;
  minPrice: number;
  maxPrice: number;
  variants: ProductVariant[];
}

export interface ProductPayload {
  name: string;
  description: string;
  image: string;
  categoryId: number | null;
}
