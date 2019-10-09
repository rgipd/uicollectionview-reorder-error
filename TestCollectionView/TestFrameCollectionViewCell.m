//
//  TestFrameCollectionViewCell.m
//  TestCollectionView
//
//  Created by Rafael on 08/10/19.
//  Copyright © 2019 Rafael. All rights reserved.
//

#import "TestFrameCollectionViewCell.h"

@implementation TestFrameCollectionViewCell

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    // Default border color
    self.layer.borderColor = [UIColor blackColor].CGColor;
    
    //
    // When selected, just put a border on it
    //
    if (selected == YES) {
        self.layer.borderWidth = 5.0f;
    } else {
        self.layer.borderWidth = 0.0f;
    }
}

@end
