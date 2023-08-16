//
//  LoginView.swift
//  CoffeTimeMVC
//
//  Created by AndrRum on 11.08.2023.
//

import Foundation
import UIKit


protocol LoginViewDelegate: AnyObject {
  
}

class LoginView: UIView {
    
    private(set) var logoLabel = LogoLabel()
    private(set) var emailInput = EmailInput()
    private(set) var passwordInput = PasswordInput()
    private(set) var loginButton = BaseButton()
    private(set) var registrationButton = RegistrationButton()
    
    private let screenHeight = UIScreen.main.bounds.height
    private let screenWidth = UIScreen.main.bounds.width
    
    weak var delegate: LoginViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        opacityUIHandler(alphaValue: 0)
        configureLogo()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension LoginView {
    
    func opacityUIHandler(alphaValue: CGFloat) {
        self.logoLabel.alpha = alphaValue
        self.emailInput.alpha = alphaValue
        self.passwordInput.alpha = alphaValue
        self.loginButton.alpha = alphaValue
        self.registrationButton.alpha = alphaValue
    }
}


extension LoginView {
    
    func animConfigureUI() {
        let yOffset = screenHeight * 0.3

        let initialY = self.center.y - self.logoLabel.frame.size.height / 2 - yOffset
        self.logoLabel.center = CGPoint(x: self.center.x, y: self.center.y)

        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseInOut, animations: {
            self.logoLabel.center = CGPoint(x: self.center.x, y: initialY)
            
            self.opacityUIHandler(alphaValue: 1)
            self.emailInput.setFocus()
        })
    }
    
    func configureBackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "LoginBkg")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.insertSubview(backgroundImage, at: 0)

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = backgroundImage.bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        backgroundImage.layer.addSublayer(gradientLayer)
    }
    
    func configureLogo() {
        addSubview(logoLabel)
        logoLabel.setTitle("CoffeTime", subtitle: "территория кофе")
    }
    
    func configureInputs() {
        emailInput.translatesAutoresizingMaskIntoConstraints = false
        passwordInput.translatesAutoresizingMaskIntoConstraints = false
        passwordInput.placeholder = "Password"
            
        addSubview(emailInput)
        addSubview(passwordInput)
        
        NSLayoutConstraint.activate([
            emailInput.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            emailInput.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant: -40),
            emailInput.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            emailInput.heightAnchor.constraint(equalToConstant: 40),
                
            passwordInput.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            passwordInput.topAnchor.constraint(equalTo: emailInput.bottomAnchor, constant: 30),
            passwordInput.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            passwordInput.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configureLoginButton() {
        let buttonBottomOffset = -screenHeight * 0.20
        let buttonWidth = screenWidth * 0.8
        loginButton.title = "Далее"
        
        addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            loginButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: buttonBottomOffset),
        ])
    }
    
    func configureRegistrationButton() {
        let buttonBottomOffset = -screenHeight * 0.13
        let buttonWidth = screenWidth * 0.8
        
        addSubview(registrationButton)
        
        NSLayoutConstraint.activate([
            registrationButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            registrationButton.heightAnchor.constraint(equalToConstant: 50),
            registrationButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            registrationButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: buttonBottomOffset),
        ])
    }
}
