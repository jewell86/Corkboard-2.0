import SwiftUI

struct CollectionView: View {
    @State private var notes = [
        Note(id: UUID(), text: "Note 1", position: CGPoint(x: 50, y: 50)),
        Note(id: UUID(), text: "Note 2", position: CGPoint(x: 200, y: 50)),
        Note(id: UUID(), text: "Note 3", position: CGPoint(x: 50, y: 200)),
        Note(id: UUID(), text: "Note 4", position: CGPoint(x: 200, y: 200))
    ]

    @State private var images = [
        ImageModel(image: UIImage(named: "image1")!, position: CGPoint(x: 100, y: 100))
    ]

    @ObservedObject var viewModel = CollectionViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                ForEach($images) { $imageModel in
                    ImageView(viewModel: viewModel, imageModel: $imageModel)
                }
                ForEach($notes) { $note in
                    NoteView(viewModel: viewModel, note: $note)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar {
                Button(action: {
                    viewModel.showingImagePicker = true
                }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $viewModel.showingImagePicker) {
                ImagePicker(image: $viewModel.inputImage)
                    .onDisappear {
                        if let inputImage = viewModel.inputImage {
                            let newImageModel = ImageModel(image: inputImage, position: CGPoint(x: 100, y: 100))
                            images.append(newImageModel)
                        }
                    }
            }
            .fullScreenCover(isPresented: $viewModel.showingLargeImage) {
                if let selectedImage = viewModel.selectedImage {
                    LargeImageView(isPresented: $viewModel.showingLargeImage, image: selectedImage)
                }
            }
            .alert("Edit Note", isPresented: Binding<Bool>(
                get: { viewModel.editingNote != nil },
                set: { if !$0 { viewModel.editingNote = nil } }
            )) {
                TextField("Note text", text: $viewModel.editText)
                Button("Save") {
                    if let index = notes.firstIndex(where: { $0.id == viewModel.editingNote?.id }) {
                        notes[index].text = viewModel.editText
                    }
                    viewModel.editingNote = nil
                }
                Button("Cancel", role: .cancel) {
                    viewModel.editingNote = nil
                }
            }
        }
    }
}


