# Backend combinado

Se generó tomando como base el backend de Kevin y agregando los módulos del backend admin-final.

Incluye:
- Autenticación con MongoDB (usuarios/clientes)
- Gestión de usuarios, clientes y ventas
- Proxy para productos vía microservicio externo
- Ruta de compras/factura

## Rutas principales
- `POST /auth/login`
- `GET/POST /clientes`
- `GET/POST /usuarios`
- `GET/POST /ventas`
- `GET/POST /productos`
- `POST /compras`

## Dependencias agregadas
- axios
- pg
