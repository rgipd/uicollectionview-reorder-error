//
//  TestCollectionViewController.m
//  TestCollectionView
//
//  Created by Rafael on 08/10/19.
//  Copyright © 2019 Rafael. All rights reserved.
//

#import "TestCollectionViewController.h"

//
// Custom UICollectionViewLayout
//
#import "TestCollectionViewLayout.h"

//
// Custom UICollectionViewCell
//
#import "TestFrameCollectionViewCell.h"

//
// NSLOG_DEBUG
//
#import "NSLogDebug.h"


//
// Private interface
//
@interface TestCollectionViewController () <UICollectionViewDragDelegate, UICollectionViewDropDelegate>

// The hard-coded items array for the UICollectionView
@property (strong, nonatomic, nonnull) NSMutableArray <NSDictionary *> *dictArray;

// Reset button that will float above the UICollectionViewController's view
@property (strong, nonatomic, nonnull) UIButton *floatingButton;

// The custom layout with dynamic cell size
@property (strong, nonatomic, nonnull) TestCollectionViewLayout *testLayout;

@end


@implementation TestCollectionViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Initialize the custom layout
    self.testLayout = [[TestCollectionViewLayout alloc] init];
    self.testLayout.controller = self;

    // Fill the items array
    [self reset:NO];

    
    // Customize the UICollectionView
    self.collectionView.dragInteractionEnabled = YES;
    self.collectionView.dragDelegate = self;
    self.collectionView.dropDelegate = self;
    
    self.collectionView.collectionViewLayout = self.testLayout;
    
    
    // Init and customize the reset floating button
    self.floatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    // FIXME hard coded size to test. (iPhone XR simulator works fine)
    self.floatingButton.frame = CGRectMake(0, 800, 100, 50);
    [self.floatingButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [self.floatingButton setTitle:@"RESET" forState:UIControlStateNormal];
    [self.floatingButton addTarget:self action:@selector(onReset:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.floatingButton];
    
    [self.view bringSubviewToFront:self.floatingButton];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.dictArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Dequeue the custom UICollectionViewCell for the "FRAME_CELL"
    TestFrameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FRAME_CELL" forIndexPath:indexPath];
    
    NSDictionary *dict = self.dictArray[indexPath.row];
    
    // Configure the cell
    cell.backgroundColor = dict[@"color"];
    cell.nameLabel.text = dict[@"name"];
    
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView
    canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLOG_DEBUG(@"canMoveItemAtIndexPath: %@ - %@", @(indexPath.section), @(indexPath.row));
    
    
    return YES;
}


//
// Tried to use this, didn't worked
//

//- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
//{
//    NSLOG_DEBUG(@"moveItemAtIndexPath: ( %@ - %@ ) ==> ( %@ - %@ )",
//          @(sourceIndexPath.section), @(sourceIndexPath.row),
//          @(destinationIndexPath.section), @(destinationIndexPath.row));
//    
//    [self moveFrom:sourceIndexPath to:destinationIndexPath];
//}


#pragma mark <UICollectionViewDragDelegate>


- (nonnull NSArray<UIDragItem *> *)collectionView:(nonnull UICollectionView *)collectionView itemsForBeginningDragSession:(nonnull id<UIDragSession>)session atIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSLOG_DEBUG(@"itemsForBeginningDragSession: %@ atIndexPath: %@ - %@", session, @(indexPath.section), @(indexPath.row));
    
    NSMutableArray <UIDragItem *> *items = [NSMutableArray <UIDragItem *> array];
    
    NSString *str = [NSString stringWithFormat:@"%@", @(indexPath.row)];
    
    NSItemProvider *provider = [[NSItemProvider alloc] initWithObject:str];
    UIDragItem *dragItem = [[UIDragItem alloc] initWithItemProvider:provider];
    
    [items addObject:dragItem];
    
    
    return items;
}


#pragma mark <UICollectionViewDropDelegate>

- (void)collectionView:(UICollectionView *)collectionView dropSessionDidEnter:(id<UIDropSession>)session
{
    NSLOG_DEBUG(@"dropSession ENTER");
}

- (void)collectionView:(UICollectionView *)collectionView dropSessionDidEnd:(id<UIDropSession>)session
{
    NSLOG_DEBUG(@"dropSession END");
}

- (UICollectionViewDropProposal *)collectionView:(UICollectionView *)collectionView dropSessionDidUpdate:(id <UIDropSession>)session withDestinationIndexPath:(NSIndexPath *)destinationIndexPath
{
//    NSLOG_DEBUG(@"dropSession DID UPDATE with destionation: %@ - %@", @(destinationIndexPath.section), @(destinationIndexPath.row));
    
    UICollectionViewDropProposal *d = [[UICollectionViewDropProposal alloc] initWithDropOperation:UIDropOperationMove intent:UICollectionViewDropIntentInsertAtDestinationIndexPath];

    
    return d;
}


- (void)collectionView:(UICollectionView *)collectionView dropSessionDidExit:(id<UIDropSession>)session
{
    NSLOG_DEBUG(@"dropSession EXIT");
}

- (void)collectionView:(nonnull UICollectionView *)collectionView performDropWithCoordinator:(nonnull id<UICollectionViewDropCoordinator>)coordinator
{
    NSIndexPath *sourceIndexPath = coordinator.items.firstObject.sourceIndexPath;
    NSIndexPath *destIndexPath = coordinator.destinationIndexPath;

    NSLOG_DEBUG(@"performDropWithCoordinator");
    NSLOG_DEBUG(@"  from: %@ - %@", @(sourceIndexPath.section), @(sourceIndexPath.row));
    NSLOG_DEBUG(@"    to: %@ - %@", @(destIndexPath.section), @(destIndexPath.row));
    NSLOG_DEBUG(@" ");

    NSLOG_DEBUG(@"Before:");
    [self logArray];
    
    [self moveFrom:sourceIndexPath to:destIndexPath];
    
    NSLOG_DEBUG(@"After:");
    [self logArray];
}

- (void)moveFrom:(NSIndexPath *)sourceIndexPath to:(NSIndexPath *)destIndexPath
{
    //
    // Update the dictArray with the user reorder action
    //
    [self.collectionView performBatchUpdates:^{

        [self.collectionView deleteItemsAtIndexPaths:@[ sourceIndexPath ]];
        [self.collectionView insertItemsAtIndexPaths:@[ destIndexPath ]];
        
        NSDictionary *tmpSource = [self.dictArray objectAtIndex:sourceIndexPath.row];
        [self.dictArray removeObjectAtIndex:sourceIndexPath.row];

        [self.dictArray insertObject:tmpSource atIndex:destIndexPath.row];

    } completion:^(BOOL finished) {

        // Do nothing
        
    }];
}

- (void)logArray
{
    NSLOG_DEBUG(@" ");
    NSLOG_DEBUG(@" ");
    NSLOG_DEBUG(@"---- log array begin (count: %@)", @(self.dictArray.count));
    
    NSUInteger counter = 0;
    
    for (NSDictionary *dict in self.dictArray) {
        NSLOG_DEBUG(@" %@ :: name: %@ (size: %@)", @(counter++), dict[@"name"], dict[@"length"]);
    }
    
    NSLOG_DEBUG(@"---- log array end");
    NSLOG_DEBUG(@" ");
    NSLOG_DEBUG(@" ");

}

- (void)onReset:(UIButton *)sender
{
    NSLOG_DEBUG(@" ");
    NSLOG_DEBUG(@" ");
    NSLOG_DEBUG(@" * * * * * * * * * * * * * * * * * ");
    NSLOG_DEBUG(@" ");
    NSLOG_DEBUG(@" ");
    NSLOG_DEBUG(@"         RESETTING BY BUTTON");
    NSLOG_DEBUG(@" ");
    NSLOG_DEBUG(@" ");
    NSLOG_DEBUG(@" * * * * * * * * * * * * * * * * * ");
    NSLOG_DEBUG(@" ");
    NSLOG_DEBUG(@" ");

    [self reset:YES];
}

- (void)reset:(BOOL)reloadCollectionView
{
    //
    // The initial items arrays
    //
    self.dictArray = [NSMutableArray arrayWithArray:@[
                                                      
                                                      @{
                                                          @"name": @"0 - red",
                                                          @"color": UIColor.redColor,
                                                          @"length": @(1)
                                                          },
                                                      @{
                                                          @"name": @"1 - green",
                                                          @"color": UIColor.greenColor,
                                                          @"length": @(1)
                                                          },
                                                      @{
                                                          @"name": @"2 - blue",
                                                          @"color": UIColor.blueColor,
                                                          @"length": @(2)
                                                          },
                                                      @{
                                                          @"name": @"3 - yellow",
                                                          @"color": UIColor.yellowColor,
                                                          @"length": @(1)
                                                          },
                                                      @{
                                                          @"name": @"4 - cyan",
                                                          @"color": UIColor.cyanColor,
                                                          @"length": @(1)
                                                          },
                                                      @{
                                                          @"name": @"5 - magenta",
                                                          @"color": UIColor.magentaColor,
                                                          @"length": @(1)
                                                          },
                                                      @{
                                                          @"name": @"6 - orange",
                                                          @"color": UIColor.orangeColor,
                                                          @"length": @(2)
                                                          },
                                                      @{
                                                          @"name": @"7 - grey",
                                                          @"color": UIColor.grayColor,
                                                          @"length": @(1)
                                                          },
                                                      @{
                                                          @"name": @"8 - darkGrey",
                                                          @"color": UIColor.darkGrayColor,
                                                          @"length": @(1)
                                                          },
                                                      @{
                                                          @"name": @"9 - brown",
                                                          @"color": UIColor.brownColor,
                                                          @"length": @(1)
                                                          },
                                                      ]];
    
    // Update the UICollectionViewLayout items as well
    self.testLayout.dictArray = self.dictArray;
    
    //
    // If need to reload the UICollectionView, do it now !
    //  In the -(void)viewDidLoad {} this is not needed
    //
    if (reloadCollectionView) {
        [self.collectionView reloadData];
    } else {}
    
}

@end
