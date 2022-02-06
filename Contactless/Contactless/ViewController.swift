//
//  ViewController.swift
//  Contactless
//
//  Created by Madhur Jodhwani on 03/02/22.
//

import UIKit
import FlagPhoneNumber

class ViewController: UIViewController {


    @IBOutlet var phoneNumberTextField: FPNTextField!
    
    @IBOutlet var PrintMessages: UILabel!

    @IBAction func openWhatsApp(_ sender: UIButton) {
        let url=URL(string: "https://api.whatsapp.com/send?phone="+phoneNumberTextField.getFormattedPhoneNumber(format: .E164)!)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    var listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "In Simple View"
        PrintMessages.text="Welcome to Contactless"
        view.backgroundColor = UIColor.white

        // To use your own flag icons, uncommment the line :
        //        Bundle.FlagIcons = Bundle(for: SimpleViewController.self)
        
        phoneNumberTextField.borderStyle = .roundedRect
//        phoneNumberTextField.pickerView.showPhoneNumbers = false

        listController.setup(repository: phoneNumberTextField.countryRepository)

        listController.didSelect = { [weak self] country in
            self?.phoneNumberTextField.setFlag(countryCode: country.code)
        }

        phoneNumberTextField.delegate = self
        phoneNumberTextField.font = UIFont.systemFont(ofSize: 14)

        // Custom the size/edgeInsets of the flag button
        phoneNumberTextField.flagButtonSize = CGSize(width: 35, height: 35)
        phoneNumberTextField.flagButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

        

        // The placeholder is an example phone number of the selected country by default. You can add your own placeholder :
        phoneNumberTextField.displayMode = .list // .picker by default
        phoneNumberTextField.flagButtonSize = CGSize(width: 60, height: 60)
        // Set the flag image with a region code
        phoneNumberTextField.setFlag(countryCode: .IN)
        phoneNumberTextField.hasPhoneNumberExample = false // true by default
        phoneNumberTextField.placeholder = "Phone Number"
        
        view.addSubview(phoneNumberTextField)

        phoneNumberTextField.center = view.center
    }

    private func getCustomTextFieldInputAccessoryView(with items: [UIBarButtonItem]) -> UIToolbar {
        let toolbar: UIToolbar = UIToolbar()

        toolbar.barStyle = UIBarStyle.default
        toolbar.items = items
        toolbar.sizeToFit()

        return toolbar
    }

    @objc func dismissCountries() {
        listController.dismiss(animated: true, completion: nil)
    }
        

      

   
}

extension ViewController: FPNTextFieldDelegate {

    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        textField.rightViewMode = .always

        print(
            isValid,
            textField.getFormattedPhoneNumber(format: .E164) ?? "E164: nil"
        )
    }

    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        print(name, dialCode, code)
    }


    func fpnDisplayCountryList() {
        let navigationViewController = UINavigationController(rootViewController: listController)

        listController.title = "Countries"
        listController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissCountries))

        self.present(navigationViewController, animated: true, completion: nil)
    }
}
