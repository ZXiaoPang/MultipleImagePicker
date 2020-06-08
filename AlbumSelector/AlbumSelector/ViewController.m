//
//  ViewController.m
//  AlbumSelector
//
//  Created by hadlinks on 2020/5/21.
//  Copyright © 2020 hadlinks. All rights reserved.
//

#import "ViewController.h"
#import "AssetPickerManager.h"
@interface ViewController ()<AssetPickerManagerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)showAlbums:(UIButton *)sender {
    AssetPickerDefault.delegate = self;
    [AssetPickerDefault pushToAlbumListWithController:self];

}

#pragma mark - AssetPickerManager Delegate
- (void)cancleSelectedImage {
    
}

- (void)didFinishSelectedImage:(nonnull NSMutableArray *)imageArray {
     
}

@end
