//
//  M13Checkbox.h
//  M13Checkbox-UIRadioGroup
//
/*Copyright (c) 2012 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

/*
    Special thanks to Jeff Wolski ( https://github.com/jefmwols ) for adding KVO compliance!
*/

#import <UIKit/UIKit.h>

#define M13CheckboxDefaultHeight 16.0

#define kBoxRadius 0.1875
#define kBoxStrokeWidth 0.05

//States
typedef enum {
    M13CheckboxStateUnchecked = NO, //Default
    M13CheckboxStateChecked = YES,
    M13CheckboxStateMixed
} M13CheckboxState;

//Box location compared to text
typedef enum {
    M13CheckboxAlignmentLeft,
    M13CheckboxAlignmentRight //Default
} M13CheckboxAlignment;

@interface M13Checkbox : UIControl

@property (nonatomic, retain) UILabel *titleLabel; //Label will fill available frame - box size.
@property (nonatomic, assign) M13CheckboxState checkState;
@property (nonatomic, assign) M13CheckboxAlignment checkAlignment UI_APPEARANCE_SELECTOR; //Set the box to the left or right of the text
@property (nonatomic, readonly) CGRect boxFrame; //Location of checkbox in control

//Values, the values returned by using the - (id)value method, this is a convenience method if you have a group of boxes on a page. That way one does not have to do if(box == mybox) {if( mybox.checkState == ... for every checkbox
@property (nonatomic, retain) id checkedValue;
@property (nonatomic, retain) id uncheckedValue;
@property (nonatomic, retain) id mixedValue;
- (id)value;

- (id)init; // create with default height
- (id)initWithFrame:(CGRect)frame; //manually override default frame, checkbox will fill height of frame, and label font size will be determined by the height
- (id)initWithTitle:(NSString *)title; // set the frame with a default height, width will expand to fit text
- (id)initWithTitle:(NSString *)title andHeight:(CGFloat)height;//set the frame with the specified height, width will expand to fit text

- (void)setTitle:(NSString *)title;
- (void)setState:(M13CheckboxState)state __attribute((deprecated("use setCheckState method"))); 
- (void)setCheckState:(M13CheckboxState)state;//Change state programitically
- (void)toggleState __attribute((deprecated("use toggleCheckState method")));
- (void)toggleCheckState;
- (void)autoFitFontToHeight;//If you change the font, run this to change the font size to fit the frame.
- (void)autoFitWidthToText;

- (UIBezierPath *)getDefaultShape;//One needs to subclass M13Checkbox and override this method to use a custom shape. see method for more details.

//Appearance
@property (nonatomic, assign) BOOL flat UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat strokeWidth UI_APPEARANCE_SELECTOR; 
@property (nonatomic, retain) UIColor *strokeColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, retain) UIColor *checkColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, retain) UIColor *tintColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, retain) UIColor *uncheckedColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat radius UI_APPEARANCE_SELECTOR; 

@end
