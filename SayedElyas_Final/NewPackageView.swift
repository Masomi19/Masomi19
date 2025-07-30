//
//  NewPackageView.swift
//  SayedElyas_Final
//
//  Created by Sayed Elyas Masomi on 2025-06-09.
//

import SwiftUI

// MARK: - NewPackageView

struct NewPackageView: View {
    
    // MARK: - Environment & ViewModel
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: PackageViewModel

    // MARK: - Form States
    @State private var packageID: String = ""
    @State private var address: String = ""
    @State private var carrier: String = "FedEx"
    @State private var deliveryDate: Date = Date()
    @State private var isDelivered: Bool = false

    // MARK: - Alert States
    @State private var showValidationAlert = false
    @State private var showDuplicateIDAlert = false
    @State private var showNonNumericIDAlert = false
    @State private var showDateValidationAlert = false
    @State private var showSuccessAlert = false

    // MARK: - Constants
    let carriers = ["FedEx", "UPS", "DHL", "Canada Post"]

    // MARK: - Body

    var body: some View {
        Form {
            // MARK: - Package Info Section
            Section(header: Text("Package Information")) {
                TextField("Package ID", text: $packageID)
                    .keyboardType(.numberPad)
                    .submitLabel(.done)

                TextField("Delivery Address", text: $address)
                    .keyboardType(.default)
            }

            // MARK: - Delivery Details Section
            Section(header: Text("Delivery Details")) {
                Picker("Carrier", selection: $carrier) {
                    ForEach(carriers, id: \.self) {
                        Text($0)
                    }
                }

                DatePicker("Expected Delivery Date", selection: $deliveryDate,
                           in: Date()...,
                           displayedComponents: .date)

                Toggle("Mark as Delivered", isOn: $isDelivered)
            }
        } // end Form

        // MARK: - Navigation & Toolbar
        .navigationTitle("Add Package")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Add") {
                    handleAddPackage()
                }
                .disabled(packageID.isEmpty || address.isEmpty)
            }
        }

        // MARK: - Alerts
        .alert("Incomplete Form", isPresented: $showValidationAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please fill in all required fields.")
        }

        .alert("Invalid Delivery Date", isPresented: $showDateValidationAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(isDelivered ?
                 "Delivered packages cannot have a future date." :
                 "In-transit packages cannot have a past date.")
        }

        .alert("Duplicate Package ID", isPresented: $showDuplicateIDAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("A package with this ID already exists.")
        }

        .alert("Invalid Package ID", isPresented: $showNonNumericIDAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Package ID must contain only numbers.")
        }

        .alert("Package Added!", isPresented: $showSuccessAlert) {
            Button("OK") {
                dismiss()
            }
        }
    }

    // MARK: - Helper Methods

    /// Validates that all required form fields are filled.
    func isFormFilled() -> Bool {
        !packageID.trimmingCharacters(in: .whitespaces).isEmpty &&
        !address.trimmingCharacters(in: .whitespaces).isEmpty &&
        !carrier.trimmingCharacters(in: .whitespaces).isEmpty
    }

    /// Validates the selected delivery date based on the delivery status.
    func isDateValid() -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        let selectedDate = Calendar.current.startOfDay(for: deliveryDate)

        if isDelivered {
            return selectedDate <= today
        } else {
            return selectedDate >= today
        }
    }

    /// Handles adding a new package after validating inputs.
    func handleAddPackage() {
        guard isFormFilled() else {
            showValidationAlert = true
            return
        }

        guard isDateValid() else {
            showDateValidationAlert = true
            return
        }

        // Validate Package ID contains only numbers
        let isNumeric = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: packageID))
        if !isNumeric {
            showNonNumericIDAlert = true
            return
        }

        // Check for duplicate Package ID
        if viewModel.packages.contains(where: { $0.packageID == packageID }) {
            showDuplicateIDAlert = true
            return
        }

        // Create and add new Package
        let newPackage = Package(
            packageID: packageID,
            deliveryAddress: address,
            carrier: carrier,
            deliveryDate: deliveryDate,
            isDelivered: isDelivered
        )

        viewModel.addPackage(newPackage)
        showSuccessAlert = true
    }
}
