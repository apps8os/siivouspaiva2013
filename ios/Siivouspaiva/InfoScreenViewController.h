//
//  InfoScreenViewController.h
//  Siivouspaiva
//
//  Created by Fabian on 08.05.13.
//  Copyright (c) 2013 Fabian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoScreenViewController : UIViewController {
    __weak IBOutlet UIScrollView *contentScrollView;
    __weak IBOutlet UITextView *InfoTextView;
    __weak IBOutlet UILabel *LabelSWD;
    __weak IBOutlet UILabel *LabelUID;
    __weak IBOutlet UILabel *Labeldev1;
    __weak IBOutlet UILabel *Labeldev2;
    __weak IBOutlet UILabel *Labelothers;
    __weak IBOutlet UILabel *Labelothers2;
    __weak IBOutlet UILabel *LabelTHT;
    __weak IBOutlet UILabel *LabelAaltoF;
}
@end
