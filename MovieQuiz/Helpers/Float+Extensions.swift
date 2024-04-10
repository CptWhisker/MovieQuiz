import Foundation

extension Float {
    func generateNumberForComparison() -> Float {
        var factor: Float
        
        switch self {
        case 9...:
            factor = Float.random(in: -0.8...0.2)
        case 8.5..<9:
            factor = Float.random(in: -0.5...0.5)
        default:
            factor = Float.random(in: -0.2...0.8)
        }
        return self + factor
    }
}
