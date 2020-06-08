//
//  AssetCollectionViewController.h
//  AlbumSelector
//
//  Created by hadlinks on 2020/5/26.
//  Copyright © 2020 hadlinks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN
@class PHAssetCollection;
@interface AssetCollectionViewController : UICollectionViewController
@property (nonatomic, strong) PHFetchResult<PHAsset *> *fetchResult;
@property (nonatomic, strong) PHAssetCollection *assetCollection;
@end

NS_ASSUME_NONNULL_END
