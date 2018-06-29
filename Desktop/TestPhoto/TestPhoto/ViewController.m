//
//  ViewController.m
//  TestPhoto
//
//  Created by ZJ on 12/07/2017.
//  Copyright © 2017 HY. All rights reserved.
//

#import "ViewController.h"
#import <Photos/Photos.h>
#import "TestAViewController.h"

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)btnEvent:(UIButton *)sender {

    TestAViewController *vc = [TestAViewController new];
    [self.navigationController pushViewController:vc animated:YES];
//    PHFetchResult *collectonResuts = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:[PHFetchOptions new]] ;
//    [collectonResuts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        PHAssetCollection *assetCollection = obj;
//        
//        if ([assetCollection.localizedTitle isEqualToString:@"Camera Roll"])  {
//            PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:[PHFetchOptions new]];
//            [assetResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//                    //获取相册的最后一张照片
//                    if (idx == [assetResult count] - 1) {
//                        [PHAssetChangeRequest deleteAssets:@[obj]];
//                    }
//                } completionHandler:^(BOOL success, NSError *error) {
//                    NSLog(@"Error: %@", error);
//                }];
//            }];
//        }
//    }];
    
//    //首先获取相册的集合
//    PHFetchResult *collectonResuts = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:[PHFetchOptions new]] ;
//    //对获取到集合进行遍历
//    [collectonResuts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        PHAssetCollection *assetCollection = obj;
//        //Camera Roll是我们写入照片的相册
//        if ([assetCollection.localizedTitle isEqualToString:@"Camera Roll"])  {
//            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//                //请求创建一个Asset
//                PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:[UIImage imageNamed:@"pet"]];
//                //请求编辑相册
//                PHAssetCollectionChangeRequest *collectonRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
//                //为Asset创建一个占位符，放到相册编辑请求中
//                PHObjectPlaceholder *placeHolder = [assetRequest placeholderForCreatedAsset ];
//                //相册中添加照片
//                [collectonRequest addAssets:@[placeHolder]];
//            } completionHandler:^(BOOL success, NSError *error) {
//                NSLog(@"Error:%@", error);
//            }];
//        }
//    }];
    
//    UIImagePickerController *_imagePickerController = [[UIImagePickerController alloc] init];
//    _imagePickerController.delegate = self;
//    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
////    _imagePickerController.allowsEditing = YES;
//    [self.navigationController presentViewController:_imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0) {
    NSLog(@"%s", __func__);
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"%s", __func__);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"%s", __func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
