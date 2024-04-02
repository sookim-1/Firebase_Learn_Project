//
//  ProfileCell.swift
//  FirebaseLearnProject
//
//  Created by sookim on 4/2/24.
//

import UIKit
import SnapKit
import Then

final class ProfileCell: UITableViewCell {

    static let reuseID = String(describing: ProfileCell.self)

    var viewModel: ProfileViewModel? {
        didSet { configure() }
    }
    
    private lazy var iconView = UIView().then {
        $0.backgroundColor = .systemPurple
        $0.layer.cornerRadius = 40 / 2
    }

    lazy private var stackView = UIStackView(arrangedSubviews: [iconView, titleLabel]).then {
        $0.axis = .horizontal
        $0.spacing = 8
    }

    lazy private var iconImage = UIImageView().then {
        $0.backgroundColor = .systemPurple
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.tintColor = .white
    }
    
    lazy private var titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        self.contentView.addSubview(self.stackView)
        self.iconView.addSubview(self.iconImage)
    }

    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
        }

        iconView.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.height.equalTo(40)
        }

        iconImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(28)
            make.height.equalTo(28)
        }
    }

    private func configure() {
        guard let viewModel = viewModel 
        else { return }

        iconImage.image = UIImage(systemName: viewModel.iconImageName)
        titleLabel.text = viewModel.description
    }

}
