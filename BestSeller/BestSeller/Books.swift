//
//  Books.swift
//  BestSeller
//
//  Created by Roland Thomas on 11/10/16.
//  Copyright © 2016 Jedisware LLC. All rights reserved.
//


import Foundation

public class Books: NSObject {
     public var primaryISBN: String?
     public var author: String?
     public var category: String?
     public var desc: String?
     public var img: NSData?
     public var rank: Int32 = 0
     public var title: String?
     public var buylocation = [[String: String]]()
     public var imageUrl: String?
     public var categoryDict = Dictionary<String, [String]>()
}
