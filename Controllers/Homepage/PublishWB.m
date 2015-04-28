//
//  PublishWB.m
//  WBdemo
//
//  Created by Nick on 15-4-15.
//  Copyright (c) 2015年 74td. All rights reserved.
//

#import "PublishWB.h"

#import "AppDelegate.h"
#import "LocalStorage+Download.h"
#import "SettingTool.h"
#import "NetworkTool.h"
#import "MBProgressHUDTool.h"
#import "AccountModel.h"

@interface PublishWB ()<UITextViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UILabel *textviewPlacehoder;
@property (weak, nonatomic) IBOutlet UIButton *firstImgBtn;
@property (weak, nonatomic) IBOutlet UILabel *iconLab;
@property (weak, nonatomic) IBOutlet UIView *imgView;

@property (assign, nonatomic) NSInteger btnBag;
@property (assign, nonatomic) NSInteger imgCount;

@end

@implementation PublishWB

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textview.delegate = self;
    [self.textview becomeFirstResponder];
    
    self.firstImgBtn.tag = 1000;
    self.imgCount = 1;
    self.imgView.hidden = YES;
    
    [self showStyle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showStyle{
    if (self.WBstatus == 1) {
        self.textviewPlacehoder.text = @"说说分享心得...";
    }
    if (self.WBstatus == 2) {

    }
}
/**
 *  textviewDelegate
 *
 *  @param textView self.textview
 */
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (![text isEqualToString:@""]) {
        if (textView == self.textview) {
            self.textviewPlacehoder.hidden = YES;
        }
    }
    if ([text isEqualToString:@""]&& range.location == 0 && range.length == 1) {
        if (textView == self.textview) {
            self.textviewPlacehoder.hidden = NO;
        }
    }
    return YES;
}
/**
 *  取消
 *
 */
- (IBAction)returnOnClick:(UIButton *)sender {
    GetAppDelegate;
    [appDelegate.navController popViewControllerAnimated:YES];
}
/**
 *  发送
 *
 */
- (IBAction)publishOnClick:(id)sender {
    if (self.WBstatus == 1) {
        [self zhuanfaWB];
    }
    if (self.WBstatus == 2) {
        [self pinglunWB];
    }
    if (self.WBstatus == 3) {
        
    }
    if (self.WBstatus == 4) {
        [self huifupinglunWB];
    }
}

//1转发微博
-(void)zhuanfaWB{
    if (self.oneAccountModel._id <= 0) {
        [MBProgressHUDTool showErrorWithStatus:@"转发失败"];
        return;
    }
    [NetworkTool statusesRepost:[SettingTool getAccessToken] andwbID:self.oneAccountModel._id andStatus:self.textview.text andis_comment:0 successBlock:^(NSDictionary *resultDic) {
        NSDictionary *resultdic = resultDic[@"user"];
        if (resultdic[@"id"] != nil) {
            [MBProgressHUDTool showSuccessWithStatus:@"转发成功"];
            GetAppDelegate;
            [appDelegate.navController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUDTool showErrorWithStatus:@"转发失败"];
        }
//        GetAppDelegate;
//        [appDelegate.navController popViewControllerAnimated:YES];
    } error:^(NSError *error) {
        [MBProgressHUDTool showErrorWithStatus:@"网络连接错误"];
    }];
}
//2评论微博
-(void)pinglunWB{
    
    if (self.oneAccountModel._id <= 0) {
        [MBProgressHUDTool showErrorWithStatus:@"评论失败"];
        return;
    }
    [NetworkTool commentsCreate:[SettingTool getAccessToken] andID:self.oneAccountModel._id andContent:self.textview.text successBlock:^(NSDictionary *resultDic) {
        if ([resultDic[@"id"] longValue] > 0) {
            [MBProgressHUDTool showSuccessWithStatus:@"评论成功"];
        }else{
            [MBProgressHUDTool showErrorWithStatus:@"评论失败"];
        }
    } error:^(NSError *error) {
        [MBProgressHUDTool showErrorWithStatus:@"网络连接错误"];
    }];
}
//4回复评论
-(void)huifupinglunWB{
    if (self.oneAccountModel._id <= 0) {
        [MBProgressHUDTool showErrorWithStatus:@"回复失败"];
        return;
    }
    [NetworkTool commentsReply:[SettingTool getAccessToken] andID:0 andwbID:0 andComment:self.textview.text andwithout_mention:0 andcomment_ori:0 successBlock:^(NSDictionary *resultDic) {
        if ([resultDic[@"id"] longValue] > 0) {
            [MBProgressHUDTool showSuccessWithStatus:@"回复成功"];
        }else{
            [MBProgressHUDTool showErrorWithStatus:@"回复失败"];
        }
    } error:^(NSError *error) {
        [MBProgressHUDTool showErrorWithStatus:@"网络连接错误"];
    }];
}

#pragma mark
-(void)addMoreImgWithTag:(NSInteger )tag{
    if (self.imgCount <3) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"homepage_tupian"] forState:UIControlStateNormal];
        CGRect frame = self.firstImgBtn.frame;
        frame.origin.x = self.imgCount * (8+80)+8;
        btn.frame = frame;
        btn.tag = tag + 1;
        [self.imgView addSubview:btn];
        [btn addTarget:self action:@selector(addimgOnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.imgCount ++;
    }
    if (self.imgCount > 1) {
        self.iconLab.hidden = YES;
    }
}
- (IBAction)addimgOnClick:(UIButton *)img {
    self.btnBag = img.tag;
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"请选择文件来源"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"照相机",@"本地相簿",nil];
    [actionSheet showInView:self.view];
}
#pragma mark - UIActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0://照相机
        {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
            picker.delegate = self;
            picker.allowsEditing = YES;//设置可编辑
            picker.sourceType = sourceType;
            [self presentViewController:picker animated:YES completion:^{
                
            }];//进入照相界面
        }
            break;
            
        case 1://本地相册
        {
            UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
                
            }
            pickerImage.delegate = self;
            pickerImage.allowsEditing = NO;
            [self presentViewController:pickerImage animated:YES completion:^{
                
            }];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - UIImagePickerController Delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    // 图片压缩，JPEG格式，压缩系数1.0
    NSData *imageData = UIImageJPEGRepresentation(image , 0.7);
    UIImage *imageCompressed = [UIImage imageWithData:imageData];
    
    // 调整图片压缩分辨率
    CGSize size = imageCompressed.size;
    float scaleFactor = [self imageGetScaleFactor:(int)imageData.length];
    size.width = size.width * scaleFactor;
    size.height = size.width;
    UIImage *targetImage = [self scaleToSize:imageCompressed size:size];
    
    
    //压缩至  128k以下
    imageData = UIImageJPEGRepresentation(targetImage , 0.7);
    while (imageData.length > 128*1024) {
        size = imageCompressed.size;
        scaleFactor = [self imageGetScaleFactor:(int)imageData.length];
        size.width = size.width * scaleFactor;
        size.height = size.width;
        targetImage = [self scaleToSize:imageCompressed size:size];
    }
    long long dt = [[NSDate date]timeIntervalSince1970]*1000.0;
    NSString *imgName = [NSString stringWithFormat:@"%lld.jpg",dt];
#warning 测试用，需要删除
    UIButton *btn = (UIButton *)[self.view viewWithTag:self.btnBag];
    [btn setBackgroundImage:targetImage forState:UIControlStateNormal];
    [self addMoreImgWithTag:btn.tag];
    
    //    BOOL success =[LocalStorage saveImage:targetImage WithName:imgName withUserName:[SettingTool getSessionUuid]];
    //    if (!success) {
    //        [MBProgressHUDTool showErrorWithStatus:@"图片获取失败，请在系统设置里增加相关权限"];
    //        return;
    //    }
    //    NSString * path = [LocalStorage getDownloadPathWithUserName:[SettingTool getSessionUuid]];
    
    //    [self sendFileName:imgName FilePath:path];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//
- (void)sendFileName:(NSString *)fileName FilePath:(NSString *)filePath {
    
    NSString * path = [LocalStorage getDownloadPathWithUserName:[SettingTool getAccessToken]];
    NSString *full = [path stringByAppendingPathComponent:fileName];
    UIButton *btn = (UIButton *)[self.view viewWithTag:self.btnBag];
    [btn setBackgroundImage:[UIImage imageWithContentsOfFile:full] forState:UIControlStateNormal];
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

// 根据图片字节长度，获得压缩因子
- (float)imageGetScaleFactor:(int) bytesSize {
    if (bytesSize < 100*1024) { // 小于100k,按照原始比例的1/2压缩
        return 0.5;
    } else if(bytesSize >= 100*1024 && bytesSize < 500*1024){ // 100k =< bytesSize < 500k
        return 0.4;
    } else if(bytesSize >= 500*1024 && bytesSize < 1000*1024){ // 500k =< bytesSize < 1M
        return 0.3;
    } else if (bytesSize >= 1000*1024 && bytesSize < 5000*1024) { // 1000k =< bytesSize < 5M
        return 0.2;
    } else { // 大于5M
        return 0.1;
    }
}
@end
