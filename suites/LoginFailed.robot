*** Settings ***
Resource    ../Conf/SetupTearDown.robot

Suite Setup    Open Browser And Login
Suite Teardown    Close Application
#Suite Teardown    Suite Teardown
Test Setup     Setup Test
Test Teardown  Teardown Test
*** Variables ***
 

*** Test Cases ***
Invalid Login
    Given LoginPage.Open Login Page
    When LoginPage.I enter username    invaliduser
    And LoginPage.I enter password    invalidpass
    And LoginPage.I click login button
    Then LoginPage.I should see login failure
Emty Login
    Given LoginPage.EmptyFields
    When LoginPage.I click login button
    Then LoginPage.I should see Field Required