## zExpression 句法编译器+解释器，脚本引擎内核


## 技术体系解释：
在编译原理的技术体系中，凡是处理文本化的代码前，都需要做一次预处理，其中我们常说的语法，语法糖，都是一种预处理程序

词法：词法是对文本关键字，数字，符号，进行分类整理，最后形成词法树，并且严格遵循顺序化处理原则

申明：在预处理代码中，申明部分，叫做申明树，申明树又依赖于词法顺序预处理，因为对词法预处理是一种简化手段

句法：在经过了申明预处理以后，是对代码表达式的单行逻辑操作进行处理，这一步叫句法，取为zExpression句法编译器是我从曾经撰写的编译器中特意剥离出来的解决方案，它可以独立出来分发和使用，可以实用数字化预处理，图形图像，科学计算等等领域，也可以作为学习提高自己的手段



## 核心思路

实现zExpression采用的是对等复杂化原则，面向解决编译器问题而编写，复杂度相比于常规程序会高许多，因为解决了最终问题，代码在命名和堆结构上也看不出漏洞，所以它是成熟句法解释器方案

## zExpression特点

完整的单步原子化操作

完整的符号优先级后处理

能预处理字面错误，并反馈错误发生在哪

能识别浮点和整数的自然数写法

支持函数调用

支持自定义脚本语法

逆波兰2.0符号优先级处理

支持安卓和苹果各型号手机

完整的功能Demo，完整性能和解析准确性评估框架

在编译以后，能形成原子化op代码，可以通过stream高速载入并运行，不限制cpu类型

OP代码框架可以轻松译码成ARMv7 ARMx64 x64 x86等平台的机器码


## 基本用法演示

```Delphi
var
  rt: TOpCustomRunTime;
  v : Variant;
begin
  // rt为ze的运行函数支持库
  rt := TOpCustomRunTime.Create;
  rt.RegOp('myAddFunction', function(var Param: TOpParam): Variant
    // (a+b)*0.5
    begin
      Result := (Param[0] + Param[1]) * 0.5;
    end);
  rt.RegOp('myStringFunction', function(var Param: TOpParam): Variant
    begin
      Result := Format('字符串长度为:%d', [Length(VarToStr(Param[0]) + VarToStr(Param[1]))]);
    end);

  // 简单数学表达式
  v := EvaluateExpressionValue(False, '1000+{ 这里是备注 ze可以识别pascal和c的备注以及字符串写法 } myAddFunction(1+1/2*3/3.14*9999, 599+2+2*100 shl 3)', rt);
  DoStatus(VarToStr(v));

  // 简单字符串表达式，ze的默认文本处理格式为Pascal
  v := EvaluateExpressionValue(False, 'myStringFunction('#39'abc'#39', '#39'123'#39')', rt);
  DoStatus(VarToStr(v));

  // 简单字符串表达式，我们使用c的文本格式
  v := EvaluateExpressionValue(tsC, 'myStringFunction("abc", "123")', rt);
  DoStatus(VarToStr(v));

  disposeObject(rt);
end;

```

## 基于二进制Stream的高速读取与执行

```delphi
var
  tmpSym: TSymbolExpression;
  op    : TOpCode;
  rt    : TOpCustomRunTime;
  m64   : TMemoryStream64;
begin
  // rt为ze的运行函数支持库
  rt := TOpCustomRunTime.Create;
  rt.RegOp('myAddFunction', function(var Param: TOpParam): Variant
    // (a+b)*0.5
    begin
      Result := (Param[0] + Param[1]) * 0.5;
    end);
  rt.RegOp('myStringFunction', function(var Param: TOpParam): Variant
    begin
      Result := Format('字符串长度为:%d', [Length(VarToStr(Param[0]) + VarToStr(Param[1]))]);
    end);

  // 使用ParseTextExpressionAsSymbol函数，将表达式翻译成词法树
  tmpSym := ParseTextExpressionAsSymbol(TTextParsing, '', '1000+myAddFunction(1+1/2*3/3.14*9999, 599+2+2*100 shl 3)', nil, rt);
  // BuildAsOpCode会将词法树再次翻译成语法树，然后再基于语法树生成op代码
  op := BuildAsOpCode(tmpSym);
  disposeObject(tmpSym);
  // 我们执行一次op
  DoStatus('op运行返回值(正确值为4489.2962): %s', [VarToStr(op.Execute(rt))]);

  m64 := TMemoryStream64.Create;
  op.SaveToStream(m64);

  // 这里已经释放了op
  disposeObject(op);

  // 从stream快速读取op，这便于我们在
  m64.Position := 0;
  if LoadOpFromStream(True, m64, op) then
    begin
      DoStatus('op运行返回值(正确值为4489.2962): %s', [VarToStr(op.Execute(rt))]);
    end;

  disposeObject([op, rt, m64]);

  DoStatus('高速载入与执行demo，运行完毕');
end;
```


## 自己实现IF结构体，基于ze自带的词法引擎TTextParsing解析脚本和编译器中的IF结构体内部流程

```delphi
type
  TState = (sUnknow, sIF, sTrue, sFalse); // 解析用的简单状态机
label gFillStruct;
var
  t                                      : TTextParsing;     // 词法解析引擎
  cp, ep                                 : Integer;          // 字坐标
  wasNumber, wasText, wasAscii, wasSymbol: Boolean;          // 解析文本状态机
  state                                  : TState;           // 解析结构状态机
  decl                                   : TPascalString;    // 当前解析词法体，包括
  ifMatchBody                            : TPascalString;    // 条件布尔判断运行体
  ifTrueBody                             : TPascalString;    // 条件成立运行体
  ifFalseBody                            : TPascalString;    // 条件不成立运行体
  rt                                     : TOpCustomRunTime; // 运行函数库支持
begin
  // 由于pascal的字符串不便于书写在程序中，这里我们c风格字符串
  t := TTextParsing.Create('if 1+1=2 then writeln("if was true") else writeln("if was false");', tsC);
  cp := 1;
  ep := 1;
  state := sUnknow;
  ifMatchBody := '';
  ifTrueBody := '';
  ifFalseBody := '';

  // 解析主循环
  while cp < t.Len do
    begin
      // 词法流程范式，这套此范式是以成熟词法解析为主，没有考虑性能，如果需要加速运行脚本，请考虑编译成数据结构存储再以高速方式载入运行
      wasNumber := t.IsNumber(cp);
      wasText := t.IsTextDecl(cp);
      wasAscii := t.IsAscii(cp);
      wasSymbol := t.IsSymbol(cp);

      if wasNumber then
        begin
          ep := t.GetNumberEndPos(cp);
          decl := t.GetStr(cp, ep);
          cp := ep;
          goto gFillStruct;
        end;

      if wasText then
        begin
          ep := t.GetTextDeclEndPos(cp);
          decl := t.GetStr(cp, ep);
          cp := ep;
          goto gFillStruct;
        end;

      if wasAscii then
        begin
          ep := t.GetAsciiEndPos(cp);
          decl := t.GetStr(cp, ep);
          cp := ep;
          goto gFillStruct;
        end;

      if wasSymbol then
        begin
          decl := t.ParsingData.Text[cp];
          inc(cp);
          ep := cp;
          goto gFillStruct;
        end;

      inc(cp);
      continue;
      // 词法流程范式结束，下面我们做结构体判断

    gFillStruct:

      if wasAscii then
        begin
          // 词法结构
          if decl.Same('if') then
            begin
              if state <> sUnknow then
                begin
                  DoStatus('if 格式解析错误');
                  break;
                end;
              state := sIF;
              continue;
            end;

          if decl.Same('then') then
            begin
              if state <> sIF then
                begin
                  DoStatus('then 格式解析错误');
                  break;
                end;
              state := sTrue;
              continue;
            end;

          if decl.Same('else') then
            begin
              if state <> sTrue then
                begin
                  DoStatus('else 书写格式解析错误');
                  break;
                end;
              state := sFalse;
              continue;
            end;
        end;

      case state of
        sIF: ifMatchBody.Append(decl);    // 在TPascalString中，使用Append方法，要比string:=string+string效率更高
        sTrue: ifTrueBody.Append(decl);   // 在TPascalString中，使用Append方法，要比string:=string+string效率更高
        sFalse: ifFalseBody.Append(decl); // 在TPascalString中，使用Append方法，要比string:=string+string效率更高
      end;
    end;

  // 到这一步，整个if结构体就已经解析成功了，我们直接运行程序即可
  if state = sFalse then
    begin
      rt := TOpCustomRunTime.Create;
      rt.RegOp('writeln', function(var Param: TOpParam): Variant
        begin
          Writeln(VarToStr(Param[0]));
          Result := 0;
        end);
      // 如果需要性能，这里的结构体你可以考虑用数据结构来存储，实现快速脚本
      if EvaluateExpressionValue(tsC, ifMatchBody, rt) = True then
          EvaluateExpressionValue(tsC, ifTrueBody, rt)
      else
          EvaluateExpressionValue(tsC, ifFalseBody, rt);
      disposeObject(rt);
    end;

  disposeObject(t);
end;
```

## 将zExpression表达式应用于文本解析器，文本格式可以是HTML,Text,Json,XML

```delphi
var
  rt: TOpCustomRunTime;

  function Macro(var AText: string; const HeadToken, TailToken: string): TPascalString;
  var
    sour      : TPascalString;
    ht, tt    : TPascalString;
    bPos, ePos: Integer;
    KeyText   : SystemString;
    i         : Integer;
    tmpSym    : TSymbolExpression;
    op        : TOpCode;
  begin
    Result := '';
    sour.Text := AText;
    ht.Text := HeadToken;
    tt.Text := TailToken;

    i := 1;

    while i <= sour.Len do
      begin
        if sour.ComparePos(i, @ht) then
          begin
            bPos := i;
            ePos := sour.GetPos(tt, i + ht.Len);
            if ePos > 0 then
              begin
                KeyText := sour.copy(bPos + ht.Len, ePos - (bPos + ht.Len)).Text;

                // 在TPascalString中，使用Append方法，要比string:=string+string效率更高
                Result.Append(VarToStr(EvaluateExpressionValue(KeyText, rt)));
                i := ePos + tt.Len;
                continue;
              end;
          end;

        // 在TPascalString中，使用Append方法，要比string:=string+string效率更高
        Result.Append(sour[i]);
        inc(i);
      end;
  end;

var
  n: string;
  i: Integer;
  t: TTimeTick;
begin
  DoStatus('简单演示用脚本来封装zExpression');
  // rt为ze的运行函数支持库
  rt := TOpCustomRunTime.Create;
  rt.RegOp('OverFunction', function(var Param: TOpParam): Variant
    begin
      Result := '谢谢';
    end);

  // 我们这里使用宏处理将1+1以表达式来翻译
  n := '这是1+1=<begin>1+1<end>，这是一个UInt48位整形:<begin>1<<48<end>，结束 <begin>OverFunction<end>';

  DoStatus('原型:' + n);
  DoStatus('计算结果' + Macro(n, '<begin>', '<end>').Text);

  DoStatus('zExpression正在测试性能，对上列原型做100万次处理');

  t := GetTimeTick;

  // 重复做100万次句法表达式解析和处理
  for i := 1 to 100 * 10000 do
      Macro(n, '<begin>', '<end>');

  DoStatus('zExpression性能测试完成，耗时:%dms', [GetTimeTick - t]);

  disposeObject([rt]);
end;
```



## 关于作者


请不要直接联系作者


使用zExpression有疑问请加qq群490269542，


## 更新日志

2018-2-25

修复嵌套函数参数不能正确展开接口的问题

修复解析引擎的数字探头不能识别16进制自然数和函数问题

新增一个赋值的demo范例，包含变量申明，静态复用，动态复用，总共三部曲，请在范例演示中自行研究

修复字符串和数字匹配联合的问题

支持c代码风格0x16进制语法


2018-2-6

重写了一次解析器内核，支持函数调用，从现在起，zExpression会不断更新



首发代码创建 于2004年 

最后更新于2014年 可以兼容fpc编译器和最新的delphi xe，包括ios,osx,android,linux,win32


有问题请来信
by600585 qq邮箱
