#!/usr/bin/env bash

EXPECTED_COVERAGE=${EXPECTED_COVERAGE:-80}
function die() {
  echo $*
  exit 1
}

# Initialize coverage.out
echo "mode: count" > coverage.out

# Initialize error tracking
ERROR=""

packages=$(go list ./...)

SAVEIFS=$IFS
# Change IFS to new line.
IFS=$'\n'
packages=($packages)
# Restore IFS
IFS=$SAVEIFS


# Test each package and append coverage profile info to coverage.out
rm -f coverage_tmp.out
for pkg in "${packages[@]}"
do
    go test -v -covermode=count -coverprofile=coverage_tmp.out "$pkg" || ERROR="Error testing $pkg"
    if [ -z "$ERROR" ]
    then
      tail -n +2 coverage_tmp.out >> coverage.out 2> /dev/null || ERROR="No tests for $pkg"
      rm -f coverage_tmp.out
    fi

    if [ ! -z "$ERROR" ]
    then
        die "Encountered error, last error was: $ERROR"
    fi
done

cov=`go tool cover -func=coverage.out | tail -n 1 | sed 's/[^0-9\.]*//g'`
# bash only works with integers => covi = math.floor(cov)
covi=$( echo "$cov" | sed 's/\.[0-9]*$//g' )

if [ $covi -lt $EXPECTED_COVERAGE ]
then
    die "ERROR: Test coverage is not enough! Want at least $EXPECTED_COVERAGE% but only $cov% of tested packages are covered with tests."
else
    echo "SUCCESS: Coverage is ~$cov% (minimum expected is $EXPECTED_COVERAGE%)"
fi
