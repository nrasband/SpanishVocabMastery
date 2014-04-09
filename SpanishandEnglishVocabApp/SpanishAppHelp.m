//
//  SpanishAppHelp.m
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/16/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "SpanishAppHelp.h"

#pragma mark -
#pragma mark Private Interface
@interface SpanishAppHelp ()
@end

#pragma mark -
@implementation SpanishAppHelp

#pragma mark Constructors
- (id) init
{
    self = [super init];
	if (self == nil)
		return self;
    
    // Personalize view controller
    [self setTitle:NSLocalizedString(@"Help", @"")];
    
    // Set image for tab bar item
    [[self tabBarItem] setImage:[UIImage imageNamed:@"help.png"]];
	
    return self;
}

- (void) dealloc 
{
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
- (UIWebView*) contentView
{
    return (UIWebView*)[self view];
}

#pragma mark -
#pragma mark Methods
- (void) loadView
{
    // Create a web view as the content view for this view controller
    UIWebView* webView = [[[UIWebView alloc] init] autorelease];
    [webView setDataDetectorTypes:UIDataDetectorTypeLink];
    [self setView:webView];
}

#pragma mark UIViewController Methods
- (BOOL) shouldAutorotate
{
    return YES;
}

- (void) viewDidLoad
{	
	NSError* error = nil;
	
	NSString* path = [[NSBundle mainBundle] pathForResource:NSLocalizedString(@"mainhelp", @"") ofType:@"html" inDirectory:nil];
	NSString* html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
//    if (error != nil)
//    {
//        NSLog(@"Error reading in html for help: %@", error);
//    }
	
	[[self contentView] loadHTMLString:html baseURL:nil];
}

- (void) viewDidUnload
{
}

@end
