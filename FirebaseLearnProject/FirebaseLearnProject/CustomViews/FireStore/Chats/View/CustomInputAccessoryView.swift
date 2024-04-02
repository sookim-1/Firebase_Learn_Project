//
//  CustomInputAccessoryView.swift
//  FirebaseLearnProject
//
//  Created by sookim on 4/2/24.
//

import UIKit
import SnapKit
import Then

protocol CustomInputAccessoryViewDelegate: AnyObject {
    func inputView(_ inputView: CustomInputAccessoryView, wantsToSend message: String)
}

final class CustomInputAccessoryView: UIView {

    weak var delegate: CustomInputAccessoryViewDelegate?
    
    private lazy var messageInputTextView = UITextView().then {
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.isScrollEnabled = false
    }
    
    private lazy var sendButton = UIButton(type: .system).then {
        $0.setTitle("Send", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        $0.setTitleColor(.systemPurple, for: .normal)
        $0.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
    }
    
    lazy private var placeholderLabel = UILabel().then {
        $0.text = "Enter message..."
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = .lightGray
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = .flexibleHeight
        backgroundColor = .white
        
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 10
        layer.shadowOffset = .init(width: 0, height: -8)
        layer.shadowColor = UIColor.lightGray.cgColor

        self.addSubviews()
        self.setupConstraints()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleTextInputChange),
                                               name: UITextView.textDidChangeNotification,
                                               object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }

    private func addSubviews() {
        [sendButton,
        messageInputTextView,
         placeholderLabel].forEach {
            self.addSubview($0)
        }
    }

    private func setupConstraints() {
        sendButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().offset(-8)
            make.width.equalTo(50)
            make.trailing.equalTo(50)
        }

        messageInputTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(8)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-8)
            make.trailing.equalTo(sendButton.snp.leading).offset(-8)
        }

        placeholderLabel.snp.makeConstraints { make in
            make.leading.equalTo(messageInputTextView.snp.leading).offset(4)
            make.centerY.equalTo(messageInputTextView.snp.centerY)
        }
    }

    @objc func handleSendMessage() {
        guard let text = messageInputTextView.text 
        else { return }

        delegate?.inputView(self, wantsToSend: text)
    }
    
    @objc func handleTextInputChange() {
        placeholderLabel.isHidden = !self.messageInputTextView.text.isEmpty
    }

    func clearMessageText() {
        messageInputTextView.text = nil
        placeholderLabel.isHidden = false
    }

}
