//
//  TestArrangeViewController.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/7/17.
//

import UIKit
import WebKit

class TestArrangeViewController: UIViewController,WKNavigationDelegate {
    var webView: WKWebView!
    var htmlString: String?
    var exams:[ExamAM] = []
    var mainView:TestArrangeView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        webView = WKWebView(frame: view.bounds)
        webView.accessibilityLanguage = "zh-CN"
        webView.navigationDelegate = self
        mainView = TestArrangeView(frame: view.bounds)
        view.addSubview(mainView)
        mainView.backButton.addTarget(self, action: #selector(popController), for: .touchUpInside)
        mainView.avatarButton.addTarget(self, action: #selector(presentLoginScreen), for: .touchUpInside)
        mainView.userNameLabel.text = "请登录"
        mainView.idLabel.text = "点击左侧头像按钮登录"
//        view.addSubview(webView)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        print("网页加载完成")
        if webView.url == URL(string: "http://jwzx.cqupt.edu.cn/student/ksap.php#stuKsTab-ks"){
            print("成绩加载完成")
            webView.evaluateJavaScript("document.documentElement.outerHTML.toString()", completionHandler: { (html, error) in
                        if let htmlString = html as? String {
                            print("页面源代码：\(htmlString) \n")
                            if htmlString == "<html><head></head><body>登陆失效请重新登陆</body></html>"{
                                print("登陆过期，二次跳转")
                                self.presentLoginScreen()
                            }
                            // 将页面源代码保存到变量或进行其他处理
                        
                            self.exams = analyze(html: htmlString)
                            for exam in self.exams {
                                print("Student ID: \(exam.studentID)")
                                print("Name: \(exam.name)")
                                print("Exam Type: \(exam.examType)")
                                print("Course Code: \(exam.courseCode)")
                                print("Course Name: \(exam.courseName)")
                                print("Exam Week: \(exam.examWeek)")
                                print("Weekday: \(exam.weekday)")
                                print("Exam Time: \(exam.examTime)")
                                print("Exam Location: \(exam.examLocation)")
                                print("Seat Number: \(exam.seatNumber)")
                                print("Exam Eligibility: \(exam.examEligibility)")
                                print("------")
                            }
                            
                        } else if let error = error {
                            print("获取页面源代码失败：\(error.localizedDescription)")
                        }
                    })
        }
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        // 网页发生重定向
        print("网页发生重定向")
        if webView.url == URL(string: "http://jwzx.cqupt.edu.cn/index.php"){
            print("跳转至首页（登陆完成）")
            self.jumpToExamArrangements()
        }
       }
    
    func jumpToIDSLoginPage()  {
        webView.load(URLRequest(url: URL(string: "http://jwzx.cqupt.edu.cn/tysfrz/index.php")!))
    } //跳转IDS登陆页面
    
    func jumpToExamArrangements()  {
        webView.load(URLRequest(url: URL(string: "http://jwzx.cqupt.edu.cn/student/ksap.php#stuKsTab-ks")!))
        
    } //跳转考试安排页
    
    @objc func presentLoginScreen() {
        let loginVC = IDSViewController()
        loginVC.loginCompletion = { [weak self] cookies in
               // 在闭包中处理接收到的 Cookies 数组
               self?.navigationController?.popViewController(animated: true)
               self?.showGrade(cookies: cookies)
        }
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    func showGrade(cookies:[HTTPCookie]) {
        for cookie in cookies {
            self.webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
        }
        self.jumpToExamArrangements()
    }
    
    @objc func popController(){
        self.navigationController?.popViewController(animated: true)
    }
    

}
