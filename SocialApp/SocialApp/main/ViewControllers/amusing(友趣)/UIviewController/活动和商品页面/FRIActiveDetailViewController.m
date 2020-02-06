//
//  FRIActiveDetailViewController.m
//  SocialApp
//
//  Created by zhiqiang meng on 3/1/2020.
//  Copyright © 2020 zhiqiang meng. All rights reserved.
//

#import "FRIActiveDetailViewController.h"
#import "SDCycleScrollView.h"
#import "FRIActiveEditViewController.h"
#import "FRIGoodModel.h"
#import "FRIActiveListModel.h"

@interface FRIActiveDetailViewController ()<UIScrollViewDelegate,SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *rootScrollView;
@property (weak, nonatomic) IBOutlet UIView *rootView;

@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UILabel *initiateLabel;
@property (weak, nonatomic) IBOutlet UILabel *unInjionLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIView *joinNumberView;
@property (weak, nonatomic) IBOutlet UILabel *comedCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumCountLabel;

@property (weak, nonatomic) IBOutlet UIView *requestView;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *eduLabel;
@property (weak, nonatomic) IBOutlet UILabel *marryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopAddressLabel;

@property (weak, nonatomic) IBOutlet UIView *goodView;
@property (weak, nonatomic) IBOutlet UILabel *goodTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodPriceLabel;

@property (weak, nonatomic) IBOutlet UIView *goodContentView;
@property (weak, nonatomic) IBOutlet UITextView *goodContentTV;
@property (weak, nonatomic) IBOutlet UILabel *goodContentLabel;

@property(nonatomic, strong)SDCycleScrollView *cycleScrollView;


@property(nonatomic, strong)FRIGoodModel *goodModel;
@property(nonatomic, strong)FRIActiveListModel *activeModel;

@property (assign, nonatomic) float  footHeight;


@end



@implementation FRIActiveDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _rootScrollView.frame =  CGRectMake(0, SCREEN_top, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_top-50);
    [_rootScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH+_rootView.height)];
    
    [_rootScrollView addSubview:self.cycleScrollView];
    _rootView.top = SCREEN_WIDTH;
    _cycleScrollView.imageURLStringsGroup= @[@"img_smrz",@"img_smrz"];
    [self creatUI];
    
    self.customNavBar.title = (_style==1?@"活动详情":@"商品详情");
    [self loadNewData];
}
-(void)creatUI{
    _unInjionLabel.backgroundColor = [UIColor colorWithRed:26/255.0 green:157/255.0 blue:199/255.0 alpha:0.4];
    _initiateLabel.backgroundColor = [UIColor colorWithRed:26/255.0 green:157/255.0 blue:199/255.0 alpha:0.4];
}

-(SDCycleScrollView*)cycleScrollView{
    
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH) delegate:self placeholderImage:nil];
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
        _cycleScrollView.autoScrollTimeInterval = 4.0;
        [_cycleScrollView draCirlywithColor:nil andRadius:8.0f];
    }
    return _cycleScrollView;
}

- (IBAction)lowActionButton:(UIButton *)sender {
  
    if (sender.tag==10) {
       if (_style==1) {
           ///分享

       }else{
           ///联系商家
           
       }
    }else
    {
        if (_style==1) {
            [AFAlertViewHelper  alertViewWithTitle:@"提示" message:@"是否确定参加该活动？ 该活动预计花费 ¥ 50.00  " delegate:self cancelTitle:@"取消" otherTitle:@"确定" clickBlock:^(NSInteger buttonIndex) {
                       
                   }];
        }else{
            FRIActiveEditViewController* addActiveVC = [FRIActiveEditViewController new];
                   addActiveVC.storeID = _activeID;
          [self.navigationController pushViewController:addActiveVC animated:YES];        }
       
    }
}

#pragma mark 获取商家详情
-(void)loadNewData{
    NSString * api = [API_HOST stringByAppendingString:(_style==1?youFun_activityDetail: youFun_commodity)];
    NSDictionary*diciton = @{(_style==1? @"activityId":@"commodityId"): _activeID};
    WS(weakself);
    [HttpEngine requestGetWithURL:api params:diciton isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {

        if (weakself.style==0) {
            weakself.goodModel = [FRIGoodModel mj_objectWithKeyValues:[responseObject[@"data"] objectAtIndex:0]];
            [self upadatUIWithGood];
        }else{
            weakself.activeModel = [FRIActiveListModel mj_objectWithKeyValues:responseObject[@"data"]];
            [self upadatUIWithActiveModel];
        }
        
    } failure:^(NSError *error) {
//        [weakself.collectionView.mj_footer endRefreshing];
//        [weakself.collectionView.mj_header endRefreshing];
        
    }];
}

-(void)upadatUIWithGood
{

    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:20];
      for (NSString * string in [_goodModel.commodityImg componentsSeparatedByString:@","]) {
          [array addObject:URL(string)];
      }
      _cycleScrollView.imageURLStringsGroup = array;
      
      _rootView.top = _cycleScrollView.bottom;
      _titleLabel.text = _goodModel.commodityName;
      _timeLabel.text = [NSString stringWithFormat:@"¥%.2f",_goodModel.commodityPrice.floatValue ];
    _timeLabel.textColor = [UIColor redColor];
    _timeLabel.font = [UIFont systemFontOfSize:18];
    _initiateLabel.text = [NSString stringWithFormat:@"人数：%d人",_goodModel.maxNum.intValue];
    _unInjionLabel.text = [NSString stringWithFormat:@"提前%d小时可退",_goodModel.advanceHour.intValue];
    
        _goodContentLabel.text = _goodModel.commodityIntroduce;
        _goodContentLabel.height = [self getHeightByLabel:_goodContentLabel];
        
        _goodContentView.top = 132 ;
        _goodContentView.height = _goodContentLabel.height + 50 ;
        
        _rootView.height = _goodContentView.bottom;
        
        _rootView.clipsToBounds = YES;
        
    NSMutableArray *arrayInd = [NSMutableArray arrayWithCapacity:20];
         for (NSString * string in [_goodModel.commodityDetails componentsSeparatedByString:@","]) {
             [arrayInd addObject:URL(string)];
         }
    [_rootScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, _rootView.bottom+arrayInd.count*200)];
    [self loadImages:arrayInd];

}

-(void)upadatUIWithActiveModel
{
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:20];
    for (NSString * string in [_activeModel.commodityImg componentsSeparatedByString:@","]) {
        [array addObject:URL(string)];
    }
    _cycleScrollView.imageURLStringsGroup = array;
    
    _rootView.top = _cycleScrollView.bottom;
    _titleLabel.text = _activeModel.activityName;
    _timeLabel.text = [NSString stringWithFormat:@"%@   ID：%@",_activeModel.activityTime,_activeModel.activityId ];
    _initiateLabel.text = (_activeModel.activitySponsor.intValue==2?@"商家发起":@"个人发起");
    _unInjionLabel.text = [NSString stringWithFormat:@"提前%d小时可退",_activeModel.advanceHour.intValue];
    _comedCountLabel.text = _activeModel.gatherAmount;
    _sumCountLabel.text   = _activeModel.activityNum;
    
    _sexLabel.text = [NSString stringWithFormat:@"性别：%@",(_activeModel.requireSex.intValue==1?@"同性":@"不限")];
    _eduLabel.text = [NSString stringWithFormat:@"学历：%@", [self EducationWithID: _activeModel.requireEducation.intValue ]];
    _ageLabel.text = [NSString stringWithFormat:@"年龄层次：%@",(_activeModel.requireAge?_activeModel.requireAge:@"18-24岁")];
    _marryLabel.text = [NSString stringWithFormat:@"婚恋状况：%@",(_activeModel.requireMarriage.intValue==0?@"不限":(_activeModel.requireMarriage.intValue==1?@"单身":@"非单身"))];

    [_shopImageView setImageWithURL:[NSURL URLWithString:URL(_activeModel.merchantImg)] placeholderImage:[UIImage imageNamed:@""]];
    _shopAddressLabel.text = _activeModel.merchantAddress;
    _shopNameLabel.text = _activeModel.merchantName;
    
    
    _goodNameLabel.text = _activeModel.commodityName;
    _goodTimeLabel.text = [NSString stringWithFormat:@"提前%d小时可退",_activeModel.advanceHour.intValue];
    _goodPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",_activeModel.commodityPrice.floatValue];
    [_shopImageView setImageWithURL:[NSURL URLWithString:URL(array.firstObject)] placeholderImage:[UIImage imageNamed:@""]];
    
//    _goodContentTV.text = _activeModel.commodityIntroduce;
    
    _goodContentLabel.text = _activeModel.commodityIntroduce;
    _goodContentLabel.height = [self getHeightByLabel:_goodContentLabel];
    
    _goodContentView.height = _goodContentLabel.height + 50 ;
    
    _rootView.height = _goodContentView.bottom;
    
    
    NSMutableArray *arrayInd = [NSMutableArray arrayWithCapacity:20];
       for (NSString * string in [_activeModel.commodityDetails componentsSeparatedByString:@","]) {
           [arrayInd addObject:URL(string)];
       }
    [_rootScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, _rootView.bottom+arrayInd.count*200)];

    [self loadImages:arrayInd];
    
    /**
    return;
    
    UIView * footV = [[UIView alloc]initWithFrame:CGRectMake(0, _rootView.bottom, SCREEN_WIDTH, 1000)];
    [_rootScrollView addSubview:footV];
    NSMutableArray * arrayView = [NSMutableArray arrayWithCapacity:20];

   
    for (int i=0; i<arrayInd.count ;i++) {
//        CGRect rect  = CGRectMake(0, _rootView.bottom+200*i, SCREEN_WIDTH, 200);
        UIImageView *img = [[UIImageView alloc]init];
        [img setImageWithURL:[NSURL URLWithString:arrayInd[i]] placeholderImage:[UIImage imageNamed:@""]];
        [footV addSubview:img];
        img.contentMode =  UIViewContentModeScaleAspectFill ;
        [arrayView addObject:img];
        
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i==0) {
            make.top.equalTo(footV);
            }else{
                UIImageView *ig = arrayView[i-1];
                make.top.equalTo(ig.mas_bottom);
            }
            
          make.left.equalTo(footV);
          make.width.equalTo(footV); //use .multipliedBy()/.dividedBy() if you want to display multiple slides in one row
        }];
        WS(weakself);
        [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:arrayInd[i]] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            
            if (image) {
            weakself.footHeight = image.size.height*(SCREEN_WIDTH/image.size.width )+weakself.footHeight;
            [weakself.rootScrollView setContentSize:CGSizeMake(SCREEN_WIDTH,weakself.rootView.bottom + weakself.footHeight+50+50)];
            }
          
        }];
//
    }
     */
    
}
- (void)loadImages:(NSArray*)array
  {
      // 异步下载
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         
          NSMutableArray * images = [NSMutableArray arrayWithCapacity:20];
          for (int i=0; i<array.count; i++) {
              NSData *data1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:array[i]]];
              UIImage *image1 = [UIImage imageWithData:data1];
              if (image1) {
                  [images addObject:image1];
              }
          }
            
          // 4.回到主线程显示图片
          dispatch_async(dispatch_get_main_queue(), ^{
              [self addImages:images];
          });
      });
  
}
   
-(void)addImages:(NSArray*)array{
    
    UIView * footV = [[UIView alloc]initWithFrame:CGRectMake(0, _rootView.bottom, SCREEN_WIDTH, 1000)];
       [_rootScrollView addSubview:footV];
    NSMutableArray * arrayView = [NSMutableArray arrayWithCapacity:20];
    CGRect rect  = CGRectMake(0, 0, SCREEN_WIDTH, 200);
      for (int i=0; i<array.count ;i++) {
            UIImageView *img = [[UIImageView alloc]initWithFrame:rect];
            img.image = array[i];
            [footV addSubview:img];
            self.footHeight = img.image.size.height*(SCREEN_WIDTH/img.image.size.width )+self.footHeight;
          img.height = self.footHeight;
          if (i==0) {
              img.top=0;
          }else{
              UIImageView *ig = arrayView[i-1];
              img.top=ig.bottom;

          }
          img.contentMode =  UIViewContentModeScaleAspectFill ;
          [arrayView addObject:img];
          
      }
    UIImageView *ig = arrayView.lastObject;
    [_rootScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, _rootView.bottom+ig.bottom)];

}

-(NSString*)EducationWithID:(int)eduID{
  
    switch (eduID) {
        case 0:
            return @"不限";
            break;
        case 1:
            return @"大学专科以下";
            break;
        case 2:
            return @"大学专科";
            break;
        case 3:
            return @"大学本科";
            break;
        case 4:
            return @"研究生硕士";
            break;
        case 5:
        return @"研究生博士";
           break;
            break;
    }
    
    return @"不限";
}


- (CGFloat)getHeightByLabel:(UILabel*)FLabel;
{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, FLabel.width, 0)];
    label.text = FLabel.text;
    label.font = FLabel.font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return ceil(height);
}

@end
