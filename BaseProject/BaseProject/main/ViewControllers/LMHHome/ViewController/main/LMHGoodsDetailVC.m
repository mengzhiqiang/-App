//
//  LMHGoodsDetailVC.m
//  BaseProject
//
//  Created by wfg on 2019/9/19.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHGoodsDetailVC.h"
#import "LMHGoodDetailModel.h"
#import "LMHImageCollectionViewCell.h"
#import "LMHCellSizeTools.h"
#import "CustomActionSheetView.h"
#import "LMHShareGoodsView.h"
#import <ShareSDK/ShareSDK.h>
#import "LMHForwardingPriceView.h"
#import "SDCycleScrollView.h"
#import "WXApi.h"
#import "ShareSystemTools.h"

@interface LMHGoodsDetailVC () <
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
SDCycleScrollViewDelegate>
{
    CustomActionSheetView * shareView;

}
@property (weak, nonatomic) IBOutlet UIScrollView *imgsSV;
@property (weak, nonatomic) IBOutlet UILabel *desLbl;
@property (weak, nonatomic) IBOutlet UILabel *amountLbl;
@property (weak, nonatomic) IBOutlet UILabel *originAmountLbl;
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;
@property (weak, nonatomic) IBOutlet UILabel *countLbl;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *rootScrollView;

@property (strong, nonatomic) IBOutlet UICollectionView *collectView;
@property (assign, nonatomic)  NSInteger selectGuigeIndex;
@property (assign, nonatomic)  NSInteger slectGoodcount;
@property (strong, nonatomic) LMHGoodDetailModel *goodModel;

@property (weak, nonatomic) IBOutlet UIView *middleView;
@property(nonatomic,strong) LMHShareGoodsView* shareGoodView;

@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;
/* 轮播图数组 */
@property (copy , nonatomic)NSMutableArray *imageGroupArray;

@property (weak, nonatomic) IBOutlet UIView *lowView;

@end

@implementation LMHGoodsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"商品详情";
    // Do any additional setup after loading the view from its nib.
    [self setUpUI];
    [self getGoodsDetail];
    
}
- (void)setUpUI
{
    _imageGroupArray  = [NSMutableArray arrayWithCapacity:20];
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH) delegate:self placeholderImage:nil];
    _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
    _cycleScrollView.autoScrollTimeInterval = 5.0;
    [self.headImageView addSubview:_cycleScrollView];
    _cycleScrollView.userInteractionEnabled = YES;
    self.headImageView.userInteractionEnabled = YES;
    _lowView.top  = SCREEN_HEIGHT;
    
}

#pragma mark - 点击图片Bannar跳转
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"点击了%zd轮播图",index);
    
    
}

- (IBAction)countAction:(UIButton *)sender {
    
    if (_selectGuigeIndex==0) {
        [MBProgressHUD showError:@"请选择款式!"];
        return;
    }
    
    NSInteger count = self.countLbl.text.integerValue;
    if (sender.tag == 0) {
        if (count <= 1) {
            count = 1;
        } else {
            count--;
        }
    } else {
        if (count>=_slectGoodcount) {
            count = _slectGoodcount;
        }else{
            count++;
        }
    }
    self.countLbl.text = @(count).stringValue;
}

- (IBAction)reduceAction:(UIButton *)sender {
}

- (IBAction)serviceAction:(UIButton *)sender {
    [self callWithPhone];
}
#pragma mark  打电话
-(void)callWithPhone{
    
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"4008882435"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:nil completionHandler:nil];
    
}
- (IBAction)shareAction:(UIButton *)sender {
    
    [self.view addSubview:self.shareGoodView];
    [self.shareGoodView shareimage:self.goodModel];
}

- (IBAction)shopCarAction:(UIButton *)sender {
    [self joinCar];
}


-(void)getGoodsDetail{
    
    if (_goodID.length<1) {
        [MBProgressHUD showError:@"无商品ID！"];
        return;
    }
    [MBProgressHUD showActivityIndicator];
    NSString *path = [API_HOST stringByAppendingString:client_goods_getGoodsDetail];
    NSDictionary*dict = @{@"goodsId":_goodID};
    WS(weakself);
    [HttpEngine requestPostWithURL:path params:dict isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        
        [MBProgressHUD hideActivityIndicator];
        if ([responseObject objectForKey:@"data"] ) {
            weakself.goodModel = [LMHGoodDetailModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
//            if (!weakself.goodModel.isShelves) {
//                 [AFAlertViewHelper alertViewWithTitle:@"" message:@"该商品暂未排期，敬请期待！" delegate:self cancelTitle:@"确定" otherTitle:nil clickBlock:^(NSInteger buttonIndex) {
//                      [self.navigationController popViewControllerAnimated:YES];
//                } ];
////                return ;
//            }
            [weakself loadNewData];
            
        }else{
            [AFAlertViewHelper alertViewWithTitle:@"" message:@"该商品获取失败，请稍后再试！" delegate:self cancelTitle:@"确定" otherTitle:nil clickBlock:^(NSInteger buttonIndex) {
                       [self.navigationController popViewControllerAnimated:YES];
                } ];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideActivityIndicator];
        NSDictionary *userInfo = error.userInfo;
        NSLog(@"==JSONDic=userInfo==%@",userInfo);
        if ([userInfo[@"msg"] isEqualToString:@"商品ID为空"]) {
                   [AFAlertViewHelper alertViewWithTitle:@"" message:@"该商品暂未排期，敬请期待！" delegate:self cancelTitle:@"确定" otherTitle:nil clickBlock:^(NSInteger buttonIndex) {
                       [self.navigationController popViewControllerAnimated:YES];
                   } ];
        }else{
             [MBProgressHUD showError:userInfo[@"msg"]];
        }
        
    }];
    
}

-(void)loadNewData
{
    NSDictionary  *dic = _goodModel.specifications.firstObject;
    self.desLbl.text = [NSString stringWithFormat:@"%@、%@-¥%@ \n%@" ,_goodModel.goodsSn,_goodModel.goodsName,dic[@"recommendedPrice"] ,_goodModel.goodsDesc];
    self.amountLbl.text     = [NSString stringWithFormat:@"¥%.2f",[dic[@"sellPrice"] floatValue]];
    self.originAmountLbl.text   = [NSString stringWithFormat:@"¥%.2f",[dic[@"marketPrice"] floatValue]];
    
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",self.originAmountLbl.text]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, self.originAmountLbl.text.length)];
    self.originAmountLbl.attributedText = newPrice ;
    
    [self.reduceBtn setTitle:[NSString stringWithFormat:@" 省赚：¥%ld",[dic[@"recommendedPrice"] integerValue]-[dic[@"sellPrice"] integerValue]] forState:UIControlStateNormal];;
    
    NSArray  *array = _goodModel.goodsPicList;
    
    [_headImageView setImageWithURL:[array.firstObject[@"url"] changeURL] placeholderImage:[UIImage imageNamed:DefluatPic]];
    
    [self loadCollectView];
}


#pragma mark - LazyLoad
- (void)loadCollectView
{
    
    _collectView.delegate = self;
    _collectView.dataSource = self;
    _collectView.showsVerticalScrollIndicator = NO;        //注册
    _collectView.scrollEnabled = NO;
    [_collectView registerNib:[UINib nibWithNibName:NSStringFromClass([LMHImageCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"LMHImageCollectionViewCell"];
    _collectView.backgroundColor = White_Color;
    NSString * specificationName = [_goodModel.specifications.firstObject objectForKey:@"specificationName"];
    long  guigeCount = (_goodModel.specifications.count%[LMHCellSizeTools cellWith:specificationName]==0? _goodModel.specifications.count/[LMHCellSizeTools cellWith:specificationName]:_goodModel.specifications.count/[LMHCellSizeTools cellWith:specificationName]+1);
    CGFloat height = guigeCount*30+10;
    _collectView.height = height;
    [_collectView mas_updateConstraints:^(MASConstraintMaker *make) {
         make.top.mas_equalTo(40);
         make.height.mas_equalTo(height);
         make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    for (NSDictionary*diction in _goodModel.goodsPicList) {
        [_imageGroupArray addObject:diction[@"url"]];
    }
    _cycleScrollView.imageURLStringsGroup = _imageGroupArray;

    
    [_rootScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, _rootScrollView.height+50+self.desLbl.height)];
//    _rootScrollView.height = SCREEN_HEIGHT - 64-50 ;
    _rootScrollView.scrollEnabled = YES;
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger count = (_goodModel.specifications.count?_goodModel.specifications.count:_goodModel.goodsSpecifications.count) ;
    
    return count ;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LMHImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LMHImageCollectionViewCell" forIndexPath:indexPath];

        cell.contentLabel.hidden = NO;
        cell.imageView.hidden = YES;
        NSString * specificationName;
        if (_goodModel.specifications.count) {
            specificationName = [_goodModel.specifications[indexPath.row] objectForKey:@"specificationName"];
            
        }else{
            specificationName = [_goodModel.goodsSpecifications[indexPath.row] objectForKey:@"specificationName"];
        }
        
        cell.contentLabel.text = specificationName;
        [cell.contentLabel draCirlywithColor:nil andRadius:2.0f];
        
        if (_selectGuigeIndex==indexPath.row+100) {
            cell.contentLabel.backgroundColor = Main_Color;
        }else{
            cell.contentLabel.backgroundColor = [UIColor HexString:@"f5f5f5"];
        }
        cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
        NSString * specificationName ;
        if (_goodModel.specifications.count) {
            specificationName = [_goodModel.specifications.firstObject objectForKey:@"specificationName"];
        }else{
            specificationName = [_goodModel.goodsSpecifications.firstObject objectForKey:@"specificationName"];
        }
        NSInteger  guigeCount = [LMHCellSizeTools cellWith:specificationName];
        return CGSizeMake((SCREEN_WIDTH-60)/guigeCount, 30);
    return CGSizeZero;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    if (indexPath.section == 0) {
        layoutAttributes.size = CGSizeMake(0,0);
    }else{
        layoutAttributes.size = CGSizeMake(self.view.width, 30);
        
    }
    return layoutAttributes;
}

#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {

    return CGSizeZero;
}

////代理方法, 控制每个段的边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

#pragma mark - foot宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    return CGSizeZero;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return  10.0;
}
#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return (section >= 1) ? 4 : 6;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
 
    _selectGuigeIndex = indexPath.row+100;
    [collectionView reloadData];
    
    if (_goodModel.specifications.count) {
        _slectGoodcount = [[_goodModel.specifications[indexPath.row] objectForKey:@"repertory"] integerValue];
        
    }else{
        _slectGoodcount = [[_goodModel.goodsSpecifications[indexPath.row] objectForKey:@"repertory"] integerValue];
    }
}

#pragma mark 分享
-(void)showShareView{
    if (!shareView) {
        shareView =    [[CustomActionSheetView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    shareView.hidden = NO;
    shareView.backClick = ^(NSInteger buttonIndex) {
        shareView.hidden = YES;
        if (buttonIndex!=100) {
            [self shareAppWithIndex:buttonIndex];
        }
    };
    [[UIViewController getCurrentController].view addSubview:shareView];
    
}

-(LMHShareGoodsView*)shareGoodView{
    WS(weakself);
    if (!_shareGoodView) {
        _shareGoodView = [[NSBundle mainBundle] loadNibNamed:@"LMHShareGoodsView" owner:self options:nil].firstObject;
        _shareGoodView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) ;
        _shareGoodView.backSelect = ^(NSInteger index) {
            if (index==11) {
//                if ([WXApi isWXAppInstalled] && weakself.shareGoodView.shareImages.count==1 ) {
//                    [weakself showShareView];
//                }else{
                    [ ShareSystemTools shareWithData:weakself.shareGoodView.shareImages ];
//                }
                
            }else{
                //转发价格
                LMHForwardingPriceView *view = [[NSBundle mainBundle] loadNibNamed:@"LMHForwardingPriceView" owner:weakself options:nil].firstObject;
                [[UIViewController getCurrentController].view addSubview:view];
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo([UIViewController getCurrentController].view);
                }];
                view.backload = ^(NSString * _Nonnull price) {
                    [weakself.shareGoodView loadChangePrice:price];  //分享图片更新的价格
                };
               
            }
        };
    }
    _shareGoodView.hidden = NO;
    return _shareGoodView;
}

-(void)shareAppWithIndex:(NSInteger)index{
    
    NSInteger shareStyle = SSDKPlatformTypeWechat;
    switch (index-10) {
        case 1:
            shareStyle = SSDKPlatformTypeQQ;
            break;
        case 2:
            shareStyle = SSDKPlatformTypeSinaWeibo;
            break;
        case 3:
            shareStyle = SSDKPlatformSubTypeWechatTimeline;
            break;
            
        default:
            break;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:20];
    [dic SSDKSetupShareParamsByText:nil
                             images:_shareGoodView.shareImages
                                url:nil
                              title:nil
                               type:SSDKContentTypeImage];
    //
    [ShareSDK share:shareStyle
         parameters:dic
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData,
                      SSDKContentEntity *contentEntity, NSError *error) {
         switch (state) {
             case SSDKResponseStateSuccess:
                 NSLog(@"成功");//成功
                 break;
             case SSDKResponseStateFail:
             {
                 NSLog(@"--%@",error.description);
                 //失败
                 break;
             }
             case SSDKResponseStateCancel:
                 NSLog(@"取消");
                 //取消
                 break;
                 
             default:
                 break;
         }
     }];
}


#pragma mark  加入购物车
- (void)joinCar{
    
    if (_selectGuigeIndex==0) {
        [MBProgressHUD showError:@"请选择规格！"];
        return;
    }
    
    [MBProgressHUD showActivityIndicator];
    NSString *path = [API_HOST stringByAppendingString:client_cart_addCart];
    
    NSMutableDictionary * diction = [NSMutableDictionary dictionaryWithCapacity:20];
    [diction setObject:_goodModel.goodsId forKey:@"goodsId"];
    [diction setObject:_goodModel.goodsName forKey:@"goodsName"];
    
    [diction setObject:_goodModel.brandName forKey:@"brandName"];
    [diction setObject:_goodModel.brandLogo forKey:@"brandUrl"];
    [diction setObject:_goodModel.brandId forKey:@"brandId"];
        
 
    NSDictionary *dict =  _goodModel.specifications[_selectGuigeIndex-100];
    [diction setObject:dict[@"specificationName"] forKey:@"goodsSpecifications"];
    [diction setObject:dict[@"specificationId"] forKey:@"specificationsId"];
    [diction setObject:dict[@"sellPrice"] forKey:@"price"];

    
        NSDictionary *picDic =  _goodModel.goodsPicList.firstObject;
        [diction setObject:picDic[@"url"] forKey:@"goodsUrl"];
 
    [diction setObject:_countLbl.text forKey:@"num"];
    
    [HttpEngine requestPostWithURL:path params:diction isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        [MBProgressHUD hideActivityIndicator];
        
        [MBProgressHUD showSuccess:@"已成功添加购物车！"];
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideActivityIndicator];
        NSDictionary *userInfo = error.userInfo;
        NSLog(@"==JSONDic=userInfo==%@",userInfo);
        [MBProgressHUD showError:userInfo[@"msg"]];
        
    }];
    
}


@end
