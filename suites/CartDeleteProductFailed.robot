*** Settings ***
Resource    ../conf/ImportRessource.robot
Resource    ../conf/SetupTeardown.robot
Test Setup    Open Browser And Login
Test Teardown     Close Application

*** Test Cases ***
TC6_Remove avec panier vide
    [Tags]    TC6_CartDeletePage    PANIER_VIDE
    #Open Browser And Login
    Ensure Cart Is Empty
    Go To Cart
    Page Should Contain    ${EMPTY_MSG}
    Page Should Not Contain Element    ${DELETE_BTN}

TC7_Edit avec panier vide
    [Tags]    TC7_CartDeletePage    PANIER_VIDE
    #Open Browser And Login
    Ensure Cart Is Empty
    Go To Cart
    Page Should Not Contain Element    ${EDIT_BTN}
