run("8-bit");
run("Subtract Background", "rolling=50");
setAutoThreshold("Triangle dark");
setOption("BlackBackground", false);
run("Convert to Mask");
run("Open");
run("Close-");
run("Watershed");
run("Analyze Particles...", "display clear");
