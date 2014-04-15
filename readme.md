<img src="https://raw.github.com/Marxon13/M13Checkbox/master/ReadmeResources/M13CheckboxBanner.png">

M13Checkbox
============

A customizable checkbox for iOS that mimics the checkbox found on OS X, and Safari.

Features:
----------
* Simple to setup, just initialize with the desired parameters, and add to your subview.
* Many customizable settings to make it easy to seamlessly integrate with your app.
* All appearance settings follow the UIAppearance protocol.
* Can be a standalone checkbox, or add a title.
* Easy resizing. Use the provided methods to resize the control's width to the content, and change the font size based on the height of the checkbox.
* Resizeable!
* You can add your own shape if desired!
* No images! Everything is drawn with code!

Examples:
----------

***Default***

<img src="https://raw.github.com/Marxon13/M13Checkbox/master/ReadmeResources/DefaultCheck.png">

***Resizable***

<img src="https://raw.github.com/Marxon13/M13Checkbox/master/ReadmeResources/ResizeableCheck.png">

***Supports Titles***

<img src="https://raw.github.com/Marxon13/M13Checkbox/master/ReadmeResources/AddTitleCheck.png">

***Custom Size With Text***

<img src="https://raw.github.com/Marxon13/M13Checkbox/master/ReadmeResources/CustomHeightCheck.png">

***Custom Size and Multiline Text***

<img src="https://raw.github.com/Marxon13/M13Checkbox/master/ReadmeResources/CustomFrameAndText.png">

***Text Alignment***

<img src="https://raw.github.com/Marxon13/M13Checkbox/master/ReadmeResources/AlignmentCheck.png">

***Supports a Mixed State***

<img src="https://raw.github.com/Marxon13/M13Checkbox/master/ReadmeResources/MixedStateCheck.png">

***OS X Styling***

<img src="https://raw.github.com/Marxon13/M13Checkbox/master/ReadmeResources/OSXCheck.png">

***Custom Stroke***

<img src="https://raw.github.com/Marxon13/M13Checkbox/master/ReadmeResources/CustomStrokeCheck.png">

***Custom Colors***

<img src="https://raw.github.com/Marxon13/M13Checkbox/master/ReadmeResources/CustomColorsCheck.png">

***Custom Corner Radius***

<img src="https://raw.github.com/Marxon13/M13Checkbox/master/ReadmeResources/CustomRadiusCheck.png">

***Control Disabling***

<img src="https://raw.github.com/Marxon13/M13Checkbox/master/ReadmeResources/DisabledCheck.png">

Initialization:
----------
* <code>- (id)init</code>:Creates a checkbox with the default height, and no text.
* <code>- (id)initWithFrame:(CGRect)frame</code>: Creates a checkbox with the specified frame, and no text. The box will just fill the height of the frame.
* <code>- (id)initWithTitle:(NSString *)title</code>: Creates a checkbox with the default height, and the specified text. The width of the frame will be changed to make the text fit.
* <code>- (id)initWithFrame:(CGRect)frame title:(NSString *)title</code>: Creates a checkbox with the default, and the given text. The width of the frame will be changed to make the text fit.

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
* <code>- (void)setCheckState:(M13CheckboxState)state</code>: Sets the state of the checkbox to the state given.
* <code>- (void)toggleCheckState</code>: Toggles the state between M13CheckboxStateUnchecked, and M13CheckboxStateChecked
* <code>- (void)autoFitFontToHeight</code>: Changes the font size, so it fills the height of the frame.
* <code>- (void)autoFitWidthToText</code>: Changes the width of the frame to fit the titleLabel's text.
* <code>- (UIBezierPath *)getDefaultShape</code>: Override this method to specify your own shape to draw instead of the checkmark. All distances should be specified as percentages of the height of the frame.

License:
--------
MIT License

> Copyright (c) 2014 Brandon McQuilkin
> 
> Permission is hereby granted, free of charge, to any person obtaining 
>a copy of this software and associated documentation files (the  
>"Software"), to deal in the Software without restriction, including 
>without limitation the rights to use, copy, modify, merge, publish, 
>distribute, sublicense, and/or sell copies of the Software, and to 
>permit persons to whom the Software is furnished to do so, subject to  
>the following conditions:
> 
> The above copyright notice and this permission notice shall be 
>included in all copies or substantial portions of the Software.
> 
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
>EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
>MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
>IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
>CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
>TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
>SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


 