import Foundation

final class FillWithColor {

    func fillWithColor(_ image: [[Int]], _ row: Int, _ column: Int, _ newColor: Int) -> [[Int]] {
        for row in image.indices {
            for column in image[row].indices {
                if image[row][column] < 0 {
                    return image
                }
            }
        }
        let m = image.count
        let n = image[row].count
        guard 1 <= m && n <= 50 && newColor < 65536 && 0 <= row && row <= m && 0 <= column && column <= n  else {
            return image
        }
        let oldColor = image[row][column]
        
        let rowMin = image.startIndex
        let rowMax = image.endIndex - 1
        
        let columnMin = image[row].startIndex
        let columnMax = image[row].endIndex - 1
        
        var fillImage = image
        var arrayOfPixels = [(row,column)]
        
        func fourDirectionaly (row: Int, column: Int) {
            if fillImage[row][column] == oldColor {
                fillImage[row][column] = newColor
                if row != rowMin {
                    arrayOfPixels += [(row-1, column)]
                }
                if row != rowMax {
                    arrayOfPixels += [(row+1, column)]
                }
                if column != columnMin {
                    arrayOfPixels += [(row, column-1)]
                }
                if column != columnMax {
                    arrayOfPixels += [(row, column+1)]
                }
            }
        }
        while arrayOfPixels.count != 0 {
            fourDirectionaly(row: arrayOfPixels[0].0, column: arrayOfPixels[0].1)
            arrayOfPixels.removeFirst()
        }
        return fillImage
    }
}
