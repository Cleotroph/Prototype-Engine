import os

if __name__ == '__main__':
	path = "./Engine"  ##path to project file
	ignore = ["data", "Engine.pde", "Compiled.pde"]
	outPath = ["Compiled/Compiled.pde"]
	outText = ""
	for filename in os.listdir(path):
		if filename not in ignore:
			with open(os.path.join(path, filename), 'r') as f:  # open in readonly mode
				for line in f.readlines():
					outText += line
	for out in outPath:
		with open(out, "w") as myFile:
			myFile.write(outText)
