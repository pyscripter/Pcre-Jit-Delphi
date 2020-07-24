(*
** You do need the mtent12.txt from
** http://www.gutenberg.org/files/3200/old/mtent12.zip for this benchmark
**)
// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
// JCL_DEBUG_EXPERT_INSERTJDBG OFF
// JCL_DEBUG_EXPERT_DELETEMAPFILE OFF
program benchmark;

{$apptype console}

uses
  System.SysUtils,
  System.Classes,
  System.Diagnostics,
  System.RegularExpressionsAPI in '..\Source\System.RegularExpressionsAPI.pas',
  System.RegularExpressionsConsts,
  System.RegularExpressionsCore,
  System.RegularExpressions;

const BenchmarkCount=1;

      BenchmarkPatterns:array[0..14] of String=('Twain',
                                                '(?i)Twain',
                                                '[a-z]shing',
                                                'Huck[a-zA-Z]+|Saw[a-zA-Z]+',
                                                '\b\w+nn\b',
                                                '[a-q][^u-z]{13}x',
                                                'Tom|Sawyer|Huckleberry|Finn',
                                                '(?i)Tom|Sawyer|Huckleberry|Finn',
                                                '.{0,2}(Tom|Sawyer|Huckleberry|Finn)',
                                                '.{2,4}(Tom|Sawyer|Huckleberry|Finn)',
                                                'Tom.{10,25}river|river.{10,25}Tom',
                                                '[a-zA-Z]+ing',
                                                '\s[a-zA-Z]{0,12}ing\s',
                                                '([A-Za-z]awyer|[A-Za-z]inn)\s',
                                                '["''][^"'']{0,30}[?!\.]["'']');


type
  { TPerlRegExHelper }
  TPerlRegExHelper = class helper for TPerlRegEx
  public
    procedure SetAdditionalPCREOptions(PCREOptions : Integer);
    procedure StudyJIT;
  end;

procedure TPerlRegExHelper.SetAdditionalPCREOptions(PCREOptions: Integer);
begin
  with Self do FPCREOptions := FPCREOptions or PCREOptions;
end;


procedure TPerlRegExHelper.StudyJIT;
var
  Error: MarshaledAString;
begin
  with Self do begin
    if not FCompiled then
      Compile;
    FHints := pcre_study(FPattern, PCRE_STUDY_JIT_COMPILE, @Error);
    if Error <> nil then
      raise ERegularExpressionError.CreateResFmt(@SRegExStudyError, [string(Error)]);
    FStudied := True
  end;
end;

type
{ TRegExHelper }
  TRegExHelper = record helper for TRegEx
  public
    procedure Study;
    procedure StudyJIT;
    procedure SetAdditionalPCREOptions(PCREOptions : Integer);
    function PerlRegEx: TPerlRegEx;
  end;

procedure TRegExHelper.Study;
begin
  with Self do FRegEx.Study;
end;

procedure TRegExHelper.StudyJIT;
begin
  with Self do FRegEx.StudyJIT;
end;

function TRegExHelper.PerlRegEx: TPerlRegEx;
begin
  With Self do Result := FRegEx;
end;

procedure TRegExHelper.SetAdditionalPCREOptions(PCREOptions: Integer);
begin
  with Self do FRegEx.SetAdditionalPCREOptions(PCREOptions);
end;

procedure BenchmarkDelphiRegEx(Subject : String; Study, JIT: Boolean);
Var
  i,j:integer;
  StopWatch : TStopWatch;
  RegEx : TRegEx;
  Matches : TMatchCollection;
  TotalStopWatch: TStopWatch;
  Count : integer;
begin
  TotalStopWatch := TStopWatch.StartNew;
  for i:=low(BenchmarkPatterns) to high(BenchmarkPatterns) do begin
    RegEx.Create(BenchmarkPatterns[i]);
    RegEx.SetAdditionalPCREOptions(PCRE_UCP);
    if JIT then
      RegEx.StudyJIT
    else if Study then
      RegEx.Study;
    try
      write('/'+BenchmarkPatterns[i]+'/ : ':50,'Please wait... ');
      StopWatch := TStopWatch.StartNew;
      Count := 0;
      for j:=1 to BenchmarkCount do begin
        Matches := RegEx.Matches(Subject);
        Inc(Count, Matches.Count);
      end;
      StopWatch.Stop;
      Write(#8#8#8#8#8#8#8#8#8#8#8#8#8#8#8);
      Writeln((StopWatch.ElapsedMilliseconds / BenchmarkCount):11:2, ' ms |', Count:12);
    except
      on e:Exception do begin
        writeln(e.Message);
      end;
    end;
  end;
  TotalStopWatch.Stop;
  Writeln('Total Time: ', (TotalStopWatch.ElapsedMilliseconds / BenchmarkCount):11:2, ' ms');
end;

function FileToText(FileName : string) : string;
var
  SL : TStringList;
begin
  SL := TStringList.Create;
  try
    SL.LoadFromFile(FileName, TEncoding.UTF8);
    Result := SL.Text;
  finally
    SL.Free;
  end;
end;

Var
  Subject: String;
  JitAvail: integer;

begin
  if pcre_config(PCRE_CONFIG_JIT, @JITAvail) = 0 then
    if JITAvail <> 1 then
      Writeln('JIT not available');


  Subject := FileToText('mtent12.txt');

  Writeln(' ':50,'      Time     | Match count');


  Writeln('==============================================================================');
  writeln('Delphi''s own TRegEx:');
  BenchmarkDelphiRegEx(Subject, False, False);

  Writeln('==============================================================================');
  writeln('Delphi''s own TRegEx with Study:');
  BenchmarkDelphiRegEx(Subject, True, False);

  Writeln('==============================================================================');
  writeln('Delphi''s own TRegEx with JIT:');
  BenchmarkDelphiRegEx(Subject, False, True);

  Readln;
End.


