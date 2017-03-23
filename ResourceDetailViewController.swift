//
//  ResourceDetailViewController.swift
//  GreenList
//
//  Created by Gustavo Belo Brilhante on 21/03/17.
//  Copyright © 2017 Gustavo. All rights reserved.
//

import UIKit

class ResourceDetailViewController: UIViewController {
    
    @IBOutlet weak var createdContent: UILabel!
    @IBOutlet weak var updatedContent: UILabel!
    @IBOutlet weak var resourceContent: UILabel!
    @IBOutlet weak var moduleContent: UILabel!
    @IBOutlet weak var valueContent: UILabel!
    @IBOutlet weak var languageContent: UILabel!
    
    var resource:ResourceArg?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let res = resource {
            createdContent.text = res.created_at
            updatedContent.text = res.updated_at
            resourceContent.text = res.resource_id
            moduleContent.text = res.module_id
            valueContent.text = res.value
            languageContent.text = res.language_id
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func switchedValueFormatedDate(_ sender: UISwitch) {
        if(sender.isOn){
            if let date = self.resource?.created_at{
                let createdDateStr = self.convertDateFormater(date: date)
                if(createdDateStr.isEmpty == false){
                    createdContent.text = createdDateStr
                }
            }
            if let date = self.resource?.updated_at{
                let updatedDateStr = self.convertDateFormater(date: date)
                if(updatedDateStr.isEmpty == false){
                    updatedContent.text = updatedDateStr
                }
            }
        }else{
            createdContent.text = self.resource!.created_at
            updatedContent.text = self.resource!.updated_at
        }
    }
    
    
    func convertDateFormater(date: String) -> String {
        if(date.isEmpty==false && date.contains("T")){
            let dateFormatter = DateFormatter()
            let splittedStr = date.components(separatedBy: "T")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            guard let date = dateFormatter.date(from: splittedStr[0]) else {
                assert(false, "no date from string")
                return ""
            }
            
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let timeStamp = dateFormatter.string(from: date)
            
            return timeStamp
        }
        return ""
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
