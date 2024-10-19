import SwiftUI
import UniformTypeIdentifiers

struct CollectionView: View {
    @State private var notes = [
        Note(id: 1, text: "Note 1", position: CGPoint(x: 50, y: 50)),
        Note(id: 2, text: "Note 2", position: CGPoint(x: 200, y: 50)),
        Note(id: 3, text: "Note 3", position: CGPoint(x: 50, y: 200)),
        Note(id: 4, text: "Note 4", position: CGPoint(x: 200, y: 200))
    ]
    
    @State private var images = [
        ImageModel(id: 1, image: UIImage(named: "image1")!, position: CGPoint(x: 100, y: 100))
    ]
    
    @ObservedObject var viewModel = CollectionViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                ForEach($images) { $imageModel in
                    ImageView(viewModel: viewModel, imageModel: $imageModel)
                        .accessibility(identifier: "imageView_\(imageModel.id)")
                }
                ForEach($notes) { $note in
                    NoteView(viewModel: viewModel, note: $note)
                        .accessibility(identifier: "noteView_\(note.id)")
                        .onTapGesture {
                            viewModel.editingNote = note
                            viewModel.editText = note.text
                        }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar {
                Button(action: {
                    viewModel.showingImagePicker = true
                }) {
                    Image(systemName: "plus")
                }
                .accessibility(identifier: "addImageButton")
            }
            .sheet(isPresented: $viewModel.showingImagePicker) {
                ImagePicker(image: $viewModel.inputImage)
                    .onDisappear {
                        if let inputImage = viewModel.inputImage {
                            let newImageModel = ImageModel(id: images.count + 1, image: inputImage, position: CGPoint(x: 100, y: 100))
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
