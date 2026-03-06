from pydantic import BaseModel

class Producto(BaseModel):
    codigo: str
    nombre: str
    descripcion: str
    precio_venta: float
    costo: float
    stock: int
    stock_minimo: int
    id_categoria: int
    id_marca: int
    unidad_medida: str
    activo: bool