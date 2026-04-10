
*** Settings ***
Resource    ../Conf/SetupTearDown.robot

Suite Setup    Open Browser And Login
#Suite Teardown    Close Application
#Suite Teardown    Suite Teardown
Test Setup     Setup Test
Test Teardown  Teardown Test
*** Test Cases ***
Login With All Credentials
    @{credentials}=    Read Login Credentials    data/Login.txt
    ${count}=    Get Length    ${credentials}
    Log To Console    Found ${count} login credentials in data/Login.txt
    FOR    ${cred}    IN    @{credentials}
        Log To Console    Testing with username: ${cred['username']} and password: ${cred['password']}
        Given LoginPage.Open Login Page
        When LoginPage.I enter username    ${cred['username']}
        And LoginPage.I enter password    ${cred['password']}
        And LoginPage.I click login button
        ${status}    ${message}=    Run Keyword And Ignore Error    LoginPage.I should see successful login
        Run Keyword If    '${status}' == 'FAIL'    Append To File    data/failed_logins.txt    ${cred['username']} ${cred['password']}\n
        Run Keyword If    '${status}' == 'FAIL'    Log To Console    Login failed for ${cred['username']} - saved to data/failed_logins.txt
        Go To    ${URL}
    END


