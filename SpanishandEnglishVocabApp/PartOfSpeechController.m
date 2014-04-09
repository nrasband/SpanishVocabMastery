//
//  PartOfSpeechController.m
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/19/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "PartOfSpeechController.h"

#pragma mark -
#pragma mark Private Interface
@interface PartOfSpeechController ()<UIPickerViewDelegate, UIPickerViewDataSource>
@end

#pragma mark -
@implementation PartOfSpeechController

#pragma mark Constructors
- (id) initWithPartOfSpeech:(NSString*)partOfSpeech
{
    self = [super init];
	if (self == nil)
		return self;
    
    [self setPartOfSpeech:partOfSpeech];
    
    UIBarButtonItem* barButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(updatePartOfSpeech)] autorelease];
    
    [[self navigationItem] setLeftBarButtonItem:barButtonItem];

	
    return self;
}

- (void) dealloc 
{
    [self setDelegate:nil];
    [_partOfSpeech release];
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
@synthesize delegate = _delegate;
@synthesize partOfSpeech = _partOfSpeech;

- (PartOfSpeechView*) contentView
{
    return (PartOfSpeechView*)[self view];
}

#pragma mark -
#pragma mark Methods
- (void) loadView
{
    CGRect screen = [[UIScreen mainScreen] bounds];
    PartOfSpeechView* partOfSpeechView = [[[PartOfSpeechView alloc] initWithFrame:screen partOfSpeech:[self partOfSpeech]] autorelease];
    [self setView:partOfSpeechView];
}

// This method updates the definition set's part of speech via the delegate.
- (void) updatePartOfSpeech
{
    if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(partOfSpeechController:updatePartOfSpeech:)])
    {
        [[self delegate] partOfSpeechController:self updatePartOfSpeech:[[[self contentView] partsOfSpeech] objectAtIndex:[[[self contentView] partOfSpeechPicker] selectedRowInComponent:0]]];
    }
}

#pragma mark UIViewController Methods
- (void) viewDidLoad
{
    PartOfSpeechView* partOfSpeechView = [self contentView];
    // Setup the delegates for the picker
    [[partOfSpeechView partOfSpeechPicker] setDelegate:self];
    [[partOfSpeechView partOfSpeechPicker] setDataSource:self];
    
    // Set the initially selected part of speech
    int partOfSpeechIndex = [partOfSpeechView partOfSpeechToIndex:[self partOfSpeech]];
    //NSLog(@"partOfSpeech index: %i, partOfSpeech: %@", partOfSpeechIndex, [self partOfSpeech]);
    [[partOfSpeechView partOfSpeechPicker] selectRow:partOfSpeechIndex inComponent:0 animated:FALSE];
}

- (void) viewDidUnload
{
}

#pragma mark UIPickerViewDelegate implementation
// Called by the picker view when it needs the title to use for a given row in a given component.
- (NSString*) pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return NSLocalizedString([[[self contentView] partsOfSpeech] objectAtIndex:row], @"");
}

#pragma mark UIPickerViewDataSource implementation
// Called by the picker view when it needs the number of components. (required)
// The number of components (or “columns”) that the picker view should display.
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
	return 1;
}

// Called by the picker view when it needs the number of rows for a specified component. (required)
// 
- (NSInteger) pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [[[self contentView] partsOfSpeech] count];
}

@end
