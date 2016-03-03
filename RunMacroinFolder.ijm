//Get path
input = getDirectory("Choose image file location");
list = getFileList(input);
//print(list[0]);

macropath = File.openDialog("Select a Marco to apply to every image in the folder");



first = true;
setBatchMode(false);
for (i=0; i<list.length; i++){
	path = input + list[i];
	showProgress(i, list.length);	
	if(!endsWith(path,"/")) open(path);
	if(nImages>=1){
		runMacro(macropath);
		close("*");
	}
}

//print results to table
