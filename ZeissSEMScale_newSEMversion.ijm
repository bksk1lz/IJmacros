//This very simple macro sets the scale for SEM images taken with the Carl
//Zeiss SmartSEM program. It requires the tiff_tags plugin written by
//Joachim Wesner. It can be downloaded from
// http://rsbweb.nih.gov/ij/plugins/tiff-tags.html

//This is the number of the VERY long tag that stores
//all the SEM information
tagnum=34118;

//Gets the path+name of the active image
path = getDirectory("image");
if (path=="") exit ("path not available");
name = getInfo("image.filename");
if (name=="") exit ("name not available");
path = path + name;

//Gets the tag, and parses it to get the pixel size information
tag = call("TIFF_Tags.getTag", path, tagnum);
i0 = 8;
i1 = indexOf(tag, " 5", i0);

text = substring(tag,8,i1);

//Printed these for debugging...
//print(text);
//print(parseFloat(text));
//print(d2s(parseFloat(text) * 1e6,8));

umPerPx = d2s(parseFloat(text) * 1e6, 8);
run("Set Scale...", "distance=1 known="+umPerPx+" pixel=1 unit=um")