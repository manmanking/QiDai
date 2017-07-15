//
//  AddAddressViewController.m
//  QiDai
//
//  Created by 张汇丰 on 16/6/30.
//  Copyright © 2016年 张汇丰. All rights reserved.
//

#import "AddAddressViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "ReactiveCocoa.h"
#import "PersonalAddressModel.h"
#import "QDAlertView.h"
#import "UIButton+AcceptEvent.h"
#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <AddressBook/ABPerson.h>
#import <AddressBookUI/ABPersonViewController.h>
@interface AddAddressViewController ()<UITableViewDataSource,UITableViewDelegate,ABPeoplePickerNavigationControllerDelegate,UITextFieldDelegate>
{
    /** 默认*/
    BOOL _isDefault;
}
@property (nonatomic,strong) ABPeoplePickerNavigationController *peoplePicker;
/** 管理键盘*/
@property (nonatomic,strong) TPKeyboardAvoidingScrollView *bgScrollView;
/** 地址列表*/
@property (nonatomic, strong) UITableView *areaListTableView;
/** 选择区域时的红线*/
@property (nonatomic, strong) UIView *animationLine;
@property (nonatomic, strong) UIButton *tempBtn;
@property (nonatomic, strong) NSMutableArray *initializeArray;//存放初始化左侧数据
/** 储存全部数据的数组，进行数据更新的操作*/
@property (nonatomic, strong) NSArray *allDataArray;//

@property (nonatomic, strong) NSArray *tempArray;
/** 存放市级数据*/
@property (nonatomic, strong) NSArray *temptwonArray;//
/** 存放县级数据*/
@property (nonatomic, strong) NSArray *tempcountryArray;//
/** 选择地区的名字*/
@property (nonatomic, copy) NSString *areaNameString;

@property (nonatomic,strong) UITextField *nameTextField;

@property (nonatomic,strong) UITextField *phoneTextField;

@property (nonatomic,strong) UITextField *detailAddressTextField;
/** 选择地区，可以点击*/
@property (nonatomic,strong) UILabel *areaLabel;
@property (nonatomic,strong) UIButton *saveBtn;

/** 弹框*/
@property (nonatomic,strong) QDAlertView *alertVIew;
@end

@implementation AddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatTitleViewWithString:@"新增地址"];
    self.view.backgroundColor = [UIColor blackColor];
    self.edgesForExtendedLayout = NO;
    //初始化数据
    self.initializeArray = [[NSMutableArray alloc]init];
    self.allDataArray = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
    
    [self createView];
    // Do any additional setup after loading the view.
}
//创建基本的视图
- (void)createView {
    
    self.bgScrollView = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.bgScrollView];
    
    NSArray *array = @[@"收货人",@"手机号码",@"所在区域"];

    [self.bgScrollView addSubview:self.nameTextField];
    [self.bgScrollView addSubview:self.phoneTextField];
    [self.bgScrollView addSubview:self.areaLabel];
    [self.bgScrollView addSubview:self.detailAddressTextField];
    
    if (self.isEdit) {
        self.nameTextField.text = self.model.name;
        self.phoneTextField.text = self.model.phone;
        
        NSArray *array = [self.model.address componentsSeparatedByString:@","];
        
        if (array.count >= 2) {
            self.areaLabel.textColor = kColorForfff;
            self.areaLabel.text = array[0];
            self.detailAddressTextField.text = array[1];
        }
    }
    
    for (int i = 0; i < array.count; i++) {

        UILabel *textLabel = [UILabel qd_labelWithFrame:CGRectMake720(34, 20+i*94, 166, 94) title:array[i] titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:30];
        [self.bgScrollView addSubview:textLabel];
    }
    UIImageView *defultImageView = [[UIImageView alloc] initWithFrame:CGRectMake720(34, 436, 64, 30)];
    defultImageView.image = [UIImage imageNamed:@"address_default_image"];
    [self.bgScrollView addSubview:defultImageView];
    
    UILabel *defaultLabel = [UILabel qd_labelWithFrame:CGRectMake720(123, 396, 400, 106) title:@"设置为默认地址" titleColor:kColorForccc textAlignment:NSTextAlignmentLeft font:30];
    [self.bgScrollView addSubview:defaultLabel];
    
    UIButton *addFriendBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(554, 20, 166, 188) NormalImageString:@"address_add_friend" tapAction:^(UIButton *button) {
        [self clickSystemAddressBook];
    }];
//    //addFriendBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0);
//    [addFriendBtn setTitle:@"添加联系人" forState:UIControlStateNormal];
//    addFriendBtn.titleLabel.font = UIFontOfSize720(24);
//    addFriendBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
//    [addFriendBtn setTitleEdgeInsets:UIEdgeInsetsMake(addFriendBtn.imageView.frame.size.height ,-addFriendBtn.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
//    [addFriendBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0.0, -addFriendBtn.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
    [self.bgScrollView addSubview:addFriendBtn];
    
    //是否设为默认地址
    UIButton *defaultBtn = [UIButton qd_buttonImageButtonWithFrame:CGRectMake720(620, 428, 44, 44) NormalImageString:@"good_select_activity" tapAction:^(UIButton *button) {
        [self clickDefaultBtn:button];
    }];
    [defaultBtn setImage:[UIImage imageNamed:@"address_default_sure"] forState:UIControlStateSelected];
    //defaultBtn.selected = YES;
    
    [self.bgScrollView addSubview:defaultBtn];
    
    //保存按钮
    self.saveBtn = [UIButton qd_buttonTextButtonWithFrame:CGRectMake720(35, 706, 650, 88) title:@"保存" titleColor:kColorForfff titleFont:35 backgroundColor:nil tapAction:^(UIButton *button) {
        [self saveAddress];
    }];
    //self.saveBtn.userInteractionEnabled = NO;
    self.saveBtn.enabled = NO;
    
    
    self.saveBtn.qd_acceptEventInterval = 2.0f;
    [self.saveBtn setBackgroundImage:[UIImage imageNamed:@"login_button_red_bg"] forState:UIControlStateNormal];
    [self.saveBtn setBackgroundImage:[UIImage imageNamed:@"login_button_gary_bg"] forState:UIControlStateDisabled];
    [self.bgScrollView addSubview:self.saveBtn];
    
    if (self.isEdit) {
        _isDefault = NO;
        if ([self.model.is_def isEqualToString:@"1"]) {
            defaultBtn.selected = YES;
            _isDefault = YES;
        }
        [self.saveBtn setTitle:@"保存并使用" forState:UIControlStateNormal];
        
        [self creatRightBtnWithString:@"删除"];
        
        if (self.areaNameString.length == 0) {
            self.areaNameString = [NSString stringWithFormat:@"%@",self.model.address];
        }
        
    }
    // modify by manman  on 2016-09-18 BUG 216 start of line
    RAC(self.saveBtn,enabled) = [RACSignal combineLatest:@[self.phoneTextField.rac_textSignal,self.detailAddressTextField.rac_textSignal,self.nameTextField.rac_textSignal] reduce:^id(NSString *phone,NSString *address,NSString *name){
        if (self.areaNameString.length == 0) {
            return @0;
        }
        return @(phone.length == 11 && address.length > 0 && name.length > 0);
    }];
    
    // end of line
}
#pragma mark --- interface
- (void)saveAddress {
    
    if (![self.phoneTextField.text isMobileNumberClassification]) {
        [[MBProgressHUDManager instance] showHUDWithView:kGetKeyWindow string:@"请输入正确的手机号" andDisappearIn:1];
        return;
    }
    [[MBProgressHUDManager instance] sendRequestShowHUD:self.navigationController.view];
    NSString *address = [NSString stringWithFormat:@"%@,%@",self.areaLabel.text,self.detailAddressTextField.text];
    //保存收货信息    id地址编辑时需要，新增时不需要---
    NSMutableDictionary *param = @{@"name":self.nameTextField.text,
                                 @"phone":self.phoneTextField.text,
                                 @"address":address,
                                 @"userId":kUserId,
                                 @"isDef":@(_isDefault)}.mutableCopy;
    if (self.model) {
        [param setValue:self.model.id forKey:@"id"];
    }
    [QDHttpTool getWithURL:kUrl_saveGoodsAddress params:param success:^(BOOL isSuccess, NSDictionary *responseObject) {
        //NSLog(@"---%@",responseObject);
        if (isSuccess) {
            [[MBProgressHUDManager instance] requestSuccessWithMessage:@"保存成功"];
            //让上个页面刷新
            self.refreshAddressBlock();
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [[MBProgressHUDManager instance] requestSuccessWithMessage:responseObject[@"message"]];
        }
        
    } failure:^(NSError *error) {
        [[MBProgressHUDManager instance] requestFailAndHideHUD];
    }];
}

- (void)deleteAddress {
    
    [[MBProgressHUDManager instance] sendRequestShowHUD:self.navigationController.view];
    NSDictionary *param = @{@"id":self.model.id,
                            @"userId":kUserId};
    [QDHttpTool getWithURL:kUrl_deleteGoodsAddress params:param success:^(BOOL isSuccess, NSDictionary *responseObject) {
        //NSLog(@"---%@",responseObject);
        if (isSuccess) {
            [[MBProgressHUDManager instance] requestSuccessWithMessage:@"删除成功"];
            //让上个页面刷新
            self.refreshAddressBlock();
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [[MBProgressHUDManager instance] requestSuccessWithMessage:responseObject[@"message"]];
        }
        
    } failure:^(NSError *error) {
        [[MBProgressHUDManager instance] requestFailAndHideHUD];
    }];
}
#pragma mark --- private method
///** 点击删除*/
//- (void)clickDeleteBtn {
//    
//}
/** 点击默认btn*/
- (void)clickDefaultBtn:(UIButton *)sender {
    sender.selected = !_isDefault;
    _isDefault = sender.selected;
}
//创建下面选择框的视图
- (void)dd_crearChooseViews {
    
    [self.nameTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    [self.detailAddressTextField resignFirstResponder];
    
    UIView *disView = [self.view viewWithTag:30];
    if (disView) {
        //NSLog(@"bug");
    } else {
        self.areaNameString = @"";
        //self.initializeArray = @[].mutableCopy;
        if (self.initializeArray.count) {
            [self.initializeArray removeAllObjects];
        }
        for (int i = 0; i < self.allDataArray.count; i++) {
            [self.initializeArray addObject:[self.allDataArray[i] objectForKey:@"state"]];
        }
        
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, HCDH - 760*SizeScaleSubjectTo720, HCDW, 760*SizeScaleSubjectTo720)];
        baseView.tag = 30;
        baseView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:baseView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(HCDW/2-150*SizeScaleSubjectTo720, 38*SizeScaleSubjectTo720, 300*SizeScaleSubjectTo720, 50*SizeScaleSubjectTo720)];
        titleLabel.text = @"所在地区";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:28*SizeScaleSubjectTo720];
        [baseView addSubview:titleLabel];
        
        UIButton *dismisBaseViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        dismisBaseViewBtn.frame = CGRectMake720(655, 38, 25, 25);
        [dismisBaseViewBtn setEnlargeEdge:25*SizeScaleSubjectTo720];
        [dismisBaseViewBtn setImage:[UIImage imageNamed:@"address_dismiss_image"] forState:UIControlStateNormal];
        [dismisBaseViewBtn addTarget:self action:@selector(dismis) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:dismisBaseViewBtn];
        
        for (int i = 0; i < 3; i++) {
            UIButton *areaTitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            areaTitleBtn.frame = CGRectMake(i*160*SizeScaleSubjectTo720, 116*SizeScaleSubjectTo720, 160*SizeScaleSubjectTo720, 44*SizeScaleSubjectTo720);
            [areaTitleBtn setTitle:@"请选择" forState:UIControlStateNormal];
            [areaTitleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            areaTitleBtn.tag = 20 + i;
            areaTitleBtn.titleLabel.font = [UIFont systemFontOfSize:30*SizeScaleSubjectTo720];
            [areaTitleBtn addTarget:self action:@selector(nextChooseArea:) forControlEvents:UIControlEventTouchUpInside];
            [baseView addSubview:areaTitleBtn];
            
//            if (self.areaNameString.length > 0) {
//                NSArray *areaArray = [self.areaNameString componentsSeparatedByString:@","];
//                if (i <= areaArray.count) {
//                    [areaTitleBtn setTitle:areaArray[i] forState:UIControlStateNormal];
//                }
//                
//            } else {
//                //给tempBtn初始化赋值
//                if (i == 0) {
//                    self.tempBtn = areaTitleBtn;
//                } else{
//                    areaTitleBtn.hidden = YES;
//                }
//            }
            
            //给tempBtn初始化赋值
            if (i == 0) {
                self.tempBtn = areaTitleBtn;
            } else{
                areaTitleBtn.hidden = YES;
            }
        }
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 160*SizeScaleSubjectTo720, HCDW, 1*SizeScaleSubjectTo720)];
        line.backgroundColor =[UIColor grayColor];
        [baseView addSubview:line];
        
        self.animationLine = [[UIView alloc] initWithFrame:CGRectMake(0, 158*SizeScaleSubjectTo720, 160*SizeScaleSubjectTo720, 2*SizeScaleSubjectTo720)];
        self.animationLine.backgroundColor = [UIColor redColor];
        [baseView addSubview:self.animationLine];
        
        [baseView addSubview:self.areaListTableView];
        [self.areaListTableView reloadData];
        [UIView animateWithDuration:0.5 animations:^{
            baseView.frame = CGRectMake(0, HCDH - 760*SizeScaleSubjectTo720, HCDW, 760*SizeScaleSubjectTo720);
        }];
    }
    
}
#pragma mark --- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.initializeArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.initializeArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:30*SizeScaleSubjectTo720];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tempBtn setTitle:self.initializeArray[indexPath.row] forState:UIControlStateNormal];
    [self.tempBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if (![self.areaNameString isExist]) {
        self.areaNameString = self.initializeArray[indexPath.row];
    } else {
        self.areaNameString = [NSString stringWithFormat:@"%@%@",self.areaNameString,self.initializeArray[indexPath.row]];
    }
    NSLog(@"_______%@",self.areaNameString);
    if (self.tempBtn.tag == 20) {
        
        self.tempArray = [self.allDataArray[indexPath.row] objectForKey:@"cities"];
        self.initializeArray = [NSMutableArray array];
        for (int i = 0; i< self.tempArray.count; i++) {
            [self.initializeArray addObject:[self.tempArray[i] objectForKey:@"city"]];
            self.temptwonArray = self.initializeArray;
        }
        
        //重选操作
        UIButton *btn = [self.view viewWithTag:21];
        //self.areaNameString = @"";
        //self.areaNameString = self.initializeArray[indexPath.row];
        [btn setTitle:@"请选择" forState:UIControlStateNormal];
        UIButton *countrybtn = [self.view viewWithTag:22];
        countrybtn.hidden = YES;
        //                if ([self.areaNameString isEqualToString:@""]) {
        //                        self.areaNameString = @"";
        //
        //                    }
        
        
    }
    if (self.tempBtn.tag == 21) {
        
        self.initializeArray = [NSMutableArray arrayWithArray:[self.tempArray[indexPath.row] objectForKey:@"areas"]];
        //NSLog(@"%@",self.initializeArray);
        
        self.tempcountryArray = self.initializeArray;
        if (self.initializeArray.count == 0) {
            [self dismis];
            return;
        }
    }
    
    [self.areaListTableView reloadData];
    
    if (self.tempBtn.tag == 22) {
        [self dismis];
    }
    if (self.tempBtn.tag < 22) {
        UIButton *btn = [self.view viewWithTag:self.tempBtn.tag+1];
        btn.hidden = NO;
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.tempBtn = btn;
        [self animationLine:btn.tag];
        
    }
    
}

#pragma mark --- 通讯录的deldegate
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person NS_AVAILABLE_IOS(8_0) {
    
}
//点击完成进入回调
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    long index = ABMultiValueGetIndexForIdentifier(phone,identifier);
    NSString *phoneNO = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, index);
    if ([phoneNO hasPrefix:@"+"]) {
        phoneNO = [phoneNO substringFromIndex:3];
    }
    phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
    //NSLog(@"ios 8 %@", phoneNO);
    NSString * name = (__bridge NSString *)ABRecordCopyCompositeName(person);
    
    self.nameTextField.text = name;
    self.phoneTextField.text = phoneNO;
    //[self setValue:name forKey:@"nameTextField"];
    //[self.nameTextField resignFirstResponder];
    
    
}
#pragma mark tapMeathd
- (void)chooseAreaTapGes {
    [self dd_crearChooseViews];
}
- (void)addChatPTapGes {
    NSLog(@"增加联系人");
}
- (void)dismis {
    UIView *disView = [self.view viewWithTag:30];
    [UIView animateWithDuration:0.5 animations:^{
        disView.frame = CGRectMake(0, HCDH, HCDW, 0);
    }completion:^(BOOL finished){
        [disView removeFromSuperview];
    }];
    
    if ([self.areaNameString isExist]) {
        self.areaLabel.textColor = kColorForfff;
        self.areaLabel.text = self.areaNameString;
    }
    
}
/** 往回走*/
- (void)nextChooseArea:(UIButton *)btn {
    [self.tempBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.tempBtn = btn;
    [self animationLine:btn.tag];
    if (btn.tag == 20) {
        self.areaNameString = @"";
        [self initiazeArrayData];
    }
    if (btn.tag == 21) {
        self.initializeArray = [NSMutableArray arrayWithArray:self.temptwonArray];
        [self.areaListTableView reloadData];
    }
    if (btn.tag == 22) {

        self.initializeArray = [NSMutableArray arrayWithArray:self.tempcountryArray];
        [self.areaListTableView reloadData];
    }
}
//初始化省级数据操作
- (void)initiazeArrayData {
    self.initializeArray = [NSMutableArray array];
    for (int i = 0; i<self.allDataArray.count; i++) {
        [self.initializeArray addObject:[self.allDataArray[i] objectForKey:@"state"]];
    }
    [self.areaListTableView reloadData];
}
- (void)animationLine:(NSInteger )num {
    [UIView animateWithDuration:0.3f animations:^{
        self.animationLine.frame = CGRectMake((num-20)*160*SizeScaleSubjectTo720, 158*SizeScaleSubjectTo720, 160*SizeScaleSubjectTo720, 2*SizeScaleSubjectTo720);
    }];
}
- (void)clickSystemAddressBook {
    BOOL isSuccess =  [self authorizationAddressBookStatus];
    if (!isSuccess) {
        //做一个友好的提示
        UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的通讯录\n设置>隐私>通讯录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alart show];
        return;
    }
    self.peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
    self.peoplePicker.peoplePickerDelegate = self;
    
    if(IOS8_OR_LATER) {
        self.peoplePicker.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
    }
    [self presentViewController:self.peoplePicker animated:YES completion:nil];
}
//验证当前通讯录授权状态
- (BOOL) authorizationAddressBookStatus {
    BOOL __block isSuccess = YES;
    //取得授权状态
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    //声明一个通讯簿的引用
    ABAddressBookRef addBook =nil;
    if (authStatus != kABAuthorizationStatusAuthorized) {
        //因为在IOS6.0之后和之前的权限申请方式有所差别，这里做个判断
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
            //创建通讯簿的引用
            addBook = ABAddressBookCreateWithOptions(NULL, NULL);
            //创建一个出事信号量为0的信号
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            //申请访问权限
            ABAddressBookRequestAccessWithCompletion(addBook, ^(bool greanted, CFErrorRef error){
                //greanted为YES是表示用户允许，否则为不允许
                if (!greanted) {
                    NSLog(@"授权失败");
                    isSuccess = NO;
                }
                //发送一次信号
                dispatch_semaphore_signal(sema);
            });
            //等待信号触发
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        } else {
            //IOS6之前
            addBook = ABAddressBookCreate();
        }
        
    }
    return isSuccess;
    
}

#pragma mark ---- UITextFieldDelegate --- start

// add by manman on2016-09-18 BUG 216 start of line
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.nameTextField.text.length >0 && self.detailAddressTextField.text.length >0 &&
        self.phoneTextField.text.length == 11 &&self.areaNameString.length>0) {
        self.saveBtn.enabled = YES;
        
        
    }
    
    
}

// end of line 
#pragma mark ---- UITextFieldDelegate --- end


#pragma mark --- super method
- (void)clickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}
/** 删除地址*/
- (void)clickRightBtn {
    [self.alertVIew updateUIAutolayout];
    [self.view addSubview:self.alertVIew];
}
#pragma mark --- lazy load
- (UITableView *)areaListTableView {
    if (!_areaListTableView) {
        _areaListTableView = [[UITableView alloc]initWithFrame:CGRectMake720(0, 160, 720, 600) style:UITableViewStylePlain];
        _areaListTableView.height -= 64;
        _areaListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _areaListTableView.delegate = self;
        _areaListTableView.dataSource = self;
        _areaListTableView.rowHeight = 100*SizeScale;
        _areaListTableView.showsVerticalScrollIndicator = NO;
    }
    return _areaListTableView;
}
- (UITextField *)nameTextField {
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc]initWithFrame:CGRectMake720(196, 20, 350, 94)];
        _nameTextField.font = UIFontOfSize720(26);
        _nameTextField.placeholder = @"请输入姓名";
        _nameTextField.textColor = kColorForfff;
        _nameTextField.delegate = self;
        [_nameTextField setValue:kColorFor999 forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _nameTextField;
}
- (UITextField *)phoneTextField {
    if (!_phoneTextField) {
        _phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake720(196, 114, 350, 94)];
        _phoneTextField.font = UIFontOfSize720(26);
        _phoneTextField.placeholder = @"请输入收货人手机号码";
        _phoneTextField.textColor = kColorForfff;
        _phoneTextField.delegate = self;
        [_phoneTextField setValue:kColorFor999 forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _phoneTextField;
}
- (UILabel *)areaLabel {
    if (!_areaLabel) {
        _areaLabel = [UILabel qd_labelWithFrame:CGRectMake720(196, 208, 350, 94) title:@"请选择收货地区" titleColor:kColorFor999 textAlignment:NSTextAlignmentLeft font:26];
        UITapGestureRecognizer *addChatPTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dd_crearChooseViews)];
        _areaLabel.userInteractionEnabled = YES;
        [_areaLabel addGestureRecognizer:addChatPTapGes];
    }
    return _areaLabel;
}
- (UITextField *)detailAddressTextField {
    if (!_detailAddressTextField) {
        _detailAddressTextField = [[UITextField alloc]initWithFrame:CGRectMake720(196, 302, 500, 94)];
        _detailAddressTextField.font = UIFontOfSize720(26);
        _detailAddressTextField.placeholder = @"输入详细收货地址(如门牌号等)";
        _detailAddressTextField.textColor = kColorForfff;
        _detailAddressTextField.delegate = self;
        [_detailAddressTextField setValue:kColorFor999 forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _detailAddressTextField;
}
- (QDAlertView *)alertVIew {
    if (!_alertVIew) {
        _alertVIew = [[QDAlertView alloc]initWithFrame:self.view.bounds];
        _alertVIew.title = @"确定删除地址吗？";
        _alertVIew.sureBtnTitle = @"确定";
        _alertVIew.cancleBtnTitle = @"取消";
        _alertVIew.rewriteCancleMethod = NO;
        @weakify_self
        _alertVIew.clickSureBlock = ^ {
            @strongify_self
            [self deleteAddress];
        };
        //[_alertVIew updateUIAutolayout];
    }
    return _alertVIew;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
