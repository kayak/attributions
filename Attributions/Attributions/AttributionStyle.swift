import Foundation
import UIKit

public struct AttributionStyle {

    public let backgroundColor: UIColor
    public let licenseBackgroundColor: UIColor
    public let cellBackgroundColor: UIColor

    /// The background color for selected cells. Use `nil` to retain the system default.
    public let cellSelectionColor: UIColor?

    public let textColor: UIColor
    public let rowHeight: CGFloat
    public let statusBarStyle: UIStatusBarStyle

    public init(
        backgroundColor: UIColor = .groupTableViewBackground,
        licenseBackgroundColor: UIColor = .white,
        cellBackgroundColor: UIColor = .white,
        cellSelectionColor: UIColor? = nil,
        textColor: UIColor = .black,
        rowHeight: CGFloat = 44,
        statusBarStyle: UIStatusBarStyle = .default)
    {
        self.backgroundColor = backgroundColor
        self.licenseBackgroundColor = licenseBackgroundColor
        self.cellBackgroundColor = cellBackgroundColor
        self.cellSelectionColor = cellSelectionColor
        self.textColor = textColor
        self.rowHeight = rowHeight
        self.statusBarStyle = statusBarStyle
    }

}
