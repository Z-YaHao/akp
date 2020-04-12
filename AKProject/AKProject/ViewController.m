//
//  ViewController.m
//  AKProject
//
//  Created by yahaozhang on 2020/4/12.
//  Copyright © 2020 thsde. All rights reserved.
//

#import "ViewController.h"
#import "AKNetWork.h"
#import "MJRefresh/MJRefresh/MJRefresh.h"
#import "SVProgressHUD.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableDictionary *paraDic;

@property (nonatomic,strong)NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UITableView *akTab;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self dataInit];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"创建" style:UIBarButtonItemStyleDone target:self action:@selector(createModel)];
    
}

-(void)dataInit{
    
    
    self.paraDic = [NSMutableDictionary new];
    [self.paraDic setValue:@"zyh" forKey:@"id"];
    [self.paraDic setValue:@"5" forKey:@"limit"];
    self.dataArr = [NSMutableArray new];
    
    __weak typeof(self) weakself = self;
    self.akTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakself.paraDic setValue:@"1" forKey:@"direction"];
        [weakself.paraDic removeObjectForKey:@"lastItem"];
        [weakself requestData:YES];
    }];
    
    self.akTab.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if (self.dataArr.count > 0) {
            NSDictionary *dic = self.dataArr.lastObject;
            [weakself.paraDic setValue:dic[@"creationTime"] forKey:@"lastItem"];
        }
        
        [weakself.paraDic setValue:@"0" forKey:@"direction"];
        
        [weakself requestData:NO];
    }];
    
    [self requestData:YES];
    
    

}

-(void)requestData:(BOOL)ishead{
     __weak typeof(self) weakself = self;
    NSString *url = @"https://3evjrl4n5d.execute-api.us-west-1.amazonaws.com/dev/message";
    [AKNetWork getRequestWithUrl:url parameter:self.paraDic success:^(id  _Nonnull result) {
        
        
        if (ishead) {
            self.dataArr = [result[@"data"][@"items"] mutableCopy];
            [weakself.akTab reloadData];
            
            [weakself.akTab.mj_header endRefreshing];
            [weakself.akTab.mj_footer endRefreshing];
        }
        else{
            NSArray *darr = result[@"data"][@"items"];
            if (darr.count == 0) {
                [weakself.akTab.mj_footer endRefreshingWithNoMoreData];
            }
            else{
                [self.dataArr addObjectsFromArray:result[@"data"][@"items"]];
                [weakself.akTab reloadData];
                
                [weakself.akTab.mj_footer endRefreshing];
            }
            
        }
        
        
    } failure:^{
        [weakself.akTab.mj_header endRefreshing];
        [weakself.akTab.mj_footer endRefreshing];
    }];
    
}

-(void)createModel{
    
    NSString *url = @"https://3evjrl4n5d.execute-api.us-west-1.amazonaws.com/dev/message";
    NSMutableDictionary *paraDic = [NSMutableDictionary new];
    
    [paraDic setValue:@"zyh" forKey:@"id"];
    
    [paraDic setValue:[self randomStringWithLength:arc4random()%100] forKey:@"content"];
#warning ---------
    [paraDic setValue:@(arc4random()%2) forKey:@"type"];
    
    __weak typeof(self) weakself = self;
    [AKNetWork postRequestWithUrl:url parameter:paraDic success:^(id  _Nonnull result) {
        
        if (result) {
            [paraDic setValue:result[@"timestamp"] forKey:@"creationTime"];
            [weakself.dataArr insertObject:paraDic atIndex:0];
            [weakself.akTab reloadData];
            
        }
        
        
        
    } failure:^{
        
    }];
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"txtcell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"txtcell"];
        cell.detailTextLabel.numberOfLines = 0;
    }
    NSDictionary *model = self.dataArr[indexPath.row];
    cell.textLabel.text = model[@"id"];
    cell.detailTextLabel.text = model[@"content"];
    
    return cell;
}


-(CGFloat )tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}










-(NSString *)randomStringWithLength:(NSInteger)len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSString *str = @"";
    
    for (NSInteger i = 0; i < len; i++) {
        
        NSString *rstr = [letters substringWithRange:NSMakeRange(arc4random()%letters.length, 1)];
        str = [str stringByAppendingString:rstr];
    }
    return str;
}
@end
