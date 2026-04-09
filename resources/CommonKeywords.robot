*** Settings ***
Library    SeleniumLibrary
Library     OperatingSystem


*** Keywords ***
Read Product List
    [Arguments]    ${PRODUCT_FILE}
    ${content}=    Get File    ${PRODUCT_FILE}
    @{lines}=       Split To Lines    ${content}
     RETURN   @{lines}