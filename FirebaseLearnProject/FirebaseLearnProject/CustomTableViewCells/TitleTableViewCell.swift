//
//  HomeDescriptionTableViewCell.swift
//  FirebaseLearnProject
//
//  Created by sookim on 1/10/24.
//

import UIKit
import SnapKit
import Then

class TitleTableViewCell: UITableViewCell {

    static let reuseID = String(describing: TitleTableViewCell.self)

    lazy private var titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .bold)
        $0.textColor = .systemBlue
        contentView.addSubview($0)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .none
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func configureCell(item: CustomTableViewModel) {
        self.titleLabel.text = item.title
    }

}
