#
#  setup.py
#  DDMCubeTeraGrid
#
#  Created by nicain on 4/29/10.
#  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
#
from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

import numpy as np	# Needed to compile the c numpy extensions correctly
setup(cmdclass = {'build_ext': build_ext},
    ext_modules = [Extension("DDMCube", ['DDMCube.pyx'],language="c++",include_dirs=[np.get_include()])])

from subprocess import call as call
call('cython -a DDMCube.pyx',shell=True)
