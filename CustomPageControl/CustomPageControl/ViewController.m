//
//  ViewController.m
//  CustomPageControl
//
//  Created by weiying on 16/7/26.
//  Copyright © 2016年 amoby. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

#define kScrollPageCount 5
/**
 *  颜色的R,G,B,A
 */
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0)
#define RandomColor RGB(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))

@interface ViewController ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, weak) UIScrollView *scrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupScrollImgAndPageControl];
}

- (void)setupScrollImgAndPageControl
{
    //1、创建一个scrollview显示，显示所有的新特性图片
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    //2、添加图片到scrollview上
    for (int i = 0; i < kScrollPageCount; i ++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(i * self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
        imageView.backgroundColor = RandomColor;
        [scrollView addSubview:imageView];
    }
    scrollView.bounces = NO;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(kScrollPageCount * self.view.frame.size.width, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    //3、添加pagecontrol到view上，和scrollview处于平级
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 30);
    pageControl.userInteractionEnabled = NO;
    pageControl.numberOfPages = kScrollPageCount;
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
    
    //4、利用runtime获取pagecontol属性
    //由于UIPageControl提供的属性和方法不足以修改小圆点的样式
    //通过runtime可知：设置pageControl原点图片的应该是_pageImage和_currentPageImage
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList([pageControl class], &count);
    for (int i = 0; i < count; i ++) {
        Ivar ivar = ivarList[i];
        const char *ivarName = ivar_getName(ivar);
        NSString *name = [NSString stringWithUTF8String:ivarName];
        NSLog(@"name -- %@",name);
    }

    //5、利用KVC更改小圆点普通状态和选中状态样式
    [pageControl setValue:[UIImage imageNamed:@"icon_normal"] forKey:@"_pageImage"];
    [pageControl setValue:[UIImage imageNamed:@"icon_selected"] forKey:@"_currentPageImage"];
}

#pragma mark - scrollview的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double page = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageControl.currentPage = (int)(page + 0.5);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
