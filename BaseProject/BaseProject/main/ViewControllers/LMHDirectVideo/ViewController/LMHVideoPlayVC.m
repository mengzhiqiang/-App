//
//  LMHVideoPlayVC.m
//  BaseProject
//
//  Created by wfg on 2019/9/7.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHVideoPlayVC.h"
#import "SJVideoPlayer.h"
#import "LMHVideoModel.h"
#import "LMHVideoBandView.h"

@interface LMHVideoPlayVC ()<SJVideoPlayerControlLayerDelegate>
@property (nonatomic, strong) SJVideoPlayer *player;

@property (nonatomic, strong) LMHVideoModel *videoModel;

@property (nonatomic, strong) LMHVideoBandView *bandView;

@end

@implementation LMHVideoPlayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _player = [SJVideoPlayer player];
    [self.view addSubview:_player.view];
        [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
    [self getShortVideoDetail];
    
//    [self.customNavBar setTitle:@""];
    [self.view insertSubview:self.customNavBar aboveSubview:self.player.view];
    self.customNavBar.barBackgroundColor = [UIColor clearColor];
    self.customNavBar.barBackgroundImage = nil;
    self.customNavBar.backgroundColor =  [UIColor clearColor];
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"nav_btn_back_white"]];
}

-(void)addbandView{
    
    _bandView = [[NSBundle mainBundle] loadNibNamed:@"LMHVideoBandView" owner:self options:nil].firstObject;
    _bandView.top = iphoneXTop + 65;
    _bandView.width = SCREEN_WIDTH;
    _bandView.backgroundColor = [UIColor clearColor];
    _bandView.model = _videoModel;
    [self.view addSubview:_bandView];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_player stop];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadPlayView];

}
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [_player replay];
//}

-(void)loadPlayView{
    
   _player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:_videoModel.playUrl]];
    if (_videoType==1) {
        _player.hideBottomProgressSlider = YES;
        [_player.defaultEdgeControlLayer setValue:nil forKey:@"bottomAdapter"];
        _player.view.userInteractionEnabled = NO;
        [self addbandView];

    }else{
        _player.hideBottomProgressSlider = NO;

    }
    WS(weakself);
    _player.playDidToEndExeBlock = ^(__kindof SJBaseVideoPlayer * _Nonnull player) {
        [weakself.player replay];

    };
}


-(void)getShortVideoDetail{
    
    [MBProgressHUD showActivityIndicator];
    
    NSString *path = @"";
    if (_videoType) {
        path = [API_LogisticsInfo_HOST stringByAppendingString:app_Broadcast_Detail];
    }else {
        path = [API_LogisticsInfo_HOST stringByAppendingString:app_ShortVideo_detail];
    }
    
    NSDictionary* diction = @{@"id":_videoID};
    WS(weakself);
    [HttpEngine requestPostWithURL:path params:diction isToken:nil errorDomain:nil errorString:nil success:^(id responseObject) {
        [MBProgressHUD hideActivityIndicator];
        if (responseObject[@"data"]) {
            weakself.videoModel = [LMHVideoModel mj_objectWithKeyValues:responseObject[@"data"]];
            [weakself loadPlayView];
        }
  
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideActivityIndicator];
        NSDictionary *userInfo = error.userInfo;
        NSLog(@"==JSONDic=userInfo==%@",userInfo);
        [MBProgressHUD showError:userInfo[@"msg"]];
        
    }];
    
}

@end
