*** Settings ***
Resource    ../conf/SetupTeardown.robot
Test Setup      Open Browser And Login
Test Teardown   Close Application

*** Variables ***

*** Test Cases ***
TC4 - Tenter d'ajouter un produit avec la quantité 0
    [Documentation]    Saisir 0 dans le champ quantité, cliquer sur ADD TO CART et vérifier que le produit n'est pas ajouté au panier
    Navigate To Product Page
    Set Product Quantity    0
    Click Add To Cart
    Verify Cart Counter Equals    0

TC5 - Tenter d'ajouter un produit avec la quantité 99
    [Documentation]    Saisir 99 dans le champ quantité, cliquer sur ADD TO CART et vérifier que la quantité dans le panier est plafonnée à 10 (maximum autorisé par le site)
    Navigate To Product Page
    Set Product Quantity    99
    Click Add To Cart
    Navigate To Cart Page
    ${qty}=    Get Cart Item Quantity
    Should Be Equal As Integers    ${qty}    10
 