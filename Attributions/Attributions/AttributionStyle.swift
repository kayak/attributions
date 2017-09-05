import Foundation
import UIKit

public struct AttributionStyle {

    public let textColor: UIColor
    public let rowHeight: CGFloat
    public let statusBarStyle: UIStatusBarStyle

    public init(
        textColor: UIColor = .black,
        rowHeight: CGFloat = 44,
        statusBarStyle: UIStatusBarStyle = .default)
    {
        self.textColor = textColor
        self.rowHeight = rowHeight
        self.statusBarStyle = statusBarStyle
    }

}
