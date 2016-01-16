#!/bin/sh

######################################################################
# Usage
# sh assemble-all-materials.sh ${version} ${profile}
# 現在assemble.shに対応しているすべてのモジュール
# (TODO 埋めてください)
# について、指定されたプロファイルで資材を作成して
# 指定されたバージョン用のディレクトリにコピーします。
# --------------------------------------------------------------------
# 実体はモジュール名のリストをループしてassemble.shを呼んでいるだけ
# なので、個別の動作はassemble.shが責任を持っています。
######################################################################

# Parse Arguments
if [ $# -ne 2 ]; then
  echo '######################################################################'
  echo '# Usage'
  echo '# sh assemble-all-materials.sh ${version} ${profile}'
  echo '######################################################################'
  exit 0
fi
VERSION=$1
PROFILE=$2

# Define Module List
# 半角スペース区切りのこのリストを回しているので、リリース対象が増えるときはここに書き足すと
# assemble.shを呼んでくれます。
MODULE_LIST="TODO 埋めてください"

# Assemble All Materials
cd ./subscripts/assemble

for MODULE in ${MODULE_LIST}; do
  echo "Assemble Starting..."
  echo "Module: ${MODULE}"
  sh ./assemble.sh ${MODULE} ${VERSION} ${PROFILE} 1>>../../assemble-all-materials.log 2>&1
  if [ $? -ne 0 ]; then
    echo
    echo "Failed to Assemble Material"
    echo "MODULE: ${MODULE}"
    exit 1
  fi
done

exit 0
