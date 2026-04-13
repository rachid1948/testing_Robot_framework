*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Resource   ImportRessource.robot

*** Keywords *** 

Open Browser And Login
    ${ROOT}=    Normalize Path    ${CURDIR}/..
    Create Directory    ${ROOT}/results/screenshots
    Create Directory    ${ROOT}/erreurs
    Set Screenshot Directory    ${ROOT}/results/screenshots
    Open Browser   ${URL}    ${BROWSER}
    Set Window Position    0    0
    Set Window Size    1920    1080

Capture Full Screen
    [Arguments]    ${file_name}
    Execute Javascript    window.scrollTo(0, 0)
    Set Window Position    0    0
    Set Window Size    1920    1080
    ${ROOT}=    Normalize Path    ${CURDIR}/..
    Set Screenshot Directory    ${ROOT}/results/screenshots
    Capture Page Screenshot    ${file_name}

Capture Error Screen
    [Arguments]    ${file_name}
    ${ROOT}=    Normalize Path    ${CURDIR}/..
    Set Screenshot Directory    ${ROOT}/erreurs
    Capture Page Screenshot    ${file_name}
    
Close Application
    Close All Browsers

Setup Test
    Log    Début du test

Teardown Test

    Teardown Avec Screenshot
    Log    Fin du test

    #Run Keyword If Test Failed    Capture Error Screen    selenium-failed-fullscreen.png
    

