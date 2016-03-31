//
//  ListController.swift
//  MAF-SwiftCompe
//
//  Created by SaikaYamamoto on 2015/09/23.
//  Copyright (c) 2015年 SaikaYamamoto. All rights reserved.
//

// Frameworks
import UIKit

import RxSwift

/// RSS List Controller
final class ListController: UIViewController, UITableViewDelegate {
  
    /// Table View
    @IBOutlet final private weak var tableView: ListTable!

    /// Error View
    @IBOutlet final private weak var errorView: UIView!

    /// Pull To Refresh
    final private let refresh = UIRefreshControl()
    
    /// View Model
    final private let viewModel = ListViewModel()

    /// Rx破棄用Dispose
    final private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ViewModel
        setupViewModel()
        
        // PullToRefresh
        setupPullRefresh()
        
        // Rx
        bind()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
    View Model Setting
    */
    final func setupViewModel() {
        tableView.dataSource = viewModel
        // Load
        viewModel.reloadData()
    }
    
    /**
     RX bind
     */
    final func bind() {
        
        // TableView Reload
        viewModel.dataUpdated
            .driveNext { [unowned self] in
                self.viewModel.entries = $0
                self.tableView.reloadData()
            }
            .addDisposableTo(disposeBag)

        // Loading Status
        viewModel.isLoading
            .drive(refresh.rx_refreshing)
            .addDisposableTo(disposeBag)
        
        // Error View 
        viewModel.isError
            .map { !$0 }
            .drive(errorView.rx_hidden)
            .addDisposableTo(disposeBag)

        // Pull Refresh
        refresh.rx_controlEvent(.ValueChanged)
            .subscribeNext { [unowned self] _ in self.viewModel.reloadData()
        }.addDisposableTo(disposeBag)
    }
    
    /**
    Pull To Refresh Setting
    */
    final private func setupPullRefresh() {
        refresh.tintColor = UIColor.whiteColor()
        tableView.addSubview(refresh)
    }
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        let controller = navigationController.visibleViewController as! DetailController
        controller.url = (viewModel.entries[(tableView.indexPathForSelectedRow?.row)!].link)
   }
    
    /**
    Back From Detail
    
    - parameter segue: segue
    */
    @IBAction final func unwindFromDetail(segue: UIStoryboardSegue) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}

