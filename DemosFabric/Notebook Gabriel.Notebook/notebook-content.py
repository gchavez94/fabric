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

# Import necessary libraries

import pandas as pd



# URL of the CSV File v2.0

orders_url = "https://raw.githubusercontent.com/microsoft/PowerApps-Samples/master/ai-builder/order.csv"



# Use pandas to load the CSV file

orders_pd = pd.read_csv(orders_url)



orders_pd.head()

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

contacts_pd = spark.sql("SELECT fullname,contactid,parentcustomerid FROM dataverse_cdsgcg_cds2_workspace_29f750ecf23a477bb1c523dc50d41058.contact LIMIT 1000").toPandas()
contacts_pd.head()
 
# Import necessary libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
 
orders_with_contacts_pd = orders_pd
 
# Generate random indices
random_indices = np.random.choice(contacts_pd.index, size=len(orders_with_contacts_pd))
 
orders_with_contacts_pd['contactid'] = contacts_pd.loc[random_indices, 'contactid'].values
 
count = orders_with_contacts_pd.groupby('contactid').size()
 
# Plot the count as a bar chart
count.plot(kind='bar')
 
# Show the plot
plt.show()
 

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

import pandas as pd
import matplotlib.pyplot as plt
 
# Convert 'order_purchase_timestamp' to datetime
orders_with_contacts_pd['order_purchase_timestamp'] = pd.to_datetime(orders_with_contacts_pd['order_purchase_timestamp'])
 
# Aggregate the price by 'contactid' and 'order_purchase_timestamp'
orders_with_contacts_pd_agg_pd = orders_with_contacts_pd.groupby(['contactid', orders_with_contacts_pd['order_purchase_timestamp'].dt.date])['price'].sum().reset_index()
 
# Pivot the DataFrame to get 'contactid' as columns
orders_with_contacts_pd_agg_pivot = orders_with_contacts_pd_agg_pd.pivot(index='order_purchase_timestamp', columns='contactid', values='price')
 
# Select a specific 'contactid'
specific_contactid = orders_with_contacts_pd_agg_pivot[contacts_pd.loc[contacts_pd['fullname'] == 'Karl McKee', 'contactid']]  # replace 'contactid' with the actual contactid
 
# Plot the DataFrame for the specific 'contactid'
specific_contactid.plot(kind='line')
 
# Show the plot
plt.show()

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

from pyspark.sql.functions import rand
 
# Write the DataFrame to a Delta Lake table, using the specified name and path
orders_with_contacts_agg = spark.createDataFrame(orders_with_contacts_pd_agg_pd)
orders_with_contacts_agg.createOrReplaceTempView("orders_with_contacts_agg_view")
contacts = spark.createDataFrame(contacts_pd)
contacts.createOrReplaceTempView("contacts_view")
# add key and unique id for bring it back to Dataverse
orders_with_contacts_agg_with_unique_int = spark.sql("""
    SELECT orders.*,
    concat(contacts.fullname, '_', orders.order_purchase_timestamp, '_', orders.price) as Key,
    monotonically_increasing_id() as UniqueInt
    FROM orders_with_contacts_agg_view as orders
    JOIN contacts_view as contacts
    ON orders.contactid == contacts.contactid
""")
 
orders_with_contacts_agg_with_unique_int.write.format('delta').mode('overwrite').option("overwriteSchema", "true").saveAsTable('orders_with_contacts_agg')

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

# Import Shopper intentions from the internet in CSV format.
 
# Import necessary libraries
import pandas as pd
 
# URL of the CSV file
shopper_intentions_url = "https://raw.githubusercontent.com/microsoft/PowerApps-Samples/master/ai-builder/aib_onlineshopperintention.csv"
 
# Use pandas to load the CSV file
shopper_intentions_pd = pd.read_csv(shopper_intentions_url)
 
# Display the first few rows of the DataFrame
shopper_intentions_pd.head()

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

# Establish associations between Shopper intentions and contacts.
 
# Import necessary libraries
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
 
shopper_intentions_with_contacts_pd = shopper_intentions_pd.copy()
 
# Generate random indices
random_indices = np.random.choice(contacts_pd.index, size=len(shopper_intentions_with_contacts_pd))
 
shopper_intentions_with_contacts_pd['contactid'] = contacts_pd.loc[random_indices, 'contactid'].values
count = shopper_intentions_with_contacts_pd.groupby('contactid').size()
# Plot the count as a bar chart
count.plot(kind='bar')
 
# Show the plot
plt.show()

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
 
# convert revenue to bool
data = shopper_intentions_with_contacts_pd[shopper_intentions_with_contacts_pd['aib_Revenue'].notnull()].copy()
data['aib_Revenue'] = data['aib_Revenue'].astype(bool)
 
# Historical data
historical_data_pd = data.select_dtypes(include=[np.number,'bool'])
 
# Define the feature matrix X and the target y
X = historical_data_pd.drop('aib_Revenue', axis=1)
y = historical_data_pd['aib_Revenue']
 
# Split the data into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
 
# Create a Random Forest Regressor
model = RandomForestClassifier(n_estimators=100, random_state=42)
model.fit(X_train, y_train)
 
# Make predictions on the test set
y_pred = model.predict(X_test)

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

import pandas as pd
# Load data into pandas DataFrame from "/lakehouse/default/Files/datos_final.csv"
df = pd.read_csv("/lakehouse/default/Files/datos_final.csv")
display(df)


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

# Código generado por Data Wrangler para pandas DataFrame

def clean_data(df):
    # Reemplazar los valores que faltan con 0en la columna: 'PAM2'
    df = df.fillna({'PAM2': 0})
    # Filter rows where SUM is greater than 1200
    df = df[df['SUM'] > 1200]
    return df

df_clean = clean_data(df.copy())
display(df_clean)

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
