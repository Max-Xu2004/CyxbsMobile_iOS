//
//  TestArrangeViewController.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/7/17.
//

import UIKit
import WebKit

class TestArrangeViewController: UIViewController,
                                 WKNavigationDelegate,
                                 UITableViewDelegate,
                                 UITableViewDataSource {
    var webView: WKWebView!  //该webView仅用于获取考试安排信息，全程不显示
    var htmlString: String?
    var exams:[ExamAM] = []
    var mainView:TestArrangeView!
    var topView:TopView!
    var bottomView:BottomView!
    var scoreEnterButton: UIButton!
    var tableView: UITableView?
    var seperateLine: UIView?
    var titleLabel: UILabel!
    var dateFormatter1: DateFormatter!
    var startDate: Date!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if #available(iOS 11.0, *) {
            view.backgroundColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#F8F9FC")!, darkColor: UIColor(hexString: "#000101")!, alpha: 1)
        }
        else {
            view.backgroundColor = UIColor(hexString: "#F8F9FC")
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDateString = "2023-02-20" //开学日期，目前写死
        startDate = dateFormatter.date(from: startDateString)!
        dateFormatter1 = DateFormatter()
        dateFormatter1.locale = Locale(identifier: "zh_CN")
        dateFormatter1.dateFormat = "M月d号"
        
        webView = WKWebView(frame: view.bounds)
        webView.accessibilityLanguage = "zh-CN"
        webView.navigationDelegate = self
        mainView = TestArrangeView(frame: view.bounds)
        view.addSubview(mainView)
        self.addTopView()
        self.addBottomView()
        self.addTableView()
        self.addSeperateLine()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("网页加载完成")
        //当加载页面为考试安排页面时，分析考试安排
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
                        self.exams = testArrangementsanalyze(html: htmlString)
                        if exams.count > 0 {
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
                            self.getUserInfos()
                            self.getExamArrangeDataSucceed()
                            self.addTitleLabel()
                            self.scoreEnterButton.removeTarget(self, action: #selector(self.popController), for: .touchUpInside) //移除登录栏按钮事件，防止二次登录
                        }else {
                            self.getUserInfos()
                            self.scoreEnterButton.removeTarget(self, action: #selector(self.popController), for: .touchUpInside) //移除登录栏按钮事件，防止二次登录
                            let hud = MBProgressHUD.showAdded(to: view, animated: true)
                            hud?.mode = .text
                            hud?.labelText = "您当前没有考试哦～"
                            hud?.hide(true, afterDelay: 3)
                            }
                        } //当exams中含exam的数量为0，说明没有考试安排
                    }
                    
                } else if let error = error {
                    print("获取页面源代码失败：\(error.localizedDescription)")
                }
            })
        }
        //当加载页面为个人服务页面时，分析个人信息
        if webView.url == URL(string: "http://jwzx.cqupt.edu.cn/user.php"){
            webView.evaluateJavaScript("document.documentElement.outerHTML.toString()", completionHandler: { [self] (html, error) in
                if let htmlString = html as? String {
                    print("个人信息页面源代码：\(htmlString) \n")
                    if let userInfo = UserInfoModel.parseUserInfo(from: htmlString){
                        bottomView.userNameLabel.text = userInfo.name
                        bottomView.idLabel.text = userInfo.studentNumber
                        bottomView.majorLabel.text = userInfo.major
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
        self.mainView.addSubview(topView)
        topView.backButton.addTarget(self, action: #selector(popController), for: .touchUpInside)
    }
    
    func addBottomView() {
        bottomView = BottomView()
        self.mainView.addSubview(bottomView)
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
    private func addTableView() {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        if isIPhoneX() {
            tableView.frame = CGRect(x: 53,
                                     y: statusBarHeight+80,
                                     width: self.view.frame.width - 53 - 19,
                                     height: self.view.frame.height - 87 - (self.tabBarController?.tabBar.frame.height ?? 0) - 30)
        } else {
            tableView.frame = CGRect(x: 53,
                                     y: 80,
                                     width: self.view.frame.width - 53 - 19,
                                     height: self.view.frame.height - 87 - (self.tabBarController?.tabBar.frame.height ?? 0) - 50)
        }
        self.tableView = tableView
        self.mainView.addSubview(tableView)
        
        //避免tableView上面的tittleLabel和topbar的label文字重叠
        self.mainView.sendSubviewToBack(tableView)
        
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = self.view.backgroundColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    private func addSeperateLine() {
        let line = UIView(frame: CGRect.zero)
        if isIPhoneX(){
            line.frame = CGRect(x: 0,
                                y: statusBarHeight+80,
                                width: self.view.frame.width,
                                height: 1)
        }
        else{
            line.frame = CGRect(x: 0,
                                y: 80,
                                width: self.view.frame.width,
                                height: 1)
        }
        line.backgroundColor = UIColor(red: 42/255.0, green: 78/255.0, blue: 132/255.0, alpha: 0.1)
        self.view.addSubview(line)
        self.seperateLine = line
    }
    
    func addTitleLabel() {
        let label = UILabel(frame: CGRect(x: -34, y: -48+62, width: 250, height: 40))
        self.titleLabel = label
        self.tableView?.addSubview(label)
        label.text = "考试安排"
        label.font = UIFont(name: PingFangSCBold, size: 22)
        
        if #available(iOS 11.0, *) {
            label.textColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#15315B", alpha: 1), darkColor: UIColor(hexString: "#F0F0F2", alpha: 1))
        } else {
            label.textColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#15315B", alpha: 1), darkColor: UIColor(hexString: "#FFFFFF", alpha: 1))
        }
    }
    
    @objc private func getExamArrangeDataSucceed() {
        self.tableView?.reloadData()
        //展示左边的小球和点点
        let pointCount = self.exams.count
        let spacing: CGFloat = 166.13
        let pointAndDottedLineView = PointAndDottedLineView(pointCount: pointCount, spacing: spacing)
        if isIPhoneX() {
            pointAndDottedLineView.frame = CGRect(x: -30, y: 78 + statusBarHeight, width: 11, height: pointAndDottedLineView.bigCircle!.width + spacing * CGFloat(pointCount - 1))
        }else{
            pointAndDottedLineView.frame = CGRect(x: -30, y: 78, width: 11, height: pointAndDottedLineView.bigCircle!.width + spacing * CGFloat(pointCount - 1))
        }
        self.tableView?.clipsToBounds = false
        self.tableView?.addSubview(pointAndDottedLineView)
        if pointAndDottedLineView.isNoExam {
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud?.mode = .text
            hud?.labelText = "您当前没有考试哦～"
            hud?.hide(true, afterDelay: 3)
                
            }
        }
    }
    // MARK: - tableView代理
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exams.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 166
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ExamCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? TestCardTableViewCell
        if cell == nil {
                cell = TestCardTableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
            
//            if let exam = examArrangeModel?.examArrangeData.data[indexPath.section].exams[indexPath.row] {
//                cell?.configure(with: exam)
//            }
        cell?.subjectLabel?.text = exams[indexPath.row].courseName
        cell?.classLabel?.text = exams[indexPath.row].examLocation
        cell?.timeLabel?.text = exams[indexPath.row].examTime
        cell?.testNatureLabel?.text = exams[indexPath.row].examType
        cell?.seatNumLabel?.text = "\(exams[indexPath.row].seatNumber)号"
        let date = calculateDate(from: startDate, weeks: extractNumberFromString(exams[indexPath.row].examWeek)!, weekday: exams[indexPath.row].weekday)
        cell?.dayLabel?.text = dateFormatter1.string(from: date!)
        cell?.leftDayLabel?.text = "还剩\(daysUntilDate((date)!) ?? 0)天考试"
        cell?.weekTimeLabel?.text = "\(translationArabicNum(Int(extractNumberFromString(exams[indexPath.row].examWeek)!)!))周周\(translationArabicNum(Int(exams[indexPath.row].weekday)!))"
        if daysUntilDate((date)!)! < 0 {
            cell?.leftDayLabel?.text = "考试已结束"
                if #available(iOS 11.0, *) {
                    cell?.leftDayLabel?.textColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#2A4E84", alpha: 0.56), darkColor: UIColor(hexString: "#858585", alpha: 1))
//                    cell?.leftDayLabel?.textColor = UIColor.dm_colorWithLightColor(UIColor(hexString: "#2A4E84", alpha: 0.56), darkColor: UIColor(hexString: "#858585", alpha: 1))
                }
            else {
                    cell?.leftDayLabel?.textColor = UIColor(hexString: "#2A4E84")
            }
        }
        cell?.leftDayLabel?.alpha = 0.56
        return cell!
    }
        
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.backgroundColor = UIColor.clear
            
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 10, width: tableView.frame.width - 40, height: 30))
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
//            if let examDate = examArrangeModel?.examArrangeData.data[section].date {
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd"
//                if let date = dateFormatter.date(from: examDate) {
//                    dateFormatter.dateFormat = "yyyy年MM月dd日"
//                    let formattedDate = dateFormatter.string(from: date)
//                    titleLabel.text = formattedDate
//                }
//            }
        titleLabel.textColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#15315B")!, darkColor: UIColor(hexString: "#F0F0F2")!, alpha: 1)
        headerView.addSubview(titleLabel)
            
        return headerView
    }
    
    // MARK: - 根据开学日期、weeks和weekady计算出考试日期
    func calculateDate(from startDate: Date, weeks: String, weekday: String) -> Date? {
        guard let weeksInt = Int(weeks), let weekdayInt = Int(weekday) else {
            return nil
        }

        let calendar = Calendar.current
        let weekdayRange = calendar.range(of: .weekday, in: .weekOfYear, for: startDate)

        guard let weekdayRange = weekdayRange else {
            return nil
        }

        let numberOfDaysInAWeek = 7
        let daysToAdd = (weeksInt - 1) * numberOfDaysInAWeek + (weekdayInt - weekdayRange.lowerBound)

        guard let calculatedDate = calendar.date(byAdding: .day, value: daysToAdd, to: startDate) else {
            return nil
        }

        return calculatedDate
    }
    
    // MARK: - 正则表达式从“**周”string中提取出周数
    func extractNumberFromString(_ inputString: String) -> String? {
        let regexPattern = "(\\d+)周" // 正则表达式匹配一个或多个数字后跟"周"
        let regex = try! NSRegularExpression(pattern: regexPattern, options: [])
        let matches = regex.matches(in: inputString, options: [], range: NSRange(location: 0, length: inputString.count))

        if let match = matches.first, let range = Range(match.range(at: 1), in: inputString) {
            return String(inputString[range])
        } else {
            return nil
        }
    }
    
    // MARK: - 计算考试日期离现在还有多少天
    func daysUntilDate(_ targetDate: Date) -> Int? {
        let calendar = Calendar.current
        let currentDate = Date()
        
        let dateComponents = calendar.dateComponents([.day], from: currentDate, to: targetDate)
        return dateComponents.day
    }
    
    
    func translationArabicNum(_ arabicNum: Int) -> String {
        let arabicNumStr = String(arabicNum)
        let arabicNumeralsArray = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
        let chineseNumeralsArray = ["一", "二", "三", "四", "五", "六", "七", "八", "九", "零"]
        let digits = ["个", "十", "百", "千", "万", "十", "百", "千", "亿", "十", "百", "千", "兆"]
        let dictionary = Dictionary(uniqueKeysWithValues: zip(arabicNumeralsArray, chineseNumeralsArray))
        
        if arabicNum < 20 && arabicNum > 9 {
            if arabicNum == 10 {
                return "十"
            } else {
                let subStr1 = arabicNumStr.prefix(1)
                if let a1 = dictionary[String(subStr1)] {
                    let chinese1 = "十\(a1)"
                    return chinese1
                }
            }
        } else {
            var sums = [String]()
            for i in 0..<arabicNumStr.count {
                let index = arabicNumStr.index(arabicNumStr.startIndex, offsetBy: i)
                let substr = String(arabicNumStr[index])
                if let a = dictionary[substr], let b = digits[arabicNumStr.count - i - 1] as? String {
                    var sum = a + b
                    if a == chineseNumeralsArray[9] {
                        if b == digits[4] || b == digits[8] {
                            sum = b
                            if sums.last == chineseNumeralsArray[9] {
                                sums.removeLast()
                            }
                        } else {
                            sum = chineseNumeralsArray[9]
                        }
                        if sums.last == sum {
                            continue
                        }
                    }
                    sums.append(sum)
                }
            }
            let sumStr = sums.joined()
            let chinese = String(sumStr.prefix(sumStr.count - 1))
            return chinese
        }
        return ""
    }
    
    func getUserInfos (){
        webView.load(URLRequest(url: URL(string: "http://jwzx.cqupt.edu.cn/user.php")!))
    }
        
        
}

