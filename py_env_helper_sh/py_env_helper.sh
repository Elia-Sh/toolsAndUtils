#!/usr/bin/env bash

### this is a prototype ###
## a "simple" script for the cretion of python venv
## similarly to: 
##    mkdir $1 $$ cd $1 $$ python3 -m venv venv
###

DEFAULT_PROJ_DIR="test_project_name"
DEFAULT_VENV_DIR="venv"
PYTHON_REQUIRED_VERSION="3.3"

help() {
    cat <<-EOF
    $0 <project-dir-name> [venv-dir-name]

        project-dir-name        a name for the project containing directory
        venv-dir-name           a name for the virtual environment directory - inside the project dir

        -h| --help              print help

EOF
    exit 1
}

test_args() {
    args_num=${#cmdline_args_array[@]}
    case "$args_num" in
        "0")
            help
        ;;
        "1"|"2")
            if [[ ${cmdline_args_array[0]} == "-h" || \
                  ${cmdline_args_array[0]} == "--help" || \
                  ${cmdline_args_array[1]} == "-h"  || \
                  ${cmdline_args_array[1]} == "--help" ]]; then
                help
            fi
            # we are golden -> passed checks (did not asked for "help")
        ;;
        *)
            echo "ERROR: Too many arguments"
            help
        ;;
    esac
}


init_py_venv() {
    # use default if not supplied
    local dir_name=${cmdline_args_array[0]:-$DEFAULT_PROJ_DIR}
    local venv_dir_name=${cmdline_args_array[1]:-$DEFAULT_VENV_DIR}

    if [[ -d "$dir_name" ]]; then
        echo "ERROR: Directory is taken, please choose a new project name :)"
        exit 1
    fi
    local cmd="mkdir -p \"$dir_name\" \
        && cd \"$dir_name\" && python3 -m venv \"$venv_dir_name\""

    # this is the core of the entire tool - create venv!
    # TODO add pip?
    echo -e "Creating project dir:      '$dir_name',\nand in it cooking Py venv: '$venv_dir_name'..."
    eval $cmd
    if [ $? -ne 0 ] ; then 
        echo "ERROR: Project directory creation failed! :(" ; 
        echo -e "Tried to execute the following:\n\t$cmd"
        exit 1
    fi

    echo -e "Finished succsfully, to load venv run:\
        \n\tsource $dir_name/$venv_dir_name/bin/activate"
    
}


test_host_env () {
    # test python version
    type python3 &>/dev/null
    if [[ $? -ne 0 ]]; then
        echo "Error: no python3 installed"
        exit
    fi

    full_py_version=$(python3 -V | cut -d ' ' -f 2)
    python_required_version_prefix=${PYTHON_REQUIRED_VERSION:0:3}
    python_current_version_prefix=${full_py_version:0:3}    # get Major.Minor of py version
    is_version_supported=$(echo "$python_current_version_prefix > $python_required_version_prefix" | bc)
    if  !((is_version_supported)); then
        echo -e "Error:\trequiered python version: $PYTHON_REQUIRED_VERSION\n\tyou are using:\t\t  $full_py_version"
        exit 
    fi
    
}

cmdline_args_array=("$@")   # store the arguments into a global var; for convinience.
test_args
test_host_env
init_py_venv

