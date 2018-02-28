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

֧���Զ���ű��﷨

�沨��2.0�������ȼ�����

֧�ְ�׿��ƻ�����ͺ��ֻ�

�����Ĺ���Demo���������ܺͽ���׼ȷ���������

�ڱ����Ժ����γ�ԭ�ӻ�op���룬����ͨ��stream�������벢���У�������cpu����

OP�����ܿ������������ARMv7 ARMx64 x64 x86��ƽ̨�Ļ�����


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


## �Լ�ʵ��IF�ṹ�壬����ze�Դ��Ĵʷ�����TTextParsing�����ű��ͱ������е�IF�ṹ���ڲ�����

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

## �����������Լ��Ľű�����ʱ����ʱ����Ҫ���������ַ�

```delphi
// ������ź���
procedure SpecialFuncDemo;
var
  rt: TOpCustomRunTime;
  v : Variant;
begin
  DoStatus('ȫ�ֵĴʷ�̽ͷǰ׺������ʹ��');

  // ȫ�ֵ��������̽ͷ��ǰ��׺���� ����ǰ׺��@@����,����Ϊascii������
  SpecialAsciiToken.Clear;
  SpecialAsciiToken.Add('@@');
  SpecialAsciiToken.Add('&&');

  // rtΪze�����к���֧�ֿ�
  rt := TOpCustomRunTime.Create;
  rt.RegOp('@@a&&', function(var Param: TOpParam): Variant
    // (a+b)*0.5
    begin
      Result := (Param[0] + Param[1]) * 0.5;
    end);
  rt.RegOp('@@combineString&&', function(var Param: TOpParam): Variant
    // (a+b)*0.5
    begin
      Result := VarToStr(Param[0]) + VarToStr(Param[1]);
    end);

  // ����@@ǰ׺��asciiҲ�����ں�׺����������ţ�������ų��Ȳ�����
  v := EvaluateExpressionValue(False, '{ ��ע } @@a&&(1,2)', rt);
  DoStatus(VarToStr(v));

  // ���ַ������ʽ��ze��Ĭ���ı������ʽΪPascal
  v := EvaluateExpressionValue(False, '@@combineString&&('#39'abc'#39', '#39'123'#39')', rt);
  DoStatus(VarToStr(v));

  // ���ַ������ʽ������ʹ��c���ı���ʽ
  v := EvaluateExpressionValue(tsC, '@@combineString&&("abc", "123")', rt);
  DoStatus(VarToStr(v));
  v := EvaluateExpressionValue(tsC, '@@combineString&&('#39'abc'#39', '#39'123'#39')', rt);
  DoStatus(VarToStr(v));

  disposeObject(rt);

  // ��ԭȫ�ֵ��������̽ͷ��ǰ��׺����
  SpecialAsciiToken.Clear;
end;
```

## ��zExpression���ʽӦ�����ı����������ı���ʽ������HTML,Text,Json,XML

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
```

## ����TTextParsing��zExpressionʵ�ֶԽű�������ڲ�������ֵ

```delphi
procedure Demo5;
var
  sourTp, t          : TTextParsing;       // �ʷ���������
  setBefore, setAfter: TPascalString;      // ��ֵ��ǰ���������͸�ֵ�ĺ�������
  splitVarDecl       : TArrayPascalString; // �п��ı��ʽ��
  myvars             : TArrayPascalString; // ������Ҫ��ֵ����ʱ�������Զ��ŷָ�
  WasAssignment      : Boolean;            // �ڱ��ʽ���ҵ��˸�ֵ
  HashVars           : THashVariantList;   // ������hash�洢�ṹ�����ǿ��Դ�ŵ�Ӳ���е�
  rt                 : TOpCustomRunTime;   // ���к�����֧��
  op                 : TOpCode;            // ����������cache��op����
  i                  : Integer;            // forʹ��
  dynvar             : Integer;            // ��̬����
begin
  // ������c��pascal����д���������޸ı�ע����
  sourTp := TTextParsing.Create('myvar1/*�����Ǳ�ע*/,myvar2,myvar3 = 123+456+" ����: "+dynamic', tsC, nil); // �ʷ��������棬��c�﷨Ϊ��
  // sourTp := TTextParsing.Create('myvar1(*�����Ǳ�ע*),myvar2,myvar3 := 123+456+'#39' ����: '#39'+dynamic', tsPascal); // �ʷ��������棬��c�﷨Ϊ��
  // sourTp := TTextParsing.Create('123+456+dynamic', tsPascal); // �ʷ��������棬��c�﷨Ϊ��

  HashVars := THashVariantList.Create(16); // 16��hash��buff���ȣ���ֵԽ����ٶ�Խ��

  SetLength(splitVarDecl, 0);
  SetLength(myvars, 0);

  // ��һ����������ֵ����
  case sourTp.TextStyle of
    tsPascal:
      begin
        // pascal�ĸ�ֵ����Ϊ :=
        WasAssignment := sourTp.SplitString(1, ':=', ';', splitVarDecl) = 2; // ���ַ�����Ϊ�и�Ǻţ��Դ���:=�Ǻŵ��ַ��������и�
        if WasAssignment then
          begin
            setBefore := splitVarDecl[0];
            setAfter := splitVarDecl[1];

            t := TTextParsing.Create(setBefore, tsPascal, nil);
            t.DeletedComment;
            if t.SplitChar(1, ',', ';', myvars) = 0 then // ���ﲻ���ַ����������ַ���Ϊ�и�Ǻţ��Դ���,���ַ������и�
                DoStatus('������ֵ�﷨���� %s', [setBefore.Text]);
            disposeObject(t);
          end;
      end;
    tsC:
      begin
        // c�ĸ�ֵ����Ϊ =
        WasAssignment := sourTp.SplitChar(1, '=', ';', splitVarDecl) = 2; // ���ﲻ���ַ����������ַ���Ϊ�и�Ǻţ��Դ���=���ַ������и�
        if WasAssignment then
          begin
            setBefore := splitVarDecl[0];
            setAfter := splitVarDecl[1];

            t := TTextParsing.Create(setBefore, tsC, nil);
            t.DeletedComment;
            if t.SplitChar(1, ',', ';', myvars) = 0 then // ���ﲻ���ַ����������ַ���Ϊ�и�Ǻţ��Դ���,���ַ������и�
                DoStatus('������ֵ�﷨���� %s', [setBefore.Text]);
            disposeObject(t);
          end;
      end;
    else
      begin
        DoStatus('��֧�ֱ��ʽ');
        WasAssignment := False;
      end;
  end;

  rt := TOpCustomRunTime.Create;
  rt.RegOp('dynamic', function(var Param: TOpParam): Variant
    begin
      Result := dynvar;
      inc(dynvar);
    end);
  rt.RegOp('myvar1', function(var Param: TOpParam): Variant
    begin
      // ��myvar1���ж�̬����
      Result := HashVars['myvar1'];
    end);

  dynvar := 1;

  // �ڶ���������ҵ��˸�ֵ����
  if WasAssignment then
    begin
      DoStatus('�����˱�����ֵ���ʽ');

      op := BuildAsOpCode(sourTp.TextStyle, setAfter, rt);

      for i := low(myvars) to high(myvars) do
          HashVars[myvars[i].TrimChar(#32).Text] := op.Execute(rt); // ��һ����β�ո�ü���ִ��op�����������ĸ�ֵ

      DoStatus('������ֵ����');
      DoStatus(HashVars.AsText);

      // ���������ñ����ڱ��ʽ�еĸ���
      DoStatus('���ڣ����ǿ�ʼ��̬�������Ǹղ������ı�������̬�����ǽ�������const��ʽ���б���');

      // ����opCache�������Զ������еģ��������κ�ʱ����const���ñ���ʱ��Ҫ�����
      OpCache.Clear;

      DoStatus(VarToStr(EvaluateExpressionValue_P(TTextParsing, tsC, '"��̬���� "+myvar1',
        procedure(DeclName: SystemString; var ValType: TExpressionDeclType; var Value: Variant)
        begin
          if HashVars.Exists(DeclName) then
            begin
              Value := HashVars[DeclName];
              ValType := TExpressionDeclType.edtString; // ������Ҫ���߱��������ñ���������
            end;
        end)));

      DoStatus(VarToStr(EvaluateExpressionValue_P(TTextParsing, tsC, '"��̬���� "+myvar4',
        procedure(DeclName: SystemString; var ValType: TExpressionDeclType; var Value: Variant)
        begin
          // myvar4�ǲ����ڵ�
          // Ȼ�� ������myvar2������
          Value := HashVars['myvar2'];
          ValType := TExpressionDeclType.edtString; // ������Ҫ���߱��������ñ���������
        end)));

      DoStatus('���ڣ����ǿ�ʼ��̬�������Ǹղ������ı���');
      DoStatus(VarToStr(EvaluateExpressionValue(tsC, '"��̬���� "+myvar1', rt)));

      HashVars['myvar1'] := 'abc';
      DoStatus(VarToStr(EvaluateExpressionValue(tsC, '"��̬���� "+myvar1', rt)));
    end
  else
    begin
      DoStatus('û�з����˱�����ֵ');
      DoStatus('���ʽ "%s"' + #13#10 + '���н�� %s', [sourTp.TextData.Text, VarToStr(EvaluateExpressionValue(sourTp.TextStyle, sourTp.TextData, rt))]);
    end;

  disposeObject([sourTp, HashVars, rt]);
end;
```



## ��������


�벻Ҫֱ����ϵ����


ʹ��zExpression���������qqȺ490269542��


## ������־

2018-2-28

�޸�cת���ַ�buf����л��ľqq345148965

��charPos�Ĳ����������ĳ���cOffset�����Ҽ���const���η�


2018-2-26

�޸�ʹ��Releaseģʽ�޷���������

�޸�zExpression���и�ֶβ���ȷ����

С�������ַ�̽ͷ���и�����(splitToken,splitChar)

��Ϊ�ײ���д��һ��ԭ�������ںܶ�record����ǰ������packed���η�


2018-2-25

�����Զ�����ʽ����֧��

�����Զ�����ʽ���ŵ���ʾ


2018-2-25

�޸�Ƕ�׺�������������ȷչ���ӿڵ�����

�޸��������������̽ͷ����ʶ��16������Ȼ���ͺ�������

����һ����ֵ��demo����������������������̬���ã���̬���ã��ܹ������������ڷ�����ʾ�������о�

�޸��ַ���������ƥ�����ϵ�����

֧��c������0x16�����﷨


2018-2-6

��д��һ�ν������ںˣ�֧�ֺ������ã���������zExpression�᲻�ϸ���



�׷����봴�� ��2004�� 

��������2014�� ���Լ���fpc�����������µ�delphi xe������ios,osx,android,linux,win32


������������
by600585 qq����
