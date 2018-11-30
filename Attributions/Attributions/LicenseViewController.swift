import UIKit

final class LicenseViewController: UIViewController  {

    var attributionStyle = AttributionStyle()
    var licenseReader: LicenseReader?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        let containerView = UIView(frame: .zero)
        containerView.layoutMargins = .zero
        containerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        let textView = UITextView(frame: .zero)
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.text = try? licenseReader?.text() ?? ""
        textView.font = .systemFont(ofSize: 15)
        textView.textColor = attributionStyle.textColor
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

        textView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: containerView.readableContentGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: containerView.readableContentGuide.trailingAnchor),
            textView.topAnchor.constraint(equalTo: containerView.topAnchor),
            textView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = licenseReader?.attribution.name
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return attributionStyle.statusBarStyle
    }

}
