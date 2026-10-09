# language: pt
Feature: Cálculo do carrinho com cupom e frete grátis (POST /api/carrinho/calcular)
    Eu Como cliente da Verzel Store
    Quero calcular meu carrinho com cupom e frete
    Para saber quanto vou pagar

  Scenario: Calcular carrinho com cupom válido e frete grátis (exemplo da documentação)
    Given um carrinho com os itens:
      | produtoId | quantidade |
      | P002      | 1          |
      | P004      | 2          |
    And o cupom "BEMVINDO10"
    When envio POST para "/carrinho/calcular"
    And o status da resposta é 200
    And "subtotal" é 239.70
    And "desconto" é 23.97
    And "frete" é 0.00
    And "freteGratis" é true
    And "valorFaltanteFreteGratis" é 0.00
    And "total" é 215.73
    And "cupom.aplicado" é true
    And "cupom.mensagem" é "Cupom aplicado: 10% de desconto nos produtos."

  Scenario: Cada item da resposta traz preço unitário, quantidade e total da linha
    Given um carrinho com os itens:
      | produtoId | quantidade |
      | P002      | 1          |
      | P004      | 2          |
    When envio POST para "/carrinho/calcular"
    Then o item "P002" possui nome "Calça Jeans Slim", precoUnitario 139.9, quantidade 1 e total 139.9
    And o item "P004" possui nome "Boné Aba Curva", precoUnitario 49.9, quantidade 2 e total 99.8

Scenario: Calcular subtotal, desconto, frete e total
    Given um carrinho com os itens "<itens>"
    And o cupom "<cupom>"
    When envio POST para "/carrinho/calcular"
    Then o status da resposta é 200
    And "subtotal" é <subtotal>
    And "desconto" é <desconto>
    And "frete" é <frete>
    And "freteGratis" é <freteGratis>
    And "valorFaltanteFreteGratis" é <faltante>
    And "total" é <total>

    Exemplos: Sem cupom
      | itens                | cupom | subtotal | desconto | frete | freteGratis | faltante | total  |
      | P005:1               |       | 100.00   | 0.00     | 19.90 | false       | 100.00   | 119.90 |
      | P006:1               |       | 29.90    | 0.00     | 19.90 | false       | 170.10   | 49.80  |
      | P007:1               |       | 229.90   | 0.00     | 0.00  | true        | 0.00     | 229.90 |
      | P001:5               |       | 299.50   | 0.00     | 0.00  | true        | 0.00     | 299.50 |

    Exemplos: Limite do frete grátis (CA06, CA07)
      | itens                | cupom | subtotal | desconto | frete | freteGratis | faltante | total  |
      | P005:2               |       | 200.00   | 0.00     | 0.00  | true        | 0.00     | 200.00 |
      | P004:1;P008:3        |       | 199.90   | 0.00     | 19.90 | false       | 0.10     | 219.80 |

    Exemplos: Com cupom BEMVINDO10 (CA01, CA08, CA09)
      | itens                | cupom      | subtotal | desconto | frete | freteGratis | faltante | total  |
      | P005:1               | BEMVINDO10 | 100.00   | 10.00    | 19.90 | false       | 100.00   | 109.90 |
      | P003:1               | BEMVINDO10 | 189.90   | 18.99    | 19.90 | false       | 10.10    | 190.81 |
      | P005:2               | BEMVINDO10 | 200.00   | 20.00    | 0.00  | true        | 0.00     | 180.00 |
      | P004:1;P008:3        | BEMVINDO10 | 199.90   | 19.99    | 19.90 | false       | 0.10     | 199.81 |
      | P001:5;P002:5        | BEMVINDO10 | 999.00   | 99.90    | 0.00  | true        | 0.00     | 899.10 |

    Exemplos: Arredondamento com 2 casas decimais (CA11)
      | itens                | cupom      | subtotal | desconto | frete | freteGratis | faltante | total  |
      | P001:3               |            | 179.70   | 0.00     | 19.90 | false       | 20.30    | 199.60 |
      | P001:3               | BEMVINDO10 | 179.70   | 17.97    | 19.90 | false       | 20.30    | 181.63 |
      | P001:1               | BEMVINDO10 | 59.90    | 5.99     | 19.90 | false       | 140.10   | 73.81  |


Scenario: A regra do frete grátis usa o subtotal antes do desconto (CA08)
    Given um carrinho com os itens:
      | produtoId | quantidade |
      | P005      | 2          |
    And o cupom "BEMVINDO10"
    When envio POST para "/carrinho/calcular"
    Then "freteGratis" é true
    And "frete" é 0.00
    And "total" é 180.00

Scenario: O desconto do cupom não incide sobre o frete (CA09)
    Given um carrinho com os itens:
      | produtoId | quantidade |
      | P005      | 1          |
    And o cupom "BEMVINDO10"
    When envio POST para "/carrinho/calcular"
    Then "desconto" é 10.00
    And "frete" é 19.90

Scenario: O valor faltante para o frete grátis nunca é negativo
    Given um carrinho com os itens:
      | produtoId | quantidade |
      | P007      | 5          |
    When envio POST para "/carrinho/calcular"
    Then "valorFaltanteFreteGratis" é 0.00

Scenario: O cálculo não grava nada e é repetível
    Given um carrinho com os itens:
      | produtoId | quantidade |
      | P005      | 1          |
    When envio POST para "/carrinho/calcular" duas vezes seguidas
    Then as duas respostas possuem exatamente os mesmos valores

Scenario: Código do cupom ignora maiúsculas/minúsculas e espaços nas pontas (CA02)
    Given um carrinho com os itens "P005:1"
    Arredondamento o cupom "<cupom>"
    When envio POST para "/carrinho/calcular"
    Then o status da resposta é 200
    And "cupom.aplicado" é true
    And "desconto" é 10.00
    And "total" é 109.90

    Exemplos:
      | cupom            |
      | BEMVINDO10       |
      | bemvindo10       |
      | BemVindo10       |
      | "  BEMVINDO10  " |
      | "  bemvindo10 "  |


Scenario: Cupom inexistente não aplica desconto (CA03)
    Given um carrinho com os itens "P005:1"
    And o cupom "<cupom>"
    When envio POST para "/carrinho/calcular"
    Then o status da resposta é 200
    And "cupom.aplicado" é false
    And "cupom.mensagem" é "Cupom inválido."
    And "desconto" é 0.00
    And "total" é 119.90

    Exemplos:
      | cupom           |
      | INVALIDO        |
      | BEMVINDO        |
      | BEMVINDO100     |
      | "BEMVINDO 10"   |
      | BEMVINDO10,X    |

Scenario: Cupom expirado não aplica desconto (CA04)
    Given um carrinho com os itens "P005:1"
    And o cupom "<cupom>"
    When envio POST para "/carrinho/calcular"
    Then o status da resposta é 200
    And "cupom.aplicado" é false
    And "cupom.mensagem" é "Cupom expirado."
    And "desconto" é 0.00
    And "total" é 119.90

    Exemplos:
      | cupom          |
      | VERAO2026      |
      | verao2026      |
      | " VERAO2026 "  |

Scenario: Cupom ausente ou vazio é tratado como sem cupom
    Given um carrinho com os itens "P005:1"
    And o campo cupom é <valor>
    When envio POST para "/carrinho/calcular"
    Then o status da resposta é 200
    And "desconto" é 0.00
    And "total" é 119.90

    Exemplos:
      | valor      |
      | ausente    |
      | null       |
      | ""         |

Scenario: Cupom com tipo de dado inesperado (apenas um cupom por vez, CA05)
    Given um carrinho com os itens "P005:1"
    And o campo cupom é <valor>
    When envio POST para "/carrinho/calcular"
    Then o desconto retornado não é superior a 10.00
    And registro o status e o corpo retornados para análise

    Exemplos:
      | valor                          |
      | ["BEMVINDO10", "VERAO2026"]    |
      | 123                            |
      | "   "                          |

Scenario: Quantidade válida por produto (limite de 5 unidades, CA10)
    Given um carrinho com os itens "P005:<quantidade>"
    When envio POST para "/carrinho/calcular"
    Then o status da resposta é 200
    And "subtotal" é <subtotal>

    Exemplos:
      | quantidade | subtotal |
      | 1          | 100.00   |
      | 4          | 400.00   |
      | 5          | 500.00   |

Scenario: Quantidade acima do máximo permitido é rejeitada
    Given um carrinho com os itens "P005:<quantidade>"
    When envio POST para "/carrinho/calcular"
    Then o status da resposta é 422
    And "erro.codigo" é "QUANTIDADE_MAXIMA_EXCEDIDA"
    And "erro.campo" é "itens[0].quantidade"

    Exemplos:
      | quantidade |
      | 6          |
      | 7          |
      | 100        |

Scenario: Quantidade que não é inteiro maior ou igual a 1 é rejeitada
    Given um carrinho cujo item "P005" tem quantidade <quantidade>
    When envio POST para "/carrinho/calcular"
    Then o status da resposta é 422
    And "erro.codigo" é "QUANTIDADE_INVALIDA"
    And "erro.campo" é "itens[0].quantidade"

    Exemplos:
      | quantidade |
      | 0          |
      | -1         |
      | 1.5        |
      | "2"        |
      | "abc"      |
      | null       |

Scenario: O erro de quantidade aponta o índice do item problemático
    Given um carrinho com os itens:
      | produtoId | quantidade |
      | P001      | 1          |
      | P002      | 6          |
    When envio POST para "/carrinho/calcular"
    Then o status da resposta é 422
    And "erro.codigo" é "QUANTIDADE_MAXIMA_EXCEDIDA"
    And "erro.campo" é "itens[1].quantidade"

Scenario: Lista de itens ausente ou vazia
    Given um corpo de requisição com "itens" <valor>
    When envio POST para "/carrinho/calcular"
    Then o status da resposta é 422
    And "erro.codigo" é "ITENS_OBRIGATORIOS"

    Exemplos:
      | valor    |
      | ausente  |
      | []       |
      | null     |

Scenario: Item que não é um objeto com produtoId e quantidade
    Given um corpo de requisição com "itens" igual a <itens>
    When envio POST para "/carrinho/calcular"
    Then o status da resposta é 422
    And "erro.codigo" é "ITEM_INVALIDO"

    Exemplos:
      | itens                          |
      | ["P001"]                       |
      | [null]                         |
      | [{}]                           |
      | [{"produtoId": "P001"}]        |
      | [{"quantidade": 1}]            |

Scenario: Item referencia produto inexistente
    Given um carrinho com os itens:
      | produtoId | quantidade |
      | P999      | 1          |
    When envio POST para "/carrinho/calcular"
    Then o status da resposta é 422
    And "erro.codigo" é "PRODUTO_NAO_ENCONTRADO"

Scenario: Mesmo produto repetido na lista de itens
    Given um carrinho com os itens:
      | produtoId | quantidade |
      | P001      | 1          |
      | P001      | 2          |
    When envio POST para "/carrinho/calcular"
    Then o status da resposta é 422
    And "erro.codigo" é "ITEM_DUPLICADO"

Scenario: Produto repetido cuja soma ultrapassa 5 unidades
    Given um carrinho com os itens:
      | produtoId | quantidade |
      | P001      | 3          |
      | P001      | 3          |
    When envio POST para "/carrinho/calcular"
    Then o status da resposta é 422
    And registro o código de erro retornado para análise

Scenario: Combinações de erros na mesma requisição
    Given um corpo de requisição com <situacao>
    When envio POST para "/carrinho/calcular"
    Then registro o status e o código de erro retornados para análise

    Exemplos:
      | situacao                                              |
      | cupom inválido e quantidade 6                         |
      | produto inexistente e quantidade 0                    |
      | "itens" como texto "P001" em vez de lista             |
