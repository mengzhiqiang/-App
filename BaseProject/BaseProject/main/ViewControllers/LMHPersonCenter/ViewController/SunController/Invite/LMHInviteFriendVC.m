//
//  LMHInviteFriendVC.m
//  BaseProject
//
//  Created by wfg on 2019/9/4.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHInviteFriendVC.h"
#import "LMHInviteFriendCell.h"
#import "LMHInviteRecordVC.h"
#import "LMHinviteModel.h"
#import "CustomActionSheetView.h"
#import <ShareSDK/ShareSDK.h>


@interface LMHInviteFriendVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tv;

@property (strong, nonatomic)  CustomActionSheetView *shareView;

@property (strong, nonatomic) NSArray <LMHinviteModel*>* array;

@end

@implementation LMHInviteFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.customNavBar.title = @"邀请好友";
    [self.customNavBar wr_setRightButtonWithTitle:@"邀请记录" titleColor:Main_Color];
    WS(weakself);
    self.customNavBar.onClickRightButton = ^{
        LMHInviteRecordVC *vc = [[LMHInviteRecordVC alloc] initWithNibName:@"LMHInviteRecordVC" bundle:[NSBundle mainBundle]];
        vc.array = weakself.array;
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140)];
    UILabel *lbl = [UILabel new];
    lbl.text = @"邀请说明：\n1、零码汇仅限注册码邀请加入会员。\n2、点击“分享邀请”按钮，即可复制注册码，直接黏贴分享给好友，成功注册即成功绑定上下级关系。\n3、每个注册码仅可成功邀请一位下级，不可重复使用，成功注册即失效。\n4、每个会员等级仅有固定数量的注册码，请谨慎使用。\n5、会员每次升级可获得新增注册码，降级注册码不会失效，重新升级到原有等级注册码不再新增。\n6、请勿违规推广注册码，官方有权禁用您的违规注册码。";
    lbl.numberOfLines = 0;
    lbl.textColor = Sub_title_Color;
    lbl.font = [UIFont systemFontOfSize:15];
    lbl.preferredMaxLayoutWidth = SCREEN_WIDTH-32;
    [view addSubview:lbl];
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(12, 16, 12, 16));
    }];
    CGSize size = [view systemLayoutSizeFittingSize:CGSizeMake(SCREEN_WIDTH, 1000)];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, size.height);
    self.tv.tableFooterView = view;
    self.tv.rowHeight = 58;
    [self.tv registerNib:[UINib nibWithNibName:@"LMHInviteFriendCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 476*RATIO_IPHONE6)];
    imageV.image = [UIImage imageNamed:@"grzx_tdzx_yqhy"];
    self.tv.tableHeaderView = imageV;

    [self getRegisterCodes];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (_array.count?_array.count:1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LMHInviteFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (_array.count<1) {
        cell.codeLbl.text = @"暂时没有邀请码";
        cell.inviteBtn.hidden = YES;
    }else{
        
        LMHinviteModel * model = _array[indexPath.row];
        cell.codeLbl.text = [NSString stringWithFormat:@"注册码:%@",model.code];

        if ([model.state intValue] == 0) {
            [cell.inviteBtn setTitle:@"分享邀请" forState:UIControlStateNormal];
            cell.inviteBtn.backgroundColor = Main_Color;
            cell.inviteBtn.enabled = YES;

        } else {
            [cell.inviteBtn setTitle:@"已失效" forState:UIControlStateNormal];
            cell.inviteBtn.backgroundColor = Sub_title_Color;
            cell.inviteBtn.enabled = NO;
        }
        cell.inviteBtn.hidden = NO;
        cell.selectBlock = ^{
            [self addshareView:model];
            
        };
    }
    
    return cell;
}


-(void)getRegisterCodes{
    
    NSString * url = [API_HOST stringByAppendingString:client_order_getRegisterCodes];
    
    WS(weakself);
    [HttpEngine requestPostWithURL:url params:nil isToken:YES errorDomain:nil errorString:nil success:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"data"]count]<1) {
            return ;
        }
        weakself.array = [LMHinviteModel mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"data"]];
        [weakself.tv reloadData];
    } failure:^(NSError *error) {
        
        
    }];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    LMHinviteModel * model = _array[indexPath.row];
//    [self addshareView:model];
   
}

-(void)addshareView:(LMHinviteModel*)model{
    if (!_shareView) {
        _shareView =    [[CustomActionSheetView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    _shareView.hidden = NO;
    WS(weakself);
    _shareView.backClick = ^(NSInteger buttonIndex) {
        weakself.shareView.hidden = YES;
        if (buttonIndex!=100) {
            [weakself shareAppWithIndex:buttonIndex andModel:model];
        }
    };
    [[UIViewController getCurrentController].view addSubview:_shareView];

}

-(void)shareAppWithIndex:(NSInteger)index andModel:(LMHinviteModel*)model{
    
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
    [dic SSDKSetupShareParamsByText:@"一起来赚钱吧~~~"
                             images:[UIImage imageNamed:@"icon-1024"]
                                url:[NSURL URLWithString:[NSString stringWithFormat:@"%@/views/user/regiest.html?inviteCode=%@",API_Iamage_HOST,model.code]]
                              title:@"邀请好友"
                               type:SSDKContentTypeAuto];
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


@end
