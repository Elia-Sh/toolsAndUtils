

# Python3 venv setup helper - The shell version

Self contained python3 script that:
* setup isolated virtual environment using pythons built `venv` module
* TODO: "ensure pip" in the newly created virtual environment
* TODO: installs additional packages using a `requirements.txt` file, providing simplicity similar to ***npm install***

Like: [py_env_helper](https://github.com/Elia-Sh/toolsAndUtils/tree/master/py_env_helper) but in "pure" bash
## Usage examples
```
$ ./py_env_helper.sh <project-dir-name> [venv-dir-name]

        project-dir-name        a name for the project containing directory
        venv-dir-name           a name for the virtual environment directory - inside the project dir

        -h| --help              print help
```
