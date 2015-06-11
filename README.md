# impSDM

A Matlab implementation of Supervised Descent Method (SDM) for Face
Alignment.

We provide both training and testing modules. It is under development for 
an improvement version: Global Supvervised Descent Method (GSDM).

The ogirinal paper: 

Xiong et F. De la Torre, 
Supervised Descent Method and its Applications to Face Alignment, 
CVPR 2013.

===========================================================================

Dependency:
   - Vlfeat library: http://www.vlfeat.org/
   - libLinear: www.csie.ntu.edu.tw/~cjlin/liblinear/

Datasets in use:

[300-W] http://ibug.doc.ic.ac.uk/resources/facial-point-annotations/

How to use:

1. Download 300-W data (i.e. LFPW) from above link and put into "./data" 
   folder, then correct the dataset path to your dataset foler in setup.m

   >> mkdir -p data
  
   For example:

	options.trainingImageDataPath = './data/lfpw/trainset/';
	options.trainingTruthDataPath = './data/lfpw/trainset/';
                                   
	options.testingImageDataPath  = './data/lfpw/testset/';
	options.testingTruthDataPath  = './data/lfpw/testset/';
   
2. Download and install dependencies: libLinear, Vlfeat, mexopencv, put
   into "./lib" folder and compile if necessary. Make sure you already 
   addpath(...) all folders in matlab. 
   Check and correct the library path in setup.m.

   >> mkdir -p lib
   
   libLinear: 
     - Open Matlab
     - Go to i.e. lib/liblinear-1.96/matlab/ in Matlab editor.
     - Run make.m to comile *.mex files.

   Vlfeat:
     - >> cd lib/vlfeat/ && make
     - cd ./toolbox in Matlab editor.
     - Run vl_setup
     - Compile mex Hog functions:
       >> cd misc
       >> mex -L../../bin/glnx86 -lvl -I../ -I../../ vl_hog.c
     - Setup libvl.so path.
     - Assume that your libvl.so located at: <vlfeat_folder>/bin/glnx86
       Create soft link:
       >> ln -s <vlfeat_folder>/bin/glnx86/libvl.so /usr/local/libvl.so
       Check if the libvl.so is ready to use.
       >> ldd vl_hog.mexglx
       If libvl.so still not found.
       Add /usr/local/lib into /etc/ld.so.conf (sudo).
       >> sudo ldconfig
       >> ldconfig -p | grep libvl.so
       Check again: >> ldd vl_hog.mexglx
      

3. If you run first time. You should set these following parameters
   to learn shape and variation. For later time, reset to 0.

   options.learningShape     = 1;
   options.learningVariation = 1;

4. Do training:
   >> run_training();
   
5. Do testing:
   >> do_testing();


Note that in the program, we provide the simple training models in folder:
"./model" that trained only on 10 images. You should re-train on the whole
dataset. The program does not optimize the memory during training, the 
memory program may happens if you train on too much data.
