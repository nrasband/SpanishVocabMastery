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
@interface WordController ()<UITextFieldDelegate, UIAlertViewDelegate, PartOfSpeechControllerDelegate, CategoryControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ExampleSentencesControllerDelegate>

// Sets the values of the various controls to the values contained in the definition set. 
- (void) prePopulateFields;

@end

#pragma mark -
@implementation WordController

#pragma mark Constructors
- (id) init
{
    self = [super init];
	if (self == nil)
		return self;
    
    [self setDefinitionSetSaved:FALSE];
	
    return self;
}

- (id) initWithDefinitionSet:(DefinitionSet*)defSet isNew:(BOOL)isNew
{
    self = [super init];
	if (self == nil)
		return self;
    
    [self setDefinitionSetSaved:FALSE];    
    [self setDefinitionSet:defSet];
    [self setIsNewDefinition:isNew];

    UIBarButtonItem* saveButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(saveWord)] autorelease];
    UIBarButtonItem* cancelButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(cancelWord)] autorelease];    
    
    [[self navigationItem] setLeftBarButtonItem:saveButton];
    [[self navigationItem] setRightBarButtonItem:cancelButton];    
	
    return self;    
}

- (void) dealloc 
{
    [self setDelegate:nil];
    [_definitionSet release];
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
@synthesize definitionSet = _definitionSet;
@synthesize isNewDefinition = _isNewDefinition;
@synthesize definitionSetSaved = _definitionSetSaved;

- (void) setDelegate:(NSObject<WordControllerDelegate> *)delegate
{
    _delegate = delegate;
    if ([self isNewDefinition])
    {
        if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(getNextDefinitionId)])
        {
            int defId = [[self delegate] getNextDefinitionId];
            if (defId != -1)
            {
                [[self definitionSet] setDefinitionID:defId];
            }
            else
            {
                NSLog(@"DefinitionSet ID not returned correctly to WordController. Possibly a delegate has not been implemented.");
            }
        }
    }
}

- (NSObject<WordControllerDelegate>*) delegate
{
    return _delegate;
}

- (WordView*) contentView
{
    return (WordView*)[self view];
}

#pragma mark -
#pragma mark Methods


// This method loads CategoryController to allow the user to change the category
- (void) changeCategory
{
    NSArray* categories = nil;
    if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(wordController:retrieveCategories:)])
    {
        categories = [[self delegate] wordController:self retrieveCategories:TRUE];
         CategoryController* categoryController = [[[CategoryController alloc] initWithcategories:categories selectedCategory:[[self definitionSet] categoryID]] autorelease];
        [categoryController setDelegate:self];
        [[self navigationController] pushViewController:categoryController animated:TRUE];
    }
   
}

// This method allows the user to specify the part of speech
- (void) changePartOfSpeech
{
    PartOfSpeechController* partOfSpeechController = [[[PartOfSpeechController alloc] initWithPartOfSpeech:[[self definitionSet] partOfSpeech]] autorelease];
    [partOfSpeechController setDelegate:self];
    [[self navigationController] pushViewController:partOfSpeechController animated:TRUE];
}

// This method allows the user to add/change the image associated with the definition
- (void) changeImage
{
    UIAlertView* alertView = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Choose", @"") message:NSLocalizedString(@"Capture an image with the camera or choose an existing image from the library.", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") otherButtonTitles:NSLocalizedString(@"Camera", @""), NSLocalizedString(@"Library", @""), nil] autorelease];
    [alertView setTag:3];
    [alertView show];

}

- (void) changeExampleSentences
{
    ExampleSentencesController* exampleSentencesController = [[[ExampleSentencesController alloc] initWithEnglish:[[self definitionSet] englishExampleSentence] spanish:[[self definitionSet] spanishExampleSentence]] autorelease];
    [exampleSentencesController setDelegate:self];
    [[self navigationController] pushViewController:exampleSentencesController animated:TRUE];
}

// This method validates all important attributes of the definition before saving it to the database.
- (void) saveWord
{
    WordView* wordView = [self contentView];
    // Create a string to store any potential problems
    NSMutableString* problems = [[[NSMutableString alloc] init] autorelease];
    
    // Update the definition set with the values from all of the different controls.
    DefinitionSet* defSet = [self definitionSet];
    
    NSString* english = [[wordView englishText] text];
    if (english == nil || [english length] == 0)
    {
        [problems appendString:NSLocalizedString(@"Please enter text for English\n", @"")];
    }
    else
    {
        [defSet setEnglish:english];    
    }
    
    NSString* spanish = [[wordView spanishText] text];
    if (spanish == nil || [spanish length] == 0)
    {
        [problems appendString:NSLocalizedString(@"Please enter text for Spanish\n", @"")];
    }
    else
    {
        [defSet setSpanish:spanish];
    }
    
    // Set the gender
    int gender = [[wordView genderControl] selectedSegmentIndex];
    if (gender == UISegmentedControlNoSegment || gender == 2)
    {
        [defSet setGender:@"N/A"];
    }
    else
    {
        if (gender == 0)
        {
            [defSet setGender:@"M"];
        }
        else
        {
            [defSet setGender:@"F"];
        }
    }
    
    // Set singular or plural
    int singPlrl = [[wordView singularOrPluralControl] selectedSegmentIndex];
    if (singPlrl == UISegmentedControlNoSegment || singPlrl == 2)
    {
        [defSet setSingularOrPlural:NA];
    }
    else
    {
        // Because SINGULAR == 0 and PLURAL == 1, this shorthand works.
        [defSet setSingularOrPlural:singPlrl];
    }
    
    // Check to make sure a part of speech has been assigned
    if ([defSet partOfSpeech] == nil || [[defSet partOfSpeech] length] == 0)
    {
        [problems appendString:NSLocalizedString(@"Please select a part of speech.", @"")];
    }
    
    // It's all good, proceed to save.
    if ([problems length] == 0)
    {
        [self setDefinitionSetSaved:TRUE];
        // Call the appropriate delegate method to update or add the definition set.
        if ([self isNewDefinition])
        {
            if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(wordController:addDefinitionSet:)])
            {
                [[self delegate] wordController:self addDefinitionSet:defSet];
            }
        }
        else
        {
            if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(wordController:updateDefinitionSet:)])
            {
                [[self delegate] wordController:self updateDefinitionSet:defSet];
            }        
        }        
    }
    else
    {
        // There is a problem. Display the problems as an alert.
        UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Problems with definition set", @"") message:problems delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", @"") otherButtonTitles:nil] autorelease];
        [alert setTag:1];
        [alert show];
    }

}

- (void) cancelWord
{
    /* I believe this will be autoreleased, so this shouldn't be necessary.
    if ([self isNewDefinition])
    {
        [[self definitionSet] release];
    }
    */
    
    if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(cancelUpdate)])
    {
        [[self delegate] cancelUpdate];
    }
}

#pragma mark UIView methods
- (void) loadView
{
    CGRect screen = [[UIScreen mainScreen] bounds];
    WordView* wordView = [[[WordView alloc] initWithFrame:screen] autorelease];
    [self setView:wordView];
}

#pragma mark UIViewController Methods
- (void) viewDidLoad
{
    WordView* wordView = [self contentView];
    // Setup delegates and button targets
    [[wordView englishText] setDelegate:self];
    [[wordView spanishText] setDelegate:self];
    
    // Associate a method with the category button
    [[wordView categoryButton] addTarget:self action:@selector(changeCategory) forControlEvents:UIControlEventTouchUpInside];
    
    [[wordView exampleSentenceButton] addTarget:self action:@selector(changeExampleSentences) forControlEvents:UIControlEventTouchUpInside];
    
    // Associate a method with the part of speech button
    [[wordView partOfSpeechButton] addTarget:self action:@selector(changePartOfSpeech) forControlEvents:UIControlEventTouchUpInside];
    
    // Associate a method with the image button
    [[wordView imageButton] addTarget:self action:@selector(changeImage) forControlEvents:UIControlEventTouchUpInside];
    
    // Show text image or the image itself if it exists
    NSString* imagePath = [[self definitionSet] imagePath];
    if ([imagePath length] > 0)
    {
        [[wordView imageButton] setBackgroundImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
    }
    else
    {
        [[wordView imageButton] setTitle:NSLocalizedString(@"Image", @"") forState:UIControlStateNormal];
    }
    
    [self prePopulateFields];
}

- (void) viewWillUnload
{
    NSLog(@"View will unload");
}

- (void) prePopulateFields
{
    WordView* wordView = [self contentView];
    DefinitionSet* defSet = [self definitionSet];
    [[wordView englishText] setText:[defSet english]];
    [[wordView spanishText] setText:[defSet spanish]];
    [[wordView genderControl] setSelectedSegmentIndex:[defSet genderIndex]];
    [[wordView singularOrPluralControl] setSelectedSegmentIndex:[defSet singularPluralIndex]];
}

#pragma mark UITextFieldDelegate implementation
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return NO;
}

#pragma mark UIAlertViewDelegate methods
- (void) alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView tag] == 1)
    {
        [alertView dismissWithClickedButtonIndex:0 animated:TRUE];
    }
    else if ([alertView tag] == 3)
    {
        if (buttonIndex == 1)
        {
            // Show the camera control
            // Check to make sure that the camera is available
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES)
            {
                _imagePicker = [[UIImagePickerController alloc] init];
                [_imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
                NSArray* mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
                // By only checking if mediaTypes is greater than zero, I am using the default where the camera is only allowed to take still photos.
                if ([mediaTypes count] > 0)
                {
                    [_imagePicker setAllowsEditing:TRUE];
                    [_imagePicker setDelegate:self];
                    [self presentModalViewController:_imagePicker animated:YES];
                }
                
            }            
        }
        else if (buttonIndex == 2)
        {
            // Show the image library control
            // Check to make sure that the photo library is available
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == YES)
            {
                _imagePicker = [[UIImagePickerController alloc] init];
                [_imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                NSArray* mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                // By only checking if mediaTypes is greater than zero, I am using the default where the library is only allowed to show still photos.
                if ([mediaTypes count] > 0)
                {
                    [_imagePicker setAllowsEditing:TRUE];
                    [_imagePicker setDelegate:self];
                    [self presentModalViewController:_imagePicker animated:YES];
                }
                
            }
            
        }
        else
        {
            [alertView dismissWithClickedButtonIndex:0 animated:TRUE];
        }
        
    }
}

#pragma mark PartOfSpeechControllerDelegate methods
- (void) partOfSpeechController:(PartOfSpeechController*)partOfSpeechController updatePartOfSpeech:(NSString*)partOfSpeech
{
    [[self definitionSet] setPartOfSpeech:partOfSpeech];
    [[self navigationController] popViewControllerAnimated:TRUE];
}

#pragma mark CategoryControllerDelegate methods
 - (void) categoryController:(CategoryController*)categoryController updateCategory:(WordCategory*)category
{
    [[self definitionSet] setCategoryID:[category categoryID]];
    [[self navigationController] popViewControllerAnimated:TRUE];
}

- (void) categoryController:(CategoryController *)categoryController addCategory:(NSString*)category
{
    if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(wordController:addCategory:)])
    {
        int categoryID = [[self delegate] wordController:self addCategory:category];
        if (categoryID != -1)
        {
            [[self definitionSet] setCategoryID:categoryID];
        }
    }
    [[self navigationController] popViewControllerAnimated:TRUE];
}

#pragma mark UIImagePickerController methods
// Tells the delegate that the user picked a still image or movie.
- (void) imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    [self dismissModalViewControllerAnimated:YES];
    
    // Store the URI of the image
    NSString* imagePath = nil;
    UIImage* editedImage = nil;
    
    editedImage = (UIImage*)[info objectForKey:UIImagePickerControllerEditedImage];
    
    // Save the edited image, if available, or the original image if not, to the documents folder, then store the image's
    // URL to the database.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    imagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%i.jpg", [[self definitionSet] definitionID]]];
    
    if (editedImage)
    {
        [UIImageJPEGRepresentation(editedImage, 0.5f) writeToFile:imagePath atomically:YES];
    }
    
    
    [[self definitionSet] setImagePath:imagePath];
    NSLog(@"image path: %@", imagePath);
    
    // Update the preview image
    WordView* wordView = [self contentView];
    [[wordView imageButton] setBackgroundImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
    [[[wordView imageButton] titleLabel] setText:@""];
    [picker release];

}

// Tells the delegate that the user cancelled the pick operation.
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
    [picker release];
}

#pragma mark ExampleSentencesControllerDelegate methods
- (void) updateEnglishExample:(NSString*)english andSpanishExample:(NSString*)spanish;
{
    [[self definitionSet] setEnglishExampleSentence:english];
    [[self definitionSet] setSpanishExampleSentence:spanish];
    
    [[self navigationController] popViewControllerAnimated:TRUE];
}

@end
