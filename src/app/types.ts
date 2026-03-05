export interface Product {
  id: string;
  sku: string;
  name: string;
  category: string;
  brand: string;
  price: number;
  stock: number;
  status: 'active' | 'inactive';
}

export interface CartItem {
  product: Product;
  quantity: number;
}

export interface Sale {
  id: string;
  date: string;
  total: number;
  paymentMethod: 'cash' | 'card' | 'transfer';
  seller: string;
  items: CartItem[];
  discount: number;
  tax: number;
  subtotal: number;
}

export interface StockMovement {
  id: string;
  productId: string;
  productName: string;
  type: 'in' | 'out' | 'adjustment';
  quantity: number;
  reason: string;
  date: string;
}

export interface User {
  name: string;
  role: 'Cashier' | 'Admin';
  email: string;
}
