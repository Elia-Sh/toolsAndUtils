#!/bin/bash
# Inspired by: 
# https://stackoverflow.com/questions/40193222/dialog-show-menu-after-option-has-been-executed

HEIGHT=15
WIDTH=70
CHOICE_HEIGHT=5
BACKTITLE="Dialog TUI to sample and set ASLR on local system"
TITLE="ASLR TUI"
MENU="Choose one of the following options:"
TAIL_BOX_PATH="/tmp/dialog_text_box.log"

# ASLR -> /proc/sys/kernel/randomize_va_space
# 0 = Disabled
# 1 = Conservative Randomization
# 2 = Full Randomization

EXIT_CHOISE=5

OPTIONS=(1 "Test if ASLR(randomize_va_space) is enabled on the system"
         2 "Enable ASLR, mode: Conservative Randomization"
         3 "Enable ASLR, mode: Full Randomization"
         4 "Disable ASLR"
         $EXIT_CHOISE "Quit")

DATE_CMD=(date +%Y-%m-%dT%H:%M:%S%z)

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
            1)
                COMMAND_TO_RUN="cat /proc/sys/kernel/randomize_va_space"
                ;;
            2)
                COMMAND_TO_RUN="echo 1 > /proc/sys/kernel/randomize_va_space"
                ;;
            3)
                COMMAND_TO_RUN="echo 2 > /proc/sys/kernel/randomize_va_space"
                ;;
            4)
                COMMAND_TO_RUN="echo 0 > /proc/sys/kernel/randomize_va_space"
                ;;
            $EXIT_CHOISE) 
                echo "Exit on user request"
                exit
            ;;
    esac
    "${DATE_CMD[@]}" 2>&1 >> $TAIL_BOX_PATH
    echo "Running: ${COMMAND_TO_RUN[@]}" 
    # "${COMMAND_TO_RUN[@]}" # array approach will not work here, since arrays also get expanded after redirects are parsed.
    eval $COMMAND_TO_RUN
    read -n 1 -r -s -p $'Press enter to continue...\n'
done

