# Attributions

Attributions is a framework used to acknowledge Third-Party Libraries and build tools used to develop and maintain your iOS application. Here's an example:

![Framed Screenshot](https://github.com/kayak/attributions/blob/SourceCode/Screenshots/AttributionsListView.png) ![Framed Screenshot](https://github.com/kayak/attributions/blob/SourceCode/Screenshots/AttributionsListView.png)

## Compile Attributions

Attributions includes two scripts: one that compiles Attributions from Carthage dependencies, and the other which compiles Attributions from GitHub Repositories for user specified Third-Party Libraries. Remaining Attributions can be built from commonly used licenses, bundled within the framework, or specified by the user manually.

* To compile Attributions for dependencies managed by Carthage:
	* Run `update Carthage` to build the project's Carthage directory, if needed
	*  Run 	`python cartfile2json.py [directory containing Carthage files] 	[output.json]`

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

      ```json
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

* `AttributionViewController` - contains an `attributionStyle: AttributionStyle` public member variable, and a public `func setAttributions(from sections: [AttributionSections])`.  `setAttributions(from sections:)` compiles all input JSON files, and populates a UITableView with the data.
* `AttributionStyles` - is a struct containing the following mutable parameters: `textColor: UIColor`, `rowHeight: CGFloat`, and `statusBarStyle: UIStatusBarStyle`. Some or all the style parameters  can be specified when instantiated. If not specified, default styles are used.
* `AttributionSections` - is a struct used to define the input JSON Attribution file. Each file is treated as its own section. `AttributionSection` has two member variables and is initialized with `AttributionSections(file: URL, description: String)`

To incorporate Attributions into your project, add the compiled Attribution JSON files to the project. Instantiate an AttributionViewController object `let controller = AttributionViewController()`, and set `controller.attributionStyles()`. Build an array of `AttributionSections`. For example  from the compiled Attribution JSON files. Then call `controller.setAttributions(from: [AttributionSections])`. Lastly, add the AttributionViewController to the desired `UINavigationController`. For more details, please reference the AppDelegate in the Example App provided.

![Framed Screenshot](https://github.com/kayak/attributions/blob/SourceCode/Screenshots/SampleUsageCode.png)
