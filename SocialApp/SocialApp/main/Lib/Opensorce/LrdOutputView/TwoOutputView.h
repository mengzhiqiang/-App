//
//  LrdOutputView.h
//  LrdOutputView
//
//  Created by 键盘上的舞者 on 4/14/16.
//  Copyright © 2016 键盘上的舞者. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TwoOutputViewDelegate <NSObject>

@required
//-(void)backindexPath:(NSIndexPath*)indexPath;
- (void)TwodidSelectedAtIndexPath:(NSIndexPath *)indexPath;
- (void)areaSelectWithString:(NSString *)area;
@end

typedef void(^dismissWithOperation)();

typedef NS_ENUM(NSUInteger, TwoLrdOutputViewDirection) {
    TwokLrdOutputViewDirectionLeft = 1,
    TwokLrdOutputViewDirectionRight
};

@interface TwoOutputView : UIView
@property (nonatomic,assign) NSInteger  tableViewHeight;
@property (nonatomic, weak) id<TwoOutputViewDelegate> delegate;
@property (nonatomic, strong) dismissWithOperation dismissOperation;

//初始化方法
//传入参数：模型数组，弹出原点，宽度，高度（每个cell的高度）
- (instancetype)initWithDataArray:(NSArray *)dataArray
                           origin:(CGPoint)origin
                            width:(CGFloat)width
                           height:(CGFloat)height
                        direction:(TwoLrdOutputViewDirection)direction;

//弹出
- (void)pop;
//消失
- (void)dismiss;

@end


@interface TwoLrdCellModel : NSObject
@property (nonatomic,assign) BOOL isSelect;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic,strong) NSString *_id;
- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName;

@end
