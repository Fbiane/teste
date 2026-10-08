# Automação de Testes WEB - Robot Framework

Esse projeto contém a automação de testes WEB utilizando **Robot Framework** e **SeleniumLibrary** para formulario de cadastro:

# Tecnologias utilizadas

- Python 
- Robot Framework 
- SeleniumLibrary
- Selenium WebDriver
- Google Chrome

---

# Pré-requisitos

- Python 
- Google Chrome 
- WebDriver compatível com o navegador


# Instalação das dependências

## Robot Framework

pip install robotframework

## SeleniumLibrary

pip install robotframework-seleniumlibrary

---

# Execução dos testes

Na raiz do projeto, executar:

python -m robot -d results tests/cadastro_usuario.robot



# Cenários automatizados

## C01 - Validar campo telefone

### Objetivo

Validar o comportamento do campo telefone ao informar um formato inválido.

### Fluxo executado

- Abrir página de cadastro;
- Preencher os dados necessários;
- Informar telefone em formato inválido;
- Acionar envio do formulário;
- Validar mensagem de validação 

### Resultado esperado

O sistema deve impedir o envio do formulário e apresentar uma mensagem informando que o formato do telefone não atende ao padrão esperado.

---

## C02 - Validar campo Email inválido

### Objetivo

Validar a regra de formato do campo de e-mail.

### Fluxo executado

- Abrir página de cadastro;
- Inserir e-mail em formato inválido;
- Tentar enviar o formulário;
- Validar mensagem de validação 

### Resultado esperado

O sistema deve impedir o envio e apresentar uma mensagem informando que o e-mail informado possui formato inválido.

---

## C03 - Validar limpeza dos campos após Refresh

### Objetivo

Validar o comportamento do botão Refresh do formulário.

### Fluxo executado

- Abrir página de cadastro;
- Preencher dados no formulário;
- Clicar no botão Refresh;
- Validar que os campos foram limpos.

### Resultado esperado

Após clicar no botão Refresh, os dados preenchidos devem ser removidos dos campos do formulário.

---

# Observações

Durante os testes exploratórios manuais foi identificado um defeito no campo **Country**:

- O campo possui obrigatoriedade de preenchimento;
- Porém não apresenta opções disponíveis para seleção;
- Esse comportamento impede a conclusão do cadastro.

Devido a esse bloqueio, o fluxo completo de cadastro não foi automatizado como cenário positivo, pois depende de uma funcionalidade atualmente indisponível na aplicação.

O defeito foi documentado separadamente na etapa de **Testes Exploratórios WEB**.



# Gravação da execução

A gravação da execução dos testes automatizados está disponibilizada junto ao projeto conforme solicitado no desafio.

2_automacao_web\evidencias