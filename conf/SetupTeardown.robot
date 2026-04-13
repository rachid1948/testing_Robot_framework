*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Resource   ImportRessource.robot

*** Keywords *** 

Open Browser And Login
    ${ROOT}=    Normalize Path    ${CURDIR}/..
    Set Screenshot Directory    ${ROOT}/erreurs
    Open Browser   ${URL}    ${BROWSER}
    Maximize Browser Window
    
Close Application
    Close All Browsers

Setup Test
    Log    Début du test

Teardown Test
    Teardown Avec Screenshot
    Log    Fin du test
