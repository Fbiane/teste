*** Settings ***

Library    SeleniumLibrary

Resource    variables.robot


*** Keywords ***

Configurar ambiente de teste

    Set Selenium Speed    1s


Abrir navegador

    Open Browser
    ...    ${URL}
    ...    ${BROWSER}

    Maximize Browser Window

Fechar navegador

    Close All Browsers

Preencher formulario cadastro

    Input Text
    ...    xpath://input[@placeholder="First Name"]
    ...    ${FIRST_NAME}


    Input Text
    ...    xpath://input[@placeholder="Last Name"]
    ...    ${LAST_NAME}


    Input Text
    ...    xpath://textarea
    ...    Endereco Teste QA


    Input Text
    ...    xpath://input[@type="email"]
    ...    ${EMAIL_VALIDO}


    Input Text
    ...    xpath://input[@type="tel"]
    ...    ${PHONE}

Selecionar genero

    Click Element
    ...    xpath://input[@value="FeMale"]

Inserir email invalido

    Clear Element Text
    ...    xpath://input[@type="email"]


    Input Text
    ...    xpath://input[@type="email"]
    ...    ${EMAIL_INVALIDO}


Inserir telefone invalido

    Clear Element Text
    ...    xpath://input[@type="tel"]


    Input Text
    ...    xpath://input[@type="tel"]
    ...    ${PHONE_INVALIDO}

Clicar submit

    Scroll Element Into View
    ...    xpath://button[@id="submitbtn"]

    Sleep    1

    Execute JavaScript
    ...    document.getElementById('submitbtn').click()

Clicar refresh

    Execute Javascript
    ...    document.getElementById('Button1').click()

Validar campos limpos

    ${valor}=    Execute Javascript
    ...    return document.querySelector('input[placeholder="First Name"]').value;

    Should Be Empty
    ...    ${valor}


Validar erro email

       
    ${mensagem}=    Execute Javascript
    ...    return document.querySelector('input[type="email"]').validationMessage;

    Log    Mensagem exibida: ${mensagem}

    Should Not Be Empty
    ...    ${mensagem}

    Should Contain
    ...    ${mensagem}
    ...    @

Validar erro telefone

    ${mensagem}=    Execute Javascript
    ...    return document.querySelector('input[type="tel"]').validationMessage;

    Log    Mensagem: ${mensagem}

    Should Not Be Empty
    ...    ${mensagem}

Inserir dados obrigatorios email
    Input Text
    ...    xpath://input[@placeholder="First Name"]
    ...    ${FIRST_NAME}


    Input Text
    ...    xpath://input[@placeholder="Last Name"]
    ...    ${LAST_NAME}



Inserir dados obrigatorios telefone
    Input Text
    ...    xpath://input[@placeholder="First Name"]
    ...    ${FIRST_NAME}

    Input Text
    ...    xpath://input[@placeholder="Last Name"]
    ...    ${LAST_NAME}

    Input Text
    ...    xpath://input[@type="email"]
    ...    ${EMAIL_VALIDO}