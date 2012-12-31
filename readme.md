M13Checkbox
============

A customizable checkbox for iOS that mimics the checkbox found on OS X, and Safari.

Features:
----------
* Simple to setup, just initialize with the desired parameters, and add to your subview.
* Many customizable settings to make it easy to seamlessly integrate with your app.
* All appearance settings follow the UIAppearance protocol.
* Can be a standalone checkbox, or add a title.
* Easy setup for any string. Just initialize with a string, and M13Checkbox will figure out the width for you.
* The height can be changed.
*You can add your own shape if desired!
*No images! Everything is drawn with code!

![screenshot](https://raw.github.com/Marxon13/M13Checkbox/master/Screenshot.png "screenshot") 

Initialization:
----------
* <code>- (id)init</code>:Creates a checkbox with the default height, and no text.
* <code>- (id)initWithFrame:(CGRect)frame</code>: Creates a checkbox with the specified frame, and no text. The box will just fill the height of the frame.
* <code>- (id)initWithTitle:(NSString *)title</code>: Creates a checkbox with the default height, and the specified text. The width of the frame will be changed to make the text fit.
* <code>- (id)initWithTitle:(NSString *)title andHeight:(CGFloat)height</code>: Creates a checkbox with the height specified, and the given text. The width of the frame will be changed to make the text fit.

Properties:
-----------
* <code>M13CheckboxState checkState</code>: There are three checkbox states available:
    * M13CheckboxStateUnchecked (default)
    * M13CheckboxStateChecked
    * M13CheckboxStateMixed
* <code>(UILabel *)titleLabel</code>: The title label will appear if one sets a string for it to display. The label will fill the control's frame minus the frame of the checkbox itself.
* <code>M13CheckboxAlignment checkAlignment</code>: Determines if the checkbox is to the left or right of the text. Follows the UIAppearance protocol. The possible values are:
    * M13CheckboxAlignmentLeft - Checkbox is to the left of the text.
    * M13CheckboxAlignmentRight - Checkbox is to the right of the text. (default)
* <code>CGRect boxFrame</code>: Frame of the checkbox itself in the control's frame, just in case one would need to separate the frames of the titleLabel, and the checkbox. (READ ONLY).
* <code>- (id)value</code>: Returns a custom value that is associated with a specific M13CheckboxState. The values returned come from these properties:
    * id checkedValue
    * id uncheckedValue
    * id mixedValue

Appearance Properties:
-----------------------
All Properties follow the UIAppearance protocol.

* <code>BOOL flat</code>: If YES, the checkbox draws with solid color instead of gradients. (default is NO.)
* <code>CGFloat strokeWidth</code>: The width of the stroke around the box. (default is 5% of the height of the control's frame.)
* <code>UIColor *strokeColor</code>: The color of the stroke around the box. (default is <code>[UIColor colorWithRed: 0.167 green: 0.198 blue: 0.429 alpha: 1]</code>)
* <code>UIColor *checkColor</code>: The color of the checkmark. (default is <code>[UIColor colorWithRed:0.0 green:0.129 blue:0.252 alpha:1.0]</code>)
* <code>UIColor *tintColor</code>: The color of the checkbox when checked or mixed. (default is <code>[UIColor colorWithRed: 0.616 green: 0.82 blue: 0.982 alpha: 1]</code>)
* <code>UIColor *uncheckedColor</code>: The color of the checkbox when unchecked. (default is <code>[UIColor colorWithRed:0.925 green:0.925 blue:0.925 alpha:1.0]</code>)
* <code>CGFloat radius</code>: The radius of the corners of the box. (default is 18.75% of the boxes height.)

Extra Methods:
-------------
* <code>- (void)setTitle:(NSString *)title</code>: Sets the title of the titleLabel, and resizes the width of the contra's frame to fit that text.
* <code>- (void)setState:(M13CheckboxState)state</code>: Sets the state of the checkbox to the state given.
* <code>- (void)toggleState</code>: Toggles the state between M13CheckboxStateUnchecked, and M13CheckboxStateChecked
* <code>- (void)autoFitFontToHeight</code>: Changes the font size, so it fills the height of the frame.
* <code>- (void)autoFitWidthToText</code>: Changes the width of the frame to fit the titleLabel's text.
* <code>- (UIBezierPath *)getDefaultShape</code>: Override this method to specify your own shape to draw instead of the checkmark. All distances should be specified as percentages of the height of the frame.