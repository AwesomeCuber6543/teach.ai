//
//  WelcomeViewController.swift
//  HackMIT
//
//  Created by yahia salman on 9/17/23.
//

import UIKit

class WelcomeViewController: UIViewController {

    
    private let logo : UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(named: "teachailogo")
        return logo
    }()
    
    
    private let continueButton: UIButton = {
        let continueButton = UIButton()
        continueButton.backgroundColor = .white
        continueButton.setTitle("Welcome", for: .normal)
        continueButton.setTitleColor(.black, for: .normal)
        continueButton.layer.cornerRadius = 10
        return continueButton
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 243/255, green: 151/255, blue: 102/255, alpha: 1)
        self.setupUI()
        self.continueButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
    }
    
    
    private func setupUI(){
        
        self.view.addSubview(logo)
        self.view.addSubview(continueButton)
        
        
        logo.translatesAutoresizingMaskIntoConstraints = false
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.logo.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100),
            self.logo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            logo.heightAnchor.constraint(equalToConstant: 330),
            logo.widthAnchor.constraint(equalToConstant: 320),
            
            continueButton.centerXAnchor.constraint(equalTo: logo.centerXAnchor),
            continueButton.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 20),
            continueButton.heightAnchor.constraint(equalToConstant: 50),
            continueButton.widthAnchor.constraint(equalToConstant: 100)
            
        
        
        
        ])
        
    }
    
    @objc func didTapLogin(){
        let vc = ViewController()
        vc.modalPresentationStyle = .fullScreen // You can adjust the presentation style as needed
        present(vc, animated: true, completion: nil)
        
        
        
        
    }
    

}
