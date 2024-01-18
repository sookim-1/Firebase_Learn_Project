//
//  FirebaseUtility.swift
//  FirebaseLearnProject
//
//  Created by sookim on 1/18/24.
//

import UIKit

struct FirebaseUtility {

    static let shared = FirebaseUtility()

    func showToast(view: UIView, _ message : String, withDuration: Double, delay: Double) {
        let toastLabel = UILabel(frame: CGRect(x: (view.frame.size.width / 2) - 75, y: (view.frame.size.height - 100), width: 200, height: 45))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont.systemFont(ofSize: 14.0)
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 16
        toastLabel.clipsToBounds  =  true

        view.addSubview(toastLabel)

        UIView.animate(withDuration: withDuration, delay: delay, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }

    func loadAppSetting() {
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
        }
    }

}
