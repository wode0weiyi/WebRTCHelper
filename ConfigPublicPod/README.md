# ConfigPrivatePod
组件化脚本文件

#使用方法
1.在一个文件里下载这个文件，比如project文件：
  git clone git@github.com:wode0weiyi/ConfigPrivatePod.git
  
2.将ConfigPrivatePod的template文件夹下Podfile中source 'https://github.com/HGModulizationDemo/PrivatePods.git'改成第一步里面你自己的私有Pod源仓库的repo地址

3.将ConfigPrivatePod的template文件夹下upload.sh中改成第二步里面你自己的私有Pod源仓库的名字 

4.在创建一个私有库组件的时候，比如文件结构目录

Project
  ├── ConfigPrivatePod
  └── A
  
 A是需要组件化的文件
 
  在githup上面建立好A的repo后，然后cd到ConfigPrivatePod下，执行./config.sh脚本来配置A这个私有Pod。脚本会问你要一些信息，Project Name就是A，要跟你的A工程的目录名一致。HTTPS Repo、SSH Repo网页上都有，Home Page URL就填你A Repo网页的URL就好了。
  
  
  

