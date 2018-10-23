//
//  ResponseFiles.swift
//  LvMP
//
//  Created by Jinu Kim on 17/10/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import Foundation

// 서버와 통신을 위한 타입
struct ResponseFiles: Codable {
    let files: [Data]
    let types: [String]
}
