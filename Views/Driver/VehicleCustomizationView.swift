import SwiftUI

struct VehicleCustomizationView: View {
    @StateObject private var viewModel = VehicleCustomizationViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                // Color Selection
                Section(header: Text("Vehicle Color")) {
                    ColorPicker("Primary Color", selection: $viewModel.primaryColor)
                    if viewModel.supportsAccentColor {
                        ColorPicker("Accent Color", selection: $viewModel.accentColor)
                    }
                }
                
                // Accessories
                Section(header: Text("Accessories")) {
                    ForEach(Array(VehicleIcon.Customization.Accessory.allCases), id: \.self) { accessory in
                        AccessoryToggleRow(
                            accessory: accessory,
                            isEnabled: viewModel.hasAccessory(accessory),
                            isLocked: viewModel.isAccessoryLocked(accessory)
                        )
                    }
                }
                
                // Decals
                Section(header: Text("Decals")) {
                    ForEach(viewModel.decals) { decal in
                        DecalRow(decal: decal) {
                            viewModel.removeDecal(decal)
                        }
                    }
                    
                    Button {
                        viewModel.showAddDecal = true
                    } label: {
                        Label("Add Decal", systemImage: "plus")
                    }
                }
                
                // Preview
                Section {
                    VehiclePreview(customization: viewModel.currentCustomization)
                        .frame(height: 200)
                }
            }
            .navigationTitle("Customize Vehicle")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task {
                            if await viewModel.saveCustomization() {
                                dismiss()
                            }
                        }
                    }
                    .disabled(!viewModel.hasChanges)
                }
            }
            .sheet(isPresented: $viewModel.showAddDecal) {
                AddDecalView(completion: viewModel.addDecal)
            }
        }
    }
}

struct VehiclePreview: View {
    let customization: VehicleIcon.Customization
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            // 3D vehicle preview with customizations
            VehicleModel(customization: customization)
                .rotation3DEffect(.degrees(rotation), axis: (0, 1, 0))
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            rotation += value.translation.width * 0.5
                        }
                )
            
            // Overlay controls
            VStack {
                HStack {
                    Button {
                        withAnimation {
                            rotation = 0
                        }
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                    }
                    
                    Spacer()
                    
                    Button {
                        withAnimation {
                            rotation += 90
                        }
                    } label: {
                        Image(systemName: "rotate.right")
                    }
                }
                .padding()
                
                Spacer()
            }
        }
    }
} 