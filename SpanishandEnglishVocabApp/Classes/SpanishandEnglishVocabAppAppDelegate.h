//
//  SpanishandEnglishVocabAppAppDelegate.h
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/15/11.
//  Copyright 2011 Nick Rasband. All rights reserved.

#import "DataModel.h"
#import "SpanishAppHelp.h"
#import "ManageController.h"
#import "SearchController.h"
#import "FlashCardController.h"

@interface SpanishandEnglishVocabAppAppDelegate : NSObject <UIApplicationDelegate, ManageControllerDelegate, SearchControllerDelegate, FlashCardControllerDelegate, UITabBarControllerDelegate> 
{
    UIWindow* _window;
    DataModel* _dictionary;
    UITabBarController* _tabBarController;
    UINavigationController* _manageNavController;
    UINavigationController* _searchNavController;
    UINavigationController* _flashNavController;
    SearchController* _searcher;
    FlashCardController* _flasher;
    ManageController* _manager;
    SpanishAppHelp* _help;
}

@end
