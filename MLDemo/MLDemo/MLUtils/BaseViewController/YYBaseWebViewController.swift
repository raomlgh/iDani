//
//  YYBaseWebViewController.swift
//  MLDemo
//
//  Created by raoml on 2019/5/28.
//  Copyright © 2019 raoml. All rights reserved.
//

import UIKit
import WebKit

private enum loadType {
    case unknow
    case URL
    case HTML
    case PDF
}

private let kEstimatedProgressKey = "estimatedProgress"
private let kCanGoBackKey = "canGoBack"

class YYBaseWebViewController: YYBaseViewController {
    
    private var type: loadType = .unknow
    private var sourece: (url: URL?, HTMLString: String?, data: Data?) = (nil, nil, nil)
    private let cookie: String? = UserDefaults.standard.object(forKey: "token") as? String
    
    // Token
    public var token: String?
    
    init(url: URL?) {
        super.init()
        
        self.type = .URL
        self.sourece.url = url
    }
    
    init(HTMLString: String?) {
        super.init()
        
        self.type = .HTML
        self.sourece.HTMLString = HTMLString
    }
    
    init(PDFFilePath: String?) {
        super.init()
        
        self.type = .PDF
        self.sourece.data = try! Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: PDFFilePath, ofType: "pdf")!))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.setupSubviewsConstraints()
        self.loadContent()
        
        self.webView.addObserver(self, forKeyPath: kEstimatedProgressKey, options: .new, context: nil)
        self.webView.addObserver(self, forKeyPath: kCanGoBackKey, options: .new, context: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.webView.snp.remakeConstraints { (make) in
            make.top.width.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-self.view.yy_safeInsets.bottom)
        }
    }
    
    deinit {
        self.webView.removeObserver(self, forKeyPath: kEstimatedProgressKey)
        self.webView.removeObserver(self, forKeyPath: kCanGoBackKey)
    }
    
    // MARK: - Lazy
    private(set) lazy var webView: WKWebView = { [unowned self] in
        let aWebView = WKWebView(frame: self.view.bounds, configuration: self.configuration)
        aWebView.uiDelegate = self
        aWebView.navigationDelegate = self
        aWebView.allowsBackForwardNavigationGestures = true
//        aWebView.popGestureRecognizerFirst = NSNumber(booleanLiteral: false)
        return aWebView
    }()
    
    private lazy var configuration: WKWebViewConfiguration = {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        
        let userScript = WKUserScript(source: "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta); var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        
        configuration.userContentController.addUserScript(userScript)
        if let cookie = self.cookie {
            let cookieScript = WKUserScript(source: "document.cookie=\(cookie)", injectionTime: .atDocumentStart, forMainFrameOnly: false)
            configuration.userContentController.addUserScript(cookieScript)
        }
        
        return configuration
    }()
    
    private lazy var progressView: UIProgressView = {
        let aProgressView = UIProgressView(progressViewStyle: .default)
        aProgressView.frame = CGRect(x: 0, y: self.yy_navigationBarHeight(), width: self.view.bounds.width, height: 10.0)
        aProgressView.trackTintColor = UIColor.clear
        aProgressView.progressTintColor = kMainColor
        return aProgressView
    }()
    
    private lazy var emptyView: YYEmptyView = { [unowned self] in
        let aEmptyView = YYEmptyView(_img: nil, _title: "加载失败(；′⌒`)", _message: nil, _actionTitle: "重新加载", _completion: {
            self.webView.reload()
        })        
        aEmptyView.isHidden = true
        return aEmptyView
    }()

}

// MARK: - Private Meds
extension YYBaseWebViewController {
    
    private func setupUI() {
        self.webView.addSubview(self.emptyView)
        self.view.addSubview(self.webView)
        self.view.addSubview(self.progressView)
    }
    
    private func setupSubviewsConstraints() {
        self.emptyView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func loadContent() {
        switch self.type {
        case .URL:
            if let url = self.sourece.url {
                self.webView.load(URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30.0))
            }
        case .HTML:
            if let HTMLString = self.sourece.HTMLString {
                let HTML = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>" + HTMLString
                self.webView.loadHTMLString(HTML, baseURL: nil)
            }
        case .PDF:
            if let data = self.sourece.data {
                self.webView.load(data, mimeType: "application/pdf", characterEncodingName: "utf-8", baseURL: NSURL() as URL)
            }
        default:
            break
        }
    }
    
    private func setNavigationLeftItems(canGoBack: Bool) {
        if canGoBack {
            let backItem = UIBarButtonItem(image: UIImage.yy_imageFromBundle("back_arrow"), style: .plain, target: self, action: #selector(goBack(sender:)))
            let closeItem = UIBarButtonItem(image: UIImage.yy_imageFromBundle("pic_closel"), style: .plain, target: self, action: #selector(close(sender:)))
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.leftBarButtonItems = [backItem, closeItem]
        }else {
            let backItem = UIBarButtonItem(image: UIImage.yy_imageFromBundle("back_arrow"), style: .plain, target: self, action: #selector(close(sender:)))
            self.navigationItem.leftBarButtonItems = nil
            self.navigationItem.leftBarButtonItem = backItem
        }
    }
    
    @objc private func goBack(sender: UIBarButtonItem) {
        self.webView.goBack()
    }
    
    @objc private func close(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// 刷新Token
    private func saveTokenToLocalStorage() {
        if let token = self.token {
            //保存token到本地
            self.webView.evaluateJavaScript("localStorage.setItem('h5token', '\(token)')") { (data, error) in
                print("error=\(error.debugDescription)")
            }
        }else{
            self.webView.evaluateJavaScript("localStorage.clear()") { (data, error) in
                print("error=\(error.debugDescription)")
            }
        }
    }
    
    /// 获取所有的图片地址
    @objc private func fetchAllImages() {
        // 这里是js，主要目的实现对url的获取
        let jsGetImages = "function getImages(){var objs = document.getElementsByTagName(\"img\"); var imgScr = ''; for(var i=0;i<objs.length;i++){ imgScr = imgScr + objs[i].src + '+';}; return imgScr;};"
    
        self.webView.evaluateJavaScript(jsGetImages, completionHandler: nil)
        self.webView.evaluateJavaScript("getImages()") { (imageUrls, err) in
            let imgUrls = (imageUrls as! String).components(separatedBy: "+")
            print(imgUrls)
        }
    }
    
}

// MARK: - NSKeyValueObserving
extension YYBaseWebViewController {
    
    // 监听加载进度
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if ((object as? WKWebView) == self.webView) {
            if keyPath == kEstimatedProgressKey {
                self.progressView.setProgress(Float(self.webView.estimatedProgress), animated: true)
            }else if keyPath == kCanGoBackKey {
                let canGoBack = change?[NSKeyValueChangeKey.newKey] as? Bool ?? false
                self.setNavigationLeftItems(canGoBack: canGoBack)
            }
        }
    }
    
}

// MARK: - WKUIDelegate
extension YYBaseWebViewController: WKUIDelegate {
    
    // 开始加载
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.progressView.setProgress(0.0, animated: false)
        self.progressView.isHidden = false
        self.emptyView.isHidden = true
    }
    
    // 加载完成
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if self.title?.isEmpty ?? true {
            self.title = webView.title
        }
        self.progressView.setProgress(1.0, animated: true)        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.progressView.setProgress(0.0, animated: false)
            self.progressView.isHidden = true
        }
        
        // 禁止长按弹出选项框
        webView.evaluateJavaScript("document.documentElement.style.webkitTouchCallout='none';", completionHandler: nil)
        
        
        // 刷新Token
        self.saveTokenToLocalStorage()
        
        // 获取所有的图片URL
//        self.fetchAllImages()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.progressView.setProgress(0.0, animated: false)
        self.progressView.isHidden = true
        self.emptyView.isHidden = false
    }
    
}

// MARK: - WKNavigationDelegate
extension YYBaseWebViewController: WKNavigationDelegate {
    
    
}


class YYWeakScriptMessageDelegate: NSObject, WKScriptMessageHandler {
    // window.webkit.messageHandlers.<方法名>.postMessage(<数据>)
    weak private var scriptDelegate: WKScriptMessageHandler?
    
    init(delegate: WKScriptMessageHandler) {
        super.init()
        self.scriptDelegate = delegate
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        self.scriptDelegate?.userContentController(userContentController, didReceive: message)
    }
}

