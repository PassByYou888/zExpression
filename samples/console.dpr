program console;

{$APPTYPE CONSOLE}

{
  zExpression�Ѿ������ϸ���ԣ��ȶ�����ȫ����ȫ��������������
  ������TTextParsing���棬�ܽ�zExpression���ɷ�װ�����Լ��Ľű����棨��ֻ��Ҫ����ýű����﷨�ṹ���ɣ�
  ��Demo����д��ʽ���Է����ֻ���fpc��֧�ֵĸ�ƽ̨ȥ����
  
  �����Demo�뽫ϵͳ������·�����õ���Ŀ¼
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

// ����ʹ��
procedure Demo1;
var
  rt: TOpCustomRunTime;
  v : Variant;
begin
  DoStatus('����ʹ��demo');
  // rtΪze�����к���֧�ֿ�
  rt := TOpCustomRunTime.Create;
  rt.RegOp('myAddFunction', function(var Param: TOpParam): Variant
    // (a+b)*0.5
    begin
      Result := (Param[0] + Param[1]) * 0.5;
    end);
  rt.RegOp('myStringFunction', function(var Param: TOpParam): Variant
    begin
      Result := Format('�ַ�������Ϊ:%d', [Length(VarToStr(Param[0]) + VarToStr(Param[1]))]);
    end);

  // ����ѧ���ʽ
  v := EvaluateExpressionValue(False, '1000+{ �����Ǳ�ע ze����ʶ��pascal��c�ı�ע�Լ��ַ���д�� } myAddFunction(1+1/2*3/3.14*9999, 599+2+2*100 shl 3)', rt);
  DoStatus(VarToStr(v));

  // ���ַ������ʽ��ze��Ĭ���ı������ʽΪPascal
  v := EvaluateExpressionValue(False, 'myStringFunction('#39'abc'#39', '#39'123'#39')', rt);
  DoStatus(VarToStr(v));

  // ���ַ������ʽ������ʹ��c���ı���ʽ
  v := EvaluateExpressionValue(tsC, 'myStringFunction("abc", "123")', rt);
  DoStatus(VarToStr(v));

  disposeObject(rt);
end;

// ����������ִ��
procedure Demo2;
var
  tmpSym: TSymbolExpression;
  op    : TOpCode;
  rt    : TOpCustomRunTime;
  m64   : TMemoryStream64;
begin
  DoStatus('����������ִ��demo');
  // rtΪze�����к���֧�ֿ�
  rt := TOpCustomRunTime.Create;
  rt.RegOp('myAddFunction', function(var Param: TOpParam): Variant
    // (a+b)*0.5
    begin
      Result := (Param[0] + Param[1]) * 0.5;
    end);
  rt.RegOp('myStringFunction', function(var Param: TOpParam): Variant
    begin
      Result := Format('�ַ�������Ϊ:%d', [Length(VarToStr(Param[0]) + VarToStr(Param[1]))]);
    end);

  // ʹ��ParseTextExpressionAsSymbol�����������ʽ����ɴʷ���
  tmpSym := ParseTextExpressionAsSymbol(TTextParsing, '', '1000+myAddFunction(1+1/2*3/3.14*9999, 599+2+2*100 shl 3)', nil, rt);
  // BuildAsOpCode�Ὣ�ʷ����ٴη�����﷨����Ȼ���ٻ����﷨������op����
  op := BuildAsOpCode(tmpSym);
  disposeObject(tmpSym);
  // ����ִ��һ��op
  DoStatus('op���з���ֵ(��ȷֵΪ4489.2962): %s', [VarToStr(op.Execute(rt))]);

  m64 := TMemoryStream64.Create;
  op.SaveToStream(m64);

  // �����Ѿ��ͷ���op
  disposeObject(op);

  // ��stream���ٶ�ȡop�������������
  m64.Position := 0;
  if LoadOpFromStream(True, m64, op) then
    begin
      DoStatus('op���з���ֵ(��ȷֵΪ4489.2962): %s', [VarToStr(op.Execute(rt))]);
    end;

  disposeObject([op, rt, m64]);

  DoStatus('����������ִ��demo���������');
end;

// �߼�demo���ű��﷨���ű��ʷ�������ʾ����zExpression���ʽӦ����if�ṹ
// ����ʷ����̳�������û�м����������������̱�д�Լ��Ľű����������ǵ��򼶵ģ����������������׷�ʽ
procedure Demo3;
type
  TState = (sUnknow, sIF, sTrue, sFalse); // �����õļ�״̬��
label gFillStruct;
var
  t                                      : TTextParsing;     // �ʷ���������
  cp, ep                                 : Integer;          // ������
  wasNumber, wasText, wasAscii, wasSymbol: Boolean;          // �����ı�״̬��
  state                                  : TState;           // �����ṹ״̬��
  decl                                   : TPascalString;    // ��ǰ�����ʷ��壬����
  ifMatchBody                            : TPascalString;    // ���������ж�������
  ifTrueBody                             : TPascalString;    // ��������������
  ifFalseBody                            : TPascalString;    // ����������������
  rt                                     : TOpCustomRunTime; // ���к�����֧��
begin
  // ����pascal���ַ�����������д�ڳ����У���������c����ַ���
  t := TTextParsing.Create('if 1+1=/* comment */2 then writeln/* comment */("if was true") else/*  comment */writeln("if was false");', tsC);
  cp := 1;
  ep := 1;
  state := sUnknow;
  ifMatchBody := '';
  ifTrueBody := '';
  ifFalseBody := '';

  // ������ѭ��
  while cp < t.Len do
    begin
      // �ʷ����̷�ʽ�����״˷�ʽ���Գ���ʷ�����Ϊ����û�п������ܣ������Ҫ�������нű����뿼�Ǳ�������ݽṹ�洢���Ը��ٷ�ʽ��������
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
      // �ʷ����̷�ʽ�����������������ṹ���ж�

    gFillStruct:

      if wasAscii then
        begin
          // �ʷ��ṹ
          if decl.Same('if') then
            begin
              if state <> sUnknow then
                begin
                  DoStatus('if ��ʽ��������');
                  break;
                end;
              state := sIF;
              continue;
            end;

          if decl.Same('then') then
            begin
              if state <> sIF then
                begin
                  DoStatus('then ��ʽ��������');
                  break;
                end;
              state := sTrue;
              continue;
            end;

          if decl.Same('else') then
            begin
              if state <> sTrue then
                begin
                  DoStatus('else ��д��ʽ��������');
                  break;
                end;
              state := sFalse;
              continue;
            end;
        end;

      case state of
        sIF: ifMatchBody.Append(decl);    // ��TPascalString�У�ʹ��Append������Ҫ��string:=string+stringЧ�ʸ���
        sTrue: ifTrueBody.Append(decl);   // ��TPascalString�У�ʹ��Append������Ҫ��string:=string+stringЧ�ʸ���
        sFalse: ifFalseBody.Append(decl); // ��TPascalString�У�ʹ��Append������Ҫ��string:=string+stringЧ�ʸ���
      end;
    end;

  // ����һ��������if�ṹ����Ѿ������ɹ��ˣ�����ֱ�����г��򼴿�
  if state = sFalse then
    begin
      rt := TOpCustomRunTime.Create;
      rt.RegOp('writeln', function(var Param: TOpParam): Variant
        begin
          Writeln(VarToStr(Param[0]));
          Result := 0;
        end);
      // �����Ҫ���ܣ�����Ľṹ������Կ��������ݽṹ���洢��ʵ�ֿ��ٽű�
      if EvaluateExpressionValue(tsC, ifMatchBody, rt) = True then
          EvaluateExpressionValue(tsC, ifTrueBody, rt)
      else
          EvaluateExpressionValue(tsC, ifFalseBody, rt);
      disposeObject(rt);
    end;

  disposeObject(t);
end;

// �߼�Demo����zExpression���ʽӦ�����ı�������
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

                // ��TPascalString�У�ʹ��Append������Ҫ��string:=string+stringЧ�ʸ���
                Result.Append(VarToStr(EvaluateExpressionValue(KeyText, rt)));
                i := ePos + tt.Len;
                continue;
              end;
          end;

        // ��TPascalString�У�ʹ��Append������Ҫ��string:=string+stringЧ�ʸ���
        Result.Append(sour[i]);
        inc(i);
      end;
  end;

var
  n: string;
  i: Integer;
  t: TTimeTick;
begin
  DoStatus('����ʾ�ýű�����װzExpression');
  // rtΪze�����к���֧�ֿ�
  rt := TOpCustomRunTime.Create;
  rt.RegOp('OverFunction', function(var Param: TOpParam): Variant
    begin
      Result := 'лл';
    end);

  // ��������ʹ�ú괦��1+1�Ա��ʽ������
  n := '����1+1=<begin>1+1<end>������һ��UInt48λ����:<begin>1<<48<end>������ <begin>OverFunction<end>';

  DoStatus('ԭ��:' + n);
  DoStatus('������' + Macro(n, '<begin>', '<end>').Text);

  DoStatus('zExpression���ڲ������ܣ�������ԭ����100��δ���');

  t := GetTimeTick;

  // �ظ���100��ξ䷨���ʽ�����ʹ���
  for i := 1 to 100 * 10000 do
      Macro(n, '<begin>', '<end>');

  DoStatus('zExpression���ܲ�����ɣ���ʱ:%dms', [GetTimeTick - t]);

  disposeObject([rt]);
end;

var
  sym1: TSymbolExpression;
  op  : TOpCode;

begin
  try
    { TODOoUsercConsole Main : Insert code here }

    // Ԥ����һ�������Ժ����opCode ��������opCode ��󷵻�һ��ֵ
    // �ú���������һ����Ӳ����Դ����Ч���н���һ����BuildAsOpCode��Ȼ������SaveToStream��opcode�Զ����Ʒ�ʽ���棬ʹ��ʱ��LoadOpFromStream����
    DoStatus('Value:' + VarToStr(EvaluateExpressionValue('(1+1*2/3.14)')));
    DoStatus('');

    // ���ĺ��������ı����ʽ�����ɷ��ű��ʽ
    // ����˼·������˫ԭ�ӻ����������ϻ��ƽ��������ַ��ͷ��ţ�����������ԭ�ӵ� ���� ������ǰ �ַ��ں� ��һ��������������е�ԭ��1���ڶ���������ַ���ǰ���������ٺ����ǵڶ���ԭ��2����������ศ���
    // �˺������Ӷ�ƫ�ߣ���ѭ����+ѧ������д���޵ݹ�Ԫ�أ��Ҹ�Ч����
    // zExpression ���в���ĵ�һ�����ǵõ�һ�׷��ű��Ӷ�Ϊ��һ���߼�����������׼��
    // TextEngClass ����ѡ����ͨ�ı����棬pascal�ı����棬c/c++�ı����棬����ҪӰ������ַ����ı��ʽ��c�ı�ʾ��"��ʾ�ַ�����pascal���ʽ��'��ʾ�ַ���
    // uName ��Ϊ�ϲ������׼���ģ���Ԫ˵��������unit name; include name; ����ʱ����֪���ĸ�ԭ�ļ������ڱ���Ԥ����ʱ���ͱ���
    // ExpressionText �Ǳ��ʽ���ı�����
    // OnGetValue �������˳����ͺ���ʱ��������ֵ�Դ��¼���ȡ
    // ���أ����ű��ʽ��TSymbolExpression��
    sym1 := ParseTextExpressionAsSymbol(TTextParsing, '', '(1+1*2/3.14)', nil, DefaultOpRT);
    // sym1.PrintDebug(True);

    // zExpression �ĺ����߼����������ڷ�������Ԥ��������Ժ����²𿪱��ʽ���ݽṹ�������ؽ�һ�������������Ͻ�TSymbolExpression������˳�򣬸ò���������
    // RebuildAllSymbol����ֱ�Ӵ�����ɵڶ����͵�����
    // sym2 := RebuildAllSymbol(sym1);
    // sym2.PrintDebug(True);

    // zExpression �ĺ����߼����Ĳ�������RebuildAllSymbol����Ͻ�TSymbolExpression����˳�򣬴�������ԭ�ӻ�ִ��
    // BuildAsOpCode���Զ��Եڶ��͵����������������Ż�����
    // ����ԭ�ӻ�ִ�е�ʵ����ο�opCode����
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
