//
//  AdminViewController.swift
//  CompForm
//
//  Created by My Star on 2/4/17.
//  Copyright © 2017 Silver Star. All rights reserved.
//

import UIKit
import CoreData
import TTGSnackbar

class AdminViewController: UIViewController {

    @IBOutlet weak var btnClose: UIButton!
    
    @IBOutlet weak var btnShare: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUI();
    }
    
    func initUI(){
        self.btnClose.layer.shadowColor = UIColor.darkGray.cgColor
        self.btnClose.layer.shadowOffset = CGSize.init(width: 5, height: 5)
        self.btnClose.layer.shadowOpacity = 1.0
        
        
        self.btnShare.layer.shadowColor = UIColor.darkGray.cgColor
        self.btnShare.layer.shadowOffset = CGSize.init(width: 5, height: 5)
        self.btnShare.layer.shadowOpacity = 1.0
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: button actions
   

    @IBAction func btnShareTapped(_ sender: Any) {
        
        var objects = [NSManagedObject]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //create a fetchrequest
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        
        //hand the fetch request over to the managed object context
        do{
            objects = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            
            
        }catch let error as NSError{
            print("Couldn't fetch \(error), \(error.userInfo)")
        }
        
        let csvString = self.writeCoreDataObjectToCSV(objects: objects)
        
        if csvString == "No objects"{
            self.showSnackBar(msg: "No data!")
            return
        }
    
        self.shareCSV(csvString: csvString)
    }
    func showSnackBar(msg:String!){
        let snackBar = TTGSnackbar.init(message: msg, duration: .short)
        snackBar.show()
    }
    
    @IBAction func btnCloseTapped(_ sender: Any) {
        self.dismiss(animated: true) { 
            
        }
    }
    
    func writeCoreDataObjectToCSV(objects: [NSManagedObject] ) -> String {
        /* We assume that all objects are of the same type */
        guard objects.count > 0 else {
            return "No objects"
        }
        let firstObject = objects[0]
        let attribs = Array(firstObject.entity.attributesByName.keys)
        var csvHeaderString:String =  (attribs.reduce("", {($0 as String) + "," + $1 }) as String)

        csvHeaderString.remove(at: csvHeaderString.startIndex)
        csvHeaderString = csvHeaderString + "\n"
        
        let csvArray = objects.map({object in
            (attribs.map({((object.value(forKey: $0) ?? "NIL") as AnyObject).description}).reduce("",{$0 + "," + $1}) as NSString).substring(from: 1) + "\n"
        })
        let csvString = csvArray.reduce("", +)
        
        return csvHeaderString+csvString
        
    }
    
    func shareCSV(csvString: String?) {
        //Your CSV text
        
        let filename = getDocumentsDirectory().appendingPathComponent("data.csv")
        
        do {
            
            try csvString?.write(toFile: filename, atomically: true, encoding: .utf8)
            
            let fileURL = NSURL(fileURLWithPath: filename)
            
            let objectsToShare = [fileURL]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = self.view

            
            self.present(activityVC, animated: true, completion: nil)
            
        } catch {
            showSnackBar(msg: "cannot write file")
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }
        
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }
}
