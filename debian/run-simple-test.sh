#!/bin/sh

set -e

pwd="$(pwd)"

testf="$pwd/debian/test-home/.gitconfig"
if [ ! -f "$testf" ]; then
	echo "No '$testf' file; are you in the Debian package source directory?" 1>&2
	exit 1
fi

export HOME="$pwd/debian/test-home"
export LC_ALL='C.UTF-8'
export PYTHON3="$(py3versions -d)"

dir="$(mktemp -d -t gitless-test.XXXXXX)"
trap "rm -rf -- '$dir'" EXIT HUP INT QUIT TERM

echo "Using directory $$dir"
./debian/test-gl-simple "$$dir"
