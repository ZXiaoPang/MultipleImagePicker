//
//  AssetCollectionViewController.m
//  AlbumSelector
//
//  Created by hadlinks on 2020/5/26.
//  Copyright © 2020 hadlinks. All rights reserved.
//

#import "AssetCollectionViewController.h"
#import "AssetCollectionViewCell.h"
#import <PhotosUI/PhotosUI.h>
#import "AssetPickerManager.h"
#import "ImagePreview.h"
#import "AblumTitleButton.h"
#import "AlbumListView.h"
#define KScreen_WIDTH   [[UIScreen mainScreen] bounds].size.width
#define KScreen_HEIGHT  [[UIScreen mainScreen] bounds].size.height

typedef void(^ResultHandler)(UIImage *image, NSDictionary *info);
@interface AssetCollectionViewController () <AlbumListDelegate>
{
    CGSize thumbnailSize;
}
@property (nonatomic, strong) PHCachingImageManager *imageManager;
@property (nonatomic, strong) PHImageRequestOptions *requestOption;
@property (nonatomic,strong) NSMutableArray *imageDataSource;
@property (nonatomic,strong) NSMutableArray *selectedImageArray;
@property (nonatomic,strong) AblumTitleButton *albumTitleBtn;
@property (nonatomic,assign) BOOL isShowAlbumList;
@property (nonatomic,strong) AlbumListView *albumListView;
@end

@implementation AssetCollectionViewController

static NSString * const reuseIdentifier = @"AssetCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initRightCompleteBarItem];
    [self setAlbumTitle];
    [self collectionViewConfig];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CGFloat scale = UIScreen.mainScreen.scale;
    CGFloat item_WH = (KScreen_WIDTH-2.f*3)/4.f;
    thumbnailSize = CGSizeMake(item_WH * scale, item_WH * scale);
}

- (void)initRightCompleteBarItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(completeSelectedImage)];
}

- (void)setAlbumTitle {
    _albumTitleBtn = [AblumTitleButton buttonWithType:UIButtonTypeCustom];
    [_albumTitleBtn setTitle:_assetCollection.localizedTitle forState:UIControlStateNormal];
    _albumTitleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [_albumTitleBtn setImage:[UIImage imageNamed:@"arrow_hide_nor"] forState:UIControlStateNormal];
    [_albumTitleBtn setImage:[UIImage imageNamed:@"arrow_hide_click"] forState:UIControlStateHighlighted];
    [_albumTitleBtn addTarget:self action:@selector(showAlbumListClick:) forControlEvents:UIControlEventTouchUpInside];
    [_albumTitleBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    self.navigationItem.titleView = _albumTitleBtn;
}

- (void)showAlbumListClick:(UIButton *)sender {
    _isShowAlbumList = !_isShowAlbumList;
    NSString *normalImageName = _isShowAlbumList ? @"arrow_show_nor" : @"arrow_hide_nor";
    NSString *highLightImageName = _isShowAlbumList ? @"arrow_show_click" : @"arrow_hide_click";
    [sender setImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
    [sender setImage:[UIImage imageNamed:highLightImageName] forState:UIControlStateHighlighted];
    if (_isShowAlbumList) {
        [self.view addSubview:self.albumListView];
        [self.albumListView showAlbumList];
    } else {
        [self.albumListView hidenAlbumList];
    }
}

- (void)initData{
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    if (!_fetchResult) {
        //最近添加相册
        PHFetchResult *recentResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        [recentResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PHAssetCollection *collection = obj;
            if ([collection isKindOfClass:[PHAssetCollection class]] && collection.estimatedAssetCount > 0) {
                if ([self isCameraRollAlbum:collection]) {
                    self->_assetCollection = collection;
                    self->_fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
                    *stop = YES;
                }
            }
        }];
    }
    __weak typeof(self) weakSelf = self;
    [_fetchResult enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.mediaType == PHAssetMediaTypeImage) {
            [weakSelf.imageDataSource addObject:obj];
        }
    }];
    _imageManager = [[PHCachingImageManager alloc] init];
    _requestOption = [[PHImageRequestOptions alloc] init];
    _requestOption.resizeMode = PHImageRequestOptionsResizeModeExact;
    [self.collectionView reloadData];
}

- (void)collectionViewConfig {
    [self.collectionView registerClass:[AssetCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)completeSelectedImage {
    if (self.selectedImageArray.count == 0) {
        [AssetPickerDefault.delegate cancleSelectedImage];
    } else {
        __block NSMutableArray *imageArray = [NSMutableArray array];
        _requestOption.synchronous = YES;
        _requestOption.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        _requestOption.resizeMode = PHImageRequestOptionsResizeModeNone;
        [self.selectedImageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PHAsset *asset = obj;
            [_imageManager requestImageForAsset:asset
                                     targetSize:thumbnailSize
                                    contentMode:PHImageContentModeAspectFill
                                        options:_requestOption
                                  resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                [imageArray addObject:result];
            }];
        }];
        [AssetPickerDefault.delegate didFinishSelectedImage:imageArray];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)isCameraRollAlbum:(PHAssetCollection *)metadata {
    NSString *versionStr = [[UIDevice currentDevice].systemVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (versionStr.length <= 1) {
        versionStr = [versionStr stringByAppendingString:@"00"];
    } else if (versionStr.length <= 2) {
        versionStr = [versionStr stringByAppendingString:@"0"];
    }
    CGFloat version = versionStr.floatValue;
    // IOS 8.0.0 ~ 8.0.2系统，拍照后的图片会保存在最近添加中
    if (version >= 800 && version <= 802) {
        return ((PHAssetCollection *)metadata).assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumRecentlyAdded;
    } else {
        return ((PHAssetCollection *)metadata).assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary;
    }
}


- (NSMutableArray *)imageDataSource {
    if (!_imageDataSource) {
        _imageDataSource = [NSMutableArray array];
    }
    return _imageDataSource;
}

- (NSMutableArray *)selectedImageArray {
    if (!_selectedImageArray) {
        _selectedImageArray = [NSMutableArray array];
    }
    return _selectedImageArray;
}

- (AlbumListView *)albumListView {
    if (!_albumListView) {
        _albumListView = [[AlbumListView alloc] initWithFrame:self.view.frame];
        _albumListView.delegate = self;
    }
    return _albumListView;
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AssetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    PHAsset *asset = [self.imageDataSource objectAtIndex:indexPath.item];
    if (@available(iOS 9.1, *)) {
        if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
            cell.livePhotoBadgeImage = [PHLivePhotoView livePhotoBadgeImageWithOptions:PHLivePhotoBadgeOptionsOverContent];
        }
    }
    cell.representedAssetIdentifier = asset.localIdentifier;
    
    __weak typeof(self) weakSelf = self;
    cell.selectImageHandler = ^(UIImage * _Nonnull image) {
        if ([weakSelf.selectedImageArray containsObject:asset]) {
            [weakSelf.selectedImageArray removeObject:asset];
            [weakSelf.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        } else {
            if (weakSelf.selectedImageArray.count < AssetPickerDefault.maxSelectCount) {
                [weakSelf.selectedImageArray addObject:asset];
                [weakSelf.collectionView reloadItemsAtIndexPaths:@[indexPath]];
            }
        }
       [weakSelf.navigationItem.rightBarButtonItem setTitle:weakSelf.selectedImageArray.count > 0 ? @"完成":@"取消"];
    };
    
    [_imageManager requestImageForAsset:asset
                             targetSize:thumbnailSize
                            contentMode:PHImageContentModeAspectFill
                                options:_requestOption
                          resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if ([cell.representedAssetIdentifier isEqualToString:asset.localIdentifier]) {
            cell.image = result;
            cell.isChooseed = [self.selectedImageArray containsObject:asset];
        }
    }];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIWindow* window = nil;
     
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                window = windowScene.windows.firstObject;
                break;
            }
        }
    }else{
        window = [UIApplication sharedApplication].keyWindow;
    }
    
    CGRect cellFrame = [[collectionView cellForItemAtIndexPath:indexPath] convertRect: [collectionView cellForItemAtIndexPath:indexPath].bounds toView:window];
    __block ImagePreview *imagePreview = [[ImagePreview alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [window addSubview:imagePreview];
    PHAsset *asset = [self.imageDataSource objectAtIndex:indexPath.item];
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.synchronous = YES;
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    option.resizeMode = PHImageRequestOptionsResizeModeNone;
    [_imageManager requestImageForAsset:asset
                             targetSize:thumbnailSize
                            contentMode:PHImageContentModeAspectFill
                                options:option
                          resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        imagePreview.image = result;
    }];
    imagePreview.imageFrame = cellFrame;
    [imagePreview showImagePreview];
}

#pragma mark - Album List View Delegate
- (void)didSelectedAblum:(PHAssetCollection *)assetCollection andAssetResult:(PHFetchResult<PHAsset *> *)result {
    self.assetCollection = assetCollection;
    self.fetchResult = result;
    [self.imageDataSource removeAllObjects];
    [self initData];
    self.isShowAlbumList = NO;
    [self.albumTitleBtn setTitle:assetCollection.localizedTitle forState:UIControlStateNormal];
}
@end
