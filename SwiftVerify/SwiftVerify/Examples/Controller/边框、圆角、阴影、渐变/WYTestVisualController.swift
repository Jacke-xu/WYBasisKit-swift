//
//  WYTestVisualController.swift
//  WYBasisKit
//
//  Created by 官人 on 2020/12/12.
//  Copyright © 2020 官人. All rights reserved.
//

import UIKit
import SnapKit

class WYTestVisualController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    /// 每个静态组合的标题和链式配置(标题显示在视觉区下方的外部标签上，不会被边框、圆角、阴影挡住)
    private let visualItems: [(title: String, make: (UIView) -> Void)] = [
        ("radius 10", { $0.wy_cornerRadius(10) }),
        ("radius 15 topRight", { $0.wy_cornerRadius(15).wy_rectCorner([.topRight]) }),
        ("border 5", { $0.wy_borderWidth(5).wy_borderColor(.black) }),
        ("radius 10 + border 5", { $0.wy_cornerRadius(10).wy_borderWidth(5).wy_borderColor(.black) }),
        ("radius 10 + border 20 (宽边框吃圆角场景)", { $0.wy_cornerRadius(10).wy_borderWidth(20).wy_borderColor(.systemRed) }),
        ("radius 30 + border 10 topLeft", { $0.wy_cornerRadius(30).wy_borderWidth(10).wy_rectCorner([.topLeft]).wy_borderColor(.systemBlue) }),
        ("渐变→", { $0.wy_gradualColors([.orange, .red]) }),
        ("渐变↓", { $0.wy_gradualColors([.orange, .red]).wy_gradientDirection(.topToBottom) }),
        ("渐变↘", { $0.wy_gradualColors([.orange, .red]).wy_gradientDirection(.leftToLowRight) }),
        ("渐变↙", { $0.wy_gradualColors([.orange, .red]).wy_gradientDirection(.rightToLowLeft) }),
        ("渐变 + radius 15", { $0.wy_gradualColors([.orange, .red]).wy_cornerRadius(15) }),
        ("渐变 + radius 15 + border 5", { $0.wy_gradualColors([.orange, .red]).wy_cornerRadius(15).wy_borderWidth(5).wy_borderColor(.black) }),
        ("阴影(无路径)", { $0.wy_shadowColor(.black).wy_shadowRadius(8).wy_shadowOpacity(0.6) }),
        ("阴影 + radius 15", { $0.wy_shadowColor(.black).wy_shadowRadius(8).wy_shadowOpacity(0.6).wy_cornerRadius(15) }),
        ("阴影 + radius + border", { $0.wy_shadowColor(.black).wy_shadowRadius(8).wy_shadowOpacity(0.6).wy_cornerRadius(15).wy_borderWidth(5).wy_borderColor(.black) }),
        ("全叠加(渐变+圆角+边框+阴影)", { $0.wy_gradualColors([.orange, .red]).wy_cornerRadius(15).wy_borderWidth(5).wy_borderColor(.black).wy_shadowColor(.black).wy_shadowRadius(8).wy_shadowOpacity(0.6) }),
        ("椭圆路径 + border 5 + 阴影", { $0.wy_bezierPath(UIBezierPath(ovalIn: CGRect(x: 8, y: 5, width: 155, height: 100))).wy_borderWidth(5).wy_borderColor(.purple).wy_shadowColor(.black).wy_shadowRadius(8).wy_shadowOpacity(0.6) }),
        ("指定位置边框 all 8", { $0.backgroundColor = UIColor.systemTeal }),
    ]

    private let scrollView = UIScrollView()
    private let bigButton = UIButton(type: .custom)
    private let statusLabel = UILabel()
    private var applyCount: Int = 0
    private var borderIndex: Int = 0
    private var edgeBorderRemoved: Bool = false
    private var isBigSize: Bool = false
    private var isOffset: Bool = false
    private var isRotated: Bool = false
    private var isScaled: Bool = false
    private var isNarrow: Bool = false
    private let edgeThicknesses: [CGFloat] = [6, 14]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "边框、圆角、阴影、渐变"

        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 16
        scrollView.addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 16, left: 16, bottom: 30, right: 16))
            make.width.equalTo(scrollView).offset(-32)
        }

        contentStack.addArrangedSubview(makeHintLabel())

        // 静态组合矩阵，两个一行，每项固定半列宽(防fillEqually把奇数行压扁导致固定路径的椭圆等视觉溢出越界)
        var rowItems: [(container: UIView, demoView: UIView, item: (title: String, make: (UIView) -> Void))] = []
        for item in visualItems {
            let demoItem = makeDemoItem(title: item.title)
            rowItems.append((container: demoItem.container, demoView: demoItem.demoView, item: item))
            if rowItems.count == 2 {
                contentStack.addArrangedSubview(makeRow(rowItems))
                rowItems = []
            }
        }
        if rowItems.isEmpty == false {
            contentStack.addArrangedSubview(makeRow(rowItems))
        }

        // viewBounds场景：控件还没布局(bounds为0)时先应用视觉，靠传入的固定bounds出效果
        let viewBoundsItem = makeDemoItem(title: "viewBounds(100x70)优先")
        contentStack.addArrangedSubview(makeRow([(container: viewBoundsItem.container, demoView: viewBoundsItem.demoView, item: (title: "viewBounds", make: { _ in }))]))
        viewBoundsItem.demoView.wy_cornerRadius(18).wy_borderWidth(4).wy_borderColor(.systemGreen).wy_gradualColors([.yellow, .purple]).wy_viewBounds(CGRect(x: 0, y: 0, width: 100, height: 70)).wy_showVisual()

        contentStack.addArrangedSubview(makeDynamicArea())
        applyBigButtonVisual()
        bigButton.wy_addBorder(edges: .all, color: .magenta, thickness: edgeThicknesses[borderIndex])
        refreshStatus()
    }

    /// 把一至两个演示项摆成一行，每项显式半列宽
    private func makeRow(_ items: [(container: UIView, demoView: UIView, item: (title: String, make: (UIView) -> Void))]) -> UIStackView {
        let rowStack = UIStackView(arrangedSubviews: items.map { $0.container })
        rowStack.axis = .horizontal
        rowStack.spacing = 16
        for current in items {
            current.container.snp.makeConstraints { make in
                make.width.equalTo(rowStack).multipliedBy(0.5).offset(items.count > 1 ? -8 : 0)
            }

            // 指定位置边框走单独API，viewBounds场景由调用方自行应用，其余走链式
            if current.item.title.hasPrefix("指定位置") {
                current.demoView.wy_addBorder(edges: .all, color: .magenta, thickness: 8)
            }else if current.item.title.hasPrefix("viewBounds") == false {
                current.demoView.wy_makeVisual(current.item.make)
            }
        }
        return rowStack
    }

    /// 顶部说明
    private func makeHintLabel() -> UILabel {
        let hintLabel = UILabel()
        hintLabel.font = .systemFont(ofSize: 12)
        hintLabel.textColor = .darkGray
        hintLabel.numberOfLines = 0
        hintLabel.text = "静态矩阵看几何与组合：'radius 10 + border 20'可见圆角必须仍是10(不能被宽边框吃成直角)；全叠加里紫色边框在最上层、渐变在最底层。动态区：点大按钮只改约束不改视觉，圆角/边框/渐变/阴影应自动跟随新尺寸不变形；'重复应用'连点多次应无任何闪烁；位移/旋转/缩放/改宽同样要同步跟随；'直切尺寸'应一步到位不闪帧；'慢动画2秒'途中再点应无缝反向。"
        return hintLabel
    }

    /// 造一个"视觉区+外部标签"的演示项，标签在视觉区下方不会被任何视觉挡住
    private func makeDemoItem(title: String) -> (container: UIView, demoView: UIView) {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 4

        let demoView = UIView()
        demoView.backgroundColor = UIColor(white: 0.92, alpha: 1.0)
        demoView.snp.makeConstraints { make in
            make.height.equalTo(110)
        }
        container.addArrangedSubview(demoView)

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 9)
        titleLabel.textColor = .darkGray
        titleLabel.numberOfLines = 2
        container.addArrangedSubview(titleLabel)

        return (container, demoView)
    }

    /// 动态验证区(重复应用/清除重建/同边替换/尺寸跟随/位移/旋转/缩放/改宽/直切/慢动画中断)
    private func makeDynamicArea() -> UIView {
        let container = UIView()

        statusLabel.font = .systemFont(ofSize: 11)
        statusLabel.textColor = .darkGray
        statusLabel.numberOfLines = 0
        container.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }

        bigButton.setTitle("约束控件(点击只改约束尺寸)", for: .normal)
        bigButton.setTitleColor(.black, for: .normal)
        bigButton.titleLabel?.font = .systemFont(ofSize: 12)
        bigButton.titleLabel?.numberOfLines = 0
        bigButton.addTarget(self, action: #selector(toggleSize), for: .touchUpInside)
        container.addSubview(bigButton)
        bigButton.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(12)
            // 约束用宽度+中心点定位(初始和leading/trailing等价)，后面位移、改宽都能用updateConstraints只动常量
            make.width.centerX.equalToSuperview()
            make.height.equalTo(110)
        }

        let actionTitles = ["重复应用视觉", "清除后0.6秒重建", "指定边框换厚度", "移除指定边框", "移动位置", "旋转45度", "缩放0.7", "宽度减120", "直切尺寸", "慢动画2秒"]
        let actionSelectors = [#selector(reapplyVisual), #selector(clearAndReapply), #selector(cycleEdgeBorder), #selector(removeEdgeBorder), #selector(togglePosition), #selector(toggleRotation), #selector(toggleScale), #selector(toggleWidth), #selector(snapSize), #selector(slowToggleSize)]
        let actionStack = UIStackView()
        actionStack.backgroundColor = .clear
        actionStack.axis = .vertical
        actionStack.spacing = 8
        container.addSubview(actionStack)
        actionStack.snp.makeConstraints { make in
            make.top.equalTo(bigButton.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview()
        }

        // 两个一行摆动作按钮
        for index in stride(from: 0, to: actionTitles.count, by: 2) {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 8
            rowStack.distribution = .fillEqually
            actionStack.addArrangedSubview(rowStack)

            for subIndex in index...min(index + 1, actionTitles.count - 1) {
                let actionButton = UIButton(type: .system)
                actionButton.setTitle(actionTitles[subIndex], for: .normal)
                actionButton.titleLabel?.font = .systemFont(ofSize: 12)
                actionButton.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
                actionButton.layer.cornerRadius = 6
                actionButton.addTarget(self, action: actionSelectors[subIndex], for: .touchUpInside)
                rowStack.addArrangedSubview(actionButton)
                actionButton.snp.makeConstraints { make in
                    make.height.equalTo(36)
                }
            }
        }
        return container
    }

    /// 大按钮的完整链式视觉
    private func applyBigButtonVisual() {
        bigButton.wy_gradualColors([.orange, .red]).wy_gradientDirection(.topToBottom).wy_cornerRadius(20).wy_borderWidth(8).wy_borderColor(.purple).wy_rectCorner(.allCorners).wy_shadowColor(.black).wy_shadowRadius(10).wy_shadowOpacity(0.5).wy_showVisual()
    }

    private func refreshStatus() {
        let edgeText = edgeBorderRemoved ? "已移除" : "厚度\(Int(edgeThicknesses[borderIndex]))"
        let transformText = isRotated ? "旋转45度" : (isScaled ? "缩放0.7" : "无形变")
        statusLabel.text = "已应用\(applyCount)次 · 指定边框\(edgeText) · 当前尺寸\(isNarrow ? "减宽" : "全宽")x\(isBigSize ? 150 : 110) · \(transformText) · \(isOffset ? "位移80" : "未位移")"
    }

    @objc private func toggleSize() {
        isBigSize = !isBigSize
        // 验证动画同步:动画上下文里改约束并强制布局，view本体和圆角、边框、渐变、阴影应以相同时长一起过渡
        UIView.animate(withDuration: 0.25) {
            self.bigButton.snp.updateConstraints { make in
                make.height.equalTo(self.isBigSize ? 150 : 110)
            }
            self.view.layoutIfNeeded()
        }
        refreshStatus()
    }

    @objc private func togglePosition() {
        isOffset = !isOffset
        // 验证位移同步:动画上下文里只改水平位置不改尺寸，渐变、边框、阴影背景视图应整体一起平移
        UIView.animate(withDuration: 0.4) {
            self.bigButton.snp.updateConstraints { make in
                make.centerX.equalToSuperview().offset(self.isOffset ? 80 : 0)
            }
            self.view.layoutIfNeeded()
        }
        refreshStatus()
    }

    @objc private func toggleRotation() {
        isRotated = !isRotated
        isScaled = false
        // 验证形变同步:transform旋转45度，圆角、边框、渐变是子图层天然跟着转，阴影背景视图靠库内部同步transform跟转
        UIView.animate(withDuration: 0.4) {
            self.bigButton.transform = self.isRotated ? CGAffineTransform(rotationAngle: .pi / 4) : .identity
        }
        refreshStatus()
    }

    @objc private func toggleScale() {
        isScaled = !isScaled
        isRotated = false
        // 验证形变同步:transform整体缩放0.7，全部视觉图层应一起缩放不变形
        UIView.animate(withDuration: 0.4) {
            self.bigButton.transform = self.isScaled ? CGAffineTransform(scaleX: 0.7, y: 0.7) : .identity
        }
        refreshStatus()
    }

    @objc private func toggleWidth() {
        isNarrow = !isNarrow
        // 验证宽度跟随:动画上下文里只改宽度，左右边框、渐变、阴影路径应同时收缩不拉伸
        UIView.animate(withDuration: 0.25) {
            self.bigButton.snp.updateConstraints { make in
                make.width.equalToSuperview().offset(self.isNarrow ? -120 : 0)
            }
            self.view.layoutIfNeeded()
        }
        refreshStatus()
    }

    @objc private func snapSize() {
        // 验证无动画直切:不在动画上下文里改尺寸，视觉图层应一步到位且不闪帧
        isBigSize = !isBigSize
        bigButton.snp.updateConstraints { make in
            make.height.equalTo(isBigSize ? 150 : 110)
        }
        view.layoutIfNeeded()
        refreshStatus()
    }

    @objc private func slowToggleSize() {
        // 验证动画中断接力:2秒慢动画途中再点会反向，视觉图层应从当前屏显位置无缝接上不跳变
        isBigSize = !isBigSize
        UIView.animate(withDuration: 2.0) {
            self.bigButton.snp.updateConstraints { make in
                make.height.equalTo(self.isBigSize ? 150 : 110)
            }
            self.view.layoutIfNeeded()
        }
        refreshStatus()
    }

    @objc private func reapplyVisual() {
        applyBigButtonVisual()
        applyCount += 1
        refreshStatus()
    }

    @objc private func clearAndReapply() {
        bigButton.wy_clearVisual()
        bigButton.wy_removeBorder(edges: .all)
        Task {
            try? await Task.wy_delay(0.6, cancelThrows: false, onMain: { [weak self] in
                guard let self = self else { return }
                self.applyBigButtonVisual()
                self.edgeBorderRemoved = false
                self.bigButton.wy_addBorder(edges: .all, color: .magenta, thickness: self.edgeThicknesses[self.borderIndex])
                self.applyCount += 1
                self.refreshStatus()
            })
        }
    }

    @objc private func cycleEdgeBorder() {
        borderIndex = (borderIndex + 1) % edgeThicknesses.count
        edgeBorderRemoved = false
        bigButton.wy_addBorder(edges: .all, color: .magenta, thickness: edgeThicknesses[borderIndex])
        refreshStatus()
    }

    @objc private func removeEdgeBorder() {
        edgeBorderRemoved = true
        bigButton.wy_removeBorder(edges: .all)
        refreshStatus()
    }
}
