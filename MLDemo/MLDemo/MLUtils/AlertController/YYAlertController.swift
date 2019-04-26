//
//  YYAlertController.swift
//  ShoppingMall
//
//  Created by raoml on 2019/3/22.
//  Copyright © 2019 yyhj. All rights reserved.
//

import UIKit
import SnapKit

class YYAlertController: YYBaseViewController {

    // 主视图
    private lazy var mContentView: UIView = { [unowned self] in
        let aView = UIView()
        aView.backgroundColor = UIColor.clear
        aView.addSubview(self.mStackView)
        return aView
    }()
    
    // 存放所有的子视图（除mContentView外），纵向排列
    private lazy var mStackView: UIStackView = { [unowned self] in
        let aStackView = UIStackView()
        aStackView.spacing = 0
        aStackView.axis = .vertical
        aStackView.alignment = .fill
        aStackView.addArrangedSubview(self.actionStackView)
        aStackView.addArrangedSubview(self.homeBarView)
        return aStackView
    }()
    
    // 存放Actions
    private lazy var actionStackView: UIStackView = { [unowned self] in
        let aStackView = UIStackView()
        aStackView.spacing = 0
        aStackView.distribution = .fillEqually
        aStackView.addSubview(self.verticalSeparateView)
        return aStackView
    }()
    
    // 用于适配HomeBar
    private lazy var homeBarView = UIView()
    
    // Actions之间的纵向分割线
    private lazy var verticalSeparateView: UIView = {
        let aView = UIView()
        aView.backgroundColor = kLineColor
        return aView
    }()
    
    // 标记是否监听键盘弹出收起
    private var responseKeyboard = false
    
    // 弹出样式
    private var style: UIAlertController.Style = .alert
    
    // 自定义View
    private var coustomView: UIView!
    
    // 当style == .actionSheet时，控制mContentView的位置
    private var mBottomConstaint: Constraint!
    
    /**
     便利构造器
     @param coustomView 自定义view
     @param responseKeyboard 是否监听键盘收缩（可保证不让键盘遮挡）
     */
    convenience init(coustomView: UIView, responseKeyboard: Bool = false, preferredStyle: UIAlertController.Style) {
        self.init()
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
        self.modalPresentationCapturesStatusBarAppearance = true
        
        self.style = preferredStyle
        self.responseKeyboard = responseKeyboard && preferredStyle == .alert
        self.coustomView = coustomView
        self.homeBarView.backgroundColor = coustomView.backgroundColor
        
        self.mStackView.insertArrangedSubview(coustomView, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 让verticalSeparateView显示在最上层
        self.actionStackView.bringSubviewToFront(self.verticalSeparateView)
        
        if self.style == .actionSheet {
            // 设配刘海屏
            if self.view.yy_safeInsets.top != 0 {
                self.mContentView.snp.updateConstraints { (make) in
                    make.height.lessThanOrEqualToSuperview().offset(-self.view.yy_safeInsets.top)
                }
            }
            
            // 适配HomeBar
            if self.view.yy_safeInsets.bottom != 0 {
                self.homeBarView.snp.updateConstraints { (make) in
                    make.height.equalTo(self.view.yy_safeInsets.bottom)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)

        // 隐藏自定义的导航栏
        self.yy_barCoustomView.isHidden = true
        
        self.setupUI()
        self.setSubviewsConstraints()
        
        
        // 监听键盘，保证不让键盘遮挡
        if self.responseKeyboard {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard self.style == .actionSheet else {
            super.touchesBegan(touches, with: event)
            if self.responseKeyboard {
                self.view.endEditing(true)
            }
            return
        }
        
        var tapPoint: CGPoint = (touches.first?.location(in: self.view))!
        tapPoint = self.mContentView.layer.convert(tapPoint, from: self.view.layer)
        if self.mContentView.layer.contains(tapPoint) == false {
            self.hidden(completion: nil)
        }
    }
    
    deinit {
        if self.responseKeyboard {
            NotificationCenter.default.removeObserver(self)
        }
    }

}

// MARK: - Public Meds
extension YYAlertController {
    
    public func addAction(action: YYAlertAction) {
        self.actionStackView.addArrangedSubview(action)
        
        // 当按钮数量为2时，横向排布，否则纵向排布
        if self.actionStackView.arrangedSubviews.count == 2 {
            self.actionStackView.axis = .horizontal
            self.verticalSeparateView.isHidden = false
        }else {
            self.actionStackView.axis = .vertical
            self.verticalSeparateView.isHidden = true
        }
        
        action.snp.makeConstraints { (make) in
            make.height.equalTo(44.0)
        }
        
        action.dissmisHandler = { [unowned self] (action) in
            self.hidden(completion: {
                action.actionHandler?(action)
            })
        }
    }
    
    /**
     显示
     @param viewController 父控制器，默认为keyWindow.rootViewController
     @param completion 显示动画完成回调
     */
    public func show(viewController: UIViewController? = nil, completion: ((_ finish: Bool) -> Void)? = nil) {
        guard self.presentingViewController == nil else {
            // 已经显示
            return
        }
        
        weak var aViewController: UIViewController?
        
        if let aCtr = viewController {
            aViewController = aCtr
        }else {
            aViewController = UIApplication.shared.keyWindow?.rootViewController
        }
        
        guard aViewController != nil else {
            return
        }
        
        self.view.alpha = 0.0
        if self.style == .alert {
            self.mContentView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            aViewController?.present(self, animated: false, completion: { [unowned self] in
                UIView.animate(withDuration: 0.15, animations: {
                    self.view.alpha = 1.0
                    self.mContentView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }, completion: completion)
            })
        }else {
            aViewController?.present(self, animated: false, completion: { [unowned self] in
                self.mBottomConstaint.activate()
                UIView.animate(withDuration: 0.1, animations: {
                    self.view.alpha = 1.0
                    self.view.layoutIfNeeded()
                }, completion: completion)
            })
        }
    }
    
    /**
     隐藏
     @param completion 隐藏回调
     */
    public func hidden(completion: (() -> Void)?) {
        
        if self.style == .alert {
            UIView.animate(withDuration: 0.15, animations: {
                self.view.alpha = 0.0
            }) { (finished) in
                self.dismiss(animated: false, completion: completion)
            }
        }else {
            self.mBottomConstaint.deactivate()
            UIView.animate(withDuration: 0.25, animations: {
                self.view.alpha = 0.0
                self.view.layoutIfNeeded()
            }) { (finished) in
                self.dismiss(animated: false, completion: completion)
            }
        }
        
    }
    
}

// MARK: - Private Meds
private extension YYAlertController {
    
    func setupUI() {
        self.view.addSubview(self.mContentView)
        
        if self.style == .alert {
            self.mContentView.layer.cornerRadius = 6.0
            self.mContentView.layer.masksToBounds = true
        }
    }
    
    func setSubviewsConstraints() {
        if self.style == .alert {
            self.mContentView.snp.makeConstraints { (make) in
                make.width.equalTo(self.coustomView)
                make.height.lessThanOrEqualToSuperview()
                make.center.equalToSuperview().priority(.medium)
                self.mBottomConstaint = make.bottom.equalTo(self.view.snp.top).constraint
            }
            self.mBottomConstaint.deactivate()
        }else {
            self.mContentView.snp.makeConstraints { (make) in
                make.top.equalTo(self.view.snp.bottom).priority(.low)
                make.width.equalTo(self.coustomView)
                make.height.lessThanOrEqualToSuperview()
                make.centerX.equalToSuperview()
                self.mBottomConstaint = make.bottom.equalToSuperview().constraint
            }
            self.mBottomConstaint.deactivate()
        }
        
        self.mStackView.snp.makeConstraints { (make) in
            make.top.width.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        self.homeBarView.snp.makeConstraints { (make) in
            make.width.equalTo(self.coustomView)
            make.height.equalTo(0.1)
        }
        
        self.verticalSeparateView.snp.makeConstraints { (make) in
            make.height.centerX.equalToSuperview()
            make.width.equalTo(1.0)
        }
    }
    
    @objc func keyboardWillShow(noti: NSNotification) {
        let keyboardFrame = (noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardDuration = (noti.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        self.mBottomConstaint.activate()
        self.mContentView.snp.updateConstraints { (make) in
            make.bottom.equalTo(self.view.snp.top).offset(keyboardFrame.origin.y - 10.0)
        }
        
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(noti: NSNotification) {
        self.mBottomConstaint.deactivate()
        
        let keyboardDuration = (noti.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
}


