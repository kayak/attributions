#!/usr/bin/env python3

import base64
import json
import os
import shlex
import subprocess
import sys
import urllib.request, urllib.error, urllib.parse


class Attribution():

    def __init__(self, name, license):
        self.name = name
        self.license = {'text' : license}


def export_json(output, *attributions):
    jsonResult = json.dumps([a.__dict__ for a in attributions], sort_keys=False, indent=4)
    try:
        with open(output, 'w') as file:
            file.write(jsonResult)
            file.close()
    except IOError as e:
        print('I/O Error: ({0}) : {1}'.format(e.errno, e.strerror))


def get_repos(input):
    with open(input) as file:
        repos = [line.strip() for line in file]
    return repos


def get_name(repo):
    return repo.split('github.com/')[1].split('/')[1]


def get_owner_name(repo):
    return '/'.join(repo.split('github.com/')[1].split('/')[0:2])


def get_content_headers():
    headers = {}
    if 'GITHUB_ACCESS_TOKEN' in os.environ:
        headers['Authorization'] = 'token %s' % os.environ['GITHUB_ACCESS_TOKEN']
    return headers


def send_content_request(repo, path):
    request = urllib.request.Request('https://api.github.com/repos/%s/contents/%s' % (get_owner_name(repo), path.lstrip('/')),
        headers = get_content_headers())
    return json.loads(urllib.request.urlopen(request).read())


def find_license_path(repo):
    data = send_content_request(repo, '/')
    item = next((item for item in data if item['path'].startswith('LICENSE')), None)
    if not item:
        item = next((item for item in data if item['path'].startswith('COPYING')), None)
    if item:
        return item['path']


def get_license_text(repo):
    path = find_license_path(repo)
    if path:
        data = send_content_request(repo, path)
        if data['encoding'] != 'base64':
            print("Encoding of Github response was not base64")
            sys.exit(1)
        decodedData = base64.b64decode(data['content'])
        return decodedData.decode('utf-8')


def validate_file(file, type):
    if type == 'input':
        if not os.path.isfile(file):
            print('File not found: {}'.format(file))
            sys.exit(1)
    else:
        if not file.endswith('.json'):
            print('Output file must be .json')
            sys.exit(1)


if __name__ == '__main__':
    if len(sys.argv) != 3:
        print('Missing script argument: ./attributions2json [./Attribution File] [output_file.json]')
        sys.exit(1)

    input_file = sys.argv[1]
    validate_file(input_file, 'input')
    output_file = sys.argv[2]
    validate_file(output_file, 'output')

    if 'GITHUB_ACCESS_TOKEN' not in os.environ:
        print("Warning: No GITHUB_ACCESS_TOKEN environment variable configured. Expect to run into API rate limits.")

    urls = get_repos(input_file)
    attributions = []
    for url in urls:
        name = get_name(url)
        text = get_license_text(url)
        if text:
            attributions.append(Attribution(name, text))
        else:
            print('{}: license file not found'.format(name))
    export_json(output_file, *attributions)
