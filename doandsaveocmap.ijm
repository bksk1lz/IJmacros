//path for saving output files
path = getDirectory("image");
imgnamefull = getInfo("image.filename");
imgnamearray = split(imgnamefull, ".");
imgname = imgnamearray[0];

run("8-bit");
run("OrientationJ Analysis", "log=0.0 tensor=4.0 gradient=0 harris-index=on color-survey=on s-distribution=on hue=Orientation sat=Constant bri=Coherency ");


saveAs("PNG", path + imgname + "_ocmap.png");
//selectWindow(imgnamefull);
//run("Close");