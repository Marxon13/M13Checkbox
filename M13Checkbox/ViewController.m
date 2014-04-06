//
//  ViewController.m
//  M13Checkbox
//
/*Copyright (c) 2012 Brandon McQuilkin
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "ViewController.h"
#import "M13Checkbox.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
	// Do any additional setup after loading the view, typically from a nib.
    
    //Create just a box with the default size
    M13Checkbox *allDefaults = [[M13Checkbox alloc] init];
    allDefaults.frame = CGRectMake(25, 25, allDefaults.frame.size.width, allDefaults.frame.size.height);
    [allDefaults addTarget:self action:@selector(checkChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:allDefaults];
    
    //Basic Title
    M13Checkbox *basicTitle = [[M13Checkbox alloc] initWithTitle:@"Basic Title"];
    basicTitle.frame = CGRectMake(25, allDefaults.frame.origin.y + allDefaults.frame.size.height + 8, basicTitle.frame.size.width, basicTitle.frame.size.height);
    [self.view addSubview:basicTitle];
    
    //Title With custom height
    M13Checkbox *titleWithHeight = [[M13Checkbox alloc] initWithFrame:CGRectMake(25, basicTitle.frame.origin.y + basicTitle.frame.size.height + 8, 100, 30) title:@"Custom Height" checkHeight:30.0];
    [self.view addSubview:titleWithHeight];
    
    //Left Alignment
    M13Checkbox *leftAlignment = [[M13Checkbox alloc] initWithTitle:@"M13CheckboxAlignmentLeft"];
    [leftAlignment setCheckAlignment:M13CheckboxAlignmentLeft];
    leftAlignment.frame = CGRectMake(25, titleWithHeight.frame.origin.y +titleWithHeight.frame.size.height + 8, leftAlignment.frame.size.width, leftAlignment.frame.size.height);
    
    [self.view addSubview:leftAlignment];
    
    //Mixed
    M13Checkbox *mixed = [[M13Checkbox alloc] initWithTitle:@"M13CheckboxStateMixed"];
    [mixed setCheckState:M13CheckboxStateMixed];
    mixed.frame = CGRectMake(25, leftAlignment.frame.origin.y + leftAlignment.frame.size.height + 8, mixed.frame.size.width, mixed.frame.size.height);
    [self.view addSubview:mixed];
    
    //OSX-Style
    M13Checkbox *osx = [[M13Checkbox alloc] initWithTitle:@"OSX Style"];
    osx.flat = NO;
    osx.frame = CGRectMake(25, mixed.frame.origin.y + mixed.frame.size.height + 8, osx.frame.size.width, osx.frame.size.height);
    osx.strokeColor = [UIColor colorWithRed: 0.167 green: 0.198 blue: 0.429 alpha: 1];
    osx.checkColor = [UIColor colorWithRed:0.0 green:0.129 blue:0.252 alpha:1.0];
    osx.tintColor = [UIColor colorWithRed: 0.616 green: 0.82 blue: 0.982 alpha: 1];
    osx.uncheckedColor = [UIColor colorWithRed:0.925 green:0.925 blue:0.925 alpha:1.0];
    [self.view addSubview:osx];
    
    //Custom Stroke
    M13Checkbox *stroke = [[M13Checkbox alloc] initWithFrame:CGRectMake(25, osx.frame.origin.y + osx.frame.size.height + 8, 100, 30) title:@"Custom Stroke" checkHeight:30.0];
    stroke.strokeColor = [UIColor redColor];
    stroke.strokeWidth = 3.0;
    [stroke autoFitWidthToText];
    [self.view addSubview:stroke];
    
    //Custom Check Color
    M13Checkbox *check = [[M13Checkbox alloc] initWithTitle:@"Custom Check Color"];
    check.checkColor = [UIColor blueColor];
    check.frame = CGRectMake(25, stroke.frame.origin.y + stroke.frame.size.height + 8, check.frame.size.width, check.frame.size.height);
    [self.view addSubview:check];
    
    //Custom tint color
    M13Checkbox *tint = [[M13Checkbox alloc] initWithTitle:@"Custom Tint Color"];
    tint.tintColor = [UIColor colorWithRed: 0.608 green: 0.967 blue: 0.646 alpha: 1];
    tint.frame = CGRectMake(25, check.frame.origin.y + check.frame.size.height + 8, tint.frame.size.width, tint.frame.size.height);
    [self.view addSubview:tint];
    
    //Custom Unchecked Color
    M13Checkbox *unchecked = [[M13Checkbox alloc] initWithTitle:@"Custom Unchecked Color"];
    unchecked.uncheckedColor = [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0];
    unchecked.frame = CGRectMake(25, tint.frame.origin.y + tint.frame.size.height + 8, unchecked.frame.size.width, unchecked.frame.size.height);
    [self.view addSubview:unchecked];
    
    //Custom Radius
    M13Checkbox *radius = [[M13Checkbox alloc] initWithTitle:@"Custom Radius"];
    radius.radius = 5.0;
    radius.frame = CGRectMake(25, unchecked.frame.origin.y + unchecked.frame.size.height + 8, radius.frame.size.width, radius.frame.size.height);
    [self.view addSubview:radius];
    
    //Disabled
    M13Checkbox *disabled = [[M13Checkbox alloc] initWithTitle:@"Disabled"];
    disabled.enabled = NO;
    disabled.frame = CGRectMake(25, radius.frame.origin.y + radius.frame.size.height + 8, disabled.frame.size.width, disabled.frame.size.height);
    [self.view addSubview:disabled];
    
    //Disabled Checked
    M13Checkbox *disabledChecked = [[M13Checkbox alloc] initWithTitle:@"Disabled Checked"];
    disabledChecked.enabled = NO;
    [disabledChecked setCheckState:M13CheckboxStateChecked];
    disabledChecked.frame = CGRectMake(25, disabled.frame.origin.y + disabled.frame.size.height + 8, disabledChecked.frame.size.width, disabledChecked.frame.size.height);
    [self.view addSubview:disabledChecked];
    
    //Custom Frame + Multiline text
    M13Checkbox *customFrame = [[M13Checkbox alloc] initWithFrame:CGRectMake(25, disabledChecked.frame.origin.y + disabledChecked.frame.size.height + 8, 200, 100) title:@"Custom control frame and multiple lines of text." checkHeight:M13CheckboxDefaultHeight];
    customFrame.backgroundColor = [UIColor lightGrayColor];
    customFrame.titleLabel.numberOfLines = 0;
    customFrame.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:customFrame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkChangedValue:(id)sender
{
    NSLog(@"Changed Value");
}

@end