//
//  PackageListView.swift
//  SayedElyas_Final
//
//  Created by Sayed Elyas Masomi on 2025-06-09.

import SwiftUI

struct PackageListView: View {
    // MARK: - State and ViewModel
    @StateObject var viewModel = PackageViewModel()


    var body: some View {
        NavigationView {
            // MARK: - Package List Display
            List {
                ForEach(viewModel.filteredPackages) { package in
                    NavigationLink(
                        destination: PackageDetailView(viewModel: viewModel, package: package)
                    ) {
                        VStack(alignment: .leading) {
                            Text("ID: \(package.packageID)")
                                .fontWeight(.bold)
                            Text("Date: \(package.deliveryDate, style: .date)")
                            Text("Status: \(package.isDelivered ? "Delivered" : "In Transit")")
                                .foregroundColor(package.isDelivered ? .green : .orange)
                        }
                    }
                }
                .onDelete(perform: viewModel.deletePackage) // Swipe to delete
            }

            // MARK: - Navigation Bar Setup
            .navigationTitle("Sayed Elyas Masomi")
            .searchable(text: $viewModel.searchText) // Search by package

            // MARK: - Add New Package Button
            .toolbar {
                NavigationLink(destination: NewPackageView(viewModel: viewModel)) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    PackageListView()
}

