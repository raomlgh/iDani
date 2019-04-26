//
//  YYCoustomBarView.swift
//  MLDemo
//
//  Created by raoml on 2019/4/24.
//  Copyright © 2019 raoml. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

public typealias YYNavigationBarChangedCallback = (_ alpha: CGFloat, _ barHeight: CGFloat) -> Void

public class YYCoustomBarView: YYHitFilterView {
    
    // 初始高度，始终不小于minHeight
    private var originHeight: CGFloat = 0.0 {
        didSet {
            // 初始高度不能小于最小高度
            originHeight = CGFloat(fmaxf(Float(originHeight), Float(minHeight)))
        }
    }
    
    // 最小高度
    private var minHeight: CGFloat = 0.0 {
        didSet {
            // 初始高度不能小于最小高度
            originHeight = CGFloat(fmaxf(Float(originHeight), Float(minHeight)))
        }
    }
    
    // 用于回收序列观察者
    private lazy var disposeBag = DisposeBag()
    
    // 所在的控制器
    weak private var viewController: UIViewController?
    
    // 用于设置颜图片,大小始终等于self
    private lazy var mBackgroundImgView: UIImageView = {
        let aImgView = UIImageView()
        aImgView.backgroundColor = UIColor.clear
        aImgView.contentMode = .scaleAspectFill
        return aImgView
    }()
    
    // 毛玻璃
    private lazy var blurView: UIVisualEffectView = {
        let aEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        aEffectView.isUserInteractionEnabled = false
        aEffectView.alpha = 0.5
        return aEffectView
    }()
    
    // 用于添加外部视图
    private lazy var mContentView: YYHitFilterView = {
        let aView = YYHitFilterView()
        aView.backgroundColor = UIColor.clear
        aView.clipsToBounds = true
        return aView
    }()
    
    // 用于设置颜色，图片，大小始终等于minHeight
    private lazy var mBarView = CBBarView()
    
    // 底部分割线
    private lazy var separateLineView: UIView = {
        let aView = UIView()
        aView.backgroundColor = kPageColor
        aView.isUserInteractionEnabled = false
        return aView
    }()
    
    /**
     初始化
     @param viewController 控制器
     @param originHeight 初始化高度
     @param minHeight 最小高度
     */
    init(viewController: UIViewController, originHeight: CGFloat, minHeight: CGFloat) {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.clear
        self.clipsToBounds = true
        self.alpha = 0.98
        
        self.viewController = viewController
        
        self.addSubview(self.mBackgroundImgView)
        self.addSubview(self.blurView)
        self.addSubview(self.mBarView)
        self.addSubview(self.mContentView)
        self.addSubview(self.separateLineView)
        
        self.setBarHeight(originHeight, minHeight)
        
        self.mBackgroundImgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.blurView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.mBarView.snp.makeConstraints { (make) in
            make.top.width.centerX.equalToSuperview()
            make.height.equalTo(minHeight)
        }
        
        self.mContentView.snp.makeConstraints { (make) in
            make.top.equalTo(self.mBarView.snp.bottom)
            make.width.centerX.bottom.equalToSuperview().priority(.high)
        }
        
        self.separateLineView.snp.makeConstraints { (make) in
            make.width.centerX.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.bringSubviewToFront(self.mBarView)
        self.bringSubviewToFront(self.separateLineView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Private Meds
private extension YYCoustomBarView {
    
    // 更新高度
    private func updateBarHeight(_ height: CGFloat) {
        let finalHeight = CGFloat(fmaxf(Float(height), Float(self.minHeight)))        
        self.snp.updateConstraints { (make) in
            make.height.equalTo(finalHeight).priority(.required)
        }
    }
    
}

// MARK: - Public Meds
public extension YYCoustomBarView {
    
    /// 设置最小高度
    public func setBarHeight(_ originHeight: CGFloat?, _ minHeight: CGFloat?) {
        guard originHeight != nil || minHeight != nil else {
            return
        }
        
        if let originHeight = originHeight {
            self.originHeight = originHeight
        }
        
        if let minHeight = minHeight {
            self.minHeight = minHeight
            self.mBarView.snp.updateConstraints { (make) in
                make.height.equalTo(minHeight)
            }
        }
        
        self.updateBarHeight(originHeight ?? self.originHeight)
    }
    
    /**
     添加子视图
     */
    public func setContentSubview(_ view: YYHitFilterView,  _ closure: (_ make: ConstraintMaker) -> Void) {
        self.mContentView.addSubview(view)
        view.snp.makeConstraints(closure)
    }
    
    /// 设置分割线的显隐
    public func setSeparateLineViewHidden(_ hidden: Bool) {
        self.separateLineView.isHidden = hidden
    }
    
    /**
     设置导航栏的颜色和图片
     @param color 导航栏颜色
     @param image 导航栏图片
     */
    public func setNavigationBar(color: UIColor? = kNavBarClolor, image: UIImage? = nil) {
        self.mBarView.backgroundColor = color
        self.mBarView.setImage(image)
    }
    
    /**
     设置背景图片
     @param image 背景图片
     @param imageUrl 网络图片
     */
    public func setNavigationBarBackgroundImage(_ image: UIImage?, imageUrl: URL?) {
        self.mBackgroundImgView.image = image
        if let imageUrl = imageUrl {
            self.mBackgroundImgView.kf.setImage(with: imageUrl)
        }
    }
    
    /**
     设置弹簧效果&渐变透明度
     注：所有效果将根据bindScrollView的contentOffset
     @param bounceEnable 弹簧效果开关
     @param changeAlphaEnable 渐变透明度开关
     @param originOffset bindScrollView最初的contentOffset (FIXME: 以后再改进，)
     @param
     */
    public func setNavigationBarBounceAndAlpha(bindScrollView: UIScrollView,
                                               bounceEnable: Bool = false,
                                               changeAlphaEnable: Bool = true,
                                               beginOffset: CGFloat = 0.0,
                                               progressHeight: CGFloat = 0.0,
                                               changedCallback: YYNavigationBarChangedCallback? = nil) {
        // Alpha是否允许改变
        let isProgress = changeAlphaEnable && fabsf(Float(beginOffset)) >= 0.0 && fabsf(Float(progressHeight)) >= 0.0
        
        guard bounceEnable || isProgress else {
            return
        }
        
        let originOffset_y = bindScrollView.contentInset.top - (self.viewController?.yy_navigationBarHeight() ?? 0)
        
        bindScrollView.rx.contentOffset.subscribe(onNext: { [unowned self] (contentOffset) in
            var alpha = self.mBackgroundImgView.alpha
            var height = self.bounds.size.height
            
            if isProgress {
                alpha = CGFloat(fminf(fmaxf(0.0, Float(contentOffset.y - originOffset_y - beginOffset))/Float(progressHeight), 1.0))
                self.mBarView.alpha = alpha
            }
            
            if bounceEnable {
                height = self.originHeight + CGFloat(originOffset_y - contentOffset.y)
                self.updateBarHeight(height)
            }
            
            changedCallback?(alpha, height)
        }).disposed(by: self.disposeBag)
    }
    
}


class CBBarView: YYHitFilterView {
    
    private lazy var mImgView: UIImageView = {
        let aImgView = UIImageView()
        aImgView.backgroundColor = UIColor.clear
        aImgView.contentMode = .scaleAspectFill
        aImgView.clipsToBounds = true
        return aImgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kNavBarClolor
        self.clipsToBounds = true
        
        self.addSubview(self.mImgView)
        
        self.mImgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 设置图片
    public func setImage(_ image: UIImage?) {
        self.mImgView.image = image
    }
    
}
