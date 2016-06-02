"""
This script prints a list of URLs required to download all the minecraft
resources that the new launcher can access (jars, libraries, assets)
Redirect stdout to a file to do something useful with it.
Will store cached json indexes in

This is a modified script I found here: https://gist.github.com/dequis/d24ce9d9915401f13dd1.
All credit goes to the creator all I did was remove what I didn't need.
"""

import os
import json
import requests

VERSIONS_JSON = "https://launchermeta.mojang.com/mc/game/version_manifest.json"
VERSION_JSON = "http://s3.amazonaws.com/Minecraft.Download/versions/%s/%s.json"

SERVER_JAR = "http://s3.amazonaws.com/Minecraft.Download/versions/%s/minecraft_server.%s.jar"

ALL_OS = ['osx', 'linux', 'windows']

def print_sha(url):
    print(url)
    print(url + ".sha1")

def fetch_json(url, filename):
    print(url)
    if os.path.exists(filename):
        return json.load(open(filename))
    else:
        response = requests.get(url)
        open(filename, "w").write(response.content)
        return response.json()

def parse_rules(rules):
    if not rules:
        return set(ALL_OS)

    allowed_os = set()

    for rule in rules:
        action = rule['action']
        change = set()
        if 'os' in rule:
            # when filtering out versions
            if not (action == 'disallow' and 'version' in rule['os']):
                change.add(rule['os']['name'])
        else:
            change = set(ALL_OS)

        if action == 'allow':
            allowed_os |= change
        else:
            allowed_os -= change
    return allowed_os

def parse_libraries(libs):
    for lib in libs:
        package, name, version = lib['name'].split(":")
        package = package.replace(".", "/")
        jar = LIBRARY_JAR % (package, name, version, name, version)

        if 'natives' in lib:
            allowed_os = parse_rules(lib.get('rules', []))

            for os_name, value in lib['natives'].items():
                if os_name not in allowed_os:
                    continue

                jar = (NATIVE_JAR % (package, name, version, name, version, value))

                if '${arch}' in value:
                    for arch in ("32", "64"):
                        jar_arch = jar.replace("${arch}", arch)
                        print_sha(jar_arch)
                else:
                    print_sha(jar)
        else:
            print_sha(jar)

def main():
    all_versions_json = fetch_json(VERSIONS_JSON, "versions.json")

    versions = [x['id'] for x in all_versions_json['versions']]

    asset_types = set()

    for version in versions:
        print(SERVER_JAR % (version, version))

        version_json = fetch_json(
            VERSION_JSON % (version, version),
            "versions/%s.json" % version)

if __name__ == '__main__':
    main()
