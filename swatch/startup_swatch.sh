#!/bin/sh

set -x

# resolve links - $0 may be a softlink
PRG="$0"

PRGDIR=`dirname "$PRG"`
EXECUTABLE=swatch
CONF_FILE=${PRGDIR}/swatchrc
LOG_FILE=/tmp/swatch_test.log
SCRIPT_DIR=/tmp


if [[ ! -f $CONF_FILE ]]; then
        echo "Conf file not found "
        exit 1
fi

type -P perl  # this make more sense
	      # No, it doesn't

if [[ $? -eq 0 ]]; then
        PERL_EXE=`which perl`

else
        echo "PERL not fount cannot run script "
        exit 1
fi


exec $PERL_EXE  ${PRGDIR}/$EXECUTABLE --config-file=${CONF_FILE} --use-cpan-file-tail --script-dir=${SCRIPT_DIR} -t ${LOG_FILE}

