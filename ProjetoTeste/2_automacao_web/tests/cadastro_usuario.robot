*** Settings ***

Library    SeleniumLibrary

Resource    ../resources/keywords.robot
Resource    ../resources/variables.robot

Suite Setup       Configurar ambiente de teste
Suite Teardown    Fechar navegador


*** Test Cases ***

C01 - Validar campo telefone

    Abrir navegador

    Inserir dados obrigatorios telefone

    Inserir telefone invalido

    Clicar submit

    Validar erro telefone

    Fechar navegador

C02 - Validar campo Email invalido

    Abrir navegador

    Inserir dados obrigatorios email

    Inserir email invalido

    Clicar submit

    Validar erro email

    Fechar navegador

C03 - Validar limpeza dos campos apos refresh

    Abrir navegador

    Preencher formulario cadastro

    Selecionar genero    

    Clicar refresh

    Validar campos limpos

    Fechar navegador