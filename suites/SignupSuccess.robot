*** Settings ***
Resource    ../conf/SetupTeardown.robot
Resource    ../pages/SignupPage.robot

Suite Setup      Open Browser And Login
Suite Teardown   Close Application
Test Setup       Setup Test
Test Teardown    Teardown Test

*** Variables ***
${SIGNUP_DATA_FILE}    data/signup_data.csv

*** Test Cases ***
TC_SIGNUP_001_Register_With_Valid_Data
    # --- Mise à jour username puis lecture des données depuis le CSV ---
    Increment Username In Signup CSV    ${SIGNUP_DATA_FILE}    1
    ${data}=    Read Signup Data    ${SIGNUP_DATA_FILE}    1

    # --- Navigation vers la page d'inscription ---
    Navigate To Register Page

    # --- Remplissage du formulaire ---
    Fill Username             ${data}[username]
    Fill Email                ${data}[email]
    Fill Password             ${data}[password]
    Fill Confirm Password     ${data}[confirm]
    Agree Terms

    # --- Soumission ---
    Capture Full Screen                 TC_SIGNUP_001_formulaire.png
    Submit Registration
    
    # --- Vérification du résultat ---
    Should See Registration Success
    Capture Full Screen                 TC_SIGNUP_001_espace_user.png

