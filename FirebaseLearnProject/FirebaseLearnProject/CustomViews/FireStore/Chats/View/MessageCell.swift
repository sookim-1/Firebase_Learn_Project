//
//  MessageCell.swift
//  FirebaseLearnProject
//
//  Created by sookim on 4/2/24.
//

import UIKit
import Kingfisher
import SnapKit
import Then

final class MessageCell: UICollectionViewCell {

    static let reuseID = String(describing: MessageCell.self)

    var message: Message? {
        didSet {
            configure()
        }
    }
    
    lazy private var profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 32 / 2
    }
    
    lazy private var textView = UITextView().then {
        $0.backgroundColor = .clear
        $0.font = .systemFont(ofSize: 16)
        $0.isScrollEnabled = false
        $0.textColor = .white
        $0.text = "Some message"
        $0.isEditable = false
    }
    
    lazy private var bubbleContainer = UIView().then {
        $0.backgroundColor = .systemPurple
        $0.layer.cornerRadius = 12
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        [profileImageView,
         bubbleContainer].forEach {
            self.contentView.addSubview($0)
        }

        self.bubbleContainer.addSubview(self.textView)
    }

    private func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(4)
            make.width.equalTo(32)
            make.height.equalTo(32)
        }

        bubbleContainer.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.lessThanOrEqualTo(250)
        }

        textView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-4)
        }
    }

    private func configure() {
        guard let message = message 
        else { return }

        let viewModel = MessageViewModel(message: message)
        
        bubbleContainer.backgroundColor = viewModel.messageBackgroundColor
        textView.textColor = viewModel.messageTextColor
        textView.text = message.text
        
        if viewModel.leftAnchorActive {
            bubbleContainer.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                make.leading.equalTo(profileImageView.snp.trailing).offset(12)
                make.bottom.equalToSuperview()
                make.width.lessThanOrEqualTo(250)
            }
        } else {
            bubbleContainer.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                make.trailing.equalToSuperview().offset(-12)
                make.bottom.equalToSuperview()
                make.width.lessThanOrEqualTo(250)
            }
        }
        
        profileImageView.isHidden = viewModel.shouldHideProfileImage
        profileImageView.kf.setImage(with: viewModel.profileImageUrl)
    }

}
