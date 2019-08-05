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
  CoreClasses,
  CoreCompress,
  DataFrameEngine,
  DoStatusIO,
  opCode,
  ListEngine,
  MemoryStream64,
  PascalStrings,
  TextParsing,
  UnicodeMixedLib,
  zExpression;

// ������ź���
procedure SpecialFuncDemo;
var
  SpecialAsciiToken: TPascalStringList;
  RT: TOpCustomRunTime;
  v: Variant;
begin
  DoStatus('ȫ�ֵĴʷ�̽ͷǰ׺������ʹ��');

  // ����ǰ׺��@@����,����Ϊascii������
  SpecialAsciiToken := TPascalStringList.Create;
  SpecialAsciiToken.Add('@@');
  SpecialAsciiToken.Add('&&');

  // rtΪze�����к���֧�ֿ�
  RT := TOpCustomRunTime.Create;
  RT.RegOpP('@@a&&', function(var Param: TOpParam): Variant
    // (a+b)*0.5
    begin
      Result := (Param[0] + Param[1]) * 0.5;
    end);
  RT.RegOpP('@@combineString&&', function(var Param: TOpParam): Variant
    // (a+b)*0.5
    begin
      Result := VarToStr(Param[0]) + VarToStr(Param[1]);
    end);

  // ����@@ǰ׺��asciiҲ�����ں�׺����������ţ�������ų��Ȳ�����
  v := EvaluateExpressionValue(SpecialAsciiToken, False, '{ ��ע } @@a&&(1,2)', RT);
  DoStatus(VarToStr(v));

  // ���ַ������ʽ��ze��Ĭ���ı������ʽΪPascal
  v := EvaluateExpressionValue(SpecialAsciiToken, False, '@@combineString&&('#39'abc'#39', '#39'123'#39')', RT);
  DoStatus(VarToStr(v));

  // ���ַ������ʽ������ʹ��c���ı���ʽ
  v := EvaluateExpressionValue(SpecialAsciiToken, tsC, '@@combineString&&("abc", "123")', RT);
  DoStatus(VarToStr(v));
  v := EvaluateExpressionValue(SpecialAsciiToken, tsC, '@@combineString&&('#39'abc'#39', '#39'123'#39')', RT);
  DoStatus(VarToStr(v));

  DisposeObject(RT);

  DisposeObject(SpecialAsciiToken);
end;

// ����ʹ��
procedure Demo1;
var
  RT: TOpCustomRunTime;
  v: Variant;
begin
  DoStatus('����ʹ��demo');
  // rtΪze�����к���֧�ֿ�
  RT := TOpCustomRunTime.Create;
  RT.RegOpP('myAddFunction', function(var Param: TOpParam): Variant
    // (a+b)*0.5
    begin
      Result := (Param[0] + Param[1]) * 0.5;
    end);
  RT.RegOpP('myStringFunction', function(var Param: TOpParam): Variant
    begin
      Result := Format('�ַ�������Ϊ:%d', [length(VarToStr(Param[0]) + VarToStr(Param[1]))]);
    end);

  // ����ѧ���ʽ
  v := EvaluateExpressionValue(False, '1000+{ �����Ǳ�ע ze����ʶ��pascal��c�ı�ע�Լ��ַ���д�� } myAddFunction(1+1/2*3/3.14*9999, 599+2+2*100 shl 3)', RT);
  DoStatus(VarToStr(v));

  // ���ַ������ʽ��ze��Ĭ���ı������ʽΪPascal
  v := EvaluateExpressionValue(False, 'myStringFunction('#39'abc'#39', '#39'123'#39')', RT);
  DoStatus(VarToStr(v));

  // ���ַ������ʽ������ʹ��c���ı���ʽ
  v := EvaluateExpressionValue(tsC, 'myStringFunction("abc", "123")', RT);
  DoStatus(VarToStr(v));
  v := EvaluateExpressionValue(tsC, 'myStringFunction('#39'abc'#39', '#39'123'#39')', RT);
  DoStatus(VarToStr(v));

  DisposeObject(RT);
end;

// ����������ִ��
procedure Demo2;
var
  tmpSym: TSymbolExpression;
  Op: TOpCode;
  RT: TOpCustomRunTime;
  m64: TMemoryStream64;
begin
  DoStatus('����������ִ��demo');
  // rtΪze�����к���֧�ֿ�
  RT := TOpCustomRunTime.Create;
  RT.RegOpP('myAddFunction', function(var Param: TOpParam): Variant
    // (a+b)*0.5
    begin
      Result := (Param[0] + Param[1]) * 0.5;
    end);
  RT.RegOpP('myStringFunction', function(var Param: TOpParam): Variant
    begin
      Result := Format('�ַ�������Ϊ:%d', [length(VarToStr(Param[0]) + VarToStr(Param[1]))]);
    end);

  // ʹ��ParseTextExpressionAsSymbol�����������ʽ����ɴʷ���
  tmpSym := ParseTextExpressionAsSymbol_M(TTextParsing, tsPascal, '', '1000+myAddFunction(1+1/2*3/3.14*9999, 599+2+2*100 shl 3)', nil, RT);
  // BuildAsOpCode�Ὣ�ʷ����ٴη�����﷨����Ȼ���ٻ����﷨������op����
  Op := BuildAsOpCode(tmpSym);
  DisposeObject(tmpSym);
  // ����ִ��һ��op
  DoStatus('op���з���ֵ(��ȷֵΪ4489.2962): %s', [VarToStr(Op.Execute(RT))]);

  m64 := TMemoryStream64.Create;
  Op.SaveToStream(m64);

  // �����Ѿ��ͷ���op
  DisposeObject(Op);

  // ��stream���ٶ�ȡop�������������
  m64.Position := 0;
  if LoadOpFromStream(m64, Op) then
    begin
      DoStatus('op���з���ֵ(��ȷֵΪ4489.2962): %s', [VarToStr(Op.Execute(RT))]);
    end;

  DisposeObject([Op, RT, m64]);

  DoStatus('����������ִ��demo���������');
end;

// �߼�demo���ű��﷨���ű��ʷ�������ʾ����zExpression���ʽӦ����if�ṹ
// ����ʷ����̳�������û�м����������������̱�д�Լ��Ľű����������ǵ��򼶵ģ����������������׷�ʽ
procedure Demo3;
type
  TState = (sUnknow, sIF, sTrue, sFalse); // �����õļ�״̬��
label gFillStruct;
var
  T: TTextParsing;                                  // �ʷ���������
  cp, EP: Integer;                                  // ������
  wasNumber, WasText, wasAscii, wasSymbol: Boolean; // �����ı�״̬��
  State: TState;                                    // �����ṹ״̬��
  Decl: TPascalString;                              // ��ǰ�����ʷ��壬����
  ifMatchBody: TPascalString;                       // ���������ж�������
  ifTrueBody: TPascalString;                        // ��������������
  ifFalseBody: TPascalString;                       // ����������������
  RT: TOpCustomRunTime;                             // ���к�����֧��
begin
  // ����pascal���ַ�����������д�ڳ����У���������c����ַ���
  T := TTextParsing.Create('if 1+1=/* comment */2 then writeln/* comment */("if was true") else/*  comment */writeln("if was false");', tsC, nil);
  cp := 1;
  EP := 1;
  State := sUnknow;
  ifMatchBody := '';
  ifTrueBody := '';
  ifFalseBody := '';

  // ������ѭ��
  while cp < T.Len do
    begin
      // �ʷ����̷�ʽ�����״˷�ʽ���Գ���ʷ�����Ϊ����û�п������ܣ������Ҫ�������нű����뿼�Ǳ�������ݽṹ�洢���Ը��ٷ�ʽ��������
      if T.isComment(cp) then
        begin
          EP := T.GetCommentEndPos(cp);
          cp := EP;
          Continue;
        end;

      wasNumber := T.isNumber(cp);
      WasText := T.isTextDecl(cp);
      wasAscii := T.isAscii(cp);
      wasSymbol := T.isSymbol(cp);

      if wasNumber then
        begin
          EP := T.GetNumberEndPos(cp);
          Decl := T.GetStr(cp, EP);
          cp := EP;
          goto gFillStruct;
        end;

      if WasText then
        begin
          EP := T.GetTextDeclEndPos(cp);
          Decl := T.GetStr(cp, EP);
          cp := EP;
          goto gFillStruct;
        end;

      if wasAscii then
        begin
          EP := T.GetAsciiEndPos(cp);
          Decl := T.GetStr(cp, EP);
          cp := EP;
          goto gFillStruct;
        end;

      if wasSymbol then
        begin
          Decl := T.ParsingData.Text[cp];
          Inc(cp);
          EP := cp;
          goto gFillStruct;
        end;

      Inc(cp);
      Continue;
      // �ʷ����̷�ʽ�����������������ṹ���ж�

    gFillStruct:

      if wasAscii then
        begin
          // �ʷ��ṹ
          if Decl.Same('if') then
            begin
              if State <> sUnknow then
                begin
                  DoStatus('if ��ʽ��������');
                  Break;
                end;
              State := sIF;
              Continue;
            end;

          if Decl.Same('then') then
            begin
              if State <> sIF then
                begin
                  DoStatus('then ��ʽ��������');
                  Break;
                end;
              State := sTrue;
              Continue;
            end;

          if Decl.Same('else') then
            begin
              if State <> sTrue then
                begin
                  DoStatus('else ��д��ʽ��������');
                  Break;
                end;
              State := sFalse;
              Continue;
            end;
        end;

      case State of
        sIF: ifMatchBody.Append(Decl);    // ��TPascalString�У�ʹ��Append������Ҫ��string:=string+stringЧ�ʸ���
        sTrue: ifTrueBody.Append(Decl);   // ��TPascalString�У�ʹ��Append������Ҫ��string:=string+stringЧ�ʸ���
        sFalse: ifFalseBody.Append(Decl); // ��TPascalString�У�ʹ��Append������Ҫ��string:=string+stringЧ�ʸ���
      end;
    end;

  // ����һ��������if�ṹ����Ѿ������ɹ��ˣ�����ֱ�����г��򼴿�
  if State = sFalse then
    begin
      RT := TOpCustomRunTime.Create;
      RT.RegOpP('writeln', function(var Param: TOpParam): Variant
        begin
          Writeln(VarToStr(Param[0]));
          Result := 0;
        end);
      // �����Ҫ���ܣ�����Ľṹ������Կ��������ݽṹ���洢��ʵ�ֿ��ٽű�
      if EvaluateExpressionValue(tsC, ifMatchBody, RT) = True then
          EvaluateExpressionValue(tsC, ifTrueBody, RT)
      else
          EvaluateExpressionValue(tsC, ifFalseBody, RT);
      DisposeObject(RT);
    end;

  DisposeObject(T);
end;

// �߼�Demo����zExpression���ʽӦ�����ı�������
procedure Demo4;
var
  RT: TOpCustomRunTime;

  function Macro(var AText: string; const HeadToken, TailToken: string): TPascalString;
  var
    sour: TPascalString;
    HT, TT: TPascalString;
    bPos, ePos: Integer;
    KeyText: SystemString;
    i: Integer;
    tmpSym: TSymbolExpression;
    Op: TOpCode;
  begin
    Result := '';
    sour.Text := AText;
    HT.Text := HeadToken;
    TT.Text := TailToken;

    i := 1;

    while i <= sour.Len do
      begin
        if sour.ComparePos(i, @HT) then
          begin
            bPos := i;
            ePos := sour.GetPos(@TT, i + HT.Len);
            if ePos > 0 then
              begin
                KeyText := sour.Copy(bPos + HT.Len, ePos - (bPos + HT.Len)).Text;

                // ��TPascalString�У�ʹ��Append������Ҫ��string:=string+stringЧ�ʸ���
                Result.Append(VarToStr(EvaluateExpressionValue(KeyText, RT)));
                i := ePos + TT.Len;
                Continue;
              end;
          end;

        // ��TPascalString�У�ʹ��Append������Ҫ��string:=string+stringЧ�ʸ���
        Result.Append(sour[i]);
        Inc(i);
      end;
  end;

var
  n: string;
  i: Integer;
  T: TTimeTick;
begin
  DoStatus('����ʾ�ýű�����װzExpression');
  // rtΪze�����к���֧�ֿ�
  RT := TOpCustomRunTime.Create;
  RT.RegOpP('OverFunction', function(var Param: TOpParam): Variant
    begin
      Result := 'лл';
    end);

  // ��������ʹ�ú괦��1+1�Ա��ʽ������
  n := '����1+1=<begin>1+1<end>������һ��UInt48λ����:<begin>1<<48<end>������ <begin>OverFunction<end>';

  DoStatus('ԭ��:' + n);
  DoStatus('������' + Macro(n, '<begin>', '<end>').Text);

  DoStatus('zExpression���ڲ������ܣ�������ԭ����10��δ���');

  T := GetTimeTick;

  // �ظ���10��ξ䷨���ʽ�����ʹ���
  for i := 1 to 10 * 10000 do
      Macro(n, '<begin>', '<end>');

  DoStatus('zExpression���ܲ�����ɣ���ʱ:%dms', [GetTimeTick - T]);

  DisposeObject([RT]);
end;

// �߼�Demo��ʵ���ڲ������ĸ�ֵ
// �����Ҵ���һ���ű�����γ����ķ����������е�࣬����ԭ��ֻ������
procedure Demo5;
var
  sourTp, T: TTextParsing;            // �ʷ���������
  setBefore, setAfter: TPascalString; // ��ֵ��ǰ���������͸�ֵ�ĺ�������
  splitVarDecl: TArrayPascalString;   // �п��ı��ʽ��
  myvars: TArrayPascalString;         // ������Ҫ��ֵ����ʱ�������Զ��ŷָ�
  WasAssignment: Boolean;             // �ڱ��ʽ���ҵ��˸�ֵ
  HashVars: THashVariantList;         // ������hash�洢�ṹ�����ǿ��Դ�ŵ�Ӳ���е�
  RT: TOpCustomRunTime;               // ���к�����֧��
  Op: TOpCode;                        // ����������cache��op����
  i: Integer;                         // forʹ��
  dynvar: Integer;                    // ��̬����
begin
  // ������c��pascal����д���������޸ı�ע����
  // sourTp := TTextParsing.Create('myvar1/*�����Ǳ�ע*/,myvar2,myvar3 = 123+456+" ����: "+dynamic', tsC, nil); // �ʷ��������棬��c�﷨Ϊ��
  sourTp := TTextParsing.Create('myvar1(*�����Ǳ�ע*),myvar2,myvar3 := 123+456+'#39' ����: '#39'+dynamic', tsPascal, nil); // �ʷ��������棬��c�﷨Ϊ��
  // sourTp := TTextParsing.Create('123+456+dynamic', tsPascal, nil); // �ʷ��������棬��c�﷨Ϊ��

  HashVars := THashVariantList.CustomCreate(16); // 16��hash��buff���ȣ���ֵԽ����ٶ�Խ��

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

            T := TTextParsing.Create(setBefore, tsPascal, nil);
            T.DeletedComment;
            if T.SplitChar(1, ',', ';', myvars) = 0 then // ���ﲻ���ַ����������ַ���Ϊ�и�Ǻţ��Դ���,���ַ������и�
                DoStatus('������ֵ�﷨���� %s', [setBefore.Text]);
            DisposeObject(T);
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

            T := TTextParsing.Create(setBefore, tsC, nil);
            T.DeletedComment;
            if T.SplitChar(1, ',', ';', myvars) = 0 then // ���ﲻ���ַ����������ַ���Ϊ�и�Ǻţ��Դ���,���ַ������и�
                DoStatus('������ֵ�﷨���� %s', [setBefore.Text]);
            DisposeObject(T);
          end;
      end;
    else
      begin
        DoStatus('��֧�ֱ��ʽ');
        WasAssignment := False;
      end;
  end;

  RT := TOpCustomRunTime.Create;
  RT.RegOpP('dynamic', function(var Param: TOpParam): Variant
    begin
      Result := dynvar;
      Inc(dynvar);
    end);
  RT.RegOpP('myvar1', function(var Param: TOpParam): Variant
    begin
      // ��myvar1���ж�̬����
      Result := HashVars['myvar1'];
    end);

  dynvar := 1;

  // �ڶ���������ҵ��˸�ֵ����
  if WasAssignment then
    begin
      DoStatus('�����˱�����ֵ���ʽ');

      Op := BuildAsOpCode(sourTp.TextStyle, setAfter, RT);

      for i := low(myvars) to high(myvars) do
          HashVars[myvars[i].TrimChar(#32).Text] := Op.Execute(RT); // ��һ����β�ո�ü���ִ��op�����������ĸ�ֵ

      DoStatus('������ֵ����');
      DoStatus(HashVars.AsText);

      // ���������ñ����ڱ��ʽ�еĸ���
      DoStatus('���ڣ����ǿ�ʼ��̬�������Ǹղ������ı�������̬�����ǽ�������const��ʽ���б���');

      // ����opCache�������Զ������еģ��������κ�ʱ����const���ñ���ʱ��Ҫ�����
      OpCache.Clear;

      DoStatus(VarToStr(EvaluateExpressionValue_P(False, nil, TTextParsing, tsC, '"��̬���� "+myvar1',
        procedure(const Decl: SystemString; var ValType: TExpressionDeclType; var Value: Variant)
        begin
          if HashVars.Exists(Decl) then
            begin
              Value := HashVars[Decl];
              ValType := TExpressionDeclType.edtString; // ������Ҫ���߱��������ñ���������
            end;
        end)));

      DoStatus(VarToStr(EvaluateExpressionValue_P(False, nil, TTextParsing, tsC, '"��̬���� "+myvar4',
        procedure(const Decl: SystemString; var ValType: TExpressionDeclType; var Value: Variant)
        begin
          // myvar4�ǲ����ڵ�
          // Ȼ�� ������myvar2������
          Value := HashVars['myvar2'];
          ValType := TExpressionDeclType.edtString; // ������Ҫ���߱��������ñ���������
        end)));

      DoStatus('���ڣ����ǿ�ʼ��̬�������Ǹղ������ı���');
      DoStatus(VarToStr(EvaluateExpressionValue(tsC, '"��̬���� "+myvar1', RT)));

      HashVars['myvar1'] := 'abc';
      DoStatus(VarToStr(EvaluateExpressionValue(tsC, '"��̬���� "+myvar1', RT)));
    end
  else
    begin
      DoStatus('û�з����˱�����ֵ');
      DoStatus('���ʽ "%s"' + #13#10 + '���н�� %s', [sourTp.ParsingData.Text.Text, VarToStr(EvaluateExpressionValue(sourTp.TextStyle, sourTp.ParsingData.Text, RT))]);
    end;

  DisposeObject([sourTp, HashVars, RT]);
end;

// ����tokenProbe������ if xx then xx else xx��ʵ�֣�������ԭ����ĸ��ӶȽ���90%
procedure Demo6;
var
  T: TTextParsing;                      // �ʷ���������
  pIF, pThen, pElse, pDone: PTokenData; // token�������ñ���
  t_error: Boolean;                     // ������
  ifMatchBody: TPascalString;           // ���������ж�������
  ifTrueBody: TPascalString;            // ��������������
  ifFalseBody: TPascalString;           // ����������������
  RT: TOpCustomRunTime;                 // ���к�����֧��
begin
  // ����pascal���ַ�����������д�ڳ����У���������c����ַ���
  T := TTextParsing.Create('if 1+1=2 then writeln("if was true on probe") else writeln("if was false on probe");', tsC, nil);
  // T := TTextParsing.Create('if 1+1=2 then writeln("no else: if run on probe");', tsC, nil);

  t_error := True;
  // �����һ��ƣ������0��tokenλ�ü��ascii�ʷ�Ϊif�Ĺؼ���
  pIF := T.TokenProbeR(0, [ttAscii], 'if');
  if (pIF <> nil) then
    begin
      pThen := T.TokenProbeR(pIF^.Index + 1, [ttAscii], 'then');
      if pThen <> nil then
        begin
          pElse := T.TokenProbeR(pThen^.Index + 1, [ttAscii], 'else');
          pDone := T.TokenProbeR(pThen^.Index + 1, [ttSymbol], ';');

          if (pDone <> nil) then
            begin
              ifMatchBody := T.TokenCombine(pIF^.Index + 1, pThen^.Index - 1);
              if (pDone <> nil) and (pElse <> nil) and (pElse^.Index < pDone^.Index) then
                begin
                  ifTrueBody := T.TokenCombine(pThen^.Index + 1, pElse^.Index - 1);
                  ifFalseBody := T.TokenCombine(pElse^.Index + 1, pDone^.Index - 1);
                end
              else
                begin
                  ifTrueBody := T.TokenCombine(pThen^.Index + 1, pDone^.Index - 1);
                  ifFalseBody := '';
                end;
              t_error := False;
            end
          else
              DoStatus('���ʽ�Ƿ�����');
        end
      else
          DoStatus('���ʽû��then�ؼ���');
    end
  else
      DoStatus('���ʽû��if�ؼ���');

  if t_error then
      DoStatus('��⵽�ṹ�����')
  else
    begin
      RT := TOpCustomRunTime.Create;
      RT.RegOpP('writeln', function(var Param: TOpParam): Variant
        begin
          Writeln(VarToStr(Param[0]));
          Result := 0;
        end);
      // �����Ҫ���ܣ�����Ľṹ������Կ��������ݽṹ���洢��ʵ�ֿ��ٽű�
      if EvaluateExpressionValue(tsC, ifMatchBody, RT) = True then
          EvaluateExpressionValue(tsC, ifTrueBody, RT)
      else
          EvaluateExpressionValue(tsC, ifFalseBody, RT);
      DisposeObject(RT);
    end;

  DisposeObject(T);
end;

var
  sym1: TSymbolExpression;
  Op: TOpCode;

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
    sym1 := ParseTextExpressionAsSymbol_M(TTextParsing, tsPascal, '', '(1+1*2/3.14)', nil, DefaultOpRT);
    // sym1.PrintDebug(True);

    // zExpression �ĺ����߼����������ڷ�������Ԥ��������Ժ����²𿪱��ʽ���ݽṹ�������ؽ�һ�������������Ͻ�TSymbolExpression������˳�򣬸ò���������
    // RebuildAllSymbol����ֱ�Ӵ�����ɵڶ����͵�����
    // sym2 := RebuildAllSymbol(sym1);
    // sym2.PrintDebug(True);

    // zExpression �ĺ����߼����Ĳ�������RebuildAllSymbol����Ͻ�TSymbolExpression����˳�򣬴�������ԭ�ӻ�ִ��
    // BuildAsOpCode���Զ��Եڶ��͵����������������Ż�����
    // ����ԭ�ӻ�ִ�е�ʵ����ο�opCode����
    Op := BuildAsOpCode(True, sym1);
    if Op <> nil then
      begin
        DoStatus('Value:' + VarToStr(Op.Execute));
        DoStatus('');
        FreeObject(Op);
      end;

    FreeObject([sym1]);

    SpecialFuncDemo;
    Demo1;
    Demo2;
    Demo3;
    Demo4;
    Demo5;
    Demo6;

    readln;
  except
    on E: Exception do
        Writeln(E.ClassName, ': ', E.Message);
  end;

end.

