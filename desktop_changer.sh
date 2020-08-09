# # # # # # # # # # # # # # # #
# VARIABLES
#
#   DB = database name including path

    DB=~/Library/Application\ Support/Dock/desktoppicture.db
    TIMESTAMP=$(date '+%H-%M-%S')
    IMAGE_WAIT_TIME=8

# # # # # # # # # # # # # # # #
# FUNCTION DECLARATIONS
#

# Wait 8 seconds then download a random featured image to the specified number
    function download_image_x_of_y {
        if [ $1 -eq 1 ]
        then
            echo "waiting for image 1/$2"
        else
            echo "waiting for $IMAGE_WAIT_TIME seconds for image $1/$2"
            sleep $IMAGE_WAIT_TIME
        fi
        rm ~/desktopchanger/$1.jpg
        curl -k -L https://source.unsplash.com/3840x2160/?featured --output ~/desktopchanger/$1.jpg
    }

    function restore_preferences {
        cat ~/desktopchanger/preferences.sql | sqlite3 "$DB" > /dev/null
    }

if [ -f ${HOME}/.sqliterc ]; then
    mv ${HOME}/.sqliterc ${HOME}/.sqliterc-$TIMESTAMP
fi

sqlite3 "$DB" "delete from preferences"
restore_preferences

IMAGE_COUNT=$(sqlite3 "$DB" "select COUNT(*) from (select distinct data_id from preferences where key = 1);")

counter=0
sqlite3 "$DB" "select distinct data_id from preferences where key = 1" | while read row
    do
        ((counter++))
        download_image_x_of_y $counter $IMAGE_COUNT
    done



killall System\ Preferences > /dev/null 2>&1
rm "$DB"
killall Dock
sleep 2

restore_preferences
counter=0
sqlite3 "$DB" "select distinct data_id from preferences where key = 1" | while read rowid
    do
        ((counter++))
        sqlite3 "$DB" "INSERT INTO data(rowid, value) VALUES($rowid, \"~/desktopchanger/$counter.jpg\");"
    done

killall Dock
if [ -f ${HOME}/.sqliterc-$TIMESTAMP ]; then
      mv ${HOME}/.sqliterc-$TIMESTAMP ${HOME}/.sqliterc
fi
