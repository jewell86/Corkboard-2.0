import XCTest

class CollectionViewUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
        
        try super.tearDownWithError()
    }
    
    func test_addImage() {
        // Open image picker
        let addButton = app.buttons["addImageButton"]
        XCTAssertTrue(addButton.exists)
        addButton.tap()
        
        // Find and tap the first image in the photo library
        let firstPhoto = app.scrollViews.otherElements.images.element(boundBy: 0)
        XCTAssertTrue(firstPhoto.waitForExistence(timeout: 5))
        firstPhoto.tap()

        // Verify the new image is added
        let newImage = app.images["imageView_\(2)"]
        XCTAssertTrue(newImage.waitForExistence(timeout: 5))
    }

    func test_editNote() {
        // Tap note
        let noteView = app.staticTexts["noteView_\(2)"]
        XCTAssertTrue(noteView.exists)
        noteView.tap()
        
        let alert = app.alerts["Edit Note"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5))
        
        // Edit note
        let textField = alert.textFields["Note text"]
        XCTAssertTrue(textField.exists)
        textField.tap()
        textField.typeText(" Updated")
        
        // Save note
        let saveButton = alert.buttons["Save"]
        XCTAssertTrue(saveButton.exists)
        saveButton.tap()
        
        // Verify note is edited
        XCTAssertTrue(app.staticTexts["Note 2 Updated"].exists)
    }
    
    func test_dragAndDropNote() {
        let firstNoteID = "1"
        let secondNoteID = "2"
        let firstNote = app.staticTexts["noteView_\(firstNoteID)"]
        let secondNote = app.staticTexts["noteView_\(secondNoteID)"]
        XCTAssertTrue(firstNote.exists)
        XCTAssertTrue(secondNote.exists)

        let start = firstNote.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        let end = secondNote.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        
        // Drag note
        start.press(forDuration: 1.0, thenDragTo: end)

        // Verify drag and drop has been performed by checking the new positions
        XCTAssertEqual(firstNote.frame.origin.x, secondNote.frame.origin.x)
        XCTAssertEqual(firstNote.frame.origin.y, secondNote.frame.origin.y)
    }
}
