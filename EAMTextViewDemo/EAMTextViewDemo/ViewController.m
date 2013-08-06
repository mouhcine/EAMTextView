//
//  ViewController.m
//  EAMTextViewDemo
//
//  Created by Mouhcine El Amine on 06/08/13.
//  Copyright (c) 2013 Mouhcine El Amine. All rights reserved.
//

#import "ViewController.h"
#import "EAMTextView.h"

@interface ViewController () <EAMTextViewDelegate>

@property (weak, nonatomic) IBOutlet EAMTextView *textView;

@property (weak, nonatomic) IBOutlet UIView *inputBar;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.textView.delegate = self;
    self.textView.autoresizesVertically = YES;
    self.textView.minimumHeight = 40.0f;
    self.textView.maximumHeight = 120.0f;
    self.textView.placeholder = @"Type something...";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGRect inputBarFrame = self.inputBar.frame;
    inputBarFrame.origin.y = self.view.frame.size.height - inputBarFrame.size.height;
    self.inputBar.frame = inputBarFrame;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillDisappear:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAppear:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillAppear:(NSNotification *)note
{
    CGRect inputBarFrame = self.inputBar.frame;
    inputBarFrame.origin.y = self.view.frame.size.height - inputBarFrame.size.height - [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    [UIView animateWithDuration:[[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState | [[note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]
                     animations:^{
                         self.inputBar.frame = inputBarFrame;
                     }
                     completion:nil];
}

- (void)keyboardWillDisappear:(NSNotification *)note
{
    CGRect inputBarFrame = self.inputBar.frame;
    inputBarFrame.origin.y = self.view.frame.size.height - inputBarFrame.size.height;
    
    [UIView animateWithDuration:[[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState | [[note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]
                     animations:^{
                         self.inputBar.frame = inputBarFrame;
                     }
                     completion:nil];
}

- (IBAction)sendButtonTapped
{
    self.textView.text = nil;
    [self.textView resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark EAMTextViewDelegate

- (void)textView:(EAMTextView *)textView willChangeFromHeight:(CGFloat)oldHeight toHeight:(CGFloat)newHeight
{
    CGRect frame = self.inputBar.frame;
    CGFloat difference = newHeight - oldHeight;
    frame.size.height += difference;
    frame.origin.y -= difference;
    self.inputBar.frame = frame;
}

- (void)textView:(EAMTextView *)textView didChangeFromHeight:(CGFloat)oldHeight toHeight:(CGFloat)newHeight
{
    NSLog(@"Finished height change animation from height %f to height %f", oldHeight, newHeight);
}

#pragma mark -
#pragma mark UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"Text did change");
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"Ended editing");
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"Began editing");
}


@end
