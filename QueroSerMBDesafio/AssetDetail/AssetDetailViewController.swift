//
//  AssetDetailViewController.swift
//  QueroSerMBDesafio
//
//  Created by Felipe Perius on 07/11/20.
//

import UIKit

class AssetDetailViewController: BaseViewController,CodableView {
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.emptyCoin()
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = ColorTheme.primary
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = ColorTheme.primary
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var extrasStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 15

        return stackView
    }()
    
    var viewModel: AssetViewModel?

    // MARK: Life Cycle
    
    override func loadView() {
        super.loadView()
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindExchangeAdapter()
    }
    override func viewWillAppear(_ animated: Bool) {
        //view.addGradientBackground(firstColor:iconImageView.image?.getPixelColor(pos: CGPoint(x: 100, y: 100)) ?? ColorTheme.backgroundMain, secondColor: .white)
        view.backgroundColor = ColorTheme.backgroundMain
    }
    // MARK: Private functions
    func configViews() {
        view.accessibilityLabel = R.string.accessibility.assetDetail()
    }
    
    func buildViews() {
        view.addSubview(stackView)
        view.addSubview(priceStackView)
        view.addSubview(extrasStackView)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(nameLabel)
        priceStackView.addArrangedSubview(priceLabel)
    }
    
    func configConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        priceStackView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.height.width.equalTo(70)
        }
        
        extrasStackView.snp.makeConstraints { make in
            make.top.equalTo(priceStackView.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }

    }
    private func bindExchangeAdapter() {
        guard let viewModel = viewModel else { return }
        if viewModel.icon == nil {
            iconImageView.image = R.image.emptyCoin()
        } else {
            iconImageView.kf.setImage(with: viewModel.icon)
        }
        nameLabel.text = viewModel.name
        priceLabel.text = R.string.app.price() + viewModel.price
        viewModel.allTitles.forEach {
            extrasStackView.addArrangedSubview(AssetExtraView(title: $0.0, date: $0.1))
        }
    }
}
