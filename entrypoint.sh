#!/bin/sh

set -ex

# Without arguments, simply exec shell
[[ -z $1 ]] && {
	exec /bin/sh
}


# If the first character from the input is different from "-"
# execute the command - allow it to run any command
[[ ! "${1:0:1}" = '-' ]] && {
  exec "$@"
}

debug=""
bind="0.0.0.0"

while [ "$#" != "0" ]; do
  case $1 in
    -debug)
      debug="-d -d -d -d"
      ;;

    -any)   
      ;;

    -iface)   
      bind="$1"
      ;;

    *) 
      echo "Unknown Argument [$1]."
      echo "Aborting."
      exit 1
      ;;
  esac
  shift
done

exec socat $debug UDP4-RECVFROM:53,fork,bind="$bind" UDP4-SENDTO:127.0.0.11:53

