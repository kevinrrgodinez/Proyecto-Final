import { useState } from 'react';
import { Button } from './components/ui/button';
import { Input } from './components/ui/input';
import { Label } from './components/ui/label';
import { Card, CardContent } from './components/ui/card';
import { Badge } from './components/ui/badge';
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from './components/ui/dialog';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from './components/ui/select';
import { Textarea } from './components/ui/textarea';
import { stockMovements as initialMovements, products } from './data';
import { StockMovement } from './types';
import { Plus, TrendingUp, TrendingDown, RefreshCw } from 'lucide-react';
import { toast } from 'sonner';

export function InventoryScreen() {
  const [movements, setMovements] = useState<StockMovement[]>(initialMovements);
  const [isDialogOpen, setIsDialogOpen] = useState(false);
  const [formData, setFormData] = useState({
    productId: '',
    type: 'in' as 'in' | 'out' | 'adjustment',
    quantity: '',
    reason: '',
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();

    const product = products.find((p) => p.id === formData.productId);
    if (!product) return;

    const newMovement: StockMovement = {
      id: `MOV-${Date.now()}`,
      productId: formData.productId,
      productName: product.name,
      type: formData.type,
      quantity: parseInt(formData.quantity),
      reason: formData.reason,
      date: new Date().toISOString(),
    };

    setMovements([newMovement, ...movements]);
    toast.success('Movimiento de inventario registrado');
    setIsDialogOpen(false);
    setFormData({
      productId: '',
      type: 'in',
      quantity: '',
      reason: '',
    });
  };

  const getMovementIcon = (type: string) => {
    switch (type) {
      case 'in':
        return <TrendingUp className="w-4 h-4" />;
      case 'out':
        return <TrendingDown className="w-4 h-4" />;
      case 'adjustment':
        return <RefreshCw className="w-4 h-4" />;
    }
  };

  const getMovementBadgeColor = (type: string) => {
    switch (type) {
      case 'in':
        return 'bg-green-500/10 text-green-700 border-green-500/20';
      case 'out':
        return 'bg-red-500/10 text-red-700 border-red-500/20';
      case 'adjustment':
        return 'bg-blue-500/10 text-blue-700 border-blue-500/20';
    }
  };

  const getMovementLabel = (type: string) => {
    switch (type) {
      case 'in':
        return 'Entrada';
      case 'out':
        return 'Salida';
      case 'adjustment':
        return 'Ajuste';
    }
  };

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleString('es-MX', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
    });
  };

  const getStockBadgeColor = (stock: number) => {
    if (stock > 50) return 'bg-green-500/10 text-green-700 border-green-500/20';
    if (stock > 10) return 'bg-yellow-500/10 text-yellow-700 border-yellow-500/20';
    return 'bg-red-500/10 text-red-700 border-red-500/20';
  };

  return (
    <div className="space-y-6">
      {/* Current Stock */}
      <Card>
        <CardContent className="p-6">
          <h2 className="text-2xl mb-6 text-primary">Stock Actual</h2>

          <div className="border rounded-lg overflow-hidden">
            <div className="overflow-x-auto">
              <table className="w-full">
                <thead className="bg-muted">
                  <tr>
                    <th className="text-left p-4 font-semibold">SKU</th>
                    <th className="text-left p-4 font-semibold">Producto</th>
                    <th className="text-left p-4 font-semibold">Categoría</th>
                    <th className="text-right p-4 font-semibold">Precio</th>
                    <th className="text-center p-4 font-semibold">Stock</th>
                  </tr>
                </thead>
                <tbody>
                  {products.map((product) => (
                    <tr key={product.id} className="border-t hover:bg-muted/50">
                      <td className="p-4 font-mono text-sm">{product.sku}</td>
                      <td className="p-4">
                        <p className="font-medium">{product.name}</p>
                        <p className="text-sm text-muted-foreground">{product.brand}</p>
                      </td>
                      <td className="p-4">{product.category}</td>
                      <td className="p-4 text-right">${product.price.toFixed(2)}</td>
                      <td className="p-4">
                        <div className="flex justify-center">
                          <Badge className={getStockBadgeColor(product.stock)}>
                            {product.stock} unidades
                          </Badge>
                        </div>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Stock Movements */}
      <Card>
        <CardContent className="p-6">
          <div className="flex justify-between items-center mb-6">
            <h2 className="text-2xl text-primary">Movimientos de Inventario</h2>

            <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
              <DialogTrigger asChild>
                <Button className="bg-accent hover:bg-accent/90">
                  <Plus className="w-4 h-4 mr-2" />
                  Nuevo Movimiento
                </Button>
              </DialogTrigger>
              <DialogContent className="max-w-md">
                <DialogHeader>
                  <DialogTitle>Nuevo Movimiento de Stock</DialogTitle>
                </DialogHeader>
                <form onSubmit={handleSubmit} className="space-y-4 pt-4">
                  <div className="space-y-2">
                    <Label htmlFor="product">Producto</Label>
                    <Select
                      value={formData.productId}
                      onValueChange={(value) => setFormData({ ...formData, productId: value })}
                      required
                    >
                      <SelectTrigger id="product" className="bg-input-background border">
                        <SelectValue placeholder="Seleccionar producto" />
                      </SelectTrigger>
                      <SelectContent>
                        {products.map((product) => (
                          <SelectItem key={product.id} value={product.id}>
                            {product.name} - Stock: {product.stock}
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                  </div>

                  <div className="space-y-2">
                    <Label htmlFor="type">Tipo de Movimiento</Label>
                    <Select
                      value={formData.type}
                      onValueChange={(value) =>
                        setFormData({ ...formData, type: value as typeof formData.type })
                      }
                      required
                    >
                      <SelectTrigger id="type" className="bg-input-background border">
                        <SelectValue />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="in">Entrada</SelectItem>
                        <SelectItem value="out">Salida</SelectItem>
                        <SelectItem value="adjustment">Ajuste</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>

                  <div className="space-y-2">
                    <Label htmlFor="quantity">Cantidad</Label>
                    <Input
                      id="quantity"
                      type="number"
                      value={formData.quantity}
                      onChange={(e) => setFormData({ ...formData, quantity: e.target.value })}
                      className="bg-input-background border"
                      placeholder="0"
                      required
                    />
                  </div>

                  <div className="space-y-2">
                    <Label htmlFor="reason">Motivo</Label>
                    <Textarea
                      id="reason"
                      value={formData.reason}
                      onChange={(e) => setFormData({ ...formData, reason: e.target.value })}
                      className="bg-input-background border min-h-20"
                      placeholder="Describe el motivo del movimiento..."
                      required
                    />
                  </div>

                  <div className="flex gap-3 pt-4">
                    <Button type="submit" className="flex-1 bg-primary hover:bg-primary/90">
                      Guardar
                    </Button>
                    <Button
                      type="button"
                      variant="outline"
                      onClick={() => setIsDialogOpen(false)}
                      className="flex-1"
                    >
                      Cancelar
                    </Button>
                  </div>
                </form>
              </DialogContent>
            </Dialog>
          </div>

          <div className="border rounded-lg overflow-hidden">
            <div className="overflow-x-auto">
              <table className="w-full">
                <thead className="bg-muted">
                  <tr>
                    <th className="text-left p-4 font-semibold">Fecha</th>
                    <th className="text-left p-4 font-semibold">Producto</th>
                    <th className="text-center p-4 font-semibold">Tipo</th>
                    <th className="text-right p-4 font-semibold">Cantidad</th>
                    <th className="text-left p-4 font-semibold">Motivo</th>
                  </tr>
                </thead>
                <tbody>
                  {movements.map((movement) => (
                    <tr key={movement.id} className="border-t hover:bg-muted/50">
                      <td className="p-4 text-sm">{formatDate(movement.date)}</td>
                      <td className="p-4 font-medium">{movement.productName}</td>
                      <td className="p-4">
                        <div className="flex justify-center">
                          <Badge className={getMovementBadgeColor(movement.type)}>
                            <span className="mr-1">{getMovementIcon(movement.type)}</span>
                            {getMovementLabel(movement.type)}
                          </Badge>
                        </div>
                      </td>
                      <td className="p-4 text-right font-medium">
                        {movement.type === 'in'
                          ? '+'
                          : movement.type === 'out'
                          ? '-'
                          : ''}
                        {movement.quantity}
                      </td>
                      <td className="p-4 text-muted-foreground">{movement.reason}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}