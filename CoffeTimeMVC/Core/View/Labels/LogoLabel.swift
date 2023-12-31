//
//  LogoLabel.swift
//  CoffeTimeMVC
//
//  Created by AndrRum on 12.08.2023.
//

import Foundation


import UIKit

class LogoLabel: UIView {
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: Fonts.logoFont, size: 74)
        titleLabel.textColor = .white

        subtitleLabel.textAlignment = .center
        subtitleLabel.font = .systemFont(ofSize: 18)
        subtitleLabel.textColor = .white
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: topAnchor, constant: -5),
                   
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 50),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 120),
        ])
    }
    
    func setTitle(_ title: String, subtitle: String, isTypedSubtitle: Bool = true) {
        titleLabel.text = title
        
        if (isTypedSubtitle) {
            subtitleLabel.text = ""
            typeSubtitle(subtitle)
        } else {
            subtitleLabel.text = subtitle
        }
    }
    
    private func typeSubtitle(_ subtitle: String) {
        var delay: TimeInterval = 0.5
        for char in subtitle {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.subtitleLabel.text?.append(char)
            }
            delay += 0.1
        }
    }
}
