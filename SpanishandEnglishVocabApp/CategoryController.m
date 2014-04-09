//
//  CategoryController.m
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/20/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "CategoryController.h"

#pragma mark -
#pragma mark Private Interface
@interface CategoryController ()<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

// Returns the index for the category that should be selected in the picker view initially.
- (int) indexForInitialCategory;
@end

#pragma mark -
@implementation CategoryController

#pragma mark Constructors
- (id) initWithcategories:(NSArray*)categories selectedCategory:(int)catId
{
    self = [super init];
	if (self == nil)
		return self;
    
    UIBarButtonItem* barButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(updateCategory)] autorelease];
    
    [[self navigationItem] setLeftBarButtonItem:barButtonItem];
    
    [self setCategories:categories];
    [self setInitialCategoryId:catId];
    
	
    return self;
}

- (void) dealloc 
{
    [self setDelegate:nil];
    [_categories release];
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
@synthesize delegate = _delegate;
@synthesize categories = _categories;
@synthesize initialCategoryId = _initialCategoryId;

- (CategoryView*) contentView
{
    return (CategoryView*)[self view];
}

#pragma mark -
#pragma mark Methods
- (int) indexForInitialCategory
{
    NSArray* categories = [self categories];
    int catId = [self initialCategoryId];
    int index;
    for (index = 0; index < [categories count]; ++index) 
    {
        WordCategory* category = [categories objectAtIndex:index];
        if (category.categoryID == catId)
        {
            break;
        }
    }
    
    return index;
}

// Updates the category for the definition set.
- (void) updateCategory
{
    // If there is text in the text field, we add a new category, otherwise, update the existing category.
    NSString* categoryName = [[[self contentView] categoryText] text];
    if (categoryName != nil && [categoryName length] > 0)
    {
        if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(categoryController:addCategory:)])
        {
            [[self delegate] categoryController:self addCategory:categoryName];
        }
    }
    else
    {
        if ([self delegate] != nil && [[self delegate] respondsToSelector:@selector(categoryController:updateCategory:)])
        {
            [[self delegate] categoryController:self updateCategory:[[self categories] objectAtIndex:[[[self contentView] categoryPicker] selectedRowInComponent:0]]];
        }
    }
}



- (void) loadView
{
    CGRect screen = [[UIScreen mainScreen] bounds];
    CategoryView* categoryView = [[[CategoryView alloc] initWithFrame:screen] autorelease];
    [self setView:categoryView];
}

#pragma mark UIViewController Methods
- (void) viewDidLoad
{
    CategoryView* categoryView = [self contentView];
    // Set delegate for text field
    [[categoryView categoryText] setDelegate:self];
    
    // Set delegate and data source for picker view
    [[categoryView categoryPicker] setDelegate:self];
    [[categoryView categoryPicker] setDataSource:self];
    [[categoryView categoryPicker] selectRow:[self indexForInitialCategory] inComponent:0 animated:FALSE];
}

- (void) viewDidUnload
{
}

#pragma mark UIPickerViewDelegate implementation
// Called by the picker view when it needs the title to use for a given row in a given component.
- (NSString*) pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    WordCategory* category = [[self categories] objectAtIndex:row];
	return category.categoryName;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [[[self contentView] categoryText] setText:@""];
}

#pragma mark UIPickerViewDataSource implementation
// Called by the picker view when it needs the number of components. (required)
// The number of components (or “columns”) that the picker view should display.
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
	return 1;
}

// Called by the picker view when it needs the number of rows for a specified component. (required)
- (NSInteger) pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [[self categories] count];
}

#pragma mark UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

@end
