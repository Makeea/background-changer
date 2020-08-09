function wait_for_keypress {
      echo "$1"
      while [ true ] ; do
      read -t 3 -n 1
      if [ $? = 0 ] ; then
      exit ;
      else
      echo "waiting for the keypress"
      fi
      done
    }
wait_for_keypress 'Once the image comes back,\nSelect 3 images for the desktops then press any key to continue.'
