// Set binary options
run("Options...", "iterations=4 count=2 pad");
//selects the ROI
if (roiManager("Count") == 0) exit("Please select the ROI and add to ROI manager (ctrl + t)");
roiManager("Select", 0);

run("Crop");
run("Despeckle");
run("Subtract Background...", "rolling=50");
setAutoThreshold("IsoData dark");
run("Convert to Mask");
run("Close-");
run("Watershed");
run("Analyze Particles...", "size=4-Infinity summarize");
