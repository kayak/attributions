import Foundation
import UIKit

public struct AttributionStyle {

    public let backgroundColor: UIColor
    public let cellBackgroundColor: UIColor
    public let textColor: UIColor
    public let rowHeight: CGFloat
    public let statusBarStyle: UIStatusBarStyle

    public init(
        backgroundColor: UIColor = .groupTableViewBackground,
        cellBackgroundColor: UIColor = .white,
        textColor: UIColor = .black,
        rowHeight: CGFloat = 44,
        statusBarStyle: UIStatusBarStyle = .default)
    {
        self.backgroundColor = backgroundColor
        self.cellBackgroundColor = cellBackgroundColor
        self.textColor = textColor
        self.rowHeight = rowHeight
        self.statusBarStyle = statusBarStyle
    }

}
