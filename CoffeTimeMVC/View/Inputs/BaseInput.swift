//
//  SetupInputViewHelper.swift
//  CoffeTimeMVC
//
//  Created by AndrRum on 17.08.2023.
//

import Foundation
import UIKit

class BaseInput: UIView {
    
    private let textField: UITextField
    private let bottomBorder: UIView
    private let iconView: UIView
       
    init(frame: CGRect, textField: UITextField, bottomBorder: UIView, iconView: UIView) {
        self.textField = textField
        self.bottomBorder = bottomBorder
        self.iconView = iconView
           
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BaseInput {
    
    func configureUI(trailingView: UIView) {
           addSubview(textField)
           addSubview(bottomBorder)
           addSubview(iconView)
           
           textField.tintColor = .white
           
           let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 4, height: 0))
           textField.leftView = leftView
           textField.leftViewMode = .always

           NSLayoutConstraint.activate([
               textField.topAnchor.constraint(equalTo: topAnchor, constant: 5),
               textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
               textField.trailingAnchor.constraint(equalTo: trailingView.leadingAnchor, constant: -10),
               textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 4),
                       
               bottomBorder.topAnchor.constraint(equalTo: textField.bottomAnchor),
               bottomBorder.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
               bottomBorder.trailingAnchor.constraint(equalTo: trailingView.trailingAnchor),
               bottomBorder.heightAnchor.constraint(equalToConstant: 1),
               
               trailingView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
               trailingView.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
               
               iconView.widthAnchor.constraint(equalToConstant: 24),
               iconView.heightAnchor.constraint(equalToConstant: 24),
           ])
    }
    
    func isValidInput(validationStrategy: ValidationStrategy) -> Bool {
        let isValid = updateValidationState(validationStrategy: validationStrategy)
        return isValid
    }
}

private extension BaseInput {
    
    func updateValidationState(validationStrategy: ValidationStrategy) -> Bool {
        guard let text = textField.text else { return false }
                    
        let isValid = validationStrategy.isValid(text: text)
        
        if isValid {
            configureValidationUI(borderColor: .lightGray, textColor: .white, iconColor: .white)
        } else {
            configureValidationUI(borderColor: .red, textColor: .systemRed, iconColor: .red)
        }
        
        return isValid
    }

    
    func configureValidationUI(borderColor: UIColor, textColor: UIColor, iconColor: UIColor) {
        bottomBorder.backgroundColor = borderColor
        let attributedText = NSAttributedString(string: textField.text ?? "", attributes: [
                NSAttributedString.Key.foregroundColor: textColor,
        ])
        textField.attributedText = attributedText
        textField.textColor = textColor
        iconView.tintColor = iconColor
    }
}
