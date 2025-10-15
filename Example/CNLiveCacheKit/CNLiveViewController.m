//
//  CNLiveViewController.m
//  CNLiveCacheKit
//
//  Created by woshiliushiyu on 04/26/2019.
//  Copyright (c) 2019 woshiliushiyu. All rights reserved.
//

#import "CNLiveViewController.h"
#import "CNLiveCacheManager.h"
#import "CNLiveSourceModel.h"

@interface CNLiveViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) CNLiveCacheManager * cache;
@property (nonatomic, assign) BOOL newFile;

@property (nonatomic, assign) CNLiveCacheType actionType;
@property (nonatomic, strong) CNLiveSourceModel * model;

@property (weak, nonatomic) IBOutlet UITextField *keyText;
@property (weak, nonatomic) IBOutlet UITextField *valueText;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;

@end

@implementation CNLiveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.newFile = NO;//不创建文件夹
    self.actionType = CNLiveCacheTypeDefult;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.model = [[CNLiveSourceModel alloc] initWithisSuccess:YES number:1 str:@"诗经" array:@[@"成功"]];
}
- (IBAction)cache:(id)sender {
    UIImage * image = [UIImage imageNamed:@"xiaomeng.png"];
    NSData * imageData = UIImagePNGRepresentation(image);
    [CNLiveCacheManager cacheManager].actionType(CNLiveCacheActionTypeInsert).key(@"xiaomeng").object(imageData).completerBlock(^(NSString *key,id result,BOOL contain){
        NSLog(@"插入成功");
    });
}
- (IBAction)selectAction:(id)sender {
    CACHE.actionType(CNLiveCacheActionTypeContain).key(@"xiaomeng").completerBlock(^(NSString *key,id result,BOOL contain){
        NSLog(@"是否有=>%d",contain);
    });
}

- (IBAction)delectAction:(id)sender {
    CACHE.actionType(CNLiveCacheActionTypeDelect).key(@"xiaomeng").completerBlock(^(NSString *key,id result,BOOL contain){
        NSLog(@"删除成功");
    });
}

- (IBAction)load:(id)sender {
    [CNLiveCacheManager cacheManager].actionType(CNLiveCacheActionTypeSelect).key(@"xiaomeng").completerBlock(^(NSString *key,id result,BOOL contain){
        dispatch_sync(dispatch_get_main_queue(), ^{
            UIImage * image = [UIImage imageWithData:(NSData *)result];
            self.imageView.image = image;
        });
    });
}

#pragma mark =======================================

- (IBAction)cunAction:(id)sender {
    
    CACHE.actionType(CNLiveCacheActionTypeInsert).newFile(self.newFile).key(self.keyText.text).object(self.model).cacheType(self.actionType).start;
}
- (IBAction)xianAction:(id)sender {
    
//    self.showLabel.text = CACHE.actionType(CNLiveCacheActionTypeSelect).key(self.keyText.text).cacheType(self.actionType).start;  .fileName(@[self.valueText.text])
    CNLiveSourceModel * sourceModel =  CACHE.actionType(CNLiveCacheActionTypeSelect).key(self.keyText.text).cacheType(self.actionType).start;
    NSLog(@"=>%@",sourceModel);
}
- (IBAction)shanAction:(id)sender {
    CACHE.actionType(CNLiveCacheActionTypeDelect).newFile(self.newFile).key(self.keyText.text).cacheType(self.actionType).start;
}
- (IBAction)chaAction:(id)sender {
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[CACHE.actionType(CNLiveCacheActionTypeContain).key(self.keyText.text).cacheType(self.actionType).start boolValue]?@"有该数据":@"没有该数据" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
- (IBAction)newFile:(id)sender {
    UISegmentedControl * segMent = (UISegmentedControl *)sender;
    NSInteger num = segMent.selectedSegmentIndex;
    if (num == 0) {
        self.newFile = NO;
    }else{
        self.newFile = YES;
    }
}

- (IBAction)changeType:(id)sender {
    UISegmentedControl * segMent = (UISegmentedControl *)sender;
    NSInteger num = segMent.selectedSegmentIndex;
    if (num == 0) {
        self.actionType = CNLiveCacheTypeDefult;
    }else if (num == 1) {
        self.actionType = CNLiveCacheTypeFile;
    }else if (num == 2) {
        self.actionType = CNLiveCacheTypeSQLite;
    }else{
        self.actionType = CNLiveCacheTypeUserDefa;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
