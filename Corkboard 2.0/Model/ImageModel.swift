import SwiftUI

struct ImageModel: Identifiable {
    let id = UUID()
    var image: UIImage
    var position: CGPoint
}
