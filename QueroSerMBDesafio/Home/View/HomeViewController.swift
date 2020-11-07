//
//  HomeViewController.swift
//  QueroSerMBDesafio
//
//  Created by Felipe Perius on 05/11/20.
//
import UIKit
import NVActivityIndicatorView

final class HomeViewController: UIViewController {
    private let tableView  = UITableView()
    private let loadingView = NVActivityIndicatorView(frame: .zero)
    
    private lazy var dataSource: HomeDataScource = {
        let completion: HomeDataScource.CompletionHandler = { [weak self] in
            self?.didSelect(viewModel: $0)
        }
        
        let completionRefresh: HomeDataScource.CompletionHandlerRefresh = { [weak self] in
            self?.loadAssets()
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
        setupView()
        setupLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAssets()
    }
    
    // MARK: Private functions
    
    private func setupView() {
        view.accessibilityLabel = R.string.accessibility.assetList()
    }
    
    private func setupLayout() {
        view.addSubview(tableView, constraints: [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(loadingView, constraints: [
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.widthAnchor.constraint(equalToConstant: 50),
            loadingView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func loadAssets() {
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
        loadingView.startAnimating()
    }
    
    func hideLoading() {
        loadingView.stopAnimating()
    }
    
}
