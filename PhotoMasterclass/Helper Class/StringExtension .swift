//
//  StringExtension .swift
//  PhotoMasterclass
//
//  Created by Sachin on 26/03/23.
//

import Foundation
import UIKit


extension String{

    ///check URL is vaild or not
    func canOpenURL() -> Bool {
        guard let url = NSURL(string: self) else {return false}
        if !UIApplication.shared.canOpenURL(url as URL) {return false}

        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: self)
    }
    
}
