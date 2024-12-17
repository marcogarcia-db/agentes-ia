-- Databricks notebook source
-- MAGIC %md
-- MAGIC <img src="https://github.com/mousastech/iafunciones/blob/fd139cf6a61d68b2858b91907d3885cce238cf5d/img/headertools_aifunctions.png?raw=true" width=100%>
-- MAGIC
-- MAGIC Ejecutar solo en el momento de la creación para generar un catálogo de pruebas y tablas utilizadas en este laboratorio.

-- COMMAND ----------

-- DBTITLE 1,Crear la estructura central
CREATE CATALOG IF NOT EXISTS funcionesai;

CREATE SCHEMA IF NOT EXISTS `funcionesai`.`carga`;

CREATE VOLUME IF NOT EXISTS `funcionesai`.`carga`.`archivos`; 

-- COMMAND ----------

-- DBTITLE 1,Cargar tabla Productos
-- MAGIC %python
-- MAGIC catalog = "funcionesai"
-- MAGIC schema = "carga"
-- MAGIC volume = "archivos"
-- MAGIC
-- MAGIC download_url = "https://raw.githubusercontent.com/mousastech/iafunciones/refs/heads/main/data/productos.csv"
-- MAGIC file_name = "productos.csv"
-- MAGIC table_name = "productos"
-- MAGIC path_volume = "/Volumes/" + catalog + "/" + schema + "/" + volume
-- MAGIC path_table = catalog + "." + schema
-- MAGIC print(path_table) # Show the complete path
-- MAGIC print(path_volume) # Show the complete path
-- MAGIC
-- MAGIC dbutils.fs.cp(f"{download_url}", f"{path_volume}" + "/" + f"{file_name}")
-- MAGIC
-- MAGIC df = spark.read.csv(f"{path_volume}/{file_name}",
-- MAGIC   header=True,
-- MAGIC   inferSchema=True,
-- MAGIC   sep=",",
-- MAGIC   encoding="UTF-8")
-- MAGIC
-- MAGIC df.write.mode("overwrite").saveAsTable(f"{path_table}.{table_name}")

-- COMMAND ----------

-- DBTITLE 1,Cargar tabla faq
-- MAGIC %python
-- MAGIC catalog = "funcionesai"
-- MAGIC schema = "carga"
-- MAGIC volume = "archivos"
-- MAGIC
-- MAGIC download_url = "https://raw.githubusercontent.com/mousastech/iafunciones/refs/heads/main/data/faq.csv"
-- MAGIC file_name = "faq.csv"
-- MAGIC table_name = "faq"
-- MAGIC path_volume = "/Volumes/" + catalog + "/" + schema + "/" + volume
-- MAGIC path_table = catalog + "." + schema
-- MAGIC print(path_table) # Show the complete path
-- MAGIC print(path_volume) # Show the complete path
-- MAGIC
-- MAGIC dbutils.fs.cp(f"{download_url}", f"{path_volume}" + "/" + f"{file_name}")
-- MAGIC
-- MAGIC df = spark.read.csv(f"{path_volume}/{file_name}",
-- MAGIC   header=True,
-- MAGIC   inferSchema=True,
-- MAGIC   sep=",",
-- MAGIC   encoding="UTF-8")
-- MAGIC
-- MAGIC # Rename columns to remove invalid characters
-- MAGIC for col in df.columns:
-- MAGIC     new_col = col.replace(" ", "_").replace(";", "_").replace("{", "_").replace("}", "_") \
-- MAGIC                  .replace("(", "_").replace(")", "_").replace("\n", "_").replace("\t", "_") \
-- MAGIC                  .replace("=", "_")
-- MAGIC     df = df.withColumnRenamed(col, new_col)
-- MAGIC
-- MAGIC # Save the table
-- MAGIC df.write.mode("overwrite").saveAsTable(f"{path_table}.{table_name}")

-- COMMAND ----------

-- DBTITLE 1,Cargar tabla Opiniones
-- MAGIC %python
-- MAGIC catalog = "funcionesai"
-- MAGIC schema = "carga"
-- MAGIC volume = "archivos"
-- MAGIC
-- MAGIC download_url = "https://raw.githubusercontent.com/mousastech/iafunciones/refs/heads/main/data/opiniones.csv"
-- MAGIC file_name = "opiniones.csv"
-- MAGIC table_name = "opiniones"
-- MAGIC path_volume = "/Volumes/" + catalog + "/" + schema + "/" + volume
-- MAGIC path_table = catalog + "." + schema
-- MAGIC print(path_table) # Show the complete path
-- MAGIC print(path_volume) # Show the complete path
-- MAGIC
-- MAGIC dbutils.fs.cp(f"{download_url}", f"{path_volume}" + "/" + f"{file_name}")
-- MAGIC
-- MAGIC df = spark.read.csv(f"{path_volume}/{file_name}",
-- MAGIC   header=True,
-- MAGIC   inferSchema=True,
-- MAGIC   sep=",",
-- MAGIC   encoding="UTF-8")
-- MAGIC
-- MAGIC df.write.mode("overwrite").saveAsTable(f"{path_table}.{table_name}")
-- MAGIC
-- MAGIC display(df)

-- COMMAND ----------

-- DBTITLE 1,Cargar tabla Clientes
-- MAGIC %python
-- MAGIC catalog = "funcionesai"
-- MAGIC schema = "carga"
-- MAGIC volume = "archivos"
-- MAGIC
-- MAGIC download_url = "https://raw.githubusercontent.com/mousastech/iafunciones/refs/heads/main/data/clientes.csv"
-- MAGIC file_name = "clientes.csv"
-- MAGIC table_name = "clientes"
-- MAGIC path_volume = "/Volumes/" + catalog + "/" + schema + "/" + volume
-- MAGIC path_table = catalog + "." + schema
-- MAGIC print(path_table) # Show the complete path
-- MAGIC print(path_volume) # Show the complete path
-- MAGIC
-- MAGIC dbutils.fs.cp(f"{download_url}", f"{path_volume}" + "/" + f"{file_name}")
-- MAGIC
-- MAGIC df = spark.read.csv(f"{path_volume}/{file_name}",
-- MAGIC   header=True,
-- MAGIC   inferSchema=True,
-- MAGIC   sep=",",
-- MAGIC   encoding="UTF-8")
-- MAGIC
-- MAGIC df.write.mode("overwrite").saveAsTable(f"{path_table}.{table_name}")
-- MAGIC
-- MAGIC display(df)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC #Solamente correr en caso de reprocesamiento

-- COMMAND ----------

-- DBTITLE 1,Limpieza por tema de reprocesamiento
-- MAGIC %python
-- MAGIC productos = "https://github.com/mousastech/iafunciones/blob/main/data/productos.csv"
-- MAGIC faq = "https://raw.githubusercontent.com/mousastech/iafunciones/refs/heads/main/data/faq.csv"
-- MAGIC opiniones = "https://github.com/mousastech/iafunciones/blob/main/data/opiniones.csv"
-- MAGIC clientes = "https://raw.githubusercontent.com/mousastech/iafunciones/refs/heads/main/data/clientes.csv"
-- MAGIC
-- MAGIC catalog = "funcionesai"
-- MAGIC schema = "carga"
-- MAGIC volume = "archivos"
-- MAGIC
-- MAGIC path_table = f"{catalog}.{schema}"
-- MAGIC
-- MAGIC table_names = ["productos", "faq", "opiniones", "clientes"]
-- MAGIC
-- MAGIC for table_name in table_names:
-- MAGIC     query = f"DROP TABLE IF EXISTS {path_table}.{table_name}"
-- MAGIC     spark.sql(query)
-- MAGIC
-- MAGIC # List all files in the volume
-- MAGIC files = dbutils.fs.ls(path_volume)
-- MAGIC
-- MAGIC # Delete each file
-- MAGIC for file in files:
-- MAGIC     dbutils.fs.rm(file.path)
-- MAGIC
-- MAGIC print(f"All files in {path_volume} have been deleted.")

-- COMMAND ----------

-- DBTITLE 1,Solo en caso de reprocesamiento
-- MAGIC %python
-- MAGIC from pyspark.sql.functions import input_file_name
-- MAGIC import os
-- MAGIC
-- MAGIC # Define the volume path and target catalog and schema
-- MAGIC volume_path = "/Volumes/funcionesai/carga/archivos/avaliacoes.csv"
-- MAGIC catalog = "tutorial"
-- MAGIC schema = "carga"
-- MAGIC
-- MAGIC # List all files in the volume
-- MAGIC files = dbutils.fs.ls(volume_path)
-- MAGIC
-- MAGIC # Filter out directories and get only file paths
-- MAGIC file_paths = [file.path for file in files if not file.isDir()]
-- MAGIC
-- MAGIC # Read each file and create a Delta table
-- MAGIC for file_path in file_paths:
-- MAGIC     # Extract the file name without extension to use as table name
-- MAGIC     table_name = os.path.splitext(os.path.basename(file_path))[0]
-- MAGIC     
-- MAGIC     # Read the file into a DataFrame
-- MAGIC     df = spark.read.format("csv").option("header", "true").load(file_path)
-- MAGIC     
-- MAGIC     # Write the DataFrame to a Delta table in the specified catalog and schema
-- MAGIC     df.write.format("delta").mode("overwrite").saveAsTable(f"{catalog}.{schema}.{table_name}")
-- MAGIC
-- MAGIC     print(f"Table {catalog}.{schema}.{table_name} created successfully.")
