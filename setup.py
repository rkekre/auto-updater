# coding: utf-8
import os
from setuptools import setup, find_packages

NAME = "auto-updater"
__version__ = "0.6.0"


def read(path):
    with open(os.path.join(os.path.dirname(__file__), path)) as f:
        return f.read()


REQUIRES = map(str.split, read("requirements.txt").split())

setup(
    name=NAME,
    version=__version__,
    install_requires=REQUIRES,
    packages=find_packages(),
    include_package_data=True
)
