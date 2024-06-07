//
//  ProfileViewModel.swift
//  FirebaseLearnProject
//
//  Created by sookim on 4/2/24.
//

import Foundation

enum ProfileViewModel: Int, CaseIterable {
    // here we can realize static content, which we can add in one place
    case accountInfo
    case settings
    
    var description: String {
        switch self {
        case .accountInfo: return "계정 정보"
        case .settings: return "설정"
        }
    }
    
    var iconImageName: String {
        switch self {
        case .accountInfo: return "person.circle"
        case .settings: return "gear"
        }
    }
}
