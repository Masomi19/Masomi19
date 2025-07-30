//
//  PackageViewModel.swift
//  SayedElyas_Final
//
//  Created by Sayed Elyas Masomi on 2025-06-09.
//


//Published tells SwiftUI to update views automatically when this array changes.

import Foundation

// MARK: - ViewModel for Package Tracking
class PackageViewModel: ObservableObject {

    // MARK: - Published Properties (Observed by Views)
    @Published var packages: [Package] = []      // All tracked packages
    @Published var searchText = ""               // User input for filtering packages

    // MARK: - Private Constants
    private let key = "TrackedPackages"          // Key for saving/loading from UserDefaults

    // MARK: - Initialization
    init() {
        loadPackages()                           // Load packages when ViewModel is initialized
    }

    // MARK: - Computed Property: Filtered Packages
    var filteredPackages: [Package] {
        if searchText.isEmpty {
            return packages
        } else {
            // Filter packages based on delivery status using the search text
            return packages.filter {
                $0.isDelivered ?
                "delivered".contains(searchText.lowercased()) :
                "in transit".contains(searchText.lowercased())
            }
        }
    }

    // MARK: - Data Persistence Methods

    /// Loads packages from UserDefaults
    func loadPackages() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([Package].self, from: data) {
            packages = decoded
        }
    }

    /// Saves packages to UserDefaults
    func savePackages() {
        if let encoded = try? JSONEncoder().encode(packages) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    // MARK: - CRUD Operations

    /// Adds a new package to the list and saves it
    func addPackage(_ package: Package) {
        packages.append(package)
        savePackages()
    }

    /// Deletes packages at given indices and saves the updated list
    func deletePackage(at offsets: IndexSet) {
        packages.remove(atOffsets: offsets)
        savePackages()
    }

    /// Updates an existing package and saves the list
    func updatePackage(_ package: Package) {
        if let index = packages.firstIndex(where: { $0.id == package.id }) {
            packages[index] = package
            savePackages()
        }
    }
}
