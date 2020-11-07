//
//  HomeViewController.swift
//  QueroSerMBDesafio
//
//  Created by Felipe Perius on 05/11/20.
//

import UIKit

final class HomeViewController: UIViewController {
    private let tableView  = UITableView()
    private let delegate: HomeDelegate
    private let assetService: AssetService
    
    // MARK: Initializer
    init(delegate: HomeDelegate,assetService: AssetService) {
        self.assetService = assetService
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
