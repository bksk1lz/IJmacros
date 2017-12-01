//Default parameter values
Ksegs = 4;//Number of segments for k-mean clustering
binIter1 = 20;//Number of iterations for binary erosion and dilation original 20 40
binIter2 = 40;
binCount1 = 1;//Minimum number of exposed sides required to delete a pixel in erosion
binCount2 = 4;
semID = getImageID();
//TensorWin = 7;//Size of orientation tensor window in pixels
minCirc = 0.05;//Minimum circularity of a domain
minSize = 7000;//Minimum size of a domain in pixels
CohThresh = 50;//Minimum coherency to retain a domain - mean gray of rgb image

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
run("Gaussian Blur...", "sigma=2");
run("OrientationJ Analysis", "log=0.0 tensor=10 gradient=0 harris-index=on color-survey=on s-distribution=on hue=Orientation sat=Constant bri=Coherency ");
selectWindow("Color-survey-1");
run("Gaussian Blur...", "sigma=16");

// Segment color survey
run("k-means Clustering ...", "number_of_clusters=Ksegs cluster_center_tolerance=0.00010000 enable_randomization_seed randomization_seed=48");

setOption("BlackBackground", false);


// Pull out each cluster into a mask and do particle analysis
for (i=0; i<Ksegs; i++)  {
	setThreshold(i, i);
	run("Create Selection");
	run("Create Mask");
	//Binary processing of mask controled by binIter and binCount
    run("Options...", "iterations=binIter1 count=binCount1 pad do=Nothing");
	run("Fill Holes");
    run("Erode");
	run("Dilate");
    run("Options...", "iterations=binIter2 count=binCount2 pad do=Nothing");
    run("Dilate");
    run("Erode");
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
run("Line Width...", "line=10");
roiManager("Draw");
save(path + imgname + "_domains.png")

selectImage(semID);
runMacro("ZeissSEMScale_newSEMversion.ijm");
scaleVal = 1;
toScaled(scaleVal);

//select original SEM image and measure orientation


run("Table...", "name=Table width=350 height=250");
print("[Table]","\\Headings:X	Y	Area	Orientation	Coherency	umperpx:"+scaleVal);
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