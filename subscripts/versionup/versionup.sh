#!/bin/sh

##################################################################
# Usage
# sh versionup.sh web 1.2.3-SNAPSHOT
# 指定されたモジュールを、指定されたバージョンに上げます。
# ただしpom.xmlの修正は手動です。
# 指定されたバージョン番号はコミットメッセージなどに使用されます。
##################################################################

# Parse Arguments
if [ $# -ne 2 ]; then
  echo "##############################################"
  echo "# Usage"
  echo "# sh versionup.sh web 1.2.3-SNAPSHOT"
  echo "##############################################"
  exit 1
fi

# モジュール名は変数名に使用するため、ハイフンを使用できない。
# しかしUIに影響を出したくないので内部的にアンダースコアに変換している。
MODULE=`echo $1 | sed -e "s/-/_/"`
VERSION=$2

# Load Configurations
. ./../common/repository.conf
. ./branch.conf

# Start
echo "#####################################################"
echo "# VersionUp Starting..."
echo "# Module: ${MODULE}"
echo "#####################################################"

# Change Directory to Git Work Directory
eval cd '${'path_${MODULE}'}'
if [ $? -ne 0 ]; then
  echo
  echo "There isn't any proper directory"
  echo "Module: ${MODULE}"
  exit 1
fi
echo
echo "Change directory to ${MODULE} module"
pwd

# Stable or Snapshot?
if [ `echo $VERSION | grep "SNAPSHOT"` ]; then
  eval BRANCH='${'checkout_snapshot_${MODULE}'}'
  eval MERGE_BRANCH='${'merge_snapshot_${MODULE}'}'
else
  eval BRANCH='${'checkout_stable_${MODULE}'}'
  eval MERGE_BRANCH='${'merge_stable_${MODULE}'}'
fi

# Git Checkout / Pull
echo
echo "------------------------------------"
echo "Checking out ${MODULE}:${BRANCH} ..."
echo "------------------------------------"
git fetch
git checkout ${BRANCH}
git pull origin ${BRANCH}

if [ ! -z ${MERGE_BRANCH} ]; then
  echo
  echo "------------------------------------"
  echo "Merging ${MODULE}:${MERGE_BRANCH} to ${BRANCH}..."
  echo "------------------------------------"
  git merge origin/${MERGE_BRANCH}
fi

# Increment Version
echo
echo "Press Enter to edit pom.xml..."
read wait
vim pom.xml

git diff
echo    "------------------------------------"
echo    "We are going to commit/push this modification"
echo    "Version: ${VERSION}"
echo -n "Is this correct modification?[y/n]:"
read Yn
if [ ${Yn} = "N" ] || [ ${Yn} = "n" ]; then
  echo Process stoped
  exit 0
fi
echo "------------------------------------"
git add pom.xml
git commit -m "version up to ${VERSION}"
git push origin ${BRANCH}

# Exit
echo
echo "Finish Execution"
exit 0
