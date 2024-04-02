//
//  InputContainerView.swift
//  FirebaseLearnProject
//
//  Created by sookim on 4/2/24.
//

import UIKit
import SnapKit
import Then

final class InputContainerView: UIView {

    lazy private var imageView = UIImageView().then {
        $0.tintColor = .white
        $0.alpha = 0.87
    }

    lazy private var dividerView = UIView().then {
        $0.backgroundColor = .white
    }

    init(image: UIImage?, textField: UITextField) {
        super.init(frame: .zero)
        
        self.snp.makeConstraints { make in
            make.height.equalTo(50)
        }

        [imageView,
         textField,
        dividerView].forEach {
            self.addSubview($0)
        }

        self.imageView.image = image

        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.width.equalTo(24)
            make.height.equalTo(20)
        }

        textField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(imageView.snp.trailing).offset(8)
            make.bottom.equalToSuperview().offset(-9)
            make.trailing.equalToSuperview()
        }

        dividerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.height.equalTo(0.75)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
