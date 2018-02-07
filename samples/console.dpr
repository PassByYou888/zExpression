program console;

{$APPTYPE CONSOLE}

{
  zExpression已经经过严格测试，稳定，安全，能全面侦错和缩进处理
  如果结合TTextParsing引擎，能将zExpression轻松封装成你自己的脚本引擎（你只需要定义好脚本的语法结构即可）
  此Demo的书写范式可以放在手机和fpc所支持的各平台去运行
  
  编译此Demo请将系统的搜索路径设置到库目录
}

uses
  System.SysUtils,
  Variants,
  CoreClasses in '..\lib\CoreClasses.pas',
  CoreCompress in '..\lib\CoreCompress.pas',
  DataFrameEngine in '..\lib\DataFrameEngine.pas',
  DoStatusIO in '..\lib\DoStatusIO.pas',
  Fast_MD5 in '..\lib\Fast_MD5.pas',
  Geometry2DUnit in '..\lib\Geometry2DUnit.pas',
  Geometry3DUnit in '..\lib\Geometry3DUnit.pas',
  GeometryLib in '..\lib\GeometryLib.pas',
  JsonDataObjects in '..\lib\JsonDataObjects.pas',
  ListEngine in '..\lib\ListEngine.pas',
  MemoryStream64 in '..\lib\MemoryStream64.pas',
  opCode in '..\lib\opCode.pas',
  PascalStrings in '..\lib\PascalStrings.pas',
  TextDataEngine in '..\lib\TextDataEngine.pas',
  TextParsing in '..\lib\TextParsing.pas',
  UnicodeMixedLib in '..\lib\UnicodeMixedLib.pas',
  zExpression in '..\lib\zExpression.pas';

// 基本使用
procedure Demo1;
var
  rt: TOpCustomRunTime;
  v : Variant;
begin
  DoStatus('基本使用demo');
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

// 高速载入与执行
procedure Demo2;
var
  tmpSym: TSymbolExpression;
  op    : TOpCode;
  rt    : TOpCustomRunTime;
  m64   : TMemoryStream64;
begin
  DoStatus('高速载入与执行demo');
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

// 高级demo，脚本语法，脚本词法引擎演示，将zExpression表达式应用于if结构
// 正规词法流程程序范例，没有减懒，参照下列流程编写自己的脚本解析流程是地球级的，不会有人异议这套范式
procedure Demo3;
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
  t := TTextParsing.Create('if 1+1=/* comment */2 then writeln/* comment */("if was true") else/*  comment */writeln("if was false");', tsC);
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
      if t.IsComment(cp) then
        begin
          ep := t.GetCommentEndPos(cp);
          cp := ep;
          continue;
        end;

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

// 高级Demo，将zExpression表达式应用于文本解析器
procedure Demo4;
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
            ePos := sour.GetPos(@tt, i + ht.Len);
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

var
  sym1: TSymbolExpression;
  op  : TOpCode;

begin
  try
    { TODOoUsercConsole Main : Insert code here }

    // 预处理一二三步以后输出opCode 并且运行opCode 最后返回一个值
    // 该函数会消耗一定的硬件资源，高效运行建议一次性BuildAsOpCode，然后再用SaveToStream将opcode以二进制方式保存，使用时用LoadOpFromStream载入
    DoStatus('Value:' + VarToStr(EvaluateExpressionValue('(1+1*2/3.14)')));
    DoStatus('');

    // 核心函数：将文本表达式解析成符号表达式
    // 核心思路：采用双原子化处理，以蚂蚁化推进法处理字符和符号，这里有两个原子点 其中 符号在前 字符在后 是一种情况，这是其中的原子1，第二种情况是字符在前，而符号再后，这是第二种原子2，两种情况相辅相成
    // 此函数复杂度偏高，遵循理论+学术所编写，无递归元素，且高效解析
    // zExpression 运行步骤的第一步就是得到一套符号表达，从而为下一步逻辑处理做出简化准备
    // TextEngClass 可以选择普通文本引擎，pascal文本引擎，c/c++文本引擎，它主要影响的是字符串的表达式，c的表示以"表示字符串，pascal表达式以'表示字符串
    // uName 是为上层编译器准备的，单元说明，类似unit name; include name; 编译时可以知道哪个原文件，便于编译预处理时查错和报错
    // ExpressionText 是表达式的文本内容
    // OnGetValue 在申明了常量和函数时，常量的值以此事件获取
    // 返回：符号表达式的TSymbolExpression类
    sym1 := ParseTextExpressionAsSymbol(TTextParsing, '', '(1+1*2/3.14)', nil, DefaultOpRT);
    // sym1.PrintDebug(True);

    // zExpression 的核心逻辑第三步，在符号缩进预处理完成以后，重新拆开表达式数据结构，并且重建一个带有缩进的严谨TSymbolExpression的缩进顺序，该步骤带侦错功能
    // RebuildAllSymbol可以直接处理完成第二步和第三步
    // sym2 := RebuildAllSymbol(sym1);
    // sym2.PrintDebug(True);

    // zExpression 的核心逻辑第四步，根据RebuildAllSymbol后的严谨TSymbolExpression符号顺序，创建单步原子化执行
    // BuildAsOpCode会自动对第二和第三步进行缩进和优化处理
    // 单步原子化执行的实现请参考opCode内容
    op := BuildAsOpCode(True, sym1);
    if op <> nil then
      begin
        DoStatus('Value:' + VarToStr(op.Execute));
        DoStatus('');
        FreeObject(op);
      end;

    FreeObject([sym1]);

    Demo1;
    Demo2;
    Demo3;
    Demo4;

    readln;
  except
    on E: Exception do
        Writeln(E.ClassName, ': ', E.Message);
  end;

end.
