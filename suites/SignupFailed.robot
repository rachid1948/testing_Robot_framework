*** Settings ***
Resource    ../Conf/SetupTearDown.robot
Resource    ../pages/SignupPage.robot

Suite Setup      Open Browser And Login
Suite Teardown   Close Application
Test Setup       Setup Test
Test Teardown    Teardown Test

*** Variables ***
${SIGNUP_DATA_FILE}    data/signup_data.csv

*** Test Cases ***
TC_SIGNUP_004_Username_Too_Short
    ${data}=    Read Signup Data    ${SIGNUP_DATA_FILE}    2

    Navigate To Register Page

    Fill Username             ${data}[username]
    Fill Email                ${data}[email]
    Fill Password             ${data}[password]
    Fill Confirm Password     ${data}[confirm]
    Agree Terms

    Capture Full Screen      TC_SIGNUP_004_formulaire.png
    Should Show Username Too Short Validation
    Capture Full Screen      TC_SIGNUP_004_resultat.png

*** Keywords ***
Capture Full Screen
    [Arguments]    ${file_name}
    Capture Page Screenshot    ${file_name}
