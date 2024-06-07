//
//  UITextView+Ext.swift
//  FirebaseLearnProject
//
//  Created by sookim on 4/1/24.
//

import UIKit

extension UITextView {

    func setLineAndLetterSpacing(_ text: String, font: UIFont) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5

        let attributedString = NSMutableAttributedString(string: text)

        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(0), range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.font, value: font, range: NSRange(location: 0, length: attributedString.length))

        self.attributedText = attributedString
    }

}

