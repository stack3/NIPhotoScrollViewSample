//
//  STViewController.m
//  NIPhotoScrollViewSample
//
//  Created by EIMEI on 2013/05/04.
//  Copyright (c) 2013 stack3.net. All rights reserved.
//

#import "STViewController.h"
#import "NimbusPhotos.h"
#import "AFNetworking.h"

@implementation STViewController {
    __weak NIPhotoScrollView *_photoScrollView;
    __strong NSOperationQueue *_operationQueue;
    __strong UIImage *_thumbnailImage;
    __strong UIImage *_originalImage;
    __strong NSURL *_originalImageURL;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGRect bounds = self.view.bounds;
    
    NIPhotoScrollView *photoScrollView = [[NIPhotoScrollView alloc] initWithFrame:bounds];
    _photoScrollView = photoScrollView;
    _photoScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _photoScrollView.photoDimensions = CGSizeMake(800, 600);
    [self.view addSubview:_photoScrollView];
    
    _operationQueue = [[NSOperationQueue alloc] init];
    _thumbnailImage = [UIImage imageNamed:@"ramen200x150.jpg"];
    _originalImageURL = [NSURL URLWithString:@"http://cdn-ak.f.st-hatena.com/images/fotolife/e/eimei23/20120413/20120413232454.jpg"];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (_originalImage) {
        [_photoScrollView setImage:_originalImage photoSize:NIPhotoScrollViewPhotoSizeOriginal];
    } else {
        [_photoScrollView setImage:_thumbnailImage photoSize:NIPhotoScrollViewPhotoSizeThumbnail];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if (_originalImage == nil) {
        //
        // Start Loading original image.
        //
        NSURLRequest *request = [NSURLRequest requestWithURL:_originalImageURL];
        NSOperation *operation =
        [AFImageRequestOperation
           imageRequestOperationWithRequest:request
                                    success:^(UIImage *image) {
                                        _originalImage = image;
                                        [_photoScrollView setImage:_originalImage
                                                         photoSize:NIPhotoScrollViewPhotoSizeOriginal];
                                    }];
        [_operationQueue addOperation:operation];
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //
    // Set the image again to place at correct position.
    //
    if (_originalImage) {
        [_photoScrollView setImage:_originalImage photoSize:NIPhotoScrollViewPhotoSizeOriginal];
    } else {
        [_photoScrollView setImage:_thumbnailImage photoSize:NIPhotoScrollViewPhotoSizeThumbnail];
    }
}

@end
