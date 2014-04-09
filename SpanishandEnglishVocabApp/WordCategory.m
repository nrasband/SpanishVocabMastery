//
//  WordCategory.m
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/15/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "WordCategory.h"

#pragma mark -
#pragma mark Private Interface
@interface WordCategory ()
@end

#pragma mark -
@implementation WordCategory

#pragma mark Constructors
// Default constructor
- (id) init
{
    self = [super init];
    if (self == nil)
        return nil;
    
    return self;
}

// Custom constructor
- (id) initWithCategoryName:(NSString*)name andID:(int)catID
{
    self = [super init];
    if (self == nil)
        return nil;
	
	[self setCategoryID:catID];
	[self setCategoryName:name];
    
    return self;	
}

- (void) dealloc
{
    [_categoryName release];
    [super dealloc];
}

#pragma mark -
#pragma mark Accessors
@synthesize categoryID= _categoryID;
@synthesize categoryName = _categoryName;

#pragma mark -
#pragma mark Methods
- (NSString*) description
{
	return [NSString stringWithFormat:@"Category: name='%@' id='%i'", [self categoryName], [self categoryID]];
}

@end
