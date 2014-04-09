//
//  FlashCardCardController.m
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/22/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "FlashCardCardController.h"

#pragma mark -
#pragma mark Private Interface
@interface FlashCardCardController ()
@end

#pragma mark -
@implementation FlashCardCardController

#pragma mark Constructors
- (id) init
{
    self = [super init];
	if (self == nil)
		return self;
	
    return self;
}

- (void) dealloc 
{
    [self setDelegate:nil];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
@synthesize delegate = _delegate;

#pragma mark -
#pragma mark Methods

#pragma mark UIViewController Methods
- (void) viewDidLoad
{
    [[self view] setBackgroundColor:[UIColor colorWithHue:(float)drand48() saturation:1.0f brightness:1.0f alpha:1.0f]];
}

- (void) viewDidUnload
{
}

@end
