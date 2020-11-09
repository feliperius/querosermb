//
//  DataScource.swift
//  QueroSerMBDesafio
//
//  Created by Felipe Perius on 06/11/20.
//

import Foundation
import UIKit

final class HomeDataScource: NSObject {
    typealias CompletionHandler = (AssetViewModel) -> ()
    typealias CompletionHandlerRefresh = () -> ()
    
    var viewModels: [AssetViewModel] = [] {
        didSet {
            refreshControl.endRefreshing()
            tableView?.reloadData()
        }
    }
    
    var refreshControl = UIRefreshControl()
    private weak var tableView: UITableView?
    private let completion: CompletionHandler
    private let completionRefresh: CompletionHandlerRefresh
    
    init(tableView: UITableView,  completion: @escaping CompletionHandler, completionRefresh: @escaping CompletionHandlerRefresh) {
        self.tableView = tableView
        self.completion = completion
        self.completionRefresh = completionRefresh
        super.init()
        registerCells()
        setupDataSource()
        setupPullToRefresh()
    }
    
    private func registerCells() {
        tableView?.registerReusableCell(AssetTableViewCell.self)
        tableView?.registerReusableCell(HeaderTableViewCell.self)
    }
    
    private func setupDataSource() {
        tableView?.dataSource = self
        tableView?.delegate = self
    }
    
    private func setupPullToRefresh() {
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.tintColor = ColorTheme.primary
        tableView?.refreshControl = refreshControl
    }
    
    @objc private func refresh() {
        completionRefresh()
    }
}

extension HomeDataScource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        if (indexPath.row == 0) {
            let cellHeader: HeaderTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
            return cellHeader
        } else {
            let cell: AssetTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
            let viewModel = viewModels[indexPath.row-1]
            cell.bind(viewModel: viewModel)
            cell.applyConfig(for: indexPath, numberOfCellsInSection: tableView.numberOfRows(inSection: indexPath.section))
            return cell
        }
    }
}

extension HomeDataScource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return 150
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        completion(viewModels[indexPath.row-1])
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
