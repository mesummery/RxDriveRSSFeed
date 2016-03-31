//
//  FeedRequest.swift
//  MAF-RSSFeed
//
//  Created by SaikaYamamoto on 2015/10/11.
//  Copyright © 2015年 SaikaYamamoto. All rights reserved.
//

// Frameworks
import RxSwift
import ObjectMapper
import Alamofire

/// RSS Feeds Request
class FeedRequest: RequestBase {

    // Host
    private let HOST = GOOGLE_FEED_PATH
    
    // Path
    private let PATH = "http://www.sketchappsources.com/rss.xml&num=100"

    final func connect() -> Observable<FeedResponse> {
        createRequest(
            hostName: HOST,
            path: PATH,
            method: .GET,
            parameters: nil,
            encording: .JSON,
            headers: nil
        )
        return super.connect()
    }
}