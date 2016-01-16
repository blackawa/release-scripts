#!/bin/sh

############################################################
# Usage
# sh assemble.sh web 1.2.3-SNAPSHOT ${profile}
# 指定されたモジュールの指定されたプロファイルで資材を作成して、
# 指定されたバージョン用のディレクトリにコピーします。
# 資材作成は
#   $ mvn clean package -DskipTests=true -P<profile you want>
# でできる前提です。
############################################################

# Parse Arguments
if [ $# -ne 3 ]; then
echo "############################################################"
echo "# Usage"
echo "# sh assemble.sh web 1.2.3-SNAPSHOT ${profile}"
echo "############################################################"
echo
exit 1
fi

# モジュール名は変数名に使用するため、ハイフンを使用できない。
# しかしUIに影響を出したくないので内部的にアンダースコアに変換している。
MODULE=`echo $1 | sed -e "s/-/_/"`
VERSION=$2
PROFILE=$3

# Define Shared Directory to Copy Assembled Material
# TODO 埋めてください
BASE_DIR=
VERSION_DIR=$(ls ${BASE_DIR} | grep \(${PROFILE}_${VERSION}\))
if [ -z ${VERSION_DIR} ]; then
  echo
  echo "There isn't any proper directory."
  echo "version: ${VERSION}"
  echo "profile: ${PROFILE}"
  echo
  echo "Create directory first."
  echo "$ mkdir ${BASE_DIR}/MMdd_定期デプロイ\(${PROFILE}_${VERSION}\)"
  exit 1
fi
TARGET_DIR=${BASE_DIR}/${VERSION_DIR}

# Load Configurations
. ./../common/repository.conf
. ./branch.conf

# Start
echo "#####################################################"
echo "# Assemble Starting..."
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
  eval BRANCH='${'snapshot_${MODULE}'}'
else
  eval BRANCH='${'stable_${MODULE}'}'
fi

# Git Checkout / Pull
echo
echo "Checking out ${MODULE}:${BRANCH} ..."
git fetch
git checkout ${BRANCH}
git pull origin ${BRANCH}
echo

# Assemble
### NOTE ###############################################################
# ddl.zip、web.earもこのスクリプトから生成したい場合は、
# 1. Mavenプロジェクトをpackageで成果物が出るように修正するか、
# 2. 以下のベタ書きのコマンドをrepository.configのように外出しする
# ことを検討してください。
########################################################################
mvn clean package -DskipTests=true -P${PROFILE}

echo "Copying `ls target/*.zip` to ${TARGET_DIR}"
cp target/*.zip ${TARGET_DIR}

# Exit
exit 0
