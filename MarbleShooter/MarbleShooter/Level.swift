//
//  Level.swift
//  MarbleShooter
//
//  Created by Sam Knepper on 11/9/16.
//  Copyright © 2016 Apress. All rights reserved.
//

import Foundation

let NumColumns = 10
let NumRows = 7

class Level {
    fileprivate var balls = Matrix<Ball>(columns: NumColumns, rows: NumRows)

    init(filename: String) {
        // 1
        guard let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(filename: filename) else { return }
        // 2
        guard let slotsArray = dictionary["slots"] as? [[Int]] else { return }
        // 3
        for (row, rowArray) in slotsArray.enumerated() {
            // 4
            let slotRow = NumRows - row - 1
            // 5
            for (column, value) in rowArray.enumerated() {
                if value == 1 {
                    slots[column, slotRow] = Slot()
                }
            }
        }
    }
    
    func ballAt(column: Int, row: Int) -> Ball? {
        //use of assert() to verify that the specified
        //column and row numbers are within the valid range
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return balls[column, row]
    }
    
    func shuffle() -> Set<Ball> {
        return createInitialBalls()
    }
    
    private func createInitialBalls() -> Set<Ball> {
        var set = Set<Ball>()
        
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                if slots[column, row] != nil {
                    var ballType = BallType.random()
                
                    let ball = Ball(column: column, row: row, ballType: ballType)
                    balls[column, row] = ball
                
                    set.insert(ball)
                }
            }
        }
        return set
    }
    
    private var slots = Matrix<Slot>(columns: NumColumns, rows: NumRows)
    
    func slotAt(column: Int, row: Int) -> Slot? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return slots[column, row]
    }

}


