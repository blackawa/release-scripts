#!/bin/sh

##############################################
# Usage
# sh create-tag-to-all-repositories.sh ${version}
# モジュールのリストをループして、指定されたバージョンで
# タグを切ってプッシュしてくれます。
##############################################

if [ $# -ne 1 ]; then
  echo
  echo "##############################################"
  echo "# Usage"
  echo "# sh create-tag-to-all-repositories.sh 0.2.34"
  echo "##############################################"
  exit 1
fi

# Parse Arguments
VERSION=$1

# 変数名に使うのでハイフンが使えない。
# よってアンスコに置き換えている。
MODULE_LIST="TODO 埋めてください"

cd ./subscripts/tagging

echo
echo "------------------------------------"
echo "Creating Tag v${VERSION}."
echo "------------------------------------"
echo "PRESS ENTER to go"
read wait

for MODULE in ${MODULE_LIST}; do
  sh create-tag.sh ${MODULE} ${VERSION}
done

exit 0
