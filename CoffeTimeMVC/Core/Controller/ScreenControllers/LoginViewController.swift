//
//  LoginViewController.swift
//  CoffeTimeMVC
//
//  Created by AndrRum on 08.08.2023.
//

import UIKit

class LoginViewController: UIViewController, CommonLifecycleMethods  {
    
    private var loginView = LoginView()
    private var loginService = UserDataService()
    private let regViewController = RegistrationViewController()
    private let errorViewController = ErrorViewController()
    
    override func loadView() {
        super.loadView()
        setupLoginView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginView.configureEmailInput()
        self.loginView.configurePassInput()
        self.loginView.configureLoginButton()
        self.loginView.configureRegistrationButton()
    }
       
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barStyle = .black
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        commonViewWillAppear()
        loginView.animConfigureUI()
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        commonViewWillDisappear()
    }
    
    private func setupLoginView() {
        loginView.delegate = self
        self.view = loginView
        
        loginView.configureBackground()
    }
    
    @objc func handleHttpErrorStatus500() {
        showHttpErrorView(from: self, errorViewController: errorViewController)
        self.loginView.loginButton.stopLoader()
        //self.loginService.saveResponse(sessionId: "Api normalno")
    }
}


extension LoginViewController: LoginViewDelegate {
    
    func navigateToRegistrationScreen() {
        self.navigationController?.navigationBar.tintColor = .white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        show(regViewController, sender: self)
    }
    
    func loginButtonTapped() {
        let isEmailValid = loginView.isEmailValid()
        let isPassValid = loginView.isPasswordValid()
        let email = loginView.getEmailValue()
        let pass = loginView.getPasswordValue()
               
        if isEmailValid && isPassValid {
            loginView.loginButton.startLoader()
            authenticateAndNavigate(url: ApiEndpoints.login, email: email, password: pass, service: loginService) { sessionId in
                self.loginView.loginButton.stopLoader()
                if sessionId != nil {
                    self.navigateToCafeListScreen()
                }
            }
        } else {
            print("Invalid email or password.")
        }
    }
}
