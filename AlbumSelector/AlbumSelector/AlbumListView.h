//
//  AlbumListView.h
//  AlbumSelector
//
//  Created by hadlinks on 2020/6/9.
//  Copyright © 2020 hadlinks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
NS_ASSUME_NONNULL_BEGIN
@protocol AlbumListDelegate <NSObject>

- (void)didSelectedAblum:(PHAssetCollection *)assetCollection andAssetResult:(PHFetchResult<PHAsset *> *)result;

@end

@interface AlbumListView : UIView
@property (nonatomic,weak) id <AlbumListDelegate> delegate;
- (void)showAlbumList;
- (void)hidenAlbumList;
@end

NS_ASSUME_NONNULL_END
