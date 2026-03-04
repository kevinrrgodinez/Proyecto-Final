import 'package:flutter/material.dart';
import 'products_screen.dart';
import 'inventory_screen.dart';
import 'pos_screen.dart';
import 'sales_history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_DashboardItem>[
      _DashboardItem(
        title: "Punto de venta",
        subtitle: "Cobrar, carrito y ticket",
        icon: Icons.point_of_sale,
        screen: const PosScreen(),
      ),
      _DashboardItem(
        title: "Productos",
        subtitle: "Catálogo y precios",
        icon: Icons.inventory_2_outlined,
        screen: const ProductsScreen(),
      ),
      _DashboardItem(
        title: "Inventario",
        subtitle: "Stock y mínimos",
        icon: Icons.warehouse_outlined,
        screen: const InventoryScreen(),
      ),
      _DashboardItem(
        title: "Ventas",
        subtitle: "Historial y detalles",
        icon: Icons.receipt_long_outlined,
        screen: const SalesHistoryScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ferretería - Dashboard"),
        actions: [
          IconButton(
            tooltip: "Salir",
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _ResumenCard(),
            const SizedBox(height: 14),
            Expanded(
              child: GridView.builder(
                itemCount: items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.15,
                ),
                itemBuilder: (_, i) => _DashboardTile(item: items[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResumenCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 22,
              child: Icon(Icons.storefront),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Sucursal: Principal", style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(height: 2),
                  Text("Listo para vender • Inventario monitoreado"),
                ],
              ),
            ),
            FilledButton.tonal(
              onPressed: () {},
              child: const Text("Corte"),
            )
          ],
        ),
      ),
    );
  }
}

class _DashboardTile extends StatelessWidget {
  final _DashboardItem item;
  const _DashboardTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => item.screen),
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(item.icon, size: 34),
              const Spacer(),
              Text(item.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              const SizedBox(height: 4),
              Text(item.subtitle, style: TextStyle(color: Colors.grey.shade700)),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget screen;

  _DashboardItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.screen,
  });
}