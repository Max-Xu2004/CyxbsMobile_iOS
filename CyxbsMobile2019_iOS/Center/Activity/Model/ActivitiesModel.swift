//
//  UFieldActivityModel.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/8/16.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation

class ActivitiesModel {
    
    var requestURL: String = "magipoke-ufield/activity/list/all/"
    var activities: [Activity] = []

    ///用于请求活动布告栏的活动
    func requestNoticeboardActivities(success: @escaping ([Activity]) -> Void, failure: @escaping (Error) -> Void) {
        activities = []
        ActivityClient.shared.request(url: requestURL, method: .get, headers: nil, parameters: nil) { responseData in
            if let dataDict = responseData as? [String: Any],
               let jsonData = try? JSONSerialization.data(withJSONObject: dataDict),
               let allActivityResponseData = try? JSONDecoder().decode(AllActivityResponse.self, from: jsonData) {
                let activities = allActivityResponseData.data.ongoing + allActivityResponseData.data.ended
                self.activities = activities
                success(activities)
            } else {
                let error = NSError(domain: "NetworkErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response data"])
                failure(error)
            }
        } failure: { error in
            failure(error)
        }
    }
    
    ///用于请求排行榜的活动
    func requestHitActivity(success: @escaping ([Activity]) -> Void, failure: @escaping (Error) -> Void) {
        let parameters: [String: Any] = [
            "activity_type": "all",
            "order_by": "watch",
            "activity_num": "50"
        ]
        ActivityClient.shared.request(url: "magipoke-ufield/activity/search/",
                                      method: .get,
                                      headers: nil,
                                      parameters: parameters) { responseData in
            if let dataDict = responseData as? [String: Any],
               let jsonData = try? JSONSerialization.data(withJSONObject: dataDict),
               let hitActivityResponseData = try? JSONDecoder().decode(SearchActivityResponse.self, from: jsonData) {
                let activities = hitActivityResponseData.data
                self.activities = activities
                success(activities)
            } else {
                let error = NSError(domain: "NetworkErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response data"])
                failure(error)
            }
        } failure: { error in
            failure(error)
        }
    }
    
    ///用于请求搜索活动
    func requestSearchActivity(keyword: String, activityType: String, success: @escaping ([Activity]) -> Void, failure: @escaping (Error) -> Void) {
        let parameters: [String: Any] = [
            "activity_type": activityType,
            "order_by": "start_timestamp_but_ongoing_first",
            "activity_num": "50",
            "contain_keyword": keyword
        ]
        ActivityClient.shared.request(url: "magipoke-ufield/activity/search/",
                                      method: .get,
                                      headers: nil,
                                      parameters: parameters) { responseData in
            if let dataDict = responseData as? [String: Any],
               let jsonData = try? JSONSerialization.data(withJSONObject: dataDict),
               let hitActivityResponseData = try? JSONDecoder().decode(SearchActivityResponse.self, from: jsonData) {
                let activities = hitActivityResponseData.data
                self.activities = activities
                success(activities)
            } else {
                let error = NSError(domain: "NetworkErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response data"])
                failure(error)
            }
        } failure: { error in
            failure(error)
        }
    }
}


struct Activity: Codable {
    
    let activityTitle: String
    let activityType: String
    let activityId: Int
    let activityCreateTimestamp: Int
    let activityDetail: String
    let activityStartAt: Int
    let activityEndAt: Int
    let activityWatchNumber: Int
    let activityOrganizer: String
    let activityCreator: String
    let activityPlace: String
    let activityRegistrationType: String
    let activityCoverURL: String
    var wantToWatch: Bool?
    let ended: Bool?
    let state: String?
    let phone: String?

    private enum CodingKeys: String, CodingKey {
        case activityTitle = "activity_title"
        case activityType = "activity_type"
        case activityId = "activity_id"
        case activityCreateTimestamp = "activity_create_timestamp"
        case activityDetail = "activity_detail"
        case activityStartAt = "activity_start_at"
        case activityEndAt = "activity_end_at"
        case activityWatchNumber = "activity_watch_number"
        case activityOrganizer = "activity_organizer"
        case activityCreator = "activity_creator"
        case activityPlace = "activity_place"
        case activityRegistrationType = "activity_registration_type"
        case activityCoverURL = "activity_cover_url"
        case wantToWatch = "want_to_watch"
        case ended = "ended"
        case state = "activity_state"
        case phone = "phone"
    }
}

struct AllActivityResponse: Codable {
    let status: Int
    let info: String
    let data: AllActivityData
}

struct AllActivityData: Codable {
    let ended: [Activity]
    let ongoing: [Activity]
}

struct SearchActivityResponse: Codable {
    let status: Int
    let info: String
    let data: [Activity]
}

struct standardResponse: Codable {
    let data: String?
    let status: Int
    let info: String
}

struct MineActivityResponse: Codable {
    let status: Int
    let info: String
    let data: MineActivityData
}

struct MineActivityData: Codable {
    let wantToWatch: [Activity]
    let participated: [Activity]
    let reviewing: [Activity]
    let published: [Activity]
    
    private enum CodingKeys: String, CodingKey {
        case wantToWatch = "want_to_watch"
        case participated = "participated"
        case reviewing = "reviewing"
        case published = "published"
    }
}
