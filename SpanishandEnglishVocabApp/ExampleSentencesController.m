//
//  ExampleSentencesController.m
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 6/16/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "ExampleSentencesController.h"

#pragma mark -
#pragma mark Private Interface
@interface ExampleSentencesController ()<UITextViewDelegate>

- (void) registerForKeyboardNotifications;

@end

#pragma mark -
@implementation ExampleSentencesController

#pragma mark Constructors
- (id) initWithEnglish:(NSString*)english spanish:(NSString*)spanish
{
    self = [super init];
	if (self == nil)
		return self;
    
    [self setEnglishExample:english];
    [self setSpanishExample:spanish];
    
    UIBarButtonItem* barButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(saveExamples)] autorelease];
    
    [[self navigationItem] setLeftBarButtonItem:barButtonItem];
    
    [self registerForKeyboardNotifications];
	
    return self;
}

- (void) dealloc 
{
    [self setDelegate:nil];
    [_englishExample release];
    [_spanishExample release];
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
@synthesize delegate = _delegate;
@synthesize englishExample = _englishExample;
@synthesize spanishExample = _spanishExample;

- (ExampleSentencesView*) contentView
{
    return (ExampleSentencesView*)[self view];
}

#pragma mark -
#pragma mark Methods


- (void) saveExamples
{
    if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(updateEnglishExample:andSpanishExample:)])
    {
        [[self delegate] updateEnglishExample:[[[self contentView] englishExampleText] text] andSpanishExample:[[[self contentView] spanishExampleText] text]];
    }
}

- (void) loadView
{
    CGRect bounds = [[UIScreen mainScreen] applicationFrame];
    ExampleSentencesView* exampleView = [[[ExampleSentencesView alloc] initWithFrame:bounds english:[self englishExample] spanish:[self spanishExample]] autorelease];
    [self setView:exampleView];
}

#pragma mark UIViewController Methods
- (void) viewDidLoad
{
    [[[self contentView] englishExampleText] setDelegate:self];
    [[[self contentView] spanishExampleText] setDelegate:self];
}

- (void) viewDidUnload
{
}

#pragma mark UITextViewDelegate methods
// Asks the delegate whether the specified text should be replaced in the text view.
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return FALSE;
    }
    else
    {
        return TRUE;
    }
}

- (void) textViewDidBeginEditing:(UITextView*)textView
{
    _activeTextView = textView;
}

- (void) textViewDidEndEditing:(UITextView*)textView
{
    _activeTextView = nil;
}

- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    [self contentView].contentInset = contentInsets;
    [self contentView].scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = [[self contentView] frame];
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, _activeTextView.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, _activeTextView.frame.origin.y - [[[self contentView] englishExampleLabel] frame].size.height);
        [[self contentView] setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    [self contentView].contentInset = contentInsets;
    [self contentView].scrollIndicatorInsets = contentInsets;
}

@end
