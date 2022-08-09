import os

if __name__ == '__main__':
	# path to project file
	path = "./Engine"
	moduleFlags = []
	with open("./Engine/compile.cfg") as f:
		version = ""
		for line in f.readlines():
			line = line.split("\n")[0]
			if version == "":
				version = line.split(":")[1]
			else:
				moduleFlags.append((line.split(":")[0], line.split(":")[1] == "yes"))
	print("compiling version " + version + " with the following modules:")
	for flag in moduleFlags:
		if flag[1]:
			print("\t-" + flag[0])

	ignore = ["data", "Engine.pde", "Compiled.pde", "compile.cfg"]
	outPath = ["Compiled/Compiled.pde"]
	outText = ""
	for filename in os.listdir(path):
		if filename not in ignore:
			with open(os.path.join(path, filename), 'r') as f:  # open in readonly mode
				moduleCheck = False
				for line in f.readlines():
					if not moduleCheck:
						line = line.split("\n")[0]
						if line[0:7] == "// mod:":
							mod = line[7:]
							for flag in moduleFlags:
								if flag[0] == mod:
									if flag[1]:
										print("loading " + path + "/" + filename + " from module " + mod)
									else:
										print("skipping file " + path + "/" + filename + " because " + mod + " module not included")
										break
						else:
							print("compiling failed! missing flag in " + path + "/" + filename)
							exit()
						moduleCheck = True
					outText += line
	for out in outPath:
		with open(out, "w") as myFile:
			myFile.write(outText)
