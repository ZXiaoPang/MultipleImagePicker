//
//  HDAuthorizationManager.m
//  AlbumSelector
//
//  Created by hadlinks on 2020/6/5.
//  Copyright © 2020 hadlinks. All rights reserved.
//

#import "HDAuthorizationManager.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@implementation HDAuthorizationManager


/// 相册权限
+ (BOOL)photoLibraryAuthorizationEnabled {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}


/// 相机权限
+ (BOOL)videoMediaAuthorizationEnabled {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted ||
        authStatus ==AVAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}


/// 麦克风权限
+ (BOOL)audioMediaAuthorizationEnabled {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authStatus == AVAuthorizationStatusRestricted ||
        authStatus ==AVAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}


/// APP 推送权限
+ (BOOL)userNotificationAuthorizationEnabled {
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types == UIUserNotificationTypeNone) {
        return NO;
    }
    return YES;
}


/// 定位权限
+ (BOOL)locationAuthorizatuinEnabled {
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}


@end
