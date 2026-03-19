# Fabric notebook source

# METADATA ********************

# META {
# META   "kernel_info": {
# META     "name": "synapse_pyspark"
# META   },
# META   "dependencies": {
# META     "lakehouse": {
# META       "default_lakehouse": "6d4069c9-930d-4eb8-ae10-e7140f2890d0",
# META       "default_lakehouse_name": "CatManagement",
# META       "default_lakehouse_workspace_id": "5bb3a27e-bc84-41d2-bf55-296bb6efc7a4",
# META       "known_lakehouses": [
# META         {
# META           "id": "6d4069c9-930d-4eb8-ae10-e7140f2890d0"
# META         }
# META       ]
# META     }
# META   }
# META }

# CELL ********************

# ================================
# CONFIG: Parámetros del dataset
# ================================
import numpy as np
import pandas as pd
from pyspark.sql import SparkSession
from pyspark.sql.types import (StructType, StructField, StringType, IntegerType, DoubleType, DateType)
from pyspark.sql import functions as F

spark = SparkSession.builder.getOrCreate()

# Tiendas en Monterrey (12)
STORES = [
    "Astros", "Camino Real", "Concordia", "Contry",
    "Cumbres", "El Molinete", "Escobedo", "Fresnos",
    "García", "Las Margaritas", "Lincoln", "Pablo Livas"
]

CATEGORIES = ["Abarrotes", "Lácteos", "Carnes", "Frutas", "Verduras", "Bebidas", "Limpieza"]
PRODUCTS = {cat: [f"{cat}_prod_{i}" for i in range(30)] for cat in CATEGORIES}

np.random.seed(42)

# Rango de fechas (año pasado 2025)
DATE_START = "2025-01-01"
DATE_END   = "2025-12-31"

# Tabla destino (Lakehouse por defecto)
TARGET_TABLE = "fact_transactions"  # se creará como tabla Managed en /lakehouse/default/Tables
WRITE_MODE   = "overwrite"          # usa "append" si vas a re-ejecutar para sumar datos

# ================================
# FUNCIÓN: genera un pandas.DataFrame para una tienda
# ================================
def generate_store_df(store_name: str, n_min=80000, n_max=100000) -> pd.DataFrame:
    n = np.random.randint(n_min, n_max + 1)

    # fecha aleatoria dentro de 2025
    dates = pd.date_range(DATE_START, DATE_END)
    fecha = np.random.choice(dates, size=n, replace=True)

    categoria = np.random.choice(CATEGORIES, size=n)
    producto = [np.random.choice(PRODUCTS[c]) for c in categoria]

    precio = np.round(np.random.uniform(10, 500, size=n), 2)
    cantidad = np.random.randint(1, 6, size=n)

    descuento_flag = np.random.choice([0, 1], size=n, p=[0.7, 0.3])
    porcentaje_descuento = np.zeros(n, dtype=int)
    mask = descuento_flag == 1
    porcentaje_descuento[mask] = np.random.randint(5, 50, size=mask.sum())

    tamano_tienda = np.random.choice(["Pequeña", "Mediana", "Grande"], size=n, p=[0.3, 0.5, 0.2])
    perfil_cliente = np.random.choice(["Familiar", "Joven", "Adulto mayor"], size=n, p=[0.55, 0.35, 0.10])

    df = pd.DataFrame({
        "fecha": fecha,
        "tienda": store_name,
        "tamano_tienda": tamano_tienda,
        "perfil_cliente": perfil_cliente,
        "categoria": categoria,
        "producto": producto,
        "precio": precio,
        "cantidad": cantidad,
        "descuento_flag": descuento_flag.astype(int),
        "porcentaje_descuento": porcentaje_descuento.astype(int),
    })

    # Orden de columnas y tipos
    df = df[[
        "fecha", "tienda", "tamano_tienda", "perfil_cliente",
        "categoria", "producto", "precio", "cantidad",
        "descuento_flag", "porcentaje_descuento"
    ]]

    return df

# ================================
# ESQUEMA (para Spark) y utilidades
# ================================
schema = StructType([
    StructField("fecha", DateType(), False),
    StructField("tienda", StringType(), False),
    StructField("tamano_tienda", StringType(), False),
    StructField("perfil_cliente", StringType(), False),
    StructField("categoria", StringType(), False),
    StructField("producto", StringType(), False),
    StructField("precio", DoubleType(), False),
    StructField("cantidad", IntegerType(), False),
    StructField("descuento_flag", IntegerType(), False),
    StructField("porcentaje_descuento", IntegerType(), False),
])

# ================================
# GENERACIÓN Y ESCRITURA EN DELTA (OneLake)
# ================================
# Si vas a re-ejecutar a menudo, conviene limpiar la tabla antes con overwrite
first = True

for store in STORES:
    pdf = generate_store_df(store)
    sdf = spark.createDataFrame(pdf, schema=schema)

    # Escribimos particionando por tienda (optimiza queries y refrescos en PBI)
    (
        sdf
        .write
        .format("delta")
        .mode("overwrite" if first and WRITE_MODE == "overwrite" else "append")
        .partitionBy("tienda")
        .saveAsTable(TARGET_TABLE)
    )
    first = False

# OPTIMIZACIONES: columnas derivadas útiles para BI
# (Ajusta si quieres almacenar totales o año/mes/día)
spark.sql(f"""
    ALTER TABLE {TARGET_TABLE} SET TBLPROPERTIES (
        delta.autoOptimize.optimizeWrite = true,
        delta.autoOptimize.autoCompact = true
    )
""")

# Columnas de fechas (parquet-friendly) como enteros o strings si las necesitas
spark.sql(f"""
    CREATE OR REPLACE TEMP VIEW __tmp AS
    SELECT
        fecha,
        tienda,
        tamano_tienda,
        perfil_cliente,
        categoria,
        producto,
        precio,
        cantidad,
        descuento_flag,
        porcentaje_descuento,
        YEAR(fecha)  AS anio,
        MONTH(fecha) AS mes,
        DAY(fecha)   AS dia
    FROM {TARGET_TABLE}
""")

# Sobrescribe con columnas Y/M/D si las quieres persistir:
spark.sql(f"DROP TABLE IF EXISTS {TARGET_TABLE}_with_calendar")
spark.table("__tmp").write.format("delta").mode("overwrite").partitionBy("tienda").saveAsTable(f"{TARGET_TABLE}_with_calendar")

print("✅ Datos generados en OneLake como tablas Delta: fact_transactions y fact_transactions_with_calendar")


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
