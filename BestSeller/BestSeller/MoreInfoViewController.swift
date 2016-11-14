//
//  MoreInfoViewController.swift
//  BestSeller
//
//  Created by Roland Thomas on 11/13/16.
//  Copyright © 2016 Jedisware LLC. All rights reserved.
//

import UIKit

class MoreInfoViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    
  
    var thisBook: Books? {
        didSet {

        }
    }

    var category: String? {
        didSet {

        }
    }
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        
        loadText()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func loadText()
    {
        //let pad = " "
        let adminHeading1 = (thisBook?.title)! + "\n\n"
        
        
        let head1Link2 = (thisBook?.author)! + "\n"
        let head1Link3 = (thisBook?.desc)! + "\n\n"
        let head1Link4 = "Buy Here:\n"
        let head1Link5 = "Purchase Link"
        var link:String = String()
        
        //thisBook?.buylocation
        
        for item in (thisBook?.buylocation)!
        {
            let newLinkDict = item as [String: String]
            for (key, value)in newLinkDict
            {
                if key == category
                {
                    link = value
                    print(link)
                    break
                }
            }
            
        }

        
        
        let solid  =  NSUnderlineStyle.patternSolid.rawValue | NSUnderlineStyle.styleSingle.rawValue
        // let attrib1 = [ NSForegroundColorAttributeName: UIColor.black, NSUnderlineStyleAttributeName : solid, NSUnderlineColorAttributeName : UIColor.black] as [String : Any]
        
        //Administration Help
        let heading1Attrib = NSMutableAttributedString(string: adminHeading1)
        heading1Attrib.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 18), range: NSMakeRange(0, adminHeading1.characters.count))
        heading1Attrib.addAttribute(NSUnderlineStyleAttributeName, value: solid, range: NSMakeRange(0, adminHeading1.characters.count))
        
        
        //The second Line
        let heading2Attrib = NSMutableAttributedString(string: head1Link2)
        heading2Attrib.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 18), range: NSMakeRange(0, head1Link2.characters.count))
        
        //The third Line
        let heading3Attrib = NSMutableAttributedString(string: head1Link3)
        heading3Attrib.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 18), range: NSMakeRange(0, head1Link3.characters.count))
        
        //The fourth Line
        let heading4Attrib = NSMutableAttributedString(string: head1Link4)
        heading4Attrib.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 18), range: NSMakeRange(0, head1Link4.characters.count))

        //The fifth Line
        let heading5Attrib = NSMutableAttributedString(string: head1Link5)
        heading5Attrib.addAttribute(NSLinkAttributeName, value: link, range: NSRange(location: 0, length: head1Link5.characters.count))
        heading5Attrib.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 18), range: NSMakeRange(0, head1Link5.characters.count))
  
        //All Attributes have been set at this point
        
        let combination = NSMutableAttributedString()
        
        
        
        combination.append(heading1Attrib)
        combination.append(heading2Attrib)
        combination.append(heading3Attrib)
        combination.append(heading4Attrib)
        combination.append(heading5Attrib)
               
        textView.attributedText = combination
        
        
        
    }
    
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {

        UIApplication.shared.open(URL, options: [:])

        
        return false
    }


}
