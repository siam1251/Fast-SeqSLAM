from os import listdir
import os
import shutil
import subprocess
from os.path import isfile, join
mypath = './'
#onlyfiles = [f for f in listdir(mypath) if isfile(join(mypath, f))]
onlyfiles = [f for f in listdir(mypath)]
files = ['doDifferenceMatrix.m']
source_file = './alderley ANN sparse matrix modifiedfindmatches alderley dataset changed parameter/'
for file in onlyfiles:
	if os.path.isdir(file) and not file in source_file and not 'original' in file:
		for f in files:
			sf = source_file+f
			shutil.copy(sf,file+'/')
		print(file)

	#print('./common/comments.txt',mypath+'/'+file+'/')
	#print(folder+'/'+'*.py',folder+'/assignment4.py')
	#os.rename(folder+'/*'+'.py',folder+'/assignment4.py')
	#p = subprocess.Popen(['mv','./sayem/'+file, './sayem/'+folder+'/'], stdout=subprocess.PIPE)
	#print(p.communicate())
	# try:
	# 	os.rename(mypath+'/'+folder+'/assignment4.py',mypath+'/'+folder+'/'+folder[:-1]+'.py')
	# except Exception:
	# 	pass
	# finally:
	# 	pass
	
	#shutil.copy('./common/comments.txt',mypath+'/'+file+'/')
	#copy comments file
	#shutil.copy(mypath+'/'+folder+'/'+'comments.txt',mypath+'/'+folder+'.txt')
	
	#print('./common/comments.txt',mypath+'/'+folder+'/')
#shutil.copytree('./common/','./script_s/')
