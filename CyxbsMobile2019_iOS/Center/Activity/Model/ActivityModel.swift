//
//  UFieldActivityModel.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/8/16.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation

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



