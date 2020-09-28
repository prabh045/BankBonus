//
//  BankDetailCell.swift
//  BankBonus
//
//  Created by Prabhdeep Singh on 20/09/20.
//  Copyright © 2020 Prabh. All rights reserved.
//

import UIKit
import SafariServices

class BankDetailCell: UITableViewCell {
    
    @IBOutlet weak var bankLogoImage: UIImageView!
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var accountTypeLabel: UILabel!
    @IBOutlet weak var bonusAmountLabel: UILabel!
    @IBOutlet weak var bankDetailLabel: UILabel!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var validityLabel: UILabel!
    @IBOutlet weak var bacnkGroundView: UIView!
    
    
    var bankViewModel = BankViewModel()
    var bankLink: String?
    var closure: ((SFSafariViewController) -> Void)?
    var alertClosure: ((UIAlertController) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print("1 called")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
         print("2 called")
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
         print("3 called")
         setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setup() {
//        bankDetailLabel.layer.cornerRadius = 7
//        bankDetailLabel.layer.borderColor = UIColor.systemGray5.cgColor
//        bankDetailLabel.layer.borderWidth = 0.5
        validityLabel.isHidden = false
        applyButton.addTarget(self, action: #selector(openBankLink), for: .touchUpInside)
        applyButton.layer.cornerRadius = 10
        bankLogoImage.layer.cornerRadius = bankLogoImage.frame.height/2
        bankLogoImage.clipsToBounds = true
        bacnkGroundView?.layer.cornerRadius = 10
        bankDetailLabel.isUserInteractionEnabled = true
        setupBankDetalOnTap()
       // bacnkGroundView.backgroundColor = UIColor(
    }
    
    func configureCell(forIndex: Int) {
        bankNameLabel.text = self.bankViewModel.getBankName(forIndex: forIndex)
        accountTypeLabel.text = self.bankViewModel.getAccountType(index: forIndex)
        bonusAmountLabel.text = "$\(self.bankViewModel.getBonusAmount(index: forIndex))"
        bankDetailLabel.text = self.bankViewModel.getBankDetail(index: forIndex)
        
        if let validityDate = self.bankViewModel.getValidityDate(index: forIndex) {
            validityLabel.text = validityDate
        } else {
            validityLabel.isHidden = true
        }
        
        bankLink = self.bankViewModel.getBankLink(index: forIndex)
    }
    
    @objc func openBankLink() {
        guard let link = bankLink else {
            print("No Link is present")
            return
        }
        print("Link is \(link)")
        if let url = URL(string: link) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: url, configuration: config)
            closure?(vc)
        }
    }
    
    func setupBankDetalOnTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showAlert))
        tap.cancelsTouchesInView = false
        bankDetailLabel.addGestureRecognizer(tap)
    }
    
    @objc func showAlert() {
        let alert = UIAlertController(title: "Details", message: bankDetailLabel.text, preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(dismiss)
        alertClosure?(alert)
    }
    
}
