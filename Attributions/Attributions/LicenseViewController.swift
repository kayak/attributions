import UIKit

final class LicenseViewController: UIViewController  {

    private let textView = UITextView()
    var attributionStyle = AttributionStyle()
    var licenseReader: LicenseReader?

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.text = try? licenseReader?.text() ?? ""
        textView.font = .systemFont(ofSize: 15)
        textView.textColor = attributionStyle.textColor
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textView.topAnchor.constraint(equalTo: view.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        textView.isScrollEnabled = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = licenseReader?.attribution.name
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return attributionStyle.statusBarStyle
    }

}
