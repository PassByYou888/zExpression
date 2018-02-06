## zExpression �䷨������+���������ű������ں�


## ������ϵ���ͣ�
�ڱ���ԭ��ļ�����ϵ�У����Ǵ����ı����Ĵ���ǰ������Ҫ��һ��Ԥ�����������ǳ�˵���﷨���﷨�ǣ�����һ��Ԥ�������

�ʷ����ʷ��Ƕ��ı��ؼ��֣����֣����ţ����з�����������γɴʷ����������ϸ���ѭ˳�򻯴���ԭ��

��������Ԥ��������У��������֣��������������������������ڴʷ�˳��Ԥ������Ϊ�Դʷ�Ԥ������һ�ּ��ֶ�

�䷨���ھ���������Ԥ�����Ժ��ǶԴ�����ʽ�ĵ����߼��������д�����һ���о䷨��ȡΪzExpression�䷨���������Ҵ�����׫д�ı������������������Ľ�������������Զ��������ַ���ʹ�ã�����ʵ�����ֻ�Ԥ����ͼ��ͼ�񣬿�ѧ����ȵ�����Ҳ������Ϊѧϰ����Լ����ֶ�


## ����˼·

ʵ��zExpression���õ��ǶԵȸ��ӻ�ԭ���������������������д�����Ӷ�����ڳ����������࣬��Ϊ������������⣬�����������Ͷѽṹ��Ҳ������©�����������ǳ���䷨����������

## zExpression�ص�

�����ĵ���ԭ�ӻ�����

�����ķ������ȼ�����

��Ԥ����������󣬲���������������

��ʶ�𸡵����������Ȼ��д��

֧�ֺ�������

֧���Զ���ű��﷨��

�沨��2.0�������ȼ�����

�Դ�ʹ��Demo

�ڱ����Ժ����γ�ԭ�ӻ�op���룬����ͨ��stream�������벢���У�������cpu���ͣ����Լ����ֻ�����

OP����������������ARMv7 ARMx64 x64 x86��ƽ̨�Ļ�����


## �����÷���ʾ

```Delphi
var
  rt: TOpCustomRunTime;
  v : Variant;
begin
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

```

## ���ڶ�����Stream�ĸ��ٶ�ȡ��ִ��

```delphi
var
  tmpSym: TSymbolExpression;
  op    : TOpCode;
  rt    : TOpCustomRunTime;
  m64   : TMemoryStream64;
begin
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
```

## ʵ��if�ṹ��
```delphi
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
  t := TTextParsing.Create('if 1+1=2 then writeln("if was true") else writeln("if was false");', tsC);
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
```



## ������־

�׷����봴�� ��2004�� ������qq600585

��������2014�� ���Լ���fpc�����������µ�delphi xe������ios,osx,android,linux,win32


������������
by600585 qq����
