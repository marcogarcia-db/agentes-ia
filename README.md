<img src="https://github.com/mousastech/agentes_ia/blob/a6db91737186d6d21d7808bb9950b154376d1d69/img/headertools_aiagents.png?raw=true" width=100%>

# Databricks AI Systems - Agentes de IA 

## Objective

Los LLM son excelentes para responder preguntas generales. Sin embargo, la inteligencia general por sí sola no es suficiente para ofrecer valor a sus clientes.

Para poder brindar respuestas valiosas, se requiere información adicional, específica de su negocio y del usuario que hace la pregunta (su ID de contrato de cliente, el último correo electrónico que enviaron a su soporte, su informe de ventas más reciente, etc.).

Los sistemas de IA componibles están diseñados para responder a este desafío. Son despliegues de IA más avanzados, compuestos por múltiples entidades (herramientas) especializadas en diferentes acciones (recuperar información o actuar sobre sistemas externos). <br/>

En un nivel alto, usted crea y presenta un conjunto de funciones personalizadas a la IA. Luego, el LLM puede razonar al respecto, decidir qué herramienta se debe utilizar y recopilar información para responder a las necesidades del cliente.

## Key Features

- Cree y almacene sus funciones (herramientas) aprovechando UC
- Ejecutar las funciones de forma segura.
- Razone sobre las herramientas que seleccionó y encadenélas para responder adecuadamente a su pregunta.

## Disclaimer

- Se requiere Unity Catalog
- Se requiere la criación de Vector Search
- Se requiere la utilización de LLMs

## Implementation Details

<img src="https://github.com/mousastech/agentes_ia/blob/e4602f57c4a83b171c7c541e11244136cdd80816/img/llm-call.png?raw=true" width="100%">

## Setup and Usage

1. Hacer el setup de las tablas (si aún no ha hecho) - notebook **Setup**
2. Correr el notebook para la criación de los componentes
3. Crear los índices en el Vector Search
