#!/bin/sh

ctrl_c(){
  echo "***Trapped ^C. Terminating"
  exit 2
}

trap ctrl_c SIGINT

export PATH="/usr/local/bin/:$PATH"

actions=( $@ )
for action in "${actions[@]}"; do
    printf "[ action: %s ]\n" "$action"
    case $action in
        get)    rockyget ;; 
       prep)    rockyprep ;; 
      build)    rockybuild ;; 
          *)    printf "unsupported action: %s\n" "$action";;
    esac
done
