//
//  LoginController.swift
//  FirebaseLearnProject
//
//  Created by sookim on 4/2/24.
//

import UIKit
import SnapKit
import Then

protocol AuthenticationControllerProtocol {
    func checkFormStatus()
}

protocol AuthenticationDelegate: AnyObject {
    func authenticationComplete()
}

final class LoginController: UIViewController {
    
    private var viewModel = LoginViewModel()
    
    weak var delegate: AuthenticationDelegate?
    
    private lazy var iconImage = UIImageView().then {
        $0.image = UIImage(systemName: "bubble.right")
        $0.tintColor = .white
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton, homeButton]).then {
        $0.axis = .vertical
        $0.spacing = 16
    }
    
    private lazy var emailContainerView = InputContainerView(image: UIImage(systemName: "envelope"), textField: emailTextField)
    
    private lazy var passwordContainerView = InputContainerView(image: UIImage(systemName: "lock"), textField: passwordTextField)
    
    private lazy var loginButton = UIButton(type: .system).then {
        $0.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 5
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    }
    
    private lazy var homeButton = UIButton(type: .system).then {
        $0.backgroundColor = .systemBlue
        $0.setTitle("홈으로 이동", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 5
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        $0.addTarget(self, action: #selector(handleHome), for: .touchUpInside)
    }
    
    private lazy var emailTextField = CustomTextField(placeholder: "이메일", secure: false).then {
        $0.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
    }
    
    private lazy var passwordTextField = CustomTextField(placeholder: "비밀번호", secure: true).then {
        $0.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
    }
    
    private lazy var dontHaveAnAccountButton = UIButton(type: .system).then {
        let attributedTitle = NSMutableAttributedString(string: "계정이 없나요? ",
                                                        attributes: [.font : UIFont.systemFont(ofSize: 16),
                                                                     .foregroundColor: UIColor.white])
        
        attributedTitle.append(NSAttributedString(string: "회원가입",
                                                  attributes: [.font : UIFont.boldSystemFont(ofSize: 16),
                                                               .foregroundColor: UIColor.white]))
        
        $0.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        $0.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureGradientLayer()
        addSubviews()
        setupConstraints()
        configureUI()
    }
    
    private func addSubviews() {
        [iconImage,
        stackView,
         dontHaveAnAccountButton].forEach {
            self.view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        iconImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.width.equalTo(120)
            make.height.equalTo(120)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(iconImage.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
        }
        
        dontHaveAnAccountButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
            make.bottom.equalToSuperview().offset(-35)
        }
        
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        homeButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
    
    @objc func handleLogin() {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
            else { return }
        
       showLoader(true, withText: "로그인 중")
        
        AuthService.shared.logUserIn(withEmail: email, password: password) { [weak self] (result, error) in
            guard let self 
            else { return }
            
            if let error = error {
                self.showLoader(false)
                self.showError(error.localizedDescription)
                return
            }
            
            self.showLoader(false)
            self.delegate?.authenticationComplete()
        }
    }
    
    @objc func handleHome() {
        self.dismiss(animated: true) {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @objc func handleShowSignUp() {
        let registerVC = RegisterController()
        registerVC.delegate = delegate
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        
        checkFormStatus()
    }
    
    private func configureUI() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
}

// MARK: - AuthenticationControllerProtocol
extension LoginController: AuthenticationControllerProtocol {
    
    func checkFormStatus() {
        if viewModel.formIsValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        }
    }
    
}
