
//path for saving output files
path = getDirectory("image");
imgnamefull = getInfo("image.filename");
imgnamearray = split(imgnamefull, ".");
imgname = imgnamearray[0];

//Selects ROI
if (roiManager("Count") == 0) exit("Please select the ROI and add to ROI manager (ctrl + t)");
roiManager("Select", 0);
run("Crop");

//Despeckle (there is a lot of sensor? noise)
run("Remove Outliers...", "radius=2 threshold=40 which=Bright");

saveAs("Tiff", path + imgname + ".tif");
//selectWindow(imgnamefull);
//run("Close");