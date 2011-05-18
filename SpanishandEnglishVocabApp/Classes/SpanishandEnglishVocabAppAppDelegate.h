//
//  SpanishandEnglishVocabAppAppDelegate.h
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/15/11.
//  Copyright 2011 Nick Rasband. All rights reserved.

#import "DataModel.h"
#import "SpanishAppHelp.h"
#import "ManageController.h"

@interface SpanishandEnglishVocabAppAppDelegate : NSObject <UIApplicationDelegate, UITabBarDelegate, ManageControllerDelegate> 
{
    UIWindow* _window;
    DataModel* _dictionary;
    UITabBarController* _tabBarController;
    UINavigationController* _manageNavController;
    ManageController* _manager;
    SpanishAppHelp* _help;
}

@end
