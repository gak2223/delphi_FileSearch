unit formMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, ComCtrls, Buttons, Menus, formResult, basUnit,
  formProgress;

type
  TForm3 = class(TForm)
    Button1: TButton;
    GroupBox1: TGroupBox;
    edtKakuchosiAdd: TEdit;
    Button3: TButton;
    CheckListBox1: TCheckListBox;
    Button4: TButton;
    Button5: TButton;
    GroupBox2: TGroupBox;
    CheckBox1: TCheckBox;
    fromDateTimePicker1: TDateTimePicker;
    toDateTimePicker1: TDateTimePicker;
    Label1: TLabel;
    Button2: TButton;
    CheckBox6: TCheckBox;
    MainMenu1: TMainMenu;
    mnuFile: TMenuItem;
    mnuSave: TMenuItem;
    mnuLoad: TMenuItem;
    mnuClose: TMenuItem;
    CheckListBox2: TCheckListBox;
    CheckBox2: TCheckBox;
    fromDateTimePicker2: TDateTimePicker;
    toDateTimePicker2: TDateTimePicker;
    procedure DateTimePickersClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CheckListBox2ClickCheck(Sender: TObject);
    procedure mnuLoadClick(Sender: TObject);
    procedure mnuSaveClick(Sender: TObject);
    procedure mnuCloseClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckListCheckChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure edtKakuchosiAddKeyPress(Sender: TObject; var Key: Char);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private 宣言 }
    dtFrom : TDatetime;
    dtTo: TDatetime;
    searchList : TStringList;
    blockExtList : TStringList;
    progress : TfrmPregress;
    procedure SetDateTimes;
    procedure LockControls(b: Boolean);
    function ExtractFileBody(const Path: string): string;
    function GetListDetailInfo():TStringList;
    function DateCheck():Boolean;
    procedure AllCheckControl(b : Boolean);
    function EnumFileFromDir(Dir: String):String;
    function GetMask(): TStringList;
    function NeedToAddList(rec : TSearchRec): Boolean;
    procedure BlockCheck(Extentions : TStringList; b : Boolean);
    procedure LoadFromFss(sFileName: String);                 
  public
    { Public 宣言 }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

{$region 'Form全般'}

{$region 'コンストラクタ'}
procedure TForm3.FormCreate(Sender: TObject);
var
  i : Integer;
begin
  searchList := TStringList.Create();
  blockExtList := TStringList.Create();
  fromDateTimePicker1.Date := now;
  fromDateTimePicker2.DateTime := now;
  fromDateTimePicker2.Time := StrToTime('00:00:00');
  toDateTimePicker1.Date := now;
  toDateTimePicker2.DateTime := now;
  toDateTimePicker2.Time := StrToTime('23:59:59');
  SetDateTimes();
  Self.ActiveControl := Button1;

  with blockExtList do
  begin
    Add('jsp');
    Add('java');
    Add('画像');
    Add('confとか');
    Add('シェル');
    Add('Htmlとか');
    Add('jar(日付無視)');
    for i := 0 to Count -1 do
    begin
      Self.CheckListBox2.Items.Add(Strings[i]);
    end;
  end;
end;
{$endregion}

{$region '閉じるボタン'}
procedure TForm3.Button2Click(Sender: TObject);
begin
  Self.Close();
end;
{$endregion}

{$region 'Close実行部'}
procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Self.searchList.Free();
  Self.blockExtList.Free();
end;
{$endregion}

{$region '処理実行中はコントロールをロック'}
procedure TForm3.LockControls(b: Boolean);
begin
  self.Enabled := b;
end;
{$endregion}

{$region '日付は使わないチェックボックス'}
procedure TForm3.CheckBox1Click(Sender: TObject);
begin
  with (Sender as TCheckBox) do
  begin
    fromDateTimePicker1.Enabled := not(Checked);
    fromDateTimePicker2.Enabled := not(Checked);
    toDateTimePicker1.Enabled := not(Checked);
    toDateTimePicker2.Enabled := not(Checked);
  end;
end;
{$endregion}

{$region 'キーボードショートカット'}
procedure TForm3.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE : Self.Close();
    VK_F12 : Self.Button1.OnClick(Self.Button1);
  end;
end;
{$endregion}

{$region 'DatetimePicker関係'}
procedure TForm3.DateTimePickersClick(Sender: TObject);
begin
  SetDateTimes();
end;

procedure TForm3.SetDateTimes();
var
  sFrom, sTo: String;
begin
  sFrom := DateToStr(fromDateTimePicker1.Date) + ' ' + TimeToStr(fromDateTimePicker2.Time);
  dtFrom := StrToDateTime(sFrom);
  sTo := DateToStr(toDateTimePicker1.Date) + ' ' + TimeToStr(toDateTimePicker2.Time);
  dtTo := StrToDateTime(sTo);
end;
{$endregion}

{$endregion}

{$region '拡張子関連'}

{$region '全部ON,OFFチェックイベント'}
procedure TForm3.CheckListCheckChange(Sender: TObject);
begin
  Self.AllCheckControl((Sender as TButton).Caption = '全部ON');
end;
{$endregion}

{$region '全部ON,OFF実行部'}
procedure TForm3.allCheckControl(b : Boolean);
var
  i : Integer;
begin
  with CheckListBox1 do
  begin
    for i := 0 to Items.Count - 1 do
    begin
       Checked[i] := b;
    end;
  end;
end;
{$endregion}

{$region '拡張子手動追加禁則文字'}
procedure TForm3.edtKakuchosiAddKeyPress(Sender: TObject; var Key: Char);
begin
   case Key of
    '*', '.', ',': Key := #0;
   end;
end;
{$endregion}

{$region '拡張子手動追加イベント'}
procedure TForm3.Button3Click(Sender: TObject);
var
  sNewKakuchoshi : String;
begin
  sNewKakuchoshi := '.' +  Trim(edtKakuchosiAdd.Text);
  if not(sNewKakuchoshi = '.')then
  begin
    with CheckListBox1 do
    begin
      Items.Add(sNewKakuchoshi);
      Checked[Items.Count -1] := true;
    end;
    edtKakuchosiAdd.Text := '';
  end;
end;
{$endregion}

{$region '拡張子テンプレート'}
procedure TForm3.CheckListBox2ClickCheck(Sender: TObject);
var
  s : String;
  sl : TStringList;
begin
  sl := TStringList.Create();
  try
    with CheckListBox2 do
      begin
      s := Items[ItemIndex];
      if(s = Self.blockExtList.Strings[0])then
      begin
        sl.Add('.jsp');
      end else if(s = Self.blockExtList.Strings[1]) then
      begin
        sl.Add('.java');
      end else if(s = Self.blockExtList.Strings[2]) then
      begin
        sl.Add('.gif');
        sl.Add('.png');
        sl.Add('.jpg');
        sl.Add('.jpeg');
      end else if(s = Self.blockExtList.Strings[3]) then
      begin
        sl.Add('.conf');
        sl.Add('.cnf');
        sl.Add('.txt');
        sl.Add('.xml');
      end else if(s = Self.blockExtList.Strings[4]) then
      begin
        sl.Add('.sh');
      end else if(s = Self.blockExtList.Strings[5]) then
      begin
        sl.Add('.html');
        sl.Add('.htm');
        sl.Add('.js');
        sl.Add('.css');
      end else if(s = Self.blockExtList.Strings[6]) then
      begin
        sl.Add('.jar');
      end;
      BlockCheck(sl,Checked[ItemIndex]);
    end;
  finally
    sl.Free();
  end;
end;
{$endregion}

{$region '拡張子テンプレート実行部'}
procedure TForm3.BlockCheck(Extentions: TStringList; b: Boolean);
var
  i,j : Integer;
begin
  with CheckListBox1 do
  begin
    if(b)then
    begin
      for j := 0 to Extentions.Count - 1 do
      begin
        if(Items.IndexOf(Extentions.Strings[j]) < 0)then
        begin
          Items.Add(Extentions.Strings[j]);
        end;
      end;
    end;
    for i := 0 to Items.Count - 1 do
    begin
      for j := 0 to Extentions.Count - 1 do
      begin
        if(Items.Strings[i] = Extentions.Strings[j])then
        begin
          Checked[i] := b;
        end;
      end;
    end;
  end;
end;
{$endregion}

{$region '画面から指定された拡張子のリストを得る'}
function TForm3.GetMask(): TStringList;
var
  i : Integer;
  sl : TStringList;
begin
  sl := TStringList.Create();
  try
    with CheckListBox1 do
    begin
      for i := 0 to Items.Count - 1 do
      begin
        if(Checked[i])then
        begin
          sl.Add(Items[i]);
        end;
      end;
    end;
  finally
    result := sl;
  end;
end;
{$endregion}

{$endregion}

{$region '日付関連'}

{$region 'From,To日付の妥当性チェック'}
function TForm3.dateCheck(): Boolean;
begin
  Result := (CheckBox1.Checked or not(dtfrom > dtto));
end;
{$endregion}

{$endregion}

{$region '検索処理関連'}

{$region '検索ボタン'}
procedure TForm3.Button1Click(Sender: TObject);
var
  frm : TfrmResult;
begin
  progress := TfrmPregress.Create(Self);
  frm := TfrmResult.Create(Self);
  try
    Self.LockControls(false);
    searchList.Clear();
    if(dateCheck())then
    begin
      ChDir(ExtractFilePath(Application.ExeName));
      progress.SetTitle('検索中');
      progress.Show();
      EnumFileFromDir(CURRENT_DIR);
//      ShowMessage(searchList.Text);
      try
        frm.sl := searchList;
        application.ProcessMessages();
        progress.Close();
        frm.ShowModal();
      finally
        frm.Free();
      end;
    end
    else
    begin
      MessageDlg('日付指定が変なので処理しません。', mtError, [mbOK], 0);
    end;
  finally
    Self.LockControls(true);
    progress.Free();
  end;
end;
{$endregion}

{$region '検索処理実行部'}
function TForm3.EnumFileFromDir(Dir: String): String;
var
  rec, rec2: TSearchRec;
  classDir : String;
  classString : String;
  resultValue : String;
begin
  //フォルダ名の最後に \ がついていなければつける
  Dir :=IncludeTrailingPathDelimiter(Dir);

  if (FindFirst(Dir + '*.*', faAnyFile, Rec) = 0) then
  begin
    try
      repeat
        if (Rec.Attr and faDirectory <> 0) then
        begin
          if ((Rec.Name='.') or (Rec.Name='..')) then
          begin
            Continue;
          end;
          //フォルダなら再度この関数を呼び出し
          Result :=EnumFileFromDir(Dir + Rec.Name);
        end
        else
        begin
          if(NeedToAddList(rec))then
          begin
            if(CheckBox2.Checked)and((ExtractFileExt(rec.name) = '.java'))then
            begin
              classDir := StringReplace(dir, '\src\', '\classes\', [rfReplaceAll, rfIgnoreCase]);
              classString := ExtractFileBody(rec.Name) + '*.class';
              if (FindFirst(classDir + classString, faAnyFile, rec2) = 0) then
              begin
                repeat
                  if (rec2.Attr and faDirectory <> 0) then
                  begin
                    if ((rec2.Name='.') or (rec2.Name='..')) then
                    begin
                      Continue;
                    end;
                  end
                  else
                  begin
                    resultValue := classDir + rec2.Name;
                    if(CheckBox6.Checked)then resultValue := StringReplace(resultValue, '\','/', [rfReplaceAll, rfIgnoreCase]);
                    progress.SetDetail(resultValue);
                    searchList.Add(resultValue);
                  end;
                  Application.ProcessMessages();
                until (FindNext(rec2) <> 0) or (Result <> '');
              end;
            end else begin
              resultValue := Dir + rec.Name;
              if(CheckBox6.Checked)then resultValue := StringReplace(resultValue, '\','/', [rfReplaceAll, rfIgnoreCase]);
              progress.SetDetail(resultValue);
              searchList.Add(resultValue);
            end;
          end;
        end;
        Application.ProcessMessages();
      until (FindNext(Rec) <> 0) or (Result <> '');
    finally
       FindClose(Rec);
    end;
  end;
end;
{$endregion}

{$region 'ファイルから拡張子をはずした部分を返す'}
function TForm3.ExtractFileBody(const Path: string): string;
var
  name: string;
  ext: string;
  lext: integer;
begin
  name := ExtractFileName(Path);
  ext := ExtractFileExt(Path);
  lext := length(ext);
  if lext > 0 then
  begin
    Result := Copy(name, 1, length(name)-lext);
  end
  else
  begin
    Result := name;
  end;
end;
{$endregion}

{$region '見つかったファイルは条件に一致しているか？'}
function TForm3.NeedToAddList(rec : TSearchRec): Boolean;
var
  Extentions : TStringList;
  extOK : Boolean;
  dateOK : Boolean;
  i : Integer;
begin
  extOK := false;
  dateOK := false;
  Extentions := Self.GetMask();
  if (Extentions.Count = 0)then
  begin
    extOK := true;
  end
  else
  begin
    for i := 0 to Extentions.Count - 1 do
    begin
      if(extOK)then break;
      extOK := (AnsiUpperCase(ExtractFileExt(rec.name)) = AnsiUpperCase(Extentions.Strings[i]));
      if(Extentions.Strings[i] = '.jar')then dateOK := true;
    end;
  end;
  if(extOK and not dateOK)then
  begin
    if (Self.CheckBox1.Checked) then
    begin
      dateOK := true;
    end
    else
    begin
      dateOK := (rec.Time >= DateTimeToFileDate(dtFrom)) and (rec.Time <= DateTimeToFileDate(dtTo));
    end;
  end;
  result := (extOK and dateOK);
end;
{$endregion}

{$endregion}

{$region 'メニューバー関連'}

{$region 'ファイル ⇒　保存'}
procedure TForm3.mnuSaveClick(Sender: TObject);
var
  slDetail : TStringList;
  sFileName : String;
  b : Boolean;
begin
  slDetail := GetListDetailInfo();
  with TSaveDialog.Create(Self) do
  begin
    InitialDir := CURRENT_DIR;
    FileName := 'FileSearchSetting' + FormatDateTime('yyyymmddhhnnss', Now) + '.fss';
    Filter := FSS_FILTER;
    b := Execute();
    sFileName := FileName;
    Free();
  end;
  if(b)then
  begin
    slDetail.SaveToFile(sFileName);
  end;
end;
{$endregion}

{$region '保存するデータ収集'}
function TForm3.GetListDetailInfo():TStringList;
var
  sl : TStringList;
  sExt, sOnOff : String;
  i : Integer;
  s : String;
begin
    sl := TStringList.Create();
  try
    sl.Add(DETAIL_STRING);
    with CheckListBox1 do
    begin
      for i := 0 to Items.Count - 1 do
      begin
        sOnOff := '0';
        sExt := Items[i];
        if(Checked[i])then sOnOff := '1';
        sl.Add(sOnOff + #8 + sExt);
      end;
    end;
    sl.Add(BLOCK_STRING);
    with CheckListBox2 do
    begin
      for i := 0 to Items.Count - 1 do
      begin
        sOnOff := '0';
        sExt := Items[i];
        if(Checked[i])then sOnOff := '1';
        sl.Add(sOnOff + #8 + sExt);
      end;
    end;
    sl.Add(JAVA_REPLACE_STRING);
    if(CheckBox2.Checked)then s := '1' else s := '0';
    sl.Add(s);
    sl.Add(DELIMITER_STRING);
    if(CheckBox6.Checked)then s := '1' else s := '0';
    sl.Add(s);
    sl.Add(DATE_USE_STRING);
    if(CheckBox1.Checked)then s := '1' else s := '0';
    sl.Add(s);
    sl.Add(EOF_STRING);
  finally
      result := sl;
  end;
end;
{$endregion}

{$region 'ファイル ⇒　読込'}
procedure TForm3.mnuLoadClick(Sender: TObject);
var
  sFileName : String;
  b : Boolean;
begin
  with TOpenDialog.Create(Self) do
  begin
    InitialDir := CURRENT_DIR;
    Filter := FSS_FILTER;
    b := Execute();
    sFileName := FileName;
    Free();
  end;
  if(b)then
  begin
    LoadFromFss(sFileName);
  end;
end;
{$endregion}

{$region '読み込んで画面へ反映'}
procedure TForm3.LoadFromFss(sFileName: String);
var
  i,j : Integer;
  sl, spliter: TStringList;
  posDetail, posBlock, posJavaReplace, posDelimiter, posDateUse, posEof : Integer;
begin
  sl := TStringList.Create();
  spliter := TStringList.Create();
  try
    sl.LoadFromFile(sFileName);
    posDetail := sl.IndexOf(DETAIL_STRING);
    posBlock := sl.IndexOf(BLOCK_STRING);
    posJavaReplace := sl.IndexOf(JAVA_REPLACE_STRING);
    posDelimiter := sl.IndexOf(DELIMITER_STRING);
    posDateUse := sl.IndexOf(DATE_USE_STRING);
    posEof := sl.IndexOf(EOF_STRING);
    if((posDetail > -1)and (posBlock > -1)and
       (posJavaReplace > -1)and (posDelimiter > -1) and
       (posDateUse > -1)and (posEof > -1))then
    begin
      CheckListBox1.Items.Clear();
      for i := 0 to sl.Count -1 do
      begin
        if((i > posDetail) and (i < posBlock))then
        begin
          spliter.CommaText := sl.Strings[i];
          if(spliter.Count > 1)then
          begin
            with CheckListBox1 do
            begin
              Items.Add(spliter.Strings[1]);
              Checked[Items.Count -1] := (spliter.Strings[0] = '1');
            end;
          end;
        end else if((i > posBlock) and (i < posJavaReplace))then
        begin
          spliter.CommaText := sl.Strings[i];
          if(spliter.Count > 1)then
          begin
            with CheckListBox2 do
            begin
              j := Items.IndexOf(spliter.Strings[1]);
              if(j > -1)then
              begin
                Checked[j] := (spliter.Strings[0] = '1');
              end;
            end;
          end;
        end else if((i > posJavaReplace) and (i < posDelimiter))then
        begin
          CheckBox2.Checked := (sl.Strings[i] = '1');
        end else if((i > posDelimiter) and (i < posDateUse))then
        begin
          CheckBox6.Checked := (sl.Strings[i] = '1');
        end else if((i > posDateUse) and (i < posEof))then
        begin
          CheckBox1.Checked := (sl.Strings[i] = '1');
        end;
      end;
    end else begin
      MessageDlg('ファイルフォーマットが変なので処理をしません。', mtError, [mbOK], 0);
    end;
  finally
    sl.Free();
    spliter.Free();
  end;
end;
{$endregion}

{$region 'ファイル ⇒　閉じる'}
procedure TForm3.mnuCloseClick(Sender: TObject);
begin
  Self.Close();
end;
{$endregion}

{$endregion}

end.
