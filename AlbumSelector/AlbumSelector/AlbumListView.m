//
//  AlbumListView.m
//  AlbumSelector
//
//  Created by hadlinks on 2020/6/9.
//  Copyright © 2020 hadlinks. All rights reserved.
//

#import "AlbumListView.h"
@interface AlbumListView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) UITableView *albumTableView;
typedef void(^completion)(BOOL isOpera, NSMutableArray *albums, NSMutableArray *results);
@property (nonatomic,strong) NSMutableArray<PHAssetCollection *> *albums;
@property (nonatomic,strong) NSMutableArray<PHFetchResult *> *results;
@end

static NSString * const reuseIdentifier = @"AlbumNameCell";

@implementation AlbumListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3];
        typeof(self) __weak weakSelf = self;
        [self requestCollectionWithHandler:^(BOOL isOpera, NSMutableArray *albums, NSMutableArray *results) {
            weakSelf.albums = albums;
            weakSelf.results = results;
            [weakSelf.albumTableView reloadData];
        }];
    }
    return self;
}

- (UITableView *)albumTableView {
    if (!_albumTableView) {
        _albumTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 0) style:UITableViewStyleGrouped];
        _albumTableView.dataSource = self;
        _albumTableView.delegate = self;
        _albumTableView.sectionHeaderHeight = 0.001;
        _albumTableView.sectionFooterHeight = 0.001;
        [self addSubview:_albumTableView];
    }
    return _albumTableView;
}

- (NSMutableArray<PHAssetCollection *> *)albums {
    if (!_albums) {
        _albums = [NSMutableArray array];
    }
    return _albums;
}

- (NSMutableArray<PHFetchResult *> *)results {
    if (!_results) {
        _results = [NSMutableArray array];
    }
    return _results;
}

- (void)showAlbumList {
    [UIView animateWithDuration:.3 animations:^{
        self.albumTableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 100);
    }];
}

- (void)hidenAlbumList {
    [UIView animateWithDuration:.3 animations:^{
        self.albumTableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)requestCollectionWithHandler:(completion)handler {
    __block completion operation = handler;
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    if ([self checkAlbumAuthorization]) {
        __block NSMutableArray *album = [NSMutableArray new];
        __block NSMutableArray *result = [NSMutableArray new];
        PHFetchResult *myPhotoResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumMyPhotoStream options:nil];
        PHFetchResult *smartResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        PHFetchResult *topLevelUserResult = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
        PHFetchResult *syncedResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
        PHFetchResult *sharedResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumCloudShared options:nil];
        [myPhotoResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[PHAssetCollection class]]) {
                PHAssetCollection *collection = obj;
                if (collection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumVideos
                    && collection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumAllHidden
                    && collection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumRecentlyAdded) {
                    PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:obj options:option];
                    if (assetResult.count > 0) {
                        [album addObject:obj];
                        [result addObject:assetResult];
                    }
                }
            }
        }];
        [smartResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[PHAssetCollection class]]) {
                PHAssetCollection *collection = obj;
                if (collection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumVideos
                    && collection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumAllHidden
                    && collection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumRecentlyAdded) {
                    PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:obj options:option];
                    if (assetResult.count > 0) {
                        [album addObject:obj];
                        [result addObject:assetResult];
                    }
                }
            }
        }];
        [topLevelUserResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[PHAssetCollection class]]) {
                PHAssetCollection *collection = obj;
                if (collection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumVideos
                    && collection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumAllHidden
                    && collection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumRecentlyAdded) {
                    PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:obj options:option];
                    if (assetResult.count > 0) {
                        [album addObject:obj];
                        [result addObject:assetResult];
                    }
                }
            }
        }];
        [syncedResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             if ([obj isKindOfClass:[PHAssetCollection class]]) {
                   PHAssetCollection *collection = obj;
                   if (collection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumVideos
                       && collection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumAllHidden
                       && collection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumRecentlyAdded) {
                       PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:obj options:option];
                       if (assetResult.count > 0) {
                           [album addObject:obj];
                           [result addObject:assetResult];
                       }
                   }
               }
        }];
        [sharedResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             if ([obj isKindOfClass:[PHAssetCollection class]]) {
                   PHAssetCollection *collection = obj;
                   if (collection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumVideos
                       && collection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumAllHidden
                       && collection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumRecentlyAdded) {
                       PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:obj options:option];
                       if (assetResult.count > 0) {
                           [album addObject:obj];
                           [result addObject:assetResult];
                       }
                   }
               }
        }];
        if (operation) {
            dispatch_async(dispatch_get_main_queue(), ^{
                operation(YES, album,result);
            });
        }
        
    } else {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [self requestCollectionWithHandler:operation];
            }
        }];
    }
}

- (BOOL)checkAlbumAuthorization {
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    //读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusNotDetermined){
        return NO;
    }
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    }
    cell.textLabel.text = self.albums[indexPath.row].localizedTitle;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"（%ld）",self.results[indexPath.row].count];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate) {
        [_delegate didSelectedAblum:self.albums[indexPath.row] andAssetResult:self.results[indexPath.row]];
        [self hidenAlbumList];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
@end
