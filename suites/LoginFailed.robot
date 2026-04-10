*** Settings ***
Resource    ../Conf/SetupTearDown.robot

Suite Setup    Open Browser And Login
Suite Teardown    Close Application

Test Setup     Setup Test
Test Teardown  Teardown Test
*** Variables ***
 

*** Test Cases ***
Invalid Login
    @{credentials}=    Read Login Credentials    data/failed_logins.txt
    ${count}=    Get Length    ${credentials}
    Log To Console    Found ${count} login credentials in data/failed_logins.txt
    FOR    ${cred}    IN    @{credentials}
        Log To Console    Testing with username: ${cred['username']} and password: ${cred['password']}
        Given LoginPage.Open Login Page
        When LoginPage.I enter username    ${cred['username']}
        And LoginPage.I enter password    ${cred['password']}
        And LoginPage.I click login button
        Then LoginPage.I should see login failure
        Go To    ${URL}
    END
Empty Login
    Given LoginPage.EmptyFields
    When LoginPage.I click login button
    Then LoginPage.I should see Field Required