#!usr/bin/python2

import json
import os
import sys

CARTHAGE = 'Carthage/Checkouts'
CART_RESOLVED = 'Cartfile.resolved'


class Attribution():
    def __init__(self, name, license):
        self.name = name
        self.license = {'text' : license}


def exportJSON(output, *attributions):
    """converts Attribution List to json and prints to specified output file"""
    jsonResult = json.dumps([a.__dict__ for a in attributions], sort_keys=False, indent=4)
    try:
        with open(output, 'w') as file:
            file.write(jsonResult)
            file.close()
    except IOError as e:
        print 'I/O Error: ({0}) : {1}'.format(e.errno, e.strerror)


def getNames(cartResolved):
    """returns all attribution names in Cartfile.resolved"""
    names = []
    try:
        with open(cartResolved) as f:
            for line in f:
                attributes = line.split()
                repo = attributes[1].strip('"')
                name = repo.split('/')[1]
                names.append(name)
    except IOError as e:
        print 'Could not open {}'.format(cartResolved)
        sys.exit(1)
    return names


def validateDirectory(directory):
    if not os.path.isdir(directory):
        print 'Invalid Directory: {}'.format(directory)
        sys.exit(1)


def validateFile(file):
    if not os.path.isfile(file):
        print 'File not found: {}'.format(file)
        sys.exit(1)


def buildCarthageAttributions(directory):
    """builds attributions list from all names contained in both Cartfile.resolved file and Carthage/Checkouts directory"""
    cartDirectory = os.path.join(directory, CARTHAGE)
    validateDirectory(cartDirectory)
    cartResolved = os.path.join(directory, CART_RESOLVED)
    validateFile(cartResolved)

    # return all names listed in both Cartfile.resolved, and Carthage/Checkouts
    frameworks = [n for n in getNames(cartResolved) if n in os.listdir(cartDirectory)]

    # find, open and extract data in LICENSE file from Carthage/Checkouts/[framework]
    attributions = []
    for framework in frameworks:
        frameworkDirectory = os.path.join(cartDirectory, framework)
        validateDirectory(frameworkDirectory)
        filename = [f for f in os.listdir(frameworkDirectory) if f.startswith('LICENSE')]
        fname = filename[0]
        try:
            text = open(os.path.join(frameworkDirectory, fname)).read()
        except IOError as e:
            print 'I/O Error: ({0}) : {1}'.format(fname, e.strerror)
        attributions.append(Attribution(framework, text))
    return attributions


if __name__ == '__main__':
    if len(sys.argv) != 3:
        print 'Missing script argument: ./cartfile2json [Carthage directory path] [outputFile.json]'
        sys.exit(1)
    directory = sys.argv[1]
    validateDirectory(directory)
    outputFile = sys.argv[2]
    if outputFile.endswith('.json'):
        d = buildCarthageAttributions(directory)
        exportJSON(outputFile, *d)
    else:
        print 'Output file must be .json'
        sys.exit(1)
