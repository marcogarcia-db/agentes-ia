-- Databricks notebook source
-- MAGIC %md <img src="https://github.com/Databricks-BR/lab_genai/blob/main/img/header.png?raw=true" width=100%>
-- MAGIC
-- MAGIC # Hands-On LAB 03 - Usando Agentes
-- MAGIC
-- MAGIC Treinamento Hands-on na plataforma Databricks com foco nas funcionalidades de IA Generativa.

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Objetivos do Exercício
-- MAGIC
-- MAGIC O objetivo desse laboratório é implementar o seguinte caso de uso:
-- MAGIC
-- MAGIC ### Personalizando o atendimento com Agentes
-- MAGIC
-- MAGIC LLMs são ótimos para responder a perguntas. No entanto, isso sozinho não é suficiente para fornecer valor aos seus clientes.
-- MAGIC
-- MAGIC Para ser capaz de fornecer respostas mais complexas, informações adicionais e específicas para o usuário são necessárias, como seu ID de contrato, o último e-mail que enviaram para o seu suporte ou seu relatório de compras mais recentes.
-- MAGIC
-- MAGIC Agentes são projetados para superar este desafio. Eles são implantações de IA mais avançadas, compostas por múltiplas entidades (ferramentas) especializadas em diferentes ações (recuper informações ou interagir com sistemas externos).
-- MAGIC
-- MAGIC De forma geral, você constrói e apresenta um conjunto de funções personalizadas para a IA. A LLM pode então raciocinar sobre quais informações precisam ser reunidas e quais ferramentas utilizar para responder às intruções recebidas.
-- MAGIC
-- MAGIC <img src="https://github.com/databricks-demos/dbdemos-resources/blob/main/images/product/llm-tools-functions/llm-tools-functions-flow.png?raw=true" width="100%">

-- COMMAND ----------

-- MAGIC %md ## Preparação
-- MAGIC
-- MAGIC Para executar os exercícios, precisamos conectar este notebook a um compute.
-- MAGIC
-- MAGIC Basta seguir os passos abaixo:
-- MAGIC 1. No canto superior direito, clique em **Connect**
-- MAGIC 2. Selecione o **SQL Warehouse** desejado

-- COMMAND ----------

-- MAGIC %md ## Exercício 03.01 - Usando Unity Catalog Tools
-- MAGIC
-- MAGIC O primeiro passo na construção do nosso agente será entender como utilizar **Unity Catalog Tools**.
-- MAGIC
-- MAGIC No laboratório anterior, criamos algumas funções, como a `revisar_avaliacao`, que nos permitiam facilitar a invocação dos nossos modelos de IA Generativa a partir do SQL. No entanto, essas mesmas funções também podem ser utilizadas como ferramentas por nossas LLMs. Basta indicar quais funções o modelo pode utilizar!
-- MAGIC
-- MAGIC Poder utilizar um mesmo catálogo de ferramentas em toda a plataforma simplifica bastante a nossa vida ao promover a reutilização desses ativos. Isso pode economizar horas de redesenvolvimento, bem como padronizar esses conceitos.
-- MAGIC
-- MAGIC Vamos ver como utilizar ferramentas na prática!
-- MAGIC
-- MAGIC 1. No **menu principal** à esquerda, clique em **`Playground`**
-- MAGIC 2. Clique no **seletor de modelos** e selecione o modelo **`Meta Llama 3.1 70B Instruct`** (caso já não esteja selecionado)
-- MAGIC 3. Clique em **Tools** e depois em **Add Tool** 
-- MAGIC 4. Em **Hosted Function**, digite `academy.<seu_nome>.revisar_avaliacao`
-- MAGIC 5. Adicione a instrução abaixo:
-- MAGIC     ```
-- MAGIC     Revise a avaliação abaixo:
-- MAGIC     Comprei um tablet e estou muito insatisfeito com a qualidade da bateria. Ela dura muito pouco tempo e demora muito para carregar.
-- MAGIC     ```
-- MAGIC 6. Clique no ícone **enviar**

-- COMMAND ----------

-- MAGIC %md ## Exercício 03.02 - Consultando dados do cliente
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

-- MAGIC %md ### A. Selecionar o database que criamos anteriormente

-- COMMAND ----------

USE academy.<seu_nome>

-- COMMAND ----------

-- MAGIC %md ### B. Criar a função

-- COMMAND ----------

CREATE OR REPLACE FUNCTION CONSULTAR_CLIENTE(id_cliente BIGINT)
RETURNS TABLE (nome STRING, sobrenome STRING, num_pedidos INT)
COMMENT 'Use esta função para consultar os dados de um cliente'
RETURN SELECT nome, sobrenome, num_pedidos FROM clientes c WHERE c.id_cliente = consultar_cliente.id_cliente

-- COMMAND ----------

-- MAGIC %md ### C. Testar a função

-- COMMAND ----------

SELECT * FROM consultar_cliente(1)

-- COMMAND ----------

-- MAGIC %md ### D. Testar a função como ferramenta
-- MAGIC
-- MAGIC 1. No **menu principal** à esquerda, clique em **`Playground`**
-- MAGIC 2. Clique no **seletor de modelos** e selecione o modelo **`Meta Llama 3.1 70B Instruct`** (caso já não esteja selecionado)
-- MAGIC 3. Clique em **Tools** e depois em **Add Tool** 
-- MAGIC 4. Em **Hosted Function**, digite `academy.<seu_nome>.consultar_cliente` e `academy.<seu_nome>.revisar_avaliacao`
-- MAGIC 5. Adicione a instrução abaixo:<br>
-- MAGIC     `Gere uma resposta para o cliente 1 que está insatisfeito com a qualidade da tela do seu tablet. Não esqueça de customizar a mensagem com o nome do cliente.`
-- MAGIC 6. Clique no ícone **enviar**

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

-- MAGIC %md ## Exercício 03.03 - Pesquisando perguntas e respostas em uma base de conhecimento
-- MAGIC
-- MAGIC Agora, precisamos prepara uma função que nos permita aproveitar uma base de conhecimento para guiar as respostas do nosso agente.
-- MAGIC
-- MAGIC Para isso, utilizaremos o **Vector Search**. Este componente permite comparar as perguntas feitas pelo nosso cliente com as que estão na base de conhecimento e, então, recuperar a resposta correspondente à pergunta com maior similaridade. A única coisa que precisamos fazer é indexar o FAQ, que carregamos mais cedo, no Vector Search!
-- MAGIC
-- MAGIC Vamos lá!

-- COMMAND ----------

-- MAGIC %md ### A. Habilitar o Change Data Feed na tabela `FAQ`
-- MAGIC
-- MAGIC Essa configuração permite com que o Vector Search leia os dados inseridos, excluídos ou alterados no FAQ de forma incremental.

-- COMMAND ----------

ALTER TABLE faq SET TBLPROPERTIES (delta.enableChangeDataFeed = true)

-- COMMAND ----------

-- MAGIC %md ### B. Criar um índice no Vector Search
-- MAGIC
-- MAGIC 1. No **menu principal** à esquerda, clique em **`Catalog`**
-- MAGIC 2. Busque a sua **tabela** `academy.<seu_nome>.faq`
-- MAGIC 3. Clique em `Create` e depois em `Vector search index`
-- MAGIC 4. Preencha o formulário:
-- MAGIC     - **Nome:** faq_index
-- MAGIC     - **Primary key:** id
-- MAGIC     - **Endpoint**: selecione o endpoint desejado
-- MAGIC     - **Columns to sync:** deixar em branco (sincroniza todas as colunas)
-- MAGIC     - **Embedding source:** Compute embeddings (o Vector Search gerencia a indexação / criação de embeddings)
-- MAGIC     - **Embedding source column:** pergunta
-- MAGIC     - **Embedding model:** databricks-gte-large-en
-- MAGIC     - **Sync computed embeddings:** desabilitado
-- MAGIC     - **Sync mode:** Triggered
-- MAGIC 5. Clique em `Create`
-- MAGIC 6. Aguarde a criação do índice finalizar

-- COMMAND ----------

-- MAGIC %md ### C. Criar a função

-- COMMAND ----------

CREATE OR REPLACE FUNCTION consultar_faq(pergunta STRING)
RETURNS TABLE(id LONG, pergunta STRING, resposta STRING, search_score DOUBLE)
COMMENT 'Use esta função para consultar a base de conhecimento sobre prazos de entrega, pedidos de troca ou devolução, entre outras perguntas frequentes sobre o nosso marketplace'
RETURN select * from vector_search(
  index => 'academy.<seu_nome>.faq_index', 
  query => consultar_faq.pergunta,
  num_results => 1
)

-- COMMAND ----------

-- MAGIC %md ### D. Testar a função

-- COMMAND ----------

SELECT * FROM consultar_faq('Qual o prazo para devolução?')

-- COMMAND ----------

SELECT * FROM consultar_faq('Como emitir a segunda via?')

-- COMMAND ----------

-- MAGIC %md ### E. Testar a função como ferramenta
-- MAGIC
-- MAGIC 1. No **menu principal** à esquerda, clique em **`Playground`**
-- MAGIC 2. Clique no **seletor de modelos** e selecione o modelo **`Meta Llama 3.1 70B Instruct`** (caso já não esteja selecionado)
-- MAGIC 3. Clique em **Tools** e depois em **Add Tool** 
-- MAGIC 4. Em **Hosted Function**, digite `academy.<seu_nome>.consultar_faq`
-- MAGIC 5. Adicione a instrução abaixo:
-- MAGIC     ```
-- MAGIC     Qual o prazo para devolução?
-- MAGIC     ```
-- MAGIC 6. Clique no ícone **enviar**

-- COMMAND ----------

-- MAGIC %md ## Exercício 03.04 - Fornecendo recomendações personalizadas de produtos com base em suas descrições
-- MAGIC
-- MAGIC Por fim, também gostaríamos de criar uma ferramenta para auxiliar nossos clientes a encontrarem produtos que possuam descrições similares. Essa ferramenta irá auxiliar clientes que estejam insatisfeitos com algum produto e estejam buscando uma troca.
-- MAGIC
-- MAGIC Vamos lá!

-- COMMAND ----------

-- MAGIC %md ### A. Habilitar o Change Data Feed na tabela `produtos`

-- COMMAND ----------

ALTER TABLE produtos SET TBLPROPERTIES (delta.enableChangeDataFeed = true)

-- COMMAND ----------

-- MAGIC %md ### B. Criar um índice no Vector Search
-- MAGIC
-- MAGIC 1. No **menu principal** à esquerda, clique em **`Catalog`**
-- MAGIC 2. Busque a sua **tabela** `academy.<seu_nome>.produtos`
-- MAGIC 3. Clique em `Create` e depois em `Vector search index`
-- MAGIC 4. Preencha o formulário:
-- MAGIC     - **Nome:** produtos_index
-- MAGIC     - **Primary key:** id
-- MAGIC     - **Endpoint**: selecione o endpoint desejado
-- MAGIC     - **Columns to sync:** deixar em branco (sincroniza todas as colunas)
-- MAGIC     - **Embedding source:** Compute embeddings (o Vector Search gerencia a indexação / criação de embeddings)
-- MAGIC     - **Embedding source column:** descricao
-- MAGIC     - **Embedding model:** databricks-gte-large-en
-- MAGIC     - **Sync computed embeddings:** desabilitado
-- MAGIC     - **Sync mode:** Triggered
-- MAGIC 5. Clique em `Create`
-- MAGIC 6. Aguarde a criação do índice finalizar

-- COMMAND ----------

-- MAGIC %md ### C. Criar a função

-- COMMAND ----------

CREATE OR REPLACE FUNCTION buscar_produtos_semelhantes(descricao STRING)
RETURNS TABLE(id LONG, produto STRING, descricao STRING, search_score DOUBLE)
COMMENT 'Esta função recebe a descrição de um produto, que é utilizada para buscar produtos semelhantes'
RETURN SELECT * FROM vector_search(
  index => 'academy.<seu_nome>.produtos_index',
  query => buscar_produtos_semelhantes.descricao,
  num_results => 10)
WHERE search_score BETWEEN 0.003 AND 0.99
LIMIT 3

-- COMMAND ----------

-- MAGIC %md ### D. Testar a função

-- COMMAND ----------

SELECT * FROM buscar_produtos_semelhantes('O fone de ouvido DEF é um dispositivo de áudio projetado para fornecer uma experiência de som imersiva e de alta qualidade. Com drivers de alta fidelidade e tecnologia de cancelamento de ruído, ele permite que você se perca na música ou nos detalhes de um podcast sem distrações. Além disso, seu design ergonômico garante confort durante o uso prolongado.')

-- COMMAND ----------

-- MAGIC %md ### E. Testar a função como ferramenta
-- MAGIC
-- MAGIC 1. No **menu principal** à esquerda, clique em **`Playground`**
-- MAGIC 2. Clique no **seletor de modelos** e selecione o modelo **`Meta Llama 3.1 70B Instruct`** (caso já não esteja selecionado)
-- MAGIC 3. Clique em **Tools** e depois em **Add Tool** 
-- MAGIC 4. Em **Hosted Function**, digite `academy.<seu_nome>.buscar_produtos_semelhantes`
-- MAGIC 5. Adicione a instrução abaixo:
-- MAGIC     ```
-- MAGIC     Quais os tablets com boa qualidade da tela?
-- MAGIC     ```
-- MAGIC 6. Clique no ícone **enviar**

-- COMMAND ----------

-- MAGIC %md ## Exercício 03.05 - Testando nosso agente
-- MAGIC
-- MAGIC 1. No **menu principal** à esquerda, clique em **`Playground`**
-- MAGIC 2. Clique no **seletor de modelos** e selecione o modelo **`Meta Llama 3.1 70B Instruct`** (caso já não esteja selecionado)
-- MAGIC 3. Clique em **Tools** e depois em **Add Tool** 
-- MAGIC 4. Em **Hosted Function**, digite `academy.<seu_nome>.*` para adicionar todas as funções criadas
-- MAGIC 5. Em **System Prompt**, digite: <br>
-- MAGIC `Você é um assistente virtual de um e-commerce. Para responder à perguntas, é necessário que o cliente forneça seu CPF. Caso ainda não tenha essa informação, solicite o CPF educadamente. Você pode responder perguntas sobre entrega, devolução de produtos, status de pedidos, entre outros. Se você não souber como responder a pergunta, diga que você não sabe. Não invente ou especule sobre nada. Sempre que perguntado sobre procedimentos, consulte nossa base de conhecimento.`
-- MAGIC 6. Digite `Olá!`
-- MAGIC 7. Digite `000.000.000-01`
-- MAGIC 8. Digite `Comprei um tablet DEF, porém a qualidade da tela é muito ruim`
-- MAGIC 9. Digite `Poderia recomendar produtos semelhantes?`
-- MAGIC 10. Digite `Como faço para solicitar a troca?`

-- COMMAND ----------

-- MAGIC %md # Parabéns!
-- MAGIC
-- MAGIC Você concluiu o laboratório de **Agentes**!
-- MAGIC
-- MAGIC Agora, você já sabe como utilizar o Foundation Models, Playground e Unity Catalog Tools para prototipar de forma rápida e simplificada agentes capazes de responder precisamente a perguntas complexas!
