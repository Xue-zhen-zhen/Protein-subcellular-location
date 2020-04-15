"""PyLL
Provides a variety of tensorflow-based network layers, flexible (recurrent) network designs, convenience routines for saving and resuming networks, and more!
Copyright (c) 2016-2017 Michael Widrich and Markus Hofmarcher, Institute of Bioinformatics, Johannes Kepler University Linz, Austria
"""

# Always prefer setuptools over distutils
from setuptools import setup, find_packages
# To use a consistent encoding
from codecs import open
from os import path

here = path.abspath(path.dirname(__file__))

# Get the long description from the README file
with open(path.join(here, 'README.rst'), encoding='utf-8') as f:
    long_description = f.read()

setup(
    name='pyll',
    
    # Versions should comply with PEP440.  For a discussion on single-sourcing
    # the version across setup.py and the project code, see
    # https://packaging.python.org/en/latest/single_source_version.html
    version='0.1',
    
    description='Provides a variety of convenience routines for pytorch projects',
    long_description=long_description,
    
    # The project's main homepage.
    url='https://git.bioinf.jku.at/hofmarch/pyll',
    
    # Author details
    author='Markus Hofmarcher, Michael Widrich',
    author_email='hofmarcher@bioinf.jku.at, widrich@bioinf.jku.at',
    
    # Choose your license
    license='MIT License',
    
    # See https://pypi.python.org/pypi?%3Aaction=list_classifiers
    classifiers=[
        # How mature is this project? Common values are
        #   3 - Alpha
        #   4 - Beta
        #   5 - Production/Stable
        'Development Status :: 4 - Beta',
        
        # Indicate who your project is intended for
        'Intended Audience :: Developers',
        'Topic :: Software Development :: Deep Learning',
        
        # Pick your license as you wish (should match "license" above)
        'License :: OSI Approved :: MIT License',
        
        # Specify the Python versions you support here. In particular, ensure
        # that you indicate whether you support Python 2, Python 3 or both.        
        'Programming Language :: Python :: 3.5',
        'Programming Language :: Python :: 3.6',
    ],
    
    # What does your project relate to?
    keywords='Library on top of tensorflow for convenient design of deep (recurrent) networks.',
    
    # You can just specify the packages manually here if your project is
    # simple. Or you can use find_packages().
    packages=find_packages(),
    
    # List run-time dependencies here.  These will be installed by pip when
    # your project is installed. For an analysis of "install_requires" vs pip's
    # requirements files see:
    # https://packaging.python.org/en/latest/requirements.html
    install_requires=['torch',
                      'torchvision',
                      'numpy',
                      'tensorboardX'                      
                      ],
    
    # To provide executable scripts, use entry points in preference to the
    # "scripts" keyword. Entry points provide cross-platform support and allow
    # pip to create the appropriate form of executable for the target platform.
    #entry_points={
    #    'console_scripts': [
    #        'tell-resume=TeLL.scripts.resume:main',
    #        'tell-ising-dropout=TeLL.scripts.dropoutmask:main',
    #    ],
    #}
)
