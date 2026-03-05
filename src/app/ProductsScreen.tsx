import { useState } from 'react';
import { Button } from './components/ui/button';
import { Input } from './components/ui/input';
import { Card, CardContent } from './components/ui/card';
import { Badge } from './components/ui/badge';
import { products as initialProducts } from './data';
import { Product } from './types';
import { Search, Plus, Edit } from 'lucide-react';

export function ProductsScreen() {
  const [products] = useState<Product[]>(initialProducts);
  const [searchQuery, setSearchQuery] = useState('');

  const filteredProducts = products.filter(
    (product) =>
      product.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
      product.sku.toLowerCase().includes(searchQuery.toLowerCase()) ||
      product.brand.toLowerCase().includes(searchQuery.toLowerCase()) ||
      product.category.toLowerCase().includes(searchQuery.toLowerCase())
  );

  const getStockBadgeColor = (stock: number) => {
    if (stock > 50) return 'bg-green-500/10 text-green-700 border-green-500/20';
    if (stock > 10) return 'bg-yellow-500/10 text-yellow-700 border-yellow-500/20';
    return 'bg-red-500/10 text-red-700 border-red-500/20';
  };

  return (
    <Card>
      <CardContent className="p-6">
        <div className="flex justify-between items-center mb-6">
          <h2 className="text-2xl text-primary">Gestión de Productos</h2>
          <Button className="bg-accent hover:bg-accent/90">
            <Plus className="w-4 h-4 mr-2" />
            Agregar Producto
          </Button>
        </div>

        {/* Search Bar */}
        <div className="mb-6">
          <div className="relative max-w-md">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground" />
            <Input
              placeholder="Buscar productos..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="pl-10 h-12 bg-input-background border"
            />
          </div>
        </div>

        {/* Products Table */}
        <div className="border rounded-lg overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-muted">
                <tr>
                  <th className="text-left p-4 font-semibold">SKU</th>
                  <th className="text-left p-4 font-semibold">Producto</th>
                  <th className="text-left p-4 font-semibold">Categoría</th>
                  <th className="text-left p-4 font-semibold">Marca</th>
                  <th className="text-right p-4 font-semibold">Precio</th>
                  <th className="text-center p-4 font-semibold">Stock</th>
                  <th className="text-center p-4 font-semibold">Estado</th>
                  <th className="text-center p-4 font-semibold">Acciones</th>
                </tr>
              </thead>
              <tbody>
                {filteredProducts.map((product) => (
                  <tr key={product.id} className="border-t hover:bg-muted/50">
                    <td className="p-4 font-mono text-sm">{product.sku}</td>
                    <td className="p-4">
                      <div>
                        <p className="font-medium">{product.name}</p>
                      </div>
                    </td>
                    <td className="p-4">{product.category}</td>
                    <td className="p-4">{product.brand}</td>
                    <td className="p-4 text-right font-medium">
                      ${product.price.toFixed(2)}
                    </td>
                    <td className="p-4">
                      <div className="flex justify-center">
                        <Badge className={getStockBadgeColor(product.stock)}>
                          {product.stock}
                        </Badge>
                      </div>
                    </td>
                    <td className="p-4">
                      <div className="flex justify-center">
                        <Badge
                          className={
                            product.status === 'active'
                              ? 'bg-green-500/10 text-green-700 border-green-500/20'
                              : 'bg-gray-500/10 text-gray-700 border-gray-500/20'
                          }
                        >
                          {product.status === 'active' ? 'Activo' : 'Inactivo'}
                        </Badge>
                      </div>
                    </td>
                    <td className="p-4">
                      <div className="flex justify-center">
                        <Button size="sm" variant="outline">
                          <Edit className="w-4 h-4 mr-1" />
                          Editar
                        </Button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        {filteredProducts.length === 0 && (
          <div className="text-center py-12 text-muted-foreground">
            No se encontraron productos
          </div>
        )}
      </CardContent>
    </Card>
  );
}