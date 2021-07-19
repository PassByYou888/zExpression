## zExpression 句法编译器+解释器，脚本引擎内核


## 技术体系解释：
- 在编译原理的技术体系中，凡是处理文本化的代码前，都需要做一次预处理，其中我们常说的语法，语法糖，都是一种预处理程序
- 词法：词法是对文本关键字，数字，符号，进行分类整理，最后形成词法树，并且严格遵循顺序化处理原则
- 申明：在预处理代码中，申明部分，叫做申明树，申明树又依赖于词法顺序预处理，因为对词法预处理是一种简化手段
- 句法：在经过了申明预处理以后，是对代码表达式的单行逻辑操作进行处理，这一步叫句法，取为zExpression句法编译器是我从曾经撰写的编译器中特意剥离出来的解决方案，它可以独立出来分发和使用，可以实用数字化预处理，图形图像，科学计算等等领域，也可以作为学习提高自己的手段



## 核心思路
- 实现zExpression采用的是对等复杂化原则，面向解决编译器问题而编写，复杂度相比于常规程序会高许多，因为解决了最终问题，代码在命名和堆结构上也看不出漏洞，所以它是成熟句法解释器方案

## zExpression特点
- 完整的单步原子化操作
- 完整的符号优先级后处理
- 能预处理字面错误，并反馈错误发生在哪
- 能识别浮点和整数的自然数写法
- 支持函数调用
- 支持自定义脚本语法
- 逆波兰2.0符号优先级处理
- 支持安卓和苹果各型号手机
- 完整的功能Demo，完整性能和解析准确性评估框架
- 在编译以后，能形成原子化op代码，可以通过stream高速载入并运行，不限制cpu类型
- OP代码框架可以轻松译码成ARMv7 ARMx64 x64 x86等平台的机器码
- 矩阵和向量表达式支持

## 平台支持，test with Delphi 10.3 update 2 and FPC 3.0.4

- Windows: delphi-CrossSocket(C/S OK), delphi-DIOCP(C/S OK), delphi-ICS(C/S OK), delphi-Indy(C/S OK),delphi+fpc Synapse(C/S OK)
- Android:Indy(C/S OK), CrossSocket(Only Client)
- IOS Device: Indy(C/S OK), CrossSocket(Only Client)
- IOS Simulaor: n/a
- OSX: Indy(C/S OK)，ICS(未测试), CrossSocket(C/S OK)
- Ubuntu16.04 x64 server: Indy(C/S OK), CrossSocket(C/S OK)
- Ubuntu18.04 x86+x64 Desktop:only fpc3.0.4 Synapse(C/S OK)
- Ubuntu18.04 x86+x64 Server:only fpc3.0.4 Synapse(C/S OK) 
- Ubuntu18.04 arm32+arm neon Server:only fpc3.0.4 Synapse(C/S OK)
- Ubuntu18.04 arm32+arm neon desktop:only fpc3.0.4 compile ok,no test on run.  
- Ubuntu16.04 Mate arm32 desktop:only fpc3.0.4 compile ok, test passed  
- Raspberry Pi 3 Debian linux armv7 desktop,only fpc 3.0.4,test passed.
- wince(arm eabi hard flaot),windows 10 IOT,only fpc 3.3.1,test passed.

## CPU架构支持，test with Delphi 10.3 update 2 and FPC 3.0.4

- MIPS(fpc-little endian), soft float, test pass on QEMU 
- intel X86(fpc-x86), soft float
- intel X86(delphi+fpc), hard float,80386,PENTIUM,PENTIUM2,PENTIUM3,PENTIUM4,PENTIUMM,COREI,COREAVX,COREAVX2
- intel X64(fpc-x86_64), soft float
- intel X64(delphi+fpc), hard float,ATHLON64,COREI,COREAVX,COREAVX2
- ARM(fpc-arm32-eabi,soft float):ARMV3,ARMV4,ARMV4T,ARMV5,ARMV5T,ARMV5TE,ARMV5TEJ
- ARM(fpc-arm32-eabi,hard float):ARMV6,ARMV6K,ARMV6T2,ARMV6Z,ARMV6M,ARMV7,ARMV7A,ARMV7R,ARMV7M,ARMV7EM
- ARM(fpc-arm64-eabi,hard float):ARMV8，aarch64


## 更新日志

### 2021-7

- 修复字符表达式**-2.0E-3**这类识别问题
- 修复OpCode.pas库因为大小写敏感不兼容win/linux问题

### 2020-3

- 对注册函数新增申明信息
- 修复函数前符号 -func(1+1)
- 修复函数后符号 func(1+1)-1

### 2019-7

**矩阵表达式支持**

```delphi
// 构建3*3的variant矩阵，使用c语法表达式
procedure MatrixExp;
var
  m: TExpressionValueMatrix;
begin
  DoStatus('');
  m := EvaluateExpressionMatrix(3, 3,
    '"hello"+"-baby"/*备注：字符串联合*/,true,false,' +
    '1+1,2+2,3+3,' +
    '4*4,4*5,4*6', tsC);
  DoStatus(m);
end;

// 构建variant向量数组，使用pascal语法表达式
procedure MatrixVec;
var
  v: TExpressionValueVector;
begin
  DoStatus('');
  v := EvaluateExpressionVector('0.1*(0.1+max(0.15,0.11)){备注内容},1,2,3,4,5,6,7,8,9', tsPascal);
  DoStatus(v);
end;
```


### 2019-4

- 修复TextParsing备注编码后的bug
- OpCode新增回调调用类型(参考zAI工具链中的Script支持)

### 2018-9-29

- 新技术:新增文本探头技术：可将蚂蚁程序的编程复杂度降低50%
- 新技术:逐字符文本字符爬取性能提升%500
- 多平台:全面支持多种IOT系统以及多处理器硬件架构
- 新Demo:新增一个FPC的Demo，该Demo不使用匿名函数
- 工艺:兼容基于FPC对IOT的支持：从底层到高级，大规模统一调整命名，此项调整会影响很多工程的代码细节

```delphi
// 本项目中的回调分为3种
// call:   直接指针回调，fpc+delphi有效
// method: 方法回调，会继承一个方法宿主的地址，fpc+delphi有效
// proc:   匿名过程回调，只有delphi有效

// 如果本项调整对于改造现有工程有一定的工作量，请使用字符串批量处理工具
// 在任何有回调重载的地方，方法与函数，均需要在后缀曾加回调类型首字母说明

// 如
RunOp 变更为 RunOpP() // 后缀加P表示匿名类型回调
RunOp 变更为 RunOpM() // 后缀加M表示方法类型的回调
RunOp 变更为 RunOpC() // 后缀加C表示指针类型的回调

```


### 2018-7-6
- 大幅修正底层库的命名规则
- 对fpc/86/64平台支持，全部基础库支持Linux下的无故障编译和运行
- 对fpc编译器3.1.1全面支持
- 新增大小字节序支持
- 修复对32位fpc编译器不认for用Int64的问题
- 修复字符串在fpc编译器运行于linux发生异常的问题
- 新增pascal预编译工具，将pascal代码规范成c风格的全部统一大小写，全面兼容Linux区分大小写文件名的机制

### 2018-4-12

- 修复内核中的内存越界bug：该bug的症状为无故提示内存无法访问，通过正常debug很难排除，这是是内存越界时所造成的bug

### 2018-3-1

- 在TPascalString内核中新增模糊字符串对比函数（SmithWaterman），优化与测试完成
- 该算法属于生物基因工程学科 Smith-Waterman的维基百科地址 https://en.wikipedia.org/wiki/Smith%E2%80%93Waterman_algorithm

### 2018-2-28

- 修复c转义字符buf，感谢阿木qq345148965
- 将charPos的参数命名更改成了cOffset，并且加入const修饰符

### 2018-2-26

- 修复使用Release模式无法编译问题
- 修复zExpression的切割分段不正确问题
- 小幅提升字符探头的切割性能(splitToken,splitChar)
- 因为底层重写了一个原子锁，在很多record申明前加入了packed修饰符

### 2018-2-25

- 新增自定义表达式符号支持
- 新增自定义表达式符号的演示

### 2018-2-25

- 修复嵌套函数参数不能正确展开接口的问题
- 修复解析引擎的数字探头不能识别16进制自然数和函数问题
- 新增一个赋值的demo范例，包含变量申明，静态复用，动态复用，总共三部曲，请在范例演示中自行研究
- 修复字符串和数字匹配联合的问题
- 支持c代码风格0x16进制语法

### 2018-2-6


- 重写了一次解析器内核，支持函数调用，从现在起，zExpression会不断更新


----------



使用zExpression有疑问请加互助qq群490269542，请不要直接联系作者

by.qq600585
2017-6

