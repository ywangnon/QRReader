//
//  QRCodes+CoreDataProperties.swift
//  QRReader
//
//  Created by Hansub Yoo on 2020/03/27.
//  Copyright © 2020 Hansub Yoo. All rights reserved.
//
//

import Foundation
import CoreData


extension QRCodes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QRCodes> {
        return NSFetchRequest<QRCodes>(entityName: "QRCodes")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: Int64
    @NSManaged public var qrContent: String?

}
