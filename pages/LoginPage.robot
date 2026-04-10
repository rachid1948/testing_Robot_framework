*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${USER_MENU}    //*[@id='menuUser']
${USERNAME_FIELD}    //input[@name='username']
${PASSWORD_FIELD}    //input[@name='password']
${Article_Table}    //article[@id='our_products']
${LOGIN_BUTTON}    //button[@id='sign_in_btn']
${SUCCESS_INDICATOR}    //span[@class='hi-user containMiniTitle ng-binding']  # Exemple : nom d'utilisateur affiché après connexion
${ERROR_MESSAGE}    //label[@id='signInResultMessage']  # Message d'erreur pour échec

*** Keywords ***
LoginPage.Open Login Page
    Wait Until Page Contains Element    ${Article_Table}    20s
    Wait Until Page Contains Element    ${USER_MENU}    10s
    Click Element    ${USER_MENU}
    Wait Until Element Is Visible    ${USERNAME_FIELD}    10s 
LoginPage.I enter username
    [Arguments]    ${username}
    Wait Until Page Contains Element    ${USERNAME_FIELD}    10s
    Input Text    ${USERNAME_FIELD}    ${username}

LoginPage.I enter password
    [Arguments]    ${password}
    Wait Until Page Contains Element    ${PASSWORD_FIELD}    10s
    Input Text    ${PASSWORD_FIELD}    ${password}

LoginPage.I click login button
    Wait Until Element Is Visible    ${LOGIN_BUTTON}    20s  # S'assurer que le bouton est cliquable
    Click Button    ${LOGIN_BUTTON}

LoginPage.I should see successful login
    Wait Until Page Contains Element    ${SUCCESS_INDICATOR}    10s
    ${success}=    Get Text    ${SUCCESS_INDICATOR}
    Log    Success indicator text: ${success}
    Log To Console    Success indicator text: ${success}

LoginPage.I should see login failure
    Wait Until Page Contains Element    ${ERROR_MESSAGE}    5s
    ${error}=    Get Text    ${ERROR_MESSAGE}
    Log    Login error message: ${error}
    Log To Console    Login error message: ${error}