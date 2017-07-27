program zExpDemo;

{$APPTYPE CONSOLE}

{$R *.res}


uses
  System.SysUtils,
  Variants,
  zExpression in '..\..\zExpression.pas',
  Geometry2DUnit in '..\..\lib\Geometry2DUnit.pas',
  CoreClasses in '..\..\lib\CoreClasses.pas',
  ListEngine in '..\..\lib\ListEngine.pas',
  Geometry3DUnit in '..\..\lib\Geometry3DUnit.pas',
  UnicodeMixedLib in '..\..\lib\UnicodeMixedLib.pas',
  PascalStrings in '..\..\lib\PascalStrings.pas',
  DataFrameEngine in '..\..\lib\DataFrameEngine.pas',
  DoStatusIO in '..\..\lib\DoStatusIO.pas',
  TextDataEngine in '..\..\lib\TextDataEngine.pas',
  GeometryLib in '..\..\lib\GeometryLib.pas',
  MemoryStream64 in '..\..\lib\MemoryStream64.pas',
  TextParsing in '..\..\lib\TextParsing.pas',
  opCode in '..\..\opCode.pas';

var
  sym1, sym2: TSymbolExpression;
  op        : TOpCode;

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }

    // 预处理一二三步以后输出opCode 并且运行opCode 最后返回一个值
    // 该函数会消耗一定的硬件资源，高效运行建议一次性BuildAsOpCode，然后再用SaveToStream将opcode以二进制方式保存，使用时用LoadOpFromStream载入
    DoStatus('Value:' + VarToStr(EvaluateExpressionValue(TTextParsing, '(1+1)*2/3.14', nil)));
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
    sym1 := ParseTextExpressionAsSymbol(TTextParsing, '', '(1+1)*2/3.14', nil);
    sym1.PrintDebug(True);

    // zExpression 的核心逻辑第三步，在符号缩进预处理完成以后，重新拆开表达式数据结构，并且重建一个带有缩进的严谨TSymbolExpression的缩进顺序，该步骤带侦错功能
    // RebuildAllSymbol可以直接处理完成第二步和第三步
    sym2 := RebuildAllSymbol(sym1);
    sym2.PrintDebug(True);

    // zExpression 的核心逻辑第四步，根据RebuildAllSymbol后的严谨TSymbolExpression符号顺序，创建单步原子化执行
    // 单步原子化执行的实现请参考opCode内容
    op := BuildAsOpCode(sym2, '', 0);
    if op <> nil then
      begin
        DoStatus('Value:' + VarToStr(op.Execute));
        DoStatus('');
        FreeObject(op);
      end;

    FreeObject([sym1, sym2]);

    readln;
  except
    on E: Exception do
        Writeln(E.ClassName, ': ', E.Message);
  end;

end.
