//
//  RegisterViewModel.swift
//  FirebaseLearnProject
//
//  Created by sookim on 4/2/24.
//

import Foundation

struct RegisterViewModel: AuthenticationProtocol {

    var email: String?
    var fullName: String?
    var userName: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false
            && fullName?.isEmpty == false
            && userName?.isEmpty == false
            && password?.isEmpty == false 
    }
    
}
