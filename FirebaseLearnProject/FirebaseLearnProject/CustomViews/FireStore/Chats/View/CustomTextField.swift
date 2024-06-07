//
//  CustomTextField.swift
//  FirebaseLearnProject
//
//  Created by sookim on 4/2/24.
//

import UIKit

final class CustomTextField: UITextField {
    
    init(placeholder: String, secure: Bool) {
        super.init(frame: .zero)
        
        isSecureTextEntry = secure
        borderStyle = .none
        font = UIFont.systemFont(ofSize: 16)
        textColor = .white
        keyboardAppearance = .dark
        attributedPlaceholder = NSAttributedString(string: placeholder,
                                                   attributes: [.foregroundColor : UIColor.white])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
