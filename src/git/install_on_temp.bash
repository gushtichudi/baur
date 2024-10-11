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

delete_package() {
  if [ -z $(ls -A $TMPDIR) ]; then
    die "No packages are installed. If you think this is a mistake then please report so."
  fi 

  print_info "There are packages installed which this helper has note of."
  ls $TMPDIR

  print_info "\nThe goal is to specify the name of the package you want to uninstall."
  print_info "It does not have to be the exact same input as of the listed packages."
  print_warning "Keep in mind that the installed packages list are stored on a temporary cache directory."
  print_warning "This means, if you were to clean off the cache, the list would also be gone to."
  print_warning "As of now, there is no easy way to display the list of installed AUR packages. Not even in yay or paru.\n\n"

  print_info "What would you like to delete?"
  read PKGNAME

  print_info "\nRemoving package $PKGNAME..."
  sudo pacman -R $PKGNAME

  if [ $? != 0 ]; then
    die "There were errors seen during the deletion of packages. Try again"
  fi
}
