#!/bin/sh

set -e

pwd="$(pwd)"

testf="$pwd/debian/run-upstream-test.sh"
if [ ! -f "$testf" ]; then
	echo "No '$testf' file; are you in the Debian package source directory?" 1>&2
	exit 1
fi

export LC_ALL='C.UTF-8'
export PATH="$pwd:$PATH"
export PYBUILD_NAME='gitless'
export PYTHON3="$(py3versions -d)"

pyver="$(py3versions -d -v)"

ln -s gl.py gl
pybuild --test -i 'python{version}' -p "$pyver" --before-test "cp -v '$pwd/debian/test-home/.gitconfig' '{home_dir}/'; ls -A '{home_dir}'"
