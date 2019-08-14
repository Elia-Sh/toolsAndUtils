#!/bin/bash
# Inspired by: 
# https://stackoverflow.com/questions/40193222/dialog-show-menu-after-option-has-been-executed

HEIGHT=15
WIDTH=70
CHOICE_HEIGHT=5
BACKTITLE="Backtitle here"
TITLE="Dialog Box Skeleton"
MENU="Choose one ofthe following options:"
TAIL_BOX_PATH="/tmp/dialog_text_box.log"

EXIT_CHOISE=5

OPTIONS=(1 "This is option 1 - meminfo"
         2 "This is option 2 - meminfo > log file"
         3 "This is option 3 - loadavg"
         4 "This is option 4 - loadavg > log file"
         $EXIT_CHOISE "Quit")

DATE_CMD=(date +%Y-%m-%dT%H:%M:%S%z)

######### Main Dialog #######

echo "Starting TUI at: " >> $TAIL_BOX_PATH
"${DATE_CMD[@]}" 2>&1 >> $TAIL_BOX_PATH
echo "*************" >> $TAIL_BOX_PATH

while [[ $CHOICE -ne $EXIT_CHOISE ]]; do
    CHOICE=$(dialog \
                    --backtitle "$BACKTITLE" \
                    --title "$TITLE" \
                    --menu "$MENU" \
                    $HEIGHT $WIDTH $CHOICE_HEIGHT \
                    "${OPTIONS[@]}" \
                    2>&1 >/dev/tty)
                    # Currently not showing log in tailbox
                    #--and-widget --begin 30 1 \
                    #--tailbox "$TAIL_BOX_PATH" 21 80 \
    if test $? -ne 0; then 
        clear
        echo "Exit on user request"
        exit
    fi
 
    clear
    case $CHOICE in
    # Alter COMMAND_TO_RUN to fit your need,
            1)
                COMMAND_TO_RUN="cat /proc/meminfo"
                ;;
            2)
                COMMAND_TO_RUN="cat /proc/meminfo > /tmp/meminfo.log"
                ;;
            3)
                COMMAND_TO_RUN="cat /proc/loadavg"
                ;;
            4)
                COMMAND_TO_RUN="cat /proc/loadavg > /tmp/loadavg.log"
                ;;
            $EXIT_CHOISE) 
                echo "Exit on user request"
                exit
            ;;
    esac
    "${DATE_CMD[@]}" 2>&1 >> $TAIL_BOX_PATH
    echo "Running: ${COMMAND_TO_RUN}" 
    # "${COMMAND_TO_RUN[@]}" # array approach will not work here, since arrays also get expanded after redirects are parsed.
    eval $COMMAND_TO_RUN
    echo -e "\nINFO: return code is: $?"
    read -n 1 -r -s -p $'Press enter to continue...\n'
done

