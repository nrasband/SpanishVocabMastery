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

- (void) getNextCard;
- (void) getPreviousCard;
- (BOOL) shouldShowPicture;
- (void) addButtonTargets;
- (void) assignCardsToRandomIndices;

@end

#pragma mark -
@implementation FlashCardCardController

#pragma mark Constructors
- (id) initWithDefinitionSets:(NSArray*)definitionSets andDirection:(int)direction andPictureLocation:(int)picLocation showEngExample:(BOOL)showEng showSpanExample:(BOOL)showSpan andCategoryName:(NSString*)name
{
    self = [super init];
	if (self == nil)
		return self;
    
    [self setDefinitionSets:definitionSets];
    [self assignCardsToRandomIndices];
    [self setCurrentIndex:-1];
    [self setDirection:direction];
    [self setShowEngExample:showEng];
    [self setShowSpanExample:showSpan];
    [self setPictureLocation:picLocation];
    
    [self setTitle:name];
    
    // Find out if it is iPad or iPhone and set the font appropriately.
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [self setFontSize:30.0f];
    }
    else
    {
        [self setFontSize:17.0f];
    }
    
    // Set the current side to the front side
    [self setCurrentSide:FRONT];
	
    return self;
}

- (void) dealloc 
{
    [_remainingCards release];
    [self setDelegate:nil];
    [_definitionSets release];
    [_currentDefinitionSet release];
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
@synthesize delegate = _delegate;
@synthesize definitionSets = _definitionSets;
@synthesize fontSize = _fontSize;
@synthesize direction = _direction;
@synthesize showEngExample = _showEngExample;
@synthesize showSpanExample = _showSpanExample;
@synthesize pictureLocation = _pictureLocation;
@synthesize currentDefinitionSet = _currentDefinitionSet;
@synthesize currentIndex = _currentIndex;
@synthesize currentSide = _currentSide;

- (FlashCardView*) contentView
{
    return (FlashCardView*)[self view];
}


#pragma mark -
#pragma mark Methods

- (void) loadView
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    // Get the first definition set
    [self getNextCard];
    
    FlashCardView* cardView = [[[FlashCardView alloc] initWithFrame:bounds definitionSet:[self currentDefinitionSet] direction:[self direction] showEngExample:[self showEngExample] showSpanExample:[self showSpanExample] showPicture:[self shouldShowPicture]] autorelease];
    [self setView:cardView];
}

#pragma mark UIViewController Methods
- (void) viewDidLoad
{
    [self addButtonTargets];
}

- (void) viewDidUnload
{
}

- (void) getNextCard
{
    int nextIndex = [self currentIndex] + 1;
    
    // We have reached the end. Go back to zero.
    if (nextIndex > [_remainingCards count] - 1)
    {
        [self setCurrentIndex:0];
        nextIndex = 0;
    }
    else
    {
        [self setCurrentIndex:nextIndex];
    }
    
    [self setCurrentDefinitionSet:[_remainingCards objectAtIndex:nextIndex]];
}

- (void) getPreviousCard
{
    int previousIndex = [self currentIndex] - 1;
    if (previousIndex < 0)
    {
        previousIndex = [_remainingCards count] - 1;
    }
    
    [self setCurrentDefinitionSet:[_remainingCards objectAtIndex:previousIndex]];
    [self setCurrentIndex:previousIndex];
}

- (void) addButtonTargets
{
    [[[self contentView] flipButton] addTarget:self action:@selector(flipCard) forControlEvents:UIControlEventTouchUpInside];
    [[[self contentView] nextButton] addTarget:self action:@selector(nextCard) forControlEvents:UIControlEventTouchUpInside];
    [[[self contentView] previousButton] addTarget:self action:@selector(previousCard) forControlEvents:UIControlEventTouchUpInside];
}

- (BOOL) shouldShowPicture
{
    BOOL result = FALSE;
    if (([self currentSide] == FRONT && [self pictureLocation] == FRONT) ||
        ([self currentSide] == BACK && [self pictureLocation] == BACK))
    {
        result = TRUE;
    }
    
    return result;
}

- (void) flipCard
{
    int direction = 0;
    // If we are on the front, switch to the back, otherwise switch to the front
    if ([self currentSide] == FRONT)
    {
        [self setCurrentSide:BACK];
        
        if ([self direction] == ENG_SPA)
        {
            direction = SPA_ENG;
        }
        else
        {
            direction = ENG_SPA;
        }
    }
    else
    {
        direction = [self direction];
        
        [self setCurrentSide:FRONT];
    }
    
    FlashCardView* cardView = [[[FlashCardView alloc] initWithFrame:[[self view] frame] definitionSet:[self currentDefinitionSet] direction:direction showEngExample:[self showEngExample] showSpanExample:[self showSpanExample] showPicture:[self shouldShowPicture]] autorelease];
    
    // Animate flip
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[[self view] superview] cache:NO];
    [self setView:cardView];
    [UIView commitAnimations];
    [self addButtonTargets];
}

- (void) previousCard
{
    // Get the previous card for display
    [self getPreviousCard];
    
    // Change the side of the card to the front
    [self setCurrentSide:FRONT];
    
    FlashCardView* cardView = [[[FlashCardView alloc] initWithFrame:[[self view] frame] definitionSet:[self currentDefinitionSet] direction:[self direction] showEngExample:[self showEngExample] showSpanExample:[self showSpanExample] showPicture:[self shouldShowPicture]] autorelease];
    
    // Animate changing cards
    // Animate flip
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:[[self view] superview] cache:NO];
    [self setView:cardView];
    [UIView commitAnimations];
    
    [self addButtonTargets];
}

- (void) nextCard
{
    // Get the next card for display
    [self getNextCard];
    
    // Change the side of the card to the front
    [self setCurrentSide:FRONT];
    
    FlashCardView* cardView = [[[FlashCardView alloc] initWithFrame:[[self view] frame] definitionSet:[self currentDefinitionSet] direction:[self direction] showEngExample:[self showEngExample] showSpanExample:[self showSpanExample] showPicture:[self shouldShowPicture]] autorelease];

    // Animate changing cards
    // Animate flip
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:[[self view] superview] cache:NO];
    [self setView:cardView];
    [UIView commitAnimations];
    
    [self addButtonTargets];
}

// Assigns each card to a random index so that people don't remember the cards just
// based on their order.
- (void) assignCardsToRandomIndices
{
    int numberOfCards = [[self definitionSets] count];
    NSMutableArray* tempArray = [[NSMutableArray alloc] initWithArray:[self definitionSets] copyItems:YES];
    _remainingCards = [[NSMutableArray alloc] initWithCapacity:numberOfCards];
    for (int i = 0; i < numberOfCards; i++) 
    {
        // Get a definition set randomly from the deck (random between 0 and one less than the size of the deck
        int randomIndex = arc4random() % [tempArray count] - 1;
        randomIndex = randomIndex < 0 ? 0 : randomIndex;
        
        // Assign the definition set at the random index to the current index of _remainingCards
        [_remainingCards insertObject:[tempArray objectAtIndex:randomIndex] atIndex:i];
        
        // Delete definition set from tempArray
        [tempArray removeObjectAtIndex:randomIndex];
    }
    
    [tempArray release];
}

@end
