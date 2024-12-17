<img src="https://github.com/mousastech/agentes_ia/blob/a6db91737186d6d21d7808bb9950b154376d1d69/img/headertools_aiagents.png?raw=true" width=100%>

# Databricks AI Systems - Agentes de IA 

## Objetivo

Os LLMs são excelentes para responder perguntas gerais. No entanto, a inteligência geral por si só não é suficiente para oferecer valor aos seus clientes.

Para poder fornecer respostas valiosas, é necessária informação adicional, específica do seu negócio e do usuário que faz a pergunta (seu ID de contrato de cliente, o último e-mail que enviaram ao seu suporte, seu relatório de vendas mais recente, etc.).

Os sistemas de IA componíveis são projetados para responder a esse desafio. São implantações de IA mais avançadas, compostas por múltiplas entidades (ferramentas) especializadas em diferentes ações (recuperar informações ou atuar sobre sistemas externos).

Em um nível alto, você cria e apresenta um conjunto de funções personalizadas à IA. Em seguida, o LLM pode raciocinar sobre isso, decidir qual ferramenta deve ser utilizada e coletar informações para responder às necessidades do cliente.

## Características Principais

- Crie e armazene suas funções (ferramentas) aproveitando o UC
- Execute as funções de forma segura
- Raciocine sobre as ferramentas que selecionou e encadeie-as para responder adequadamente à sua pergunta

## Aviso

- Unity Catalog é necessário
- A criação de Vector Search é necessária
- A utilização de LLMs é necessária

## Detalhes de Implementação

<img src="https://github.com/mousastech/agentes_ia/blob/e4602f57c4a83b171c7c541e11244136cdd80816/img/llm-call.png?raw=true" width="100%">

## Configuração e Uso

1. Fazer a configuração das tabelas (se ainda não foi feito) - notebook **Setup**
2. Executar o notebook para a criação dos componentes
3. Criar os índices no Vector Search

Citations:
[1] https://github.com/mousastech/agentes_ia/blob/a6db91737186d6d21d7808bb9950b154376d1d69/img/headertools_aiagents.png?raw=true
