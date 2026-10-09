# language: pt
Feature: Catalogo de produtos e comportamento geral da API
    Eu Como consumidor da API da Verzel Store
    Quero consultar o catálogo e receber respostas padronizadas
    Para integrar com segurança

Scenario: Listar todos os produtos
    Given que a API está disponível em "https://verzel-store.qa-test-verzel-store.workers.dev/api"
    And que as requisições usam o cabeçalho "Content-Type: application/json"
    When envio GET para "/produtos"
    Then o status da resposta é 200
    And o corpo é uma lista com 8 produtos
    And cada produto possui os campos "id", "nome", "descricao", "categoria" e "preco"
    And o campo "preco" de cada produto é numérico

Scenario: Consultar produto existente pelo id
    Given que a API está disponível em "https://verzel-store.qa-test-verzel-store.workers.dev/api"
    And que as requisições usam o cabeçalho "Content-Type: application/json"
    When envio GET para "/produtos/<id>"
    Then o status da resposta é 200
    And o campo "id" é "<id>"
    And o campo "nome" é "<nome>"
    And o campo "preco" é <preco>

    Exemplos:
      | id   | nome                   | preco  |
      | P001 | Camiseta Essencial     | 59.9   |
      | P002 | Calça Jeans Slim       | 139.9  |
      | P003 | Tênis Casual Urbano    | 189.9  |
      | P004 | Boné Aba Curva         | 49.9   |
      | P005 | Mochila Urbana 20L     | 100    |
      | P006 | Kit 3 Pares de Meias   | 29.9   |
      | P007 | Jaqueta Corta-Vento    | 229.9  |
      | P008 | Garrafa Térmica 750ml  | 50     |


Scenario: Consultar produto com id inexistente
    Given que a API está disponível em "https://verzel-store.qa-test-verzel-store.workers.dev/api"
    And que as requisições usam o cabeçalho "Content-Type: application/json"
    When envio GET para "/produtos/<id>"
    Then o status da resposta é 404
    And o campo "erro.codigo" é "PRODUTO_NAO_ENCONTRADO"
    And o campo "erro.mensagem" não está vazio

    Exemplos:
      | id    |
      | P999  |
      | P000  |
      | XYZ   |
      | 0     |


Scenario: Consultar produto com id em minúsculas
    Given que a API está disponível em "https://verzel-store.qa-test-verzel-store.workers.dev/api"
    And que as requisições usam o cabeçalho "Content-Type: application/json"
    When envio GET para "/produtos/p001"
    Then registro o status e o corpo retornados para análise


Scenario: Acessar rota inexistente
    Given que a API está disponível em "https://verzel-store.qa-test-verzel-store.workers.dev/api"
    And que as requisições usam o cabeçalho "Content-Type: application/json"
    When envio GET para "<rota>"
    Then o status da resposta é 404
    And o campo "erro.codigo" é "ROTA_NAO_ENCONTRADA"

    Exemplos:
      | rota                |
      | /inexistente        |
      | /carrinho           |
      | /produtos/P001/foto |

Scenario: Usar método HTTP não permitido em rota existente
    Given que a API está disponível em "https://verzel-store.qa-test-verzel-store.workers.dev/api"
    And que as requisições usam o cabeçalho "Content-Type: application/json"
    When envio <metodo> para "<rota>"
    Then o status da resposta é 405
    And o campo "erro.codigo" é "METODO_NAO_PERMITIDO"

    Exemplos:
      | metodo | rota               |
      | POST   | /produtos          |
      | PUT    | /produtos/P001     |
      | DELETE | /produtos/P001     |
      | GET    | /carrinho/calcular |
      | GET    | /pedidos           |
      | PUT    | /pedidos           |


Scenario: Enviar corpo que não é um objeto JSON válido
    Given que a API está disponível em "https://verzel-store.qa-test-verzel-store.workers.dev/api"
    And que as requisições usam o cabeçalho "Content-Type: application/json"
    When envio POST para "<endpoint>" com o corpo bruto '<corpo>'
    Then o status da resposta é 400
    And o campo "erro.codigo" é "JSON_INVALIDO"

    Exemplos:
      | endpoint           | corpo                |
      | /carrinho/calcular | {itens: [             |
      | /carrinho/calcular | [1, 2, 3]            |
      | /carrinho/calcular | "texto"              |
      | /carrinho/calcular |                      |
      | /pedidos           | {"cliente": {        |
      | /pedidos           | [1, 2, 3]            |
      | /pedidos           |                      |

Scenario: Toda resposta de erro segue o formato padrão
    Given que a API está disponível em "https://verzel-store.qa-test-verzel-store.workers.dev/api"
    And que as requisições usam o cabeçalho "Content-Type: application/json"
    When envio GET para "/produtos/P999"
    Then o corpo possui o objeto "erro"
    And "erro" possui os campos "codigo" e "mensagem"
