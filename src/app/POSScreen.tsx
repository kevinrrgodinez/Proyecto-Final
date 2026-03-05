import { useState } from 'react';
import { Button } from './components/ui/button';
import { Input } from './components/ui/input';
import { Label } from './components/ui/label';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from './components/ui/select';
import { Card, CardContent } from './components/ui/card';
import { Badge } from './components/ui/badge';
import { products } from './data';
import { CartItem, Product } from './types';
import { Search, Plus, Minus, Trash2, DollarSign } from 'lucide-react';
import { toast } from 'sonner';

export function POSScreen() {
  const [cart, setCart] = useState<CartItem[]>([]);
  const [searchQuery, setSearchQuery] = useState('');
  const [categoryFilter, setCategoryFilter] = useState('all');
  const [paymentMethod, setPaymentMethod] = useState<'cash' | 'card' | 'transfer'>('cash');
  const [amountReceived, setAmountReceived] = useState('');
  const [discount, setDiscount] = useState('0');

  const categories = ['all', ...new Set(products.map((p) => p.category))];

  const filteredProducts = products.filter((product) => {
    const matchesSearch =
      product.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
      product.sku.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesCategory = categoryFilter === 'all' || product.category === categoryFilter;
    return matchesSearch && matchesCategory;
  });

  const addToCart = (product: Product) => {
    const existingItem = cart.find((item) => item.product.id === product.id);
    if (existingItem) {
      if (existingItem.quantity >= product.stock) {
        toast.error('No hay suficiente stock disponible');
        return;
      }
      setCart(
        cart.map((item) =>
          item.product.id === product.id ? { ...item, quantity: item.quantity + 1 } : item
        )
      );
    } else {
      setCart([...cart, { product, quantity: 1 }]);
    }
    toast.success(`${product.name} agregado al carrito`);
  };

  const updateQuantity = (productId: string, change: number) => {
    setCart(
      cart
        .map((item) => {
          if (item.product.id === productId) {
            const newQuantity = item.quantity + change;
            if (newQuantity <= 0) return null;
            if (newQuantity > item.product.stock) {
              toast.error('No hay suficiente stock disponible');
              return item;
            }
            return { ...item, quantity: newQuantity };
          }
          return item;
        })
        .filter((item): item is CartItem => item !== null)
    );
  };

  const removeFromCart = (productId: string) => {
    setCart(cart.filter((item) => item.product.id !== productId));
  };

  const subtotal = cart.reduce((sum, item) => sum + item.product.price * item.quantity, 0);
  const discountAmount = parseFloat(discount) || 0;
  const taxRate = 0.16; // 16% IVA
  const tax = (subtotal - discountAmount) * taxRate;
  const total = subtotal - discountAmount + tax;

  const change =
    paymentMethod === 'cash' && amountReceived
      ? Math.max(0, parseFloat(amountReceived) - total)
      : 0;

  const completeSale = () => {
    if (cart.length === 0) {
      toast.error('El carrito está vacío');
      return;
    }
    if (paymentMethod === 'cash' && (!amountReceived || parseFloat(amountReceived) < total)) {
      toast.error('El monto recibido es insuficiente');
      return;
    }

    toast.success('Venta completada exitosamente');
    setCart([]);
    setAmountReceived('');
    setDiscount('0');
    setPaymentMethod('cash');
  };

  const cancelSale = () => {
    setCart([]);
    setAmountReceived('');
    setDiscount('0');
    toast.info('Venta cancelada');
  };

  const getStockBadgeColor = (stock: number) => {
    if (stock > 50) return 'bg-green-500/10 text-green-700 border-green-500/20';
    if (stock > 10) return 'bg-yellow-500/10 text-yellow-700 border-yellow-500/20';
    return 'bg-red-500/10 text-red-700 border-red-500/20';
  };

  return (
    <div className="grid grid-cols-1 lg:grid-cols-[1fr_400px] gap-6">
      {/* Left Side - Current Sale */}
      <div className="space-y-4">
        <Card>
          <CardContent className="p-6">
            <h2 className="text-xl mb-4 text-primary">Venta Actual</h2>

            {/* Cart Items Table */}
            <div className="border rounded-lg overflow-hidden">
              <div className="overflow-x-auto">
                <table className="w-full">
                  <thead className="bg-muted">
                    <tr>
                      <th className="text-left p-3 font-semibold">Producto</th>
                      <th className="text-right p-3 font-semibold">Precio</th>
                      <th className="text-center p-3 font-semibold">Cantidad</th>
                      <th className="text-right p-3 font-semibold">Subtotal</th>
                      <th className="w-20"></th>
                    </tr>
                  </thead>
                  <tbody>
                    {cart.length === 0 ? (
                      <tr>
                        <td colSpan={5} className="text-center p-8 text-muted-foreground">
                          No hay productos en el carrito
                        </td>
                      </tr>
                    ) : (
                      cart.map((item) => (
                        <tr key={item.product.id} className="border-t">
                          <td className="p-3">
                            <div>
                              <p className="font-medium">{item.product.name}</p>
                              <p className="text-sm text-muted-foreground">
                                SKU: {item.product.sku}
                              </p>
                            </div>
                          </td>
                          <td className="p-3 text-right">${item.product.price.toFixed(2)}</td>
                          <td className="p-3">
                            <div className="flex items-center justify-center gap-2">
                              <Button
                                size="icon"
                                variant="outline"
                                className="h-8 w-8"
                                onClick={() => updateQuantity(item.product.id, -1)}
                              >
                                <Minus className="w-4 h-4" />
                              </Button>
                              <span className="w-12 text-center font-medium">
                                {item.quantity}
                              </span>
                              <Button
                                size="icon"
                                variant="outline"
                                className="h-8 w-8"
                                onClick={() => updateQuantity(item.product.id, 1)}
                              >
                                <Plus className="w-4 h-4" />
                              </Button>
                            </div>
                          </td>
                          <td className="p-3 text-right font-medium">
                            ${(item.product.price * item.quantity).toFixed(2)}
                          </td>
                          <td className="p-3 text-center">
                            <Button
                              size="icon"
                              variant="ghost"
                              className="h-8 w-8 text-destructive hover:text-destructive hover:bg-destructive/10"
                              onClick={() => removeFromCart(item.product.id)}
                            >
                              <Trash2 className="w-4 h-4" />
                            </Button>
                          </td>
                        </tr>
                      ))
                    )}
                  </tbody>
                </table>
              </div>
            </div>

            {/* Totals */}
            <div className="mt-6 space-y-4">
              <div className="flex justify-between text-lg">
                <span>Subtotal:</span>
                <span>${subtotal.toFixed(2)}</span>
              </div>

              <div className="flex items-center gap-4">
                <Label htmlFor="discount" className="min-w-24">
                  Descuento:
                </Label>
                <Input
                  id="discount"
                  type="number"
                  value={discount}
                  onChange={(e) => setDiscount(e.target.value)}
                  className="max-w-32 bg-input-background border"
                  placeholder="0.00"
                  min="0"
                  step="0.01"
                />
                <span className="text-muted-foreground">
                  ${parseFloat(discount || '0').toFixed(2)}
                </span>
              </div>

              <div className="flex justify-between text-lg">
                <span>IVA (16%):</span>
                <span>${tax.toFixed(2)}</span>
              </div>

              <div className="h-px bg-border" />

              <div className="flex justify-between text-3xl text-primary">
                <span>TOTAL:</span>
                <span>${total.toFixed(2)}</span>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Right Side - Product Search & Checkout */}
      <div className="space-y-4">
        {/* Search Section */}
        <Card>
          <CardContent className="p-6 space-y-4">
            <div className="space-y-2">
              <Label htmlFor="search">Buscar Producto</Label>
              <div className="relative">
                <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground" />
                <Input
                  id="search"
                  placeholder="Nombre o SKU..."
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  className="pl-10 h-12 bg-input-background border"
                />
              </div>
            </div>

            <div className="space-y-2">
              <Label htmlFor="category">Categoría</Label>
              <Select value={categoryFilter} onValueChange={setCategoryFilter}>
                <SelectTrigger id="category" className="h-12 bg-input-background border">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">Todas las categorías</SelectItem>
                  {categories
                    .filter((c) => c !== 'all')
                    .map((category) => (
                      <SelectItem key={category} value={category}>
                        {category}
                      </SelectItem>
                    ))}
                </SelectContent>
              </Select>
            </div>

            {/* Product Results */}
            <div className="space-y-3 max-h-[300px] overflow-y-auto">
              {filteredProducts.map((product) => (
                <Card key={product.id} className="border shadow-sm hover:shadow-md transition">
                  <CardContent className="p-4">
                    <div className="flex justify-between items-start mb-2">
                      <div className="flex-1">
                        <h3 className="font-semibold">{product.name}</h3>
                        <p className="text-sm text-muted-foreground">{product.brand}</p>
                      </div>
                      <Badge className={getStockBadgeColor(product.stock)}>
                        Stock: {product.stock}
                      </Badge>
                    </div>
                    <div className="flex justify-between items-center">
                      <span className="text-lg font-semibold text-primary">
                        ${product.price.toFixed(2)}
                      </span>
                      <Button
                        size="sm"
                        onClick={() => addToCart(product)}
                        disabled={product.stock === 0}
                        className="bg-accent hover:bg-accent/90"
                      >
                        <Plus className="w-4 h-4 mr-1" />
                        Agregar
                      </Button>
                    </div>
                  </CardContent>
                </Card>
              ))}
            </div>
          </CardContent>
        </Card>

        {/* Checkout Section */}
        <Card>
          <CardContent className="p-6 space-y-4">
            <h3 className="font-semibold text-lg text-primary">Pago</h3>

            <div className="space-y-2">
              <Label htmlFor="payment">Método de Pago</Label>
              <Select
                value={paymentMethod}
                onValueChange={(value) => setPaymentMethod(value as typeof paymentMethod)}
              >
                <SelectTrigger id="payment" className="h-12 bg-input-background border">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="cash">Efectivo</SelectItem>
                  <SelectItem value="card">Tarjeta</SelectItem>
                  <SelectItem value="transfer">Transferencia</SelectItem>
                </SelectContent>
              </Select>
            </div>

            {paymentMethod === 'cash' && (
              <>
                <div className="space-y-2">
                  <Label htmlFor="received">Monto Recibido</Label>
                  <div className="relative">
                    <DollarSign className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground" />
                    <Input
                      id="received"
                      type="number"
                      value={amountReceived}
                      onChange={(e) => setAmountReceived(e.target.value)}
                      className="pl-10 h-12 bg-input-background border"
                      placeholder="0.00"
                      step="0.01"
                    />
                  </div>
                </div>

                <div className="bg-muted p-4 rounded-lg">
                  <div className="flex justify-between items-center">
                    <span className="font-semibold">Cambio:</span>
                    <span className="text-2xl font-bold text-accent">
                      ${change.toFixed(2)}
                    </span>
                  </div>
                </div>
              </>
            )}

            <div className="space-y-3 pt-4">
              <Button
                onClick={completeSale}
                className="w-full h-14 text-lg bg-accent hover:bg-accent/90"
              >
                Completar Venta
              </Button>
              <Button
                onClick={cancelSale}
                variant="outline"
                className="w-full h-12 border-destructive text-destructive hover:bg-destructive/10"
              >
                Cancelar Venta
              </Button>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}