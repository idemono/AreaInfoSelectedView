//
//  PHAreaInfoSelectedView.m
//  AreaInfoSelected
//
//  Created by 泓杉mini on 2018/11/28.
//  Copyright © 2018 PH. All rights reserved.
//

#import "PHAreaInfoSelectedView.h"
#import "PHAreaTableViewCell.h"
#import "PHAreaInfoModel.h"
#import <Masonry.h>

@interface PHAreaInfoSelectedView ()
<
UIScrollViewDelegate,
UITableViewDelegate,
UITableViewDataSource
>

@property (strong, nonatomic) UIView *whiteBgView;//白色背景视图
@property (strong, nonatomic) UIView *grayBgView;//灰色背景视图
@property (strong, nonatomic) UIButton *closeButton;//关闭
@property (strong, nonatomic) UILabel *selectedAreaDescLabel;//已经选择的区域,描述

@property (strong, nonatomic) UILabel *provinceTitle;//省
@property (strong, nonatomic) UILabel *cityTitle;//市
@property (strong, nonatomic) UILabel *districtTitle;//区
@property (strong, nonatomic) UILabel *streetTitle;//街道

@property (strong, nonatomic) UIButton *provinceTitleButton;
@property (strong, nonatomic) UIButton *cityTitleButton;
@property (strong, nonatomic) UIButton *districtTitleButton;
@property (strong, nonatomic) UIButton *streetTitleButton;

@property (strong, nonatomic) UIView *grayLineView;//灰色线
@property (strong, nonatomic) UIView *selectedLineView;//选中短线
@property (strong, nonatomic) UITableView *provinceTableView;//省 表视图
@property (strong, nonatomic) UITableView *cityTableView;//市 表视图
@property (strong, nonatomic) UITableView *districtTableView;//区 表视图
@property (strong, nonatomic) UITableView *streetTableView;//街道 表视图
@property (strong, nonatomic) UIScrollView *areaScrollView;//滚动视图

@property (strong, nonatomic) NSArray *provinceArray;//省 数据源
@property (strong, nonatomic) NSArray *cityArray;//市 数据源
@property (strong, nonatomic) NSArray *districtArray;//区 数据源
@property (strong, nonatomic) NSArray *streetArray;//街道 数据源

@property (strong, nonatomic) NSMutableArray *selectedAreaInfo;//选择的区域数据

@end


@implementation PHAreaInfoSelectedView


#pragma mark - cycle

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    self.provinceArray = self.dataArray;
    [self.provinceTableView reloadData];
}

#pragma mark - Action

//刷新 selected Line View 位置
- (void)refreshSelectedLinePositionWithScrollView:(UIScrollView *)scrollView{
    CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
    NSInteger pageNum = (NSInteger)(scrollView.contentOffset.x / pageWidth);
    if (pageNum == 0) {
        [self.selectedLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.grayLineView);
            make.height.mas_equalTo(3);
            //会动态变化的
            make.width.mas_equalTo(self.provinceTitle);
            make.centerX.mas_equalTo(self.provinceTitle);
        }];
    }else if (pageNum == 1){
        [self.selectedLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.grayLineView);
            make.height.mas_equalTo(3);
            //会动态变化的
            make.width.mas_equalTo(self.cityTitle);
            make.centerX.mas_equalTo(self.cityTitle);
        }];
    }else if (pageNum == 2){
        [self.selectedLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.grayLineView);
            make.height.mas_equalTo(3);
            //会动态变化的
            make.width.mas_equalTo(self.districtTitle);
            make.centerX.mas_equalTo(self.districtTitle);
        }];
    }else if (pageNum == 3){
        [self.selectedLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.grayLineView);
            make.height.mas_equalTo(3);
            //会动态变化的
            make.width.mas_equalTo(self.streetTitle);
            make.centerX.mas_equalTo(self.streetTitle);
        }];
    }
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
    
}

//点击 省 , 市 , 区 ,街道 滑动
- (void)titleTapAction:(UIButton *)sender{
    if (sender.tag == 20001 && self.provinceArray.count > 0) {
        [self.areaScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if (sender.tag == 20002 && self.cityArray.count > 0){
        [self.areaScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.areaScrollView.frame), 0) animated:YES];
    }else if (sender.tag == 20003 && self.districtArray.count > 0){
        [self.areaScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.areaScrollView.frame) * 2, 0) animated:YES];
    }else if (sender.tag == 20004 && self.streetArray.count > 0){
        [self.areaScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.areaScrollView.frame) * 3, 0) animated:YES];
    }
}

//更新各Table的宽度
- (void)updateTableViewWith{
    
    [self.cityTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.cityArray.count == 0) {
            make.width.mas_equalTo(0);
        }else{
            make.width.mas_equalTo(self.areaScrollView);
        }
        make.height.mas_equalTo(self.areaScrollView);
        make.top.bottom.mas_equalTo(self.areaScrollView);
        make.left.mas_equalTo(self.provinceTableView.mas_right);
    }];
    
    [self.districtTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.districtArray.count == 0) {
            make.width.mas_equalTo(0);
        }else{
            make.width.mas_equalTo(self.areaScrollView);
        }
        make.height.mas_equalTo(self.areaScrollView);
        make.top.bottom.mas_equalTo(self.areaScrollView);
        make.left.mas_equalTo(self.cityTableView.mas_right);
        
    }];
    
    [self.streetTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.streetArray.count == 0) {
            make.width.mas_equalTo(0);
        }else{
            make.width.mas_equalTo(self.areaScrollView);
        }
        make.height.mas_equalTo(self.areaScrollView);
        make.top.bottom.mas_equalTo(self.areaScrollView);
        make.left.mas_equalTo(self.districtTableView.mas_right);
        make.right.mas_equalTo(self.areaScrollView);
    }];
    
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
    
}

//隐藏
- (void)hiddenView{
    [self removeFromSuperview];
}

//获取描述
- (NSString *)getDescLabelString{
    NSMutableArray *nameArray = [NSMutableArray array];
    for (NSDictionary *dict in self.selectedAreaInfo) {
        NSString *name = dict[@"name"];
        [nameArray addObject:name];
    }
    return [nameArray componentsJoinedByString:@" "];
}


#pragma mark - Delegate && DataSource

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //scrollview 滑动
    if (scrollView.tag == 10000) {
        [self refreshSelectedLinePositionWithScrollView:scrollView];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 10001) {
        //省
        return self.provinceArray.count;
        
    }else if (tableView.tag == 10002){
        //市
        return self.cityArray.count;
        
    }else if (tableView.tag == 10003){
        //区
        return self.districtArray.count;
        
    }else if(tableView.tag == 10004){
        //街道
        return self.streetArray.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PHAreaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PHAreaTableViewCell class])];
    if (!cell) {
        cell = [[PHAreaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([PHAreaTableViewCell class])];
    }
    
    
    if (tableView.tag == 10001) {
        //省
        PHAreaInfoModel *dModel = [self.provinceArray objectAtIndex:indexPath.row];
        
        if (self.selectedAreaInfo.count > 0) {
            NSString *selectName = [self.selectedAreaInfo objectAtIndex:0][@"name"];
            [cell setName:dModel.provinceName isSelected:[selectName isEqualToString:dModel.provinceName]];
        }else{
            [cell setName:dModel.provinceName isSelected:NO];
        }
        
    }else if (tableView.tag == 10002){
        //市
        PHAreaInfoModelCitys *dModel = [self.cityArray objectAtIndex:indexPath.row];
        if (self.selectedAreaInfo.count > 1) {
            NSString *selectName = [self.selectedAreaInfo objectAtIndex:1][@"name"];
            [cell setName:dModel.cityName isSelected:[selectName isEqualToString:dModel.cityName]];
        }else{
            [cell setName:dModel.cityName isSelected:NO];
        }
    }else if (tableView.tag == 10003){
        //区
        PHAreaInfoModelCitysDistricts *dModel = [self.districtArray objectAtIndex:indexPath.row];
        if (self.selectedAreaInfo.count > 2) {
            NSString *selectName = [self.selectedAreaInfo objectAtIndex:2][@"name"];
            [cell setName:dModel.districtname isSelected:[selectName isEqualToString:dModel.districtname]];
        }else{
            [cell setName:dModel.districtname isSelected:NO];
        }
        
    }else if(tableView.tag == 10004){
        //街道
        if (self.selectedAreaInfo.count > 3) {
            NSString *selectName = [self.selectedAreaInfo objectAtIndex:3][@"name"];
        }else{
        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (tableView.tag == 10001) {
        //省
        PHAreaInfoModel *dModel = [self.provinceArray objectAtIndex:indexPath.row];
        self.cityArray = dModel.citys;
        self.districtArray = [NSArray array];
        self.streetArray = [NSArray array];
        
        self.selectedAreaDescLabel.text = dModel.provinceName;
        
        self.selectedAreaInfo = [NSMutableArray array];
        [self.selectedAreaInfo setObject:@{
                                           @"name":dModel.provinceName,
                                           @"code":dModel.provinceSysno
                                           } atIndexedSubscript:0];
    }else if (tableView.tag == 10002){
        //市
        PHAreaInfoModelCitys *dModel = [self.cityArray objectAtIndex:indexPath.row];
        self.districtArray = dModel.districts;
        self.streetArray = [NSArray array];
        
        NSMutableArray *tselectedAreaInfo = [NSMutableArray array];
        [tselectedAreaInfo setObject:[self.selectedAreaInfo objectAtIndex:0]
                  atIndexedSubscript:0];
        [tselectedAreaInfo setObject:@{
                                       @"name":dModel.cityName,
                                       @"code":dModel.citySyso
                                       } atIndexedSubscript:1];
        self.selectedAreaInfo = tselectedAreaInfo;
        
    }else if (tableView.tag == 10003){
        //区
        PHAreaInfoModelCitysDistricts *dModel = [self.districtArray objectAtIndex:indexPath.row];
        
        NSMutableArray *tselectedAreaInfo = [NSMutableArray array];
        [tselectedAreaInfo setObject:[self.selectedAreaInfo objectAtIndex:0]
                  atIndexedSubscript:0];
        [tselectedAreaInfo setObject:[self.selectedAreaInfo objectAtIndex:1]
                  atIndexedSubscript:1];
        [tselectedAreaInfo setObject:@{
                                       @"name":dModel.districtname,
                                       @"code":dModel.sysno
                                       } atIndexedSubscript:2];
        self.selectedAreaInfo = tselectedAreaInfo;
        
    }else if(tableView.tag == 10004){
        //街道
        
    }
    
    //刷新描述
    self.selectedAreaDescLabel.text = [self getDescLabelString];
    
    [self.provinceTableView reloadData];
    [self.cityTableView reloadData];
    [self.districtTableView reloadData];
    [self.streetTableView reloadData];
    
    [self updateTableViewWith];
    
    if (tableView.tag == 10001 && self.cityArray.count > 0) {
        //省
        [self.areaScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.areaScrollView.frame), 0)];
    }else if (tableView.tag == 10002 && self.districtArray.count > 0){
        //市
        [self.areaScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.areaScrollView.frame)  * 2, 0)];
    }else if (tableView.tag == 10003 && self.streetArray.count > 0){
        //区
        [self.areaScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.areaScrollView.frame) * 3, 0)];
    }else if(tableView.tag == 10004){
        //街道
        
    }
    
    
}

#pragma mark - UI
- (void)setupUI{
    
    [self addSubview:self.grayBgView];
    [self addSubview:self.whiteBgView];
    [self.whiteBgView addSubview:self.closeButton];
    [self.whiteBgView addSubview:self.provinceTitle];
    [self.whiteBgView addSubview:self.cityTitle];
    [self.whiteBgView addSubview:self.districtTitle];
    [self.whiteBgView addSubview:self.streetTitle];
    
    [self.whiteBgView addSubview:self.provinceTitleButton];
    [self.whiteBgView addSubview:self.cityTitleButton];
    [self.whiteBgView addSubview:self.districtTitleButton];
    [self.whiteBgView addSubview:self.streetTitleButton];
    
    [self.whiteBgView addSubview:self.grayLineView];
    [self.whiteBgView addSubview:self.selectedLineView];
    [self.whiteBgView addSubview:self.areaScrollView];
    
    [self.whiteBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(self.whiteBgView.mas_width).multipliedBy(1.25);//h:w = 5:4
    }];
    [self.grayBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self.whiteBgView.mas_top);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.whiteBgView);
        make.right.mas_equalTo(self.whiteBgView);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    
    [self.areaScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.whiteBgView);
        make.height.mas_equalTo(self.areaScrollView.mas_width).multipliedBy(1);
    }];
    
    [self.grayLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.whiteBgView);
        make.bottom.mas_equalTo(self.areaScrollView.mas_top);
        make.height.mas_equalTo(2);
    }];
    
    [self.selectedLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.grayLineView);
        make.height.mas_equalTo(3);
        //会动态变化的
        make.width.mas_equalTo(self.provinceTitle);
        make.centerX.mas_equalTo(self.provinceTitle);
    }];
    
    [self.provinceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.whiteBgView).offset(20);
        make.bottom.mas_equalTo(self.grayLineView.mas_top).offset(-5);
    }];
    
    [self.cityTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.provinceTitle.mas_right).offset(50);
        make.bottom.mas_equalTo(self.provinceTitle);
    }];
    
    [self.districtTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.cityTitle.mas_right).offset(50);
        make.bottom.mas_equalTo(self.provinceTitle);
    }];
    
    [self.streetTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.districtTitle.mas_right).offset(50);
        make.bottom.mas_equalTo(self.provinceTitle);
    }];
    
    [self.provinceTitleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.provinceTitle);
        make.left.mas_equalTo(self.provinceTitle).offset(-10);
        make.right.mas_equalTo(self.provinceTitle).offset(10);
        make.top.mas_equalTo(self.provinceTitle).offset(-10);
    }];
    
    [self.cityTitleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.cityTitle);
        make.left.mas_equalTo(self.cityTitle).offset(-10);
        make.right.mas_equalTo(self.cityTitle).offset(10);
        make.top.mas_equalTo(self.cityTitle).offset(-10);
    }];
    
    [self.districtTitleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.districtTitle);
        make.left.mas_equalTo(self.districtTitle).offset(-10);
        make.right.mas_equalTo(self.districtTitle).offset(10);
        make.top.mas_equalTo(self.districtTitle).offset(-10);
    }];
    
    [self.streetTitleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.streetTitle);
        make.left.mas_equalTo(self.streetTitle).offset(-10);
        make.right.mas_equalTo(self.streetTitle).offset(10);
        make.top.mas_equalTo(self.streetTitle).offset(-10);
    }];
    
    UIView *tView = [[UIView alloc] init];
    [self.whiteBgView addSubview:tView];
    [tView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.whiteBgView);
        make.top.mas_equalTo(self.closeButton.mas_bottom);
        make.bottom.mas_equalTo(self.provinceTitle.mas_top);
    }];
    [tView addSubview:self.selectedAreaDescLabel];
    [self.selectedAreaDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.selectedAreaDescLabel.superview).offset(20);
        make.right.mas_equalTo(self.selectedAreaDescLabel.superview).offset(-20);
        make.centerY.mas_equalTo(self.selectedAreaDescLabel.superview);
    }];
    
    [self.areaScrollView addSubview:self.provinceTableView];
    [self.areaScrollView addSubview:self.cityTableView];
    [self.areaScrollView addSubview:self.districtTableView];
    [self.areaScrollView addSubview:self.streetTableView];
    
    [self.provinceTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.areaScrollView);
        make.left.top.bottom.mas_equalTo(self.areaScrollView);
    }];
    
    [self.cityTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(self.areaScrollView);
        make.top.bottom.mas_equalTo(self.areaScrollView);
        make.left.mas_equalTo(self.provinceTableView.mas_right);
    }];
    
    [self.districtTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(self.areaScrollView);
        make.top.bottom.mas_equalTo(self.areaScrollView);
        make.left.mas_equalTo(self.cityTableView.mas_right);

    }];

    [self.streetTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(self.areaScrollView);
        make.top.bottom.mas_equalTo(self.areaScrollView);
        make.left.mas_equalTo(self.districtTableView.mas_right);
        make.right.mas_equalTo(self.areaScrollView);
    }];
    
    
}

#pragma mark - Lazy Load


- (UIScrollView *)areaScrollView{
    if (!_areaScrollView) {
        _areaScrollView = [[UIScrollView alloc] init];
        _areaScrollView.showsVerticalScrollIndicator = NO;
        _areaScrollView.showsHorizontalScrollIndicator = NO;
        _areaScrollView.pagingEnabled = YES;
        _areaScrollView.delegate = self;
        _areaScrollView.tag = 10000;
        _areaScrollView.bounces = NO;
    }
    return _areaScrollView;
}

- (UITableView *)provinceTableView{
    if (!_provinceTableView) {
        _provinceTableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                          style:UITableViewStylePlain];
        _provinceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _provinceTableView.delegate = self;
        _provinceTableView.dataSource = self;
        _provinceTableView.tag = 10001;
    }
    return _provinceTableView;
}

- (UITableView *)cityTableView{
    if (!_cityTableView) {
        _cityTableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                          style:UITableViewStylePlain];
        _cityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _cityTableView.delegate = self;
        _cityTableView.dataSource = self;
        _cityTableView.tag = 10002;
    }
    return _cityTableView;
}

- (UITableView *)districtTableView{
    if (!_districtTableView) {
        _districtTableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                          style:UITableViewStylePlain];
        _districtTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _districtTableView.delegate = self;
        _districtTableView.dataSource = self;
        _districtTableView.tag = 10003;
    }
    return _districtTableView;
}

- (UITableView *)streetTableView{
    if (!_streetTableView) {
        _streetTableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                          style:UITableViewStylePlain];
        _streetTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _streetTableView.delegate = self;
        _streetTableView.dataSource = self;
        _streetTableView.tag = 10004;
    }
    return _streetTableView;
}


- (UIView *)whiteBgView{
    if (!_whiteBgView){
        _whiteBgView = [[UIView alloc] init];
        _whiteBgView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteBgView;
}

- (UIView *)grayBgView{
    if (!_grayBgView) {
        _grayBgView = [[UIView alloc] init];
        _grayBgView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView)];
        [_grayBgView addGestureRecognizer:tapGesture];
    }
    return _grayBgView;
}

- (UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIButton *)provinceTitleButton{
    if (!_provinceTitleButton) {
        _provinceTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _provinceTitleButton.tag = 20001;
        [_provinceTitleButton addTarget:self action:@selector(titleTapAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _provinceTitleButton;
}

- (UIButton *)cityTitleButton{
    if (!_cityTitleButton) {
        _cityTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cityTitleButton.tag = 20002;
        [_cityTitleButton addTarget:self action:@selector(titleTapAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cityTitleButton;
}

- (UIButton *)districtTitleButton{
    if (!_districtTitleButton) {
        _districtTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _districtTitleButton.tag = 20003;
        [_districtTitleButton addTarget:self action:@selector(titleTapAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _districtTitleButton;
}

- (UIButton *)streetTitleButton{
    if (!_streetTitleButton) {
        _streetTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _streetTitleButton.tag = 20004;
        [_streetTitleButton addTarget:self action:@selector(titleTapAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _streetTitleButton;
}

- (UILabel *)selectedAreaDescLabel{
    if (!_selectedAreaDescLabel) {
        _selectedAreaDescLabel = [[UILabel alloc] init];
        _selectedAreaDescLabel.textColor = [UIColor blackColor];
        _selectedAreaDescLabel.font = [UIFont systemFontOfSize:12.0f];
        _selectedAreaDescLabel.numberOfLines = 1;
        _selectedAreaDescLabel.text = @"";
    }
    return _selectedAreaDescLabel;
}

- (UILabel *)provinceTitle{
    if (!_provinceTitle) {
        _provinceTitle = [[UILabel alloc] init];
        _provinceTitle.textColor = [UIColor blackColor];
        _provinceTitle.font = [UIFont systemFontOfSize:12.0f];
        _provinceTitle.numberOfLines = 1;
        _provinceTitle.text = @"省";
    }
    return _provinceTitle;
}

- (UILabel *)cityTitle{
    if (!_cityTitle) {
        _cityTitle = [[UILabel alloc] init];
        _cityTitle.textColor = [UIColor blackColor];
        _cityTitle.font = [UIFont systemFontOfSize:12.0f];
        _cityTitle.numberOfLines = 1;
        _cityTitle.text = @"市";
    }
    return _cityTitle;
}

- (UILabel *)districtTitle{
    if (!_districtTitle) {
        _districtTitle = [[UILabel alloc] init];
        _districtTitle.textColor = [UIColor blackColor];
        _districtTitle.font = [UIFont systemFontOfSize:12.0f];
        _districtTitle.numberOfLines = 1;
        _districtTitle.text = @"区";
    }
    return _districtTitle;
}

- (UILabel *)streetTitle{
    if (!_streetTitle) {
        _streetTitle = [[UILabel alloc] init];
        _streetTitle.textColor = [UIColor blackColor];
        _streetTitle.font = [UIFont systemFontOfSize:12.0f];
        _streetTitle.numberOfLines = 1;
        _streetTitle.text = @"街道";
    }
    return _streetTitle;
}

- (UIView *)grayLineView{
    if (!_grayLineView) {
        _grayLineView = [[UIView alloc] init];
        _grayLineView.backgroundColor = [UIColor colorWithRed:228.0 / 255.0
                                                        green:228.0 / 255.0
                                                         blue:228.0 / 255.0
                                                        alpha:1.0];
    }
    return _grayLineView;
}

- (UIView *)selectedLineView{
    if (!_selectedLineView) {
        _selectedLineView = [[UIView alloc] init];
        _selectedLineView.backgroundColor = [UIColor colorWithRed:181.0 / 255.0
                                                            green:218.0 / 255.0
                                                             blue:79.0 / 255.0
                                                            alpha:1.0];
    }
    return _selectedLineView;
}


@end
