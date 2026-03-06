from fastapi import FastAPI, HTTPException
from schemas import Producto
from database import engine
import models
models.Base.metadata.create_all(bind=engine)
app = FastAPI(title="Microservicio de Productos")

productos = []

# -------------------------
# LISTAR PRODUCTOS
# -------------------------
@app.get("/productos")
def listar_productos():
    return productos


# -------------------------
# OBTENER PRODUCTO POR ID
# -------------------------
@app.get("/productos/{id}")
def obtener_producto(id: int):
    if id >= len(productos):
        raise HTTPException(status_code=404, detail="Producto no encontrado")
    
    return productos[id]


# -------------------------
# CREAR PRODUCTO
# -------------------------
@app.post("/productos")
def crear_producto(producto: Producto):
    productos.append(producto)
    return {
        "mensaje": "Producto creado",
        "producto": producto
    }


# -------------------------
# MODIFICAR PRODUCTO
# -------------------------
@app.put("/productos/{id}")
def actualizar_producto(id: int, producto: Producto):
    if id >= len(productos):
        raise HTTPException(status_code=404, detail="Producto no encontrado")

    productos[id] = producto
    return {
        "mensaje": "Producto actualizado",
        "producto": producto
    }


# -------------------------
# ELIMINAR PRODUCTO
# -------------------------
@app.delete("/productos/{id}")
def eliminar_producto(id: int):
    if id >= len(productos):
        raise HTTPException(status_code=404, detail="Producto no encontrado")

    producto = productos.pop(id)

    return {
        "mensaje": "Producto eliminado",
        "producto": producto
    }


# -------------------------
# DESCONTAR STOCK
# -------------------------
@app.put("/productos/descontar/{id}")
def descontar_stock(id: int, cantidad: int):
    if id >= len(productos):
        raise HTTPException(status_code=404, detail="Producto no encontrado")

    if productos[id].stock < cantidad:
        raise HTTPException(status_code=400, detail="Stock insuficiente")

    productos[id].stock -= cantidad

    return {
        "mensaje": "Stock actualizado",
        "stock": productos[id].stock
    }