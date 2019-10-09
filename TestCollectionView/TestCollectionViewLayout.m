//
//  TestCollectionViewLayout.m
//  TestCollectionView
//
//  Created by Rafael on 08/10/19.
//  Copyright © 2019 Rafael. All rights reserved.
//

#import "TestCollectionViewLayout.h"


//
// UICollectionViewController reference
//
#import "TestCollectionViewController.h"


//
// NSLOG_DEBUG
//
#import "NSLogDebug.h"


//
// 0 - to use the same size to all cells (that works)
// 1 - to use dict[@"length"] as size (that doesn't works)
//

#define USE_DYNAMIC_SIZE 1


//
// Private interface
//
@interface TestCollectionViewLayout ()

@property (strong, nonatomic, nonnull) NSMutableArray <UICollectionViewLayoutAttributes *> *attributes;

@end


@implementation TestCollectionViewLayout

- (void)prepareLayout
{
    // Lazy init for cached attributes array
    if (self.attributes == nil) {
        self.attributes = [NSMutableArray <UICollectionViewLayoutAttributes *> array];
    } else {}
    
    
    CGFloat x = 0.0f;
    CGFloat y = 100.0f;
    CGFloat baseWidth = 128.0f;
    CGFloat height = 128.0f;
    CGFloat hSpace = 4.0f;
    CGFloat vSpace = 4.0f;
    
    NSUInteger row = 0;
    
    NSLOG_DEBUG(@"prepareLayout");
    
    //
    // For each item in the dictArray, calculate the cell's size
    //
    for (NSDictionary *dict in self.dictArray) {
        
        NSLOG_DEBUG(@"  row: %@  ==> %@ ( size: %@ )", @(row), dict[@"name"], dict[@"length"]);

        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        row ++;
        
        
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        //
        // This will make the cell width bigger or normal size
        //
#if USE_DYNAMIC_SIZE
        NSUInteger size = [dict[@"length"] unsignedIntegerValue];
        
        CGFloat width = baseWidth * size;
#else
        CGFloat width = baseWidth;
#endif
        
        //
        // Check if the cell can stay at same line (y), or next
        //
        if ((x + width) > self.collectionViewContentSize.width) {
            x = 0.0f;
            y += height + vSpace;
        } else {}
        
        //
        // Store the cell attribute frame
        //
        attribute.frame = CGRectMake(x, y, width, height);
        [self.attributes addObject:attribute];
        
        //
        // Prepare the next cell x position
        //
        x += width + hSpace;
        
    }
    
    NSLOG_DEBUG(@" ");
}

- (CGSize)collectionViewContentSize
{
    // FIXME hard coded used for the quick testing
    return CGSizeMake(400, 500);
}

- (NSArray <UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray <UICollectionViewLayoutAttributes *> *visible = [NSMutableArray array];
    
    //
    // Just return the visible attributes to speed up the perfomance
    //
    for (UICollectionViewLayoutAttributes *attribute in self.attributes) {
        if (CGRectIntersectsRect(attribute.frame, rect)) {
            [visible addObject:attribute];
        } else {}
    }
    
    
    return visible;
}



//
// This should be the method to call the moveItemAt...
//  I tried to put the remove/insertAt in the dictArray as well in the
//  attriubtes array, none worked !
//
- (UICollectionViewLayoutInvalidationContext *)invalidationContextForInteractivelyMovingItems:(NSArray<NSIndexPath *> *)targetIndexPaths withTargetPosition:(CGPoint)targetPosition previousIndexPaths:(NSArray<NSIndexPath *> *)previousIndexPaths previousPosition:(CGPoint)previousPosition
{
    
    NSLOG_DEBUG(@"invalidationContextForInteractivelyMovingItems");
    NSLOG_DEBUG(@"  previousIndexPaths: %@ - %@", @(previousIndexPaths.firstObject.section), @(previousIndexPaths.firstObject.row));
    NSLOG_DEBUG(@"  previousPosition: %@ , %@", @(previousPosition.x), @(previousPosition.y));
    NSLOG_DEBUG(@"  targetIndexPaths: %@ - %@", @(targetIndexPaths.firstObject.section), @(targetIndexPaths.firstObject.row));
    NSLOG_DEBUG(@"  targetPosition: %@ , %@", @(targetPosition.x), @(targetPosition.y));
    NSLOG_DEBUG(@"  ");

    UICollectionViewLayoutInvalidationContext *context = [super invalidationContextForInteractivelyMovingItems:targetIndexPaths withTargetPosition:targetPosition previousIndexPaths:previousIndexPaths previousPosition:previousPosition];
    
    if (previousIndexPaths.firstObject.row != targetIndexPaths.firstObject.row) {
        
        NSLOG_DEBUG(@" *** CHANGED *** ");
        
        // Not working anything here.
        
    } else {}
    
    return context;
    
}


@end
