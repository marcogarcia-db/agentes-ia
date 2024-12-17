-- Databricks notebook source
-- MAGIC %md <img src="https://github.com/mousastech/agentes_ia/blob/a6db91737186d6d21d7808bb9950b154376d1d69/img/headertools_aiagents.png?raw=true" width=100%>
-- MAGIC
-- MAGIC # Usando Agentes de IA
-- MAGIC
-- MAGIC Capacitación práctica en la plataforma Databricks con enfoque en funcionalidades de IA generativa.

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Objetivo del ejercicio
-- MAGIC
-- MAGIC El objetivo de este laboratorio es implementar el siguiente caso de uso:
-- MAGIC
-- MAGIC ### Personalización del servicio con Agentes
-- MAGIC
-- MAGIC Los LLM son excelentes para responder preguntas. Sin embargo, esto por sí solo no es suficiente para ofrecer valor a sus clientes.
-- MAGIC
-- MAGIC Para poder proporcionar respuestas más complejas, se requiere información adicional específica del usuario, como su ID de contrato, el último correo electrónico que envió a su soporte o su informe de compra más reciente.
-- MAGIC
-- MAGIC Los agentes están diseñados para superar este desafío. Son despliegues de IA más avanzados, compuestos por múltiples entidades (herramientas) especializadas en diferentes acciones (recuperar información o interactuar con sistemas externos).
-- MAGIC
-- MAGIC En términos generales, usted crea y presenta un conjunto de funciones personalizadas a la IA. Luego, el LLM puede razonar sobre qué información debe recopilarse y qué herramientas utilizar para responder a las instrucciones que recibe.
-- MAGIC <br><br>
-- MAGIC
-- MAGIC <img src="https://github.com/mousastech/agentes_ia/blob/e4602f57c4a83b171c7c541e11244136cdd80816/img/llm-call.png?raw=true" width="100%">

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Preparación
-- MAGIC
-- MAGIC Para realizar los ejercicios, necesitamos prender a un Clúster.
-- MAGIC
-- MAGIC Simplemente siga los pasos a continuación:
-- MAGIC 1. En la esquina superior derecha, haga clic en **Conectar**
-- MAGIC 2. Seleccione el tipo de Clúster **SQL Serverless Warehouse** o **Serverless**.

-- COMMAND ----------

-- MAGIC %md 
-- MAGIC
-- MAGIC ## Conjunto de datos de ejemplo
-- MAGIC
-- MAGIC Ahora, accedamos a las reseñas de productos que subimos en la práctica de laboratorio anterior.
-- MAGIC
-- MAGIC En esta práctica de laboratorio usaremos dos tablas:
-- MAGIC - **Evaluaciones**: datos no estructurados con el contenido de las evaluaciones
-- MAGIC - **Clientes**: datos estructurados como registro de clientes y consumo.
-- MAGIC
-- MAGIC ¡Ahora visualicemos estos datos!

-- COMMAND ----------

-- MAGIC %md ### A. Preparación de datos
-- MAGIC
-- MAGIC 1. Crear o utilizar el catalogo `funcionesai`
-- MAGIC 2. Crear o utilizar el schema `carga`
-- MAGIC 3. Crear el volumen `archivos`
-- MAGIC 4. Importar los archivos de la carpeta `data` para el Volumen creado
-- MAGIC
-- MAGIC Código disponible en el notebook `⚙️ ./Setup`

-- COMMAND ----------

-- MAGIC %md ## Usando el Unity Catalog Tools
-- MAGIC
-- MAGIC El primer paso en la construcción de nuestro agente será entender cómo utilizar **Unity Catalog Tools**.
-- MAGIC
-- MAGIC En la práctica de laboratorio anterior, creamos algunas funciones, como `revisar_evaluacion`, que nos permitió facilitar la invocación de nuestros modelos de IA generativa desde SQL. Sin embargo, nuestros LLM también pueden utilizar estas mismas funciones como herramientas. ¡Simplemente indique qué funciones puede utilizar el modelo!
-- MAGIC
-- MAGIC Poder utilizar el mismo catálogo de herramientas en toda la plataforma nos simplifica enormemente la vida al promover la reutilización de estos activos. Esto puede ahorrar horas de remodelación y estandarizar estos conceptos.
-- MAGIC
-- MAGIC ¡Veamos cómo utilizar las herramientas en la práctica!
-- MAGIC
-- MAGIC 1. En el **menú principal** de la izquierda, haz clic en **`Playground`**
-- MAGIC 2. Haz clic en el **selector de modelo** y selecciona el modelo **`Meta Llama 3.1 70B Instruct`** (si aún no está seleccionado)
-- MAGIC 3. Hacer clic **Tools** y luego en **Add Tool** 
-- MAGIC 4. En **Hosted Function**, tipear `funcionesai.carga.revisar_avaliacao`
-- MAGIC 5. Agregue instrucciones a continuación:
-- MAGIC     ```
-- MAGIC     Revise la reseña a continuación:
-- MAGIC  Compré una tableta y estoy muy descontento con la calidad de la batería. Dura muy poco y tarda mucho en cargarse.
-- MAGIC     ```
-- MAGIC 6. Haga clic en el ícono **enviar**

-- COMMAND ----------

-- MAGIC %md ## Consultando dados do cliente
-- MAGIC
-- MAGIC Ferramentas podem ser utilizadas em diversos cenários, como por exemplo:
-- MAGIC
-- MAGIC - Consultar informações em bancos de dados
-- MAGIC - Calcular indicadores complexos
-- MAGIC - Gerar um texto baseado nas informações disponíveis
-- MAGIC - Interagir com APIs e sistemas externos
-- MAGIC
-- MAGIC Como já discutimos, isso vai ser muito importante para conseguirmos produzir respostas mais personalizadas e precisas no nosso agente. 
-- MAGIC
-- MAGIC No nosso caso, gostaríamos de:
-- MAGIC - Consultar os dados do cliente
-- MAGIC - Pesquisar perguntas e respostas em uma base de conhecimento
-- MAGIC - Fornecer recomendações personalizadas de produtos com base em suas descrições
-- MAGIC
-- MAGIC Vamos começar pela consulta dos dados do cliente!

-- COMMAND ----------

-- MAGIC %md ### A. Seleccione la base de datos creada previamente

-- COMMAND ----------

USE funcionesai.carga

-- COMMAND ----------

-- MAGIC %md ### B. Crear la función

-- COMMAND ----------

CREATE OR REPLACE FUNCTION CONSULTAR_CLIENTE(id_cliente BIGINT)
RETURNS TABLE (nome STRING, sobrenome STRING, num_pedidos INT)
COMMENT 'Utilice esta función para consultar los datos de un cliente'
RETURN SELECT nome, sobrenome, num_pedidos FROM clientes c WHERE c.id_cliente = consultar_cliente.id_cliente

-- COMMAND ----------

-- MAGIC %md ### C. Probar la función

-- COMMAND ----------

SELECT * FROM consultar_cliente(1)

-- COMMAND ----------

-- MAGIC %md ### D. Probar la función como herramienta.
-- MAGIC
-- MAGIC 1. En el **menú principal** de la izquierda, haz clic en **`Playground`**
-- MAGIC 2. Haga clic en el **selector de modelo** y seleccione el modelo **`Meta Llama 3.1 70B Instruct`** (si aún no está seleccionado)
-- MAGIC 3. Haga clic en **Tools** y luego en **Add Tools**
-- MAGIC 4. En **Hosted function**, escriba `funcionesai.carga.consultar_cliente` y `funcionesai.carga.revisar_avaliacao`
-- MAGIC 5. Agregue las instrucciones a continuación:<br>
-- MAGIC  `Generar una respuesta al cliente 1 que no está satisfecho con la calidad de la pantalla de su tablet. No olvides personalizar el mensaje con el nombre del cliente.
-- MAGIC 6. Haga clic en el ícono **enviar**

-- COMMAND ----------

-- MAGIC %md ### E. Analisando os resultados
-- MAGIC
-- MAGIC Com o resultado do exercício anterior, siga os passos abaixo:
-- MAGIC
-- MAGIC 1. Na parte inferior da resposta, clique em **`View Trace`** 
-- MAGIC 2. Neste painel, navegue entre as diferentes ações executadas à esquerda
-- MAGIC
-- MAGIC Dessa forma, você poderá entender a linha de raciocínio do agente, ou seja, quais ações foram executas, com quais parâmetros e em que ordem. Além disso, quando houver algum erro de execução, também servirá de insumo para entendermos e corrigirmos eventuais problemas.

-- COMMAND ----------

-- MAGIC %md ## Búsqueda de preguntas y respuestas en una base de conocimientos
-- MAGIC
-- MAGIC Ahora, necesitamos preparar una función que nos permita aprovechar una base de conocimientos para guiar las respuestas de nuestro agente.
-- MAGIC
-- MAGIC Para hacer esto, usaremos **Vector Search**. Este componente nos permite comparar las preguntas formuladas por nuestro cliente con las de la base de conocimiento y luego recuperar la respuesta correspondiente a la pregunta con mayor similitud. ¡Lo único que debemos hacer es indexar las preguntas frecuentes, que subimos anteriormente, en Vector Search!
-- MAGIC
-- MAGIC ¡Vamos!

-- COMMAND ----------

-- MAGIC %md ### A. Habilitar o Change Data Feed na tabela `FAQ`
-- MAGIC
-- MAGIC Esta configuración permite a Vector Search leer los datos ingresados, eliminados o modificados en las preguntas frecuentes de forma incremental.

-- COMMAND ----------

ALTER TABLE faq SET TBLPROPERTIES (delta.enableChangeDataFeed = true)

-- COMMAND ----------

-- MAGIC %md ### B. Crear un índice en Búsqueda de vectores (Vector Search)
-- MAGIC
-- MAGIC 1. No **menu principal** à esquerda, clique em **`Catalog`**
-- MAGIC 2. Busque a sua **tabela** `funcionesai.carga.faq`
-- MAGIC 3. Clique em `Create` e depois em `Vector search index`
-- MAGIC 4. Preencha o formulário:
-- MAGIC     - **Nome:** faq_index
-- MAGIC     - **Primary key:** id
-- MAGIC     - **Endpoint**: selecione o endpoint desejado
-- MAGIC     - **Columns to sync:** deixar em branco (sincroniza todas as colunas)
-- MAGIC     - **Embedding source:** Compute embeddings (Vector Search gestiona la indexación/creación de embeddings)
-- MAGIC     - **Embedding source column:** pregunta
-- MAGIC     - **Embedding model:** databricks-gte-large-en
-- MAGIC     - **Sync computed embeddings:** desabilitado
-- MAGIC     - **Sync mode:** Triggered
-- MAGIC 5. Clique em `Create`
-- MAGIC 6. Aguarde a criação do índice finalizar

-- COMMAND ----------

-- MAGIC %md ### C. Crear la función

-- COMMAND ----------

CREATE OR REPLACE FUNCTION consultar_faq(pregunta STRING)
RETURNS TABLE(id LONG, pregunta STRING, respuesta STRING, search_score DOUBLE)
COMMENT 'Utilice esta función para consultar la base de conocimientos sobre tiempos de entrega, solicitudes de cambio o devolución, entre otras preguntas frecuentes sobre nuestro mercado.'
RETURN select * from vector_search(
  index => 'funcionesai.carga.faq_index', 
  query => consultar_faq.pregunta,
  num_results => 1
)

-- COMMAND ----------

CREATE OR REPLACE FUNCTION funcionesai.carga.consultar_faq(pregunta STRING)
RETURNS STRING
COMMENT 'Utilice esta función para consultar la base de conocimientos sobre tiempos de entrega, solicitudes de cambio o devolución, entre otras preguntas frecuentes sobre nuestro mercado.'
RETURN (
  SELECT respuesta___ 
  FROM vector_search(
    index => 'funcionesai.carga.faq_index', 
    query => pregunta,
    num_results => 1
  )
  LIMIT 1
)

-- COMMAND ----------

-- MAGIC %md ### D. Probar la función

-- COMMAND ----------

SELECT consultar_faq('¿Cuál es el plazo de devolución?') AS STRING

-- COMMAND ----------

SELECT consultar_faq('¿Cómo emitir un duplicado?')

-- COMMAND ----------

-- MAGIC %md ### E. Pruebe la función como herramienta.
-- MAGIC
-- MAGIC 1. En el **menú principal** de la izquierda, haz clic en **`Playground`**
-- MAGIC 2. Haga clic en el **selector de modelo** y seleccione el modelo **`Meta Llama 3.1 70B Instruct`** (si aún no está seleccionado)
-- MAGIC 3. Haga clic en **Tools** y luego en **Add Tools**
-- MAGIC 4. En **Hosted Function**, escriba `funcionesia.carga.consultar_faq`
-- MAGIC 5. Agregue la siguiente declaración:
-- MAGIC  ```
-- MAGIC  ¿Cuál es el plazo de devolución?
-- MAGIC  ```
-- MAGIC 6. Haga clic en el ícono **enviar**

-- COMMAND ----------

-- MAGIC %md ## Proporcionar recomendaciones de productos personalizadas basadas en sus descripciones.
-- MAGIC
-- MAGIC Finalmente, también nos gustaría crear una herramienta para ayudar a nuestros clientes a encontrar productos que tengan descripciones similares. Esta herramienta ayudará a los clientes que no están satisfechos con un producto y buscan un cambio.

-- COMMAND ----------

-- MAGIC %md ### A. Habilite Change Data Feed en la tabla `productos`

-- COMMAND ----------

ALTER TABLE productos SET TBLPROPERTIES (delta.enableChangeDataFeed = true)

-- COMMAND ----------

-- MAGIC %md ### B. Crear un índice en el Vector Search
-- MAGIC
-- MAGIC 1. En el **menú principal** de la izquierda, haga clic en **`Catálogo`**
-- MAGIC 2. Busca tu **tabla** `funcionesai.carga.productos`
-- MAGIC 3. Haga clic en `Create` y luego en `Vector search index`
-- MAGIC 4. Complete el formulario:
-- MAGIC  - **Nombre:** id
-- MAGIC  - **Primary key:** id
-- MAGIC  - **Endpoint**: seleccione el punto final deseado
-- MAGIC  - **Columns to sync:** dejar en blanco (sincroniza todas las columnas)
-- MAGIC  - **Fuente de incrustación:** Computar incrustaciones (Vector Search gestiona la indexación/creación de incrustaciones)
-- MAGIC  - **Embedding source:** descripción
-- MAGIC  - **Embedding model:** databricks-gte-large-en
-- MAGIC  - **Sync computed embeddings:** deshabilitado
-- MAGIC  - **Sync mode:** Activado
-- MAGIC 5. Haga clic en "Create".
-- MAGIC 6. Espere a que finalice la creación del índice.

-- COMMAND ----------

-- MAGIC %md ### C. Crear la función

-- COMMAND ----------

CREATE OR REPLACE FUNCTION buscar_produtos_similares(descripcion STRING)
RETURNS TABLE(id LONG, producto STRING, descripcion STRING, search_score DOUBLE)
COMMENT 'Esta función recibe una descripción del producto, que se utiliza para buscar productos similares.'
RETURN SELECT id, produto, descricao, search_score FROM (
  SELECT *, ROW_NUMBER() OVER (ORDER BY search_score DESC) AS rn
  FROM vector_search(
    index => 'funcionesai.carga.productos_index',
    query => buscar_produtos_similares.descripcion,
    num_results => 10)
  WHERE search_score BETWEEN 0.003 AND 0.99
) WHERE rn <= 3

-- COMMAND ----------

-- MAGIC %md ### D. Probar la función

-- COMMAND ----------

SELECT * FROM buscar_produtos_similares('Los auriculares DEF son un dispositivo de audio diseñado para brindar una experiencia de sonido envolvente y de alta calidad. Con controladores de alta fidelidad y tecnología de cancelación de ruido, te permite perderte en la música o los detalles de un podcast sin distracciones. Además, su diseño ergonómico garantiza comodidad durante un uso prolongado.')

-- COMMAND ----------

-- MAGIC %md ### E. Probar la función como herramienta
-- MAGIC
-- MAGIC 1. En el **menú principal** de la izquierda, haz clic en **`Playground`**
-- MAGIC 2. Haga clic en el **selector de modelo** y seleccione el modelo **`Meta Llama 3.1 70B Instruct`** (si aún no está seleccionado)
-- MAGIC 3. Haga clic en **Tools** y luego en **Add tools**
-- MAGIC 4. En **Hosted function**, escriba `funcionesai.carga.buscar_produtos_similares`
-- MAGIC 5. Agregue la siguiente declaración:
-- MAGIC  ```
-- MAGIC  ¿Qué tabletas tienen buena calidad de pantalla?
-- MAGIC  ```
-- MAGIC 6. Haga clic en el ícono **enviar**

-- COMMAND ----------

-- MAGIC %md ## Probando a nuestro agente
-- MAGIC
-- MAGIC 1. En el **menú principal** de la izquierda, haz clic en **`Playground`**
-- MAGIC 2. Haga clic en el **selector de modelo** y seleccione el modelo **`Meta Llama 3.1 70B Instruct`** (si aún no está seleccionado)
-- MAGIC 3. Haga clic en **Tools** y luego en **Add tools**
-- MAGIC 4. En **Hosted Function**, escriba `funcionesai.carga.*` para agregar todas las funciones creadas.
-- MAGIC 5. En **System Prompt**, escriba: <br>
-- MAGIC `Eres un asistente virtual para un comercio electrónico. Para responder preguntas, el cliente debe proporcionar su cédula. Si aún no tiene esta información, solicite cortésmente su cédula. Podrás resolver dudas sobre entrega, devoluciones de productos, estado de pedidos, entre otras. Si no sabe cómo responder la pregunta, diga que no lo sabe. No inventes ni especules sobre nada. Siempre que se le pregunte sobre procedimientos, consulte nuestra base de conocimientos.`
-- MAGIC 6. Escribe "¡Hola!"
-- MAGIC 7. Ingrese `000.000.000-01`
-- MAGIC 8. Escriba "Compré una tableta DEF, pero la calidad de la pantalla es muy mala".
-- MAGIC 9. Escriba "¿Podría recomendar productos similares?"
-- MAGIC 10. Escriba "¿Cómo solicito un cambio?"

-- COMMAND ----------

-- MAGIC %md # ¡Felicidades!
-- MAGIC
-- MAGIC ¡Has completado el laboratorio de **Agentes**!
-- MAGIC
-- MAGIC ¡Ahora ya sabes cómo utilizar Foundation Models, Playground y las herramientas de catálogo de Unity para crear prototipos de forma rápida y sencilla de agentes capaces de responder con precisión preguntas complejas!
