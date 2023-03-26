//
//  ItemCache.swift
//  PhotoMasterclass
//
//  Created by Sachin on 27/03/23.
//

import Foundation

class StructWrapper<T>: NSObject {
    let value: T

    init(_ _struct: T) {
        value = _struct
    }
}


class ItemCache: NSCache<NSString, StructWrapper<LessonsItem>> {
    static let shared = ItemCache()

    func cache(_ item: LessonsItem, for key: Int) {
        let keyString = NSString(format: "%d", key)
        let itemWrapper = StructWrapper(item)
        self.setObject(itemWrapper, forKey: keyString)
    }

    func getItem(for key: Int) -> LessonsItem? {
        let keyString = NSString(format: "%d", key)
        let itemWrapper = self.object(forKey: keyString)
        return itemWrapper?.value
    }
}
