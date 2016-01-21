//Default parameter values
Ksegs = 4;//Number of segments for k-mean clustering
binIter = 5;//Number of iterations for binary erosion and dilation
binCount = 1;//Minimum number of exposed sides required to delete a pixel in erosion
semID = getImageID();
TensorWin = 5;//Size of orientation tensor window in pixels
minCirc = 0.05;//Minimum circularity of a domain
minSize = 1000;//Minimum size of a domain in pixels
CohThresh = 25;//Minimum coherency to retain a domain - mean gray of rgb image

//Make a dialog box to change values
Dialog.create("Ben's domain segmenter");
Dialog.addNumber("OrientationJ tensor window size (pixels)", TensorWin);
Dialog.addNumber("Number of Clusters", Ksegs);
Dialog.addNumber("Binary Iterations", binIter);
Dialog.addNumber("Binary Count", binCount);
Dialog.addNumber("Minimum domain circularity", minCirc);
Dialog.addNumber("Minimum domain size (px)", minSize);
Dialog.addNumber("Domain coherency threshold (mean gray)", CohThresh);
Dialog.show();
TensorWin = Dialog.getNumber();
Ksegs = Dialog.getNumber();;
binIter = Dialog.getNumber();;;
binCount = Dialog.getNumber();;;;
minCirc = Dialog.getNumber();;;;;
minSize = Dialog.getNumber();;;;;;
CohThresh = Dialog.getNumber();;;;;;;

//Clear ROIs, results, and set result measurements
roiManager("reset")
run("Clear Results");
run("Set Measurements...", "area mean centroid redirect=None decimal=3");

// Run orientationj
run("OrientationJ Analysis", "log=0.0 tensor=5 gradient=0 harris-index=on color-survey=on s-distribution=on hue=Orientation sat=Constant bri=Coherency ");
selectWindow("Color-survey-1");

// Segment color survey
run("k-means Clustering ...", "number_of_clusters=Ksegs cluster_center_tolerance=0.00010000 enable_randomization_seed randomization_seed=48");

setOption("BlackBackground", false);
run("Options...", "iterations=binIter count=binCount pad do=Nothing");

// Pull out each cluster into a mask and do particle analysis
for (i=0; i<Ksegs; i++)  {
	setThreshold(i, i);
	run("Create Selection");
	run("Create Mask");
	//Binary processing of mask controled by binIter and binCount
	run("Erode");
	run("Dilate");
	run("Analyze Particles...", "size=minSize-Infinity circularity=minCirc-1.00 display add");
	close(); //close mask
	
}
//close(); // close cluster image
//close(); // close color survey, now original SEM image is open

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
	MeanGray = getResultString("Mean", i);
	MeanGray = parseFloat(MeanGray);
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

//Make new image to draw domains
getDimensions(imw, imh, d3, d4, d5);
newImage("Domain Preview", "RGB black", imw, imh, 1);

//Draw domains (all ROIs in manager)
roiManager("Show All");
run("Colors...", "foreground=orange");
roiManager("Fill");
run("Colors...", "foreground=green");
roiManager("Draw");

//select original SEM image and measure orientation
selectImage(semID)

print("Results Start");
for (i=0; i<roiManager("count"); i++)  {
	roiManager("select", i);
	run("Interpolate", "interval=1");
	run("OrientationJ Measure", "sigma=0.0");
}
