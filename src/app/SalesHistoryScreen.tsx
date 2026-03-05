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
import { salesHistory } from './data';
import { Sale } from './types';
import { Eye, CreditCard, Banknote, ArrowRightLeft } from 'lucide-react';

export function SalesHistoryScreen() {
  const [sales] = useState<Sale[]>(salesHistory);
  const [startDate, setStartDate] = useState('');
  const [endDate, setEndDate] = useState('');
  const [selectedSale, setSelectedSale] = useState<Sale | null>(null);

  const filteredSales = sales.filter((sale) => {
    const saleDate = new Date(sale.date);
    const start = startDate ? new Date(startDate) : null;
    const end = endDate ? new Date(endDate) : null;

    if (start && saleDate < start) return false;
    if (end && saleDate > end) return false;
    return true;
  });

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleString('es-MX', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
    });
  };

  const getPaymentIcon = (method: string) => {
    switch (method) {
      case 'cash':
        return <Banknote className="w-4 h-4" />;
      case 'card':
        return <CreditCard className="w-4 h-4" />;
      case 'transfer':
        return <ArrowRightLeft className="w-4 h-4" />;
    }
  };

  const getPaymentLabel = (method: string) => {
    switch (method) {
      case 'cash':
        return 'Efectivo';
      case 'card':
        return 'Tarjeta';
      case 'transfer':
        return 'Transferencia';
    }
  };

  const getPaymentBadgeColor = (method: string) => {
    switch (method) {
      case 'cash':
        return 'bg-green-500/10 text-green-700 border-green-500/20';
      case 'card':
        return 'bg-blue-500/10 text-blue-700 border-blue-500/20';
      case 'transfer':
        return 'bg-purple-500/10 text-purple-700 border-purple-500/20';
    }
  };

  const totalSales = filteredSales.reduce((sum, sale) => sum + sale.total, 0);

  return (
    <Card>
      <CardContent className="p-6">
        <div className="flex justify-between items-center mb-6">
          <h2 className="text-2xl text-primary">Historial de Ventas</h2>
          <div className="text-right">
            <p className="text-sm text-muted-foreground">Total de ventas filtradas</p>
            <p className="text-2xl font-semibold text-primary">${totalSales.toFixed(2)}</p>
          </div>
        </div>

        {/* Date Filters */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
          <div className="space-y-2">
            <Label htmlFor="startDate">Fecha Inicial</Label>
            <Input
              id="startDate"
              type="date"
              value={startDate}
              onChange={(e) => setStartDate(e.target.value)}
              className="bg-input-background border"
            />
          </div>
          <div className="space-y-2">
            <Label htmlFor="endDate">Fecha Final</Label>
            <Input
              id="endDate"
              type="date"
              value={endDate}
              onChange={(e) => setEndDate(e.target.value)}
              className="bg-input-background border"
            />
          </div>
        </div>

        {/* Sales Table */}
        <div className="border rounded-lg overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-muted">
                <tr>
                  <th className="text-left p-4 font-semibold">ID Venta</th>
                  <th className="text-left p-4 font-semibold">Fecha</th>
                  <th className="text-right p-4 font-semibold">Total</th>
                  <th className="text-center p-4 font-semibold">Método de Pago</th>
                  <th className="text-left p-4 font-semibold">Vendedor</th>
                  <th className="text-center p-4 font-semibold">Acciones</th>
                </tr>
              </thead>
              <tbody>
                {filteredSales.map((sale) => (
                  <tr key={sale.id} className="border-t hover:bg-muted/50">
                    <td className="p-4 font-mono text-sm">{sale.id}</td>
                    <td className="p-4">{formatDate(sale.date)}</td>
                    <td className="p-4 text-right font-semibold text-primary">
                      ${sale.total.toFixed(2)}
                    </td>
                    <td className="p-4">
                      <div className="flex justify-center">
                        <Badge className={getPaymentBadgeColor(sale.paymentMethod)}>
                          <span className="mr-1">{getPaymentIcon(sale.paymentMethod)}</span>
                          {getPaymentLabel(sale.paymentMethod)}
                        </Badge>
                      </div>
                    </td>
                    <td className="p-4">{sale.seller}</td>
                    <td className="p-4">
                      <div className="flex justify-center">
                        <Dialog>
                          <DialogTrigger asChild>
                            <Button
                              size="sm"
                              variant="outline"
                              onClick={() => setSelectedSale(sale)}
                            >
                              <Eye className="w-4 h-4 mr-1" />
                              Ver Detalles
                            </Button>
                          </DialogTrigger>
                          <DialogContent className="max-w-2xl">
                            <DialogHeader>
                              <DialogTitle>Detalles de Venta - {sale.id}</DialogTitle>
                            </DialogHeader>
                            <div className="space-y-6 pt-4">
                              {/* Sale Info */}
                              <div className="grid grid-cols-2 gap-4">
                                <div>
                                  <p className="text-sm text-muted-foreground">Fecha</p>
                                  <p className="font-medium">{formatDate(sale.date)}</p>
                                </div>
                                <div>
                                  <p className="text-sm text-muted-foreground">Vendedor</p>
                                  <p className="font-medium">{sale.seller}</p>
                                </div>
                                <div>
                                  <p className="text-sm text-muted-foreground">Método de Pago</p>
                                  <Badge className={getPaymentBadgeColor(sale.paymentMethod)}>
                                    <span className="mr-1">
                                      {getPaymentIcon(sale.paymentMethod)}
                                    </span>
                                    {getPaymentLabel(sale.paymentMethod)}
                                  </Badge>
                                </div>
                              </div>

                              {/* Items Table */}
                              <div>
                                <h4 className="font-semibold mb-3">Productos</h4>
                                <div className="border rounded-lg overflow-hidden">
                                  <table className="w-full">
                                    <thead className="bg-muted">
                                      <tr>
                                        <th className="text-left p-3 text-sm font-semibold">
                                          Producto
                                        </th>
                                        <th className="text-right p-3 text-sm font-semibold">
                                          Precio
                                        </th>
                                        <th className="text-center p-3 text-sm font-semibold">
                                          Cantidad
                                        </th>
                                        <th className="text-right p-3 text-sm font-semibold">
                                          Subtotal
                                        </th>
                                      </tr>
                                    </thead>
                                    <tbody>
                                      {sale.items.map((item, idx) => (
                                        <tr key={idx} className="border-t">
                                          <td className="p-3">
                                            <p className="font-medium">
                                              {item.product.name}
                                            </p>
                                            <p className="text-sm text-muted-foreground">
                                              SKU: {item.product.sku}
                                            </p>
                                          </td>
                                          <td className="p-3 text-right">
                                            ${item.product.price.toFixed(2)}
                                          </td>
                                          <td className="p-3 text-center">
                                            {item.quantity}
                                          </td>
                                          <td className="p-3 text-right font-medium">
                                            ${(item.product.price * item.quantity).toFixed(2)}
                                          </td>
                                        </tr>
                                      ))}
                                    </tbody>
                                  </table>
                                </div>
                              </div>

                              {/* Totals */}
                              <div className="space-y-2 bg-muted p-4 rounded-lg">
                                <div className="flex justify-between">
                                  <span>Subtotal:</span>
                                  <span>${sale.subtotal.toFixed(2)}</span>
                                </div>
                                {sale.discount > 0 && (
                                  <div className="flex justify-between text-destructive">
                                    <span>Descuento:</span>
                                    <span>-${sale.discount.toFixed(2)}</span>
                                  </div>
                                )}
                                <div className="flex justify-between">
                                  <span>IVA (16%):</span>
                                  <span>${sale.tax.toFixed(2)}</span>
                                </div>
                                <div className="h-px bg-border my-2" />
                                <div className="flex justify-between text-xl font-semibold text-primary">
                                  <span>TOTAL:</span>
                                  <span>${sale.total.toFixed(2)}</span>
                                </div>
                              </div>
                            </div>
                          </DialogContent>
                        </Dialog>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        {filteredSales.length === 0 && (
          <div className="text-center py-12 text-muted-foreground">
            No se encontraron ventas en el rango de fechas seleccionado
          </div>
        )}
      </CardContent>
    </Card>
  );
}