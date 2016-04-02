//
//  ListModel.swift
//  RxRSSFeed
//
//  Created by SaikaYamamoto on 2016/04/01.
//  Copyright © 2016年 mafmoff. All rights reserved.
//

import UIKit

import RxSwift

// Model + Operator
final class ListModel: NSObject {

    /// Load
    final let isLoading = Variable(false)

    /// Entries
    final let entries = Variable([Entry]())
    
    /// Error
    final let error: Variable<ErrorType?> = Variable(nil)

    /// Rx Dispose
    final let disposeBag = DisposeBag()
    
    final func request() {
        if isLoading.value {
            return
        }
        isLoading.value = true
        error.value = nil
        
        let request = FeedRequest()
        request.connect()
            .subscribe(
                onNext: { [weak self] in self?.entries.value = $0.feed.entries },
                onError: { [weak self] in
                    self?.error.value = $0
                    self?.isLoading.value = false },
                onCompleted: { [weak self] in self?.isLoading.value = false }
            )
        .addDisposableTo(disposeBag)
    }
}
