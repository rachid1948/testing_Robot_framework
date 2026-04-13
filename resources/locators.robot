*** Variables ***
${USER_ICON}               id=menuUserLink
${LOADER}                  css=div.loader
${CREATE_ACCOUNT_LINK}     css=a.create-new-account
${USERNAME_INPUT}          name=usernameRegisterPage
${EMAIL_INPUT}             name=emailRegisterPage
${PASSWORD_INPUT}          name=passwordRegisterPage
${CONFIRM_INPUT}           name=confirm_passwordRegisterPage
${AGREE_CHECKBOX}          name=i_agree
${REGISTER_BTN}            id=register_btn
${USERNAME_MINLEN_ERROR}   xpath=//label[contains(@class,'invalid') and contains(normalize-space(.),'Use 5 character or longer')]
${SIGNUP_SUCCESS_INDICATOR}    xpath=//span[@class='hi-user containMiniTitle ng-binding']
${SIGNUP_ERROR_MSG}            css=span.regErrorLogin
