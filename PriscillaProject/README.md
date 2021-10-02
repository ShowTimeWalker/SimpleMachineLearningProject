项目介绍  
  
1 目录介绍  
  1.1 文件夹:  
  ./MatlabScript - 存放matlab脚本以及mat数据文件  
  ./MatlabScript/DATA - 存放临时采集的数据  
  ./MatlabScript/TrainData - 存放待训练的数据集，命名规则见该路径下readme文件  
  ./SensorDataCollector - 存放arduino文件  
  
  1.2 文件  
  ./MatlabScript/ReadSerialDataFromArduinoUno.mlx - 脚本：用于生成serial采集数据的实时脚本  
  ./MatlabScript/readSineWaveData.m - 函数：串口读到换行符后触发的回调函数  
  ./MatlabScript/dataDivision.m - 函数：数据分割函数，输入连续波形，输出分割后的数据段  
  ./MatlabScript/EnergyValueDivision.m - 脚本：测试用，分割算法，用于作图  
  ./MatlabScript/ClassifierConstruction.m - 脚本：用于建立BPNN模型，并对预测数据集进行测试，统计结果  
  ./MatlabScript/BPNN_Construction.m - 函数：生成BPNN模型的函数，输入训练集和比例，输出网络模型  
  ./MatlabScript/dataPreprocess.m - 函数：数据预处理，调用特征提取函数，输入分割后的波段，输出训练集  
  ./MatlabScript/FeatureExtract.m - 函数：特征提取，输入波段，输出特征向量  
  ./MatlabScript/Predict.m - 函数：预测结果，输入训练后网络模型，待预测数据集，输出预测结果，精确度  
  ![](https://github.com/ShowTimeWalker/SimpleMachineLearningProject/blob/master/PriscillaProject/images/MatlabDir.png)  
  
2 数据采集流程  
  2.1 发送端  
  由于单片机的性能限制，只传输50HZ的声音和5HZ的CO2，TVOC浓度数据  
  为了提高传输效率，以数据包为单位传输，每个数据包(package)12个数据  
  一个数据包中包含10个声音数据，1个CO2浓度数据，单位ppm(parts per million)，1个TVOC浓度数据，单位ppb(parts per billion)  
  每秒钟发送5个package，代码如下：  
  ![](https://github.com/ShowTimeWalker/SimpleMachineLearningProject/blob/master/PriscillaProject/images/DataTransmitCode.png)  
  在串口监视器中，可以看到数据组织方式如下（一行表示一个package）：  
  ![](https://github.com/ShowTimeWalker/SimpleMachineLearningProject/blob/master/PriscillaProject/images/DataPackage.png)  
  将arduino源码写入单片机，运行即可，正常开始传输后关闭串口监视器  
  
  2.2 接收端  
  打开实时脚本：  
  ![](https://github.com/ShowTimeWalker/SimpleMachineLearningProject/blob/master/PriscillaProject/images/ReceiveInMatlab.png)  
  在最后一行打一个断点，运行脚本，开始自动采集数据，设定为30s后开始采集，采集时间为1分钟  
  每接收完一个数据包（回车换行），进行回调，回调函数如下：  
	![](https://github.com/ShowTimeWalker/SimpleMachineLearningProject/blob/master/PriscillaProject/images/CallbackFunction.png)  
  在回调函数中，调用数据分割算法，将连续的波形分割成为多个数据段，分割效果如图：  
  ![](https://github.com/ShowTimeWalker/SimpleMachineLearningProject/blob/master/PriscillaProject/images/DataDivision.png)  
  工作区形成数据包如下：  
  ![](https://github.com/ShowTimeWalker/SimpleMachineLearningProject/blob/master/PriscillaProject/images/DataAfterDivision.png)  
  运行脚本，对分割后的数据集进行预处理：  
  ![](https://github.com/ShowTimeWalker/SimpleMachineLearningProject/blob/master/PriscillaProject/images/Proprocessing.png)  
  代码4-9行为特征选择器，通过bool选择对应数据段的特征，代码24，26，28行为特征提取，一共可以提取16种特征，12中时域特征，4种频域特征，预处理完后，在工作区的数据如下：  
  ![](https://github.com/ShowTimeWalker/SimpleMachineLearningProject/blob/master/PriscillaProject/images/BeforeTraining.png)  
  在工作区形成了训练集train和目标值等数据，调用BPNN训练算法，训练模型，得到如下数据：  
  ![](https://github.com/ShowTimeWalker/SimpleMachineLearningProject/blob/master/PriscillaProject/images/AfterTraining.png)  
  对应的代码如下：  
  ![](https://github.com/ShowTimeWalker/SimpleMachineLearningProject/blob/master/PriscillaProject/images/ClassifierConstructionCode.png)  
  代码3-6行进行配置参数，第8行调用预处理函数进行特征提取，归一化等预处理，第9行进行训练模型，训练结果如下：  
  Performance:  
  ![](https://github.com/ShowTimeWalker/SimpleMachineLearningProject/blob/master/PriscillaProject/images/Performance.png)  
  ConfusionMarrix:  
  ![](https://github.com/ShowTimeWalker/SimpleMachineLearningProject/blob/master/PriscillaProject/images/ConfusionMatrix.png)  
  其他信息：  
  ![](https://github.com/ShowTimeWalker/SimpleMachineLearningProject/blob/master/PriscillaProject/images/TrainResult.png)  
  模型训练完后，保存在工作区，组织一组未参与训练的数据，作为预测集，调用预测函数，获得预测分类结果，最后在终端展示预测结果：  
  ![](https://github.com/ShowTimeWalker/SimpleMachineLearningProject/blob/master/PriscillaProject/images/ResultInConsole.png)  
