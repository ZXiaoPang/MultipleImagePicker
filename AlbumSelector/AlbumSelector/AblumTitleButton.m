//
//  AblumTitleButton.m
//  AlbumSelector
//
//  Created by hadlinks on 2020/6/8.
//  Copyright © 2020 hadlinks. All rights reserved.
//

#import "AblumTitleButton.h"

@implementation AblumTitleButton

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -
     self.imageView.frame.size.width, 0, self.imageView.frame.size.width)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.bounds.size.width, 0, - self.titleLabel.bounds.size.width - 8)];
}

@end
