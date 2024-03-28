//
//  NotificationService.swift
//  CustomNotificationServiceExt
//
//  Created by sookim on 3/28/24.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    // completion handler 저장
    var contentHandler: ((UNNotificationContent) -> Void)?
    // content 저장
    var bestAttemptContent: UNMutableNotificationContent?

    // 페이로드 내용 수정
    override func didReceive(_ request: UNNotificationRequest,
             withContentHandler contentHandler:
             @escaping (UNNotificationContent) -> Void) {
       self.contentHandler = contentHandler
       self.bestAttemptContent = (request.content.mutableCopy()
             as? UNMutableNotificationContent)

       // 암호화된 메시지 데이터를 디코딩
       let encryptedData = bestAttemptContent?.userInfo["ENCRYPTED_DATA"]
       if let bestAttemptContent = bestAttemptContent {
          if let data = encryptedData as? String {
            bestAttemptContent.body = data
          }
          else {
             bestAttemptContent.body = "(Encrypted)"
          }

          contentHandler(bestAttemptContent)
       }
    }

    // 시간이 만료되기 전에 반환하는 메서드
    override func serviceExtensionTimeWillExpire() {
       if let contentHandler = contentHandler,
          let bestAttemptContent = bestAttemptContent {

          bestAttemptContent.subtitle = "(Encrypted)"
          bestAttemptContent.body = ""
          contentHandler(bestAttemptContent)
       }
    }

}
