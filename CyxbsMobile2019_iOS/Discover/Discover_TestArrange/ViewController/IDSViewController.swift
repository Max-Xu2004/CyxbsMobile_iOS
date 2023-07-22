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
        webView = WKWebView(frame: view.bounds)
        webView.accessibilityLanguage = "zh-CN"
        webView.navigationDelegate = self
        webView.load(URLRequest(url: URL(string: "http://jwzx.cqupt.edu.cn/user.php")!))
        view.addSubview(webView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("载入登陆页面中")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        print("网页加载完成")
        
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
            if let cookies = HTTPCookieStorage.shared.cookies(for: webView.url!) {
                // 设置 cookies1 到 webView2 的 HTTPCookieStorage
                self.loginCompletion?(cookies)
            }
//            webView.evaluateJavaScript("document.cookie") { (result, error) in
//                        if let cookies = result as? String {
//                            print("Cookies: \(cookies)")
//                            // 在这里可以对获取到的 Cookie 进行后续处理
//                            self.processCookies(cookies)
//                        }
//                    }
            
        }
       }
    
    func jumpToIDSLoginPage()  {
        webView.load(URLRequest(url: URL(string: "http://jwzx.cqupt.edu.cn/tysfrz/index.php")!))
    } //跳转IDS登陆页面
    
    func processCookies(_ cookieString: String) {
        // 将字符串按照分号进行拆分
        let cookieComponents = cookieString.components(separatedBy: "; ")

        // 创建一个空的字典，用于存储解析后的cookie参数
        var cookieProperties = [HTTPCookiePropertyKey: Any]()

        for component in cookieComponents {
            // 将每个参数按照等号进行拆分，获取key和value
            let keyValue = component.components(separatedBy: "=")
            if keyValue.count == 2 {
                let key = keyValue[0]
                let value = keyValue[1]
                cookieProperties[HTTPCookiePropertyKey(key)] = value
            }
        }

        // 创建HTTPCookie对象
        if let cookie = HTTPCookie(properties: cookieProperties) {
            // 在这里可以使用cookie对象进行相应的操作
            print("处理完的Cookie: \(cookie)")
        } else {
            print("无法创建HTTPCookie对象")
        }
        }

}
