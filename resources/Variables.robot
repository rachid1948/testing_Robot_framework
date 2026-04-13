*** Variables ***


${MAX_QTY_PER_COLOR}           10

# Navigation
${TABLETS_CATEGORY}            xpath=(//*[self::span or self::a][contains(normalize-space(.),'TABLETS') or contains(@href,'#/category/Tablets/3')])[1]
${PRODUCT_CARDS}               xpath=//li[contains(@ng-repeat,'product in')]//img
${ADD_TO_CART_BTN}             xpath=//button[@name='save_to_cart' or @id='save_to_cart' or contains(.,'ADD TO CART')]
${CART_ICON}                   xpath=//*[@id='shoppingCartLink' or contains(@class,'shoppingCart') or contains(@href,'shoppingCart')]
${CART_HEADER}                 xpath=//*[contains(text(),'SHOPPING CART') or contains(text(),'Shopping Cart')]

# Couleurs produit - Advantage Online Shopping
${COLOR_OPTIONS}               css=span.productColor

# Quantité PDP (product page)
${PDP_QTY_INPUT}               css=input[name='quantity']

# Quantité panier
${CART_QTY_INPUT_1}            css=input[name='quantity']
${FIRST_QTY_INPUT}             css=input[name='quantity']
${CART_ROWS}                   css=tr.ng-scope, tr[class*='roboto']
${PLUS_BTN_1}                  xpath=(//*[contains(@class,'plus') or contains(@ng-click,'plus') or normalize-space(text())='+'])[1]
${REMOVE_BTN_1}                xpath=(//*[contains(text(),'REMOVE') or contains(text(),'Remove') or contains(@class,'remove') or contains(@name,'remove')])[1]

# Totaux
${CART_TOTAL}                  xpath=//*[contains(text(),'TOTAL')]/following::*[1] | //*[@id='totalAmount']
${LINE_SUBTOTAL_1}             xpath=(//*[contains(@class,'price') or contains(@class,'total')])[1]

# Messages
${MESSAGE_LIMIT}               xpath=//*[contains(translate(normalize-space(.),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'max') or contains(translate(normalize-space(.),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'limit') or contains(translate(normalize-space(.),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'quantity')]
${MESSAGE_ERROR}               xpath=//*[contains(translate(normalize-space(.),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'error') or contains(translate(normalize-space(.),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'invalid')]
${BASE_URL}   https://advantageonlineshopping.com/
${TABLETS_URL}    https://advantageonlineshopping.com/#/category/Tablets/3
${CART_URL}       https://advantageonlineshopping.com/#/shoppingCart
${DEFAULT_TABLET_PRODUCT_URL}    https://advantageonlineshopping.com/#/product/16
${URL}        https://advantageonlineshopping.com/
${BROWSER}    chrome
${USERNAME}    asmae.said@gmail.com
${PASSWORD}    Password1234

# --- Timeouts ---
${PAGE_LOAD_TIMEOUT}    10s

# --- Messages ---
${EMPTY_MSG}   Your shopping cart is empty

