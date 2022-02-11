import argparse
import multiprocessing as mp
import os
import re
import subprocess
import tempfile
from functools import partial
import shutil

FILENAME_RE = re.compile(r'[^\w\d-]')


def main():
    args = parseargs()
    pool = mp.Pool(processes=args.processes)
    scan_list = [line.strip() for line in open(args.inputfile)]
    func = partial(process, args.output_directory)
    pool.map(func, scan_list)


def process(output, host):
    try:
        tmp_file = tempfile.mktemp()
        path = os.path.join(output, FILENAME_RE.sub("_", host))

        command = ["testssl.sh"]
        command_arguments = ['--jsonfile', tmp_file, host]
        command.extend(command_arguments)

        subprocess.call(command)
        shutil.move(tmp_file, path)
    except Exception as exception:
        print(exception)


def parseargs():
    parser = argparse.ArgumentParser(description='Start the testssl scan')
    parser.add_argument('-o', '--output_directory', default='/output', type=str, required=False,
                        help='output directory for results')
    parser.add_argument('-p', '--processes', default=5, type=int, required=False,
                        help='number of processes to run')
    parser.add_argument('inputfile', type=str,
                        help='Fetch the domains from a particular file.')
    return parser.parse_args()


if __name__ == "__main__":
    main()
