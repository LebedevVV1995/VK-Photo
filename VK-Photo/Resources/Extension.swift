//
//  Extension.swift
//  VK-Photo
//
//  Created by Владимир on 07.04.2022.
//  Copyright © 2022 Владимир. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    public var width: CGFloat {
        return self.frame.size.width
    }
    
    public var height: CGFloat {
        return self.frame.size.height
    }
    
    public var top: CGFloat {
        return self.frame.origin.y
    }
    
    public var bottom: CGFloat {
        return self.frame.size.height + self.frame.origin.y
    }
    
    public var left: CGFloat {
        return self.frame.origin.x
    }
    
    public var reight: CGFloat {
        return self.frame.size.height + self.frame.origin.x
    }
}
