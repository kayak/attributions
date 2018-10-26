# Attributions

Attributions is a framework used to acknowledge Third-Party Libraries and build tools used to develop and maintain your iOS application. Here's an example:

| <img src="https://github.com/kayak/attributions/blob/master/Screenshots/AttributionsListView.png" style="width: 50%; height: 50%"> | <img src="https://github.com/kayak/attributions/blob/master/Screenshots/AttributionsLicenseView.png" style="width: 50%; height: 50%"> |
:---:|:---:


## Compile Attributions

Attributions includes two scripts: one that compiles Attributions from Carthage dependencies, and the other which compiles Attributions from GitHub Repositories (for user specified Third-Party Libraries not managed by Carthage). Remaining Attributions can be specified manually by the user.

### From Cartfile

To compile Attributions for dependencies managed by Carthage:

* Run `carthage checkout --no-use-binaries` to download framework sources into your project's `Carthage/Checkouts` directory
* Run `python cartfile2json.py [directory containing Carthage files] [output.json]`

#### Customization

It's possible to further customize displayed Carthage attributions by modifying `Cartfile` with Attributions macros, which are comments with a simple syntax:

``` text
# Attributions[macro_key]=macro_value
github "kayak/attributions"
```

Attributions macros apply to the next Carthage framework declaration. You can define multiple macros for a framework by separating each macro into separate line:

``` text
# Attributions[key1]=value1
# Attributions[key2]=value2
github "kayak/attributions"
```

### Change attribution display name

Since framework name is inferred from second path of Carthage identifier (after slash), some framework attributions may not display with a self descriptive name. To provide a custom name for an attribution, insert `display_name` macro into `Cartfile`:

``` text
# Attributions[display_name]=KAYAK Attributions
github "kayak/attributions"
```

### Limit attribution to specific bundle identifier

If you build multiple apps in one workspace, but there are frameworks, which are only embedded into a subset of those apps, you can limit displayed attributions to only that subset. Collect main app bundle identifiers and insert them with a `displayed_for_main_bundle_ids` macro into `Cartfile`:

``` text
# Attributions[displayed_for_main_bundle_ids]=com.company.myapp1,com.company.mayapp2
github "kayak/attributions"
```

This macro is optional and not providing it, displays the framework attribution in all your apps.

### Custom GitHub Attributions

To compile Attributions for Third-Party Libraries with GitHub Repositories:

* Create an input file containing a list of GitHub Repositories
    ``` text
    https://github.com/jenkinsci/jenkins
    https://github.com/fastlane/fastlane
    https://github.com/realm/SwiftLint
    ```
* Then, run `python attributions2json.py [./input file] [output.json]`

`attributions2json.py` uses GitHub's JSON API. You can work around rate limits by generating an access token and exporting it under `GITHUB_ACCESS_TOKEN` in your shell session.

## Example Attribution JSON Files

* Output file from scripts:

``` json
[
    {
        "name": "[Attribution from Carthage/GitHub]",
        "license": {
            "text": "This is a license... "
        }
    },
    ...
]
```

* Example for manually specifying other attributions:

``` json
[
    {
        "name": "[Attribution from user specified license files]",
        "license": {
            "id": "unlicense"
        }
    },
    {
        "name": "[Attribution from license in main bundle]",
        "license": {
            "filename": "unlicenseMain.txt"
        }
    },
    {
        "name": "[Attribution from license in another framework]",
        "license": {
            "bundleID" : "com.kayak.Framework",
            "filename": "unlicenseFW.txt"
        }
    }
]
```

**NOTE**: Attributions no longer includes common license files. If you want to continue specifying licenses with the `id` property, you will have to supply the license files yourself. The `setAttributions()` function on `AttributionViewController` now includes a new parameters for passing in an array of these licenses. Each should be the full path to the license file.

## Usage

* `AttributionViewController` - is a subclassed UITableViewController that lists all the Attributions in a grouped UITableView. It has two public members:
  * `attributionStyle` - an `AttributionStyle` struct used to modify styles (described below)
  * `setAttributions(from sections: [AttributionSections])` - creates and compiles Attributions from all input JSON files, and populates a grouped UITableView with the data. Each input file is handled as its own section.
  * NOTE: To use the AttributionViewController, the user must subclass the AttributionViewController, and add an initializer that calls `super.init(style: .grouped)`
* `AttributionStyles` - is a struct that controls some styling options. Some or all the style parameters  can be specified when instantiated. If a parameter is not specified, the default style is used.
    * `textColor: UIColor` - `black` by default
    * `rowHeight: CGFloat` - `44` by default
    * `statusBarStyle: UIStatusBarStyle`. - `.default` by default
* `AttributionSections` - is a struct used to define each input JSON Attribution file.
  * `file` -  URL specifying location of Attribution JSON file
  * `description` - String describing the file (i.e. "Carthage")

To incorporate Attributions into your project, add the compiled Attribution JSON files to the project. Instantiate an AttributionViewController object, and set the `attributionStyles`. Build an array of `AttributionSections` from the compiled Attributions JSON files. Then call `controller.setAttributions(from: [AttributionSections])`. Lastly, add the AttributionViewController to the desired `UINavigationController`. For more details, please reference the Example App provided and the code snippet below.

* Attributions Implementation Example:

``` swift
let attributionController = AttributionController()
guard let carthageFile = Bundle.main.url(forResource: "carthageAttributions", withExtension: "json") else {
    assertionFailure("File not found")
    return false
}
guard let customAttributionsFile = Bundle.main.url(forResource: "customAttributions", withExtension: "json") else {
    assertionFailure("File not found")
    return false
}
let sections = [
    AttributionSection(file: carthageFile, description: "Carthage"),
    AttributionSection(file: customAttributionsFile, description: "Other")
]
do {
    try attributionController.setAttributions(from: sections)
} catch {
    assertionFailure(error.localizedDescription)
    return false
}

let navController = UINavigationController()
navController.viewControllers = [attributionController as UIViewController]
```
