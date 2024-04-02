//
//  ProfileFooterView.swift
//  FirebaseLearnProject
//
//  Created by sookim on 4/2/24.
//

import UIKit
import SnapKit
import Then

protocol ProfileFooterViewDelegate: AnyObject {
    func handleLogout()
}

final class ProfileFooterView: UIView {

    weak var delegate: ProfileFooterViewDelegate?
    
    private lazy var logoutButton = UIButton(type: .system).then {
        $0.setTitle("로그아웃", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 18)
        $0.backgroundColor = .systemPink
        $0.layer.cornerRadius = 5
        $0.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
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
        self.addSubview(logoutButton)
    }

    private func setupConstraints() {
        logoutButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(32)
            make.centerX.equalToSuperview()
            make.trailing.equalToSuperview().offset(-32)
            make.height.equalTo(50)
        }
    }

    @objc func handleLogout() {
        delegate?.handleLogout()
    }

}
