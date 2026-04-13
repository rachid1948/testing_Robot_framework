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
TC_SIGNUP_005_Password_Mismatch
	${data}=    Read Signup Data    ${SIGNUP_DATA_FILE}    3

	Navigate To Register Page

	Fill Username             ${data}[username]
	Fill Email                ${data}[email]
	Fill Password             ${data}[password]
	Fill Confirm Password     ${data}[confirm]
	Agree Terms

	Capture Full Screen       TC_SIGNUP_005_formulaire.png
	Should Show Password Mismatch Validation
	Capture Full Screen       TC_SIGNUP_005_resultat.png
