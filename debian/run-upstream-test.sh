#!/bin/sh

set -e

pwd="$(pwd)"

testf="$pwd/debian/run-upstream-test.sh"
if [ ! -f "$testf" ]; then
	echo "No '$testf' file; are you in the Debian package source directory?" 1>&2
	exit 1
fi

: "${GITLESS:=./gl}"
gitless_dir="$(dirname -- "$GITLESS")"

# If it's relative, prepend the current directory.
if [ "$gitless_dir" = "${gitless_dir#/}" ]; then
	gitless_dir="$pwd/$gitless_dir"
fi

# Now prepend it to the search path.
export PATH="$gitless_dir:$PATH"

# Okay, do we need to symlink it, too?
if [ ! -f "$GITLESS" ] && [ -f "$GITLESS.py" ]; then
	ln -s -- "$GITLESS.py" "$GITLESS"
	trap "rm -f -- '$GITLESS'" EXIT HUP INT QUIT TERM
fi

# Fail early if it's not executable even after all of this.
if [ ! -f "$GITLESS" ] || [ ! -x "$GITLESS" ]; then
	echo "Not an executable file: '$GITLESS'" 1>&2
	exit 1
fi

export LC_ALL='C.UTF-8'
export PYBUILD_NAME='gitless'
export PYTHON3="$(py3versions -d)"

pyver="$(py3versions -d -v)"

pybuild --test -i 'python{version}' -p "$pyver" --before-test "cp -v '$pwd/debian/test-home/.gitconfig' '{home_dir}/'; ls -A '{home_dir}'"
