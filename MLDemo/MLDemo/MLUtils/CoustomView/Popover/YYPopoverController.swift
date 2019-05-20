//
//  YYPopoverController.swift
//  MLDemo
//
//  Created by raoml on 2019/5/9.
//  Copyright © 2019 raoml. All rights reserved.
//

import UIKit

enum PopoverDirection {
    case up
    case down
    case left
    case right
    // 横向自动
    case autoHorizontal
    // 纵向自动
    case autoVertical
}


private let kArrowSize = CGSize(width: 16.0, height: 12.0)
private let kSpace: CGFloat = 5.0

class YYPopoverController: YYBaseViewController {
    
    private lazy var mContentView: UIView = {
        let aView = UIView()
        aView.backgroundColor = UIColor.clear
        return aView
    }()
    private var coustomView: UIView!
    private var direction: PopoverDirection = .autoVertical
    weak private var showInViewController: UIViewController!
    weak private var fromView: UIView!
    public var convertFrame: CGRect!
    
    override func loadView() {
        super.loadView()
        self.view = PCView(frame: UIScreen.main.bounds)
    }
    
    init(coustomView: UIView, direction: PopoverDirection, showInViewController: UIViewController, fromView: UIView) {
        super.init()
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
        self.modalPresentationCapturesStatusBarAppearance = true
        
        self.coustomView = coustomView
        self.direction = direction
        self.showInViewController = showInViewController
        self.fromView = fromView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 坐标转换
        self.convertFrame = self.view.convert(self.fromView.bounds, from: self.fromView)
        
        // 根据确定具体的显示方向
        switch self.direction {
            case .autoHorizontal:
                if self.convertFrame.midX > self.view.bounds.midX {
                    self.direction = .left
                }else {
                    self.direction = .right
                }
            case .autoVertical:
                if self.convertFrame.midY > self.view.bounds.midY {
                    self.direction = .up
                }else {
                    self.direction = .down
                }
            default:
                break
        }
        
        self.setupUI()
        self.setSubviewsConstraints()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var tapPoint: CGPoint = (touches.first?.location(in: self.view))!
        tapPoint = self.mContentView.layer.convert(tapPoint, from: self.view.layer)
        if self.mContentView.layer.contains(tapPoint) == false {
            self.hidden(completion: nil)
        }
    }

}

// MARK: - Private Meds
private extension YYPopoverController {
    
    func setupUI() {
        // 设置背景颜色
        self.view.alpha = 0.0
        self.view.backgroundColor = UIColor.clear
        // 设置direction、convertFrame
        (self.view as! PCView).direction = self.direction
        (self.view as! PCView).convertFrame = self.convertFrame
        (self.view as! PCView).arrowColor = self.coustomView.backgroundColor
        
        // 隐藏自定义的导航栏
        self.yy_barCoustomView.isHidden = true
        
        self.mContentView.addSubview(self.coustomView)
        self.view.addSubview(self.mContentView)
    }
    
    func setSubviewsConstraints() {
        self.coustomView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.size.lessThanOrEqualTo(self.view).priority(.required)
        }
        
        switch self.direction {
            case .up:
                self.mContentView.snp.makeConstraints { (make) in
                    make.left.greaterThanOrEqualToSuperview().priority(.high)
                    make.right.lessThanOrEqualToSuperview().priority(.high)
                    make.centerX.equalTo(self.convertFrame.midX).priority(.low)
                    make.top.greaterThanOrEqualToSuperview()
                    make.bottom.equalTo(self.view.snp.top).offset(self.convertFrame.minY - kSpace - kArrowSize.height)
                }
            case .down:
                self.mContentView.snp.makeConstraints { (make) in
                    make.left.greaterThanOrEqualToSuperview().priority(.high)
                    make.right.lessThanOrEqualToSuperview().priority(.high)
                    make.centerX.equalTo(self.convertFrame.midX).priority(.low)
                    make.top.equalToSuperview().offset(self.convertFrame.maxY + kSpace + kArrowSize.height)
                    make.bottom.lessThanOrEqualToSuperview()
                }
            case .left:
                self.mContentView.snp.makeConstraints { (make) in
                    make.top.greaterThanOrEqualToSuperview().priority(.high)
                    make.bottom.lessThanOrEqualToSuperview().priority(.high)
                    make.centerY.equalTo(self.convertFrame.midY).priority(.low)
                    make.left.greaterThanOrEqualToSuperview()
                    make.right.equalTo(self.view.snp.left).offset(self.convertFrame.minX - kSpace - kArrowSize.height)
                }
            case .right:
                self.mContentView.snp.makeConstraints { (make) in
                    make.top.greaterThanOrEqualToSuperview().priority(.high)
                    make.bottom.lessThanOrEqualToSuperview().priority(.high)
                    make.centerY.equalTo(self.convertFrame.midY).priority(.low)
                    make.left.equalToSuperview().offset(self.convertFrame.maxX + kSpace + kArrowSize.height)
                    make.right.lessThanOrEqualToSuperview()
                }
            default:
                break
        }
    }
    
    /// 显示动画
    private func showAnimation() {
        // 动画时长
        let animationDuration: TimeInterval = 0.05
        // 缩放比列
        let transScale: (x: CGFloat, y: CGFloat) = (0.5, 0.5)
        // 初始Transform
        var startTransform: CGAffineTransform!
        
        switch self.direction {
            case .up:
            startTransform = CGAffineTransform(scaleX: transScale.x, y: transScale.y).concatenating(CGAffineTransform(translationX: 0, y: 0.5*transScale.y*self.mContentView.bounds.height))
            case .down:
                startTransform = CGAffineTransform(scaleX: transScale.x, y: transScale.y).concatenating(CGAffineTransform(translationX: 0, y: -0.5*transScale.y*self.mContentView.bounds.height))
            case .left:
                startTransform = CGAffineTransform(scaleX: transScale.x, y: transScale.y).concatenating(CGAffineTransform(translationX: 0.5*transScale.x*self.mContentView.bounds.width, y: 0))
            case .right:
                startTransform = CGAffineTransform(scaleX: transScale.x, y: transScale.y).concatenating(CGAffineTransform(translationX: -0.5*transScale.x*self.mContentView.bounds.width, y: 0))
            default:
                return
            }
        
        self.mContentView.transform = startTransform
        UIView.animate(withDuration: animationDuration, animations: {
            self.view.alpha = 1.0
            self.mContentView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).concatenating(CGAffineTransform(translationX: 0.0, y: 0.0))
        })
    }
    
    private func hiddenAnimation(completion: ((_ finish: Bool) -> Void)?) {
        // 动画时长
        let animationDuration: TimeInterval = 0.15
        // 缩放比列
        let transScale: (x: CGFloat, y: CGFloat) = (0.5, 0.5)
        // 初始Transform
        var endTransform: CGAffineTransform!
        
        switch self.direction {
        case .up:
            endTransform = CGAffineTransform(scaleX: transScale.x, y: transScale.y).concatenating(CGAffineTransform(translationX: 0, y: 0.5*transScale.y*self.mContentView.bounds.height))
        case .down:
            endTransform = CGAffineTransform(scaleX: transScale.x, y: transScale.y).concatenating(CGAffineTransform(translationX: 0, y: -0.5*transScale.y*self.mContentView.bounds.height))
        case .left:
            endTransform = CGAffineTransform(scaleX: transScale.x, y: transScale.y).concatenating(CGAffineTransform(translationX: 0.5*transScale.x*self.mContentView.bounds.width, y: 0))
        case .right:
            endTransform = CGAffineTransform(scaleX: transScale.x, y: transScale.y).concatenating(CGAffineTransform(translationX: -0.5*transScale.x*self.mContentView.bounds.width, y: 0))
        default:
            return
        }
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.view.alpha = 0.0
            self.mContentView.transform = endTransform
        }, completion: completion)
    }
    
}

// MARK: - Public Meds
extension YYPopoverController {
    
    /**
     显示
     @param completion 显示动画完成回调
     */
    public func show(completion: (() -> Void)? = nil) {
        self.showInViewController.present(self, animated: false) {
            completion?()
            self.showAnimation()
        }
    }
    
    /**
     隐藏
     @param completion 隐藏回调
     */
    public func hidden(completion: (() -> Void)?) {
        self.hiddenAnimation { (_) in
            self.dismiss(animated: false, completion: completion)
        }
    }
    
}

class PCView: UIView {
    
    public var direction: PopoverDirection = .autoVertical
    public var convertFrame: CGRect = .zero
    public var arrowColor: UIColor?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let arrowBezier = UIBezierPath()
        switch self.direction {
        case .up:
            arrowBezier.move(to: CGPoint(x: self.convertFrame.midX - kArrowSize.width/2.0, y: self.convertFrame.minY - kSpace - kArrowSize.height))
            arrowBezier.addLine(to: CGPoint(x: self.convertFrame.midX, y: self.convertFrame.minY - kSpace))
            arrowBezier.addLine(to: CGPoint(x: self.convertFrame.midX + kArrowSize.width/2.0, y: self.convertFrame.minY - kSpace - kArrowSize.height))
        case .down:
            arrowBezier.move(to: CGPoint(x: self.convertFrame.midX - kArrowSize.width/2.0, y: self.convertFrame.maxY + kSpace + kArrowSize.height))
            arrowBezier.addLine(to: CGPoint(x: self.convertFrame.midX, y: self.convertFrame.maxY + kSpace))
            arrowBezier.addLine(to: CGPoint(x: self.convertFrame.midX + kArrowSize.width/2.0 , y: self.convertFrame.maxY + kSpace + kArrowSize.height))
        case .left:
            arrowBezier.move(to: CGPoint(x: self.convertFrame.minX - kSpace - kArrowSize.height, y: self.convertFrame.midY - kArrowSize.width/2.0))
            arrowBezier.addLine(to: CGPoint(x: self.convertFrame.minX - kSpace, y: self.convertFrame.midY))
            arrowBezier.addLine(to: CGPoint(x: self.convertFrame.minX - kSpace - kArrowSize.height, y: self.convertFrame.midY + kArrowSize.width/2.0))
        case .right:
            arrowBezier.move(to: CGPoint(x: self.convertFrame.maxX + kSpace + kArrowSize.height, y: self.convertFrame.midY - kArrowSize.width/2.0))
            arrowBezier.addLine(to: CGPoint(x: self.convertFrame.maxX + kSpace, y: self.convertFrame.midY))
            arrowBezier.addLine(to: CGPoint(x: self.convertFrame.maxX + kSpace + kArrowSize.height, y: self.convertFrame.midY + kArrowSize.width/2.0))
        default:
            break
        }
        (arrowColor ?? UIColor.white).setFill()
        arrowBezier.fill()
    }
    
}
