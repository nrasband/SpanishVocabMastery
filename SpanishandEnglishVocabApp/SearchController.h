//
//  SearchController.h
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/21/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

#import "DefinitionSet.h"
#import "SearchView.h"
#import "WordController.h"

#define ENG_SPA 0 
#define SPA_ENG 1 

@class SearchController;

@protocol SearchControllerDelegate

@required - (void) searchController:(SearchController*)searchController searchFor:(NSString*)searchTerm inDirection:(int)direction;
@required - (void) searchController:(SearchController *)searchController updateDefinitionSet:(DefinitionSet*)defSet;
@required - (void) searchController:(SearchController *)searchController addDefinitionSet:(DefinitionSet*)defSet;
@required - (void) searchController:(SearchController *)searchController retrieveCategories:(BOOL)retrieve;
@required - (int) searchController:(SearchController *)searchController addCategory:(NSString*)category;
@required - (int) getNextDefinitionId;

@end

@interface SearchController : UIViewController 
{
    NSObject<SearchControllerDelegate>* _delegate;
    NSString* _randomWord;
    int _direction;
    float _fontSize;
    NSString* _searchTerm;
    NSArray* _searchResults;
    NSArray* _categories;
}

- (id) initWithRandomWord:(NSString*)randomWord;

@property (assign) NSObject<SearchControllerDelegate>* delegate;
@property (retain) NSString* randomWord;
@property (assign) int direction;
@property (assign) float fontSize;
@property (retain) NSString* searchTerm;
@property (retain) NSArray* searchResults;
@property (retain) NSArray* categories;

@end

