

# Python3 venv setup helper

Self contained python3 script that:
* setup isolated virtual environment using pythons built `venv` module
* "ensure pip" in the newly created virtual environment
* installs additional packages using a `requirements.txt` file, providing simplicity similar to ***npm install***

The utility is based on the official python help and examples of venv: 
* https://docs.python.org/3/library/venv.html#venv.EnvBuilder
* https://docs.python.org/3/library/venv.html#an-example-of-extending-envbuilder

## Usage examples

### command line

```
$ python3 py_env_helper.py venv12 ./requirements.txt
Creating py venv at: /Users/..../venv12
Looking in links: /var/folders/....
Collecting setuptools
Collecting pip
Installing collected packages: setuptools, pip
Successfully installed pip-19.0.3 setuptools-40.8.0
pip 19.0.3 from /Users/..../venv12/lib/python3.7/site-packages/pip (python 3.7)
Collecting django (from -r ./requirements.txt (line 1))
  Using cached https://files.pythonhosted.org/packages/12/68/8c125da33aaf0942add5095a7a2a8e064b3812d598e9fb5aca9957872d71/Django-$
.0.4-py3-none-any.whl
Collecting uWSGI (from -r ./requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/e7/1e/3dcca007f974fe4eb369bf1b8629d5e342bb3055e2001b2e5340aaefae7a/uwsgi-2$
0.18.tar.gz
Collecting asgiref~=3.2 (from django->-r ./requirements.txt (line 1))
  Using cached https://files.pythonhosted.org/packages/68/00/25013f7310a56d17e1ab6fd885d5c1f216b7123b550d295c93f8e29d372a/asgiref$
3.2.7-py2.py3-none-any.whl
Collecting pytz (from django->-r ./requirements.txt (line 1))
  Using cached https://files.pythonhosted.org/packages/e7/f9/f0b53f88060247251bf481fa6ea62cd0d25bf1b11a87888e53ce5b7c8ad2/pytz-201
9.3-py2.py3-none-any.whl
Collecting sqlparse>=0.2.2 (from django->-r ./requirements.txt (line 1))
  Using cached https://files.pythonhosted.org/packages/85/ee/6e821932f413a5c4b76be9c5936e313e4fc626b33f16e027866e1d60f588/sqlparse
-0.3.1-py2.py3-none-any.whl
Installing collected packages: asgiref, pytz, sqlparse, django, uWSGI
  Running setup.py install for uWSGI ... done
Successfully installed asgiref-3.2.7 django-3.0.4 pytz-2019.3 sqlparse-0.3.1 uWSGI-2.0.18

```

### within python script
```
from py_env_helper import execute_installer
        execute_installer('venv12', 'requirements.txt')

```


## Validating that packages installed into venv
The whole magic is to run pip as a module of the python executable within the virtual venv - 
> The standard packaging tools are all designed to be used from the command line.

source: https://docs.python.org/3/installing/index.html#basic-usage

In the example bellow assuming the virutual environment is called `venv12`

```
$ venv12/bin/python -m pip list
Package    Version
---------- -------
asgiref    3.2.7
Django     3.0.4
pip        19.0.3
pytz       2019.3
setuptools 40.8.0
sqlparse   0.3.1
uWSGI      2.0.18

$ venv12/bin/python -m pip --version
pip 19.0.3 from /Users/<--path to venv-->/venv12/lib/python3.7/site-packages/pip (python 3.7)
```

