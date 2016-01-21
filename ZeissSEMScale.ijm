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
i0 = indexOf(tag, "Pixel Size = ");
if (i0==-1) exit ("Scale information not found");
i1 = indexOf(tag, "=", i0);
i2 = indexOf(tag, "AP", i1);
if (i1==-1 || i2==-1 || i2 <= i1+4)
    exit ("Parsing error! Maybe the file structure changed?");
text = substring(tag,i1+2,i2-2);

//Splits the pixel size in number+unit
//and sets the scale of the active image
tokens=split(text);
i3 = parseFloat(tokens[0]);
i3 = i3 / 1000;
i4 = d2s(i3, 5);
run("Set Scale...", "distance=1 known="+i4+" pixel=1 unit=um");