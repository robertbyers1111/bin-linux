#!/bin/bash

#   +------------------------+
#---| network_address_to_ips |-------------------------------------------------
#   +------------------------+

network_address_to_ips() {
  # define empty array to hold the ip addresses
  ips=()
  # create array containing network address and subnet
  network=(${1//\// })
  # split network address by dot
  iparr=(${network[0]//./ })
  # check for subnet mask or create subnet mask from CIDR notation
  if [[ ${network[1]} =~ '.' ]]; then
    netmaskarr=(${network[1]//./ })
  else
    if [[ $((8-${network[1]})) -gt 0 ]]; then
      netmaskarr=($((256-2**(8-${network[1]}))) 0 0 0)
    elif  [[ $((16-${network[1]})) -gt 0 ]]; then
      netmaskarr=(255 $((256-2**(16-${network[1]}))) 0 0)
    elif  [[ $((24-${network[1]})) -gt 0 ]]; then
      netmaskarr=(255 255 $((256-2**(24-${network[1]}))) 0)
    elif [[ $((32-${network[1]})) -gt 0 ]]; then 
      netmaskarr=(255 255 255 $((256-2**(32-${network[1]}))))
    fi
  fi
  # correct wrong subnet masks (e.g. 240.192.255.0 to 255.255.255.0)
  [[ ${netmaskarr[2]} == 255 ]] && netmaskarr[1]=255
  [[ ${netmaskarr[1]} == 255 ]] && netmaskarr[0]=255
  # generate list of ip addresses
  for i in $(seq 0 $((255-${netmaskarr[0]}))); do
    for j in $(seq 0 $((255-${netmaskarr[1]}))); do
      for k in $(seq 0 $((255-${netmaskarr[2]}))); do
        for l in $(seq 1 $((255-${netmaskarr[3]}))); do
          ips+=( $(( $i+$(( ${iparr[0]}  & ${netmaskarr[0]})) ))"."$(( $j+$(( ${iparr[1]} & ${netmaskarr[1]})) ))"."$(($k+$(( ${iparr[2]} & ${netmaskarr[2]})) ))"."$(($l+$((${iparr[3]} & ${netmaskarr[3]})) )) )
        done
      done
    done
  done
}

#   +---------+
#---| M A I N |----------------------------------------------------------------
#   +---------+

[ $# -lt 1 ] && { echo USAGE: `basename $0` CIDRexpr ...; exit; }

while [ $# -gt 0 ]; do
  network_address_to_ips $1
  echo
  echo Expanding ${1}..
  for IPADDR in ${ips[@]}; do
    echo IPADDR: $IPADDR
  done
  shift
done

