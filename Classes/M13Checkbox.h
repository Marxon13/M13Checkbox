//
//  M13Checkbox.h
//  M13Checkbox-UIRadioGroup
//
//  Created by Brandon McQuilkin on 12/29/12.
//  Copyright (c) 2012 Brandon McQuilkin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define M13CheckboxDefaultHeight 16.0

#define kBoxRadius 0.1875
#define kBoxStrokeWidth 0.05

//States
typedef enum {
    M13CheckboxStateUnchecked, //Default
    M13CheckboxStateChecked,
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
- (void)setState:(M13CheckboxState)state;//Change state programitically
- (void)toggleState;
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
