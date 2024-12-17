-- Databricks notebook source
-- MAGIC %md <img src="https://github.com/mousastech/agentes_ia/blob/a6db91737186d6d21d7808bb9950b154376d1d69/img/headertools_aiagents.png?raw=true" width=100%>
-- MAGIC
-- MAGIC # Usando Agentes de IA
-- MAGIC
-- MAGIC Treinamento pratico na plataforma Databricks com foco em funcionalidades de IA generativa.

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Objetivo do exercicio
-- MAGIC
-- MAGIC O objetivo deste laboratorio e implementar o seguinte caso de uso:
-- MAGIC
-- MAGIC ### Personalizacao do servico com Agentes
-- MAGIC
-- MAGIC Os LLMs sao excelentes para responder perguntas. No entanto, isso por si so nao e suficiente para oferecer valor aos seus clientes.
-- MAGIC
-- MAGIC Para poder fornecer respostas mais complexas, e necessaria informacao adicional especifica do usuario, como seu ID de contrato, o ultimo e-mail que enviou ao suporte ou seu relatorio de compra mais recente.
-- MAGIC
-- MAGIC Os agentes sao projetados para superar esse desafio. Sao implantacoes de IA mais avancadas, compostas por multiplas entidades (ferramentas) especializadas em diferentes acoes (recuperar informacoes ou interagir com sistemas externos).
-- MAGIC
-- MAGIC Em termos gerais, voce cria e apresenta um conjunto de funcoes personalizadas a IA. Em seguida, o LLM pode raciocinar sobre quais informacoes devem ser coletadas e quais ferramentas utilizar para responder as instrucoes que recebe.
-- MAGIC <br><br>
-- MAGIC
-- MAGIC <img src="https://github.com/mousastech/agentes_ia/blob/e4602f57c4a83b171c7c541e11244136cdd80816/img/llm-call.png?raw=true" width="100%">

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Preparacao
-- MAGIC
-- MAGIC Para realizar os exercicios, precisamos conectar a um Cluster.
-- MAGIC
-- MAGIC Simplesmente siga os passos abaixo:
-- MAGIC 1. No canto superior direito, clique em **Conectar**
-- MAGIC 2. Selecione o tipo de Cluster **SQL Serverless Warehouse** ou **Serverless**.

-- COMMAND ----------

-- MAGIC %md 
-- MAGIC
-- MAGIC ## Conjunto de dados de exemplo
-- MAGIC
-- MAGIC Agora, vamos acessar as avaliacoes de produtos que carregamos na pratica de laboratorio anterior.
-- MAGIC
-- MAGIC Nesta pratica de laboratorio usaremos duas tabelas:
-- MAGIC - **Avaliacoes**: dados nao estruturados com o conteudo das avaliacoes
-- MAGIC - **Clientes**: dados estruturados como registro de clientes e consumo.
-- MAGIC
-- MAGIC Vamos visualizar esses dados!

-- COMMAND ----------

-- MAGIC %md ### A. Preparacao de dados
-- MAGIC
-- MAGIC 1. Criar ou utilizar o catalogo `funcoesai`
-- MAGIC 2. Criar ou utilizar o schema `carga`
-- MAGIC 3. Criar o volume `arquivos`
-- MAGIC 4. Importar os arquivos da pasta `data` para o Volume criado
-- MAGIC
-- MAGIC Codigo disponivel no notebook `⚙️ ./Setup`

-- COMMAND ----------

-- MAGIC %md ## Usando o Unity Catalog Tools
-- MAGIC
-- MAGIC O primeiro passo na construcao do nosso agente sera entender como utilizar o **Unity Catalog Tools**.
-- MAGIC
-- MAGIC Na pratica de laboratorio anterior, criamos algumas funcoes, como `revisar_avaliacao`, que nos permitiu facilitar a invocacao dos nossos modelos de IA generativa a partir do SQL. No entanto, nossos LLMs tambem podem utilizar essas mesmas funcoes como ferramentas. Basta indicar quais funcoes o modelo pode utilizar!
-- MAGIC
-- MAGIC Poder utilizar o mesmo catalogo de ferramentas em toda a plataforma simplifica enormemente nossa vida ao promover a reutilizacao desses ativos. Isso pode economizar horas de remodelagem e padronizar esses conceitos.
-- MAGIC
-- MAGIC Vamos ver como utilizar as ferramentas na pratica!
-- MAGIC
-- MAGIC 1. No **menu principal** a esquerda, clique em **`Playground`**
-- MAGIC 2. Clique no **seletor de modelo** e selecione o modelo **`Meta Llama 3.1 70B Instruct`** (se ainda nao estiver selecionado)
-- MAGIC 3. Clique em **Tools** e depois em **Add Tool** 
-- MAGIC 4. Em **Hosted Function**, digite `funcoesai.carga.revisar_avaliacao`
-- MAGIC 5. Adicione as instrucoes abaixo:
-- MAGIC     ```
-- MAGIC     Revise a avaliacao abaixo:
-- MAGIC  Comprei um tablet e estou muito insatisfeito com a qualidade da bateria. Dura muito pouco e demora muito para carregar.
-- MAGIC     ```
-- MAGIC 6. Clique no icone **enviar**

-- COMMAND ----------

-- MAGIC %md ## Consultando dados do cliente
-- MAGIC
-- MAGIC Ferramentas podem ser utilizadas em diversos cenarios, como por exemplo:
-- MAGIC
-- MAGIC - Consultar informacoes em bancos de dados
-- MAGIC - Calcular indicadores complexos
-- MAGIC - Gerar um texto baseado nas informacoes disponiveis
-- MAGIC - Interagir com APIs e sistemas externos
-- MAGIC
-- MAGIC Como ja discutimos, isso vai ser muito importante para conseguirmos produzir respostas mais personalizadas e precisas no nosso agente. 
-- MAGIC
-- MAGIC No nosso caso, gostariamos de:
-- MAGIC - Consultar os dados do cliente
-- MAGIC - Pesquisar perguntas e respostas em uma base de conhecimento
-- MAGIC - Fornecer recomendacoes personalizadas de produtos com base em suas descricoes
-- MAGIC
-- MAGIC Vamos comecar pela consulta dos dados do cliente!

-- COMMAND ----------

-- MAGIC %md ### A. Selecione o banco de dados criado anteriormente

-- COMMAND ----------

USE funcoesai.carga

-- COMMAND ----------

-- MAGIC %md ### B. Criar a funcao

-- COMMAND ----------

CREATE OR REPLACE FUNCTION CONSULTAR_CLIENTE(id_cliente BIGINT)
RETURNS TABLE (nome STRING, sobrenome STRING, num_pedidos INT)
COMMENT 'Utilize esta funcao para consultar os dados de um cliente'
RETURN SELECT nome, sobrenome, num_pedidos FROM clientes c WHERE c.id_cliente = consultar_cliente.id_cliente

-- COMMAND ----------

-- MAGIC %md ### C. Testar a funcao

-- COMMAND ----------

SELECT * FROM consultar_cliente(1)

-- COMMAND ----------

-- MAGIC %md ### D. Testar a funcao como ferramenta.
-- MAGIC
-- MAGIC 1. No **menu principal** a esquerda, clique em **`Playground`**
-- MAGIC 2. Clique no **seletor de modelo** e selecione o modelo **`Meta Llama 3.1 70B Instruct`** (se ainda nao estiver selecionado)
-- MAGIC 3. Clique em **Tools** e depois em **Add Tools**
-- MAGIC 4. Em **Hosted function**, digite `funcoesai.carga.consultar_cliente` e `funcoesai.carga.revisar_avaliacao`
-- MAGIC 5. Adicione as instrucoes abaixo:<br>
-- MAGIC  `Gerar uma resposta ao cliente 1 que nao esta satisfeito com a qualidade da tela do seu tablet. Nao esqueca de personalizar a mensagem com o nome do cliente.
-- MAGIC 6. Clique no icone **enviar**

-- COMMAND ----------

-- MAGIC %md ### E. Analisando os resultados
-- MAGIC
-- MAGIC Com o resultado do exercicio anterior, siga os passos abaixo:
-- MAGIC
-- MAGIC 1. Na parte inferior da resposta, clique em **`View Trace`** 
-- MAGIC 2. Neste painel, navegue entre as diferentes acoes executadas a esquerda
-- MAGIC
-- MAGIC Dessa forma, voce podera entender a linha de raciocinio do agente, ou seja, quais acoes foram executadas, com quais parametros e em que ordem. Alem disso, quando houver algum erro de execucao, tambem servira de insumo para entendermos e corrigirmos eventuais problemas.

-- COMMAND ----------

-- MAGIC %md ## Busca de perguntas e respostas em uma base de conhecimento
-- MAGIC
-- MAGIC Agora, precisamos preparar uma funcao que nos permita aproveitar uma base de conhecimento para orientar as respostas do nosso agente.
-- MAGIC
-- MAGIC Para fazer isso, usaremos o **Vector Search**. Este componente nos permite comparar as perguntas formuladas pelo nosso cliente com as da base de conhecimento e depois recuperar a resposta correspondente a pergunta com maior similaridade. A unica coisa que precisamos fazer e indexar as perguntas frequentes, que carregamos anteriormente, no Vector Search!
-- MAGIC
-- MAGIC Vamos la!

-- COMMAND ----------

-- MAGIC %md ### A. Habilitar o Change Data Feed na tabela `FAQ`
-- MAGIC
-- MAGIC Esta configuracao permite ao Vector Search ler os dados inseridos, excluidos ou modificados nas perguntas frequentes de forma incremental.

-- COMMAND ----------

ALTER TABLE faq SET TBLPROPERTIES (delta.enableChangeDataFeed = true)

-- COMMAND ----------

-- MAGIC %md ### B. Criar um indice no Vector Search
-- MAGIC
-- MAGIC 1. No **menu principal** a esquerda, clique em **`Catalog`**
-- MAGIC 2. Busque a sua **tabela** `funcoesai.carga.faq`
-- MAGIC 3. Clique em `Create` e depois em `Vector search index`
-- MAGIC 4. Preencha o formulario:
-- MAGIC     - **Nome:** faq_index
-- MAGIC     - **Primary key:** id
-- MAGIC     - **Endpoint**: selecione o endpoint desejado
-- MAGIC     - **Columns to sync:** deixar em branco (sincroniza todas as colunas)
-- MAGIC     - **Embedding source:** Compute embeddings (Vector Search gerencia a indexacao/criacao de embeddings)
-- MAGIC     - **Embedding source column:** pergunta
-- MAGIC     - **Embedding model:** databricks-gte-large-en
-- MAGIC     - **Sync computed embeddings:** desabilitado
-- MAGIC     - **Sync mode:** Triggered
-- MAGIC 5. Clique em `Create`
-- MAGIC 6. Aguarde a criacao do indice finalizar

-- COMMAND ----------

-- MAGIC %md ### C. Criar a funcao

-- COMMAND ----------

CREATE OR REPLACE FUNCTION consultar_faq(pergunta STRING)
RETURNS TABLE(id LONG, pergunta STRING, resposta STRING, search_score DOUBLE)
COMMENT 'Utilize esta funcao para consultar a base de conhecimento sobre prazos de entrega, solicitacoes de troca ou devolucao, entre outras perguntas frequentes sobre nosso mercado.'
RETURN select * from vector_search(
  index => 'funcoesai.carga.faq_index', 
  query => consultar_faq.pergunta,
  num_results => 1
)

-- COMMAND ----------

CREATE OR REPLACE FUNCTION funcoesai.carga.consultar_faq(pergunta STRING)
RETURNS STRING
COMMENT 'Utilize esta funcao para consultar a base de conhecimento sobre prazos de entrega, solicitacoes de troca ou devolucao, entre outras perguntas frequentes sobre nosso mercado.'
RETURN (
  SELECT resposta___ 
  FROM vector_search(
    index => 'funcoesai.carga.faq_index', 
    query => pergunta,
    num_results => 1
  )
  LIMIT 1
)

-- COMMAND ----------

-- MAGIC %md ### D. Testar a funcao

-- COMMAND ----------

SELECT consultar_faq('Qual e o prazo de devolucao?') AS STRING

-- COMMAND ----------

SELECT consultar_faq('Como emitir uma segunda via?')

-- COMMAND ----------

-- MAGIC %md ### E. Teste a funcao como ferramenta.
-- MAGIC
-- MAGIC 1. No **menu principal** a esquerda, clique em **`Playground`**
-- MAGIC 2. Clique no **seletor de modelo** e selecione o modelo **`Meta Llama 3.1 70B Instruct`** (se ainda nao estiver selecionado)
-- MAGIC 3. Clique em **Tools** e depois em **Add Tools**
-- MAGIC 4. Em **Hosted Function**, digite `funcoesai.carga.consultar_faq`
-- MAGIC 5. Adicione a seguinte declaracao:
-- MAGIC  ```
-- MAGIC  Qual e o prazo de devolucao?
-- MAGIC  ```
-- MAGIC 6. Clique no icone **enviar**

-- COMMAND ----------

-- MAGIC %md ## Fornecer recomendacoes de produtos personalizadas com base em suas descricoes.
-- MAGIC
-- MAGIC Finalmente, tambem gostariamos de criar uma ferramenta para ajudar nossos clientes a encontrar produtos que tenham descricoes semelhantes. Esta ferramenta ajudara os clientes que nao estao satisfeitos com um produto e procuram uma troca.

-- COMMAND ----------

-- MAGIC %md ### A. Habilite o Change Data Feed na tabela `produtos`

-- COMMAND ----------

ALTER TABLE produtos SET TBLPROPERTIES (delta.enableChangeDataFeed = true)

-- COMMAND ----------

-- MAGIC %md ### B. Criar um indice no Vector Search
-- MAGIC
-- MAGIC 1. No **menu principal** a esquerda, clique em **`Catalogo`**
-- MAGIC 2. Busque sua **tabela** `funcoesai.carga.produtos`
-- MAGIC 3. Clique em `Create` e depois em `Vector search index`
-- MAGIC 4. Preencha o formulario:
-- MAGIC  - **Nome:** id
-- MAGIC  - **Primary key:** id
-- MAGIC  - **Endpoint**: selecione o endpoint desejado
-- MAGIC  - **Columns to sync:** deixar em branco (sincroniza todas as colunas)
-- MAGIC  - **Fonte de embedding:** Compute embeddings (Vector Search gerencia a indexacao/criacao de embeddings)
-- MAGIC  - **Embedding source:** descricao
-- MAGIC  - **Embedding model:** databricks-gte-large-en
-- MAGIC  - **Sync computed embeddings:** desabilitado
-- MAGIC  - **Sync mode:** Ativado
-- MAGIC 5. Clique em "Create".
-- MAGIC 6. Aguarde a criacao do indice finalizar.

-- COMMAND ----------

-- MAGIC %md ### C. Criar a funcao

-- COMMAND ----------

CREATE OR REPLACE FUNCTION bus

Citations:
[1] https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/14131051/4679cd05-065e-4d03-a6aa-b3a4b00830e4/paste.txt
[2] https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/14131051/37403a55-48cc-4c3c-9960-8d0ac404ada4/paste-2.txt
[3] https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/14131051/a1db1307-c414-4a4f-aa54-f81ef3f571ec/paste-3.txt
[4] https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/14131051/1d0d5551-07e5-4888-88c6-e256c011f96a/paste-4.txt
[5] https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/14131051/4679cd05-065e-4d03-a6aa-b3a4b00830e4/paste.txt
