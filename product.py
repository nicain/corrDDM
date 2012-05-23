#
#  product.py
#  DDMCubeTeraGrid
#
#  Created by nicain on 4/29/10.
#  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
#

# Python 2.5 has no product method in its itertools!
def product(*args, **kwds):
	# product('ABCD', 'xy') --> Ax Ay Bx By Cx Cy Dx Dy
	# product(range(2), repeat=3) --> 000 001 010 011 100 101 110 111
	pools = map(tuple, args) * kwds.get('repeat', 1)
	result = [[]]
	for pool in pools:
		result = [x+[y] for x in result for y in pool]
	for prod in result:
		yield tuple(prod)