//
//  SeleceAlbumViewController.m
//  PhotoDemoSSS
//
//  Created by sks on 16/9/27.
//  Copyright © 2016年 ALiBaiChuan. All rights reserved.
//

#import "SeleceAlbumViewController.h"
#import "customHeader.h"

@interface SeleceAlbumViewController ()

@property (nonatomic, strong) NSMutableArray *firstImageArray;//第一张图
@end



@implementation SeleceAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([UserData userDataStandard].firstTitle != nil) {
        self.navigationItem.title = [UserData userDataStandard].firstTitle;
    } else {
        self.navigationItem.title = @"选择相册";
    }
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"2"] style:UIBarButtonItemStylePlain target:self action:@selector(leftButton)];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(leftButton)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    _firstImageArray = [NSMutableArray array];
    if (_dataArray.count > 0) {
        BOOL firstMark = YES;
        if ([[UserData userDataStandard].isSeleceArray count] == 0) {
            firstMark = YES;
        } else {
            firstMark = NO;
        }
        for (NSDictionary *dic in _dataArray) {
            NSMutableArray *tempArray = [NSMutableArray array];
            if (firstMark) {
                [[UserData userDataStandard].isSeleceArray addObject:tempArray];
            }
            [self getAllImageArray:dic[@"assets"]];
        }
    }
    
    [_tableView registerNib:[UINib nibWithNibName:@"SeleAlbumTableViewCell" bundle:nil] forCellReuseIdentifier:@"SeleAlbumTableViewCell"];
    _tableView.tableFooterView = [UIView new];
}
//获取所有图片
- (void)getAllImageArray:(PHFetchResult<PHAsset *> *)assets
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.networkAccessAllowed = NO;
    
    if (assets.count > 0) {
        for (int i = 0; i < assets.count; i++) {
            PHAsset *asset = assets[i];
            if (i == 0) {//只取首页图片
                [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(180, 180) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    [_firstImageArray addObject:result];
                }];
            } else {
                break;
            }
        }
    } else {
        [_firstImageArray addObject:[[UIImage alloc] init]];
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     SeleAlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SeleAlbumTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (_dataArray.count != 0) {
        cell.rightLabel.text = _dataArray[indexPath.section][@"title"];
        cell.rightLabel2.text = [NSString stringWithFormat:@"%@张照片",_dataArray[indexPath.section][@"count"]];
        if (_firstImageArray.count != 0) {
            cell.leftImageView.image = _firstImageArray[indexPath.section];
        }
        
    }
 
     return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60*ScaleSize;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([_dataArray[indexPath.section][@"count"] integerValue] > 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CustomStoryboard" bundle:[NSBundle mainBundle]];
        DetailsViewController *detailsVC = (DetailsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
        detailsVC.number = indexPath.section;
        detailsVC.assetArray = [_dataArray[indexPath.section][@"assets"] copy];
        [self.navigationController pushViewController:detailsVC animated:YES];
    } else {
        NSLog(@"该相册内没有照片");
    }
    
}

- (void)leftButton
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        //发送assets数据
         [[NSNotificationCenter defaultCenter] postNotificationName:@"PhotoAssets" object:nil userInfo:@{@"assetsArray":[UserData userDataStandard].photoAssets}];

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
