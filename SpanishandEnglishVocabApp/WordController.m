//
//  WordController.m
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/18/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "WordController.h"

#pragma mark -
#pragma mark Private Interface
@interface WordController ()
@end

#pragma mark -
@implementation WordController

#pragma mark Constructors
- (id) init
{
    self = [super init];
	if (self == nil)
		return self;
	
    return self;
}

- (id) initWithDefinitionSet:(DefinitionSet*)defSet isNew:(BOOL)isNew allowChangeCategory:(BOOL)allowChangeCategory
{
    self = [super init];
	if (self == nil)
		return self;
    
    [self setDefinitionSet:defSet];
    [self setIsNewDefinition:isNew];
    [self setAllowChangeCategory:allowChangeCategory]; 
	
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
@synthesize definitionSet = _definitionSet;
@synthesize isNewDefinition = _isNewDefinition;
@synthesize allowChangeCategory = _allowChangeCategory;

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
