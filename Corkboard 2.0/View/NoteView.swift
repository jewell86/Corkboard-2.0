import SwiftUI

struct NoteView: View {
    @ObservedObject var viewModel: CollectionViewModel
    @Binding var note: Note
    @State private var dragOffset = CGSize.zero

    var body: some View {
        Text(note.text)
            .padding()
            .frame(width: 150, height: 100)
            .background(Color.yellow)
            .cornerRadius(8)
            .position(note.position)
            .offset(dragOffset)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        self.dragOffset = gesture.translation
                    }
                    .onEnded { gesture in
                        note.position = CGPoint(
                            x: note.position.x + gesture.translation.width,
                            y: note.position.y + gesture.translation.height
                        )
                        self.dragOffset = .zero
                    }
            )
            .onTapGesture {
                viewModel.editingNote = $note.wrappedValue
                viewModel.editText = $note.wrappedValue.text
            }
    }
}
