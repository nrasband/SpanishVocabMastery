//
//  FlashCardStartView.h
//  SpanishandEnglishVocabApp
//
//  Created by Nicholas Rasband on 5/21/11.
//  Copyright 2011 Nick Rasband. All rights reserved.
//

@interface FlashCardStartView : UIView 
{
    UISegmentedControl* _direction;
    UISegmentedControl* _pictureLocation;
    UISwitch* _englishExampleSwitch;
    UISwitch* _spanishExampleSwitch;
    UITableView* _tableView;
    UILabel* _showEnglishExample;
    UILabel* _showSpanishExample;    
}

- (id) initWithFrame:(CGRect)frame;

- (UISegmentedControl*) direction;
- (UISegmentedControl*) pictureLocation;
- (UISwitch*) englishExampleSwitch;
- (UISwitch*) spanishExampleSwitch;
- (UITableView*) tableView;

@end
