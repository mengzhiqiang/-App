//
//  SAUICollectionViewFlowLayout.m
//  SallyDiMan
//
//  Created by zhiqiang meng on 9/10/2019.
//  Copyright © 2019 lijun L. All rights reserved.
//

#import "SAUICollectionViewFlowLayout.h"

@implementation SAUICollectionViewFlowLayout

#pragma mark - cell的左右间距

- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {

  NSMutableArray * answer = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
   /* 处理左右间距 */
   for(int i = 1; i < [answer count]; ++i) {

    UICollectionViewLayoutAttributes *currentLayoutAttributes = answer[i];
    UICollectionViewLayoutAttributes *prevLayoutAttributes = answer[i - 1];
    NSInteger maximumSpacing = 0;
    NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
       
    if(origin + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width) {
             CGRect frame = currentLayoutAttributes.frame;
             frame.origin.x = origin + maximumSpacing;
            currentLayoutAttributes.frame = frame;
          }
       }
    return answer;

}

@end
