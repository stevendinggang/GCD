//
//  ViewController.m
//  iOS多线程
//
//  Created by Steven on 2018/8/23.
//  Copyright © 2018 Steven. All rights reserved.
//

#import "ViewController.h"
#import "DGGCDTool.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) NSInteger a; //
@property (nonatomic,strong) UITableView *tableView; //
@property (nonatomic,strong) NSMutableArray *array; //
@property(nonatomic,strong) NSMutableArray *tableArray;
@property (nonatomic,assign) NSInteger ticketSurplusCount; //

@property (nonatomic,strong) dispatch_semaphore_t semaphoreLock; //

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUI];
}

-(void)setUI{
    self.edgesForExtendedLayout = UIRectEdgeNone; //默认布局从导航栏下开始
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    tableView.dataSource =self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    
    
    self.tableView = tableView;
    self.tableView.tableFooterView = [[UIView alloc] init];//空白处理
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//线隐藏
//    self.tableView.backgroundColor = BackGroudGrayColor;
    
    //添加线的
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    self.tableView.showsHorizontalScrollIndicator = NO; //隐藏下滑
    self.tableView.showsVerticalScrollIndicator = NO; //隐藏条

}


#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.tableArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.tableArray[indexPath.row]];
    //cell.textLabel.text = [NSString stringWithString:[@"第%@行",indexPath]];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor purpleColor];
    //无选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        [self click1];
    }else if (indexPath.row == 1){
        [self click2];
    }else if (indexPath.row == 2){
        [self click3];
    }else if (indexPath.row == 3){
        [self click4];
    }else if (indexPath.row == 4){
        [self click5];
    }else if (indexPath.row == 5){
        [self click6];
    }else if (indexPath.row == 6){
        [self click7];
    }else if (indexPath.row == 7){
        [self click8];
    }else if (indexPath.row == 8){
        [self click9];
    }else if (indexPath.row == 9){
        [self click10];
    }else if (indexPath.row == 10){
        [self group];
    }else if (indexPath.row == 11){
        [self groupWait];
    }else if (indexPath.row == 12){
        [self semaphor];
    }else if (indexPath.row == 13){
        [self semaphorLock];
    }else if (indexPath.row == 12){
        [self semaphor];
    }else if (indexPath.row == 12){
        [self semaphor];
    }else if (indexPath.row == 12){
        [self semaphor];
    }
}


#pragma Mark -空白视图代理

// 两个异步线程同时执行 +
- (void)click1{
    //异步线程1
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self addWithNum];
    });
    
    //异步线程1
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self addWithNum];
    });
}


// 串行队列任务
- (void)click2{
    //
    dispatch_queue_t q = dispatch_queue_create("chuanXing", DISPATCH_QUEUE_SERIAL);
    for (int i=0; i<500; i++) {
        // 串行队列的任务
        dispatch_async(q, ^{
            self.a++;
            NSLog( @"%@ %d" , [NSThread  currentThread ], i);
            NSLog(@"修改的---%ld",self.a);
        });
    }
    //    串行队列的任务
    //    dispatch_async(q, ^{
    //        // NSLog(@"1");
    //        [self addWithNum];
    //        NSLog(@"1");
    //    });
    
    //    dispatch_queue_t t = dispatch_queue_create("123", NULL); // 串行队列
}

// 创建同步队列任务
- (void)click3{
    // 1. 队列
    dispatch_queue_t q = dispatch_queue_create("zfl", DISPATCH_QUEUE_CONCURRENT);
    // 2. 同步执行
    for(int  i = 0 ; i < 500 ; ++i) {
        dispatch_sync(q, ^{
            self.a++;
            NSLog( @"%@ %d" , [NSThread  currentThread ], i);
        });
    }
    NSLog(@"come here - %@" ,[NSThread currentThread]);
}

//主线程同步执行任务
- (void)click4{
    // 1. 主队列
    dispatch_queue_t t = dispatch_get_main_queue();
    
    for (int i = 0; i<500; i++) {
        dispatch_sync(t, ^{
            self.a++;
            NSLog( @"%@ %d  a=%ld" , [NSThread  currentThread ], i,(long)self.a);
        });
    };
    
    dispatch_sync(t, ^{
        [self addWithNum];
    });
    
    NSLog(@"come here - %@" ,[NSThread currentThread]);
}


/**
 * 同步执行 + 并发队列
 * 特点：在当前线程中执行任务，不会开启新线程，执行完一个任务，再执行下一个任务。
 */

- (void)click5{
    //1.创建一个并发队列
    dispatch_queue_t t = dispatch_queue_create("bingfa", DISPATCH_QUEUE_CONCURRENT);
    //    dispatch_queue_t t = dispatch_get_main_queue();
    //2. 同步任务
    //同步任务1
    dispatch_sync(t, ^{
        NSLog(@"任务1---%ld",self.a);
        [self addWithNum];
    });
    //同步任务2
    dispatch_sync(t, ^{
        [self addWithNum];
    });
}

/**
 * 异步执行 + 并发队列
 * 特点：在当前线程中执行任务，不会开启新线程，执行完一个任务，再执行下一个任务。
 */

- (void)click6{
   
    //1.创建一个并发队列
    dispatch_queue_t queue = dispatch_queue_create("bingfa", DISPATCH_QUEUE_CONCURRENT);
    //2. 异步任务 1
//    dispatch_async(queue,^{
//        [self addWithNum];
//    });
//    //3. 异步任务 2
//    dispatch_async(queue,^{
//        [self addWithNum];
//    });
    
//    3. 异步任务 3
    dispatch_async(queue,^{
//        [NSThread sleepForTimeInterval:3];
        [self addWithNum];
    });

    dispatch_async(queue,^{
            for (int i=0; i<500; i++) {
            self.a++;
            NSLog( @"%@  a=%ld" , [NSThread  currentThread],self.a);
           }
    });
    
    // 开启了两个线程 3.4 交替进行操作, 当出现耗时操作时候,不会等待
    
}


/**
 * 同步执行 + 串行队列
 * 特点：不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务。
 */
- (void)click7{
    //1.创建一个串行队列
    dispatch_queue_t t = dispatch_queue_create("bingfa", DISPATCH_QUEUE_SERIAL);
    //    dispatch_queue_t t = dispatch_get_main_queue();
    //2. 同步任务
    //同步任务1
    dispatch_sync(t, ^{
        NSLog(@"任务1---%ld",self.a);
        [self addWithNum];
    });
    //同步任务2
    dispatch_sync(t, ^{
        [self addWithNum];
    });
    
    //同步无法开启线程, 只能在主线程操作
}

//  异步串行
//会开启新线程，但是因为任务是串行的，执行完一个任务，再执行下一个任务

- (void)click8{
    //1.创建一个串行队列
    dispatch_queue_t t = dispatch_queue_create("bingfa", DISPATCH_QUEUE_SERIAL);
    //    dispatch_queue_t t = dispatch_get_main_queue();
    //2. 同步任务
    //同步任务1
    dispatch_async(t, ^{
        NSLog(@"任务1---%ld",self.a);
        [self addWithNum];
    });
    //同步任务2
    dispatch_async(t, ^{
        [self addWithNum];
    });
    
    //会开启新线程，但是因为任务是串行的,一个一个来,速度很快
}


//  异步线程执行 +主队列

- (void)click9{
    //1.创建一个并行队列
    dispatch_queue_t t = dispatch_queue_create("bingfa", DISPATCH_QUEUE_CONCURRENT);
    //    dispatch_queue_t t = dispatch_get_main_queue();
    //2. 同步任务
    //同步任务1
    dispatch_async(t, ^{
        NSLog(@"任务1---%ld",self.a);
        [self click4];
    });

    //会开启新线程，但是因为任务是串行的,一个一个来,速度很快
}


//GCD 栅栏方法：dispatch_barrier_async
/**
 * 栅栏方法 dispatch_barrier_async
 */
-(void)click10{
    
    //并发队列
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_barrier_async(queue, ^{
        // 追加任务 barrier
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"barrier---%@",[NSThread currentThread]);// 打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(queue, ^{
        // 追加任务4
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"4---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
}


// 线程组- 线程通知使用
// 2个耗时操作
-(void)group{
   
    //创建线程组
    dispatch_group_t group = dispatch_group_create();
    
    // 并发队列
    dispatch_queue_t queue = dispatch_queue_create("name", DISPATCH_QUEUE_CONCURRENT);

    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:2];
        [self addWithNum];
    });
    
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:2];
        [self addWithNum];
    });
    
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:5];
        [self addWithNum];
    });
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"666666666");
    });
    
}


// 线程组阻塞
-(void)groupWait{
    //创建线程组
    dispatch_group_t group = dispatch_group_create();
    //创建并发线程
    dispatch_queue_t t = dispatch_queue_create("66666", DISPATCH_QUEUE_CONCURRENT);
    
    //异步线程
    dispatch_group_async(group, t, ^{
        [NSThread sleepForTimeInterval:10];
        NSLog(@"11111");
    });
    dispatch_group_async(group, t, ^{
        [NSThread sleepForTimeInterval:8];
        NSLog(@"1222222");
    });
    
    //等待
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"暂停一下");
    //执行
    dispatch_group_async(group, t, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"666666");
    });
    
    //执行
    dispatch_group_async(group, t, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"688888");
    });
    
}


// 信号量 Dispatch Semaphor,将异步线程同步
-(void)semaphor{
     dispatch_queue_t t = dispatch_queue_create("bongfade", DISPATCH_QUEUE_CONCURRENT);
    
     dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block int number = 0; //强引用
    
    dispatch_async(t,^{
       //追加任务1
        [NSThread sleepForTimeInterval:3];
       //追加任务2
        number = 100;
        
        dispatch_semaphore_signal(semaphore); //加锁
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        NSLog(@" dispatch_asyn 第一个 加锁的 %d",number);
    });
    
    dispatch_async(t,^{
        //追加任务1
        [NSThread sleepForTimeInterval:3];
        //追加任务2
        number = 2000;
        //      dispatch_semaphore_signal(semaphore); //加锁
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        NSLog(@" dispatch_asyn 第二个 %d",number);
        
    });

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); //线程阻塞
    
    NSLog(@"dispatch_async-end %d",number);
    
    dispatch_async(t,^{
        //追加任务1
        [NSThread sleepForTimeInterval:3];
        //追加任务2
        number = 10;
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        NSLog(@"%d",number);

    });
    
    dispatch_async(t,^{
        //追加任务1
        [NSThread sleepForTimeInterval:3];
        //追加任务2
        number = 20;
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        NSLog(@"%d",number);
    });
    
    NSLog(@"end   %d",number);

}


// 信号量 Dispatch Semaphor,线程锁
-(void)semaphorLock{
    
    self.ticketSurplusCount = 50;
    self.semaphoreLock = dispatch_semaphore_create(1); //创建信号量

    //线程1
//    dispatch_queue_t t1 = dispatch_queue_create("123", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t t1 = dispatch_queue_create("123", DISPATCH_QUEUE_CONCURRENT);
    //线程2
//    dispatch_queue_t t2 = dispatch_queue_create("1234", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t t2 = dispatch_queue_create("1234", DISPATCH_QUEUE_CONCURRENT);

    __weak typeof(self) weakSelf = self;
    dispatch_async(t1, ^{
        [weakSelf saleTicketNotSafe];
    });

    dispatch_async(t2, ^{
        [weakSelf saleTicketNotSafe];
    });

    
    
    
}

/**
 * 售卖火车票(非线程安全)
 */
- (void)saleTicketNotSafe {

    while (1) {
        
        dispatch_semaphore_wait(self.semaphoreLock, DISPATCH_TIME_FOREVER); //加锁等待
        
        if (self.ticketSurplusCount > 0) {  //如果还有票，继续售卖
            self.ticketSurplusCount--;
            //解锁
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%ld 窗口：%@", (long)self.ticketSurplusCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        } else { //如果已卖完，关闭售票窗口
            NSLog(@"所有火车票均已售完");
            dispatch_semaphore_signal(self.semaphoreLock);
            break;
        }
            dispatch_semaphore_signal(self.semaphoreLock);
    }
}


//异步执行
-(void)addWithNum{
    for (int i=0; i<500; i++) {
        self.a++;
        NSLog( @"%@  a=%ld" , [NSThread  currentThread],self.a);
    }
    NSLog(@"修改的---%ld",self.a);
}

#pragma mark -tableView
- (NSMutableArray *)tableArray{
    if (_tableArray==nil) {
        NSArray *array = @[@"两个异步线程同时执行 + ",@"串行队列任务",@"创建同步队列任务",@"主线程同步执行任务",@"同步执行 + 并发队列",@"异步执行 + 并发队列",@"同步串行",@"异步串行",@"异步执行 + 主队列",@"GCD 栅栏方法：dispatch_barrier_async",@"线程组的使用",@"线程组阻塞",@"信号量 Dispatch Semaphor",@"信号量 Dispatch Semaphor保证线程安全",@"同步串行"];
        _tableArray = [NSMutableArray arrayWithArray:array];
    }
    return _tableArray;
}




@end
