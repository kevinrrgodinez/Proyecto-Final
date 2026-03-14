from sqlalchemy import Column, Integer, String, Numeric, Boolean, Text, TIMESTAMP, ForeignKey, text
from sqlalchemy.orm import relationship
from database import Base


class Categoria(Base):
    __tablename__ = "categorias"

    id = Column(Integer, primary_key=True, index=True)
    nombre = Column(String(100), nullable=False, unique=True)


class Marca(Base):
    __tablename__ = "marcas"

    id = Column(Integer, primary_key=True, index=True)
    nombre = Column(String(100), nullable=False, unique=True)


class Producto(Base):
    __tablename__ = "productos"

    id = Column(Integer, primary_key=True, index=True)
    codigo = Column(String(30), nullable=False, unique=True)
    nombre = Column(String(150), nullable=False)
    descripcion = Column(Text, nullable=True)
    precio_venta = Column(Numeric(10, 2), nullable=False)
    costo = Column(Numeric(10, 2), nullable=False)
    stock = Column(Integer, nullable=False)
    stock_minimo = Column(Integer, nullable=False)
    id_categoria = Column(Integer, ForeignKey("categorias.id"), nullable=False)
    id_marca = Column(Integer, ForeignKey("marcas.id"), nullable=False)
    unidad_medida = Column(String(30), nullable=False)
    activo = Column(Boolean, default=True)
    fecha_creacion = Column(TIMESTAMP, server_default=text("CURRENT_TIMESTAMP"))

    categoria = relationship("Categoria")
    marca = relationship("Marca")