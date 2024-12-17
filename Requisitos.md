
# Pré-Requisitos para o Hands-On:

* Trazer seu próprio **notebook**
* Ter acesso a um **workspace** Databricks
* Ter acesso a um **SQL Warehouse Serverless** ou **Pro**
* Ter acesso a um **Vector Search** endpoint
* Ter acesso a um **catálogo** com permissões de escrita
* Ter os **Foundation Models** habilitados
* Ter o **Unity Catalog** habilitado
* Ter o **Genie Spaces** habilitado
* Os participantes irão precisar das seguintes **permissões**:
    * `Workspace access` e `Databricks SQL access` no workspace
    * `CAN USE` no SQL Warehouse
    * `USE CATALOG`, `CREATE SCHEMA`, `CREATE FUNCTION` e `CREATE TABLE` no catálogo

</br></br>

# Configurando o ambiente:

***OBS: para configurar seu ambiente, são necessárias permissões de administração na sua conta Databricks, workspace e metastore do Unity Catalog.***

Para validar o atendimento aos pré-requisitos e configurar o seu ambiente, siga os passos abaixo:

1. Criando **grupo de usuários** para atribuição de permissões:
[[AWS](https://docs.databricks.com/en/admin/users-groups/groups.html#create-or-assign-a-group-to-a-workspace-using-the-workspace-admin-settings-page)][[Azure](https://learn.microsoft.com/en-us/azure/databricks/admin/users-groups/groups#create-or-assign-a-group-to-a-workspace-using-the-workspace-admin-settings-page)]

2. Adicionando **membros** ao grupo de usuários:
[[AWS](https://docs.databricks.com/en/admin/users-groups/groups.html#add-members-to-a-group-using-the-workspace-admin-settings-page)][[Azure](https://learn.microsoft.com/en-us/azure/databricks/admin/users-groups/groups#add-members-to-a-group-using-the-workspace-admin-settings-page)]

3. Autorizando acesso ao **workspace**:
[[AWS](https://docs.databricks.com/en/security/auth/entitlements.html#manage-entitlements-on-groups)][[Azure](https://learn.microsoft.com/en-us/azure/databricks/security/auth/entitlements#groups)]

4. Criando um **SQL Warehouse**:
[[AWS](https://docs.databricks.com/en/compute/sql-warehouse/create.html#create-a-sql-warehouse)][[Azure](https://learn.microsoft.com/en-us/azure/databricks/compute/sql-warehouse/create#create-a-sql-warehouse)]

5. Autorizando acesso ao **SQL Warehouse**:
[[AWS](https://docs.databricks.com/en/compute/sql-warehouse/create.html#manage-a-sql-warehouse)][[Azure](https://learn.microsoft.com/en-us/azure/databricks/compute/sql-warehouse/create#manage)]

6. Criando um **Vector Search** endpoint:
[[AWS](https://docs.databricks.com/en/generative-ai/create-query-vector-search.html#create-a-vector-search-endpoint-using-the-ui)][[Azure](https://learn.microsoft.com/en-us/azure/databricks/generative-ai/create-query-vector-search#create-a-vector-search-endpoint-using-the-ui)]

6. Criando e autorizando acesso a um **catálogo**:
[[AWS](https://docs.databricks.com/en/catalogs/create-catalog.html#create-a-catalog)][[Azure](https://learn.microsoft.com/en-us/azure/databricks/catalogs/create-catalog#create-a-catalog)]

7. Validando a disponibilidade de **Foundation Models**:
verifique se a coluna `AI Functions using Foundation Model APIs` da sua região está marcada como habilitada em: [[AWS](https://docs.databricks.com/en/resources/feature-region-support.html#ai-and-machine-learning-feature-availability)][[Azure](https://learn.microsoft.com/en-us/azure/databricks/resources/feature-region-support#ai-and-machine-learning)]

8. Habilitando o **Unity Catalog** em um workspace:
[[AWS](https://docs.databricks.com/en/data-governance/unity-catalog/enable-workspaces.html)][[Azure](https://learn.microsoft.com/en-us/azure/databricks/data-governance/unity-catalog/enable-workspaces)]

9. Habilitando o **Genie Spaces**:
[[AWS](https://docs.databricks.com/en/genie/index.html#enable-genie-spaces-in-your-workspace)][[Azure](https://learn.microsoft.com/en-us/azure/databricks/genie/#enable-genie)]

