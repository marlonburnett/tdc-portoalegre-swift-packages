//
//  String+HTMLDecode.swift
//  TheDevConf2019
//
//  Created by Marlon Burnett on 27/11/19.
//  Copyright © 2019 Marlon Burnett. All rights reserved.
//

import SwiftSoup

extension String {

    init?(htmlEncodedString: String) {
        
        guard let document = try? SwiftSoup.parse(htmlEncodedString), let decoded = try? document.body()?.html() else {
            return nil
        }

        self.init(stringLiteral: decoded)
    }

}
