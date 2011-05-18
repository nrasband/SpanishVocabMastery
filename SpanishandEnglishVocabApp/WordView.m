//
//  WordView.m
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/18/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "WordView.h"

#pragma mark -
#pragma mark Private Interface
@interface WordView ()
@end

#pragma mark -
@implementation WordView

#pragma mark Constructors
- (id) initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
	if (self == nil)
		return nil;
	
    return self;
}

- (void) dealloc 
{
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors

#pragma mark -
#pragma mark Methods

#pragma mark UIView Methods
- (void) layoutSubviews
{
}

@end
