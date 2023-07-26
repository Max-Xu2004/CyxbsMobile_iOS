//
//  IDSViewController.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/7/20.
//

import UIKit
import WebKit

class IDSViewController: UIViewController,WKNavigationDelegate {
    var webView: WKWebView!
    var htmlString: String?
    var loginCompletion: (([HTTPCookie]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        print("载入登陆页面中")
        
        self.view.addSubview(topBar)
        self.topBar.addSubview(self.titleLab)
        self.topBar.addSubview(self.backButton)
        setPosition()
        self.backButton.addTarget(self, action: #selector(popController), for: .touchUpInside)
        
        webView = WKWebView(frame: CGRect(x: 0, y: 80, width: self.view.bounds.width, height: self.view.bounds.height-80))
        webView.accessibilityLanguage = "zh-CN"
        webView.navigationDelegate = self
        webView.load(URLRequest(url: URL(string: "http://jwzx.cqupt.edu.cn/user.php")!))
        view.addSubview(webView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("载入登陆页面中")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("网页加载完成")
        if webView.url == URL(string: "http://jwzx.cqupt.edu.cn/user.php"){
            webView.removeFromSuperview()
            print("已登陆")
            self.alreadyLogin()
        }
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        // 网页发生重定向
        print("网页发生重定向")
        if webView.url == URL(string: "http://jwzx.cqupt.edu.cn/login.php"){
            print("跳转至登陆页")
            self.jumpToIDSLoginPage()
        }
        if webView.url == URL(string: "http://jwzx.cqupt.edu.cn/index.php"){
            print("跳转至首页（登陆完成）")
            self.alreadyLogin()
        }
    }
    
    func jumpToIDSLoginPage()  {
        webView.load(URLRequest(url: URL(string: "http://jwzx.cqupt.edu.cn/tysfrz/index.php")!))
    } //跳转IDS登陆页面
    
    
    func alreadyLogin (){
        if let cookies = HTTPCookieStorage.shared.cookies(for: webView.url!) {
            self.loginCompletion?(cookies)
        }
    }
    
    lazy var topBar:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 80))
        view.backgroundColor = self.view.backgroundColor
        return view
    }()
    
    lazy var titleLab: UILabel = {
        let label = UILabel()
        label.text = "请登录"
        label.font = UIFont(name: "PingFangSC-Semibold", size: 21)
        label.textColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#15315B")!, darkColor: UIColor(hexString: "#15315B")!, alpha: 1)
        if #available(iOS 11.0, *) {
            label.textColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#15315B")!, darkColor: UIColor(hexString: "#F0F0F2")!, alpha: 1)
        } else {
            label.textColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#15315B")!, darkColor: UIColor(hexString: "#FFFFFF")!, alpha: 1)
        }
        
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "LQQBackButton"), for: .normal)
        button.setImage(UIImage(named: "EmptyClassBackButton"), for: .highlighted)
        return button
    }()
    
    func setPosition(){
        //返回按钮
        self.backButton.translatesAutoresizingMaskIntoConstraints = false
        self.backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 17).isActive = true
        self.backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 43).isActive = true
        self.backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
        self.backButton.imageView?.translatesAutoresizingMaskIntoConstraints = false
        self.backButton.imageView?.widthAnchor.constraint(equalToConstant: 7).isActive = true
        self.backButton.imageView?.heightAnchor.constraint(equalToConstant: 14).isActive = true
        //标题栏
        self.titleLab.translatesAutoresizingMaskIntoConstraints = false
        self.titleLab.leadingAnchor.constraint(equalTo: self.backButton.trailingAnchor, constant: 20).isActive = true
        self.titleLab.centerYAnchor.constraint(equalTo: self.backButton.centerYAnchor).isActive = true
        
    }
    
    @objc func popController(){
        self.dismiss(animated: true, completion: nil)
    }

}
