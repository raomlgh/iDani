//
//  YYLoopView.swift
//  MLDemo
//
//  Created by raoml on 2019/5/17.
//  Copyright © 2019 raoml. All rights reserved.
//

import UIKit
import RxSwift

private let kCollectionViewMargin: CGFloat = 40.0
private let kYYLoopViewCellID = "YYLoopViewCellId"

private typealias ConfigTuple = (autoScroll: Bool, interval: TimeInterval)

private enum ScrollDirection {
    /// 当前位置不变
    case none
    /// 向前滚动
    case forward
    /// 向后滚动
    case backward
}

class YYLoopView: UIView {
    
    // 初始化配置
    private var config: ConfigTuple = (true, 3.0)

    // 本地图片
    private var locationImages: [UIImage]?
    // 网络图片
    private var imageUrls: [URL]?
    
    // item数
    private var itemCount: Int = 0
    // 实际显示Item数
    private var totalItemCount: Int = 0 {
        didSet {
            self.isCircle = totalItemCount > itemCount
        }
    }
    // 是否循环滚动
    private var isCircle = false
    
    // 自动切换计时
    private var cutdownInterval: TimeInterval = 0
    // 当前页码
    private var currentPage: Int = 0
    // 判断滚动方向
    private var scrollDirection: ScrollDirection = .none
    // 重定向的位置
    private var redirectContentOffset: CGFloat = 0.0
    
    // 定时器
    private lazy var scrollTimer: Timer = { [unowned self] in
        let aTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] (_) in
            if self?.config.autoScroll ?? false {
                self?.cutdownInterval -= 0.1
                if self?.cutdownInterval ?? 0 <= Double(0.0) {
                    self?.cutdownInterval = self?.config.interval ?? 0
                    self?.scrollToForwardItem()
                }
            }
        })
        RunLoop.current.add(aTimer, forMode: RunLoop.Mode.default)
        return aTimer
    }()
    
    private lazy var mFlowLayout: YYLoopViewFlowLayout = { [unowned self] in
        let aFlowLayout = YYLoopViewFlowLayout()
        aFlowLayout.scrollDirection = .horizontal
        aFlowLayout.minimumInteritemSpacing = kCollectionViewMargin / 2
        aFlowLayout.itemSize = CGSize(width: self.bounds.width - 2 * kCollectionViewMargin, height: self.bounds.height)
        return aFlowLayout
    }()
    
    private lazy var mCollectionView: UICollectionView = { [unowned self] in
        let aCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.mFlowLayout)
        aCollectionView.backgroundColor = .white
        aCollectionView.dataSource = self
        aCollectionView.delegate = self
        aCollectionView.showsHorizontalScrollIndicator = false
        aCollectionView.contentInset = UIEdgeInsets(top: 0, left: kCollectionViewMargin, bottom: 0, right: kCollectionViewMargin)
        aCollectionView.register(YYLoopViewCell.self, forCellWithReuseIdentifier: kYYLoopViewCellID)
        return aCollectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let aPageControl = UIPageControl()
        aPageControl.isUserInteractionEnabled = false
        aPageControl.hidesForSinglePage = true
        aPageControl.currentPageIndicatorTintColor = UIColor.white
        aPageControl.pageIndicatorTintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        return aPageControl
    }()
    
    /**
     初始化
     @param autoScroll 是否自动滚动
     @param interval 滚动间隔时间
     */
    init(frame: CGRect, config: (autoScroll: Bool, interval: TimeInterval) = (true, 2.0)) {
        super.init(frame: frame)
        
        self.config = config
        self.cutdownInterval = config.interval
        
        self.setupUI()
        self.setupSubviewsConstraints()
        
        if config.autoScroll {
            self.scrollTimer.fire()
        }else {
            self.scrollTimer.invalidate()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.scrollRedirect()
    }
    
}

// MARK: - Private Meds
private extension YYLoopView {
    
    func setupUI() {
        self.addSubview(self.mCollectionView)
        self.addSubview(self.pageControl)
    }
    
    func setupSubviewsConstraints() {
        self.mCollectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.pageControl.snp.makeConstraints { (make) in
            make.bottom.width.centerX.equalToSuperview()
        }
    }
    
    // 向前滚动
    func scrollToForwardItem() {
        if self.currentPage < self.totalItemCount - 1 {
            self.currentPage += 1
            self.scrollToPage(self.currentPage, animated: true)
        }else {
            if self.isCircle {
                self.currentPage = 0
                self.scrollRedirect()
            }
        }
    }
    
    // 向后滚动
    func scrollToBackwardItem() {
        if self.currentPage > 0 {
            self.currentPage -= 1
            self.scrollToPage(self.currentPage, animated: true)
        }else {
            if self.isCircle {
                self.currentPage = self.totalItemCount - 1
                self.scrollRedirect()
            }
        }
    }
    
    // 滚动到指定位置
    func scrollToPage(_ page: Int, animated: Bool) {
        let indexPath = IndexPath(item: page, section: 0)
        self.mCollectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.left, animated: animated)
    }
    
    // 重定向滚动位置
    func scrollRedirect() {
        self.cutdownInterval = self.config.interval
        
        let redirectIndex = self.currentPage%self.itemCount
        self.pageControl.currentPage = redirectIndex
        if self.isCircle {
            self.currentPage = self.itemCount + redirectIndex
        }
        
        self.scrollToPage(self.currentPage, animated: false)
        self.redirectContentOffset = self.mCollectionView.contentOffset.x
    }
    
}

// MARK: - Public Meds
extension YYLoopView {
    
    /**
     设置图片
     若同时设置了本地图片和网络图片，则优先显示本地图片，网络图片将不显示
     @param images 本地图片
     @param imageUrls 网络图片
     */
    public func setImages(_ images: [UIImage]?, imageUrls: [URL]?) {
        self.locationImages = images
        self.imageUrls = imageUrls
        
        if let images = images  {
            self.itemCount = images.count
        }else {
            self.itemCount = imageUrls?.count ?? 0
        }
        
        self.totalItemCount = self.itemCount > 1 ? self.itemCount * 3 : self.itemCount
        self.pageControl.numberOfPages = self.itemCount
        self.currentPage = 0
        
        self.mCollectionView.reloadData()
        self.scrollRedirect()
    }
    
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension YYLoopView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.totalItemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kYYLoopViewCellID, for: indexPath) as! YYLoopViewCell
        
        let redirectIndex = indexPath.row%self.itemCount
        if let imgs = self.locationImages {
            cell.configImages(imgs[redirectIndex], url: nil)
        }else {
            cell.configImages(nil, url: self.imageUrls?[redirectIndex])
        }
        
        return cell
    }
    
}

// MARK: - UIScrollViewDelegate
extension YYLoopView: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let scrollToScrollStop = !scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating
        if scrollToScrollStop {
            self.scrollRedirect()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let dragToDragStop = !scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating
        if dragToDragStop {
            self.scrollRedirect()
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.scrollRedirect()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if abs(scrollView.contentOffset.x - self.redirectContentOffset) > self.mFlowLayout.itemSize.width * 0.25 {
            if scrollView.contentOffset.x > self.redirectContentOffset {
                self.scrollDirection = .forward
            }else {
                self.scrollDirection = .backward
            }
        }else {
            self.scrollDirection = .none
        }
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        switch self.scrollDirection {
        case .forward:
            self.scrollToForwardItem()
        case .backward:
            self.scrollToBackwardItem()
        default:
            self.scrollToPage(self.currentPage, animated: true)
        }
    }
    
}

