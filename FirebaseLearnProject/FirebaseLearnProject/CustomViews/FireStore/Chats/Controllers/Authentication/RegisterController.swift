//
//  RegisterController.swift
//  FirebaseLearnProject
//
//  Created by sookim on 4/2/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import SnapKit
import Then
 
final class RegisterController: UIViewController {
    
    private var viewModel = RegisterViewModel()
    private var profileImage: UIImage?
    
    weak var delegate: AuthenticationDelegate?
    
    private lazy var stackView = UIStackView(arrangedSubviews: [emailContainerView, fullNameContainerView, userNameContainerView, passwordContainerView, signUpButton]).then {
        $0.axis = .vertical
        $0.spacing = 16
    }
    
    private lazy var plusPhotoButton = UIButton(type: .system).then {
        let image = UIImage(resource: .plusPhoto)
        $0.setImage(image, for: .normal)
        $0.tintColor = .white
        $0.imageView?.contentMode = .scaleAspectFill
        $0.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
    }
    
    private lazy var emailContainerView = InputContainerView(image: UIImage(systemName: "envelope"), textField: emailTextField)
    
    private lazy var fullNameContainerView = InputContainerView(image: UIImage(systemName: "person.fill"), textField: fullNameTextField)
    
    private lazy var userNameContainerView = InputContainerView(image: UIImage(systemName: "person.fill"), textField: userNameTextField)
    
    private lazy var passwordContainerView = InputContainerView(image: UIImage(systemName: "lock"), textField: passwordTextField)
    
    private lazy var emailTextField = CustomTextField(placeholder: "이메일", secure: false)
    
    private lazy var fullNameTextField = CustomTextField(placeholder: "닉네임", secure: false)
    
    private lazy var userNameTextField = CustomTextField(placeholder: "이름", secure: false)
    
    
    private lazy var passwordTextField = CustomTextField(placeholder: "비밀번호", secure: true)
    
    private lazy var signUpButton = UIButton(type: .system).then {
        $0.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 5
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
    }
    
    private lazy var alreadyHaveAnAccount = UIButton(type: .system).then {
        let attributedTitle = NSMutableAttributedString(string: "이미 계정이 있나요? ",
                                                        attributes: [.font : UIFont.systemFont(ofSize: 16),
                                                                     .foregroundColor: UIColor.white])
        
        attributedTitle.append(NSAttributedString(string: "로그인",
                                                  attributes: [.font : UIFont.boldSystemFont(ofSize: 16),
                                                               .foregroundColor: UIColor.white]))
        
        $0.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        
        $0.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureGradientLayer()
        addSubviews()
        setupConstraints()
        configureNotificationObservers()
    }
    
    private func addSubviews() {
        [plusPhotoButton,
        stackView,
         alreadyHaveAnAccount].forEach {
            self.view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        plusPhotoButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.width.equalTo(200)
            make.height.equalTo(200)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(plusPhotoButton.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
        }
        
        alreadyHaveAnAccount.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
            make.bottom.equalToSuperview().offset(-35)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
    
    @objc func handleRegistration() {
        guard
            let email = emailTextField.text,
            let fullname = fullNameTextField.text,
            let username = userNameTextField.text?.lowercased(),
            let password = passwordTextField.text,
            let profileImage = profileImage
            else { return }
        
        let credentials = RegistrationCredentials(email: email,
                                                 password: password,
                                                 fullname: fullname,
                                                 username: username,
                                                 profileImage: profileImage)
        
        showLoader(true, withText: "등록 중...")
            
        AuthService.shared.createUser(credentials: credentials) { (error) in
            if let error = error {
                self.showLoader(false)
                self.showError(error.localizedDescription)
            }
            
            self.showLoader(false)
            self.delegate?.authenticationComplete()
        }
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == fullNameTextField {
            viewModel.fullName = sender.text
        } else if sender == userNameTextField {
            viewModel.userName = sender.text
        } else {
            viewModel.password = sender.text
        }
        
        checkFormStatus()
    }
    
    @objc func handleSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    @objc func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func keyboardWillShow() {
        if view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 88
        }
    }
    
    @objc func keyboardWillHide() {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
    private func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
        userNameTextField.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

//MARK: - UIImagePickerControllerDelegate
extension RegisterController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as? UIImage
        profileImage = image
        plusPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3.0
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.contentMode = .scaleAspectFill
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
        
        dismiss(animated: true)
    }
}

    
//MARK: - AuthenticationControllerProtocol
extension RegisterController: AuthenticationControllerProtocol {

        func checkFormStatus() {
            if viewModel.formIsValid {
                signUpButton.isEnabled = true
                signUpButton.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            } else {
                signUpButton.isEnabled = false
                signUpButton.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            }
        }
}
