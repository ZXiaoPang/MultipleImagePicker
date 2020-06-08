//
//  AssetPickerManager.h
//  AlbumSelector
//
//  Created by hadlinks on 2020/5/27.
//  Copyright © 2020 hadlinks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
#define AssetPickerDefault [AssetPickerManager defaultManager]
@protocol AssetPickerManagerDelegate <NSObject>
- (void)cancleSelectedImage;
- (void)didFinishSelectedImage:(NSMutableArray *)imageArray;
@end
@interface AssetPickerManager : NSObject
@property (nonatomic, weak) id <AssetPickerManagerDelegate> delegate;
@property (nonatomic) int maxSelectCount;

+ (instancetype)defaultManager;
- (void)pushToAlbumListWithController:(UIViewController *)controller;

@end

NS_ASSUME_NONNULL_END
