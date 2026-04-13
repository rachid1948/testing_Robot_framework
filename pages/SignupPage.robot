*** Settings ***
Library     SeleniumLibrary
Resource    ../resources/locators.robot

*** Keywords ***
Navigate To Register Page
    Execute Javascript               document.getElementById('menuUserLink').click()
    Wait Until Element Is Visible    ${CREATE_ACCOUNT_LINK}    timeout=10s
    Execute Javascript               document.querySelector('a.create-new-account').click()
    Wait Until Element Is Visible    ${USERNAME_INPUT}    timeout=10s

Fill Username
    [Arguments]    ${username}
    Input Text    ${USERNAME_INPUT}    ${username}

Fill Email
    [Arguments]    ${email}
    Input Text    ${EMAIL_INPUT}    ${email}

Fill Password
    [Arguments]    ${password}
    Input Text    ${PASSWORD_INPUT}    ${password}

Fill Confirm Password
    [Arguments]    ${confirm}
    Input Text    ${CONFIRM_INPUT}    ${confirm}
    Press Keys    ${CONFIRM_INPUT}    TAB
    Wait Until Element Is Visible    ${AGREE_CHECKBOX}    timeout=5s

Agree Terms
    Click Element    ${AGREE_CHECKBOX}

Submit Registration
    Click Button    ${REGISTER_BTN}

Should See Registration Success
    Wait Until Page Contains Element    ${SIGNUP_SUCCESS_INDICATOR}    15s
    Wait Until Keyword Succeeds    15x    1s    Should Be In User Space
    ${text}=    Get Text    ${SIGNUP_SUCCESS_INDICATOR}
    Log To Console    Inscription réussie : ${text}

Should Be In User Space
    ${url}=    Get Location
    Should Not Contain    ${url}    register
    ${form_visible}=    Run Keyword And Return Status
    ...    Page Should Contain Element    ${USERNAME_INPUT}
    Run Keyword If    ${form_visible}    Fail    La page Register est encore affichée.

Should See Registration Error
    Wait Until Page Contains Element    ${SIGNUP_ERROR_MSG}    10s
    ${text}=    Get Text    ${SIGNUP_ERROR_MSG}
    Log To Console    Erreur inscription : ${text}

Should Show Username Too Short Validation
    Wait Until Page Contains Element    ${USERNAME_MINLEN_ERROR}    5s
    ${text}=    Get Text    ${USERNAME_MINLEN_ERROR}
    Should Contain    ${text}    5 character or longer
    ${is_disabled}=    Run Keyword And Return Status    Element Should Be Disabled    ${REGISTER_BTN}
    Log To Console    Username invalide (<5) : ${text}
    Log To Console    Register disabled: ${is_disabled}

Should Show Password Mismatch Validation
    ${has_error}=    Run Keyword And Return Status
    ...    Wait Until Page Contains Element    ${SIGNUP_ERROR_MSG}    5s
    IF    ${has_error}
        ${text}=    Get Text    ${SIGNUP_ERROR_MSG}
        Log To Console    Password mismatch: ${text}
    ELSE
        ${confirm_class}=    Get Element Attribute    ${CONFIRM_INPUT}    class
        Should Contain    ${confirm_class}    invalid
        Log To Console    Password mismatch détecté via classe confirm password: ${confirm_class}
    END
