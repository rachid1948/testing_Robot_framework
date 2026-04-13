*** Settings ***
Resource    ../resources/CommonKeywords.robot

Suite Setup       Open AOS Browser
Suite Teardown    Close AOS Browser
Test Setup        Reset Cart State
Test Teardown     Teardown Avec Screenshot

*** Test Cases ***
P01 - Quantite 10 Autorisee Pour Une Couleur
    Open Tablets Category
    Open First Product
    Select First Available Color
    Set Quantity On PDP    10
    Add Current Product To Cart
    Open Cart
    Quantity Should Be    10

P02 - Meme Produit Autre Couleur Encore 10 Autorise
    Open Tablets Category
    Open First Product

    # Couleur 1
    Select Color By Index    0
    Set Quantity On PDP      10
    Add Current Product To Cart

    # Revenir sur produit
    Open Home
    Open Tablets Category
    Open First Product

    ${color_count}=    Get Available Color Count
    Should Be True     ${color_count} > 1

    # Couleur 2 (différente)
    ${second_index}=   Select Another Available Color    0
    Should Not Be Equal As Integers    ${second_index}    0
    Set Quantity On PDP    10
    Add Current Product To Cart

    Open Cart
    Quantity Should Be    20

TC01 - Incrementation Standard
    Add One Tablet To Cart As Guest
    ${before}=    Get Displayed Quantity
    ${before}=    Convert To Integer    ${before}
    Click Plus
    Wait Until Keyword Succeeds    10s    1s    Quantity Should Be    ${before + 1}

TC02 - Modification Manuelle De La Quantite
    Add One Tablet To Cart As Guest
    Set Displayed Quantity    3
    Wait Until Keyword Succeeds    10s    1s    Quantity Should Be    3

TC05 - Nouvelle Modification Apres Mise A Jour
    Add One Tablet To Cart As Guest
    Set Displayed Quantity    2
    Wait Until Keyword Succeeds    10s    1s    Quantity Should Be    2
    Set Displayed Quantity    4
    Wait Until Keyword Succeeds    10s    1s    Quantity Should Be    4

TC12 - Mise A Jour Du Sous Total Produit
    Add One Tablet To Cart As Guest
    ${subtotal_before}=    Get First Row Subtotal
    ${qty_before}=    Get Displayed Quantity
    ${qty_before}=    Convert To Integer    ${qty_before}
    Click Plus
    Wait Until Keyword Succeeds    10s    1s    Quantity Should Be    ${qty_before + 1}
    ${subtotal_after}=    Get First Row Subtotal
    Should Be True    ${subtotal_after} >= ${subtotal_before}

TC13 - Mise A Jour Du Total Panier
    Add One Tablet To Cart As Guest
    ${total_before}=    Get Cart Total
    ${qty_before}=    Get Displayed Quantity
    ${qty_before}=    Convert To Integer    ${qty_before}
    Click Plus
    Wait Until Keyword Succeeds    10s    1s    Quantity Should Be    ${qty_before + 1}
    ${total_after}=    Get Cart Total
    Should Be True    ${total_after} >= ${total_before}

TC15 - Persistance Apres Refresh
    Add One Tablet To Cart As Guest
    Set Displayed Quantity    3
    Wait Until Keyword Succeeds    10s    1s    Quantity Should Be    3
    Refresh Cart Page
    Quantity Should Be    3

TC19 - Double Clic Rapide Sur Plus
    Add One Tablet To Cart As Guest
    ${before}=    Get Displayed Quantity
    ${before}=    Convert To Integer    ${before}
    Double Click Plus
    ${after}=    Get Displayed Quantity
    ${after}=    Convert To Integer    ${after}
    Should Be True    ${after} == ${before + 1} or ${after} == ${before + 2}

