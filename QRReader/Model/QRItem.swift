//
//  QRItem.swift
//  QRReader
//
//  Created by Hansub Yoo on 2020/03/28.
//  Copyright © 2020 Hansub Yoo. All rights reserved.
//

import Foundation
import CoreData

@objc(QRCodes)
public class QRCodes: NSManagedObject, Identifiable {
    @NSManaged public var content: String?
    @NSManaged public var date: Date?
    @NSManaged public var isRead: Bool
}

extension QRCodes {
    static func getAllQRCodes() -> NSFetchRequest<QRCodes> {
        let request: NSFetchRequest<QRCodes> = NSFetchRequest<QRCodes>(entityName: "QRCodes")
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        
        request.sortDescriptors = [sortDescriptor]
        return request
    }
    
    
}
