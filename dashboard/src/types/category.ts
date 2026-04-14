export interface Category {
  id: number;
  name: string;
  banner: string;
  parentId: number | null;
  children: Category[];
}

export interface CategoryPayload {
  name: string;
  parentId: number | null;
  banner?: string
}
