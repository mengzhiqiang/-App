
//
//  DCCenterItemCell.m
//  CDDStoreDemo
//
//  Created by 陈甸甸 on 2017/12/12.
//Copyright © 2017年 strong. All rights reserved.
//

#import "DCCenterItemCell.h"

// Controllers

// Models
#import "DCStateItem.h"
// Views
#import "DCStateItemCell.h"
#import "DCStateItemFooterView.h"
#import "CustomShadowView.h"
// Vendors
#import <MJExtension.h>
// Categories

// Others

@interface DCCenterItemCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

/* collectionView */
@property (strong , nonatomic)UICollectionView *collectionView;
/* 数据 */
@property (strong , nonatomic)NSMutableArray<DCStateItem *> *stateItem;

@property (strong , nonatomic)CustomShadowView * shadowView;
@property (strong , nonatomic)UIView * backGrondView;

@property (strong , nonatomic)LMHPersonCenterModel * model;

@property (strong , nonatomic)UILabel * titleLabel;
@property (strong , nonatomic)UILabel * subtitleLabel ;
@property (strong , nonatomic) UIImageView * puhsImageView;

@end

static NSString *const DCStateItemCellID = @"DCStateItemCell";

static NSString *const DCStateItemFooterViewID = @"DCStateItemFooterView";

@implementation DCCenterItemCell

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *dcFlowLayout = [UICollectionViewFlowLayout new];
        dcFlowLayout.minimumLineSpacing = dcFlowLayout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:dcFlowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.frame = CGRectMake(0, 38, SCREEN_WIDTH-30, 75);
        _collectionView.scrollEnabled = NO;
        //注册Cell
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DCStateItemCell class]) bundle:nil] forCellWithReuseIdentifier:DCStateItemCellID];
//        //注册footerView
        [self addSubview:_collectionView];
        
    }
    return _collectionView;
}
-(CustomShadowView*)shadowView{
    if (!_shadowView) {
        _shadowView = [[CustomShadowView alloc]init];
        _shadowView.backgroundColor = [UIColor clearColor];
        _shadowView.frame = CGRectMake(15, 10, SCREEN_WIDTH-30, 120);
        [self addSubview:_shadowView];
    }
    return _shadowView;
}

-(UIView*)backGrondView{
    if (!_backGrondView) {
        _backGrondView = [[UIView alloc]init];
        _backGrondView.backgroundColor =White_Color;
        _backGrondView.frame = CGRectMake(0, 0, SCREEN_WIDTH-30, 120);
        [self.shadowView addSubview:_backGrondView];
    }
    return _backGrondView;
}

-(void)setCustomHeight:(CGFloat)height{
    self.height = height+10;
    
    self.shadowView.height = height;
    self.backGrondView.height = self.shadowView.height;
    self.collectionView.height = self.shadowView.height-38;
    [self.shadowView layoutIfNeeded];
    [self.backGrondView draCirlywithColor:nil andRadius:8.0f];
    [self.backGrondView addSubview:self.collectionView];

}
- (NSMutableArray<DCStateItem *> *)stateItem
{
    if (!_stateItem) {
        _stateItem = [NSMutableArray array];
    }
    return _stateItem;
}
-(void)loadNewUIWithStyle:(NSInteger)style andData:(LMHPersonCenterModel*)model{
    
    _model = model ;
    _style = style ;
    [self addDataOfstateItem:style];
    if (style ==1 || style ==2) {
        [self setCustomHeight:114];
    }else{
        [self setCustomHeight:190];
    }
    [_collectionView reloadData];
    [self addNewHeadView];
    self.backgroundColor = Main_BG_Color ;

}

-(void)addNewHeadView{
    
    NSArray * title = @[@"业绩中心",@"我的订单",@"工具与服务"];
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _collectionView.width, 38)];
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 9, 200, 20)];
    }
    _titleLabel.text = title[_style-1];
    _titleLabel.textColor = Main_title_Color;
    _titleLabel.font = [UIFont systemFontOfSize:14];
    [headView addSubview:_titleLabel];
    
     if (_style==2) {
         if (!_subtitleLabel) {
             _subtitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.shadowView.width-80, 9, 60, 20)];
         }
        _subtitleLabel.text = @"查看全部";
        _subtitleLabel.textColor = Main_title_Color;
        _subtitleLabel.font = [UIFont systemFontOfSize:12];
        [headView addSubview:_subtitleLabel];
         
         if (!_puhsImageView) {
             _puhsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.shadowView.width-20, 12, 7, 13)];
         }
         _puhsImageView.image = [UIImage imageNamed:@"grzx_icon_jt_gray"];
         [headView addSubview:_puhsImageView];
    }
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 37, _collectionView.width-30, 0.5)];
    lineView.backgroundColor = [UIColor HexString:@"eeeeee"];
    [headView addSubview:lineView];

    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = headView.bounds;
    [btn addTarget:self action:@selector(lookMore:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:btn];
    btn.backgroundColor = [UIColor clearColor];
    [self.shadowView addSubview:headView];
}
-(void)lookMore:(UIButton*)sender
{
    if (_backIndex) {
        _backIndex(100);
    }
}

#pragma mark - Intial
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = White_Color;
}

-(void)loadOrderCount:(NSDictionary*)diction{
    
    for (int i=0; i<_stateItem.count; i++) {
        DCStateItem * item = _stateItem[i];
        
        switch (i) {
            case 0:
                {
                    if ([diction[@"nopay"] intValue]>0) {
                        item.orderCount = diction[@"nopay"] ;
                    }
                }
                break;
            case 1:
            {
                if ([diction[@"nopay"] intValue]>0) {
                    item.orderCount = diction[@"nopay"] ;
                }
            }
                break;
            case 2:
            {
                if ([diction[@"nopay"] intValue]>0) {
                    item.orderCount = diction[@"nopay"] ;
                }
            }
                break;
            case 3:
            {
                if ([diction[@"nopay"] intValue]>0) {
                    item.orderCount = diction[@"nopay"] ;
                }
            }
                break;
            default:
                break;
        }
  
    }
    [_collectionView reloadData];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(self);
//    }];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    return 4 ;
    return _stateItem.count;
}

#pragma mark - <UICollectionViewDelegate>
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DCStateItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCStateItemCellID forIndexPath:indexPath];
    cell.stateItem = _stateItem[indexPath.row];//赋值
//    cell.backgroundColor = [UIColor redColor];
    if (_style == 2) {
        switch (indexPath.row) {
            case 0:
            {
                if ([_model.waitPayment intValue] > 0) {
                    cell.orderCount.text = [NSString stringWithFormat:@"%@",_model.waitPayment];
                    cell.orderCount.hidden = NO;
                }
            }
                break;
            case 1:
            {
                if ([_model.waitDeliver intValue]>0) {
                    cell.orderCount.text = [NSString stringWithFormat:@"%@",_model.waitDeliver];
                    cell.orderCount.hidden = NO;
                }
            }
                break;
            case 2:
            {
                if ([_model.waitTake intValue] >0) {
                    cell.orderCount.text = [NSString stringWithFormat:@"%@",_model.waitTake];
                    cell.orderCount.hidden = NO;
                }
            }
                break;
            case 3:
            {
                if ([_model.afterSales integerValue]>0) {
                    cell.orderCount.text = [NSString stringWithFormat:@"%@",_model.afterSales];
                    cell.orderCount.hidden = NO;
                }
            }
                break;
            default:
                break;
        }
    }
    
    return cell;
}


//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView *reusableView = nil;
//    if (kind == UICollectionElementKindSectionHeader) {
////        DCStateItemFooterView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DCStateItemFooterViewID forIndexPath:indexPath];
////        reusableView = footer;
//        UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _collectionView.width, 38)];
//        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 9, 200, 20)];
//        titleLabel.text = @"我的订单";
//        titleLabel.textColor = Main_title_Color;
//        titleLabel.font = [UIFont systemFontOfSize:14];
//        [headView addSubview:titleLabel];
//
//        UILabel * subtitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.shadowView.width-90, 9, 100, 20)];
//        subtitleLabel.text = @"查看全部";
//        subtitleLabel.textColor = Main_title_Color;
//        subtitleLabel.font = [UIFont systemFontOfSize:12];
//        [headView addSubview:subtitleLabel];
//
//        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(subtitleLabel.right+5, 9, 20, 20)];
//        imageView.image = [UIImage imageNamed:@""];
//        [headView addSubview:imageView];
//
//    }
//    return reusableView;
//}

#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_style==1) {
        return CGSizeMake(self.shadowView.width / 2, 75);
    }
    return CGSizeMake(self.shadowView.width / 4, 75);
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.shadowView.width, 0);

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"====");
    if (_backIndex) {
        _backIndex((int)indexPath.row);
    }
}

-(void)setOrderArray:(NSArray *)orderArray{
    _orderArray = orderArray;
    if (_orderArray.count>0) {
        [_collectionView reloadData];
    }
}


-(void)addDataOfstateItem:(NSInteger)style{
    
    self.stateItem = nil;
    if (style==2) {
        NSArray * title = @[@"待付款",@"待发货",@"待收货",@"售后"];
        NSArray * image = @[@"grzx_icon_dfk",@"grzx_icon_dfh",@"grzx_icon_dsh",@"grzx_icon_sh"];

        for (int i=0; i<4; i++) {
            DCStateItem * item = [[DCStateItem alloc]init];
            item.stateTitle = title[i];
            item.imageContent = image[i];
            item.showImage = YES;

            [self.stateItem addObject:item];
        }
    }
    else if (style==1) {
//        NSArray * title = @[@"今日销售",@"今日省赚",@"本月销售",@"本月省赚"];
        NSArray * title = @[@"今日销售",@"本月销售"];
        NSArray * image = @[@"00",@"369.00",@"93,230.00",@"0.00"];
        if (_model) {
           image = @[[NSString stringWithFormat:@"%.2f",_model.dayConsume.floatValue],[NSString stringWithFormat:@"%.2f",_model.monthConsume.floatValue]];
        }
        for (int i=0; i<2; i++) {
            DCStateItem * item = [[DCStateItem alloc]init];
            item.stateTitle = title[i];
            item.showImage = NO;
            item.imageContent = image[i];
            [self.stateItem addObject:item];
        }
    }
    else if (style==3) {
//        NSArray * title = @[@"我的账户",@"团队中心",@"地址管理",@"邀请好友",@"帮助中心",@"联系客服",@"设置"];
//        NSArray * image = @[@"grzx_icon_wdzh",@"grzx_icon_tdzx",@"grzx_icon_dzgl",@"grzx_icon_yqhy",@"grzx_icon_bzzx",@"grzx_icon_lxkf",@"grzx_icon_sz"];
//
        NSArray * title = @[@"我的账户",@"地址管理",@"帮助中心",@"联系客服",@"设置"];
        NSArray * image = @[@"grzx_icon_wdzh",@"grzx_icon_dzgl",@"grzx_icon_bzzx",@"grzx_icon_lxkf",@"grzx_icon_sz"];
        
        for (int i=0; i<title.count; i++) {
            DCStateItem * item = [[DCStateItem alloc]init];
            item.stateTitle = title[i];
            item.imageContent = image[i];
            item.showImage = YES;
            [self.stateItem addObject:item];

        }
    }
    
}

@end
