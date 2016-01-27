//
//  time.swift
//  FamilySns
//
//  Created by TokikawaTeppei on 26/01/2016.
//  Copyright © 2016 Minato. All rights reserved.
//

import Foundation

extension NSDate{

    func time() -> Int{
        return Int(self.timeIntervalSince1970)
    }

}