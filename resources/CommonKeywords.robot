*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    Collections
Library    String


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
    RETURN   ${credentials}

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
    RETURN   ${credentials}

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
    RETURN   ${credentials}

Read Signup Data
    [Arguments]    ${csv_file}    ${line_index}=1
    ${content}=    Get File          ${csv_file}
    @{lines}=      Split To Lines    ${content}
    @{parts}=      Split String      ${lines}[${line_index}]    ,
    ${data}=       Create Dictionary
    ...    username=${parts}[0]
    ...    email=${parts}[1]
    ...    password=${parts}[2]
    ...    confirm=${parts}[3]
    RETURN    ${data}

Increment Username
    [Arguments]    ${username}
    ${new_username}=    Evaluate    (lambda u: (__import__('re').sub(r'(\\d+)$', lambda m: str(int(m.group(1)) + 1), u) if __import__('re').search(r'\\d+$', u) else u + '1'))('''${username}''')
    RETURN    ${new_username}

Increment Username In Signup CSV
    [Arguments]    ${csv_file}    ${line_index}=1
    ${content}=    Get File          ${csv_file}
    @{lines}=      Split To Lines    ${content}
    @{parts}=      Split String      ${lines}[${line_index}]    ,
    ${new_username}=    Increment Username    ${parts}[0]
    ${updated_line}=    Catenate    SEPARATOR=,    ${new_username}    ${parts}[1]    ${parts}[2]    ${parts}[3]
    ${lines_copy}=    Create List    @{lines}
    Set List Value    ${lines_copy}    ${line_index}    ${updated_line}
    ${new_content}=    Catenate    SEPARATOR=\n    @{lines_copy}
    Create File    ${csv_file}    ${new_content}
    RETURN    ${new_username}