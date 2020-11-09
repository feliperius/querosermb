//
//  HomeViewController.swift
//  QueroSerMBDesafio
//
//  Created by Felipe Perius on 05/11/20.
//
import UIKit
import SnapKit

final class HomeViewController: BaseViewController,CodableView {
    private let tableView  = UITableView()
    private lazy var dataSource: HomeDataScource = {
        let completion: HomeDataScource.CompletionHandler = { [weak self] in
            self?.didSelect(viewModel: $0)
        }
        
        let completionRefresh: HomeDataScource.CompletionHandlerRefresh = { [weak self] in
            self?.pullToRefresh()
        }
        
        let dataSource = HomeDataScource(tableView: tableView,
                                                 completion: completion,
                                                 completionRefresh: completionRefresh)
    
        return dataSource
    }()
    
    private lazy var interactor: HomeInteractor = {
        return HomeInteractor(apiClientService: assetService, presenter: self)
    }()
    
    private let assetService: AssetService
    private let delegate: HomeDelegate

    // MARK: Initializer
    init(delegate: HomeDelegate,assetService: AssetService) {
        self.assetService = assetService
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    override func loadView() {
        super.loadView()
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAssets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configMenuButton()
        configFilterButton()
    }
    
    // MARK: CodableView functions
    
    func configViews() {
        view.accessibilityLabel = R.string.accessibility.assetList()
        view.backgroundColor = ColorTheme.navBarTint
        title = R.string.app.homeTitle()
        tableView.backgroundColor = ColorTheme.backgroundMain
    }
    
    
    func buildViews() {
        view.addSubview(tableView)
    }
    
    func configConstraints() {
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    // MARK: private functions
   
    private func loadAssets() {
        showLoading()
        interactor.loadAssets()
    }
    
    private func pullToRefresh() {
        interactor.loadAssets()
    }
    
    private func didSelect(viewModel: AssetViewModel) {
        delegate.didSelect(viewModel: viewModel)
    }
    
}
extension HomeViewController: HomePresenter {
    func fetchAssets(viewModels: [AssetViewModel]) {
        self.dataSource.viewModels = viewModels
    }
    
    func onError(message: String) {
        let alert = UIAlertController(title:R.string.app.error(), message: message, preferredStyle: .alert)
        self.present(alert, animated: true)
    }
    
    func showLoading() {
        self.displayLoading()
    }
    
    func hideLoading() {
        self.dismissLoading()
        self.dataSource.refreshControl.endRefreshing()
    }
}
extension UITableViewCell {
    func applyConfig(for indexPath: IndexPath, numberOfCellsInSection: Int) {
        switch indexPath.row {
        case numberOfCellsInSection - 1:
            self.roundCorners(.bottom, radius: 15)
            
            if numberOfCellsInSection == 1 {
                self.roundCorners(.all, radius: 15)
            }
        case 0:
            self.roundCorners(.top, radius: 15)
            
        default:
            self.roundCorners(.all, radius: 0)
        }
        
        if indexPath.row != 0 {
            let bottomBorder = CALayer()
            
            bottomBorder.frame = CGRect(x: 16.0,
                                        y: 0,
                                        width: self.contentView.frame.size.width - 16,
                                        height: 0.2)
            bottomBorder.backgroundColor = UIColor(white: 0.8, alpha: 1.0).cgColor
            self.contentView.layer.addSublayer(bottomBorder)
        }
    }
}
