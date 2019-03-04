#! /bin/bash

set -e

./rectify_config.sh
./check_perm.sh
./config_check.sh

nginx