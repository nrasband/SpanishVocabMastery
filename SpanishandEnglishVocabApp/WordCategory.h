//
//  WordCategory.h
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/15/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#define DEFAULT 0 // This is for the default category

@interface WordCategory : NSObject 
{
	NSString* _categoryName;
	int _categoryID;    
}

@property (assign) int categoryID;
@property (retain) NSString* categoryName;

- (id) initWithCategoryName:(NSString*)name andID:(int)catID;

@end
