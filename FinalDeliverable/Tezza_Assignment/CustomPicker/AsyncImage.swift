import SwiftUI
import Photos


struct AsyncImage: View {
    let asset: PHAsset
    let size: CGSize
    
    var body: some View {
        Color.gray
            .overlay {
                GeometryReader { proxy in
                    AsyncImageLoader( asset: asset, size: size)
                }
            }
    }
}

private struct AsyncImageLoader: UIViewRepresentable {
    let asset: PHAsset
    let size: CGSize

    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }

    func updateUIView(_ imageView: UIImageView, context: Context) {
        if let cachedImage = ImageCache2.shared.getImage(for: asset.localIdentifier) {
            imageView.image = cachedImage
            return
        }

        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = false
        options.isNetworkAccessAllowed = true // Fetch from iCloud if needed
        options.resizeMode = .exact

        PHImageManager.default().requestImage(
            for: asset,
            targetSize: CGSize(width: 500, height: 500),
            contentMode: .aspectFill,
            options: options
        ) { image, _ in

            if let image = image {
                let imager = resizeImage(image: image, targetSize: size)
                DispatchQueue.main.async {
                    imageView.image = imager
                    if let imager = imager {
                        ImageCache2.shared.setImage(imager, for: self.asset.localIdentifier)
                    }
                }
            }
        }
    }
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Choose the smaller ratio to ensure it fits within the target size
        let scaleFactor = min(widthRatio, heightRatio)

        let newSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)

        // Render the resized image
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage
    }
}

class ImageCache2 {
    static let shared = ImageCache2()
    private var memoryCache: [String: UIImage] = [:]
    private let lock = NSLock()
    
    func getImage(for identifier: String) -> UIImage? {
        lock.lock(); defer { lock.unlock() }
        return memoryCache[identifier]
    }
    
    func setImage(_ image: UIImage, for identifier: String) {
        lock.lock(); defer { lock.unlock() }
        memoryCache[identifier] = image
    }
}
//-- BUT CRASHES BECAUSE WHEN IT TRIES TO PROCESS 200/300 IMAGES AT A TIME THEN DUE TO MEMORY ISSUE
//   THE APP CRASHES

