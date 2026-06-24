# Fabric notebook source

# METADATA ********************

# META {
# META   "kernel_info": {
# META     "name": "synapse_pyspark"
# META   },
# META   "dependencies": {
# META     "lakehouse": {
# META       "default_lakehouse": "ce17a71f-0934-47e9-bb9e-376d80ac898d",
# META       "default_lakehouse_name": "dataverse_cdsgcg_cds2_workspace_29f750ecf23a477bb1c523dc50d41058",
# META       "default_lakehouse_workspace_id": "5bb3a27e-bc84-41d2-bf55-296bb6efc7a4",
# META       "known_lakehouses": [
# META         {
# META           "id": "ce17a71f-0934-47e9-bb9e-376d80ac898d"
# META         }
# META       ]
# META     }
# META   }
# META }

# CELL ********************

# Welcome to your new notebook
# Type here in the cell editor to add code!

df = spark.sql("SELECT * FROM dataverse_cdsgcg_cds2_workspace_29f750ecf23a477bb1c523dc50d41058.S_DIM_CLIENTE LIMIT 1000")
display(df)

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************


from pyspark.sql import SparkSession
from pyspark.sql.types import StructType, StructField, StringType, TimestampType
from datetime import datetime

# Crear sesión Spark
spark = SparkSession.builder.getOrCreate()

# Definir el esquema
schema = StructType([
    StructField("SK_CLIENTE", StringType(), True),
    StructField("CVE_CLIENTE", StringType(), True),
    StructField("DSC_NOMBRE", StringType(), True),
    StructField("CVE_COMPANIA", StringType(), True),
    StructField("CVE_MERCADO", StringType(), True),
    StructField("DSC_MERCADO", StringType(), True),
    StructField("CVE_NEGOCIO", StringType(), True),
    StructField("DSC_NEGOCIO", StringType(), True),
    StructField("SK_VENDEDOR", StringType(), True),
    StructField("Cve_Zona_de_ventas", StringType(), True),
    StructField("Dsc_Zona_de_ventas", StringType(), True),
    StructField("Cve_Subzona_de_ventas", StringType(), True),
    StructField("Dsc_Subzona_de_ventas", StringType(), True),
    StructField("Dsc_Segmento_PlanLealtad", StringType(), True),
    StructField("Dsc_Reconfiguracion_Acuerdos_Comerciales", StringType(), True),
    StructField("Dsc_CadenaCompania", StringType(), True),
    StructField("Dsc_Agrupador_Clientes", StringType(), True),
    StructField("Cve_Calidra_PlanLealtad", StringType(), True),
    StructField("Cve_Linea_Negocio", StringType(), True),
    StructField("Cve_Grupo", StringType(), True),
    StructField("INSERT_SVR", TimestampType(), True),
    StructField("UPDATE_SVR", TimestampType(), True)
])

# Crear datos de ejemplo
data = [
    ("001", "C001", "Cliente X", "CompA", "Mercado1", "Mercado Uno", "Negocio1", "Negocio Uno", "V001", "Z001", "Zona Uno", "SZ001", "Subzona Uno", "Segmento A", "Acuerdo A", "Cadena A", "Agrupador A", "PL001", "LN001", "G001", datetime.now(), datetime.now()),
    ("002", "C002", "Cliente Y", "CompB", "Mercado2", "Mercado Dos", "Negocio2", "Negocio Dos", "V002", "Z002", "Zona Dos", "SZ002", "Subzona Dos", "Segmento B", "Acuerdo B", "Cadena B", "Agrupador B", "PL002", "LN002", "G002", datetime.now(), datetime.now())
]

# Crear DataFrame
df = spark.createDataFrame(data, schema=schema)

# Escribir en la tabla Delta
df.write \
  .option("mergeSchema", "true") \
  .mode("append") \
  .format("delta") \
  .saveAsTable("dataverse_cdsgcg_cds2_workspace_29f750ecf23a477bb1c523dc50d41058.S_DIM_CLIENTE")


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************



df = spark.read.synapsesql("DWH_PRUEBAD4B.dbo.DIM_CLIENTE")
df.display()



# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************


%%tsql
SELECT * FROM DWH_PRUEBAD4B.dbo.DIM_CLIENTE



# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
