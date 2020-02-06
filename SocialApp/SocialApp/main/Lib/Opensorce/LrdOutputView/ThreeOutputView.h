//
//  LrdOutputView.h
//  LrdOutputView
//
//  Created by 键盘上的舞者 on 4/14/16.
//  Copyright © 2016 键盘上的舞者. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ThreeOutputViewDelegate <NSObject>

@required
//-(void)backindexPath:(NSIndexPath*)indexPath;
- (void)TwodidSelectedAtIndexPath:(NSIndexPath *)indexPath dataArr:(NSArray *)arr;

@end

typedef void(^dismissWithOperation)();

typedef NS_ENUM(NSUInteger, ThreeLrdOutputViewDirection) {
    ThreekLrdOutputViewDirectionLeft = 1,
    ThreekLrdOutputViewDirectionRight
};

@interface ThreeOutputView : UIView

@property (nonatomic, weak) id<ThreeOutputViewDelegate> delegate;
@property (nonatomic, strong) dismissWithOperation dismissOperation;
//是否是优惠券
@property (nonatomic,assign) BOOL isCoupon;
//初始化方法
//传入参数：模型数组，弹出原点，宽度，高度（每个cell的高度）
- (instancetype)initWithDataArray:(NSArray *)dataArray
                           origin:(CGPoint)origin
                            width:(CGFloat)width
                           height:(CGFloat)height
                        direction:(ThreeLrdOutputViewDirection)direction;

//弹出
- (void)pop;
//消失
- (void)dismiss;

@end


@interface ThreeLrdCellModel : NSObject


//@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageName;
//@property (nonatomic,strong) NSString *_id;
@property (nonatomic,assign) BOOL isSelect;

/** 优惠券ID */
@property (nonatomic,strong) NSString *_id;
/** 券号 */
@property (nonatomic,strong) NSString *coupon_no;
/** 标题 */
@property (nonatomic,strong) NSString *title;
/** 产品ID,为0时通用 */
@property (nonatomic,strong) NSString *product_id;
/** 产品名称,产品ID为0 时通用 */
@property (nonatomic,strong) NSString *product_name	;
/** 条件数值 */
@property (nonatomic,strong) NSString *condition;
/** 条件类型(0-满吨数,1-满总额) */
@property (nonatomic,strong) NSString *condition_type;
/** 优惠类型(0-减单价,1-减总额) */
@property (nonatomic,strong) NSString *amount_type;
/** 优惠券的数量 */
@property (nonatomic,strong) NSString *number;
/** 已被领取的数量 */
@property (nonatomic,strong) NSString *use_number;
/** 使用说明(html) */
@property (nonatomic,strong) NSString *explain;
/** 有效期开始日期 */
@property (nonatomic,strong) NSString *start_time;
/** 有效期结束日期 */
@property (nonatomic,strong) NSString *end_time;
/** 价格 */
@property (nonatomic,strong) NSString *amount;
/** 日期 */
@property (nonatomic,strong) NSString *time;
/** 用户是否已领取(1-已领取,0-未领取) */
@property (nonatomic,strong) NSString *is_receive;
- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName;
/** 是否是支付方式的model */
@property (nonatomic,assign) BOOL isPay;
//是否是汇票的model
@property (nonatomic,assign) BOOL isDraft;
/** 汇票的价格 */
@property (nonatomic,strong) NSString *price;
/** 汇票的数量 */
@property (nonatomic,strong) NSString *total;


@end
