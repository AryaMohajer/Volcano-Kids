import Foundation

/// A simple coordinate struct used in the puzzle grid.
struct Coord: Equatable {
    var x: Int
    var y: Int
}

/// Encapsulates the core puzzle data (the grid of tile coordinates).
struct PuzzleModel {
    /// A 2D array whose elements are either:
    ///   - `Coord(x: y:)` for a tile, or
    ///   - `nil` for the empty slot
    var data: [[Coord?]]
    
    /// Number of columns in the puzzle.
    let columns: Int
    
    /// Number of rows in the puzzle.
    let rows: Int
    
    init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        self.data = Self.initialData(columns: columns, rows: rows)
    }
    
    /// Creates a "solved" grid, with the last cell empty (nil).
    static func initialData(columns: Int, rows: Int) -> [[Coord?]] {
        var grid = [[Coord?]]()
        for x in 0..<columns {
            var col: [Coord?] = []
            for y in 0..<rows {
                col.append(Coord(x: x, y: y))
            }
            grid.append(col)
        }
        // Make the last slot nil, creating the sliding-puzzle empty space.
        grid[columns - 1][rows - 1] = nil
        return grid
    }
    
    // MARK: - Puzzle Logic
    
    /// Shuffle the puzzle randomly (not guaranteed solvable).
    mutating func shuffle() {
        let flattened = data.flatMap { $0 }
        let shuffled = flattened.shuffled()
        data = Array(shuffled.chunked(into: rows))
    }
    
    /// Reset back to the sorted arrangement.
    mutating func sort() {
        data = Self.initialData(columns: columns, rows: rows)
    }
    
    /// Swaps the content of two cells in the grid.
    mutating func swapTiles(at c1: Coord, and c2: Coord) {
        let tmp = data[c1.x][c1.y]
        data[c1.x][c1.y] = data[c2.x][c2.y]
        data[c2.x][c2.y] = tmp
    }
    
    /// Returns the coordinate of the empty slot (where data[x][y] is nil).
    func emptyCoord() -> Coord? {
        for x in 0..<columns {
            for y in 0..<rows {
                if data[x][y] == nil {
                    return Coord(x: x, y: y)
                }
            }
        }
        return nil
    }
    
    /// Check if the puzzle is in the solved state.
    func isComplete() -> Bool {
        for x in 0..<columns {
            for y in 0..<rows {
                let correctTile = (x == columns - 1 && y == rows - 1)
                    ? nil
                    : Coord(x: x, y: y)
                
                if data[x][y] != correctTile {
                    return false
                }
            }
        }
        return true
        
    }
    
}
