#!/usr/bin/env python3

import json
import os
import re
import sys

CARTHAGE = 'Carthage/Checkouts'
CARTFILE = 'Cartfile'


class Attribution():
    def __init__(self, name, displayedForMainBundleIDs, license):
        self.name = name
        self.displayedForMainBundleIDs = displayedForMainBundleIDs
        self.license = {'text' : license}


class CartfileFramework():
    def __init__(self, originalLine, name, displayName, bundle):
        self.originalLine = originalLine
        self.name = name
        self.displayName = displayName
        self.bundle = bundle


def exportJSON(output, *attributions):
    """converts Attribution List to json and prints to specified output file"""
    sortedAttributions = sorted(attributions, key=lambda a: a.name)
    jsonResult = json.dumps([a.__dict__ for a in sortedAttributions], sort_keys=False, indent=4)
    try:
        with open(output, 'w') as file:
            file.write(jsonResult)
            file.close()
    except IOError as e:
        print('I/O Error: ({0}) : {1}'.format(e.errno, e.strerror))


def parseCartfileFrameworks(cartfile):
    """returns all framework names in Cartfile"""
    frameworks = []
    macro_buffer = {}
    try:
        with open(cartfile) as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                if line.startswith('# Attributions['):
                    keyValueSearch = re.search('^# Attributions\[([a-zA-Z0-9_]+)\]=(.*)$', line)
                    if keyValueSearch:
                        macro_buffer.update({keyValueSearch.group(1): keyValueSearch.group(2)})
                    else:
                        print("Failed to parse Attributions macro '{}'".format(line))
                elif line.startswith('#') or line.startswith('binary'):
                    continue
                else:
                    components = line.split()
                    repo = components[1].strip('"')
                    frameworkName = repo.split('/')[1]
                    displayName = macro_buffer.get('display_name', frameworkName)
                    displayedForMainBundleIDsString = macro_buffer.get('displayed_for_main_bundle_ids', None)
                    displayedForMainBundleIDs = displayedForMainBundleIDsString.split(',') if displayedForMainBundleIDsString else []
                    macro_buffer = {}
                    framework = CartfileFramework(line, frameworkName, displayName, displayedForMainBundleIDs)
                    frameworks.append(framework)
    except IOError as e:
        print('Could not open {}'.format(cartfile))
        sys.exit(1)
    return frameworks


def validateDirectory(directory, messageFormat):
    if not os.path.isdir(directory):
        print(messageFormat.format(directory))
        sys.exit(1)


def validateFile(file):
    if not os.path.isfile(file):
        print('File not found: {}'.format(file))
        sys.exit(1)


def buildCarthageAttributions(directory):
    """builds attributions list from all names contained in both Cartfile file and Carthage/Checkouts directory"""
    cartDirectory = os.path.join(directory, CARTHAGE)
    validateDirectory(cartDirectory, 'Path {} is not a directory.')
    cartfile = os.path.join(directory, CARTFILE)
    validateFile(cartfile)

    # all frameworks listed in Cartfile
    cartfileFrameworks = parseCartfileFrameworks(cartfile)

    # find, open and extract data in LICENSE file from Carthage/Checkouts/[framework]
    attributions = []
    for framework in cartfileFrameworks:
        frameworkDirectory = os.path.join(cartDirectory, framework.name)
        validateDirectory(frameworkDirectory, 'Path {} is not a directory.\nMake sure to run `carthage checkout --no-use-binaries` before running this script.')
        filenames = [f for f in os.listdir(frameworkDirectory) if 'LICENSE' in f]
        filename = filenames[0]
        try:
            licenseText = open(os.path.join(frameworkDirectory, filename)).read()
        except IOError as e:
            print('I/O Error: ({0}) : {1}'.format(filename, e.strerror))
        attributions.append(Attribution(framework.displayName, framework.bundle, licenseText))
    return attributions


if __name__ == '__main__':
    if len(sys.argv) != 3:
        print('Missing script argument: ./cartfile2json [Carthage directory path] [outputFile.json]')
        sys.exit(1)
    directory = sys.argv[1]
    outputFile = sys.argv[2]
    if outputFile.endswith('.json'):
        d = buildCarthageAttributions(directory)
        exportJSON(outputFile, *d)
    else:
        print('Output file must be .json')
        sys.exit(1)
