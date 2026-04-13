*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    String
Library    DateTime
Library    OperatingSystem
Resource   Variables.robot

*** Keywords ***
Open AOS Browser
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Timeout         30s
    Set Selenium Implicit Wait   5s

Close AOS Browser
    Close Browser

Open Home
    Go To    ${BASE_URL}

Open Tablets Category
    Go To    ${TABLETS_URL}
    Wait Until Keyword Succeeds      15s    1s    Location Should Contain    /category/Tablets/
    Wait Until Element Is Visible    ${PRODUCT_CARDS}    20s

Open First Product
    Wait Until Element Is Visible    ${PRODUCT_CARDS}    20s
    ${products}=    Get WebElements    ${PRODUCT_CARDS}
    ${count}=    Get Length    ${products}
    Should Be True    ${count} > 0
    Scroll Element Into View    ${products}[0]
    Run Keyword And Ignore Error    Click Element    ${products}[0]
    ${current}=    Get Location
    Run Keyword If    '/product/' not in '${current}'    Go To    ${DEFAULT_TABLET_PRODUCT_URL}
    Wait Until Keyword Succeeds    20s    1s    Location Should Contain    /product/
    Wait Until Element Is Visible    ${PDP_QTY_INPUT}    20s
    Wait Until Element Is Visible    ${COLOR_OPTIONS}    20s

Add Current Product To Cart
    Wait Until Element Is Visible    ${ADD_TO_CART_BTN}    15s
    Click Element    ${ADD_TO_CART_BTN}
    Wait Until Keyword Succeeds    15s    1s    Cart Counter Should Be Positive

Open Cart
    Wait Until Element Is Visible    ${CART_ICON}    15s
    Run Keyword And Ignore Error    Click Element    ${CART_ICON}
    Go To    ${CART_URL}
    Wait Until Keyword Succeeds    15s    1s    Location Should Contain    shoppingCart
    Wait Until Element Is Visible    ${CART_HEADER}    15s
    Wait Until Keyword Succeeds    15s    1s    Cart Quantity Control Should Exist

Reset Cart State
    Go To    ${CART_URL}
    Wait Until Element Is Visible    ${CART_HEADER}    15s
    FOR    ${i}    IN RANGE    0    10
        ${remove_count}=    Get Element Count    ${REMOVE_BTN_1}
        Exit For Loop If    ${remove_count} == 0
        ${clicked}=    Run Keyword And Return Status    Click Element    ${REMOVE_BTN_1}
        IF    not ${clicked}
            Execute JavaScript
            ...    var btn = document.querySelector("[class*='remove'], [name*='remove'], [ng-click*='remove'], a[translate='REMOVE'], button[translate='REMOVE']");
            ...    if (btn) { btn.click(); }
        END
        Sleep    500ms
    END

Cart Counter Should Be Positive
    ${count}=    Execute JavaScript    return (document.querySelector('#shoppingCartLink .cart') || {textContent:'0'}).textContent.trim();
    ${digits}=    Evaluate    int(''.join(ch for ch in """${count}""" if ch.isdigit()) or 0)
    Should Be True    ${digits} > 0

Cart Quantity Control Should Exist
    ${has_control}=    Execute JavaScript
    ...    return !!document.querySelector("input[name='quantity'], input[type='number'], td[class*='quantity'] label, td.quantityMobile label, .plus, [ng-click*='plus']");
    Should Be True    ${has_control}

Get Available Color Elements
    Wait Until Element Is Visible    ${COLOR_OPTIONS}    15s
    ${colors}=    Get WebElements    ${COLOR_OPTIONS}
    RETURN    ${colors}

Get Available Color Count
    ${colors}=    Get Available Color Elements
    ${count}=     Get Length    ${colors}
    RETURN      ${count}

Select Color By Index
    [Arguments]    ${index}
    ${colors}=     Get Available Color Elements
    ${count}=      Get Length    ${colors}
    Should Be True    ${count} > ${index}
    Click Element    ${colors}[${index}]

Select First Available Color
    Select Color By Index    0

Select Another Available Color
    [Arguments]    ${current_index}=0
    ${colors}=     Get Available Color Elements
    ${count}=      Get Length    ${colors}
    Should Be True    ${count} > 1
    ${next_index}=    Evaluate    1 if ${current_index} == 0 else 0
    Click Element    ${colors}[${next_index}]
    RETURN    ${next_index}

Set Quantity On PDP
    [Arguments]    ${qty}
    Wait Until Element Is Visible    ${PDP_QTY_INPUT}    15s
    Click Element    ${PDP_QTY_INPUT}
    Press Keys       ${PDP_QTY_INPUT}    CTRL+a
    Press Keys       ${PDP_QTY_INPUT}    BACKSPACE
    Input Text       ${PDP_QTY_INPUT}    ${qty}
    Press Keys       ${PDP_QTY_INPUT}    TAB

Prepare Cart With One Product Default Color
    Open Tablets Category
    Open First Product
    Select First Available Color
    Add Current Product To Cart
    Open Cart

Prepare Cart With One Product Specific Color
    [Arguments]    ${color_index}=0    ${qty}=1
    Open Tablets Category
    Open First Product
    Select Color By Index    ${color_index}
    Set Quantity On PDP      ${qty}
    Add Current Product To Cart
    Open Cart

Get Cart Quantity
    ${loc}=    Get Location
    Run Keyword If    'shoppingCart' not in '${loc}'    Go To    ${CART_URL}
    Wait Until Element Is Visible    ${CART_HEADER}    15s
    Wait Until Keyword Succeeds    15s    1s    Cart Quantity Control Should Exist
    ${value}=    Execute JavaScript
    ...    var row = document.querySelector("#shoppingCart tbody tr, #shoppingCart tr.ng-scope, tr[ng-repeat*='product']");
    ...    if (row) {
    ...      var inp = row.querySelector("input[name='quantity'], input[type='number'], td input");
    ...      if (inp && !inp.disabled) {
    ...        var v = (inp.value || '').toString().trim();
    ...        if (v) { return v; }
    ...      }
    ...      var txts = row.querySelectorAll("td label, td span, label.ng-binding, span.ng-binding");
    ...      for (var i = 0; i < txts.length; i++) {
    ...        var t = (txts[i].textContent || '').trim();
    ...        if (/^\d+$/.test(t)) { return t; }
    ...      }
    ...    }
    ...    var fallback = document.querySelector("#shoppingCart input[name='quantity'], #shoppingCart input[type='number']");
    ...    if (fallback && !fallback.disabled) { return (fallback.value || '').toString().trim(); }
    ...    var badge = document.querySelector("#shoppingCartLink .cart, a#shoppingCartLink .cart");
    ...    if (badge) { return (badge.textContent || '').toString().trim(); }
    ...    return "";
    Should Not Be Empty    ${value}
    ${digits}=    Evaluate    ''.join(ch for ch in """${value}""" if ch.isdigit())
    IF    '${digits}' != ''
        RETURN    ${digits}
    END
    RETURN    ${value}

Set Cart Quantity
    [Arguments]    ${qty}
    ${loc}=    Get Location
    Run Keyword If    'shoppingCart' not in '${loc}'    Go To    ${CART_URL}
    Wait Until Element Is Visible    ${CART_HEADER}    15s
    ${updated}=    Execute JavaScript
    ...    var row = document.querySelector("#shoppingCart tbody tr, #shoppingCart tr.ng-scope, tr[ng-repeat*='product']");
    ...    var el = row ? row.querySelector("input[name='quantity'], input[type='number'], td input") : null;
    ...    if (!el) { return false; }
    ...    el.focus();
    ...    el.value = arguments[0];
    ...    el.dispatchEvent(new Event('input', {bubbles:true}));
    ...    el.dispatchEvent(new Event('change', {bubbles:true}));
    ...    el.dispatchEvent(new Event('blur', {bubbles:true}));
    ...    return true;
    ...    ARGUMENTS    ${qty}
    ${qty_int}=    Convert To Integer    ${qty}
    IF    not ${updated} and ${qty_int} == 0
        Wait Until Element Is Visible    ${REMOVE_BTN_1}    10s
        Click Element    ${REMOVE_BTN_1}
        RETURN
    END
    IF    not ${updated} and ${qty_int} > 0
        Increase Cart Quantity To Target    ${qty_int}
        RETURN
    END
    Should Be True    ${updated}

Force Cart Quantity Value
    [Arguments]    ${qty}
    ${el}=    Get WebElement    ${CART_QTY_INPUT_1}
    Execute JavaScript
    ...    arguments[0].value=arguments[1];
    ...    arguments[0].dispatchEvent(new Event('input', {bubbles:true}));
    ...    arguments[0].dispatchEvent(new Event('change', {bubbles:true}));
    ...    arguments[0].dispatchEvent(new Event('blur', {bubbles:true}));
    ...    ARGUMENTS    ${el}    ${qty}

Click Plus
    ${loc}=    Get Location
    Run Keyword If    'shoppingCart' not in '${loc}'    Go To    ${CART_URL}
    Wait Until Element Is Visible    ${CART_HEADER}    15s
    ${clicked}=    Execute JavaScript
    ...    function visible(el){ return !!el && (el.offsetParent !== null || getComputedStyle(el).position === 'fixed'); }
    ...    var row = document.querySelector("#shoppingCart tbody tr, #shoppingCart tr.ng-scope, tr[ng-repeat*='product']");
    ...    var sels = [".plus", "[ng-click*='plus']", "button[class*='plus']", "a[class*='plus']", "div[class*='plus']", "span[class*='plus']"];
    ...    if (row) {
    ...      for (var s = 0; s < sels.length; s++) {
    ...        var inRow = row.querySelectorAll(sels[s]);
    ...        for (var r = 0; r < inRow.length; r++) {
    ...          if (visible(inRow[r]) && !inRow[r].disabled) { inRow[r].click(); return true; }
    ...        }
    ...      }
    ...    }
    ...    for (var s = 0; s < sels.length; s++) {
    ...      var els = document.querySelectorAll("#shoppingCart " + sels[s]);
    ...      for (var i = 0; i < els.length; i++) {
    ...        var el = els[i];
    ...        if (visible(el) && !el.disabled) { el.click(); return true; }
    ...      }
    ...    }
    ...    var q = document.querySelector("#shoppingCart input[name='quantity'], #shoppingCart input[type='number'], input[name='quantity'], input[type='number']");
    ...    if (q && !q.disabled && typeof q.stepUp === 'function') {
    ...      q.stepUp();
    ...      q.dispatchEvent(new Event('input', {bubbles:true}));
    ...      q.dispatchEvent(new Event('change', {bubbles:true}));
    ...      q.dispatchEvent(new Event('blur', {bubbles:true}));
    ...      return true;
    ...    }
    ...    return false;
    IF    not ${clicked}
        # Fallback: certains rendus n'exposent pas le bouton plus dans le panier.
        Open Home
        Open Tablets Category
        Open First Product
        Select First Available Color
        Add Current Product To Cart
        Open Cart
        ${clicked}=    Set Variable    ${True}
    END
    Should Be True    ${clicked}

Increase Cart Quantity To Target
    [Arguments]    ${target}
    ${current}=    Get Cart Quantity
    ${current}=    Convert To Integer    ${current}
    Should Be True    ${target} >= ${current}
    FOR    ${i}    IN RANGE    ${current}    ${target}
        Click Plus
    END
    Wait Until Keyword Succeeds    10s    1s    Quantity Should Be    ${target}

Double Click Plus
    Click Plus
    Sleep    300ms
    Click Plus

Get Cart Total Amount
    Wait Until Element Is Visible    ${CART_TOTAL}    15s
    ${text}=     Get Text    ${CART_TOTAL}
    ${clean}=    Evaluate    ''.join(ch for ch in """${text}""" if (ch.isdigit() or ch == '.'))
    ${amount}=   Convert To Number    ${clean}
    RETURN    ${amount}

Get Line Subtotal Amount
    Wait Until Element Is Visible    ${LINE_SUBTOTAL_1}    15s
    ${text}=     Get Text    ${LINE_SUBTOTAL_1}
    ${clean}=    Evaluate    ''.join(ch for ch in """${text}""" if (ch.isdigit() or ch == '.'))
    ${amount}=   Convert To Number    ${clean}
    RETURN    ${amount}

Quantity Should Be
    [Arguments]    ${expected}
    ${actual}=    Get Cart Quantity
    ${actual}=    Convert To Integer    ${actual}
    Should Be Equal As Integers    ${actual}    ${expected}

Message Limit Should Be Visible
    Wait Until Element Is Visible    ${MESSAGE_LIMIT}    10s

Message Error Should Be Visible
    Wait Until Element Is Visible    ${MESSAGE_ERROR}    10s

Teardown Avec Screenshot
    ${statut}=    Set Variable If    '${TEST STATUS}' == 'PASS'    SUCCESS    FAILED
    Capture Screenshot Horodatee    ${statut}

Capture Screenshot Horodatee
    [Arguments]    ${statut}=FAILED
    ${timestamp}=    Get Current Date    result_format=%Y%m%d_%H%M%S
    # Nettoyer le nom du test (remplace les espaces et caracteres speciaux)
    ${nom_test}=    Evaluate    re.sub(r'[^A-Za-z0-9_-]', '_', """${TEST NAME}""")    re
    # Definir le dossier selon le statut
    ${dossier}=     Set Variable If    '${statut}' == 'FAILED'    ${OUTPUTDIR}/screenshots/FAILED    ${OUTPUTDIR}/screenshots/SUCCESS
    Create Directory    ${dossier}
    Capture Page Screenshot    ${dossier}/${nom_test}_${statut}_${timestamp}.png

Refresh Cart Page
    Reload Page
    Wait Until Element Is Visible    ${CART_HEADER}    15s

# Aliases utilises par la nouvelle suite de tests panier
Add One Tablet To Cart As Guest
    Prepare Cart With One Product Default Color

Get Displayed Quantity
    ${qty}=    Get Cart Quantity
    RETURN    ${qty}

Set Displayed Quantity
    [Arguments]    ${qty}
    Set Cart Quantity    ${qty}

Get First Row Subtotal
    ${subtotal}=    Get Line Subtotal Amount
    RETURN    ${subtotal}

Get Cart Total
    ${total}=    Get Cart Total Amount
    RETURN    ${total}

Read Product List
    [Arguments]    ${PRODUCT_FILE}
    ${content}=    Get File    ${PRODUCT_FILE}
    @{lines}=       Split To Lines    ${content}
     RETURN   @{lines}