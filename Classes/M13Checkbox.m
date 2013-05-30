//
//  M13Checkbox.m
//  M13Checkbox-UIRadioGroup
//
/*Copyright (c) 2012 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "M13Checkbox.h"

#define kBoxSize .875
#define kCheckHorizontalExtention .125
#define kCheckVerticalExtension .125
#define kCheckIndent .125
#define kCheckRaise .1875
#define kCheckSize .8125
#define kCheckBoxSpacing 0.3125
#define kM13CheckboxMaxFontSize 100.0

//Custom Checkbox View
@interface CheckView : UIView

@property (nonatomic, retain) M13Checkbox *checkbox;
@property (nonatomic, assign) BOOL selected;

@end

@implementation CheckView
@synthesize checkbox, selected;

- (void)drawRect:(CGRect)rect
{
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Set area
    CGRect boxRect = CGRectMake(checkbox.strokeWidth, (self.frame.size.height * kCheckVerticalExtension), (self.frame.size.height * kBoxSize) - checkbox.strokeWidth, (self.frame.size.height * kBoxSize) - checkbox.strokeWidth);
    
    //Set colors
    UIColor *fillColor = nil;
    UIColor *strokeColor = nil;
    UIColor *checkColor = nil;
    
    if (checkbox.checkState == M13CheckboxStateUnchecked) {
        fillColor = checkbox.uncheckedColor;
    } else {
        fillColor = checkbox.tintColor;
    }
    
    if (self.selected) {
        float r, g, b, a;
        [fillColor getRed:&r green:&g blue:&b alpha:&a];
    }
    
    if (!checkbox.enabled) {
        float r, g, b, a;
        [fillColor getRed:&r green:&g blue:&b alpha:&a];
        fillColor = [UIColor colorWithRed:(r + .2) green:(g + .2) blue:(b + .2) alpha:a];
        [checkbox.strokeColor getRed:&r green:&g blue:&b alpha:&a];
        strokeColor = [UIColor colorWithRed:(r + .2) green:(g + .2) blue:(b + .2) alpha:a];
        [checkbox.checkColor getRed:&r green:&g blue:&b alpha:&a];
        checkColor = [UIColor colorWithRed:(r + .2) green:(g + .2) blue:(b + .2) alpha:a];
    } else {
        strokeColor = checkbox.strokeColor;
        checkColor = checkbox.checkColor;
    }
    
    //Draw box
    if (checkbox.flat) {
        UIBezierPath *boxPath = [UIBezierPath bezierPathWithRoundedRect:boxRect cornerRadius:checkbox.radius];
        [fillColor setFill];
        [boxPath fill];
        [strokeColor setStroke];
        boxPath.lineWidth = checkbox.strokeWidth;
        [boxPath stroke];
    } else {
        //Create colors based off of tint color
        float r, g, b, a;
        [fillColor getRed:&r green:&g blue:&b alpha:&a];
        UIColor *topColor = [UIColor colorWithRed:(r + 0.20) green:(g + 0.20) blue:(b + 0.20) alpha:a];
        UIColor *bottomColor = [UIColor colorWithRed:(r + 0.15) green:(g + 0.15) blue:(b + 0.15) alpha:a];
        NSArray *fillGradientColors = [NSArray arrayWithObjects:(id)topColor.CGColor, (id)topColor.CGColor, (id)fillColor.CGColor, (id)bottomColor.CGColor, nil];
        CGFloat fillGradientLocations[] = {0, 0.47, 0.53, 1};
        CGGradientRef fillGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)fillGradientColors, fillGradientLocations);
        
        //Draw
        UIBezierPath *boxPath = [UIBezierPath bezierPathWithRoundedRect:boxRect cornerRadius:checkbox.radius];
        CGContextSaveGState(context);
        [boxPath addClip];
        CGContextDrawLinearGradient(context, fillGradient, CGPointMake(0, (self.frame.size.height * kCheckVerticalExtension)), CGPointMake(0, self.frame.size.height), 0);
        CGContextRestoreGState(context);
        [strokeColor setStroke];
        boxPath.lineWidth = checkbox.strokeWidth;
        [boxPath stroke];
        
        //Cleanup
        CGGradientRelease(fillGradient);
    }
    
    //Draw Shape
    if (checkbox.checkState == M13CheckboxStateUnchecked) {
        //Do Nothing
    } else if (checkbox.checkState == M13CheckboxStateChecked) {
        [checkColor setFill];
        [[checkbox getDefaultShape] fill];
    } else if (checkbox.checkState == M13CheckboxStateMixed) {
        UIBezierPath *mixedPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(checkbox.strokeWidth + ((boxRect.size.width - (.5 * self.frame.size.height)) * 0.5), (self.frame.size.height * .5) - ((0.09375 * self.frame.size.height) * .5), .5 * self.frame.size.height, 0.1875 * self.frame.size.height) cornerRadius:(0.09375 * self.frame.size.height)];
        [checkColor setFill];
        [mixedPath fill];
    }
    
    //Cleanup
    CGColorSpaceRelease(colorSpace);
}

@end

//User Visible Properties
@interface M13Checkbox ()

@property (nonatomic, assign) CGRect boxFrame;

@end

@implementation M13Checkbox
{
    CheckView *checkView;
    UIColor *labelColor;
}

@synthesize flat = _flat;
@synthesize strokeColor = _strokeColor;
@synthesize strokeWidth = _strokeWidth;
@synthesize checkColor = _checkColor;
@synthesize tintColor = _tintColor;
@synthesize radius = _radius;
@synthesize titleLabel = _titleLabel;
@synthesize checkState = _checkState;
@synthesize boxFrame;
@synthesize checkAlignment = _checkAlignment;
@synthesize uncheckedColor = _uncheckedColor;
@synthesize enabled = _enabled;
@synthesize checkedValue;
@synthesize uncheckedValue;
@synthesize mixedValue;

- (id)init
{
    self = [self initWithFrame:CGRectMake(0, 0, M13CheckboxDefaultHeight, M13CheckboxDefaultHeight)];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _flat = NO;
        _strokeColor = [UIColor colorWithRed: 0.167 green: 0.198 blue: 0.429 alpha: 1];
        _strokeWidth = kBoxStrokeWidth * self.frame.size.height;
        _checkColor = [UIColor colorWithRed:0.0 green:0.129 blue:0.252 alpha:1.0];
        _tintColor = [UIColor colorWithRed: 0.616 green: 0.82 blue: 0.982 alpha: 1];
        _uncheckedColor = [UIColor colorWithRed:0.925 green:0.925 blue:0.925 alpha:1.0];
        _radius = kBoxRadius * self.frame.size.height;
        _checkAlignment = M13CheckboxAlignmentRight;
        _checkState = M13CheckboxStateUnchecked;
        _enabled = YES;
        checkView = [[CheckView alloc] initWithFrame:CGRectMake(self.frame.size.width - ((kBoxSize + kCheckHorizontalExtention) * self.frame.size.height), 0, ((kBoxSize + kCheckHorizontalExtention) * self.frame.size.height), self.frame.size.height)];
        checkView.checkbox = self;
        checkView.selected = NO;
        checkView.backgroundColor = [UIColor clearColor];
        checkView.clipsToBounds = NO;
        checkView.userInteractionEnabled = NO;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height * kCheckVerticalExtension, self.frame.size.width - checkView.frame.size.width - (self.frame.size.height * kCheckBoxSpacing), self.frame.size.height * kBoxSize)];
        _titleLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.userInteractionEnabled = NO;
        [self autoFitFontToHeight];
        [self addSubview:checkView];
        [self addSubview:_titleLabel];
        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        _flat = NO;
        _strokeColor = [UIColor colorWithRed: 0.167 green: 0.198 blue: 0.429 alpha: 1];
        _strokeWidth = kBoxStrokeWidth * self.frame.size.height;
        _checkColor = [UIColor colorWithRed:0.0 green:0.129 blue:0.252 alpha:1.0];
        _tintColor = [UIColor colorWithRed: 0.616 green: 0.82 blue: 0.982 alpha: 1];
        _uncheckedColor = [UIColor colorWithRed:0.925 green:0.925 blue:0.925 alpha:1.0];
        _radius = kBoxRadius * self.frame.size.height;
        _checkAlignment = M13CheckboxAlignmentRight;
        _checkState = M13CheckboxStateUnchecked;
        _enabled = YES;
        checkView = [[CheckView alloc] initWithFrame:CGRectMake(self.frame.size.width - ((kBoxSize + kCheckHorizontalExtention) * self.frame.size.height), 0, ((kBoxSize + kCheckHorizontalExtention) * self.frame.size.height), self.frame.size.height)];
        checkView.checkbox = self;
        checkView.selected = NO;
        checkView.backgroundColor = [UIColor clearColor];
        checkView.clipsToBounds = NO;
        checkView.userInteractionEnabled = NO;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height * kCheckVerticalExtension, self.frame.size.width - checkView.frame.size.width - (self.frame.size.height * kCheckBoxSpacing), self.frame.size.height * kBoxSize)];
        _titleLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.userInteractionEnabled = NO;
        [self autoFitFontToHeight];
        [self addSubview:checkView];
        [self addSubview:_titleLabel];
        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title
{
    self = [self initWithFrame:CGRectMake(0, 0, 100.0, M13CheckboxDefaultHeight)];
    if (self) {
        _titleLabel.text = title;
        [self autoFitFontToHeight];
        CGSize labelSize = [title sizeWithFont:_titleLabel.font];
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, labelSize.width + (self.frame.size.height * kCheckBoxSpacing) + ((kBoxSize + kCheckHorizontalExtention) * self.frame.size.height), self.frame.size.height);
        [self layoutSubviews];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title andHeight:(CGFloat)height
{
    self = [self initWithFrame:CGRectMake(0, 0, 100.0, height)];
    if (self) {
        _titleLabel.text = title;
        [self autoFitFontToHeight];
        CGSize labelSize = [title sizeWithFont:_titleLabel.font];
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, labelSize.width + (self.frame.size.height * kCheckBoxSpacing) + ((kBoxSize + kCheckHorizontalExtention) * self.frame.size.height), self.frame.size.height);
        [self layoutSubviews];
    }
    return self;
}

/*
 The shape is defined by the height of the frame. The decimal numbers are the percentage of the height that distance is. That way, the shape can be drawn for any height.
 */

- (UIBezierPath *)getDefaultShape
{
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake((0.17625 * self.frame.size.height), (0.368125 * self.frame.size.height))];
    [bezierPath addCurveToPoint: CGPointMake((0.17625 * self.frame.size.height), (0.46375 * self.frame.size.height)) controlPoint1: CGPointMake((0.13125 * self.frame.size.height), (0.418125 * self.frame.size.height)) controlPoint2: CGPointMake((0.17625 * self.frame.size.height), (0.46375 * self.frame.size.height))];
    [bezierPath addLineToPoint: CGPointMake((0.4 * self.frame.size.height), (0.719375 * self.frame.size.height))];
    [bezierPath addCurveToPoint: CGPointMake((0.45375* self.frame.size.height), (0.756875 * self.frame.size.height)) controlPoint1: CGPointMake((0.4 * self.frame.size.height), (0.719375 * self.frame.size.height)) controlPoint2: CGPointMake((0.4275 * self.frame.size.height), (0.756875 * self.frame.size.height))];
    [bezierPath addCurveToPoint: CGPointMake((0.505625 * self.frame.size.height), (0.719375 * self.frame.size.height)) controlPoint1: CGPointMake((0.480625 * self.frame.size.height), (0.75625 * self.frame.size.height)) controlPoint2: CGPointMake((0.505625 * self.frame.size.height), (0.719375 * self.frame.size.height))];
    [bezierPath addLineToPoint: CGPointMake((0.978125* self.frame.size.height), (0.145625* self.frame.size.height))];
    [bezierPath addCurveToPoint: CGPointMake((0.978125* self.frame.size.height), (0.050625* self.frame.size.height)) controlPoint1: CGPointMake((0.978125* self.frame.size.height), (0.145625* self.frame.size.height)) controlPoint2: CGPointMake((1.026875* self.frame.size.height), (0.09375* self.frame.size.height))];
    [bezierPath addCurveToPoint: CGPointMake((0.885625* self.frame.size.height), (0.050625* self.frame.size.height)) controlPoint1: CGPointMake((0.929375* self.frame.size.height), (0.006875* self.frame.size.height)) controlPoint2: CGPointMake((0.885625* self.frame.size.height), (0.050625* self.frame.size.height))];
    [bezierPath addLineToPoint: CGPointMake((0.45375* self.frame.size.height), (0.590625* self.frame.size.height))];
    [bezierPath addLineToPoint: CGPointMake((0.26875* self.frame.size.height), (0.368125 * self.frame.size.height))];
    [bezierPath addCurveToPoint: CGPointMake((0.17625 * self.frame.size.height), (0.368125 * self.frame.size.height)) controlPoint1: CGPointMake((0.26875* self.frame.size.height), (0.368125 * self.frame.size.height)) controlPoint2: CGPointMake((0.221875* self.frame.size.height), (0.318125* self.frame.size.height))];
    [bezierPath closePath];
    bezierPath.miterLimit = 0;
    return bezierPath;
}

- (void)autoFitFontToHeight
{
    CGFloat height = self.frame.size.height * kBoxSize;
    CGFloat fontSize = kM13CheckboxMaxFontSize;
    CGFloat tempHeight = MAXFLOAT;
    
    do {
        //Update font
        fontSize -= 1;
        UIFont *font = [UIFont fontWithName:_titleLabel.font.fontName size:fontSize];
        //Get size
        CGSize labelSize = [@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz" sizeWithFont:font];
        tempHeight = labelSize.height;
    } while (tempHeight >= height);
    
    _titleLabel.font = [UIFont fontWithName:_titleLabel.font.fontName size:fontSize];
}

- (void)autoFitWidthToText
{
    CGSize labelSize = [_titleLabel.text sizeWithFont:_titleLabel.font];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, labelSize.width + (self.frame.size.height * kCheckBoxSpacing) + ((kBoxSize + kCheckHorizontalExtention) * self.frame.size.height), self.frame.size.height);
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    if (_checkAlignment == M13CheckboxAlignmentRight) {
        checkView.frame = CGRectMake(self.frame.size.width - ((kBoxSize + kCheckHorizontalExtention) * self.frame.size.height), 0, ((kBoxSize + kCheckHorizontalExtention) * self.frame.size.height), self.frame.size.height);
        _titleLabel.frame = CGRectMake(0, self.frame.size.height * kCheckVerticalExtension, self.frame.size.width - checkView.frame.size.width - (self.frame.size.height * kCheckBoxSpacing), self.frame.size.height * kBoxSize);
    } else {
        checkView.frame = CGRectMake(0, 0, ((kBoxSize + kCheckHorizontalExtention) * self.frame.size.height), self.frame.size.height);
        _titleLabel.frame = CGRectMake(checkView.frame.size.width + (self.frame.size.height * kCheckBoxSpacing), self.frame.size.height * kCheckVerticalExtension, self.frame.size.width - (self.frame.size.height * (kBoxSize + kCheckHorizontalExtention + kCheckBoxSpacing)), self.frame.size.height * kBoxSize);
    }
}

- (void)setState:(M13CheckboxState)state __attribute((deprecated("use setCheckState method")))
{
    [self setCheckState:state];
}

- (void)setCheckState:(M13CheckboxState)checkState{
    _checkState = checkState;
    [checkView setNeedsDisplay];
}

- (void)toggleState __attribute((deprecated("use toggleCheckState method")))
{
    [self toggleCheckState];
}

- (void)toggleCheckState
{

    self.checkState = !self.checkState;
}

- (void)setEnabled:(BOOL)enabled
{
    if (enabled) {
        _titleLabel.textColor = labelColor;
    } else {
        labelColor = _titleLabel.textColor;
        float r, g, b, a;
        [labelColor getRed:&r green:&g blue:&b alpha:&a];
        r = floorf(r * 100.0 + 0.5) / 100.0;
        g = floorf(g * 100.0 + 0.5) / 100.0;
        b = floorf(b * 100.0 + 0.5) / 100.0;
        _titleLabel.textColor = [UIColor colorWithRed:(r + .4) green:(g + .4) blue:(b + .4) alpha:1];
    }
    _enabled = enabled;
    [checkView setNeedsDisplay];
}

- (void)setCheckAlignment:(M13CheckboxAlignment)checkAlignment
{
    _checkAlignment = checkAlignment;
    [self layoutSubviews];
}

- (void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
    [self autoFitFontToHeight];
    CGSize labelSize = [title sizeWithFont:_titleLabel.font];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, labelSize.width + (self.frame.size.height * kCheckBoxSpacing) + ((kBoxSize + kCheckHorizontalExtention) * self.frame.size.height), self.frame.size.height);
    [self layoutSubviews];
}

- (id)value
{
    if (self.checkState == M13CheckboxStateUnchecked) {
        return uncheckedValue;
    } else if (self.checkState == M13CheckboxStateChecked) {
        return checkedValue;
    } else {
        return mixedValue;
    }
}

#pragma mark - UIControl overrides

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super beginTrackingWithTouch:touch withEvent:event];
    checkView.selected = YES;
    [checkView setNeedsDisplay];
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super continueTrackingWithTouch:touch withEvent:event];
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    checkView.selected = NO;
    [self toggleState];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [super endTrackingWithTouch:touch withEvent:event];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    checkView.selected = NO;
    [checkView setNeedsDisplay];
    [super cancelTrackingWithEvent:event];
}

@end

