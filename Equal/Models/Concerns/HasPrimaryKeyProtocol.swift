//
//  HasPrimaryKeyProtocol.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/6/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import Foundation

public protocol HasPrimaryKey {
    var id: Int { get set }
}
