// this is the 'mechanical turk' version - outputs image with domains overlaid only. No measuremets.
//Default parameter values
Ksegs = 4;//Number of segments for k-mean clustering
binIter = 22;//Number of iterations for binary erosion and dilation
binCount = 4;//Minimum number of exposed sides required to delete a pixel in erosion
semID = getImageID();
TensorWin = 10;//Size of orientation tensor window in pixels
minCirc = 0.05;//Minimum circularity of a domain
minSize = 7000;//Minimum size of a domain in pixels
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
run("OrientationJ Analysis", "log=0.0 tensor=5 gradient=0 harris-index=on color-survey=on s-distribution=on hue=Orientation sat=Constant bri=Coherency ");
//run("OrientationJ Distribution", "log=0.0 tensor=5.0 gradient=0 min-coherency=5.0 min-energy=10.0 harris-index=on color-survey=on s-mask=on hue=Orientation sat=Constant bri=Coherency ");
//imageCalculator("Min", "Color-survey-1","S-Mask-1");
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

//Make new image to draw domains
getDimensions(imw, imh, d3, d4, d5);
newImage("temp", "RGB black", imw, imh, 1);
roiManager("Show All");
run("Colors...", "foreground=blue");
roiManager("Fill");

//select original SEM image and measure orientation
selectImage(semID);
run("RGB Color");
run("Add Image...", "image=temp x=0 y=0 opacity=15 zero");
run("Flatten");

//Draw domains (all ROIs in manager)
roiManager("Show All");
run("Colors...", "foreground=blue");
roiManager("Draw");


save(path + imgname + "_k" + Ksegs + "_t" + TensorWin + ".png");


close("*");