//
//  EAMTextView.m
//
//  Created by Mouhcine El Amine on 06/08/13.
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

#import "EAMTextView.h"

static CGFloat const EAMTextViewMinimumHeight = 0.0f;
static CGFloat const EAMTextViewMaximumHeight = CGFLOAT_MAX;
static NSTimeInterval const EAMTextViewAutoresizingAnimationDuration = 0.2f;
static CGFloat const EAMTextViewPlaceholderInset = 8.0f;

@implementation EAMTextView {
    UIEdgeInsets _placeholderInsets;
}

@synthesize placeholderColor = _placeholderColor;

#pragma mark -
#pragma mark Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _baseInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _baseInit];
    }
    return self;
}

- (void)_baseInit
{
    _autoresizesVertically = NO;
    _minimumHeight = EAMTextViewMinimumHeight;
    _maximumHeight = EAMTextViewMaximumHeight;
    _autoresizingAnimationDuration = EAMTextViewAutoresizingAnimationDuration;
    _placeholderInsets = UIEdgeInsetsMake(EAMTextViewPlaceholderInset, EAMTextViewPlaceholderInset, 0, 0);

    if ([UIDevice.currentDevice.systemVersion compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
        _placeholderInsets.left = EAMTextViewPlaceholderInset / 2.0f;
    }

    [self _startObservingTextChangeNotification];
}

- (void)dealloc
{
    [self _stopObservingTextChangeNotification];
}

- (void)_startObservingTextChangeNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_textChanged)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
}

- (void)_stopObservingTextChangeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidChangeNotification
                                                  object:self];
}

#pragma mark -
#pragma mark Placeholder

- (void)setPlaceholder:(NSString *)placeholder
{
    if (![_placeholder isEqualToString:placeholder]) {
        _placeholder = placeholder;
        [self setNeedsDisplay];
    }
}

- (UIColor *)placeholderColor
{
    if (!_placeholderColor) {
        _placeholderColor = [UIColor lightGrayColor];
    }
    return _placeholderColor;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    if ([self _shouldDrawPlaceholder]) {
        [self setNeedsDisplay];
    }
}

- (CGRect)_placeholderRectInRect:(CGRect)rect
{
    return CGRectInset(rect, _placeholderInsets.left, _placeholderInsets.top);
}

- (BOOL)_shouldDrawPlaceholder
{
    return ![self hasText] && self.placeholder.length > 0;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if ([self _shouldDrawPlaceholder]) {
        [self.placeholderColor set];
        [self.placeholder drawInRect:[self _placeholderRectInRect:rect]
                            withFont:self.font
                       lineBreakMode:NSLineBreakByTruncatingTail
                           alignment:self.textAlignment];
    }
}

#pragma mark-
#pragma mark Autoresizing

- (void)setAutoresizesVertically:(BOOL)autoresizesVertically
{
    _autoresizesVertically = autoresizesVertically;
    [self _textChanged];
}

- (void)setMaximumHeight:(CGFloat)maximumHeight
{
    _maximumHeight = maximumHeight;
    [self _textChanged];
}

-(void)setMinimumHeight:(CGFloat)minimumHeight
{
    _minimumHeight = minimumHeight;
    [self _textChanged];
}

- (void)_textChanged
{
    if (self.autoresizesVertically) {
        // stay within min and max limit
        CGSize textViewSize = [self sizeThatFits:CGSizeMake(self.frame.size.width, FLT_MAX)];
        CGFloat newHeight = MIN(floorf(textViewSize.height), self.maximumHeight);
        newHeight = MAX(newHeight, self.minimumHeight);

        CGFloat oldHeight = self.frame.size.height;
        if (oldHeight != newHeight) {
            
            // Frame needs to be changed
            CGRect newFrame = self.frame;
            CGFloat heightDifference = newHeight - oldHeight;
            newFrame.size.height += heightDifference;
            
            // Animation blocks
            void (^animationBlock)() = ^{
                if ([self.delegate respondsToSelector:@selector(textView:willChangeFromHeight:toHeight:)]) {
                    [self.delegate textView:self
                       willChangeFromHeight:oldHeight
                                   toHeight:newHeight];
                }
                self.frame = newFrame;
            };
            void (^completionBlock)(BOOL) = ^(BOOL finished) {
                if ( [self.delegate respondsToSelector:@selector(textView:didChangeFromHeight:toHeight:)] ) {
                    [self.delegate textView:self
                        didChangeFromHeight:oldHeight
                                   toHeight:newHeight];
                }
            };
            
            // Animate change if needed
            if ( self.autoresizingAnimationDuration > 0 ) {
                [UIView animateWithDuration:self.autoresizingAnimationDuration
                                      delay:0.0f
                                    options:UIViewAnimationOptionAllowUserInteraction |
                 UIViewAnimationOptionBeginFromCurrentState
                                 animations:animationBlock
                                 completion:completionBlock];
            } else {
                animationBlock();
                completionBlock(YES);
            }
        }
    }
    [self setNeedsDisplay];
}

@end
