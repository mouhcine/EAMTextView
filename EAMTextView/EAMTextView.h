//
//  EAMTextView.h
//
//  Created by Mouhcine El Amine on 06/08/13.
//
//  Copyright (c) 2013 El Amine Mouhcine.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <UIKit/UIKit.h>

@class EAMTextView;

/**
 *	The EAMTextViewDelegate protocol defines optional methods added to the set of methods defined in UITextViewDelegate.
 */
@protocol EAMTextViewDelegate <NSObject, UITextViewDelegate>

@optional

/**
 *	Tells the delegate that the text view's height is about to change.
 *
 *	@param	textView	The text view whose height is about to change.
 *	@param	oldHeight	The actual height of the text view's frame.
 *	@param	newHeight	The new height of the text view's frame.
 *
 *  @discussion This method gets called in the animation block.
 */
- (void)textView:(EAMTextView *)textView willChangeFromHeight:(CGFloat)oldHeight toHeight:(CGFloat)newHeight;

/**
 *	Tells the delegate that the text view's height did change.
 *
 *	@param	textView	The text view whose height did change.
 *	@param	oldHeight	The actual height of the text view's frame.
 *	@param	newHeight	The new height of the text view's frame.
 *
 *  @discussion This method gets called in the animation completion block.
 */
- (void)textView:(EAMTextView *)textView didChangeFromHeight:(CGFloat)oldHeight toHeight:(CGFloat)newHeight;

@end

/**
 *	EAMTextView is UITextView subclass that adds placeholder and vertical autoresizing support.
 */
@interface EAMTextView : UITextView

/**
 *	The object that acts as the delegate of the text view.
 */
@property (nonatomic, weak) id <EAMTextViewDelegate> delegate;

/**
 *	The string that is displayed when there is no other text in the text field.
 *  
 *  @discussion The default value is nil.
 */
@property (nonatomic, strong) NSString *placeholder;

/**
 *	The color of the placeholder.
 *
 *  @discussion The default value is [UIColor lightGrayColor].
 */
@property (nonatomic, strong) UIColor *placeholderColor;

/**
 *	A boolean value indicating whether the text view autoresizes vertically.
 *
 *  @discussion The default value is NO.
 */
@property (nonatomic) BOOL autoresizesVertically;

/**
 *	The minimum height for the text view.
 *
 *  @discussion The default value is 0.
 */
@property (nonatomic) CGFloat minimumHeight;

/**
 *	The maximum height for the text view.
 *
 *  @discussion The default value is CGFloat_MAX.
 */
@property (nonatomic) CGFloat maximumHeight;

/**
 *	The autoresizing animation duration.
 *
 *  @discussion The default value is 0.2.
 *  If you set this value to 0, frame will be changed immediately without animations.
 */
@property (nonatomic) NSTimeInterval autoresizingAnimationDuration;

@end
