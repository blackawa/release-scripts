#!/bin/sh

##############################################
# Usage
# sh create-tag.sh web 0.2.34
# masterブランチの最新コミットにタグを切ります。
# NOTE: バージョン番号には勝手にvをつけます。
##############################################

# Load Configuration
. ./../common/repository.conf

# Parse Arguments
if [ $# -ne 2 ]; then
  echo "##############################################"
  echo "# Usage"
  echo "# sh create-tag.sh web 0.2.34"
  echo "# NOTE: バージョン番号には勝手にvをつけます。"
  echo "##############################################"
  exit 1
fi

MODULE=`echo $1 | sed -e "s/-/_/"`
VERSION=$2

# Change Directory to Git Work Directory
eval cd '${'path_${MODULE}'}'
if [ $? -ne 0 ]; then
  echo
  echo "There isn't any proper directory"
  echo "Module: ${MODULE}"
  exit 1
fi
echo
echo "---------------------------------------"
echo "Change directory to ${MODULE} module"
echo "---------------------------------------"
pwd

echo
echo "Creating New Tag v${VERSION}..."

# Create New Tag and Push It
git checkout master
git pull origin master
git tag v${VERSION}
git push origin v${VERSION}

# Exit
exit 0
