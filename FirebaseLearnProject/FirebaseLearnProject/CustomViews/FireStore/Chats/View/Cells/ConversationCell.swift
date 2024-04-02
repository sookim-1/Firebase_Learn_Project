//
//  ConversationCell.swift
//  FirebaseLearnProject
//
//  Created by sookim on 4/2/24.
//

import UIKit
import Kingfisher
import SnapKit
import Then

final class ConversationCell: UITableViewCell {

    static let reuseID = String(describing: ConversationCell.self)

    var conversation: Conversation? {
        didSet { configure() }
    }

    lazy private var stackView = UIStackView(arrangedSubviews: [usernameLabel, messageTextLabel]).then {
        $0.axis = .vertical
        $0.spacing = 4
    }

    lazy private var profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 50 / 2
    }
    
    lazy private var timeStampLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .darkGray
        $0.text = "2h ago"
    }

    lazy private var usernameLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 14)
    }
    
    lazy private var messageTextLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
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
         stackView,
         timeStampLabel
        ].forEach {
            self.contentView.addSubview($0)
        }
    }

    private func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(50)
        }

        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-16)
        }

        timeStampLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-12)
        }
    }

    private func configure() {
        guard let conversation = conversation 
        else { return }

        let viewModel = ConversationViewModel(conversation: conversation)
        
        usernameLabel.text = conversation.user.username
        messageTextLabel.text = conversation.message.text
        
        timeStampLabel.text = viewModel.timeStamp
        profileImageView.kf.setImage(with: viewModel.profileImageUrl)
    }

}


