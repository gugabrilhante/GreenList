//
//  ViewController.swift
//  GreenList
//
//  Created by Gustavo Belo Brilhante on 20/03/17.
//  Copyright © 2017 Gustavo. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON
import ActionSheetPicker_3_0

class InitialViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIScrollViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var LoadDataButton: UIButton!
    @IBOutlet weak var ClearDataButton: UIButton!
    @IBOutlet weak var valueTextField: UITextField!
    
    @IBOutlet var searchBarView: UIView!
    var resourceDisplayList:[ResourceHolder] = [ResourceHolder]()
    var resourceFilteredList:[ResourceHolder] = [ResourceHolder]()
    var resourceFullList:[ResourceHolder] = [ResourceHolder]()
    
    var languageIdFilter:[String] = [String]()
    var moduleIdFilter:[String] = [String]()
    
    var indexLanguage = 0
    var indexModule = 0
    
    var languageSelected = "-"
    var moduleSelected = "-"
    
    var lastTypedString:String = ""
    
    var lastOffSet:CGFloat?
    
    var searchBarTopRange:CGFloat?
    var searchBarBottomRange:CGFloat?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        valueTextField.delegate = self
        self.lastTypedString = self.valueTextField.text!
        //self.tableView.isScrollEnabled = true
        self.tableView.delegate = self
        
        self.searchBarTopRange = self.searchBarView.frame.origin.y-self.searchBarView.frame.height
        self.searchBarBottomRange = self.searchBarView.frame.origin.y

        if let array = UserDefaults.standard.dictionary(forKey: "list_translation") {
            self.resourceFullList = ResourceHolder.collectionFromJSON(JSON(array["data"]))
            
            self.resourceFilteredList = self.resourceFullList
            self.resourceDisplayList = self.resourceFullList
            self.tableView.isHidden = false
            self.tableView.reloadData()
            LoadDataButton.setTitle("Atualizar lista", for: .normal)
            self.ClearDataButton.isHidden = false
        }else{
            LoadDataButton.setTitle("Baixar lista", for: .normal)
            self.ClearDataButton.isHidden = true
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func placeSearchBarBack(){
        UIView.animate(withDuration: 0.5) { 
            self.searchBarView.frame.origin.y = self.searchBarBottomRange!
        }
    }
    
    func fetchList(){
        
        let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD?.labelText = "Carregando"
        
        Service.genericGetRequest(path:"", callBack: { (Json, CODE) in
            if let json = Json {
                self.resourceFullList = ResourceHolder.collectionFromJSON(json)
                
                let defaults = UserDefaults.standard
                
                var dict = [String:Any]()
                dict["data"] = self.resourceFullList.map{ $0.toDictionary() }
                
                defaults.set(dict, forKey: "list_translation")
                UserDefaults.standard.synchronize()
                
                //let saved = UserDefaults.standard.dictionary(forKey: "list_translation")
                
                self.resourceFilteredList = self.resourceFullList
                self.resourceDisplayList = self.resourceFullList
                self.tableView.isHidden = false
                self.tableView.reloadData()
                self.LoadDataButton.setTitle("Atualizar lista", for: .normal)
                self.ClearDataButton.isHidden = false
            }
            
            progressHUD!.hide(true)
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resourceDisplayList.count+1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row==0){
            return 80
        }else{
            return 90
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if(indexPath.row==0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) as! EmptyCell
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResourceCell", for: indexPath) as! ResourceCell
            cell.setContents(res: resourceDisplayList[indexPath.row-1].resource)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        //let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resourceViewController = self.storyboard?.instantiateViewController(withIdentifier: "ResourceDetailId") as! ResourceDetailViewController
        resourceViewController.resource = self.resourceDisplayList[indexPath.row-1].resource
        self.navigationController?.pushViewController(resourceViewController, animated: true)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if let pastOffSet = self.lastOffSet{
            let newOffSet = scrollView.contentOffset.y
            let delta = newOffSet-pastOffSet
            if(delta>0){
                if(searchBarView.frame.origin.y - delta < self.searchBarTopRange!){
                        self.searchBarView.frame.origin.y = self.searchBarTopRange!
                    
                }
                else{
                        self.searchBarView.frame.origin.y -= delta
                    
                }
            }
            else{
                if(searchBarView.frame.origin.y - delta > self.searchBarBottomRange!){
                        self.searchBarView.frame.origin.y = self.searchBarBottomRange!
            
                    
                }
                else{
                        self.searchBarView.frame.origin.y -= delta
                    
                }
            }
            
        }
        self.view.layoutIfNeeded()
        self.lastOffSet = scrollView.contentOffset.y
        //self.view.layoutIfNeeded()
    }

    @IBAction func LoadDataAction(_ sender: UIButton) {
        self.placeSearchBarBack()
        fetchList()
    }
    
    @IBAction func ClearDataAction(_ sender: UIButton) {
        self.placeSearchBarBack()
        clearData()
    }
    
    func clearData(){
        if(self.resourceFullList.count>0){
            self.resourceDisplayList = [ResourceHolder]()
            self.resourceFilteredList = [ResourceHolder]()
            self.resourceFullList = [ResourceHolder]()
            let defaults = UserDefaults.standard
            defaults.set(nil, forKey: "list_translation")
            UserDefaults.standard.synchronize()
            
            self.tableView.reloadData()
            self.LoadDataButton.setTitle("Baixar Lista", for: .normal)
        }
        self.ClearDataButton.isHidden = true
        
    }
 
    
    @IBAction func filterAction(_ sender: UIButton) {
        if(resourceFullList.count>0){
            if(languageIdFilter.count==0 || moduleIdFilter.count==0){
                setFilterList()
            }
            
            ActionSheetMultipleStringPicker.show(withTitle: "Filtros", rows: [
                languageIdFilter,
                moduleIdFilter
                ], initialSelection: [indexLanguage, indexModule], doneBlock: {
                    picker, indexes, values in
                    
                    print("values = \(values)")
                    print("indexes = \(indexes)")
                    print("picker = \(picker)")
                    let indexDict = indexes as! [Int]
                    self.indexLanguage = indexDict[0]
                    self.indexModule = indexDict[1]
                    
                    let valueDict = values as! [String]
                    self.languageSelected = valueDict[0]
                    self.moduleSelected = valueDict[1]
                    self.applyFilterToList()
                    self.resourceDisplayList = self.resourceFilteredList
                    self.tableView.reloadData()
                    return
            }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
        }
        
    }
    

    @IBAction func valueTextFieldBeginEditing(_ sender: UITextField) {
        self.placeSearchBarBack()
    }
    
    func applyFilterToList(){
        var auxList01 = [ResourceHolder]()
        var auxList02 = [ResourceHolder]()
        self.resourceFilteredList = [ResourceHolder]()
        if(languageSelected != "-"){
            for resourceHolder in self.resourceFullList{
                if(languageSelected==resourceHolder.resource.language_id){
                    auxList01.append(resourceHolder)
                }
            }
        }else{
            auxList01 = self.resourceFullList
        }
        
        if(moduleSelected != "-"){
            for resourceHolder in auxList01{
                if(moduleSelected==resourceHolder.resource.module_id){
                    auxList02.append(resourceHolder)
                }
            }
        }else{
            auxList02 = auxList01
        }
        
        self.resourceFilteredList = auxList02
        
    }
    
    @IBAction func valueEditTextChanged(_ sender: UITextField) {//chamado cada vez que o usuario muda o texto do textfield
        if(self.resourceFullList.count>0){
            if(sender.text!.isEmpty){
                self.resourceDisplayList = self.resourceFilteredList
                self.tableView.reloadData()
            }
            else{
                if(sender.text!.hasPrefix(self.lastTypedString)){//caso o usuario esteja digitando a palavra aplica o filtro na propria lista, otimiza a busca caso a lista seja muito grande
                    self.resourceDisplayList = self.resourceDisplayList.filter() {
                        if let value = ($0 as ResourceHolder).resource.value as String! {
                            return value.lowercased().contains(sender.text!.lowercased())
                        } else {
                            return false
                        }
                    }
                }else{
                    self.resourceDisplayList = self.resourceFilteredList.filter() {
                        if let value = ($0 as ResourceHolder).resource.value as String! {
                            return value.lowercased().contains(sender.text!.lowercased())
                        } else {
                            return false
                        }
                    }
                }
                self.tableView.reloadData()
            }
        }
        self.lastTypedString = sender.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        /*if(self.resourceFullList.count>0){
            if(sender.text!.isEmpty){
                self.resourceDisplayList = self.resourceFilteredList
            }
            else{
                self.resourceDisplayList = [ResourceHolder]()
                for resourceHolder in self.resourceFilteredList{
                    if (resourceHolder.resource.value?.contains(sender.text!))!{
                        self.resourceDisplayList.append(resourceHolder)
                    }
                    
                }
            }
            self.tableView.reloadData()
        }*/
    }
    

    
    func setFilterList(){//pega a lista de opçoes a ser filtrada, usada no pickerview
        languageIdFilter = [String]()
        languageIdFilter.append("-")
        moduleIdFilter = [String]()
        moduleIdFilter.append("-")
        for resourceHolder in resourceFullList{
            if let languageId = resourceHolder.resource.language_id{
                if(languageIdFilter.contains(languageId)==false){
                    languageIdFilter.append(languageId)
                }
            }
            if let moduleId = resourceHolder.resource.module_id{
                if(moduleIdFilter.contains(moduleId)==false){
                    moduleIdFilter.append(moduleId)
                }
            }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        self.valueTextField.updateFocusIfNeeded()
        return false
    }

}

