import matplotlib
import matplotlib.pyplot as plt
from decimal import Decimal
import math

f = open('time/ANN_8_8_.9_32_32.1-10.txt').read().splitlines()
f = f[0:10]

f.reverse()
f2 = open('time/original8_8_.9_32_32.1-10.txt').read().splitlines()
f2 = f2[0:10]

f2.reverse()
print(f2)
fig = plt.figure()
ax = fig.add_subplot(111)
i= 1
width = 10
gap = 48
sm_gap = 13
for ind in range(10):
	values = f[ind]
	values = values.split(',')
	print(values)
	values = [math.log(float(i)) for i in values]
	#bar from file 1
	rect1 = matplotlib.patches.Rectangle((gap*(i),0), width, (values[2]), facecolor='black',hatch = '/')
	rect2 = matplotlib.patches.Rectangle((gap*i,values[2]), width, values[3], facecolor='red',hatch = '/')
	rect3 = matplotlib.patches.Rectangle((gap*i,values[3]+values[2]), width, values[4], facecolor='green',hatch = '/')
	rect4 = matplotlib.patches.Rectangle((gap*i,values[3]+values[2]), width, values[5], facecolor='yellow', hatch = '/')
	ax.add_patch(rect1)
	ax.add_patch(rect2)
	#ax.add_patch(rect3)
	ax.add_patch(rect4)
	#bar from file 2
	values = f2[ind]
	values = values.split(',')
	print(values)
	values = [math.log(float(i)) for i in values]
	rect1 = matplotlib.patches.Rectangle((sm_gap+gap*(i),0), width, values[2], color='black')
	rect2 = matplotlib.patches.Rectangle((sm_gap+gap*i,values[2]), width, values[3], color='red')
	rect3 = matplotlib.patches.Rectangle((sm_gap+gap*i,values[3]+values[2]), width, values[4], color='green')
	rect4 = matplotlib.patches.Rectangle((sm_gap+gap*i,values[4]+values[3]+values[2]), width, values[5], color='yellow')
	ax.add_patch(rect1)
	ax.add_patch(rect2)
	ax.add_patch(rect3)
	ax.add_patch(rect4)
	i+=1

plt.xlim([0, 600])
plt.ylim([0, 40])
ax.axes.get_xaxis().set_visible(False)
plt.show()
fig.savefig('bar3.png')