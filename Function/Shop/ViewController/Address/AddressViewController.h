//
//  AddressViewController.h
//  QiDai
//
//  Created by 张汇丰 on 16/6/30.
//  Copyright © 2016年 张汇丰. All rights reserved.
//  所有的地址

#import "QDRootViewController.h"

#define kWHEREFROMSETTINGVIEW @"kWHEREFROMSETTINGVIEW"

#define kWHEREFROMCONFIRMORDERVIEW @"kWHEREFROMCONFIRMORDERVIEW"



@protocol AddressViewControllerDelegate <NSObject>

/**
 *  当新增地址时,把当前的地址数组传给之前的页面
 *
 *  @param array 当前的所有的地址
 */
- (void)refreshAdressArrayWithArray:(NSArray *)array;

- (void)refeshAddressWithPage:(NSInteger)page;

@end

@interface AddressViewController : QDRootViewController



@property (nonatomic,strong) NSString *whereFromFlagStr;

/** 上个页面传回来所有的地址数据*/
@property (nonatomic,strong) NSMutableArray *addressArrayM;

/** 标记地址是第几个*/
@property (nonatomic,assign) NSInteger addressPage;

@property (nonatomic,weak) id<AddressViewControllerDelegate> delegate;

@end
