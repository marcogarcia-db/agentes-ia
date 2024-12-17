-- Databricks notebook source
-- MAGIC %md
-- MAGIC <img src="https://github.com/mousastech/iafunciones/blob/fd139cf6a61d68b2858b91907d3885cce238cf5d/img/headertools_aifunctions.png?raw=true" width=100%>
-- MAGIC
-- MAGIC Executar apenas no momento da criacao para gerar um catalogo de testes e tabelas utilizadas neste laboratorio.

-- COMMAND ----------

-- DBTITLE 1,Criar a estrutura central
CREATE CATALOG IF NOT EXISTS funcoes_ia;

CREATE SCHEMA IF NOT EXISTS `funcoes_ia`.`carga`;

CREATE VOLUME IF NOT EXISTS `funcoes_ia`.`carga`.`arquivos`; 

-- COMMAND ----------

-- DBTITLE 1,Carregar tabela Produtos
-- MAGIC %python
-- MAGIC catalog = "funcoes_ia"
-- MAGIC schema = "carga"
-- MAGIC volume = "arquivos"
-- MAGIC
-- MAGIC download_url = "https://github.com/marcogarcia-db/agentes-ia/tree/main/dados/produtos.csv"
-- MAGIC file_name = "produtos.csv"
-- MAGIC table_name = "produtos"
-- MAGIC path_volume = "/Volumes/" + catalog + "/" + schema + "/" + volume
-- MAGIC path_table = catalog + "." + schema
-- MAGIC print(path_table) # Mostrar o caminho completo
-- MAGIC print(path_volume) # Mostrar o caminho completo
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

-- DBTITLE 1,Carregar tabela faq
-- MAGIC %python
-- MAGIC catalog = "funcoes_ia"
-- MAGIC schema = "carga"
-- MAGIC volume = "arquivos"
-- MAGIC
-- MAGIC download_url = "https://github.com/marcogarcia-db/agentes-ia/tree/main/dadosfaq.csv"
-- MAGIC file_name = "faq.csv"
-- MAGIC table_name = "faq"
-- MAGIC path_volume = "/Volumes/" + catalog + "/" + schema + "/" + volume
-- MAGIC path_table = catalog + "." + schema
-- MAGIC print(path_table) # Mostrar o caminho completo
-- MAGIC print(path_volume) # Mostrar o caminho completo
-- MAGIC
-- MAGIC dbutils.fs.cp(f"{download_url}", f"{path_volume}" + "/" + f"{file_name}")
-- MAGIC
-- MAGIC df = spark.read.csv(f"{path_volume}/{file_name}",
-- MAGIC   header=True,
-- MAGIC   inferSchema=True,
-- MAGIC   sep=",",
-- MAGIC   encoding="UTF-8")
-- MAGIC
-- MAGIC # Renomear colunas para remover caracteres invalidos
-- MAGIC for col in df.columns:
-- MAGIC     new_col = col.replace(" ", "_").replace(";", "_").replace("{", "_").replace("}", "_") \
-- MAGIC                  .replace("(", "_").replace(")", "_").replace("\n", "_").replace("\t", "_") \
-- MAGIC                  .replace("=", "_")
-- MAGIC     df = df.withColumnRenamed(col, new_col)
-- MAGIC
-- MAGIC # Salvar a tabela
-- MAGIC df.write.mode("overwrite").saveAsTable(f"{path_table}.{table_name}")

-- COMMAND ----------

-- DBTITLE 1,Carregar tabela Opinioes
-- MAGIC %python
-- MAGIC catalog = "funcoes_ia"
-- MAGIC schema = "carga"
-- MAGIC volume = "arquivos"
-- MAGIC
-- MAGIC download_url = "https://github.com/marcogarcia-db/agentes-ia/tree/main/dados/opinioes.csv"
-- MAGIC file_name = "opinioes.csv"
-- MAGIC table_name = "opinioes"
-- MAGIC path_volume = "/Volumes/" + catalog + "/" + schema + "/" + volume
-- MAGIC path_table = catalog + "." + schema
-- MAGIC print(path_table) # Mostrar o caminho completo
-- MAGIC print(path_volume) # Mostrar o caminho completo
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

-- DBTITLE 1,Carregar tabela Clientes
-- MAGIC %python
-- MAGIC catalog = "funcoes_ia"
-- MAGIC schema = "carga"
-- MAGIC volume = "arquivos"
-- MAGIC
MAGIC download_url = "https://raw.githubusercontent.com/mousastech/iafunciones/refs/heads/main/data/clientes.csv"
-- MAGIC file_name = "clientes.csv"
-- MAGIC table_name = "clientes"
-- MAGIC path_volume = "/Volumes/" + catalog + "/" + schema + "/" + volume
-- MAGIC path_table = catalog + "." + schema
-- MAGIC print(path_table) # Mostrar o caminho completo
-- MAGIC print(path_volume) # Mostrar o caminho completo
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
-- MAGIC #Executar apenas em caso de reprocessamento

-- COMMAND ----------

-- DBTITLE 1,Limpeza por tema de reprocessamento
-- MAGIC %python
-- MAGIC produtos = "https://github.com/marcogarcia-db/agentes-ia/tree/main/dados/produtos.csv"
-- MAGIC faq = "https://github.com/marcogarcia-db/agentes-ia/tree/main/dados/faq.csv"
-- MAGIC opinioes = "https://github.com/marcogarcia-db/agentes-ia/tree/main/dados/opinioes.csv"
-- MAGIC clientes = "https://github.com/marcogarcia-db/agentes-ia/tree/main/dados/clientes.csv"
-- MAGIC
-- MAGIC catalog = "funcoes_ia"
-- MAGIC schema = "carga"
-- MAGIC volume = "arquivos"
-- MAGIC
-- MAGIC path_table = f"{catalog}.{schema}"
-- MAGIC
-- MAGIC table_names = ["produtos", "faq", "opinioes", "clientes"]
-- MAGIC
-- MAGIC for table_name in table_names:
-- MAGIC     query = f"DROP TABLE IF EXISTS {path_table}.{table_name}"
-- MAGIC     spark.sql(query)
-- MAGIC
-- MAGIC # Listar todos os arquivos no volume
-- MAGIC files = dbutils.fs.ls(path_volume)
-- MAGIC
-- MAGIC # Excluir cada arquivo
-- MAGIC for file in files:
-- MAGIC     dbutils.fs.rm(file.path)
-- MAGIC
-- MAGIC print(f"Todos os arquivos em {path_volume} foram excluidos.")

-- COMMAND ----------

-- DBTITLE 1,Apenas em caso de reprocessamento
-- MAGIC %python
-- MAGIC from pyspark.sql.functions import input_file_name
-- MAGIC import os
-- MAGIC
-- MAGIC # Definir o caminho do volume e o catalogo e esquema de destino
-- MAGIC volume_path = "/Volumes/funcoes_ia/carga/arquivos/avaliacoes.csv"
-- MAGIC catalog = "tutorial"
-- MAGIC schema = "carga"
-- MAGIC
-- MAGIC # Listar todos os arquivos no volume
-- MAGIC files = dbutils.fs.ls(volume_path)
-- MAGIC
-- MAGIC # Filtrar diretorios e obter apenas caminhos de arquivos
-- MAGIC file_paths = [file.path for file in files if not file.isDir()]
-- MAGIC
-- MAGIC # Ler cada arquivo e criar uma tabela Delta
-- MAGIC for file_path in file_paths:
-- MAGIC     # Extrair o nome do arquivo sem extensao para usar como nome da tabela
-- MAGIC     table_name = os.path.splitext(os.path.basename(file_path))
-- MAGIC     
-- MAGIC     # Ler o arquivo em um DataFrame
-- MAGIC     df = spark.read.format("csv").option("header", "true").load(file_path)
-- MAGIC     
-- MAGIC     # Escrever o DataFrame em uma tabela Delta no catalogo e esquema especificados
-- MAGIC     df.write.format("delta").mode("overwrite").saveAsTable(f"{catalog}.{schema}.{table_name}")
-- MAGIC
-- MAGIC     print(f"Tabela {catalog}.{schema}.{table_name} criada com sucesso.")

Citations:
[1] https://github.com/mousastech/iafunciones/blob/fd139cf6a61d68b2858b91907d3885cce238c
