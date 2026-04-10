*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${PRODUCT_URL}              https://advantageonlineshopping.com/#/product/18
${PRODUCT_NAME}             HP PRO TABLET 608 G1
${QTY_INPUT}                xpath=//input[@name="quantity"]
${ADD_TO_CART_BTN}          xpath=//button[@name="save_to_cart"]
${CART_COUNTER}             css=#shoppingCartLink .cart.ng-binding
${CART_PRODUCT_NAME}        xpath=//label[@class="roboto-regular productName ng-binding"]
${CART_QTY_LABEL}           xpath=//td[contains(@class,"quantityMobile") and not(contains(@class,"ng-hide"))]//label[@class="ng-binding"]
${SHOPPING_CART_URL}        https://advantageonlineshopping.com/#/shoppingCart
${MENU_CART_ICON}           id=shoppingCartLink
${CART_PAGE_TITLE}          xpath=//h3[contains(@class,"roboto-regular") and contains(@class,"center") and contains(text(),"SHOPPING CART")]

*** Keywords ***
Navigate To Product Page
    Go To    ${PRODUCT_URL}
    Wait Until Page Contains    ${PRODUCT_NAME}    timeout=15s

Set Product Quantity
    [Arguments]    ${quantity}
    Wait Until Element Is Visible    ${QTY_INPUT}
    Execute JavaScript
    ...    var el = document.querySelector('input[name="quantity"]');
    ...    var scope = angular.element(el).scope();
    ...    scope.numAttr = ${quantity};
    ...    scope.$apply();

Click Add To Cart
    Wait Until Element Is Visible    ${ADD_TO_CART_BTN}
    Click Button    ${ADD_TO_CART_BTN}
    Sleep    1s

Get Cart Counter
    ${count}=    Execute JavaScript    return document.querySelector('#shoppingCartLink .cart').innerText.trim();
    RETURN    ${count}

Navigate To Cart Page
    Click Element    ${MENU_CART_ICON}
    Wait Until Element Is Visible    ${CART_PAGE_TITLE}    timeout=10s
    Sleep    2s

Get Cart Product Name
    Wait Until Element Is Visible    ${CART_PRODUCT_NAME}    timeout=10s
    ${name}=    Get Text    ${CART_PRODUCT_NAME}
    RETURN    ${name}

Get Cart Item Quantity
    Wait Until Element Is Visible    ${CART_QTY_LABEL}    timeout=10s
    ${qty}=    Get Text    ${CART_QTY_LABEL}
    RETURN    ${qty}

Verify Cart Counter Equals
    [Arguments]    ${expected}
    ${count}=    Get Cart Counter
    Should Be Equal As Integers    ${count}    ${expected}

Add To Cart N Times
    [Arguments]    ${times}
    FOR    ${i}    IN RANGE    ${times}
        Click Add To Cart
    END
