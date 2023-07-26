//
//  TestArrangeViewController.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/7/17.
//

import UIKit
import WebKit

class TestArrangeViewController: UIViewController,WKNavigationDelegate {
    var webView: WKWebView!  //该webView仅用于获取考试安排信息，全程不显示
    var htmlString: String?
    var exams:[ExamAM] = []
    var mainView:TestArrangeView!
    var topView:TopView!
    var bottomView:BottomView!
    var scoreEnterButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if #available(iOS 11.0, *) {
            view.backgroundColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#F8F9FC")!, darkColor: UIColor(hexString: "#000101")!, alpha: 1)
//            self.view.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F8F9FC" alpha:1] darkColor:[UIColor colorWithHexString:@"#000101" alpha:1]];
        } else {
            view.backgroundColor = UIColor(hexString: "#F8F9FC")
        }
        webView = WKWebView(frame: view.bounds)
        webView.accessibilityLanguage = "zh-CN"
        webView.navigationDelegate = self
//        mainView = TestArrangeView(frame: view.bounds)
//        view.addSubview(mainView)
        self.addTopView()
        self.addBottomView()
//        mainView.avatarButton.addTarget(self, action: #selector(presentLoginScreen), for: .touchUpInside)
//        mainView.userNameLabel.text = "请登录"
//        mainView.idLabel.text = "点击左侧头像按钮登录"
//        view.addSubview(webView)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        print("网页加载完成")
        if webView.url == URL(string: "http://jwzx.cqupt.edu.cn/student/ksap.php#stuKsTab-ks"){
            webView.evaluateJavaScript("document.documentElement.outerHTML.toString()", completionHandler: { [self] (html, error) in
                        if let htmlString = html as? String {
                            print("页面源代码：\(htmlString) \n")
                            if htmlString == "<html><head></head><body>登陆失效请重新登陆</body></html>"{
                                print("登陆过期，二次跳转")
                                self.presentLoginScreen()
                            }
                            else if htmlString == "<html><head></head><body></body></html>"{
                                print("成绩获取失败")
                            }//这种情况为请求失败，大部分情况为服务器关闭
                            else{
                                print("成绩加载完成")
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
                                self.bottomView.userNameLabel.text = self.exams[0].name
                                self.bottomView.idLabel.text = self.exams[0].studentID
                                self.scoreEnterButton.removeTarget(self, action: #selector(self.popController), for: .touchUpInside)
                                //移除登录栏按钮事件，防止二次登录
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
//               self?.navigationController?.popViewController(animated: true)
            self?.dismiss(animated: true, completion: nil)
            self?.showGrade(cookies: cookies)
        }
        present(loginVC, animated: true)
//        self.navigationController?.pushViewController(loginVC, animated: true)
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
    
    func addTopView() {
        topView = TopView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 80))
        view.addSubview(topView)
        topView.backButton.addTarget(self, action: #selector(popController), for: .touchUpInside)
    }
    
    func addBottomView() {
        bottomView = BottomView()
        view.addSubview(bottomView)
        scoreEnterButton = UIButton()
        scoreEnterButton.backgroundColor = UIColor.clear
        bottomView.addSubview(scoreEnterButton)
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        scoreEnterButton.translatesAutoresizingMaskIntoConstraints = false
               
        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: scoreEnterButton.topAnchor, constant: -10),
            bottomView.leftAnchor.constraint(equalTo: scoreEnterButton.leftAnchor),
            bottomView.rightAnchor.constraint(equalTo: scoreEnterButton.rightAnchor),
            bottomView.bottomAnchor.constraint(equalTo: scoreEnterButton.bottomAnchor),
            scoreEnterButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 10),
            scoreEnterButton.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            scoreEnterButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            scoreEnterButton.heightAnchor.constraint(equalToConstant: 80)
        ])
               
        bottomView.layer.cornerRadius = 16
        bottomView.clipsToBounds = true
               
        // GPA 接口暂时弄不了，所以关闭 GPA 查询入口
        scoreEnterButton.addTarget(self, action: #selector(presentLoginScreen), for: .touchUpInside)
    
    }
    

}
