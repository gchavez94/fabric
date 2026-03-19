# Fabric notebook source

# METADATA ********************

# META {
# META   "kernel_info": {
# META     "name": "synapse_pyspark"
# META   },
# META   "dependencies": {}
# META }

# CELL ********************

import sempy.fabric as sf
from sempy.relationships import (
    find_relationships,
    list_relationship_violations,
    plot_relationship_metadata
)

# Reemplaza con el nombre de tu espacio de trabajo y modelo
workspace_name = "Control de Horas D4B"
model_name = "Control de Horas D4B"

try:
    #relationships = sf.list_relationships(model_name)    
    
   #tables = sf.list_tables(workspace = workspace_name,dataset = model_name)
   #display(tables)

   sf.list_relationships(workspace = workspace_name,dataset = model_name)

    # Imprimir información sobre las relaciones
    #for relationship in relationships:
     #   display(relationship)
    

        #print(f"Relación de: {relationship.from_table_name}.{relationship.from_column_name}")
        #print(f"A: {relationship.to_table_name}.{relationship.to_column_name}")
        #print(f"Cardinalidad: {relationship.cardinality}")
        #print(f"Activa: {relationship.is_active}")
        #print("-" * 20)

except Exception as e:
    print(f"Error al obtener las relaciones: {e}")


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
