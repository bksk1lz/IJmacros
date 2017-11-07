// Calculates the structure factor S(q) of the active image and saves result in .xls file with same name and path as image.
// Before running, select the ROI you want to analyze and save it as the first entry in the ROI manager.
// The image will be saved as a TIFF with the analyzed ROI drawn. If original image is a TIFF, it will be overwritten.

// Requires the Radial Profile Plot plugin, available at:
// http://rsb.info.nih.gov/ij/plugins/radial-profile.html

run("Clear Results");
//path for saving output files
path = getDirectory("image");
imgnamefull = getInfo("image.filename");
imgnamearray = split(imgnamefull, ".");
imgname = imgnamearray[0];

//selects the ROI
if (roiManager("Count") == 0) exit("Please select the ROI and add to ROI manager (ctrl + t)");
roiManager("Select", 0);

//Correct for error in LUT of ACE-H2 images
//run("Subtract...", "value=1");
//run("8-bit");

//Despeckle (there is a lot of sensor? noise)
//run("Remove Outliers...", "radius=2 threshold=30 which=Bright");

//Set FFT to complex output and filter/normailze image
run("FFT Options...", "complex");
//run("Bandpass Filter...", "filter_large=100 filter_small=2 suppress=Vertical tolerance=5 autoscale saturate");
//run("Bandpass Filter...", "filter_large=100 filter_small=2 suppress=Horizontal tolerance=5 autoscale saturate");

//Get total FFT magnitude
run("FFT");
run("Square", "stack");
run("Z Project...", "projection=[Sum Slices]");

//Find size of FFT image and get radial profile
getDimensions(imw, imh, d3, d4, d5);
imgrad = imw/2;
run("Select All");
run("Radial Profile", "x=imgrad y=imgrad radius=imgrad");
Plot.getValues(xvals, yvals);
for (i=0; i<yvals.length; i++)
	setResult("Value", i , yvals[i]);
updateResults();

//Save radial profile as xls file
saveAs("Measurements", path + imgname + ".xls");

//Save image with ROI and filter result shown. Will overwrite original image if is TIFF
//selectWindow(imgnamefull);
//run("Draw");
//saveAs("Tiff", path + imgname + ".tif");

//CLOSE EVERYTHING
//run("Close");
//close("*");

//The plot window doesn't close for some reason?