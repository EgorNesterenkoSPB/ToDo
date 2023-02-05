import XCTest

class ToDoUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }


    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        
        let registerButton = app.buttons["Register"]
        XCTAssertTrue(registerButton.exists)
        registerButton.tap()
        
        let loginTextField = app.textFields["Login"]
        XCTAssertTrue(loginTextField.exists)
        loginTextField.tap()
        loginTextField.typeText("TestLogin")
        
        
        let mailTextField = app/*@START_MENU_TOKEN@*/.textFields["Mail"]/*[[".scrollViews.textFields[\"Mail\"]",".textFields[\"Mail\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(mailTextField.exists)
        mailTextField.tap()
        mailTextField.typeText("test@mail.com")
        
        let passwordSecuryTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordSecuryTextField.exists)
        passwordSecuryTextField.tap()
        passwordSecuryTextField.typeText("ilovepizzA1")
        
        let confirmPasswordSecureTextField = app.secureTextFields["Confirm password"]
        XCTAssertTrue(confirmPasswordSecureTextField.exists)
        confirmPasswordSecureTextField.tap()
        confirmPasswordSecureTextField.typeText("ilovepizzA1")
        
        let confirmButton = app.buttons["Confirm"]
        XCTAssertTrue(confirmButton.exists)
        confirmButton.tap()
        
        
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
