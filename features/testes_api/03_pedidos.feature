Feature: Confirmação de pedidos (POST /api/pedidos)
    Eu Como cliente da Verzel Store
    Quero confirmar meu pedido com cupom e frete corretos
    Para finalizar minha compra com pagamento na entrega

Scenario: Confirmar pedido com cupom válido (exemplo da documentação)
    Given um pedido com os itens:
      | produtoId | quantidade |
      | P005      | 1          |
    And o cupom "BEMVINDO10"
    When envio POST para "/pedidos"
    Then o status da resposta é 201
    And "numero" segue o formato "VZ-" seguido de 6 dígitos
    And "subtotal" é 100.00
    And "desconto" é 10.00
    And "frete" é 19.90
    And "freteGratis" é false
    And "valorFaltanteFreteGratis" é 100.00
    And "total" é 109.90
    And "cupom.aplicado" é true

Scenario: Confirmar pedido sem cupom
    Given um pedido com os itens:
      | produtoId | quantidade |
      | P005      | 1          |
    When envio POST para "/pedidos"
    Then o status da resposta é 201
    And "desconto" é 0.00
    And "frete" é 19.90
    And "total" é 119.90

Scenario: Confirmar pedido com frete grátis e cupom
    Given um pedido com os itens:
      | produtoId | quantidade |
      | P002      | 1          |
      | P004      | 2          |
    And o cupom "BEMVINDO10"
    When envio POST para "/pedidos"
    Then o status da resposta é 201
    And "subtotal" é 239.70
    And "desconto" é 23.97
    And "frete" é 0.00
    And "freteGratis" é true
    And "total" é 215.73

Scenario: A resposta do pedido traz criado Em, cliente normalizado e itens
    Given um pedido com os itens:
      | produtoId | quantidade |
      | P005      | 1          |
    When envio POST para "/pedidos"
    Then "criadoEm" é uma data e hora válida no formato ISO 8601
    And "cliente.nome" é "Maria Silva"
    And "cliente.email" é "maria@exemplo.com"
    And "cliente.cep" é "01310100"
    And "itens" possui 1 item com produtoId "P005"

Scenario: Os valores do pedido são idênticos aos do cálculo do carrinho
    Given um pedido com os itens:
      | produtoId | quantidade |
      | P003      | 1          |
    And o cupom "BEMVINDO10"
    When envio POST para "/carrinho/calcular" 
    And POST para "/pedidos" com os mesmos itens e cupom
    Then "subtotal", "desconto", "frete", "freteGratis", "valorFaltanteFreteGratis" e "total" são iguais nas duas respostas
    And "total" é 190.81

Scenario: Pedido nos limites do frete grátis
    Given um pedido com os itens "<itens>"
    And o cupom "<cupom>"
    When envio POST para "/pedidos"
    Then o status da resposta é 201
    And "frete" é <frete>
    And "total" é <total>

    Exemplos:
      | itens          | cupom      | frete | total  |
      | P005:2         |            | 0.00  | 200.00 |
      | P004:1;P008:3  |            | 19.90 | 219.80 |
      | P005:2         | BEMVINDO10 | 0.00  | 180.00 |
      | P004:1;P008:3  | BEMVINDO10 | 19.90 | 199.81 |

Scenario: Cupom informado com variação de caixa e espaços é aceito no pedido (CA02)
    Given um pedido com os itens "P005:1"
    And o cupom "<cupom>"
    When envio POST para "/pedidos"
    Then o status da resposta é 201
    And "desconto" é 10.00

    Exemplos:
      | cupom            |
      | bemvindo10       |
      | "  BEMVINDO10  " |

Scenario: Pedidos não são armazenados e podem ser repetidos
    Given um pedido com os itens:
      | produtoId | quantidade |
      | P005      | 1          |
    When envio POST para "/pedidos" duas vezes seguidas
    Then as duas respostas possuem status 201
    And ambas possuem "numero" no formato "VZ-000000"

Scenario: Pedido com cupom inexistente é rejeitado (CA03)
    Given um pedido com os itens "P005:1"
    And o cupom "<cupom>"
    When envio POST para "/pedidos"
    Then o status da resposta é 422
    And "erro.codigo" é "CUPOM_INVALIDO"
    And nenhum número de pedido é retornado

    Exemplos:
      | cupom    |
      | INVALIDO |
      | BEMVINDO |

Scenario: Pedido com cupom expirado é rejeitado (CA04)
    Given um pedido com os itens "P005:1"
    And o cupom "<cupom>"
    When envio POST para "/pedidos"
    Then o status da resposta é 422
    And "erro.codigo" é "CUPOM_EXPIRADO"
    And nenhum número de pedido é retornado

    Exemplos:
      | cupom         |
      | VERAO2026     |
      | verao2026     |
      | " VERAO2026 " |

Scenario: Pedido com quantidade acima de 5 unidades é rejeitado (CA10)
    Given um pedido com os itens "P001:<quantidade>"
    When envio POST para "/pedidos"
    Then o status da resposta é 422
    And "erro.codigo" é "QUANTIDADE_MAXIMA_EXCEDIDA"
    And "erro.campo" é "itens[0].quantidade"

    Exemplos:
      | quantidade |
      | 6          |
      | 50         |

Scenario: Pedido com exatamente 5 unidades de um produto é aceito (CA10)
    Given um pedido com os itens "P001:5"
    When envio POST para "/pedidos"
    Then o status da resposta é 201
    And "subtotal" é 299.50

Scenario: Pedido com quantidade inválida
    Given um pedido cujo item "P001" tem quantidade <quantidade>
    When envio POST para "/pedidos"
    Then o status da resposta é 422
    And "erro.codigo" é "QUANTIDADE_INVALIDA"

    Exemplos:
      | quantidade |
      | 0          |
      | -3         |
      | 2.5        |
      | "1"        |

Scenario: Pedido com itens inválidos
    Given um pedido com <situacao>
    When envio POST para "/pedidos"
    Then o status da resposta é 422
    And "erro.codigo" é "<codigo>"

    Exemplos:
      | situacao                         | codigo                 |
      | itens ausentes                   | ITENS_OBRIGATORIOS     |
      | lista de itens vazia             | ITENS_OBRIGATORIOS     |
      | item que é apenas o texto "P001" | ITEM_INVALIDO          |
      | produto P999                     | PRODUTO_NAO_ENCONTRADO |
      | produto P001 repetido            | ITEM_DUPLICADO         |

Scenario: Dados de cliente válidos são aceitos
    Given um pedido com os itens "P005:1"
    And o cliente com nome "<nome>", e-mail "<email>" e CEP "<cep>"
    When envio POST para "/pedidos"
    Then o status da resposta é 201
    And "cliente.cep" é "<cepNormalizado>"

    Exemplos:
      | nome                | email                | cep       | cepNormalizado |
      | Maria Silva         | maria@exemplo.com    | 01310-100 | 01310100       |
      | Maria Silva         | maria@exemplo.com    | 01310100  | 01310100       |
      | Ana Paula de Souza  | ana.paula@mail.com.br| 69000-000 | 69000000       |

Scenario: Nome sem sobrenome é rejeitado
    Given um pedido com os itens "P005:1"
    And o cliente com nome "<nome>", e-mail "maria@exemplo.com" e CEP "01310-100"
    When envio POST para "/pedidos"
    Then o status da resposta é 422
    And "erro.codigo" é "DADOS_INVALIDOS"
    And "campos" informa o campo "nome"

    Exemplos:
      | nome    |
      | Maria   |
      | ""      |
      | "   "   |
      | "Maria "|

Scenario: E-mail com formato inválido é rejeitado
    Given um pedido com os itens "P005:1"
    And o cliente com nome "Maria Silva", e-mail "<email>" e CEP "01310-100"
    When envio POST para "/pedidos"
    Then o status da resposta é 422
    And "erro.codigo" é "DADOS_INVALIDOS"
    And "campos" informa o campo "email"

    Exemplos:
      | email               |
      | maria               |
      | maria@              |
      | @exemplo.com        |
      | maria@@exemplo.com  |
      | maria exemplo@x.com |
      | ""                  |
      
Scenario: E-mail sem domínio de topo
    Given um pedido com os itens "P005:1"
    And o cliente com nome "Maria Silva", e-mail "maria@exemplo" e CEP "01310-100"
    When envio POST para "/pedidos"
    Then registro o status e o corpo retornados para análise

Scenario: CEP fora do padrão de 8 dígitos é rejeitado
    Given um pedido com os itens "P005:1"
    And o cliente com nome "Maria Silva", e-mail "maria@exemplo.com" e CEP "<cep>"
    When envio POST para "/pedidos"
    Then o status da resposta é 422
    And "erro.codigo" é "DADOS_INVALIDOS"
    And "campos" informa o campo "cep"

    Exemplos:
      | cep         |
      | 0131010     |
      | 013101000   |
      | 01310-10    |
      | 013-10100   |
      | ABCDE-FGH   |
      | 01310 100   |
      | ""          |

Scenario: Vários dados de cliente inválidos são reportados juntos
    Given um pedido com os itens "P005:1"
    And o cliente com nome "Maria", e-mail "maria" e CEP "123"
    When envio POST para "/pedidos"
    Then o status da resposta é 422
    And "erro.codigo" é "DADOS_INVALIDOS"
    And "campos" informa os campos "nome", "email" e "cep"

Scenario: Objeto cliente ausente ou com tipo inesperado
    Given um pedido com os itens "P005:1"
    And o campo cliente é <valor>
    When envio POST para "/pedidos"
    Then registro o status e o corpo retornados para análise
    And o pedido não deve ser confirmado com status 201

    Exemplos:
      | valor    |
      | ausente  |
      | null     |
      | {}       |
      | "Maria"  |

Scenario: Precedência entre erros de cliente, cupom e itens
    Given um pedido com cliente inválido, cupom "VERAO2026" e quantidade 6
    When envio POST para "/pedidos"
    Then registro o código de erro retornado para análise
