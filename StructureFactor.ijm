
//path for saving output files
path = getDirectory("image");
imgnamefull = getInfo("image.filename");
imgnamearray = split(imgnamefull, ".");
imgname = imgnamearray[0]

//crop 10x images. I just rigged this!
//makeRectangle(0, 936, 2466, 2412);
//run("Crop");


run("Subtract...", "value=1");
run("8-bit");
run("FFT Options...", "complex");
run("Bandpass Filter...", "filter_large=200 filter_small=2 suppress=None tolerance=5 autoscale saturate");
run("FFT");
run("Square", "stack");

run("Z Project...", "projection=[Sum Slices]");
getDimensions(imw, imh, d3, d4, d5);
imgrad = imw/2;
run("Select All");
run("Radial Profile", "x=imgrad y=imgrad radius=imgrad");

Plot.getValues(xvals, yvals);
Array.show("RadPro", yvals);

selectWindow("RadPro");
saveAs("Text", path + imgname + ".xls")

selectWindow(imgnamefull)
run("Draw")
saveAs("Tiff", path + imgname + ".tif")

//CLOSE EVERYTHING
//run("Close");
//close("*");