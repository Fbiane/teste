**Relatório de Execução - Testes de API**


**Informações Gerais**

API Testada:

https://fakestoreapi.com/


Ferramenta utilizada:

Postman


**Cenários de Testes**


**CT01 - Consultar lista de produtos**


Tipo: Básico


Objetivo

Validar se a API retorna corretamente a lista de produtos cadastrados.


Cenário: Consultar lista de produtos cadastrados com sucesso

Dado que  realizar uma requisição GET para

Então a API deve retornar o status code 200

E deve retornar uma lista de produtos no formato JSON

E cada produto deve possuir os campos obrigatórios como id, title, price e category






**CT02 - Criar novo produto**

Tipo: Intermediário

Objetivo

Validar a criação de um novo produto através de uma requisição POST.


Cenário: Criar um novo produto com dados válidos

Dado que acesso a rota de inserção de produtos

E que foram informados dados válidos do produto

Quando realizar uma requisição POST

Então a API deve retornar o status code 200

E deve retornar o identificador do produto criado

E os dados enviados devem estar presentes na resposta




**CT03 - Atualizar produto existente**

Tipo: Intermediário

Objetivo

Validar atualização das informações de um produto existente.

Cenário: Atualizar informações de um produto existente

Dado que existe um produto cadastrado com ID válido

E que foram informados novos dados para atualização

Quando realizar uma requisição PUT

Então a API deve retornar o status code 200

E deve retornar os dados atualizados do produto

E os campos alterados devem possuir os novos valores enviados



**CT04 - Consulta carrinhos cadastrados**

Tipo:Básico

Objetivo

Validar o comportamento da API ao consultar carrinhos cadastrados


Cenário: Consultar lista de carrinhos cadastrados

Dado que existem carrinhos cadastrados na API

E que o serviço de carrinhos está disponível

Quando realizar uma requisição GET para "/carts"

Então a API deve retornar o status code 200

E deve retornar uma lista de carrinhos no formato JSON

E cada carrinho deve possuir os campos obrigatórios id, userId, date e products


**CT05 - Excluir produto**

Tipo: Avançado

Objetivo

Validar a exclusão de um produto existente através da API.

Cenário: Excluir produto existente

Dado que existe um produto cadastrado com ID válido

Quando realizar uma requisição DELETE

Então a API deve retornar o status code 200

E deve retornar a confirmação da operação

E os dados retornados devem corresponder ao produto removido



**CT06 - Consultar produtos por categoria**

Tipo:Avançado

Objetivo

Validar se a API retorna corretamente os produtos filtrados por uma categoria específica.


Cenário: Consultar produtos filtrados por categoria

Dado que existem produtos cadastrados na categoria informada

Quando realizar uma requisição GET para "/products/category/electronics"

Então a API deve retornar o status code 200

E deve retornar uma lista de produtos no formato JSON

E todos os produtos retornados devem pertencer à categoria informada

