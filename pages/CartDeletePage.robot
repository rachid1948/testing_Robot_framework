*** Settings ***
Resource    ../resources/variables.robot
Library     SeleniumLibrary
Library     OperatingSystem

*** Variables ***
# --- Cart locators ---
${CART_ICON}    xpath=//a[@id='shoppingCartLink']
${CART_ITEM}    xpath=//tr[contains(@class,'ng-scope')]
${DELETE_BTN}   xpath=//a[contains(@class,'remove')]
${EDIT_BTN}     xpath=//a[contains(@class,'edit')]
${QTY_INPUT}    xpath=//input[@name='quantity']
${POPUP_REMOVE}   xpath=//a[@class='removeProduct']
${TOTAL_LABEL}   xpath=//span[@class='roboto-medium totalValue']
${CART_TITLE}    xpath=//*[normalize-space()='SHOPPING CART']
# --- Popup / navigation ---
${CONTINUE_BTN}    xpath=//button[contains(.,'CONTINUE SHOPPING')]
${ITEMS_COUNT}     xpath=//li[contains(.,'ITEMS')]

# --- Product locators ---
${PRODUCT_NAME_LOCATOR}    xpath=//*[normalize-space()='{}']
${ADD_TO_CART_BTN}         xpath=//button[@name='save_to_cart']

# --- Categories ---
${CATEGORY_TABLETS_LOCATOR}    xpath=//div[@id='tabletsImg']

# --- Products (JDD) ---
${PRODUCT_TABLET_A}    HP Elite x2 1011 G1 Tablet
${PRODUCT_TABLET_B}    HP Pro Tablet 608 G1 Tablet


*** Keywords ***
#Open Browser And Login
#    Open Browser    ${BASE_URL}    ${BROWSER}
#    Maximize Browser Window

Go To Cart
    Click Element    ${CART_ICON}
    Wait Until Page Contains Element    ${CART_TITLE}     ${PAGE_LOAD_TIMEOUT}
    Wait Until Page Contains Element    ${ITEMS_COUNT}    ${PAGE_LOAD_TIMEOUT}


Ensure Cart Is Empty
    Go To Cart
    ${is_empty}=    Run Keyword And Return Status
    ...    Page Should Contain    ${EMPTY_MSG}
    IF    not ${is_empty}
        Empty Cart Completely
    END

Empty Cart Completely
    WHILE    Run Keyword And Return Status
    ...       Page Should Contain Element    ${DELETE_BTN}
        Click Element    ${DELETE_BTN}
        Sleep    1s
    END
    Page Should Contain    ${EMPTY_MSG}

Add Product To Cart
    [Arguments]    ${category_locator}    ${product_name}
    #Aller à la home
    Go To    ${URL}
    #Cliquer sur la catégorie
    Wait Until Element Is Visible    ${category_locator}    ${PAGE_LOAD_TIMEOUT}
    Click Element                     ${category_locator}
    #Cliquer sur le produit 
    ${product_locator}=    Format String    ${PRODUCT_NAME_LOCATOR}    ${product_name}
    Wait Until Page Contains Element    ${product_locator}    ${PAGE_LOAD_TIMEOUT}
    Click Element                       ${product_locator}
    #Ajouter au panier
    Wait Until Page Contains Element    ${ADD_TO_CART_BTN}    ${PAGE_LOAD_TIMEOUT}
    Click Element                       ${ADD_TO_CART_BTN}

Return To Shopping
    Wait Until Element Is Visible    ${CONTINUE_BTN}    ${PAGE_LOAD_TIMEOUT}
    Click Element                    ${CONTINUE_BTN}

Remove Product Via Remove Button
    Click Element    ${DELETE_BTN}

Remove Product Via Popup
    Click Element    ${POPUP_REMOVE}

Edit Product Quantity
    [Arguments]    ${quantity}
    Click Element    ${EDIT_BTN}
    # Sélectionner tout le texte (Ctrl+A)
    Press Keys    ${QTY_INPUT}    CTRL+A
    # Supprimer la valeur existante
    Press Keys    ${QTY_INPUT}    DELETE
    # Entrer la nouvelle valeur
    Input Text    ${QTY_INPUT}    ${quantity}
    # Valider
    Press Keys    ${QTY_INPUT}    ENTER
    Sleep    1s

Get Cart Total
    ${total}=    Get Text    ${TOTAL_LABEL}
    RETURN    ${total}