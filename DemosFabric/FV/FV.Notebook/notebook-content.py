# Fabric notebook source

# METADATA ********************

# META {
# META   "kernel_info": {
# META     "name": "synapse_pyspark"
# META   },
# META   "dependencies": {
# META     "lakehouse": {
# META       "default_lakehouse": "a601b361-0cbe-4aa0-9038-3fb09a3002f9",
# META       "default_lakehouse_name": "data",
# META       "default_lakehouse_workspace_id": "5bb3a27e-bc84-41d2-bf55-296bb6efc7a4",
# META       "known_lakehouses": [
# META         {
# META           "id": "a601b361-0cbe-4aa0-9038-3fb09a3002f9"
# META         }
# META       ]
# META     }
# META   }
# META }

# CELL ********************

# Welcome to your new notebook
# Type here in the cell editor to add code!


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

df = spark.sql("SELECT * FROM data.dbo.carros_activos LIMIT 1000")
display(df)

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

# Código generado por Data Wrangler para PySpark DataFrame

from pyspark.sql import functions as F

def clean_data(df):
    # Reemplazar todas las instancias de "CEMEX MEXICO S.A. DE C.V." con "CEMEX" en la columna: 'Entidad_emisora'
    df = df.withColumn('Entidad_emisora', F.regexp_replace('Entidad_emisora', "(?i)CEMEX MEXICO S.A. DE C.V.", "CEMEX"))
    return df

df_clean = clean_data(df)
display(df_clean)

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
