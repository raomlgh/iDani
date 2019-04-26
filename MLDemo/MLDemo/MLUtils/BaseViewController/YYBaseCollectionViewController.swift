//
//  YYBaseCollectionViewController.swift
//  MLDemo
//
//  Created by raoml on 2019/4/23.
//  Copyright © 2019 raoml. All rights reserved.
//

import UIKit

class YYBaseCollectionViewController: YYBaseViewController {
    
    private(set) lazy var collectionView: UICollectionView = { [unowned self] in
        let aCollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: self.layout)
        aCollectionView.dataSource = self
        aCollectionView.delegate = self
        aCollectionView.backgroundColor = kPageColor
        return aCollectionView
    }()
    
    private var layout: UICollectionViewLayout!
    
    init(layout: UICollectionViewLayout) {
        super.init()
        self.layout = layout
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}

extension YYBaseCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
}
