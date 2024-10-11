#!/usr/bin/env bash

source /usr/include/baur/colors.bash

# Steps: [assuming we're talking about AUR on #2]
# 
#   1.  First, we check for an existing temp folder file.
#       If there's none, we create one and we use that
#       directory for our future AUR shenanigans
#
#   2.  If the source of the package is a compiled
#       language, we will try to find either of these
#       things:
#         a)  we will check if there's a build script
#             or not. if it's a Makefile, using
#             Python, we will lex through the file
#             contents and check if there any
#             source files of a compiled language
#             (.c, .cpp, .cc, etc.) are present.
#             if not, then we just run the Makefile
#             present.
#             
#         b)  if the source is intepreted, we will
#             just package the contents onto an
#             Arch Linux package.
#
#       Let's go.

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
