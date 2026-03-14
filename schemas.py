from pydantic import BaseModel, ConfigDict
from typing import Optional
from datetime import datetime


class ProductoBase(BaseModel):
    codigo: str
    nombre: str
    descripcion: Optional[str] = None
    precio_venta: float
    costo: float
    stock: int
    stock_minimo: int
    id_categoria: int
    id_marca: int
    unidad_medida: str
    activo: bool = True


class ProductoCreate(ProductoBase):
    pass


class ProductoUpdate(BaseModel):
    codigo: Optional[str] = None
    nombre: Optional[str] = None
    descripcion: Optional[str] = None
    precio_venta: Optional[float] = None
    costo: Optional[float] = None
    stock: Optional[int] = None
    stock_minimo: Optional[int] = None
    id_categoria: Optional[int] = None
    id_marca: Optional[int] = None
    unidad_medida: Optional[str] = None
    activo: Optional[bool] = None


class ProductoResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    codigo: str
    nombre: str
    descripcion: Optional[str]
    precio_venta: float
    costo: float
    stock: int
    stock_minimo: int
    id_categoria: int
    id_marca: int
    unidad_medida: str
    activo: bool
    fecha_creacion: Optional[datetime]


class ProductoDetalle(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    codigo: str
    nombre: str
    descripcion: Optional[str]
    precio_venta: float
    costo: float
    stock: int
    stock_minimo: int
    id_categoria: int
    id_marca: int
    unidad_medida: str
    activo: bool
    fecha_creacion: Optional[datetime]
    categoria: str
    marca: str


class DescontarStockRequest(BaseModel):
    cantidad: int