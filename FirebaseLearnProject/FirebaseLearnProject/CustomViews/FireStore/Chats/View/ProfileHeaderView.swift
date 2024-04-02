//
//  ProfileHeaderView.swift
//  FirebaseLearnProject
//
//  Created by sookim on 4/2/24.
//

import UIKit
import Kingfisher
import SnapKit
import Then

protocol ProfileHeaderViewDelegate: AnyObject {
    func dismissController()
}

final class ProfileHeaderView: UIView {

    var user: User? {
        didSet { configureUserWithData() }
    }
    
    weak var delegate: ProfileHeaderViewDelegate?

    lazy private var stackView = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel]).then {
        $0.axis = .vertical
        $0.spacing = 4
    }

    lazy private var dismissButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        $0.tintColor = .white
    }
     
    lazy private var profileImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.borderWidth = 4.0
        $0.layer.cornerRadius = 200 / 2
    }

    lazy private var fullnameLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 20)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.text = "Sergey Borovkov"
    }
     
    lazy private var usernameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.text = "@roba"
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func handleDismiss() {
        delegate?.dismissController()
    }

    private func configureUI() {
        configureGradientLayer()

    }

    private func addSubviews() {
        [profileImageView,
        stackView,
         dismissButton].forEach {
            self.addSubview($0)
        }
    }

    private func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(200)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(96)
        }

        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(profileImageView.snp.bottom).offset(16)
        }

        dismissButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(44)
            make.leading.equalToSuperview().offset(12)
            make.width.equalTo(48)
            make.height.equalTo(48)
        }

        dismissButton.imageView?.snp.makeConstraints { make in
            make.width.equalTo(22)
            make.height.equalTo(22)
        }
    }

    private func configureGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemPurple.cgColor, UIColor.systemPink.cgColor]
        gradient.locations = [0, 1]
        layer.addSublayer(gradient)
        gradient.frame = bounds
    }
    
    private func configureUserWithData() {
        guard
            let user = user,
            let url = URL(string: user.profileImageUrl)
            else { return }
        
        fullnameLabel.text = user.fullname
        usernameLabel.text = "@" + user.username
        profileImageView.kf.setImage(with: url)
    }
    
}
