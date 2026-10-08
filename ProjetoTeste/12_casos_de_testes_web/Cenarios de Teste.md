**Cenário 01: Realizar cadastro com dados válidos**


Dado que o usuário acessou o formulário de cadastro na pagina: https://demo.automationtesting.in/Register.html

E preenche todos os campos obrigatórios com informações válidas

Quando clicar no botão "Submit"

Então o sistema deve concluir o cadastro com sucesso

E apresentar uma mensagem de confirmação ou redirecionar o usuário conforme o fluxo esperado.



**Cenário 02: Validar obrigatoriedade dos campos obrigatórios**


Dado que o usuário acessou a página de cadastro

Quando tentar enviar o formulário sem preencher os campos obrigatórios

Então o sistema deve impedir o envio do formulário

E destacar todos os campos obrigatórios não preenchidos

E apresentar mensagem informando quais campos precisam ser preenchidos.


**Cenário 03: Validar o formato dos campos Telefone e E-mail**


Dado que o usuário acessou a página de cadastro

E preenche corretamente todos os demais campos obrigatórios

Quando informar o e-mail "teste@gmail"

E informar o telefone "55929999"

E clicar no botão "Submit"

Então o sistema deve impedir o envio do formulário

E no campo destacar o erro indicando que o e-mail e telefone informados são inválidos

E exibir uma mensagem indicando o formato esperado para E-mail e telefone.

