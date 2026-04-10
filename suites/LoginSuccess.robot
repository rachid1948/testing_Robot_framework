
*** Settings ***
Resource    ../Conf/SetupTearDown.robot

Suite Setup    Open Browser And Login
#Suite Teardown    Close Application
#Suite Teardown    Suite Teardown
Test Setup     Setup Test
Test Teardown  Teardown Test
*** Test Cases ***
Valid Login
    Given LoginPage.Open Login Page
    When LoginPage.I enter username    ahmed
    And LoginPage.I enter password    Ahmed1997
    And LoginPage.I click login button
    Then LoginPage.I should see successful login



