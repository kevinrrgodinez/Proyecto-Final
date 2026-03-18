import 'package:flutter/material.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/admin/admin_dashboard_screen.dart';
import '../../screens/admin/admin_products_screen.dart';
import '../../screens/admin/admin_inventory_screen.dart';
import '../../screens/admin/admin_users_screen.dart';
import '../../screens/admin/admin_sales_screen.dart';
import '../../screens/vendedor/vendedor_dashboard_screen.dart';
import '../../screens/vendedor/pos_screen.dart';
import '../../screens/vendedor/clientes_screen.dart';
import '../../screens/vendedor/vendedor_sales_screen.dart';
import '../../screens/cliente/cliente_home_screen.dart';
import '../../screens/cliente/cliente_catalogo_screen.dart';
import '../../screens/cliente/cliente_compras_screen.dart';
import '../../screens/cliente/perfil_screen.dart';

class AppRoutes {
  static const String login = '/login';

  static const String adminDashboard = '/admin';
  static const String adminProducts = '/admin/products';
  static const String adminInventory = '/admin/inventory';
  static const String adminUsers = '/admin/users';
  static const String adminSales = '/admin/sales';

  static const String vendedorDashboard = '/vendedor';
  static const String pos = '/vendedor/pos';
  static const String vendedorClientes = '/vendedor/clientes';
  static const String vendedorSales = '/vendedor/sales';

  static const String clienteHome = '/cliente';
  static const String clienteCatalogo = '/cliente/catalogo';
  static const String clienteCompras = '/cliente/compras';
  static const String clientePerfil = '/cliente/perfil';

  static Map<String, WidgetBuilder> get routes {
    return {
      login: (_) => const LoginScreen(),
      adminDashboard: (_) => const AdminDashboardScreen(),
      adminProducts: (_) => const AdminProductsScreen(),
      adminInventory: (_) => const AdminInventoryScreen(),
      adminUsers: (_) => const AdminUsersScreen(),
      adminSales: (_) => const AdminSalesScreen(),
      vendedorDashboard: (_) => const VendedorDashboardScreen(),
      pos: (_) => const PosScreen(),
      vendedorClientes: (_) => const ClientesScreen(),
      vendedorSales: (_) => const VendedorSalesScreen(),
      clienteHome: (_) => const ClienteHomeScreen(),
      clienteCatalogo: (_) => const ClienteCatalogoScreen(),
      clienteCompras: (_) => const ClienteComprasScreen(),
      clientePerfil: (_) => const PerfilScreen(),
    };
  }
}
