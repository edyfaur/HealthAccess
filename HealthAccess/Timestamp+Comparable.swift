//
//  Timestamp+Comparable.swift
//  HealthAccess
//
//  Created by Edward Faur on 04.07.2023.
//

import Foundation
import FirebaseFirestore

extension Timestamp: Comparable {
    public static func < (lhs: Timestamp, rhs: Timestamp) -> Bool {
        return lhs.dateValue() < rhs.dateValue()
    }
}

