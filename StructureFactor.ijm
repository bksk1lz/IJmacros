
//path for saving output files
path = getDirectory("image");
imgnamearray = split(getInfo("image.filename"), ".");
imgname = imgnamearray[0]


run("Subtract...", "value=1");
run("8-bit");
run("FFT Options...", "complex");
run("Bandpass Filter...", "filter_large=200 filter_small=2 suppress=None tolerance=5 autoscale saturate");
run("FFT");
run("Square", "stack");

run("Z Project...", "projection=[Sum Slices]");
run("Select All");
run("Radial Profile");

Plot.getValues(xvals, yvals);
Array.show("RadPro", yvals);

selectWindow("RadPro");
saveAs("Text", path + imgname + ".xls")