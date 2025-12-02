import SwiftUI

// MARK: - Improved Puzzle View Model with Precise Image Slicing
class PuzzleViewModel: ObservableObject {
    @Published private var puzzleModel: PuzzleModel
    
    private let puzzleConfigs: [(imageName: String, columns: Int, rows: Int)] = [
        (AppConstants.ImageNames.maunaLoa, 2, 2),
        (AppConstants.ImageNames.mountTambora, 3, 3),
        (AppConstants.ImageNames.mountErebus, 3, 3),
        (AppConstants.ImageNames.ojosDelSalado, 4, 4),
        (AppConstants.ImageNames.pic5Pic, 4, 4),
    ]
    
    @Published var selectedPuzzleIndex: Int = 0 {
        didSet {
            loadPuzzle()
        }
    }
    
    @Published var imageParts: [[UIImage]] = []
    @Published var moveCount: Int = 0
    
    var columns: Int { puzzleModel.columns }
    var rows: Int { puzzleModel.rows }
    
    init() {
        let (initialImage, cols, rows) = puzzleConfigs[0]
        self.puzzleModel = PuzzleModel(columns: cols, rows: rows)
        self.imageParts = Self.sliceImagePrecisely(named: initialImage, columns: cols, rows: rows)
    }
    
    private func loadPuzzle() {
        let config = puzzleConfigs[selectedPuzzleIndex]
        puzzleModel = PuzzleModel(columns: config.columns, rows: config.rows)
        imageParts = Self.sliceImagePrecisely(
            named: config.imageName,
            columns: config.columns,
            rows: config.rows
        )
        moveCount = 0
    }
    
    func shuffle() {
        puzzleModel.shuffle()
        moveCount = 0
    }
    
    func sort() {
        puzzleModel.sort()
        moveCount = 0
    }
    
    func tapTile(at coord: Coord) {
        guard let empty = puzzleModel.emptyCoord() else { return }
        let dx = abs(empty.x - coord.x)
        let dy = abs(empty.y - coord.y)
        
        if (dx == 1 && dy == 0) || (dx == 0 && dy == 1) {
            puzzleModel.swapTiles(at: coord, and: empty)
            moveCount += 1
        }
    }
    
    func isPuzzleComplete() -> Bool {
        puzzleModel.isComplete()
    }
    
    func tile(at coord: Coord) -> Coord? {
        let grid = puzzleModel.data
        guard coord.x >= 0, coord.x < grid.count,
              coord.y >= 0, coord.y < grid[coord.x].count else {
            return nil
        }
        return grid[coord.x][coord.y]
    }
    
    // MARK: - PRECISE Image Slicing (Inspired by SwiftImage approach)
    private static func sliceImagePrecisely(named imageName: String,
                                          columns: Int,
                                          rows: Int) -> [[UIImage]] {
        // Error handling: Check if image exists
        guard let original = UIImage(named: imageName) else {
            print("⚠️ Error: Image '\(imageName)' not found in bundle. Creating placeholders.")
            return createPlaceholderImages(columns: columns, rows: rows)
        }
        
        guard let cgImg = original.cgImage else {
            print("⚠️ Error: Could not get CGImage from '\(imageName)'. Creating placeholders.")
            return createPlaceholderImages(columns: columns, rows: rows)
        }
        
        let imageWidth = cgImg.width
        let imageHeight = cgImg.height
        
        // Validate dimensions
        guard imageWidth > 0 && imageHeight > 0 else {
            print("⚠️ Error: Invalid image dimensions for '\(imageName)'. Creating placeholders.")
            return createPlaceholderImages(columns: columns, rows: rows)
        }
        
        // Calculate exact tile dimensions using integer division
        let tileWidth = imageWidth / columns
        let tileHeight = imageHeight / rows
        
        // Validate tile dimensions
        guard tileWidth > 0 && tileHeight > 0 else {
            print("⚠️ Error: Invalid tile dimensions for '\(imageName)'. Creating placeholders.")
            return createPlaceholderImages(columns: columns, rows: rows)
        }
        
        print("📐 Image: \(imageWidth)x\(imageHeight), Tiles: \(tileWidth)x\(tileHeight)")
        
        // Check if image divides evenly
        let remainderWidth = imageWidth % columns
        let remainderHeight = imageHeight % rows
        
        if remainderWidth != 0 || remainderHeight != 0 {
            print("⚠️ Warning: Image \(imageName) doesn't divide evenly!")
            print("   Recommended size: \(tileWidth * columns)x\(tileHeight * rows)")
        }
        
        var result = [[UIImage]](
            repeating: [UIImage](repeating: UIImage(), count: rows),
            count: columns
        )
        
        for x in 0..<columns {
            for y in 0..<rows {
                // Use precise integer calculations like SwiftImage
                let startX = tileWidth * x
                let startY = tileHeight * y
                let endX = min(startX + tileWidth, imageWidth)
                let endY = min(startY + tileHeight, imageHeight)
                
                let cropRect = CGRect(
                    x: startX,
                    y: startY,
                    width: endX - startX,
                    height: endY - startY
                )
                
                // Error handling for cropping
                if let croppedCG = cgImg.cropping(to: cropRect) {
                    result[x][y] = UIImage(cgImage: croppedCG)
                } else {
                    print("⚠️ Warning: Failed to crop tile at (\(x), \(y)) for '\(imageName)'. Using placeholder.")
                    result[x][y] = createColoredPlaceholder(
                        x: x,
                        y: y,
                        size: CGSize(width: tileWidth, height: tileHeight)
                    )
                }
            }
        }
        
        return result
    }
    
    // MARK: - Image Size Validation
    static func validateImageSize(named imageName: String, columns: Int, rows: Int) -> (isValid: Bool, recommendedSize: String) {
        guard let image = UIImage(named: imageName),
              let cgImg = image.cgImage else {
            return (false, "Image not found")
        }
        
        let width = cgImg.width
        let height = cgImg.height
        let isWidthDivisible = width % columns == 0
        let isHeightDivisible = height % rows == 0
        
        if isWidthDivisible && isHeightDivisible {
            return (true, "\(width)x\(height) ✅")
        } else {
            let tileWidth = width / columns
            let tileHeight = height / rows
            let recommendedWidth = tileWidth * columns
            let recommendedHeight = tileHeight * rows
            return (false, "Current: \(width)x\(height), Recommended: \(recommendedWidth)x\(recommendedHeight)")
        }
    }
    
    private static func createPlaceholderImages(columns: Int, rows: Int) -> [[UIImage]] {
        var result = [[UIImage]](
            repeating: [UIImage](repeating: UIImage(), count: rows),
            count: columns
        )
        
        for x in 0..<columns {
            for y in 0..<rows {
                result[x][y] = createColoredPlaceholder(x: x, y: y, size: CGSize(width: 100, height: 100))
            }
        }
        
        return result
    }
    
    private static func createColoredPlaceholder(x: Int, y: Int, size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let colors: [UIColor] = [.systemRed, .systemBlue, .systemGreen, .systemOrange, .systemPurple, .systemCyan]
            let colorIndex = (x + y) % colors.count
            colors[colorIndex].setFill()
            context.fill(CGRect(origin: .zero, size: size))
            
            let text = "\(x+1),\(y+1)"
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.white,
                .font: UIFont.systemFont(ofSize: min(size.width, size.height) * 0.2, weight: .bold)
            ]
            let textSize = text.size(withAttributes: attributes)
            let textRect = CGRect(
                x: (size.width - textSize.width) / 2,
                y: (size.height - textSize.height) / 2,
                width: textSize.width,
                height: textSize.height
            )
            text.draw(in: textRect, withAttributes: attributes)
        }
    }
    
    // MARK: - Debug function to check all your images
    static func checkAllImageSizes() {
        let configs = [
            (AppConstants.ImageNames.maunaLoa, 2, 2),
            (AppConstants.ImageNames.mountTambora, 3, 3),
            (AppConstants.ImageNames.mountErebus, 3, 3),
            (AppConstants.ImageNames.ojosDelSalado, 4, 4),
            (AppConstants.ImageNames.pic5Pic, 4, 4),
        ]
        
        print("🔍 Checking image sizes for perfect division:")
        for (imageName, columns, rows) in configs {
            let result = validateImageSize(named: imageName, columns: columns, rows: rows)
            let status = result.isValid ? "✅" : "❌"
            print("   \(status) \(imageName) (\(columns)x\(rows)): \(result.recommendedSize)")
        }
    }
}
