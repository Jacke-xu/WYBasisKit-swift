//
//  WYTestVisualController.m
//  ObjCVerify
//
//  Created by guanren on 2026/1/8.
//

#import "WYTestVisualController.h"
#import <Masonry/Masonry.h>
#import <WYBasisKitObjC/WYBasisKitObjC.h>

typedef void(^WYVisualMakeBlock)(UIView *make);

@interface WYTestVisualController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *bigButton;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, assign) NSInteger applyCount;
@property (nonatomic, assign) NSInteger borderIndex;
@property (nonatomic, assign) BOOL edgeBorderRemoved;
@property (nonatomic, assign) BOOL isBigSize;
@property (nonatomic, assign) BOOL isOffset;
@property (nonatomic, assign) BOOL isRotated;
@property (nonatomic, assign) BOOL isScaled;
@property (nonatomic, assign) BOOL isNarrow;

@end

@implementation WYTestVisualController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"边框、圆角、阴影、渐变";

    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    UIStackView *contentStack = [[UIStackView alloc] init];
    contentStack.axis = UILayoutConstraintAxisVertical;
    contentStack.spacing = 16;
    [scrollView addSubview:contentStack];
    [contentStack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView).insets(UIEdgeInsetsMake(16, 16, 30, 16));
        make.width.equalTo(scrollView).offset(-32);
    }];

    [contentStack addArrangedSubview:[self makeHintLabel]];

    // 静态组合矩阵，两个一行，每项固定半列宽(防fillEqually把奇数行压扁导致固定路径的椭圆等视觉溢出越界)
    NSArray<NSDictionary *> *visualItems = [self visualItems];
    NSMutableArray<NSDictionary *> *rowItems = [NSMutableArray array];
    for (NSDictionary *item in visualItems) {
        [rowItems addObject:item];
        if (rowItems.count == 2) {
            [contentStack addArrangedSubview:[self makeRowWithItems:rowItems]];
            [rowItems removeAllObjects];
        }
    }
    if (rowItems.count > 0) {
        [contentStack addArrangedSubview:[self makeRowWithItems:rowItems]];
    }

    // viewBounds场景：控件还没布局(bounds为0)时先应用视觉，靠传入的固定bounds出效果
    UIView *viewBoundsDemoView = nil;
    UIView *viewBoundsContainer = [self makeDemoItemWithTitle:@"viewBounds(100x70)优先" demoView:&viewBoundsDemoView];
    [contentStack addArrangedSubview:[self makeRowWithItems:@[@{@"title": @"viewBounds"}] containers:@[viewBoundsContainer] demoViews:@[viewBoundsDemoView]]];
    viewBoundsDemoView.wy_cornerRadius(18).wy_borderWidth(4).wy_borderColor([UIColor systemGreenColor]).wy_gradualColors(@[[UIColor yellowColor], [UIColor purpleColor]]).wy_viewBounds(CGRectMake(0, 0, 100, 70)).wy_showVisual();

    [contentStack addArrangedSubview:[self makeDynamicArea]];
    [self applyBigButtonVisual];
    [self.bigButton wy_addBorder:UIRectEdgeAll color:[UIColor magentaColor] thickness:[self currentEdgeThickness]];
    [self refreshStatus];
}

/// 每个静态组合的标题和链式配置(标题显示在视觉区下方的外部标签上，不会被边框、圆角、阴影挡住)
- (NSArray<NSDictionary *> *)visualItems {
    return @[
        @{@"title": @"radius 10", @"make": ^(UIView *make) { make.wy_cornerRadius(10); }},
        @{@"title": @"radius 15 topRight", @"make": ^(UIView *make) { make.wy_cornerRadius(15).wy_rectCorner(UIRectCornerTopRight); }},
        @{@"title": @"border 5", @"make": ^(UIView *make) { make.wy_borderWidth(5).wy_borderColor([UIColor blackColor]); }},
        @{@"title": @"radius 10 + border 5", @"make": ^(UIView *make) { make.wy_cornerRadius(10).wy_borderWidth(5).wy_borderColor([UIColor blackColor]); }},
        @{@"title": @"radius 10 + border 20 (宽边框吃圆角场景)", @"make": ^(UIView *make) { make.wy_cornerRadius(10).wy_borderWidth(20).wy_borderColor([UIColor systemRedColor]); }},
        @{@"title": @"radius 30 + border 10 topLeft", @"make": ^(UIView *make) { make.wy_cornerRadius(30).wy_borderWidth(10).wy_rectCorner(UIRectCornerTopLeft).wy_borderColor([UIColor systemBlueColor]); }},
        @{@"title": @"渐变→", @"make": ^(UIView *make) { make.wy_gradualColors(@[[UIColor orangeColor], [UIColor redColor]]); }},
        @{@"title": @"渐变↓", @"make": ^(UIView *make) { make.wy_gradualColors(@[[UIColor orangeColor], [UIColor redColor]]).wy_gradientDirection(WYGradientDirectionTopToBottom); }},
        @{@"title": @"渐变↘", @"make": ^(UIView *make) { make.wy_gradualColors(@[[UIColor orangeColor], [UIColor redColor]]).wy_gradientDirection(WYGradientDirectionLeftToLowRight); }},
        @{@"title": @"渐变↙", @"make": ^(UIView *make) { make.wy_gradualColors(@[[UIColor orangeColor], [UIColor redColor]]).wy_gradientDirection(WYGradientDirectionRightToLowLeft); }},
        @{@"title": @"渐变 + radius 15", @"make": ^(UIView *make) { make.wy_gradualColors(@[[UIColor orangeColor], [UIColor redColor]]).wy_cornerRadius(15); }},
        @{@"title": @"渐变 + radius 15 + border 5", @"make": ^(UIView *make) { make.wy_gradualColors(@[[UIColor orangeColor], [UIColor redColor]]).wy_cornerRadius(15).wy_borderWidth(5).wy_borderColor([UIColor blackColor]); }},
        @{@"title": @"阴影(无路径)", @"make": ^(UIView *make) { make.wy_shadowColor([UIColor blackColor]).wy_shadowRadius(8).wy_shadowOpacity(0.6); }},
        @{@"title": @"阴影 + radius 15", @"make": ^(UIView *make) { make.wy_shadowColor([UIColor blackColor]).wy_shadowRadius(8).wy_shadowOpacity(0.6).wy_cornerRadius(15); }},
        @{@"title": @"阴影 + radius + border", @"make": ^(UIView *make) { make.wy_shadowColor([UIColor blackColor]).wy_shadowRadius(8).wy_shadowOpacity(0.6).wy_cornerRadius(15).wy_borderWidth(5).wy_borderColor([UIColor blackColor]); }},
        @{@"title": @"全叠加(渐变+圆角+边框+阴影)", @"make": ^(UIView *make) { make.wy_gradualColors(@[[UIColor orangeColor], [UIColor redColor]]).wy_cornerRadius(15).wy_borderWidth(5).wy_borderColor([UIColor blackColor]).wy_shadowColor([UIColor blackColor]).wy_shadowRadius(8).wy_shadowOpacity(0.6); }},
        @{@"title": @"椭圆路径 + border 5 + 阴影", @"make": ^(UIView *make) { make.wy_bezierPath([UIBezierPath bezierPathWithOvalInRect:CGRectMake(8, 5, 155, 100)]).wy_borderWidth(5).wy_borderColor([UIColor purpleColor]).wy_shadowColor([UIColor blackColor]).wy_shadowRadius(8).wy_shadowOpacity(0.6); }},
        @{@"title": @"指定位置边框 all 8", @"make": ^(UIView *make) { make.backgroundColor = [UIColor systemTealColor]; }},
    ];
}

/// 把一至两个演示项摆成一行并应用视觉(指定位置边框走单独API，viewBounds场景由调用方自行应用，其余走链式)
- (UIStackView *)makeRowWithItems:(NSArray<NSDictionary *> *)items {

    NSMutableArray<UIView *> *containers = [NSMutableArray array];
    NSMutableArray<UIView *> *demoViews = [NSMutableArray array];
    for (NSDictionary *item in items) {
        UIView *demoView = nil;
        [containers addObject:[self makeDemoItemWithTitle:item[@"title"] demoView:&demoView]];
        [demoViews addObject:demoView];
    }

    UIStackView *rowStack = [[UIStackView alloc] initWithArrangedSubviews:containers];
    rowStack.axis = UILayoutConstraintAxisHorizontal;
    rowStack.spacing = 16;
    for (UIView *container in containers) {
        CGFloat widthOffset = (containers.count > 1) ? -8 : 0;
        [container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(rowStack).multipliedBy(0.5).offset(widthOffset);
        }];
    }

    for (NSUInteger index = 0; index < items.count; index++) {
        NSDictionary *item = items[index];
        UIView *demoView = demoViews[index];
        NSString *title = item[@"title"];
        if ([title hasPrefix:@"指定位置"]) {
            [demoView wy_addBorder:UIRectEdgeAll color:[UIColor magentaColor] thickness:8];
        }else if ([title hasPrefix:@"viewBounds"] == NO) {
            WYVisualMakeBlock makeBlock = item[@"make"];
            [demoView wy_makeVisual:makeBlock];
        }
    }
    return rowStack;
}

/// 把已备好的容器摆成一行(viewBounds场景用，视觉由调用方自行应用)
- (UIStackView *)makeRowWithItems:(NSArray<NSDictionary *> *)items containers:(NSArray<UIView *> *)containers demoViews:(NSArray<UIView *> *)demoViews {
    UIStackView *rowStack = [[UIStackView alloc] initWithArrangedSubviews:containers];
    rowStack.axis = UILayoutConstraintAxisHorizontal;
    rowStack.spacing = 16;
    for (UIView *container in containers) {
        CGFloat widthOffset = (containers.count > 1) ? -8 : 0;
        [container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(rowStack).multipliedBy(0.5).offset(widthOffset);
        }];
    }
    return rowStack;
}

/// 顶部说明
- (UILabel *)makeHintLabel {
    UILabel *hintLabel = [[UILabel alloc] init];
    hintLabel.font = [UIFont systemFontOfSize:12];
    hintLabel.textColor = [UIColor darkGrayColor];
    hintLabel.numberOfLines = 0;
    hintLabel.text = @"静态矩阵看几何与组合：'radius 10 + border 20'可见圆角必须仍是10(不能被宽边框吃成直角)；全叠加里紫色边框在最上层、渐变在最底层。动态区：点大按钮只改约束不改视觉，圆角/边框/渐变/阴影应自动跟随新尺寸不变形；'重复应用'连点多次应无任何闪烁；位移/旋转/缩放/改宽同样要同步跟随；'直切尺寸'应一步到位不闪帧；'慢动画2秒'途中再点应无缝反向。";
    return hintLabel;
}

/// 造一个"视觉区+外部标签"的演示项，标签在视觉区下方不会被任何视觉挡住
- (UIView *)makeDemoItemWithTitle:(NSString *)title demoView:(UIView **)demoView {
    UIStackView *container = [[UIStackView alloc] init];
    container.axis = UILayoutConstraintAxisVertical;
    container.spacing = 4;

    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1.0];
    [container addArrangedSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@110);
    }];
    if (demoView != NULL) {
        *demoView = view;
    }

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:9];
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.numberOfLines = 2;
    [container addArrangedSubview:titleLabel];

    return container;
}

/// 动态验证区(重复应用/清除重建/同边替换/尺寸跟随/位移/旋转/缩放/改宽/直切/慢动画中断)
- (UIView *)makeDynamicArea {
    UIView *container = [[UIView alloc] init];

    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.font = [UIFont systemFontOfSize:11];
    statusLabel.textColor = [UIColor darkGrayColor];
    statusLabel.numberOfLines = 0;
    [container addSubview:statusLabel];
    self.statusLabel = statusLabel;
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.and.trailing.equalTo(container);
    }];

    UIButton *bigButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bigButton setTitle:@"约束控件(点击只改约束尺寸)" forState:UIControlStateNormal];
    [bigButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    bigButton.titleLabel.font = [UIFont systemFontOfSize:12];
    bigButton.titleLabel.numberOfLines = 0;
    [bigButton addTarget:self action:@selector(toggleSize) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:bigButton];
    self.bigButton = bigButton;
    [bigButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(statusLabel.mas_bottom).offset(12);
        // 约束用宽度+中心点定位(初始和leading/trailing等价)，后面位移、改宽都能用mas_updateConstraints只动常量
        make.width.and.centerX.equalTo(container);
        make.height.equalTo(@110);
    }];

    UIStackView *actionStack = [[UIStackView alloc] init];
    actionStack.backgroundColor = [UIColor clearColor];
    actionStack.axis = UILayoutConstraintAxisVertical;
    actionStack.spacing = 8;
    [container addSubview:actionStack];
    [actionStack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bigButton.mas_bottom).offset(12);
        make.leading.trailing.and.bottom.equalTo(container);
    }];

    // 两个一行摆动作按钮
    NSArray<NSString *> *actionTitles = @[@"重复应用视觉", @"清除后0.6秒重建", @"指定边框换厚度", @"移除指定边框", @"移动位置", @"旋转45度", @"缩放0.7", @"宽度减120", @"直切尺寸", @"慢动画2秒"];
    NSArray<NSString *> *actionSelectorNames = @[NSStringFromSelector(@selector(reapplyVisual)), NSStringFromSelector(@selector(clearAndReapply)), NSStringFromSelector(@selector(cycleEdgeBorder)), NSStringFromSelector(@selector(removeEdgeBorder)), NSStringFromSelector(@selector(togglePosition)), NSStringFromSelector(@selector(toggleRotation)), NSStringFromSelector(@selector(toggleScale)), NSStringFromSelector(@selector(toggleWidth)), NSStringFromSelector(@selector(snapSize)), NSStringFromSelector(@selector(slowToggleSize))];
    for (NSUInteger index = 0; index < actionTitles.count; index += 2) {
        UIStackView *rowStack = [[UIStackView alloc] init];
        rowStack.axis = UILayoutConstraintAxisHorizontal;
        rowStack.spacing = 8;
        rowStack.distribution = UIStackViewDistributionFillEqually;
        [actionStack addArrangedSubview:rowStack];

        for (NSUInteger subIndex = index; subIndex <= MIN(index + 1, actionTitles.count - 1); subIndex++) {
            UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
            [actionButton setTitle:actionTitles[subIndex] forState:UIControlStateNormal];
            actionButton.titleLabel.font = [UIFont systemFontOfSize:12];
            actionButton.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
            actionButton.layer.cornerRadius = 6;
            [actionButton addTarget:self action:NSSelectorFromString(actionSelectorNames[subIndex]) forControlEvents:UIControlEventTouchUpInside];
            [rowStack addArrangedSubview:actionButton];
            [actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@36);
            }];
        }
    }
    return container;
}

- (NSArray<NSNumber *> *)edgeThicknesses {
    return @[@6, @14];
}

- (CGFloat)currentEdgeThickness {
    return self.edgeThicknesses[self.borderIndex].floatValue;
}

/// 大按钮的完整链式视觉
- (void)applyBigButtonVisual {
    self.bigButton.wy_gradualColors(@[[UIColor orangeColor], [UIColor redColor]]).wy_gradientDirection(WYGradientDirectionTopToBottom).wy_cornerRadius(20).wy_borderWidth(8).wy_borderColor([UIColor purpleColor]).wy_rectCorner(UIRectCornerAllCorners).wy_shadowColor([UIColor blackColor]).wy_shadowRadius(10).wy_shadowOpacity(0.5).wy_showVisual();
}

- (void)refreshStatus {
    NSString *edgeText = self.edgeBorderRemoved ? @"已移除" : [NSString stringWithFormat:@"厚度%.0f", self.currentEdgeThickness];
    NSString *transformText = self.isRotated ? @"旋转45度" : (self.isScaled ? @"缩放0.7" : @"无形变");
    NSString *sizeText = [NSString stringWithFormat:@"%@x%@", self.isNarrow ? @"减宽" : @"全宽", self.isBigSize ? @"150" : @"110"];
    self.statusLabel.text = [NSString stringWithFormat:@"已应用%ld次 · 指定边框%@ · 当前尺寸%@ · %@ · %@", (long)self.applyCount, edgeText, sizeText, transformText, self.isOffset ? @"位移80" : @"未位移"];
}

- (void)toggleSize {
    self.isBigSize = !self.isBigSize;
    // 验证动画同步:动画上下文里改约束并强制布局，view本体和圆角、边框、渐变、阴影应以相同时长一起过渡
    [UIView animateWithDuration:0.25 animations:^{
        [self.bigButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.isBigSize ? 150 : 110));
        }];
        [self.view layoutIfNeeded];
    }];
    [self refreshStatus];
}

- (void)togglePosition {
    self.isOffset = !self.isOffset;
    // 验证位移同步:动画上下文里只改水平位置不改尺寸，渐变、边框、阴影背景视图应整体一起平移
    [UIView animateWithDuration:0.4 animations:^{
        [self.bigButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bigButton.superview).offset(self.isOffset ? 80 : 0);
        }];
        [self.view layoutIfNeeded];
    }];
    [self refreshStatus];
}

- (void)toggleRotation {
    self.isRotated = !self.isRotated;
    self.isScaled = NO;
    // 验证形变同步:transform旋转45度，圆角、边框、渐变是子图层天然跟着转，阴影背景视图靠库内部同步transform跟转
    [UIView animateWithDuration:0.4 animations:^{
        self.bigButton.transform = self.isRotated ? CGAffineTransformMakeRotation(M_PI / 4) : CGAffineTransformIdentity;
    }];
    [self refreshStatus];
}

- (void)toggleScale {
    self.isScaled = !self.isScaled;
    self.isRotated = NO;
    // 验证形变同步:transform整体缩放0.7，全部视觉图层应一起缩放不变形
    [UIView animateWithDuration:0.4 animations:^{
        self.bigButton.transform = self.isScaled ? CGAffineTransformMakeScale(0.7, 0.7) : CGAffineTransformIdentity;
    }];
    [self refreshStatus];
}

- (void)toggleWidth {
    self.isNarrow = !self.isNarrow;
    // 验证宽度跟随:动画上下文里只改宽度，左右边框、渐变、阴影路径应同时收缩不拉伸
    [UIView animateWithDuration:0.25 animations:^{
        [self.bigButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.bigButton.superview).offset(self.isNarrow ? -120 : 0);
        }];
        [self.view layoutIfNeeded];
    }];
    [self refreshStatus];
}

- (void)snapSize {
    // 验证无动画直切:不在动画上下文里改尺寸，视觉图层应一步到位且不闪帧
    self.isBigSize = !self.isBigSize;
    [self.bigButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.isBigSize ? 150 : 110));
    }];
    [self.view layoutIfNeeded];
    [self refreshStatus];
}

- (void)slowToggleSize {
    // 验证动画中断接力:2秒慢动画途中再点会反向，视觉图层应从当前屏显位置无缝接上不跳变
    self.isBigSize = !self.isBigSize;
    [UIView animateWithDuration:2.0 animations:^{
        [self.bigButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.isBigSize ? 150 : 110));
        }];
        [self.view layoutIfNeeded];
    }];
    [self refreshStatus];
}

- (void)reapplyVisual {
    [self applyBigButtonVisual];
    self.applyCount += 1;
    [self refreshStatus];
}

- (void)clearAndReapply {
    // 防取到block没调用:wy_clearVisual在OC桥接里是block属性，方括号消息只拿到block不会执行，必须带()调用，否则视觉永远清不掉(点了清除重建没反应)
    [self.bigButton wy_clearVisual]();
    [self.bigButton wy_removeBorder:UIRectEdgeAll];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self applyBigButtonVisual];
        self.edgeBorderRemoved = NO;
        [self.bigButton wy_addBorder:UIRectEdgeAll color:[UIColor magentaColor] thickness:self.currentEdgeThickness];
        self.applyCount += 1;
        [self refreshStatus];
    });
}

- (void)cycleEdgeBorder {
    self.borderIndex = (self.borderIndex + 1) % self.edgeThicknesses.count;
    self.edgeBorderRemoved = NO;
    [self.bigButton wy_addBorder:UIRectEdgeAll color:[UIColor magentaColor] thickness:self.currentEdgeThickness];
    [self refreshStatus];
}

- (void)removeEdgeBorder {
    self.edgeBorderRemoved = YES;
    [self.bigButton wy_removeBorder:UIRectEdgeAll];
    [self refreshStatus];
}

- (void)dealloc {
    wy_print(@"WYTestVisualController release");
}

@end
