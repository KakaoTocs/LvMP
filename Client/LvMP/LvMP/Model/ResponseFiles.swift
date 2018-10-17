//
//  ResponseFiles.swift
//  LvMP
//
//  Created by Jinu Kim on 17/10/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import Foundation

struct ResponseFiles: Codable {
    let files: [Data]
    let types: [String]
}
