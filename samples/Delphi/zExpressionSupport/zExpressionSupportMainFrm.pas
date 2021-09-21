unit zExpressionSupportMainFrm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.StdCtrls, FMX.Edit, FMX.Layouts, FMX.Controls.Presentation,
  FMX.ScrollBox, FMX.Memo,

  CoreClasses, PascalStrings, UnicodeMixedLib, ListEngine, DoStatusIO, TextParsing, zExpression, OpCode,
  FMX.Memo.Types;

type
  TzExpressionSupportMainForm = class(TForm)
    ExpParsingMemo: TMemo;
    expEvaluateMemo: TMemo;
    Layout1: TLayout;
    Label3: TLabel;
    InputEdit: TEdit;
    evaluateButton: TEditButton;
    ParsingAllButton: TButton;
    EvaluateAllButton: TButton;
    StatusMemo: TMemo;
    functionMemo: TMemo;
    Label1: TLabel;
    Debug_CheckBox: TCheckBox;
    procedure evaluateButtonClick(Sender: TObject);
    procedure EvaluateAllButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure InputEditKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure ParsingAllButtonClick(Sender: TObject);
  private
    { Private declarations }
    procedure DoStatusMethod(AText: SystemString; const ID: Integer);
  public
    { Public declarations }
  end;

var
  zExpressionSupportMainForm: TzExpressionSupportMainForm;

implementation

{$R *.fmx}

function a(var Param: TOpParam): Variant;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to length(Param) - 1 do
      Result := Result + Param[i];
end;

procedure TzExpressionSupportMainForm.evaluateButtonClick(Sender: TObject);
var
  v: Variant;
begin
  // 评估器，支持向量表达式：1+1,2+2,3+3
  v := EvaluateExpressionValue(False, nil, Debug_CheckBox.IsChecked, tsPascal, InputEdit.Text, nil);
  if not VarIsNull(v) then
      DoStatus(InputEdit.Text + ' = ' + VarToStr(v));
end;

procedure TzExpressionSupportMainForm.EvaluateAllButtonClick(Sender: TObject);
var
  i: Integer;
  v: Variant;
begin
  for i := 0 to expEvaluateMemo.Lines.Count - 1 do
    begin
      // 评估器，支持向量表达式：1+1,2+2,3+3
      v := EvaluateExpressionValue(False, nil, Debug_CheckBox.IsChecked, tsPascal, expEvaluateMemo.Lines[i], nil);
      if not VarIsNull(v) then
          DoStatus('%s = %s', [expEvaluateMemo.Lines[i], VarToStr(v)])
      else
          DoStatus('error: ' + expEvaluateMemo.Lines[i]);
    end;
end;

procedure TzExpressionSupportMainForm.FormCreate(Sender: TObject);
var
  psList: TPascalStringList;
begin
  AddDoStatusHook(Self, DoStatusMethod);
  psList := DefaultOpRT.GetAllProcDescription;
  psList.AssignTo(functionMemo.Lines);
  disposeObject(psList);

  DefaultOpRT.RegOpC('a', a);
end;

procedure TzExpressionSupportMainForm.InputEditKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if Key = VKRETURN then
      evaluateButtonClick(evaluateButton);
end;

procedure TzExpressionSupportMainForm.ParsingAllButtonClick(Sender: TObject);
var
  i: Integer;
  E, e2: TSymbolExpression;
begin
  for i := 0 to ExpParsingMemo.Lines.Count - 1 do
    begin
      // 底层符号解析api，这种API不支持向量表达式
      E := ParseTextExpressionAsSymbol_M(TTextParsing, tsPascal, '', ExpParsingMemo.Lines[i], nil, nil);
      if E <> nil then
        begin
          e2 := RebuildAllSymbol(E);
          if e2 <> nil then
            begin
              e2.PrintDebug(False);
              disposeObject(e2);
            end;
          disposeObject(E);
        end
      else
          DoStatus('error: ' + ExpParsingMemo.Lines[i]);
    end;
end;

procedure TzExpressionSupportMainForm.DoStatusMethod(AText: SystemString; const ID: Integer);
begin
  StatusMemo.Lines.Add(AText);
  StatusMemo.GoToTextEnd;
end;

end.
