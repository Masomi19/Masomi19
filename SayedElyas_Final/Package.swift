//
//  Package.swift
//  SayedElyas_Final
//
//  Created by Sayed Elyas Masomi on 2025-06-09.

import Foundation

// MARK: - Package Model
// The `Package` class represents a delivery package with relevant details.
// It conforms to Codable (for saving/loading), Identifiable (for List views), and ObservableObject (for real-time UI updates).

class Package: Codable, Identifiable, ObservableObject {

    // MARK: - Properties

    // Unique identifier for SwiftUI List rendering
    let id: UUID

    // Custom package ID entered by the user
    var packageID: String

    // Delivery address for the package
    var deliveryAddress: String

    // Selected carrier
    var carrier: String

    // Expected or actual delivery date
    var deliveryDate: Date

    // Status flag: true if delivered, false if in transit
    var isDelivered: Bool

    // MARK: - Initializer

    /// Creates a new `Package` with the provided values
    init(packageID: String, deliveryAddress: String, carrier: String, deliveryDate: Date, isDelivered: Bool) {
        self.id = UUID()
        self.packageID = packageID
        self.deliveryAddress = deliveryAddress
        self.carrier = carrier
        self.deliveryDate = deliveryDate
        self.isDelivered = isDelivered
    }

    // MARK: - Computed Property

    // Returns the current status as a user-friendly string
    var status: String {
        isDelivered ? "Delivered" : "In Transit"
    }
}
