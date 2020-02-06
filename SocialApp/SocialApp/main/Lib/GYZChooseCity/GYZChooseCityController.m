//
//  GYZChooseCityController.m
//  GYZChooseCityDemo
//  选择城市列表
//  Created by wito on 15/12/29.
//  Copyright © 2015年 gouyz. All rights reserved.
//

#import "GYZChooseCityController.h"
#import "GYZCityGroupCell.h"
#import "GYZCityHeaderView.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "GCityCell.h"
#import "BSAddChildHeaderView.h"
#import <TZLocationManager.h>
@interface GYZChooseCityController ()<GYZCityGroupCellDelegate,UISearchBarDelegate,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource>

/**
 *  记录所有城市信息，用于搜索
 */
@property (nonatomic, strong) NSMutableArray *recordCityData;
/**
 *  定位城市
 */
@property (nonatomic, strong) NSMutableArray *localCityData;
/**
 *  热门城市
 */
@property (nonatomic, strong) NSMutableArray *hotCityData;
/**
 *  最近访问城市
 */
@property (nonatomic, strong) NSMutableArray *commonCityData;
@property (nonatomic, strong) NSMutableArray *arraySection;
/**
 *  是否是search状态
 */
@property(nonatomic, assign) BOOL isSearch;
/**
 *  搜索框
 */
//@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) BSAddChildHeaderView *headerView;

/**
 *  搜索城市列表
 */
@property (nonatomic, strong) NSMutableArray *searchCities;
@property(nonatomic,retain)CLLocationManager *locationManager;
@property (nonatomic, strong) UITableView *tableView;
@end

NSString *const cityHeaderView = @"CityHeaderView";
NSString *const cityGroupCell = @"CityGroupCell";
NSString *const cityCell = @"CityCell";

@implementation GYZChooseCityController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = White_Color;
    self.isSearch = NO;
    [self locationStart];
    self.customNavBar.hidden = YES;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(kNavHeight-44);
        make.height.equalTo(@30);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.headerView.mas_bottom).offset(7);
    }];
    
    WS(weakself);
    self.headerView.cancelBtnBlock = ^{
        [weakself.navigationController popViewControllerAnimated:YES];
    };
    
    self.headerView.TextFieldDidChangeBlock = ^(NSString * _Nonnull text) {
        
        [weakself.searchCities removeAllObjects];
        
        if (text.length == 0) {
            weakself.isSearch = NO;
        }else{
            weakself.isSearch = YES;
            for (GYZCity *city in weakself.recordCityData){
                NSRange chinese = [city.cityName rangeOfString:text options:NSCaseInsensitiveSearch];
//                NSRange  letters = [city.pinyin rangeOfString:text options:NSCaseInsensitiveSearch];
//                NSRange  initials = [city.initials rangeOfString:text options:NSCaseInsensitiveSearch];
                
                if (chinese.location != NSNotFound) {
                    [weakself.searchCities addObject:city];
                }
                
            }
        }
        [weakself.tableView reloadData];
    };
   
    self.locationCityID = @"";
    // 获取定位
    [[TZLocationManager manager] startLocationWithSuccessBlock:^(NSArray<CLLocation *> *locations) {
        
    } failureBlock:^(NSError *error) {
        [MBProgressHUD showError:@"定位失败，请查看是否开启定位权限"];
         self.locationCityID = @"定位失败";
        [self.tableView reloadData];
    } geocoderBlock:^(NSArray *geocoderArray) {
        [MBProgressHUD hideActivityIndicator];
        CLPlacemark *placemark = [geocoderArray objectAtIndex:0];
        NSLog(@"%@",placemark.name);
        //获取城市
        NSString *city = placemark.locality;
        if (!city) {
            //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
            city = placemark.administrativeArea;
            self.locationCityID = placemark.locality;
        }
        // 位置名
        NSLog(@"name,%@",placemark.name);
        // 街道
        NSLog(@"thoroughfare,%@",placemark.thoroughfare);
        // 子街道
        NSLog(@"subThoroughfare,%@",placemark.subThoroughfare);
        // 市
        NSLog(@"locality,%@",placemark.locality);
        // 区
        NSLog(@"subLocality,%@",placemark.subLocality);
        // 国家
        NSLog(@"country,%@",placemark.country);
        self.locationCityID = placemark.locality;
        [self.tableView reloadData];
    }];
}
-(NSMutableArray *) cityDatas{
    
    if (_cityDatas == nil) {
//        NSError *error;
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"City" ofType:@"json"];
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filePath] options:NSJSONReadingMutableLeaves error:&error];
//         NSArray *array2 = dict[@"data"];
//
//
//        NSMutableArray *mArray = [NSMutableArray array];
//        for (NSDictionary *dic in array2) {
//            GYZCity *city = [[GYZCity alloc] init];
//            city.cityID = [dic objectForKey:@"id"];
//            city.cityName = [dic objectForKey:@"name"];
//            city.pinyin = [dic objectForKey:@"code"];
//            NSString *str = [dic objectForKey:@"code"];
//            NSString *toIndexstring = [str substringToIndex:1];
//            city.initials = toIndexstring;
//            [mArray addObject:city];
//        }
//        NSMutableArray *mArray1 = [NSMutableArray array];
//
//
//        [mArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            GYZCity *city1 = (GYZCity *)obj;
//            GYZCityGroup *group = [[GYZCityGroup alloc] init];
//            [mArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                GYZCity *city2 = (GYZCity *)obj;
//                if ([city1.initials isEqualToString:city2.initials]) {
//                    [group.arrayCitys addObject:city2];
//                    group.groupName = city1.initials;
//                    [mArray removeObject:obj];
//                }
//            }];
//            [self.arraySection addObject:group.groupName];
//            [mArray1 addObject:group];
//        }];
//
//        _cityDatas = mArray1;
//        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//            //获取document 路径
//            NSLog(@"%@",path[0]);
//
//            //获取完整路径
//            NSString *documentsPath = [path objectAtIndex:0];
//            NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"MY_PropertyList.plist"];
//
//            NSMutableDictionary *usersDic = [[NSMutableDictionary alloc ] init];
//            //设置属性值
//            [usersDic setObject:@"孙悟空" forKey:@"name"];
//            [usersDic setObject:@"sunwukong" forKey:@"password"];
//
//            NSMutableDictionary *usersDic1 = [[NSMutableDictionary alloc ] init];
//            //设置属性值
//            [usersDic1 setObject:@"孙悟空" forKey:@"name"];
//            [usersDic1 setObject:@"sunwukong" forKey:@"password"];
//            NSMutableArray *arr1 = [[NSMutableArray alloc] init];
//
//            [arr1 addObject:usersDic];
//
//            [arr1 addObject:usersDic1];
//            //写入文件
////            [dict writeToFile:plistPath atomically:YES];
//
//
//        NSMutableArray *temp = [NSMutableArray array];
//        for (GYZCityGroup *group in mArray1) {
//            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//            dict[@"initial"] = group.groupName;
//            NSMutableArray *temp1 = [NSMutableArray array];
//            for (GYZCity *city in group.arrayCitys) {
//                NSMutableDictionary *cityDict = [NSMutableDictionary dictionary];
//                cityDict[@"city_key"] = city.cityID;
//                cityDict[@"pinyin"] = city.pinyin;
//                cityDict[@"city_name"] = city.cityName;
//                [temp1 addObject:cityDict];
//            }
//            dict[@"citys"] = temp1;
//            [temp addObject:dict];
//        }
//
//        [temp writeToFile:plistPath atomically:YES];
//        NSLog(@"%@",plistPath);
        NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"]];
        _cityDatas = [[NSMutableArray alloc] init];
        for (NSDictionary *groupDic in array) {
            GYZCityGroup *group = [[GYZCityGroup alloc] init];
            group.groupName = [groupDic objectForKey:@"initial"];
            for (NSDictionary *dic in [groupDic objectForKey:@"citys"]) {
                GYZCity *city = [[GYZCity alloc] init];
                city.cityID = [dic objectForKey:@"city_key"];
                city.cityName = [dic objectForKey:@"city_name"];
//                city.shortName = [dic objectForKey:@"short_name"];
                city.pinyin = [dic objectForKey:@"pinyin"];
//                city.initials = [dic objectForKey:@"initials"];
                [group.arrayCitys addObject:city];
                [self.recordCityData addObject:city];
            }
            [self.arraySection addObject:group.groupName];
            [_cityDatas addObject:group];
        }

    }
    return _cityDatas;
}
- (NSMutableArray *) recordCityData
{
    if (_recordCityData == nil) {
        _recordCityData = [[NSMutableArray alloc] init];
    }
    return _recordCityData;
}

- (NSMutableArray *) localCityData
{
    if (_localCityData == nil) {
        _localCityData = [[NSMutableArray alloc] init];
        if (self.locationCityID != nil) {
            GYZCity *city = nil;
            for (GYZCity *item in self.recordCityData) {
                if ([FORMAT(@"%@",item.cityID) isEqualToString:self.locationCityID]) {
                    city = item;
                    break;
                }
            }
            if (city == nil) {
                NSLog(@"Not Found City: %@", self.locationCityID);
            }
            else {
                [_localCityData addObject:city];
            }
        }
    }
    return _localCityData;
}

- (NSMutableArray *) hotCityData
{
    if (_hotCityData == nil) {
        _hotCityData = [[NSMutableArray alloc] init];
        for (NSString *str in self.hotCitys) {
            GYZCity *city = nil;
            for (GYZCity *item in self.recordCityData) {
                if ([FORMAT(@"%@",item.cityID) isEqualToString:FORMAT(@"%@",str)]) {
                    city = item;
                    break;
                }
            }
            if (city == nil) {
                NSLog(@"Not Found City: %@", str);
            }
            else {
                [_hotCityData addObject:city];
            }
        }
    }
    return _hotCityData;
}

- (NSMutableArray *) commonCityData
{
    if (_commonCityData == nil) {
        _commonCityData = [[NSMutableArray alloc] init];
        for (NSString *str in self.commonCitys) {
            GYZCity *city = nil;
            for (GYZCity *item in self.recordCityData) {
                if ([item.cityName isEqualToString:str]) {
                    city = item;
                    break;
                }
            }
            if (city == nil) {
                NSLog(@"Not Found City: %@", str);
            }
            else {
                [_commonCityData addObject:city];
            }
        }
    }
    return _commonCityData;
}

- (NSMutableArray *) arraySection
{
    if (_arraySection == nil) {
        _arraySection = [[NSMutableArray alloc] initWithObjects:UITableViewIndexSearch, @"定位", @"最近", @"最热", nil];
    }
    return _arraySection;
}

- (NSMutableArray *) commonCitys
{
    if (_commonCitys == nil) {
        NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:COMMON_CITY_DATA_KEY];
        _commonCitys = (array == nil ? [[NSMutableArray alloc] init] : [[NSMutableArray alloc] initWithArray:array copyItems:YES]);
    }
    return _commonCitys;
}

#pragma mark - Getter
- (NSMutableArray *) searchCities
{
    if (_searchCities == nil) {
        _searchCities = [[NSMutableArray alloc] init];
    }
    return _searchCities;
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //搜索出来只显示一块
    if (self.isSearch) {
        return 1;
    }
    return self.cityDatas.count + 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.isSearch) {
        return self.searchCities.count;
    }
    if (section < 3) {
        return 1;
    }
    GYZCityGroup *group = [self.cityDatas objectAtIndex:section - 3];
    return group.arrayCitys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isSearch) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cityCell];
        GYZCity *city =  [self.searchCities objectAtIndex:indexPath.row];
        [cell.textLabel setText:city.cityName];
        return cell;
    }
    
    if (indexPath.section < 3) {
        if (indexPath.section == 0) {
            GCityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"onecell"];
            cell.nameLabel.text = self.locationCityID;
//            cell.titleLabel.text = @"定位城市";
//            cell.noDataLabel.text = @"无法定位当前城市，请稍后再试";
//            [cell setCityArray:self.localCityData];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;

        }
        else if (indexPath.section == 1) {
            GYZCityGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cityGroupCell];

            cell.titleLabel.text = @"热门城市";
            [cell setCityArray:self.hotCityData];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            
            [cell setDelegate:self];
            return cell;
        } else {
            GYZCityGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cityGroupCell];
            cell.titleLabel.text = @"历史搜索";
            [cell setCityArray:self.commonCityData];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            
            [cell setDelegate:self];
            return cell;
        }
        
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cityCell];
    GYZCityGroup *group = [self.cityDatas objectAtIndex:indexPath.section - 3];
    GYZCity *city =  [group.arrayCitys objectAtIndex:indexPath.row];
    [cell.textLabel setText:city.cityName];
    
    return cell;
}

#pragma mark UITableViewDelegate
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section < 3 || self.isSearch) {
        return nil;
    }
    GYZCityHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cityHeaderView];
    NSString *title = [_arraySection objectAtIndex:section + 1];
    headerView.titleLabel.text = title;
    headerView.contentView.backgroundColor = [UIColor whiteColor];
    return headerView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSearch) {
        return 44.0f;
    }
    if (indexPath.section == 0) {
        return 61;
    }
    else if (indexPath.section == 1) {
        return [GYZCityGroupCell getCellHeightOfCityArray:self.hotCityData];
    }
    else if (indexPath.section == 2){
        return [GYZCityGroupCell getCellHeightOfCityArray:self.commonCityData];
    }
    return 44.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section < 3 || self.isSearch) {
        return 0.0f;
    }
    return 23.5f;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GYZCity *city = nil;
    if (self.isSearch) {
        city =  [self.searchCities objectAtIndex:indexPath.row];
    }else{
        if (indexPath.section < 3) {
            if (indexPath.section == 0 && self.localCityData.count <= 0) {
                [self locationStart];
            }
            return;
        }
        GYZCityGroup *group = [self.cityDatas objectAtIndex:indexPath.section - 3];
        city =  [group.arrayCitys objectAtIndex:indexPath.row];
    }
   
    [self didSelctedCity:city];
}

//- (NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
//    if (index == 0) {
//        return -1;
//    }
//    return index - 1;
//}



//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return self.arraySection[section];
//}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    NSMutableArray *sections = [self.sectionTitles mutableCopy];
//
//    //往索引数组的开始处添加一个放大镜🔍 放大镜是系统定义好的一个常量字符串表示UITableViewIndexSearch 当然除了放大镜外也可以添加其他文字
//    [sections insertObject:UITableViewIndexSearch  atIndex:0];
    NSMutableArray *array = self.arraySection.mutableCopy;
    [array removeObjectsInRange:NSMakeRange(0, 4)];
    return array;
}
// 响应点击索引时的委托方法
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSLog(@"index=%zd",index);
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:NSNotFound inSection:5] atScrollPosition:UITableViewScrollPositionTop animated:YES];

    return index+3;
}

#pragma mark searchBarDelegete

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    UIButton *btn=[searchBar valueForKey:@"_cancelButton"];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.searchCities removeAllObjects];
    
    if (searchText.length == 0) {
        self.isSearch = NO;
    }else{
        self.isSearch = YES;
        for (GYZCity *city in self.recordCityData){
            NSRange chinese = [city.cityName rangeOfString:searchText options:NSCaseInsensitiveSearch];
            NSRange  letters = [city.pinyin rangeOfString:searchText options:NSCaseInsensitiveSearch];
            NSRange  initials = [city.initials rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if (chinese.location != NSNotFound || letters.location != NSNotFound || initials.location != NSNotFound) {
                [self.searchCities addObject:city];
            }
//            if ([city.cityName containsString:searchText] || [city.pinyin containsString:searchText] || [city.initials containsString:searchText]) {
//                [self.searchCities addObject:city];
//            }
        }
    }
    [self.tableView reloadData];
}
//添加搜索事件：
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
     [searchBar setShowsCancelButton:NO animated:YES];
     searchBar.text=@"";
    [searchBar resignFirstResponder];
    self.isSearch = NO;
    [self.tableView reloadData];
}
#pragma mark GYZCityGroupCellDelegate
- (void) cityGroupCellDidSelectCity:(GYZCity *)city
{
    [self didSelctedCity:city];
}

#pragma mark - Event Response
- (void) cancelButtonDown:(UIBarButtonItem *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(cityPickerControllerDidCancel:)]) {
        [_delegate cityPickerControllerDidCancel:self];
    }
}
#pragma mark - Private Methods
- (void) didSelctedCity:(GYZCity *)city
{
    if (_delegate && [_delegate respondsToSelector:@selector(cityPickerController:didSelectCity:)]) {
        [_delegate cityPickerController:self didSelectCity:city];
    }
    
    if (self.commonCitys.count >= MAX_COMMON_CITY_NUMBER) {
        [self.commonCitys removeLastObject];
    }
    for (NSString *str in self.commonCitys) {
        if ([city.cityName isEqualToString:str]) {
            [self.commonCitys removeObject:str];
            break;
        }
    }
    [self.commonCitys insertObject:city.cityName atIndex:0];
    [[NSUserDefaults standardUserDefaults] setValue:self.commonCitys forKey:COMMON_CITY_DATA_KEY];
    [[NSUserDefaults standardUserDefaults] setValue:city.cityName forKey:@"currentCity"];

    [[NSUserDefaults standardUserDefaults] synchronize];
}

//开始定位
-(void)locationStart{
    //判断定位操作是否被允许
    
    if([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init] ;
        self.locationManager.delegate = self;
        //设置定位精度
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLLocationAccuracyHundredMeters;//每隔多少米定位一次（这里的设置为每隔百米)
        if (IOS8) {
            //使用应用程序期间允许访问位置数据
            [self.locationManager requestWhenInUseAuthorization];
        }
        // 开始定位
        [self.locationManager startUpdatingLocation];
    }else {
        //提示用户无法进行定位操作
        NSLog(@"%@",@"定位服务当前可能尚未打开，请设置打开！");
        
    }
}
#pragma mark - CoreLocation Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations

{
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [self.locationManager stopUpdatingLocation];
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    
    //获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count >0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             //获取城市
             NSString *currCity = placemark.locality;
             if (!currCity) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 currCity = placemark.administrativeArea;
             }
             if (self.localCityData.count <= 0) {
                 GYZCity *city = [[GYZCity alloc] init];
                 city.cityName = currCity;
                 city.shortName = currCity;
                 [self.localCityData addObject:city];
                 
                 [self.tableView reloadData];
             }
             
         } else if (error ==nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }else if (error !=nil)
         {
             NSLog(@"An error occurred = %@", error);
         }
         
     }];
    
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    if (error.code ==kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
    
}

- (BSAddChildHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [BSAddChildHeaderView new];
        _headerView.backgroundColor = [[UIColor HexString:@"000000"] colorWithAlphaComponent:0.01];
    }
    return _headerView;
}
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate =self;
        _tableView.dataSource =self;
      
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = YES;
        [_tableView setSectionIndexBackgroundColor:[UIColor whiteColor]];
        [_tableView setSectionIndexColor:[UIColor whiteColor]];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cityCell];
        [_tableView registerClass:[GYZCityGroupCell class] forCellReuseIdentifier:cityGroupCell];
        [_tableView registerNib:[UINib nibWithNibName:@"GCityCell" bundle:nil] forCellReuseIdentifier:@"onecell"];
        _tableView.sectionIndexColor = [UIColor HexString:@"666666"];//设置默认时索引值颜色
        _tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];//设置选中时，索引背景颜色
        _tableView.sectionIndexBackgroundColor = [UIColor whiteColor];// 设置默认时，索引的背景颜色
        [_tableView registerClass:[GYZCityHeaderView class] forHeaderFooterViewReuseIdentifier:cityHeaderView];
    }
    return _tableView;
}
@end
