#!/usr/bin/env bash

if [ $# -lt 1 ]; then
  echo Usage: create_package.sh org_alias user_alias
  exit
fi

# checks if branch has something pending
function parse_git_dirty() {
  git diff --quiet --ignore-submodules HEAD 2>/dev/null
  [ $? -eq 1 ] && echo "*"
}

# gets the current git branch
function parse_git_branch() {
  git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

# get last commit hash prepended with @ (i.e. @8a323d0)
function parse_git_hash() {
  git rev-parse --short HEAD 2>/dev/null | sed "s/\(.*\)/@\1/"
}

# INFO
GIT_BRANCH=$(parse_git_branch)
GIT_HASH=$(parse_git_hash)
GIT_STATUS=$(parse_git_dirty)

echo $GIT_STATUS
echo $GIT_BRANCH
echo $GIT_HASH

  # -a, --versionname=versionname
  # -b, --branch=branch
  # -c, --codecoverage
  # -e, --versiondescription=versiondescription
  # -d, --path=path
  # -k, --installationkey=installationkey
  # -t, --tag=tag
  # -n, --versionnumber=versionnumber
  # --postinstallscript POSTINSTALLSCRIPT
  # -v, --targetdevhubusername=targetdevhubusername
  # --loglevel=(trace|debug|info|warn|error|fatal|TRACE|DEBUG|INFO|WARN|ERROR|FATAL)
  # -w, --wait=wait 

sfdx force:package:version:create -a "One" -b ${GIT_BRANCH} -e "Charm Version 1" -d "src" -t ${GIT_HASH} -n ${1} -v charm-dev --loglevel debug -w 10 --preserve