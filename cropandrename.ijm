//path for saving output files
path = getDirectory("image");
imgnamearray = split(getInfo("image.filename"), ".");
imgname = imgnamearray[0]

run("Crop");
run("8-bit");

save(path + imgname + "_crop.png")