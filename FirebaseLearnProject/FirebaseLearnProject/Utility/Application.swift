//
//  Application.swift
//  FirebaseLearnProject
//
//  Created by sookim on 4/1/24.
//

import UIKit

struct Application {

    /// system에서 만든 window에 이벤트 처리를 위해 찾는 keyWindow
    /// iOS 13이전에는 window사용 iOS 15이전까지는 windows 이후부터는 connectedScenes사용
    static var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }

    static var window: UIWindow? {
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate

        return sceneDelegate!.window
    }

    /// 디바이스 스크린 객체
    static var screenScale: CGFloat  {
        return UIScreen.main.scale
    }

    /// 디바이스 스크린 크기
    static var screenSize: CGRect {
        return UIScreen.main.bounds
    }

    /// 디바이스 스크린이 작은 기기 인지 기준은 아이폰x
    static var isSmallScreenDevice: Bool {
        // 아이폰 x 이전 작은 기기들은 보통 높이가 736 이하여서 736로 설정
        return screenSize.height <= 736 ? true : false
    }

    // 노치면 44 아니라면 34
    static var safeAreaTopHeight: CGFloat {
        return self.keyWindow?.safeAreaInsets.top ?? 0.0
    }

    // 노치면 34 아니라면 0
    static var safeAreaBottomHeight: CGFloat {
        return self.keyWindow?.safeAreaInsets.bottom ?? 0.0
    }

}
