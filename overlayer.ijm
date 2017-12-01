//
// Overlays CNT domain images onto SEM source images
// Put only domain and SEM images into folder
// Select folder when prompted

setBatchMode(true);

input = getDirectory("Choose image file location");
list = getFileList(input);


for (i=0; i<list.length; i++){
    // Assumes SEM image comes before domain image alphabetically
    sem_image = list[i];
    domain_image = list[i+1];
    
    path = input + domain_image;
    if(!endsWith(path,"/")) open(path);
    
    path = input + sem_image;
    if(!endsWith(path,"/")) open(path);
    
    sem_imgnamearray = split(getInfo("image.filename"), ".");
    sem_imgname = sem_imgnamearray[0];
    
    run("Add Image...", "image=&domain_image x=0 y=0 opacity=40 zero");
    
    save(input + sem_imgname + "_overlay.png");
    
    close("*");
    //Additional increment to i to skip to the next SEM image in list
    i += 1;
    
}