#!/bin/sh

############################################################
# Usage
# sh assemble.sh web 1.2.3-SNAPSHOT local-it
############################################################

# Parse Arguments
if [ $# -ne 3 ]; then
echo "############################################################"
echo "# Usage"
echo "# sh assemble.sh web 1.2.3-SNAPSHOT local-it"
echo "############################################################"
echo
exit 0
fi

MODULE=$1
VERSION=$2
PROFILE=$3

# Load Configurations
. ./repository.config
. ./branch_to_assemble.config
. ./validate_profile.config

# Start
echo "#####################################################"
echo "# assemble.sh"
echo "# MODULE: ${MODULE}"
echo "# VERSION: ${VERSION}"
echo "#####################################################"

# Change Directory to Git Work Directory
cd ${path[${MODULE}]}
echo
echo "Change directory to ${MODULE} module"
pwd

# Stable or Snapshot?
if [ `echo $VERSION | grep "SNAPSHOT"` ]; then
  BRANCH=${snapshot[${MODULE}]}
else
  BRANCH=${stable[${MODULE}]}
fi

# Git Checkout / Pull
echo
git checkout ${BRANCH}
git branch
# git pull origin ${BRANCH}
echo

# Assemble
if [ -z ${profile[${PROFILE}]} ]; then
  echo
  echo "profile is undefined: ${PROFILE}"
  exit 0
fi
mvn clean install -DskipTests=true -P${PROFILE}

# Transfer
# cp target/*.jar ./

# Exit
echo
echo "Here comes script finish"
exit 0
