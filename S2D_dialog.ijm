//Make a dialog box to change values
Dialog.create("Ben's domain segmenter");
Dialog.addNumber("OrientationJ tensor window size (pixels)", TensorWin);
Dialog.addNumber("Number of Clusters", Ksegs);
Dialog.addNumber("Binary Iterations", binIter);
Dialog.addNumber("Binary Count", binCount);
Dialog.addNumber("Minimum domain circularity", minCirc);
Dialog.addNumber("Minimum domain size (px)", minSize);
Dialog.addNumber("Domain coherency threshold (mean gray)", CohThresh);
Dialog.show();
TensorWin = Dialog.getNumber();
Ksegs = Dialog.getNumber();;
binIter = Dialog.getNumber();;;
binCount = Dialog.getNumber();;;;
minCirc = Dialog.getNumber();;;;;
minSize = Dialog.getNumber();;;;;;
CohThresh = Dialog.getNumber();;;;;;;