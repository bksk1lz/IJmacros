// this is the 'mechanical turk' version - outputs image with domains overlaid only. No measuremets.
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

