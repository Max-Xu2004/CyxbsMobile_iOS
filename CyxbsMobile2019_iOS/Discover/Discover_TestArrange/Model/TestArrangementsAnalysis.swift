//
//  TestArrangementsAnalysis.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/7/17.
//

import Foundation
import SwiftSoup

func testArrangementsanalyze(html: String)->[ExamAM] {
    var exams:[ExamAM] = []
    do {
        let doc = try SwiftSoup.parse(html)
        // 获取课程考试表格中的数据
        let table = try doc.select("#stuKsTab-ks table").first()
        if let rows = try table?.select("tr") {
            for i in 1..<rows.count { // 从第二行开始（第一行为数据名称）
                let row = rows[i]
                let cells = try row.select("td")
                if cells.count >= 11 {
                    let exam = ExamAM(studentID: try cells[1].text(),
                                      name: try cells[2].text(),
                                      examType: try cells[3].text(),
                                      courseCode: try cells[4].text(),
                                      courseName: try cells[5].text(),
                                      examWeek: try cells[6].text(),
                                      weekday: try cells[7].text(),
                                      examTime: try cells[8].text(),
                                      examLocation: try cells[9].text(),
                                      seatNumber: try cells[10].text(),
                                      examEligibility: try cells[11].text())
                    exams.append(exam)
                }
            }
        }
        
        
    } catch {
        print("Error: \(error)")
    }
    
    return exams
}
