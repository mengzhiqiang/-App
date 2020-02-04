//
//  LMHFindViewController.m
//  BaseProject
//
//  Created by zhiqiang meng on 28/6/2019.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHFindViewController.h"
#import "LMHLiveBroadcastTV.h"
#import "LMHVideoCollectionView.h"
#import "LMHLiveTVCollectionView.h"
@interface LMHFindViewController ()<UISearchBarDelegate>
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *typeBtns;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIScrollView *sv;

@property (nonatomic, strong) LMHLiveTVCollectionView *tv;

@property (nonatomic, strong) LMHVideoCollectionView *tv1;

@end

@implementation LMHFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.customNavBar removeFromSuperview];
    UITextField *searchTextField = [[[self.searchBar.subviews firstObject] subviews] lastObject];
    searchTextField.layer.cornerRadius = 18;
    searchTextField.layer.masksToBounds = YES;
    self.searchBar.delegate = self;
    self.searchBar.backgroundImage = [[UIImage alloc]init];
    [self.searchBar sizeToFit];
    for (UIView *view in [[self.searchBar.subviews firstObject] subviews]) {
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            view.layer.backgroundColor = Main_Color.CGColor;
            view.backgroundColor = Main_Color;
//            view.layer.contents = nil;
//            [view removeFromSuperview];
        }
    }

    [self liveView];
    [self videoView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
     //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
     tapGestureRecognizer.cancelsTouchesInView = NO;
     //将触摸事件添加到当前view
     [self.view addGestureRecognizer:tapGestureRecognizer];
}
-(void)hideKeyBoard{
    [self.searchBar resignFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
     
    [super viewDidAppear:animated];

}

- (void)liveView {
    LMHLiveTVCollectionView *tv = [[LMHLiveTVCollectionView alloc] init];
    
    [self.sv addSubview:tv.view];
    [tv.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.sv);
        make.width.height.equalTo(self.sv);
    }];
    self.tv = tv;
}

- (void)videoView {
    _tv1 = [[LMHVideoCollectionView alloc] init];
    [self.sv addSubview:_tv1];
    [_tv1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self.sv);
        make.width.height.equalTo(self.sv);
        make.left.equalTo(self.tv.view.mas_right);
    }];
}
- (IBAction)channelAction:(UIButton *)sender {
    for (UIButton *btn in self.typeBtns) {
        if ([btn isEqual:sender]) {
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } else {
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitleColor:[UIColor colorWithHexValue:0xEEEEEE] forState:UIControlStateNormal];
        }
    }
    [self.sv setContentOffset:CGPointMake(SCREEN_WIDTH*sender.tag, 0) animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
    if (searchBar.text) {
        self.tv.wordKey = searchBar.text ;
        self.tv1.wordKey = searchBar.text ;
    }else{
        
    }

}
@end
