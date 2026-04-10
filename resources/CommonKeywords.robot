*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    Collections


*** Keywords ***
Read Product List
    [Arguments]    ${PRODUCT_FILE}
    ${content}=    Get File    ${PRODUCT_FILE}
    @{lines}=       Split To Lines    ${content}
     RETURN   @{lines}

Read Login Credentials From TXT
    [Arguments]    ${txt_file}
    ${content}=    Get File    ${txt_file}
    @{lines}=    Split To Lines    ${content}
    @{credentials}=    Create List
    FOR    ${line}    IN    @{lines}
        ${line}=    Strip String    ${line}
        Run Keyword If    '${line}' == ''    Continue For Loop
        @{parts}=    Split String    ${line}
        ${len}=    Get Length    ${parts}
        Run Keyword Unless    ${len} >= 2    Continue For Loop
        ${username}=    Strip String    ${parts[0]}
        ${password}=    Strip String    ${parts[1]}
        ${cred}=    Create Dictionary    username=${username}    password=${password}
        Append To List    ${credentials}    ${cred}
    END
    [Return]    ${credentials}

Read Login Credentials From CSV
    [Arguments]    ${csv_file}
    ${content}=    Get File    ${csv_file}
    @{lines}=    Split To Lines    ${content}
    @{credentials}=    Create List
    FOR    ${line}    IN    @{lines}
        ${line}=    Strip String    ${line}
        Run Keyword If    '${line}' == ''    Continue For Loop
        @{parts}=    Split String    ${line}    ,    maxsplit=1
        ${len}=    Get Length    ${parts}
        Run Keyword Unless    ${len} == 2    Continue For Loop
        ${username}=    Strip String    ${parts[0]}
        ${password}=    Strip String    ${parts[1]}
        Run Keyword If    '${username.lower()}' == 'username'    Continue For Loop
        ${cred}=    Create Dictionary    username=${username}    password=${password}
        Append To List    ${credentials}    ${cred}
    END
    [Return]    ${credentials}

Read Login Credentials
    [Arguments]    ${file_path}
    @{parts}=    Split String    ${file_path}    .
    ${len}=    Get Length    ${parts}
    Run Keyword Unless    ${len} >= 2    Fail    Cannot determine file extension from ${file_path}
    ${ext}=    Set Variable    ${parts[-1]}
    ${ext}=    Convert To Lowercase    ${ext}
    IF    '${ext}' == 'txt'
        ${credentials}=    Read Login Credentials From TXT    ${file_path}
    ELSE IF    '${ext}' == 'csv'
        ${credentials}=    Read Login Credentials From CSV    ${file_path}
    ELSE
        Fail    Unsupported login file extension: ${ext}. Use .txt or .csv
    END
    [Return]    ${credentials}