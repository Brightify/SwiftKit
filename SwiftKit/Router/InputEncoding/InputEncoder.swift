//
//  InputEncoder.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 27/01/16.
//  Copyright © 2016 Tadeas Kriz. All rights reserved.
//

import SwiftyJSON

public protocol InputEncoder {
    func encode(_ input: JSON, to request: inout Request)
}
