# Attributions

Attributions is a framework used to acknowledge Third-Party Libraries and build tools used to develop and maintain your iOS application. Here's an example:

| <img src="https://github.com/kayak/attributions/blob/SourceCode/Screenshots/AttributionsListView.png" width="50%" height="50%"> | <img src="https://github.com/kayak/attributions/blob/SourceCode/Screenshots/AttributionsLicenseView.png" width="50%" height="50%">  |
:---:|:---:


## Compile Attributions

Attributions includes two scripts: one that compiles Attributions from Carthage dependencies, and the other which compiles Attributions from GitHub Repositories (for user specified Third-Party Libraries not managed by Carthage). Remaining Attributions can be built from commonly used licenses, bundled within the framework, or specified manually by the user.

* To compile Attributions for dependencies managed by Carthage:
	* If needed, run `update Carthage` to build the project's Carthage directory
	* Run `python cartfile2json.py [directory containing Carthage files] 	[output.json]`

* To compile Attributions for Third-Party Libraries with GitHub Repositories:
	* Create an input file containing a list of GitHub Repositories:
        ``` text
        https://github.com/jenkinsci/jenkins
	      https://github.com/fastlane/fastlane
	      https://github.com/realm/SwiftLint
      	```
  * Then, run `python attributions2json.py [./input file] [output.json]`

## Example Attribution JSON Files

* Output file from scripts:

     ```
      [
        ...
      	{
            "name": "[Attribution from Carthage/GitHub]",
            "license": {
                "text": "This is a license... "
        	}
        },
        ...
      ]
     ```

* Example for specifying all other Attributions:

    ```json
    [
      {
          "name": "[Attribution from bundled license in Attributions]",
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

To incorporate Attributions into your project, add the compiled Attribution JSON files to the project. Instantiate an AttributionViewController object, and set the `attributionStyles`. Build an array of `AttributionSections` from the compiled Attributions JSON files. Then call `controller.setAttributions(from: [AttributionSections])`. Lastly, add the AttributionViewController to the desired `UINavigationController`. For more details, please reference Example App provided.
