//
//  ListViewModel.swift
//  MAF-SwiftCompe
//
//  Created by SaikaYamamoto on 2015/09/23.
//  Copyright (c) 2015年 SaikaYamamoto. All rights reserved.
//

// Frameworks
import UIKit

import RxSwift

import RxCocoa

/// List View Model
final class ListViewModel: NSObject, UITableViewDataSource {

    /// Cell Identifier
    final private var cellIdentifier = "ListCell"

    /// Request Model class
    final private var model = ListModel()

    /// Entries
    final var entries = [Entry]()
    
    // Rx
    /// Data Updated
    final private(set) var dataUpdated: Driver<[Entry]> = Driver.never()
    
    /// Loading flg
    final private(set) var isLoading: Driver<Bool> = Driver.never()
    
    /// Error flg
    final private(set) var isError: Driver<Bool> = Driver.never()
    
    override init() {
        super.init()

        dataUpdated = model.entries.asObservable().asDriver(onErrorJustReturn: [])
        isLoading = model.isLoading.asObservable().asDriver(onErrorJustReturn: false)
        isError = model.error.asObservable().map { $0 != nil }.asDriver(onErrorJustReturn: false)
    }
    
    /**
    Reload
    */
    func reloadData() {
        // API
        model.request()
    }
    
    // MARK: - TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ListCell
        cell.configureCell(entity: entries[indexPath.row])
        return cell
    }
}
