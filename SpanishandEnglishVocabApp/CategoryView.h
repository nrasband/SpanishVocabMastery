//
//  CategoryView.h
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/20/11.
//  Copyright 2011 Nick Rasband. All rights reserved.

#import "WordCategory.h"

@interface CategoryView : UIView 
{
    UILabel* _categoryLabel;
    UITextField* _categoryText;
    UIPickerView* _categoryPicker;
}

// Constructors
- (id) initWithFrame:(CGRect)frame;

// Properties
- (UITextField*) categoryText;
- (UIPickerView*) categoryPicker;

@end
