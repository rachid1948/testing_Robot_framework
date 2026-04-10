*** Settings ***
Resource    ../conf/SetupTeardown.robot
Test Setup      Open Browser And Login
Test Teardown   Close Application

*** Variables ***

*** Test Cases ***
TC1 - Ajouter un produit avec la quantité par défaut
    [Documentation]    Ajouter HP PRO TABLET 608 G1 avec la quantité par défaut 1 et vérifier le compteur du panier
    Navigate To Product Page
    ${default_qty}=    Get Value    ${QTY_INPUT}
    Should Be Equal As Integers    ${default_qty}    1
    Click Add To Cart
    Verify Cart Counter Equals    1

TC2 - Vérifier le compteur après 4 ajouts
    [Documentation]    Cliquer sur ADD TO CART 4 fois et vérifier que le compteur est mis à jour après chaque ajout
    Navigate To Product Page
    Click Add To Cart
    Verify Cart Counter Equals    1
    Click Add To Cart
    Verify Cart Counter Equals    2
    Click Add To Cart
    Verify Cart Counter Equals    3
    Click Add To Cart
    Verify Cart Counter Equals    4

TC3 - Vérification du produit ajouté dans le panier
    [Documentation]    Vérifier que HP PRO TABLET 608 G1 apparaît bien dans le panier après ajout
    Navigate To Product Page
    Click Add To Cart
    Navigate To Cart Page
    ${name}=    Get Cart Product Name
    Should Be Equal    ${name}    ${PRODUCT_NAME}
    ${qty}=    Get Cart Item Quantity
    Should Be Equal As Integers    ${qty}    1
 