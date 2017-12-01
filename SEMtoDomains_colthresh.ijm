//Default parameter values
Ksegs = 4;//Number of segments for k-mean clustering
binIter = 18;//Number of iterations for binary erosion and dilation
binCount = 3;//Minimum number of exposed sides required to delete a pixel in erosion
semID = getImageID();
TensorWin = 10;//Size of orientation tensor window in pixels
minCirc = 0.05;//Minimum circularity of a domain
minSize = 3500;//Minimum size of a domain in pixels
CohThresh = 32;//Minimum coherency to retain a domain - mean gray of rgb image

setBatchMode(false);

//path for saving output files
path = getDirectory("image");
imgnamearray = split(getInfo("image.filename"), ".");
imgname = imgnamearray[0]

//Clear ROIs, results, and set result measurements
roiManager("reset")
run("Clear Results");
run("Set Measurements...", "area mean centroid redirect=None decimal=3");

// Run orientationj
//run("OrientationJ Analysis", "log=0.0 tensor=5 gradient=0 harris-index=on color-survey=on s-distribution=on hue=Orientation sat=Constant bri=Coherency ");
run("OrientationJ Distribution", "log=0.0 tensor=5.0 gradient=0 min-coherency=5.0 min-energy=6.0 harris-index=on color-survey=on s-mask=on hue=Orientation sat=Constant bri=Coherency ");
imageCalculator("Min", "Color-survey-1","S-Mask-1");
selectWindow("Color-survey-1");
colsurveyID = getImageID();
run("Duplicate...", " ");
colsurvey2ID = getImageID();
run("HSB Stack");
selectImage(colsurvey2ID);
run("Stack to Images");
selectWindow("Hue");

// Segment color survey
//run("k-means Clustering ...", "number_of_clusters=Ksegs cluster_center_tolerance=0.00010000 enable_randomization_seed randomization_seed=48");

setOption("BlackBackground", false);
run("Options...", "iterations=binIter count=binCount pad do=Nothing");

// Pull out each cluster into a mask and do particle analysis
//int [] setpoints = {1, 64, 128, 191};
setThreshold(1, 64);
run("Create Selection");
run("Create Mask");
//Binary processing of mask controled by binIter and binCount
run("Erode");
run("Dilate");
run("Analyze Particles...", "size=minSize-Infinity circularity=minCirc-1.00 display add");
close();
close("Hue");
close("Brightness");
close("Saturation");

selectImage(colsurveyID)
run("Duplicate...", " ");
colsurvey2ID = getImageID();
run("HSB Stack");
selectImage(colsurvey2ID);
run("Stack to Images");
selectWindow("Hue");
setThreshold(65, 127);
run("Create Selection");
run("Create Mask");
//Binary processing of mask controled by binIter and binCount
run("Erode");
run("Dilate");
run("Analyze Particles...", "size=minSize-Infinity circularity=minCirc-1.00 display add");
close();
close("Hue");
close("Brightness");
close("Saturation");

selectImage(colsurveyID)
run("Duplicate...", " ");
colsurvey2ID = getImageID();
run("HSB Stack");
selectImage(colsurvey2ID);
run("Stack to Images");
selectWindow("Hue");
setThreshold(128, 191);
run("Create Selection");
run("Create Mask");
//Binary processing of mask controled by binIter and binCount
run("Erode");
run("Dilate");
run("Analyze Particles...", "size=minSize-Infinity circularity=minCirc-1.00 display add");
close();
close("Hue");
close("Brightness");
close("Saturation");

selectImage(colsurveyID)
run("Duplicate...", " ");
colsurvey2ID = getImageID();
run("HSB Stack");
selectImage(colsurvey2ID);
run("Stack to Images");
selectWindow("Hue");
setThreshold(192, 255);
run("Create Selection");
run("Create Mask");
//Binary processing of mask controled by binIter and binCount
run("Erode");
run("Dilate");
run("Analyze Particles...", "size=minSize-Infinity circularity=minCirc-1.00 display add");
close();
close("Hue");
close("Brightness");
close("Saturation");

//Measure color suvey
run("Clear Results");
selectWindow("Color-survey-1");
roiManager("Select", Array.getSequence(roiManager("Count")));
roiManager("multi-measure measure_all");

//Find all ROIs with coherency (mean gray level) < CohThresh. 
//Append their index to array deleteROIs.
deleteROIs = newArray(0);
graytemp = newArray(1);
numresults = roiManager("count");

for (i=0; i<numresults; i++)  {
	MeanGray = getResult("Mean", i);
	if(MeanGray<CohThresh)  {
		Array.fill(graytemp, i);
		deleteROIs = Array.concat(deleteROIs, graytemp);
	}
}

//Delete every ROI indexed in array deleteROIs
roiManager("select", deleteROIs);
roiManager("Delete");

//Select all ROIs in manager and get measurement of color survey
//run("Clear Results");
selectWindow("Color-survey-1");
roiManager("Select", Array.getSequence(roiManager("Count")));
roiManager("multi-meaure measure_all");

//select original SEM image and measure orientation
selectImage(semID)

run("Table...", "name=Table width=350 height=250");
print("[Table]","\\Headings:X	Y	Area	Orientation	Coherency");
for (i=0; i<roiManager("count"); i++)  {
	roiManager("select", i);
	run("Interpolate", "interval=1");
	run("OrientationJ Measure", "sigma=0.0");
	OresAr = split(getInfo("Log"));
	//OresAr[15] is orientation (angles) and [16] is coherency (0-1)
	print("[Table]", OresAr[10]+"	"+OresAr[11]+"	"+getResult("Area", i)+"	"+OresAr[15]+"	"+OresAr[16]);
	selectWindow("Log");
	run("Close");
}

//Save results then clear
selectWindow("Table");
saveAs("Text", path + imgname + ".xls");
run("Close");

//Clear ROI manager and results
run("Clear Results");
roiManager("reset");

//Close all images

close("*");