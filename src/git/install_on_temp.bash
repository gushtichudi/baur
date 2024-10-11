#!/usr/bin/env bash

source /usr/include/baur/colors.bash


TMPDIR=~/.local/share/baur/cache
TMPEXT="Do not know"

check_Existing_Temp() {
  if [ ! -d $TMPDIR ]; then
    print_warning "$TMPDIR does not exist. Have to make one."
    mkdir ~/.local/share/baur
    mkdir $TMPDIR
    if [ $? != 0 ]; then
      TMPEXT="We are fucked"
    fi
  else
    TMPEXT="Yes it does"
  fi
}

get_Package() {
  # 2
  #---
  
  check_Existing_Temp

  case $TMPEXT in
    "We are fucked")
      die "Irrecoverable error occured. Please report this to me."
    ;;
    "Yes it does")
      print_success "We are good to go."
    ;;
  esac

  AURURL=$1

  # note: just found out that all aur shit are git
  #
    
  AURDIR=$TMPDIR/$(grep -o '/[^/]*\.' <<< $AURURL | sed 's/\/\(.*\)\./\1/' | perl -p -e 'chomp')
  
  if [ $? != 0 ]; then
    die "Cannot make directory"
  fi

  print_info "Getting $AURURL and putting it into $AURDIR"
  git clone $AURURL $AURDIR.d

  if [ $? != 0 ]; then
    die "Unexpected error occured. Try again."
  else
    print_success "Everything happened with much success."
  fi

  print_info "Installing package in $AURDIR"
  cd $AURDIR.d

  makepkg -si
}
