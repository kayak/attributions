import UIKit

open class AttributionViewController: UITableViewController {

    public var attributionStyle = AttributionStyle()
    private var attributions = [[Attribution]]()
    private var attributionSections = [AttributionSection]()
    private var licenseFiles: [String] = []

    public func setAttributions(from sections: [AttributionSection], mainBundle: Bundle = Bundle.main, licenseFiles: [String] = []) throws {
        attributionSections = sections
        attributions = try AttributionReader().compileAttributions(sections: attributionSections, mainBundle: mainBundle, licenseFiles: licenseFiles)
        self.licenseFiles = licenseFiles
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "attributionCell")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return attributionStyle.statusBarStyle
    }

    open override func numberOfSections(in tableView: UITableView) -> Int {
        return attributions.count
    }

    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attributions[section].count
    }

    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "attributionCell", for: indexPath)
        cell.textLabel?.text = attributions[indexPath.section][indexPath.row].name
        cell.textLabel?.textColor = attributionStyle.textColor
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let licenseController = LicenseViewController()
        let licenseReader = LicenseReader(
            attribution: attributions[indexPath.section][indexPath.row],
            licenseFiles: licenseFiles)
        licenseController.licenseReader = licenseReader
        licenseController.attributionStyle = attributionStyle
        navigationController?.pushViewController(licenseController, animated: true)
    }

    open override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return attributionStyle.rowHeight
    }

    open override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return attributionSections[section].description
    }

}
