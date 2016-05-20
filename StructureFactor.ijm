// Calculates the structure factor (q) and saves result in .xls file with same name and path as image.
// Before running, select the ROI you want to analyze and save it as the first entry in the ROI manager.
// The image will be saved as a TIFF with the analyzed ROI drawn. If original image is a TIFF, it will be overwritten.


//path for saving output files
path = getDirectory("image");
imgnamefull = getInfo("image.filename");
imgnamearray = split(imgnamefull, ".");
imgname = imgnamearray[0]

//selects the ROI
roiManager("Select", 0);

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
run("Close");
close("*");