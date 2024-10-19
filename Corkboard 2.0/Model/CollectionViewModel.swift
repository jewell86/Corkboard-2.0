import SwiftUI

class CollectionViewModel: ObservableObject {
    @Published var editingNote: Note?
    @Published var editText: String = ""
    @Published var showingImagePicker = false
    @Published var inputImage: UIImage?
    @Published var showingLargeImage = false
    @Published var selectedImage: UIImage?
    @Published var images: [ImageModel] = []
    @Published var notes: [Note] = []
    @Published var isShowingImageView = false
}
