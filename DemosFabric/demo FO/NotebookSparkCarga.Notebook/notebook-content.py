# Fabric notebook source

# METADATA ********************

# META {
# META   "kernel_info": {
# META     "name": "synapse_pyspark"
# META   },
# META   "dependencies": {
# META     "lakehouse": {
# META       "default_lakehouse": "51517173-c1c3-47d2-ba41-c7085ce821d4",
# META       "default_lakehouse_name": "lake_fo",
# META       "default_lakehouse_workspace_id": "5bb3a27e-bc84-41d2-bf55-296bb6efc7a4",
# META       "known_lakehouses": [
# META         {
# META           "id": "51517173-c1c3-47d2-ba41-c7085ce821d4"
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

df = spark.sql("SELECT * FROM lake_fo.custinvoicetable LIMIT 1000")
display(df)
# comentario v2

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
