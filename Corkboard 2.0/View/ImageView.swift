import SwiftUI

struct ImageView: View {
    @ObservedObject var viewModel: CollectionViewModel
    @Binding var imageModel: ImageModel
    @State private var dragOffset = CGSize.zero

    var body: some View {
        Image(uiImage: imageModel.image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 150, height: 100)
            .position(imageModel.position)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                       self.dragOffset = gesture.translation
                   }
                   .onEnded { gesture in
                       imageModel.position = CGPoint(
                           x: imageModel.position.x + gesture.translation.width,
                           y: imageModel.position.y + gesture.translation.height
                       )
                       self.dragOffset = .zero
                   }
            )
            .onTapGesture {
                viewModel.selectedImage = $imageModel.image.wrappedValue
                viewModel.showingLargeImage = true
            }
    }
}

struct LargeImageView: View {
    @Binding var isPresented: Bool

    var image: UIImage

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
            .background(.black)
            .position(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY) //Centering
            .gesture(TapGesture().onEnded {
                isPresented = false
            })
    }
}
