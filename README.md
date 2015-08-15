# Matlab Implementation （version 2.0）of Supervised Descent Method

本版本是上一版的修订版，我们仔细阅读了原来的代码，发现了一些问题，最后我们对源代码做了一些修正，主要包括：
- 修复了代码运行中出现的一些bug
- 添加了一些函数，使代码更简洁

- 参考论文[《Extended Supervised Descent Method for Robust Face Alignment》][1]，优化了源程序
- 在测试阶段，我们使用了逆的缩放和平移变换将得到的aligned_shape
转换为原始图片的特征点true_shape
- 添加了详细的注释，使之更容易明白。

===========================================================================

# Dependency:
  - Vlfeat library: http://www.vlfeat.org/

     提供了hog/sift特征函数，程序默认使用hog特征，如果要使用sift特征，你可以使用xx_sift.m提供的接口（见commom/desc/xx_sift.m）.如果使用Vlfeat的sift,你需要修改程序。因为程序默认的sift接口为xx_sift.m
  - libLinear:  http://www.csie.ntu.edu.tw/~cjlin/liblinear/

     使用其提供的svm方法计算超定方程组的根
  - mexopencv: https://github.com/kyamagu/mexopencv

     使用其提供的人脸检测程序（不过程序中我们一般以ground_truth的特征点的包围盒替代，更准确）
# Datasets in use:

[300-W] http://ibug.doc.ic.ac.uk/resources/facial-point-annotations/

该数据集仅提供了68个特征点的数据，也就是w300类型的数据

# How to use:

1. 从以上链接中下载300-W数据（i.e. LFPW），并放在"./data" 文件夹下。
   然后纠正setup.m中的数据集的路径
  
   For example:

  options.trainingImageDataPath = './data/lfpw/trainset/';

  options.trainingTruthDataPath = './data/lfpw/trainset/';
                                   
  options.testingImageDataPath  = './data/lfpw/testset/';

  options.testingTruthDataPath  = './data/lfpw/testset/';
   
2. Download and install dependencies: libLinear, Vlfeat, mexopencv, put
   into "./lib" folder and compile if necessary. Make sure you already 
   addpath(...) all folders in matlab. 
   Check and correct the library path in setup.m.

   安装方法分别见：
   
   libLinear：http://m.blog.csdn.net/blog/tiandijun/40929563
   
   Vlfeat：http://www.cnblogs.com/woshitianma/p/3872939.html
   
   mexopencv：http://wangcaiyong.com/2015/07/14/mexopencv/
      
3. If you run first time. You should set these following parameters
   to learn shape and variation. For later time, reset to 0.

   options.learningShape     = 1;
   
   options.learningVariation = 1;

  说明：第一个变量**learningShape**学习了数据集的平均特征点；第二个变量**learningVariation**学习了true_shape与mean_shape的包围盒之间差值（一个box包含四个变量x,y,width,height）的均值和方差，后期用在扰动产生更多的初始特征值.

4. Do training:
   >> run_training();
   
5. Do testing:
   >> do_testing();

6. 遗憾的是，我们还是没有真正对程序优化内存和速度，我们在程序运行中发现，占内存最严重的变量是storage_init_desc（特征向量矩阵），试想以LFBW为例，训练集共有811张图片，如我们扰动初始值10次，将会产生8110个shape,若使用sift特征（<img src="http://latex.codecogs.com/gif.latex?4*4*8=128" /> 维），加之特征点数为68，则storage_init_desc的维数将是<img src="http://latex.codecogs.com/gif.latex?8704*8110" /> ，对其使用SVM方法，程序跑不动，内存占满。
7. 新增函数列表
 - /common/cropImage/cropImage.m
 - /common/desc/xx_sift.m
 - /common/flip/flipImage.m
 - /common/io/write_w300_shape.m
 - /source/train/learn_single_regressor2.m
8. 关于上述修正细节请参考系列博文[《Some improvements about SDM for face alignment 》][2]

 
  [1]: https://dn-xiamenwcy.qbox.me/sdm/Extended%20Supervised%20Descent%20Method%20for%20Robust%20Face%20Alignment.pdf
  [2]: http://wangcaiyong.com/2015/08/14/sdm/
