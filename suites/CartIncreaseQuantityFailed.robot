*** Settings ***
Resource    ../resources/CommonKeywords.robot

Suite Setup       Open AOS Browser
Suite Teardown    Close AOS Browser
Test Setup        Reset Cart State
Test Teardown     Teardown Avec Screenshot

*** Test Cases ***
N01 - Quantite 11 Refusee Pour La Meme Couleur
    [Tags]    ANOMALIE_STOCK    KNOWN_ISSUE
    Open Tablets Category
    Open First Product
    Select Color By Index    0
    Set Quantity On PDP      11
    Add Current Product To Cart
    Open Cart

    ${current}=    Get Cart Quantity
    ${current}=    Convert To Integer    ${current}
    Should Be True    ${current} <= ${MAX_QTY_PER_COLOR}
    Run Keyword And Ignore Error    Message Limit Should Be Visible

N02 - Bouton Plus Bloque A 10 Pour La Meme Couleur
    [Tags]    ANOMALIE_STOCK    KNOWN_ISSUE
    Open Tablets Category
    Open First Product
    Select Color By Index    0
    Set Quantity On PDP      10
    Add Current Product To Cart
    Open Cart

    Quantity Should Be    10

    # Tentative d'augmenter encore la meme couleur depuis la PDP
    Open Home
    Open Tablets Category
    Open First Product
    Select Color By Index    0
    Set Quantity On PDP      1
    Add Current Product To Cart
    Open Cart

    ${current}=    Get Cart Quantity
    ${current}=    Convert To Integer    ${current}
    Should Be True    ${current} <= ${MAX_QTY_PER_COLOR}
    Run Keyword And Ignore Error    Message Limit Should Be Visible

TC21 - Suppression Produit Via Quantite Zero
    [Tags]    NEGATIVE
    Add One Tablet To Cart As Guest
    Set Displayed Quantity    0
    Sleep    1s
    ${row_count}=    Get Element Count    ${CART_ROWS}
    ${qty_count}=    Get Element Count    ${FIRST_QTY_INPUT}
    Should Be True    ${row_count} == 0 or ${qty_count} == 0

