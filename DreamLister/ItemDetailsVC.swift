//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by paul on 24/03/2017.
//  Copyright © 2017 paul. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBAction func savePressed(_ sender: Any) {
        var  item: Item!
        let picture = Image(context: context)
        let itemType = ItemType(context: context)
        picture.image = thumbImage.image
        itemType.type =  typeField.text
       
    
        if itemToEdit == nil {
            item = Item(context: context)
        }else{
            item = itemToEdit
        }
         item.toImage = picture
         item.toItemType = itemType
         item.created = NSDate()
    
        if let title = titleField.text {
            item.title = title
        }
        if let price = priceField.text {
            item.price = (price as NSString).doubleValue
        }
        if let details =  detailsField.text {
            item.details = details
        }
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        
        ad.saveContext()
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    @IBOutlet weak var thumbImage: UIImageView!
    
    @IBAction func addImage(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            thumbImage.image =  image
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var storePicker: UIPickerView!
 
    @IBOutlet weak var priceField: UITextField!
    
    @IBOutlet weak var detailsField: UITextField!
    
    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var typeField: UITextField!
    
    var stores = [Store]()
    
    var itemToEdit: Item?
    
    var imagePicker: UIImagePickerController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil
           )
        }
        
       storePicker.delegate = self
       storePicker.dataSource = self
       imagePicker = UIImagePickerController()
       imagePicker.delegate = self
        
        let store = Store(context: context)
        store.name = "String Shop 1"
        let store2 = Store(context: context)
        store2.name = "String Shop 2"
        let store3 = Store(context: context)
        store3.name = "String Shop 3"
        let store4 = Store(context: context)
        store4.name = "String Shop 4"
       
    
        getStores()
    
        if itemToEdit != nil {
            loadItemData()
        }
    
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = stores[row]
        return store.name
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func getStores(){
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        do{
             self.stores = try context.fetch(fetchRequest)
             self.storePicker.reloadAllComponents()
        }catch {
            //handle error
        }
    }
    
    func loadItemData(){
        if let item = itemToEdit {
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            
            typeField.text = item.toItemType?.type
            thumbImage.image = item.toImage?.image as? UIImage
            if let store = item.toStore {
                var index = 0
                repeat {
                    let s = stores[index]
                    if s.name ==  store.name {
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                } while (index < stores.count)
            }
        }
    }
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        _ = navigationController?.popViewController(animated: true)

    }


}
