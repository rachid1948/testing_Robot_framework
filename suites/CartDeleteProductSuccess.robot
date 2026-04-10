*** Settings ***
Resource    ../conf/ImportRessource.robot
Resource    ../conf/SetupTeardown.robot
Test Setup    Open Browser And Login
Test Teardown     Close Application

*** Test Cases ***
TC1_Suppression totale produit
    [Tags]    TC1_CartDeletePage
    #Open Browser And Login
    Ensure Cart Is Empty
    Add Product To Cart    ${CATEGORY_TABLETS_LOCATOR}    ${PRODUCT_TABLET_A}
    Go To Cart
    Remove Product Via Remove Button
    Page Should Contain    ${EMPTY_MSG}
    #Close Browser


TC2_Suppression produit parmi plusieurs
    [Tags]    TC2_CartDeletePage
    Ensure Cart Is Empty
    Add Product To Cart    ${CATEGORY_TABLETS_LOCATOR}    ${PRODUCT_TABLET_A}
    Return To Shopping
    Add Product To Cart    ${CATEGORY_TABLETS_LOCATOR}    ${PRODUCT_TABLET_B}
    Go To Cart
    Remove Product Via Remove Button
    Page Should Contain    ${PRODUCT_TABLET_A}
    
 TC3_Suppression depuis popup panier
    [Tags]    TC3_CartDeletePage
    Ensure Cart Is Empty
    Add Product To Cart    ${CATEGORY_TABLETS_LOCATOR}    ${PRODUCT_TABLET_A}
    Wait Until Page Contains Element    ${POPUP_REMOVE}    timeout=10s
    Click Element    ${POPUP_REMOVE}
    Page Should Contain    ${EMPTY_MSG}

TC4_Suppression automatique quand quantité = 0 
    [Tags]    TC4_CartDeletePage   ANOMALIE
    Ensure Cart Is Empty
    Add Product To Cart    ${CATEGORY_TABLETS_LOCATOR}    ${PRODUCT_TABLET_A}
    Go To Cart
    Edit Product Quantity    0
    Page Should Not Contain    ${PRODUCT_TABLET_A}


TC5_Suppression totale produit - boucle CSV
    [Tags]    TC5_CartDeletePage
    ${content}=    Get File    ${CURDIR}/../data/remove_products.csv
    @{lines}=      Split To Lines    ${content}

    FOR    ${line}    IN    @{lines}
        @{data}=    Split String    ${line}    ,
        ${category}=    Set Variable    ${data[0]}
        ${product}=     Set Variable    ${data[1]}

        Log    Test avec ${category} - ${product}
        Ensure Cart Is Empty
        Add Product To Cart    ${category}    ${product}
        Go To Cart
        Remove Product Via Remove Button
        Page Should Contain    ${EMPTY_MSG} 
        #Aller à la home
        Go To    ${URL}
    END