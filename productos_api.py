from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError
from database import SessionLocal, engine
import models
import schemas

print(">>> CARGANDO productos_api.py <<<")

models.Base.metadata.create_all(bind=engine)

app = FastAPI(title="Microservicio de Productos")

from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origin_regex=r"^https?://(localhost|127\.0\.0\.1)(:\d+)?$",
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
def inicio():
    return {"mensaje": "productos_api funcionando"}

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.get("/productos", response_model=list[schemas.ProductoDetalle])
def listar_productos(db: Session = Depends(get_db)):
    productos = db.query(models.Producto).all()

    resultado = []
    for p in productos:
        resultado.append(
            schemas.ProductoDetalle(
                id=p.id,
                codigo=p.codigo,
                nombre=p.nombre,
                descripcion=p.descripcion,
                precio_venta=float(p.precio_venta),
                costo=float(p.costo),
                stock=p.stock,
                stock_minimo=p.stock_minimo,
                id_categoria=p.id_categoria,
                id_marca=p.id_marca,
                unidad_medida=p.unidad_medida,
                activo=p.activo,
                fecha_creacion=p.fecha_creacion,
                categoria=p.categoria.nombre if p.categoria else "",
                marca=p.marca.nombre if p.marca else "",
            )
        )
    return resultado


@app.get("/productos/{id}", response_model=schemas.ProductoDetalle)
def obtener_producto(id: int, db: Session = Depends(get_db)):
    p = db.query(models.Producto).filter(models.Producto.id == id).first()

    if not p:
        raise HTTPException(status_code=404, detail="Producto no encontrado")

    return schemas.ProductoDetalle(
        id=p.id,
        codigo=p.codigo,
        nombre=p.nombre,
        descripcion=p.descripcion,
        precio_venta=float(p.precio_venta),
        costo=float(p.costo),
        stock=p.stock,
        stock_minimo=p.stock_minimo,
        id_categoria=p.id_categoria,
        id_marca=p.id_marca,
        unidad_medida=p.unidad_medida,
        activo=p.activo,
        fecha_creacion=p.fecha_creacion,
        categoria=p.categoria.nombre if p.categoria else "",
        marca=p.marca.nombre if p.marca else "",
    )


@app.post("/productos", response_model=schemas.ProductoResponse)
def crear_producto(producto: schemas.ProductoCreate, db: Session = Depends(get_db)):
    if producto.precio_venta < producto.costo:
        raise HTTPException(status_code=400, detail="El precio de venta no puede ser menor al costo")

    nuevo_producto = models.Producto(
        codigo=producto.codigo,
        nombre=producto.nombre,
        descripcion=producto.descripcion,
        precio_venta=producto.precio_venta,
        costo=producto.costo,
        stock=producto.stock,
        stock_minimo=producto.stock_minimo,
        id_categoria=producto.id_categoria,
        id_marca=producto.id_marca,
        unidad_medida=producto.unidad_medida,
        activo=producto.activo,
    )

    try:
        db.add(nuevo_producto)
        db.commit()
        db.refresh(nuevo_producto)
        return nuevo_producto
    except IntegrityError:
        db.rollback()
        raise HTTPException(status_code=400, detail="Código duplicado o datos inválidos")


@app.put("/productos/{id}", response_model=schemas.ProductoResponse)
def actualizar_producto(id: int, producto: schemas.ProductoUpdate, db: Session = Depends(get_db)):
    producto_db = db.query(models.Producto).filter(models.Producto.id == id).first()

    if not producto_db:
        raise HTTPException(status_code=404, detail="Producto no encontrado")

    datos = producto.model_dump(exclude_unset=True)

    if "precio_venta" in datos and "costo" in datos:
        if datos["precio_venta"] < datos["costo"]:
            raise HTTPException(status_code=400, detail="El precio de venta no puede ser menor al costo")
    elif "precio_venta" in datos:
        if datos["precio_venta"] < float(producto_db.costo):
            raise HTTPException(status_code=400, detail="El precio de venta no puede ser menor al costo")
    elif "costo" in datos:
        if float(producto_db.precio_venta) < datos["costo"]:
            raise HTTPException(status_code=400, detail="El precio de venta no puede ser menor al costo")

    for campo, valor in datos.items():
        setattr(producto_db, campo, valor)

    try:
        db.commit()
        db.refresh(producto_db)
        return producto_db
    except IntegrityError:
        db.rollback()
        raise HTTPException(status_code=400, detail="Error al actualizar el producto")


@app.delete("/productos/{id}")
def eliminar_producto(id: int, db: Session = Depends(get_db)):
    producto_db = db.query(models.Producto).filter(models.Producto.id == id).first()

    if not producto_db:
        raise HTTPException(status_code=404, detail="Producto no encontrado")

    db.delete(producto_db)
    db.commit()

    return {"mensaje": "Producto eliminado correctamente"}


@app.put("/productos/descontar/{id}")
def descontar_stock(id: int, body: schemas.DescontarStockRequest, db: Session = Depends(get_db)):
    producto_db = db.query(models.Producto).filter(models.Producto.id == id).first()

    if not producto_db:
        raise HTTPException(status_code=404, detail="Producto no encontrado")

    if body.cantidad <= 0:
        raise HTTPException(status_code=400, detail="La cantidad debe ser mayor a 0")

    if producto_db.stock < body.cantidad:
        raise HTTPException(status_code=400, detail="Stock insuficiente")

    producto_db.stock -= body.cantidad
    db.commit()
    db.refresh(producto_db)

    return {
        "mensaje": "Stock actualizado correctamente",
        "id_producto": producto_db.id,
        "stock_actual": producto_db.stock
    }
