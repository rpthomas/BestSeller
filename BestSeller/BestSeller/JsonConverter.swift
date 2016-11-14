//
//  JsonConverter.swift
//  BestSeller
//
//  Created by Roland Thomas on 11/10/16.
//  Copyright © 2016 Jedisware LLC. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class JsonConverter: NSObject, NSFetchedResultsControllerDelegate {
    
    
    
    func convertToInventory(jStr: [String: AnyObject]) -> Dictionary<String, Books>
    {
        let results = jStr["results"] as! [String:Any]
        var inventoryDict = Dictionary<String, Books>()
        let list = results["lists"] as! Array<Dictionary<String,Any>>
        
        for lst in list  {

            for (key, value) in lst {
                if key == "books"
                {
                    for object in value as! [AnyObject] {
                         let dict = object as! Dictionary<NSObject, AnyObject>
                        let thisBook = Books()

                        for (k,v) in dict {
                            //print(k)
                            //I can begin collecting data here
                            if k as! String == "author"
                            {
                                thisBook.author = (v as! String)
                            }
                            
                            if k as! String == "title"
                            {
                                thisBook.title = (v as! String)
                            }
                            
                            if k as! String == "description"
                            {
                                if let val = (v as? String)
                                {
                                  thisBook.desc = val
                                }
                                else
                                {
                                    thisBook.desc = "N/A"
                                }
                            }
                            
                            if k as! String == "rank"
                            {
                                thisBook.rank = Int32(v as! NSNumber)
                            }
                            
                            if k as! String == "author"
                            {
                                thisBook.author = (v as! String)
                            }
                            
                            if k as! String == "primary_isbn10"
                            {
                                thisBook.primaryISBN = (v as! String)
                            }

                            if  let arr = v as? [AnyObject] {
                                
                                for _ in arr {
                                    
                                    let linkDict = object as! Dictionary<NSObject, AnyObject>
                                    var locationDict = [String: String]()
                                    var url: String = String()
                                    var location: String = String()
                                    
                                    //This is the link to buy and the Distributor
                                    for (x,z) in linkDict {
                                        
                                        
                                        if let str = x as? String {
                                            if str.isEqualToString(find:"author")
                                            {
                                                thisBook.author = str
                                            }
                                            
                                            if str.isEqualToString(find:"primary_isbn10")
                                            {
                                                 thisBook.primaryISBN = z as? String
                                                
                                                //Update the ISBN's in the Array that have not been set
                                                for (key, value) in thisBook.categoryDict
                                                {
                                                    let val = value as [String]
                                                    var newArray = [String]()
                                                    
                                                    for v in val
                                                    {
                                                        if v.isEqualToString(find:"Default")
                                                        {
                                                            newArray.append(thisBook.primaryISBN!)
                                                        }
                                                        else
                                                        {
                                                            newArray.append(v)
                                                        }
                                                    }
                                                    thisBook.categoryDict[key] = newArray
                                                    
                                                }
                                                
                                                //thisBook.categoryDict.changeKey(from: "Default", to: thisBook.primaryISBN!)
                                            }
                                        }
                                        

                                        //let mirror4 = Mirror(reflecting: z)
                                        //print(mirror4.subjectType)
                                        
                                        
                                        if z is Array<AnyObject>
                                        {
                                            if  let qvc = z as? [AnyObject]
                                            {
                                             for element in qvc
                                             {
                                                //let mirror5 = Mirror(reflecting: element)
                                                //print(mirror5.subjectType)
                                                //print(element)
                                                let urlDict = element as! Dictionary<NSObject, AnyObject>
                                                
                                                url = ""
                                                location = ""
                                                for (n, u) in urlDict
                                                {
                                                    if n as! String == "url"
                                                    {
                                                        url = (u as! String)
                                                    }
                                                    if n as! String == "name"
                                                    {
                                                        location = (u as! String)
                                                    }
                                                    
                                                    if url != "" && location != ""
                                                    {
                                                        let arrayOfAllKeys = locationDict.keys
                                                        if !arrayOfAllKeys.contains(location)
                                                        {
                                                            locationDict[location] = url
                                                            thisBook.buylocation.append(locationDict)
                                                        }
                                                        let arrayOfCatKeys = thisBook.categoryDict.keys
                                                        
                                                        //Keep track of the ISBN in each category
                                                        if !arrayOfCatKeys.contains(location)
                                                        {
                                                            var newArray = [String]()
                                                            
                                                            //Check if the ISBN has been assigned yet
                                                            let myOptionalString: String? = thisBook.primaryISBN
                                                            
                                                            if myOptionalString == nil{
                                                                thisBook.primaryISBN = "Default"
                                                                }
                                                      
                                                            newArray.append(thisBook.primaryISBN!)
                                                            thisBook.categoryDict[location] = newArray
                                                        }
                                                        else
                                                        {
                                                            for (k, v) in thisBook.categoryDict
                                                            {
                                                                if k == location{
                                                                    var arr = v as [String]
                                                                    
                                                                    //Check if the ISBN has been assigned yet
                                                                    let myOptionalString: String? = thisBook.primaryISBN
                                                                    
                                                                    if myOptionalString == nil{
                                                                        thisBook.primaryISBN = "Default"
                                                                    }
                                                                    
                                                                arr.append(thisBook.primaryISBN!)
                                                                  thisBook.categoryDict[location] = arr
                                                                }
                                                            }
                                                        }
                                                    }
                                                    
                                                    
                                                }
                                                }
                                                let arrayOfAllKeys = locationDict.keys
                                                if !arrayOfAllKeys.contains(location)
                                                {
                                                    locationDict[location] = url
                                                    thisBook.buylocation.append(locationDict)
                                                }
                                                
                                                
                                                
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        inventoryDict[thisBook.primaryISBN!] = thisBook
                    }
                }
                
            }
        }
        //print([inventoryDict.count])

        return inventoryDict
    }
    
    // MARK: - Fetched results controller
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
       
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
       // self.tableView.endUpdates()
    }

}

extension Dictionary {
    mutating func changeKey(from: Key, to: Key) {
        self[to] = self[from]
        self.removeValue(forKey: from)
    }
}

extension String {
    func isEqualToString(find: String) -> Bool {
        return String(format: self) == find
    }
}
