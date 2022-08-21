//
//  CoinData.swift
//  ByteCoin
//
//  Created by IMac on 21/08/2022.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation

struct CoinData: Codable {
    var time: String?
    var asset_id_base: String?
    var asset_id_quote: String?
    var rate: Double?
}
