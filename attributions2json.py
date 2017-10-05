#!/usr/bin/env python2

import json
import os
import shlex
import subprocess
import sys


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


def getGitRepos(input):
    with open(input) as file:
        gitURLs = [line.strip() + '/trunk' for line in file]
    return gitURLs


def getNameFrom(gitRepo):
    return gitRepo.split('github.com/')[1].split('/')[1]


def getLicenseFileNameFrom(gitRepo):
    command = '{} {}'.format('svn ls', gitRepo)
    output = spawnProcessWith(command)
    repoContents = ''.join(output).split()
    filename = [f for f in repoContents if f.startswith('LICENSE')]
    if filename:
        return filename[0]


def getLicenseTextFrom(gitRepo):
    filename = getLicenseFileNameFrom(gitRepo)
    if filename:
        command = '{} {}/{}'.format('svn cat', gitRepo, filename)
        return spawnProcessWith(command)


def spawnProcessWith(command):
    p = subprocess.Popen(shlex.split(command), stdout=subprocess.PIPE, shell=False)
    (output, err) = p.communicate()
    return output


def validateFile(file, type):
    if type is 'input':
        if not os.path.isfile(file):
            print 'File not found: {}'.format(file)
            sys.exit(1)
    else:
        if not file.endswith('.json'):
            print 'Output file must be .json'
            sys.exit(1)


if __name__ == '__main__':
    if len(sys.argv) != 3:
        print 'Missing script argument: ./attributions2json [./Attribution File] [outputFile.json]'
        sys.exit(1)
    inputFile = sys.argv[1]
    validateFile(inputFile, 'input')
    outputFile = sys.argv[2]
    validateFile(outputFile, 'output')

    urls = getGitRepos(inputFile)
    attributions = []
    for url in urls:
        name = getNameFrom(url)
        text = getLicenseTextFrom(url)
        if text:
            attributions.append(Attribution(name, text))
        else:
            print '{}: license file not found'.format(name)
    exportJSON(outputFile, *attributions)
