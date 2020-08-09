# # # # # # # # # # # # # # # #
# FUNCTION DECLARATIONS
#
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

# # # # # # # # # # # # # # # #
# VARIABLES
#
#   DB = database name including path

    DB=~/Library/Application\ Support/Dock/desktoppicture.db
    timestamp=$(date '+%H-%M-%S')
    PLIST_NAME=backgroundchanger

# # # # # # # # # # # # # # # #
# DISABLE SQLITE3 CONFIG FILE
#
# To avoid unexcpected results the user's ~/.sqliterc configuration file may cause when `sqlite3` is executed, stop it being loaded by temporarily renaming it to ~/.sqliterc-HH:MM:SS
if [ -f ${HOME}/.sqliterc ]; then
    mv ${HOME}/.sqliterc ${HOME}/.sqliterc-$timestamp
fi

killall System\ Preferences > /dev/null 2>&1
rm "$DB"
killall Dock

# wait_for_keypress "Select 3 images for the desktops then press any key to continue."
./wait.sh
killall System\ Preferences > /dev/null 2>&1

echo ".mode insert\n.output preferences.sql" > ~/.sqliterc
sqlite3 "$DB" 'select * from preferences'
sed -i '' 's/table/preferences/g' preferences.sql

# Restore the user's ~/.sqliterc configuration file renamed to ~/.sqliterc-HH:MM:SS.

if [ -f ${HOME}/.sqliterc-$timestamp ]; then
      mv ${HOME}/.sqliterc-$timestamp ${HOME}/.sqliterc
fi

if [ -f ~/Library/LaunchAgents/local.${PLIST_NAME}.plist ]; then
    launchctl unload ~/Library/LaunchAgents/local.${PLIST_NAME}.plist
    rm ~/Library/LaunchAgents/local.${PLIST_NAME}.plist
fi
cp local.${PLIST_NAME}.plist ~/Library/LaunchAgents/
sed -i "" "s/home/${HOME//\//\\/}/g" ~/Library/LaunchAgents/local.${PLIST_NAME}.plist

launchctl load ~/Library/LaunchAgents/local.${PLIST_NAME}.plist
launchctl start local.${PLIST_NAME}
