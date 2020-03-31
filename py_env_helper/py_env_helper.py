import venv

import os
import sys

DEFAULT_VENV_NAME = 'venv'
DEFAULT_REQUIERMENTS_FILE_PATH = 'requirements.txt'

class ExtendedEnvBuilder(venv.EnvBuilder):
    """
    https://docs.python.org/3/library/venv.html#venv.EnvBuilder.post_setup
    venv python modules allows to control the virtual environments,
    and allows to utilise post_setup to install the requirements
    """
    def __init__(self, venv_name=DEFAULT_VENV_NAME, 
                    req_file_path=DEFAULT_REQUIERMENTS_FILE_PATH):
        self.venv_name = venv_name
        self.req_file_path = req_file_path
        super().__init__()

    def setup_venv(self):
        self.create(self.venv_name)

    def post_setup(self, context):
        os.system('{}/bin/python -m ensurepip'.format(
        self.venv_name
        ))
        os.system('{}/bin/python -m pip --version'.format(
            self.venv_name
        ))
        os.system('{}/bin/python -m pip install -r {}'.format(
            self.venv_name, self.req_file_path
        ))


def execute_installer(venv_name=DEFAULT_VENV_NAME,
        req_file_path=DEFAULT_REQUIERMENTS_FILE_PATH):
    print('Creating py venv at: {}'.format(
        os.path.abspath(venv_name)))
    builder = ExtendedEnvBuilder(venv_name=venv_name,
                                 req_file_path=req_file_path)
    builder.setup_venv()


if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser(
                                     description='Helper for virtual Python '
                                                 'environment setup')
    parser.add_argument('venv_dir', metavar='ENV_DIR', nargs='?',
                        const=DEFAULT_VENV_NAME, default=DEFAULT_VENV_NAME,
                        help='A directory in which to create the virtual environment.')
    parser.add_argument('req_file_path', metavar='REQUIREMENTS_FILE_PATH', nargs='?',
                        default=DEFAULT_REQUIERMENTS_FILE_PATH,
                        help='The path for the dependencies packages, usually: requirements.txt')
    options = parser.parse_args()
    rc = 1

    try:
        execute_installer(venv_name=options.venv_dir,
                          req_file_path=options.req_file_path)
        rc = 0
    except Exception as e:
        print('Error: %s' % e, file=sys.stderr)
    sys.exit(rc)

