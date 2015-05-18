//
//  M13Checkbox.h
//
/*Copyright (c) 2014 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import <UIKit/UIKit.h>

#define M13CheckboxDefaultHeight 24.0

#define kBoxRadius 0.1875
#define kBoxStrokeWidth 0.05

/**
 The posible states of the checkbox.
 */
typedef NS_ENUM(NSInteger, M13CheckboxState) {
    M13CheckboxStateUnchecked = NO, //Default
    M13CheckboxStateChecked = YES,
    M13CheckboxStateMixed
};


/**
 Where the box is located in comparison to the text.
 */
typedef NS_ENUM(NSInteger, M13CheckboxAlignment) {
    M13CheckboxAlignmentLeft,
    M13CheckboxAlignmentRight //Default
};

#define M13CheckboxHeightAutomatic CGFLOAT_MAX

/**
 A custom checkbox control for iOS.
 */
@interface M13Checkbox : UIControl

/**@name Properties*/
/**
 The label that displays the text for the checkbox.
 */
@property (nonatomic, retain) UILabel *titleLabel;
/**
 The current state of the checkbox
 */
@property (nonatomic, assign) M13CheckboxState checkState;
/**
 The alignment of the check box. Wether the box is to the right or left of the text.
 */
@property (nonatomic, assign) M13CheckboxAlignment checkAlignment UI_APPEARANCE_SELECTOR;
/**
 A manual setting to set the height of the checkbox. If set to M13CheckboxHeightAutomatic, the check will fill the height of the control.
 */
@property (nonatomic, assign) CGFloat checkHeight UI_APPEARANCE_SELECTOR;
/**
 The location of the checkbox inside of the main control.
 */
@property (nonatomic, readonly) CGRect checkboxFrame;

/**@name Values*/
/**
 The object to return from `- (id)value` method when the checkbox is checked.
 */
@property (nonatomic, retain) id checkedValue;
/**
 The object to return from `- (id)value` method when the checkbox is unchecked.
 */
@property (nonatomic, retain) id uncheckedValue;
/**
 The object to return from `- (id)value` method when the checkbox is mixed.
 */
@property (nonatomic, retain) id mixedValue;
/**
 Returns one of the three "value" properties depending on the checkbox state. This is a convenience method so that if one has a large group of checkboxes, it is not necessary to write: if (someCheckbox == thatCheckbox) { if (someCheckbox.checkState == ......
 
 @return The value coresponding to the checkbox state.
 */
- (id)value;

/**@name Initalization*/
/**
 Initalize the checkbox with the defaults.
 
 @return A new checkbox control.
 */
- (id)init;
/**
 Initalize the checkbox cell with a custom frame size. The checkbox height will be the height of the frame.
 
 @param frame The frame to create the checkbox with.
 
 @return A new checkbox control.
 */
- (id)initWithFrame:(CGRect)frame;
/**
 Initalizes the checkbox cell with the default height, and a width to fit the text given.
 
 @param title The title to display in the checkbox.
 
 @return A new checkbox control.
 */
- (id)initWithTitle:(NSString *)title;
/**
 Initalizes the checkbox with the default check height, and a custom frame size and title.
 
 @param frame    The frame to initalize the checkbox cell with.
 @param title    The title to display.
 
 @return A new checkbox control.
 */
- (id)initWithFrame:(CGRect)frame title:(NSString *)title;
/**
 Initalizes the checkbox with a custom frame size, title, and check height.
 
 @param frame    The frame to initalize the checkbox cell with.
 @param title    The title to display.
 @param checkHeight The height of the checkbox.
 
 @return A new checkbox control.
 */
- (id)initWithFrame:(CGRect)frame title:(NSString *)title checkHeight:(CGFloat)checkHeight;

/**@name Actions*/
/**
 Change the state of the check programatically.
 
 @param state The state to change the checkbox to.
 */
- (void)setCheckState:(M13CheckboxState)state;//Change state programitically
/**
 Toggle the check state between unchecked and checked.
 */
- (void)toggleCheckState;
/**
 Sets the font size, so that the label text is the same height as the checkbox.
 */
- (void)autoFitFontToHeight;
/**
 Sets the with of the checkbox so that all the text can fit on one line.
 */
- (void)autoFitWidthToText;
/**
 Returns the shape to be displayed in the checkbox when the check state is "checked".
 
 @note To use a custom shape, create a subclass of M13Checkbox, and override this method. See the method for more details.
 
 @return A UIBezierPath representing the shape to render when the checkbox is checked.
 */
- (UIBezierPath *)getDefaultShape;

/**@name Appearance*/
/**
 Wether or not to draw the check box flat, without a glossy overlay.
 */
@property (nonatomic, assign) BOOL flat UI_APPEARANCE_SELECTOR;
/**
 The width of the stroke around the box.
 */
@property (nonatomic, assign) CGFloat strokeWidth UI_APPEARANCE_SELECTOR;
/**
 The color of the stroke around the box.
 */
@property (nonatomic, retain) UIColor *strokeColor UI_APPEARANCE_SELECTOR;
/**
 The color of the check.
 */
@property (nonatomic, retain) UIColor *checkColor UI_APPEARANCE_SELECTOR;
/**
 The color to fill the box with when checked.
 */
@property (nonatomic, retain) UIColor *tintColor UI_APPEARANCE_SELECTOR;
/**
 The color of the box when unchecked.
 */
@property (nonatomic, retain) UIColor *uncheckedColor UI_APPEARANCE_SELECTOR;
/**
 The corner radius of the box.
 */
@property (nonatomic, assign) CGFloat radius UI_APPEARANCE_SELECTOR; 

@end
