//
//  HeaderTableViewCell.swift
//  QueroSerMBDesafio
//
//  Created by Felipe Perius on 08/11/20.
//

import UIKit
import SnapKit

class HeaderTableViewCell: UITableViewCell,Reusable,CodableView {
    let headerView: UIView = {
        let statusView = UIView()
        statusView.backgroundColor = ColorTheme.navBarTint
        return statusView
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.ic_wallet()?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = ColorTheme.primary
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorTheme.primary
        label.text = R.string.app.titleHomeHeader()
        label.font = .boldSystemFont(ofSize:16)
        label.textAlignment = .center
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.app.messageHomeHeader()
        label.textColor = ColorTheme.primary
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func buildViews() {
        addSubview(headerView)
        headerView.addSubview(iconImageView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(messageLabel)
    }
    
    func configConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.trailing.leading.equalToSuperview()
        }
    }
}
