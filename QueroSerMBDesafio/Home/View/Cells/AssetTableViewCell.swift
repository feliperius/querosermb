//
//  AssetTableViewCell.swift
//  QueroSerMBDesafio
//
//  Created by Felipe Perius on 06/11/20.
//

import UIKit
import SnapKit
import Kingfisher

class AssetTableViewCell: UITableViewCell,CodableView, Reusable {
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = R.image.emptyCoin()
        return imageView
    }()
    
    let containerView: UIView = {
        let backgroundView = UIView()
        return backgroundView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .black
        return label
    }()
    
    private let identifierLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .black
        label.textAlignment = .right
        
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = ColorTheme.backgroundMain
        label.text = R.string.app.price()
        return label
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = ColorTheme.blueMB
        label.textAlignment = .left
        label.text = R.string.app.showDetails().uppercased()
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var extrasStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    func bind(viewModel: AssetViewModel) {
        loadImageIcon(viewModel: viewModel)
        nameLabel.text = viewModel.name + "(\(viewModel.asssetId))"
        priceLabel.text = R.string.app.price() + viewModel.price
        detailLabel.textColor = iconImageView.image?.getPixelColor(pos: CGPoint(x: 100, y: 100)) ?? ColorTheme.backgroundMain
    }
    
    func loadImageIcon(viewModel: AssetViewModel) {
        iconImageView.kf.indicator?.startAnimatingView()
        iconImageView.kf.setImage(with: viewModel.icon, completionHandler:  { result in
            self.iconImageView.kf.indicator?.stopAnimatingView()
            switch result {
            case .success:
                self.detailLabel.textColor = self.iconImageView.image?.getPixelColor(pos: CGPoint(x: 100, y: 100)) ?? ColorTheme.backgroundMain
            case .failure:
                self.iconImageView.image = R.image.emptyCoin()
            }
        })
    }
    
    
    // MARK: Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private functions
    func configViews() {
        accessibilityLabel = R.string.accessibility.assetCell()
        selectionStyle = .none
    }
    
    func buildViews() {
        addSubview(stackView)
        addSubview(extrasStackView)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(priceLabel)
        extrasStackView.addArrangedSubview(detailLabel)
    }
    
    func configConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.height.width.equalTo(25)
        }
        detailLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        extrasStackView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    
    func useRoundedSectionCorners() {
        selectionStyle = .none
        self.separatorInset = UIEdgeInsets(top: 0, left: self.separatorInset.left, bottom: 0, right: 0)
    }
}
