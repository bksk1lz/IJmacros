//Get path
input = getDirectory("Choose image file location");
list = getFileList(input);
//print(list[0]);



first = true;
setBatchMode(false);
for (i=0; i<list.length; i++){
	path = input + list[i];
	showProgress(i, list.length);	
	if(!endsWith(path,"/")) open(path);
	if(nImages>=1){
		if(first){
			waitForUser("Select area (rectangle) for analysis");
			roiManager("Reset");
			roiManager("Add");	
			close();
			first = false;
			setBatchMode(true);
			open(path);
			//Initialize table with path name
			run("Table...", "name=Table width=350 height=250");
			print("[Table]","\\Headings:Filename	No. spots	Spot area mean	Spot area SD	T value	Seconds since mix");
		}
		roiManager("select", 0);
		run("Crop");
		run("8-bit");
		run("Subtract Background...", "rolling=30");
		setAutoThreshold("IsoData dark");
		setOption("BlackBackground", false);
		run("Convert to Mask", "method=IsoData background=Dark calculate list");
		run("Open");
		run("Watershed");
		run("Analyze Particles...", "display clear");
		count = nResults;
		run("Summarize");
		//Area result
		mean = getResult("Area", nResults - 4);
		//SD result
		sd = getResult("Area", nResults - 3);
		//Timeresult1
		fullname = File.getName(path);
		splitname = split(fullname, "TE_");
		Tval = splitname[1];
		//Timeresult2
		Eval = splitname[2];
		print("[Table]", fullname+"	"+count+"	"+mean+"	"+sd+"	"+Tval+"	"+Eval);
	}
}

//print results to table

