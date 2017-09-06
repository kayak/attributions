import UIKit

final class LicenseViewController: UIViewController  {
    
    private let textView = UITextView()
    var attribution: Attribution?
    var attributionStyle = AttributionStyle()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.isScrollEnabled = false
        textView.text = try! attribution?.license.getText()
        textView.font = .systemFont(ofSize: 15)
        textView.textColor = attributionStyle.textColor
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        self.view.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            textView.topAnchor.constraint(equalTo: self.view.topAnchor),
            textView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = attribution?.name
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return attributionStyle.statusBarStyle
    }

}
