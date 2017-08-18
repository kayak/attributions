# Attributions

Attributions is a framework used to acknowledge Third-Party Libraries and build tools used to develop and maintain your iOS application. Here's an example:

![Framed Screenshot](https://github.com/kayak/attributions/blob/SourceCode/Screenshots/AttributionsListView.png) ![Framed Screenshot](https://github.com/kayak/attributions/blob/SourceCode/Screenshots/AttributionsLicenseView.png)

## Compile Attributions

Attributions includes two scripts: one that compiles Attributions from Carthage dependencies, and the other which compiles Attributions from GitHub Repositories for user specified Third-Party Libraries. Remaining Attributions can be built from commonly used licenses, bundled within the framework, or specified manually by the user.

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

* `AttributionViewController` - is a subclassed UITableViewController that lists all the Attributions. It has two public members:
  * `attributionStyle` - an `AttributionStyle` struct used to modify styles (described below)
  * `func setAttributions(from sections: [AttributionSections])` - creates and compiles Attributions from all input JSON files, and populates a UITableView with the data.
* `AttributionStyles` - is a struct that controls some styling options.
    * `textColor: UIColor` - `black` by default
    * `rowHeight: CGFloat` - `44` by default
    * `statusBarStyle: UIStatusBarStyle`. - `.default` by default
  Some or all the style parameters  can be specified when instantiated. If a parameter is not specified, the default style is used.
* `AttributionSections` - is a struct used to define each input JSON Attribution file. Each file is treated as its own section.
  * `file` -  URL specifying location of Attribution JSON file
  * `description` - String describing the file (i.e. "Carthage")

To incorporate Attributions into your project, add the compiled Attribution JSON files to the project. Instantiate an AttributionViewController object `let controller = AttributionViewController()`, and set `controller.attributionStyles()`. Build an array of `AttributionSections` from the compiled Attribution JSON files. Then call `controller.setAttributions(from: [AttributionSections])`. Lastly, add the AttributionViewController to the desired `UINavigationController`. For more details, please reference the AppDelegate in the Example App provided.

![Framed Screenshot](https://github.com/kayak/attributions/blob/SourceCode/Screenshots/SampleUsageCode.png)
