//
//  WYCallMethodController.swift
//  WYBasisKitTest
//
//  Created by 官人 on 2024/5/13.
//  Copyright © 2024 官人. All rights reserved.
//

import UIKit

class WYCallMethodController: UIViewController, WYMethodSuperProtocol {
    /*
     func testNoParameterMethod() {
         wy_print("testNoParameterMethod() called")
     }
     
     func testParameterMethod(parameter1: String, parameter2: Int) {
         wy_print("testParameterMethod(parameter1: String, parameter2: Int)  called")
     }
     
     func testParameterMethodWithReturnValue(parameter: String) -> String {
         wy_print("testParameterMethodWithReturnValue(parameter: String) called")
         return "通过 return 方式获取的返回值"
     }
     
     func testParameterMethodWithProtocol(parameter: String) {
         wy_print("testParameterMethodWithProtocol(parameter: String) called")
         callMethodClassEventHandle("通过协议方式获取的返回值")
     }
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .wy_random
        
        
    }
    
    func callMethodClassEventHandle(_ responseData: String) {
        wy_print("协议：\(responseData)")
    }
    /*
     请用swift实现如下场景
     1、有个Class也可能是结构体
     2、在class或者结构体中申明了一些方法，有的方法没有参数，有的方法只有一个参数，也可能有的方法有很多个参数，并且有的有返回值，有的没有返回值，同时返回值可能是通过return方式返回的，也可能是通过闭包方式返回的，也可能是通过代理或者协议方式返回的。
     3、现在我在另一个class中要调用这个class或者结构体中申明的方法，如果有回调的话，也要监听回调，但是不能通过这个class或者结构体的实例对象调用方法，只能通过class或者结构体的名字(字符串)和class或者结构体的方法(字符串)来调用
     例如我有个字典，里面存了class或者结构体的信息，其中key是string类型的class或者结构体的名字，value是要实现的class或者结构体的方法，如：["MethodClass":"callMethod:","MethodClass":"callMethod:token:","MethodClass":"callOtherMethod:token1:token2"]
     
     
     //
     //  TestCallMethodController.m
     //  WYBasisKit
     //
     //  Created by zhanxun on 2024/5/13.
     //  Copyright © 2024 jacke-xu. All rights reserved.
     //

     @protocol MethodClassHandleDelegate <NSObject>

     @optional
     - (void)CallMethodClassEventHandle:(NSString *_Nullable)responseData;

     @end

     @interface TestMethodSuperClass : NSObject

     @property (nonatomic, weak) id<MethodClassHandleDelegate> delegate;

     @end

     @implementation TestMethodSuperClass

     @end

     @interface TestMethodClass : TestMethodSuperClass

     @end

     @implementation TestMethodClass

     /// 无参数
     - (void)testNoParameterMethod {
         NSLog(@"- (void)testNoParameterMethod called");
     }

     /// 有参数
     - (void)testParameterMethod:(NSString *)parameter1 parameter2:(NSInteger)parameter2 {
         NSLog(@"- (void)testParameterMethod:(NSString *)parameter1 parameter2:(NSInteger)parameter2  called");
     }

     /// 有参数有返回值
     - (NSString *)testParameterMethodWithReturnValue:(NSString *)parameter {
         NSLog(@"- (NSInteger)testParameterMethodWithReturnValue:(NSString *)parameter called");
         return @"通过return方式获取的返回值";
     }

     /// 有参数有返回值
     - (void)testParameterMethodWithDelegate:(NSString *)parameter {
         NSLog(@"- (void)testParameterMethodWithDelegate:(NSString *)parameter called");
         if ((self.delegate != nil) && ([self.delegate respondsToSelector:@selector(CallMethodClassEventHandle:)])) {
             [self.delegate CallMethodClassEventHandle:@"通过代理方式获取的返回值"];
         }
     }

     @end

     #import "TestCallMethodController.h"

     @interface TestCallMethodController ()<MethodClassHandleDelegate>

     @end

     @implementation TestCallMethodController

     - (void)viewDidLoad {
         [super viewDidLoad];
         // Do any additional setup after loading the view.
         self.view.backgroundColor = [UIColor whiteColor];
         
         // 第一步，通过类名找到实例对象
         id methodClass = [[NSClassFromString(@"TestMethodClass") alloc] init];
         // 第二步，设置返回值监听代理(看具体是否有代理监听的需求)
         [methodClass setValue:self forKey:@"delegate"];
         
         // 第三步，根据方法名找到要调用的方法
         SEL selector1 = NSSelectorFromString(@"testNoParameterMethod");
         SEL selector2 = NSSelectorFromString(@"testParameterMethod:parameter2:");
         SEL selector3 = NSSelectorFromString(@"testParameterMethodWithReturnValue:");
         SEL selector4 = NSSelectorFromString(@"testParameterMethodWithDelegate:");
         IMP imp1 = [methodClass methodForSelector:selector1];
         IMP imp2 = [methodClass methodForSelector:selector2];
         IMP imp3 = [methodClass methodForSelector:selector3];
         IMP imp4 = [methodClass methodForSelector:selector4];

         // 第四步,调用对应方法、传参、获取返回值
         void(*function1)(id, SEL) = (void *)imp1;
         void(*function2)(id, SEL, NSString *, NSInteger) = (void *)imp2;
         NSString *(*function3)(id, SEL, NSString *) = (void *)imp3;
         void(*function4)(id, SEL, NSString *) = (void *)imp4;
         function1(methodClass, selector1);
         function2(methodClass, selector2, @"99999", 88888);
         NSString *responseData = function3(methodClass, selector3, @"99999");
         function4(methodClass, selector4, @"99999");
         
         NSLog(@"return：%@", responseData);
     }

     - (void)CallMethodClassEventHandle:(NSString *)responseData {
         NSLog(@"代理：%@",responseData);
     }

     /*
     #pragma mark - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
         // Get the new view controller using [segue destinationViewController].
         // Pass the selected object to the new view controller.
     }
     */

     @end

     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
