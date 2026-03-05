import { createBrowserRouter } from 'react-router';
import { Login } from './Login';
import { Layout } from './Layout';
import { POSScreen } from './POSScreen';
import { ProductsScreen } from './ProductsScreen';
import { InventoryScreen } from './InventoryScreen';
import { SalesHistoryScreen } from './SalesHistoryScreen';

export const router = createBrowserRouter([
  {
    path: '/',
    Component: Login,
  },
  {
    path: '/',
    Component: Layout,
    children: [
      {
        path: 'pos',
        Component: POSScreen,
      },
      {
        path: 'products',
        Component: ProductsScreen,
      },
      {
        path: 'inventory',
        Component: InventoryScreen,
      },
      {
        path: 'sales',
        Component: SalesHistoryScreen,
      },
    ],
  },
]);
