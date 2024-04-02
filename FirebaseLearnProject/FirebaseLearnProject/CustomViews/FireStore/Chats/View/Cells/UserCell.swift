//
//  UserCell.swift
//  FirebaseLearnProject
//
//  Created by sookim on 4/2/24.
//

import UIKit
import Kingfisher
import SnapKit
import Then

final class UserCell: UITableViewCell {

    static let reuseID = String(describing: UserCell.self)

    var user: User? {
        didSet {
            configure()
        }
    }

    lazy private var stackView = UIStackView(arrangedSubviews: [usernameLabel, fullnameLabel]).then {
        $0.axis = .vertical
        $0.spacing = 2
    }

    lazy private var profileImageView = UIImageView().then {
        $0.backgroundColor = .systemPurple
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 56 / 2
    }

    lazy private var usernameLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.text = "SpiderMan"
    }

    lazy private var fullnameLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .lightGray
        $0.text = "Peter Parker"
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
        [profileImageView,
         stackView].forEach {
            self.contentView.addSubview($0)
        }
    }

    private func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
            make.height.equalTo(56)
            make.width.equalTo(56)
        }

        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
        }
    }

    private func configure() {
        guard
            let user = user,
            let url = URL(string: user.profileImageUrl)
        else { return }
        
        fullnameLabel.text = user.fullname
        usernameLabel.text = user.username
        profileImageView.kf.setImage(with: url)
    }
}
