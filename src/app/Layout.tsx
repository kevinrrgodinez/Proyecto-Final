import { Outlet, useNavigate, useLocation } from 'react-router';
import { Navigation } from './Navigation';
import { Tabs, TabsList, TabsTrigger } from './components/ui/tabs';
import { ShoppingCart, Package, Warehouse, Receipt } from 'lucide-react';

export function Layout() {
  const navigate = useNavigate();
  const location = useLocation();

  const currentTab = location.pathname.split('/')[1] || 'pos';

  const handleTabChange = (value: string) => {
    navigate(`/${value}`);
  };

  return (
    <div className="min-h-screen bg-background">
      <Navigation />

      <div className="max-w-[1440px] mx-auto p-6">
        <Tabs value={currentTab} onValueChange={handleTabChange} className="mb-6">
          <TabsList className="grid w-full max-w-2xl grid-cols-4 h-14">
            <TabsTrigger value="pos" className="text-base gap-2">
              <ShoppingCart className="w-5 h-5" />
              <span className="hidden sm:inline">Punto de Venta</span>
              <span className="sm:hidden">POS</span>
            </TabsTrigger>
            <TabsTrigger value="products" className="text-base gap-2">
              <Package className="w-5 h-5" />
              <span className="hidden sm:inline">Productos</span>
              <span className="sm:hidden">Prod</span>
            </TabsTrigger>
            <TabsTrigger value="inventory" className="text-base gap-2">
              <Warehouse className="w-5 h-5" />
              <span className="hidden sm:inline">Inventario</span>
              <span className="sm:hidden">Inv</span>
            </TabsTrigger>
            <TabsTrigger value="sales" className="text-base gap-2">
              <Receipt className="w-5 h-5" />
              <span className="hidden sm:inline">Ventas</span>
              <span className="sm:hidden">Ventas</span>
            </TabsTrigger>
          </TabsList>
        </Tabs>

        <Outlet />
      </div>
    </div>
  );
}
