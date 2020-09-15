//
//  Currency.swift
//  Equally
//
//  Created by DIMa on 13.09.2020.
//  Copyright © 2020 DIMa. All rights reserved.
//

import Foundation

struct Currency: Decodable {
    let base: String
    let rates: [String: Double]
    
    func getFlag(for currency: String) -> String{
        let flags: [String: String] = [
        "CAD": "🇨🇦",
        "HKD": "🇭🇰",
        "ISK": "🇮🇸",
        "PHP": "🇵🇭",
        "DKK": "🇩🇰",
        "HUF": "🇭🇺",
        "CZK": "🇨🇿",
        "AUD": "🇦🇺",
        "RON": "🇷🇴",
        "SEK": "🇸🇪",
        "IDR": "🇮🇩",
        "INR": "🇮🇳",
        "BRL": "🇧🇷",
        "RUB": "🇷🇺",
        "HRK": "🇭🇷",
        "JPY": "🇯🇵",
        "THB": "🇹🇭",
        "CHF": "🇨🇭",
        "SGD": "🇸🇬",
        "PLN": "🇵🇱",
        "BGN": "🇧🇬",
        "TRY": "🇹🇷",
        "CNY": "🇨🇳",
        "NOK": "🇳🇴",
        "NZD": "🇳🇿",
        "ZAR": "🇿🇦",
        "USD": "🇺🇸",
        "MXN": "🇲🇽",
        "ILS": "🇮🇱",
        "GBP": "🇬🇧",
        "KRW": "🇰🇷",
        "MYR": "🇲🇾",
        "EUR": "🇪🇺"]
        return "\(flags[currency] ?? "🏳️") \(currency)"
    }
}

