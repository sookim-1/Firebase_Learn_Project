//
//  UIScrollView+Ext.swift
//  FirebaseLearnProject
//
//  Created by sookim on 4/2/24.
//

import UIKit

extension UIScrollView {
    
    // Bonus: Scroll to bottom
    func scrollToBottom() {
        let bottomOffset = scrollBottomOffset()
        if bottomOffset.y > 0 {
            setContentOffset(bottomOffset, animated: true)
        }
    }

    private func scrollBottomOffset() -> CGPoint {
        return CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
    }

}
