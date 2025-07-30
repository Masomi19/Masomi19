//
//  PackageDetailView.swift
//  SayedElyas_Final
//
//  Created by Sayed Elyas Masomi on 2025-06-09.
//

import SwiftUI

struct PackageDetailView: View {

    // MARK: - ViewModel & Package References
    @ObservedObject var viewModel: PackageViewModel
    @ObservedObject var package: Package

    // MARK: - Alert States
    @State private var showDateValidationAlert = false
    @State private var showSaveAlert = false

    // MARK: - System Dismiss Action
    @Environment(\.dismiss) var dismiss

    // MARK: - Static Carrier Options
    let carriers = ["FedEx", "UPS", "DHL", "Canada Post"]

    // MARK: - UI Layout
    var body: some View {
        Form {
            // Section: Display Package ID
            Section(header: Text("Package ID")) {
                Text(package.packageID)
                    .font(.headline)
            }

            // Section: Editable Package Details
            Section(header: Text("Delivery Information")) {
                TextField("Address", text: $package.deliveryAddress)

                Picker("Carrier", selection: $package.carrier) {
                    ForEach(carriers, id: \.self) { carrier in
                        Text(carrier).tag(carrier)
                    }
                }

                DatePicker("Delivery Date", selection: $package.deliveryDate, displayedComponents: .date)

                Toggle("Delivered", isOn: $package.isDelivered)
            }
        }

        // MARK: - Alerts
        .alert("Invalid Delivered Date", isPresented: $showDateValidationAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(package.isDelivered ?
                 "Delivered packages cannot have a future date." :
                 "In-transit packages cannot have a past date.")
        }

        .alert("Package Updated!", isPresented: $showSaveAlert) {
            Button("OK") {
                dismiss()
            }
        }

        // MARK: - Toolbar with Save Button
        .navigationTitle("Package Details")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    if isDateValid() {
                        viewModel.updatePackage(package)
                        showSaveAlert = true
                        dismiss()
                    } else {
                        showDateValidationAlert = true
                    }
                }
            }
        }
    }

    // MARK: - Date Validation Logic
    func isDateValid() -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        let selectedDate = Calendar.current.startOfDay(for: package.deliveryDate)

        if package.isDelivered {
            return selectedDate <= today // Delivered must be today or earlier
        } else {
            return selectedDate >= today // In transit must be today or later
        }
    }

    // (Optional) MARK: - Alternative Handler Function
    func handleUpdatePackage() {
        guard isDateValid() else {
            showDateValidationAlert = true
            return
        }

        showSaveAlert = true
    }
}

