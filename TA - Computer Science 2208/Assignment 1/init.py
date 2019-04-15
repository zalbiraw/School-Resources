import os
import shutil

baseDir = './Students'

os.remove(os.path.join(baseDir, '.DS_Store'))

for foldername in os.listdir(baseDir):

	id = foldername[foldername.find('(') + 1: foldername.find(')')]
	dir = os.path.join(baseDir, foldername)
	submissions = os.path.join(baseDir, foldername, 'Submission attachment(s)')

	# Move all contents of the Submissions directory to the new directory.
	for filename in os.listdir(submissions):
		shutil.move(os.path.join(submissions, filename), os.path.join(dir, filename))

	# Remove timestamp.txt
	os.remove(os.path.join(dir, 'timestamp.txt'))

	# Remove Submissions directory
	shutil.rmtree(submissions)

	# Copy the marking scheme to all the directories
	shutil.copyfile('./marking_scheme.xlsx', os.path.join(dir, '{}.xlsx'.format(id)))