//
//  InventoryViewController.swift
//  BestSeller
//
//  Created by Roland Thomas on 11/10/16.
//  Copyright © 2016 Jedisware LLC. All rights reserved.
//

import UIKit

protocol InitialLoadDelegate {
    
    func displayFailureAlert(title heading: String, body message: String)
    func PopulateList(data dict: Dictionary<String, Books>)
    
}

class InventoryViewController: UIViewController {
    
    var delegate: InitialLoadDelegate! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadBooks()
    {
        var status = 200
        
        let booksBaseURL: String = "http://api.nytimes.com/svc/books/v2/lists/overview.json"
        let booksAPIKey:String  = "437c86045d6c44ae939324dda684e055"
        
        guard let url = URL(string: "\(booksBaseURL)?api-key=\(booksAPIKey)") else {
            print("Error: cannot create URL")
            return
        }
        
        //print(url)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        //create the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        //Now the Request
        
        
        let task = session.dataTask(with: urlRequest, completionHandler: {(data , response, error) in
            guard let responseData = data else {
                DispatchQueue.main.async { [unowned self] in
                    //Display a message to user that request failed
                    
                    self.delegate?.displayFailureAlert(title: "Request Failed", body: "Could not obtain data.")
                }
                return
            }
            
            guard error == nil else {
                print("error calling POST on /todos/1")
                print(error!)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                //print("response = \(response)")
                status = httpStatus.statusCode
                
                DispatchQueue.main.async { [unowned self] in
                    //Display a message to user that request failed
                    
                    self.delegate?.displayFailureAlert(title: "Request Failed", body: "statusCode should be 200, but is \(httpStatus.statusCode)")
                }
            }
            
            //print(responseData)
            
            //let response = String(data: data!, encoding: String.Encoding.utf8)
            //print(response as Any)
            
            do {
                guard let jsonStr = try JSONSerialization.jsonObject(with: responseData,
                                                                     options: []) as? [String: AnyObject] else {
                                                                        
                                                                        
                DispatchQueue.main.async { [unowned self] in
                                                                            
                //Display a message to user that request failed
                                                                            
                self.delegate?.displayFailureAlert(title: "Request Failed", body: "Unble to retrieve Json")
                }
                    return
                }
                //print(jsonStr)
                
                if status == 200
                {
                    let jConverter = JsonConverter()
                    
                    let result = jConverter.convertToInventory(jStr: jsonStr)
                    
                    //Update the UI
                    DispatchQueue.main.async { [unowned self] in
                        self.delegate?.PopulateList(data: result)
                    }
                }
                else
                {
                    DispatchQueue.main.async { [unowned self] in
                        //Display a message to user that insert failed
                        
                        self.delegate?.displayFailureAlert(title: "Server Error", body: "The Request Failed.")
                    }
                    
                }

            
            
            } catch  {
                DispatchQueue.main.async { [unowned self] in
                    //Display a message to user that insert failed
                    
                    self.delegate?.displayFailureAlert(title: "Applicatiom Error", body: "Error parsing response.")
                }

                return
            }
        })

        task.resume()
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
