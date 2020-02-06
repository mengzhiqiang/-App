//
//  ZCBFeedBackViewController.m
//  ZCBus
//
//  Created by wfg on 2019/8/23.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "ZCBFeedBackViewController.h"

#import "ZWTextView.h"
#import "TZImagePickerController.h"
#import "UIAlertController+Simple.h"
#import "JFBubbleHeader.h"
#import "BSGradientButton.h"
#import "LMHChangeUserNameVC.h"


@interface ZCBFeedBackViewController ()<
UITableViewDelegate,
UITableViewDataSource,
TZImagePickerControllerDelegate
>

@property(nonatomic, strong)IBOutlet UIButton * addImageButton;
@property(nonatomic, strong)   NSArray * images;
@property (retain, nonatomic)  NSMutableArray * assetArray;            // 选择的发布图片

@property (strong, nonatomic) IBOutlet UIView *detailView;
@property (strong, nonatomic) IBOutlet UIView *contentInputView;
@property (strong, nonatomic) ZWTextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *countLbl;

@property(nonatomic, strong)UITableView * tableView;
@property (strong, nonatomic) IBOutlet UIView *selectTypeView;
@property (strong, nonatomic) NSString *contentType;
@property (nonatomic, assign) NSInteger typeCount;
@property (nonatomic, strong) BSGradientButton *lowButton;

@property (assign, nonatomic) NSInteger score;
@property (assign, nonatomic) NSString *type;
@property (nonatomic, strong) NSArray *leftTitle;

@end

@implementation ZCBFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.customNavBar.title = @"意见反馈";
    self.contentType = @"-";
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = Main_BG_Color;
    self.tableView.backgroundColor = Main_BG_Color;

    self.contentTextView = [[ZWTextView alloc] initWithFrame:CGRectMake(15,30,SCREEN_WIDTH-30,80) TextFont:[UIFont systemFontOfSize:15] MoveStyle:styleMove_Down];
    
    self.contentTextView.maxNumberOfLines = 4;
    self.contentTextView.maxLength = 200;
    self.contentTextView.placeholder = @"请填写备注内容";
    self.contentTextView.inputText = @"";
    self.contentTextView.textColor = [UIColor blackColor];
//    [self.contentTextView draCirlywithColor:Main_BG_Color andRadius:1.0f];
    
    self.contentTextView.backgroundColor = [UIColor whiteColor];
    WS(weakself);
    self.contentTextView.textViewHeightChange = ^(CGFloat height) {
//        weakself.countLbl.text = [NSString stringWithFormat:@"%ld/200", weakself.contentTextView.text.length];
    };
    [self.contentInputView insertSubview:self.contentTextView atIndex:0];
    [self.addImageButton draCirlywithColor:Main_BG_Color andRadius:1.0f];
    [self.lowButton setTitle:@"提交" forState:UIControlStateNormal];
}

-(UITableView*)tableView
{
    if (!_tableView) {
        _tableView =[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate =self ;
        _tableView.dataSource = self;
        _tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        _tableView.frame = CGRectMake(0, SCREEN_top, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_top);
        _tableView.backgroundColor = [UIColor clearColor];
    }
    
    return _tableView;
}
-(void)showImageOfView{
    
    for (UIButton *btn in _contentTextView.subviews) {
        if (btn.tag==100) {
            [btn removeFromSuperview];
            btn.hidden = YES;
        }
    }
    CGFloat with = 15;
    for (int i = 0; i<self.images.count; i++) {
        UIImage * image = self.images[i];
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:image forState:UIControlStateNormal];
        btn.frame = CGRectMake(15+(70+10)*i, _addImageButton.top, 70, 70);
        btn.tag = 100 ;
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_contentInputView addSubview:btn];
        [btn addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
        with = with+(70+10);
    }
    if (self.images.count==3) {
        _addImageButton.hidden = YES;
    }else{
        _addImageButton.hidden = NO;
        _addImageButton.left = with;
    }
}

- (IBAction)addImage:(UIButton *)sender {
    
    TZImagePickerController *imagePickerController = [[TZImagePickerController alloc]initWithMaxImagesCount:3 delegate:self];
    imagePickerController.allowPickingVideo = NO;
    imagePickerController.allowTakeVideo = NO;
    imagePickerController.showSelectedIndex = YES;
    imagePickerController.hideWhenCanNotSelect = YES;
    imagePickerController.selectedAssets = self.assetArray;
    imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:imagePickerController animated:YES completion:nil];
    
}
#pragma mark -- TZImagePickerController delegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    self.images = [NSMutableArray arrayWithArray:photos];
    self.assetArray = [NSMutableArray arrayWithArray:assets];
    
    [self showImageOfView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray * title = @[@"*反馈类型",@"*反馈内容",@"*职业",@"*联系人",@"*联系电话",@"提交评价"];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell0"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = title[0];
            cell.textLabel.textColor = Main_title_Color;
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        }
        
        if (indexPath.section==1) {
            cell.accessoryType = UITableViewCellAccessoryNone;

            _contentInputView.top = 0 ;
            _contentInputView.width = SCREEN_WIDTH ;
            self.countLbl.autoresizingMask = UIViewAutoresizingNone;
            self.countLbl.frame = CGRectMake(SCREEN_WIDTH-90-18, 93, 90, 20);
            [cell addSubview:_contentInputView];
            cell.backgroundColor = [UIColor clearColor];
        }

       return cell ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        return 215;
    }
    return 45;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view =[[UIView alloc]init];
    view.backgroundColor = Main_BG_Color;
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
        UIAlertController *sheet = [UIAlertController showSheetTitles:@[@"诈骗",@"发布色情/违法信息",@"骚扰",@"其他违规信息"] titleColor:Main_Color cancelColor:Sub_title_Color backIndex:^(UIAlertAction * _Nonnull UIAlertAction, NSInteger index) {
                if (index == 0) {
                }
            }];
         
            [self presentViewController:sheet animated:YES completion:nil];
         
        return;
    }
}

- (void)bubbleView:(JFBubbleView *)bubbleView didTapItem:(JFBubbleItem *)item {
    NSMutableArray *content = [NSMutableArray array];
    for (JFBubbleItem *item in [bubbleView indexesForSelectedItems]) {
        [content addObject:item.textLabel.text];
    }
    self.contentType = [content componentsJoinedByString:@","];
}

- (BOOL)requestAllow {
    if (!self.type.length) {
        [self presentViewController:[UIAlertController showWithMessage:@"请选择反馈类型"] animated:YES completion:nil];
        return NO;
    } else if (!self.contentTextView.text.length) {
        [self presentViewController:[UIAlertController showWithMessage:@"请输入反馈内容"] animated:YES completion:nil];
        return NO;
    } else if (self.contentTextView.text.length < 5) {
        [self presentViewController:[UIAlertController showWithMessage:@"请填写5个字以上的问题描述"] animated:YES completion:nil];
        return NO;
    }
    return YES;
}

-(BSGradientButton*)lowButton{
    if (!_lowButton) {
        _lowButton = [BSGradientButton buttonWithType:UIButtonTypeCustom];
        _lowButton.frame = CGRectMake(50, SCREEN_HEIGHT-170, SCREEN_WIDTH-100, 50);
        [_lowButton addTarget:self action:@selector(clickLowButton) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.view addSubview:_lowButton];
    return  _lowButton;
}

-(void)clickLowButton{
    
}
@end
