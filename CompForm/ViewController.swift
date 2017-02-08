//
//  ViewController.swift
//  CompForm
//
//  Created by My Star on 2/3/17.
//  Copyright © 2017 Silver Star. All rights reserved.
//

import UIKit
import TTGSnackbar
import CoreData

class ViewController: UIViewController, UITextFieldDelegate, KeyboardDelegate {

    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var btnEnter: UIButton!
    
    @IBOutlet weak var checkBox: CheckBox!
    
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfNumber: UITextField!
    @IBOutlet weak var tfAge: UITextField!
    @IBOutlet weak var tfHowMany: UITextField!
    @IBOutlet weak var tfPostCode: UITextField!
    
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btn7: UIButton!
    @IBOutlet weak var btn8: UIButton!
    
    
    var imageName : String?
    var name : String?
    var email : String?
    var number : String?
    var age : String?
    var howMany : String?
    var postCode : String?
    
    var activeTextField = UITextField()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initUI();
        
        initializeCustomKeyboard()
    }
    func initializeCustomKeyboard() {
        // initialize custom keyboard
        let keyboardView = Keyboard(frame: CGRect(x: 0, y: 0, width: 0, height: 300))
        
        // the view controller will be notified by the keyboard whenever a key is tapped
        keyboardView.delegate = self
        
        // required for backspace to work
        self.tfNumber.delegate = self
        self.tfAge.delegate = self
        self.tfPostCode.delegate = self
        self.tfHowMany.delegate = self
        
        // replace system keyboard with custom keyboard
        self.tfNumber.inputView = keyboardView
        self.tfAge.inputView = keyboardView
        self.tfPostCode.inputView = keyboardView
        self.tfHowMany.inputView = keyboardView
    }
    
    func initUI(){
        self.btnLogin.layer.shadowColor = UIColor.darkGray.cgColor
        self.btnLogin.layer.shadowOffset = CGSize.init(width: 5, height: 5)
        self.btnLogin.layer.shadowOpacity = 1.0
        
        self.btnEnter.layer.shadowColor = UIColor.darkGray.cgColor
        self.btnEnter.layer.shadowOffset = CGSize.init(width: 5, height: 5)
        self.btnEnter.layer.shadowOpacity = 1.0
        
        self.btnEnter.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func checkBoxTapped(_ sender: Any){
        
        self.checkBox.isChecked = !self.checkBox.isChecked
        
        if self.checkBox.isChecked {
            self.btnEnter.isHidden = false
        }else{
            self.btnEnter.isHidden = true
        }
    }
    
    //MARK: button actions
    @IBAction func btnEnterTapped(_ sender: Any) {
        
        self.name = self.tfName.text
        self.email = self.tfEmail.text
        self.number = self.tfNumber.text
        self.age = self.tfAge.text
        self.howMany = self.tfHowMany.text
        self.postCode = self.tfPostCode.text
        
        if self.checkEmptyFields(){
            return
        }
        
        self.saveUserData();
        
        self.clearUserData();
    }
    
    func clearUserData(){
        self.name = ""
        self.email = ""
        self.age = ""
        self.number = ""
        self.howMany = ""
        self.imageName = nil
        self.postCode = ""
        
        self.tfName.text = ""
        self.tfEmail.text = ""
        self.tfAge.text = ""
        self.tfNumber.text = ""
        self.tfHowMany.text = ""
        self.tfPostCode.text = ""
        
        self.setAllButtonsToX()
        
        self.checkBox.isChecked = false
        self.btnEnter.isHidden = true
    }
    
    func checkEmptyFields() -> Bool{
        if (self.name?.isEmpty)! {
            showSnackBar(msg: SnackbarMessage.nameEmpty);
            return true
        }
        
        if (self.email?.isEmpty)! {
            showSnackBar(msg: SnackbarMessage.emailEmpty);
            return true
        }
        if self.isValidEmailAddress(emailAddressString:self.email!) == false {
            showSnackBar(msg: SnackbarMessage.emailInvalid);
            return true
        }
        
        if (self.number?.isEmpty)! {
            showSnackBar(msg: SnackbarMessage.numberEmpty);
            return true
        }
        if self.isValidNumber(numberString:self.number!) == false {
            showSnackBar(msg: SnackbarMessage.numberInvalid);
            return true
        }
        
        if (self.age?.isEmpty)! {
            showSnackBar(msg: SnackbarMessage.ageEmpty);
            return true
        }
        if self.isValidAge(age:self.age!) == false {
            showSnackBar(msg: SnackbarMessage.ageInvalid);
            return true
        }
        if (self.postCode?.isEmpty)! {
            showSnackBar(msg: SnackbarMessage.postCodeEmpty);
            return true
        }
        if self.isValidPostCode(postCode: self.postCode!) == false {
            showSnackBar(msg: SnackbarMessage.postCodeInvalid)
            return true
        }
        
        if self.imageName == nil {
            showSnackBar(msg: SnackbarMessage.imageEmpty);
            return true
        }
        
        if (self.howMany?.isEmpty)! {
            showSnackBar(msg: SnackbarMessage.howmanyEmpty);
            return true
        }
        if self.isValidNumber(numberString:self.howMany!) == false {
            showSnackBar(msg: SnackbarMessage.howmanyInvalid);
            return true
        }

        
        return false
    }
    
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    func isValidAge(age:String) -> Bool {
        let nAge:Int? = Int(age)
        if nAge == nil{
            return false
        }
        if nAge!>0 && nAge!<123 {
            return true
        }
        
        return false
    }
    func isValidPostCode(postCode:String) -> Bool {
        
        if postCode.characters.count == 4 {
            return true
        }
        
        return false
    }
    
    func isValidNumber(numberString: String) -> Bool {
        
        let num = Int(numberString)
        if num != nil{
            return true
        }else{
            return false
        }
    }
    
    func showSnackBar(msg:String!){
        let snackBar = TTGSnackbar.init(message: msg, duration: .middle)
        snackBar.show()
    }
    
    @IBAction func btnLoginTapped(_ sender: Any) {
        let alertController = UIAlertController.init(title: "Login", message: "Enter your credentials", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Name"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Password"
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            
        }))
        alertController.addAction(UIAlertAction(title: "Login", style: .default, handler: { (action) in
            let tfName = alertController.textFields![0] as UITextField
            let tfPassword = alertController.textFields![1] as UITextField
            
            if tfName.text == "a" && tfPassword.text == "b"{
                self.gotoAdmin();
            }
            
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func gotoAdmin(){
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let admin = storyboard.instantiateViewController(withIdentifier: "AdminViewController")
        self.present(admin, animated: true) { 
            
        }
    }
    //MARK: - TextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var result = true
        
        if textField == self.tfPostCode {
            let maxLength = 4
            let text = textField.text
            let newLength = (text?.characters.count)! + string.characters.count - range.length
            if newLength>maxLength {
                result = false
            }
            
        }
        
        return result
    }
    func textFieldDidBeginEditing(_ textFieldUser: UITextField) {
        self.activeTextField = textFieldUser
    }
    
    //MARK: Keyboard delegate
    func keyWasTapped(_ character: String) {
        activeTextField.insertText(character)
    }
    
    func backspace() {
        activeTextField.deleteBackward()
    }
    
    func done(){
        activeTextField.resignFirstResponder()
    }
    
    //MARK: button actions on 8 images
    @IBAction func btnTapped(_ sender: Any){
        guard let button = sender as? UIButton else {
            return
        }
        
        self.setAllButtonsToX()
        let image = UIImage(named: "o")! as UIImage
        button.setImage(image, for: .normal)
        
        switch button.tag {
        case 1:
            self.imageName = "image 1"
            break
            
        case 2:
            self.imageName = "image 2"
            break
            
        case 3:
            self.imageName = "image 3"
            break
            
        case 4:
            self.imageName = "image 4"
            break
            
        case 5:
            self.imageName = "image 5"
            break
            
        case 6:
            self.imageName = "image 6"
            break
            
        case 7:
            self.imageName = "image 7"
            break
            
        case 8:
            self.imageName = "image 8"
            break
            
            
        default:
            return
        }
    }
    
    func setAllButtonsToX(){
        let image = UIImage(named: "x")! as UIImage
        self.btn1.setImage(image, for: .normal)
        self.btn2.setImage(image, for: .normal)
        self.btn3.setImage(image, for: .normal)
        self.btn4.setImage(image, for: .normal)
        self.btn5.setImage(image, for: .normal)
        self.btn6.setImage(image, for: .normal)
        self.btn7.setImage(image, for: .normal)
        self.btn8.setImage(image, for: .normal)
        
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //try to find next responder
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField{
            nextField.becomeFirstResponder()
        }else{
            //not found, so remove keyboard
            textField.resignFirstResponder()
        }
        
        //do not add a line break
        return false
    }
    
    //MARK: Save user data
    func saveUserData(){
        //1 - get NSManagedObjectContext
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //2 - Create a new managed object and insert it into the managed object context
        let entity = NSEntityDescription.entity(forEntityName: "UserData", in: managedContext)
        let userData = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        //3 - Set attributes using key-value coding
//        let date = Date()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
//        let name = dateFormatter.string(from: date)
        
        userData.setValue(self.name, forKey: "name")
        userData.setValue(self.email, forKey: "email")
        userData.setValue(self.imageName, forKey: "image")
        userData.setValue(self.number, forKey: "number")
        userData.setValue(self.age, forKey: "age")
        userData.setValue(self.howMany, forKey: "howmany")
        userData.setValue(self.postCode, forKey: "postcode")
        
        //4 - Commit the changes to document and save to disk
        do {
            try managedContext.save()
//            appDelegate.documents.append(document)
            self.showSnackBar(msg: "Data saved!")
        } catch {
            self.showSnackBar(msg: "Failure to save!")
            fatalError("Failure to save context: \(error)")
        }
    }

}

