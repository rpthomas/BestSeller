//
//  DetailViewController.swift
//  BestSeller
//
//  Created by Roland Thomas on 11/10/16.
//  Copyright © 2016 Jedisware LLC. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

   
    @IBOutlet weak var tableView: UITableView!
    var selectedBooks = [String]()
    var selectedBooksObjects = [Books]()

    func configureView() {
        // Update the user interface for the detail item.
        
        selectedBooks.removeAll()
        selectedBooksObjects.removeAll()
        
        if let detail = self.detailItem {
            createTableArray(booksObj:detail)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.configureView()
        
        tableView.layer.masksToBounds = true
        tableView.layer.borderColor = UIColor( red: 153/255, green: 153/255, blue:0/255, alpha: 1.0 ).cgColor
        tableView.layer.borderWidth = 2.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Dictionary<String, Books>? {
        didSet {
            // Update the view.
            //self.configureView()
        }
    }
    
    var category: String? {
        didSet {
            
        }
    }

    
    func createTableArray(booksObj books:Dictionary<String, Books>)
    {
        
        for (_, value) in books{
            selectedBooksObjects.append(value)
            
            if value.title != nil
            {
                selectedBooks.append(value.title!)
            }
            
        }
        self.tableView.reloadData()
    }

     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (selectedBooks.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = selectedBooks[indexPath.row]
        
        //print((cell.textLabel?.text)! as String)
        
        return cell
    }

    
    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moreInfo" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
               let booksObject = selectedBooksObjects[indexPath.row]
                
                let controller:MoreInfoViewController = segue.destination as! MoreInfoViewController

                //let controller = (segue.destination ).topViewController as! MoreInfoViewController
                controller.thisBook = booksObject
                controller.category = self.category
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    



}

