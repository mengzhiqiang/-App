//
//  LMHInviteRecordVC.m
//  BaseProject
//
//  Created by wfg on 2019/9/4.
//  Copyright © 2019 zhiqiang meng. All rights reserved.
//

#import "LMHInviteRecordVC.h"
#import "LMHInviteRecordCell.h"
@interface LMHInviteRecordVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tv;
@property (strong, nonatomic) NSMutableArray <LMHinviteModel*>* inviteArray;

@end

@implementation LMHInviteRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.customNavBar.title = @"邀请记录";
    [self loadNewData];
    self.tv.tableFooterView = [UIView new];
    self.tv.rowHeight = 44;
    [self.tv registerNib:[UINib nibWithNibName:@"LMHInviteRecordCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
}

-(void)loadNewData{
    
    _inviteArray =  [NSMutableArray arrayWithCapacity:200];
    for (LMHinviteModel* model in _array) {
        if ([model.state intValue]!=0) {
            [_inviteArray addObject:model];
        }
    }
    [self.tv reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _inviteArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LMHInviteRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.row==0) {
        cell.codeLbl.text = @"注册码";
        cell.phoneLbl.text = @"邀请用户";
        cell.dateLbl.text = @"邀请时间";
    }else if (_array.count+1>indexPath.row) {
        LMHinviteModel * model = self.inviteArray[indexPath.row-1];
        cell.codeLbl.text = model.code;
        cell.phoneLbl.text =[model.usedPhone changePhone];
        cell.dateLbl.text = [model.usedTime substringWithRange:NSMakeRange(0, 10)];
    }
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
