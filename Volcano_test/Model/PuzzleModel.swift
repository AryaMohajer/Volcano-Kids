import Foundation

/// A simple coordinate struct used in the puzzle grid.
struct Coord: Hashable {
    let x: Int
    let y: Int
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
    
    /// Shuffle the puzzle by making valid random moves from solved state (guarantees solvability).
    mutating func shuffle() {
        // Start from solved state
        sort()
        
        // Make many random valid moves to shuffle
        let shuffleMoves = max(columns * rows * 20, 100) // More moves for larger puzzles
        
        for _ in 0..<shuffleMoves {
            guard let empty = emptyCoord() else { continue }
            
            // Get all valid adjacent tiles
            var validMoves: [Coord] = []
            
            // Check all 4 directions
            let directions = [
                Coord(x: empty.x - 1, y: empty.y),     // Left
                Coord(x: empty.x + 1, y: empty.y),     // Right
                Coord(x: empty.x, y: empty.y - 1),     // Up
                Coord(x: empty.x, y: empty.y + 1)      // Down
            ]
            
            for dir in directions {
                if isValidCoord(dir) && tile(at: dir) != nil {
                    validMoves.append(dir)
                }
            }
            
            // Randomly pick one valid move
            if let randomMove = validMoves.randomElement() {
                swapTiles(at: randomMove, and: empty)
            }
        }
    }
    
    func isValidCoord(_ coord: Coord) -> Bool {
        return coord.x >= 0 && coord.x < columns && coord.y >= 0 && coord.y < rows
    }
    
    func tile(at coord: Coord) -> Coord? {
        guard isValidCoord(coord) else { return nil }
        return data[coord.x][coord.y]
    }
    
    /// Reset back to the sorted arrangement.
    mutating func sort() {
        data = Self.initialData(columns: columns, rows: rows)
    }
    
    /// Swaps the content of two cells in the grid.
    mutating func swapTiles(at c1: Coord, and c2: Coord) {
        guard isValidCoord(c1) && isValidCoord(c2) else { return }
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
    
    // MARK: - Help/Hint: Find next best move
    /// Returns a coordinate that should be moved next (if any)
    func getHint() -> Coord? {
        guard let empty = emptyCoord() else { return nil }
        
        // Check all adjacent tiles
        let adjacentTiles = [
            Coord(x: empty.x - 1, y: empty.y),     // Left
            Coord(x: empty.x + 1, y: empty.y),     // Right
            Coord(x: empty.x, y: empty.y - 1),     // Up
            Coord(x: empty.x, y: empty.y + 1)      // Down
        ]
        
        // Find tile that should be in the empty position
        let targetCoord = empty
        
        // Check if any adjacent tile should be in the empty position
        for tileCoord in adjacentTiles {
            guard isValidCoord(tileCoord),
                  let tileAtPos = tile(at: tileCoord) else { continue }
            
            // If this tile should be at the empty position, suggest moving it
            if tileAtPos == targetCoord {
                return tileCoord
            }
        }
        
        // If no direct match, find the tile that should be closest to its correct position
        var bestMove: Coord?
        var bestScore = Int.max
        
        for tileCoord in adjacentTiles {
            guard isValidCoord(tileCoord),
                  let tileAtPos = tile(at: tileCoord) else { continue }
            
            // Calculate Manhattan distance from current position to correct position
            let distance = abs(tileAtPos.x - tileCoord.x) + abs(tileAtPos.y - tileCoord.y)
            
            // If moving this tile would reduce distance, it's a good hint
            let newDistance = abs(tileAtPos.x - empty.x) + abs(tileAtPos.y - empty.y)
            if newDistance < distance && newDistance < bestScore {
                bestScore = newDistance
                bestMove = tileCoord
            }
        }
        
        return bestMove
    }
}
