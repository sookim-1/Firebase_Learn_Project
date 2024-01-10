//
//  PushViewController.swift
//  FirebaseLearnProject
//
//  Created by sookim on 1/10/24.
//

import UIKit
import SnapKit
import Then

class PushViewController: UIViewController {

    lazy private var tableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.reuseID)
        self.view.addSubview($0)
    }

    private let models: [CustomTableViewModel] = [CustomTableViewModel(title: "로컬 알림(Local Push)"),
                                                               CustomTableViewModel(title: "원격 알림(APNs Push)")]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        self.title = "Firebase Cloud Messaging"
        self.setupConstraints()
    }

    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

extension PushViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.reuseID, for: indexPath) as! TitleTableViewCell

        let item = self.models[indexPath.row]
        cell.configureCell(item: item)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.pushToLocalPushViewController()
        case 1:
            self.pushToServerPushViewController()
        default:
            print("클릭")
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

}

extension PushViewController {

    private func pushToLocalPushViewController() {
        let vc = LocalPushViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    private func pushToServerPushViewController() {
        let vc = ServerPushViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
