//
//  FireStoreViewController.swift
//  FirebaseLearnProject
//
//  Created by sookim on 4/1/24.
//

import UIKit
import SnapKit
import Then

final class FireStoreViewController: UIViewController {

    lazy private var chatExampleButton = UIButton().then {
        $0.backgroundColor = .systemGray5
        $0.setTitle("채팅화면 예시", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.setTitleColor(.systemRed, for: .highlighted)
        $0.addTarget(self, action: #selector(touchedChatExampleButton), for: .touchUpInside)
        view.addSubview($0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        self.title = "FireStore (실시간 데이터베이스)"
        self.setupConstraints()
    }
    
    private func setupConstraints() {
        chatExampleButton.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(50)
            make.center.equalToSuperview()
        }
    }

    @objc private func touchedChatExampleButton() {
        let vc = ConversationsController()

        self.navigationController?.pushViewController(vc, animated: true)
    }

}
