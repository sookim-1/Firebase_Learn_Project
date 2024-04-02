//
//  HomeViewController.swift
//  FirebaseLearnProject
//
//  Created by sookim on 1/10/24.
//

import UIKit
import SnapKit
import Then

class HomeViewController: UIViewController {

    lazy private var tableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.reuseID)
        self.view.addSubview($0)
    }

    private let models: [CustomTableViewModel] = [CustomTableViewModel(title: "Firebase Cloud Messaging(FCM)"),
                                                  CustomTableViewModel(title: "Firebase Crashlytics"),
                                                  CustomTableViewModel(title: "FireStore")]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        self.setupConstraints()
    }

    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

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
            self.pushToPushViewController()
        case 1:
            self.pushToCrashlyticsViewController()
        case 2:
            self.pushToFireStoreViewController()
        default:
            print("클릭")
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

}

extension HomeViewController {

    private func pushToPushViewController() {
        let vc = PushViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    private func pushToCrashlyticsViewController() {
        let vc = CrashlyticsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    private func pushToFireStoreViewController() {
        let vc = FireStoreViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

