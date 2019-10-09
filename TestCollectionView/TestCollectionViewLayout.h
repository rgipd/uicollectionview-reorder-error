//
//  TestCollectionViewLayout.h
//  TestCollectionView
//
//  Created by Rafael on 08/10/19.
//  Copyright © 2019 Rafael. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


// Class forward declaration
@class TestCollectionViewController;


@interface TestCollectionViewLayout : UICollectionViewLayout

@property (weak, nonatomic) NSMutableArray <NSDictionary *> *dictArray;

@property (weak, nonatomic) TestCollectionViewController *controller;


@end

NS_ASSUME_NONNULL_END
