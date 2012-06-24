unit formResult;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, StdCtrls, Clipbrd, CheckLst, basUnit, ShellAPI,
  FileCtrl, ShlObj, formProgress;

type
  TfrmResult = class(TForm)
    pnl: TPanel;
    Button1: TButton;
    Button2: TButton;
    CheckListBox1: TCheckListBox;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    procedure Button6Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Button5Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CheckListCheckChange(Sender: TObject);
  private
    function GetCheckedItemCount: Integer;
    function GetSpecialFolder(Folder: integer): string;
    procedure SHFileCopy(fromPath, toPath: String);
    procedure allCheckControl(b: Boolean);
    { Private 宣言 }
  public
    { Public 宣言 }
    sl: TStringList;
  end;

var
  frmResult: TfrmResult;

implementation

{$R *.dfm}

{$region '画面全般'}

{$region '画面表示イベント'}
procedure TfrmResult.FormShow(Sender: TObject);
var
  i : Integer;
begin
  Self.ActiveControl := Self.CheckListBox1;
  Self.Caption := '検索結果：' + IntToStr(sl.Count) + 'ファイル';
  sl.Sort();
  with Self.CheckListBox1 do
  begin
    for i := 0 to sl.Count -1 do
    begin
      Items.Add(sl.Strings[i]);
      Checked[i] := true;
    end;
  end;
end;
{$endregion}

{$region '全部ON,OFFイベント'}
procedure TfrmResult.CheckListCheckChange(Sender: TObject);
begin
  Self.AllCheckControl((Sender as TButton).Caption = '全部ON');
end;
{$endregion}

{$region '全部ON,OFF実行部'}
procedure TfrmResult.allCheckControl(b : Boolean);
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

{$region 'クリップボードにコピーボタン'}
procedure TfrmResult.Button1Click(Sender: TObject);
var
  i : Integer;
  slcb : TStringList;
begin
  slcb := TStringList.Create();
  try
    with CheckListBox1 do
    begin
      for i := 0 to Items.Count - 1 do
      begin
        if(Checked[i])then slcb.Add(Items[i]);
      end;
    end;
    Clipboard.AsText := slcb.Text;
  finally
    slcb.Free();
  end;
end;
{$endregion}

{$region 'ファイルに保存ボタン'}
procedure TfrmResult.Button5Click(Sender: TObject);
var
  i : Integer;
  slcb : TStringList;
  sFileName : String;
  b : Boolean;
begin
  slcb := TStringList.Create();
  try
    with CheckListBox1 do
    begin
      for i := 0 to Items.Count - 1 do
      begin
        if(Checked[i])then slcb.Add(Items[i]);
      end;
    end;
    with TSaveDialog.Create(Self) do
    begin
      InitialDir := GetSpecialFolder(CSIDL_DESKTOP);
      FileName := 'FileSearchResult' + FormatDateTime('yyyymmddhhnnss', Now) + '.txt';
      Filter := RESULT_FILTER;
      b := Execute();
      sFileName := FileName;
      Free();
    end;
    if(b)then
    begin
      slcb.SaveToFile(sFileName);
    end;
  finally
    slcb.Free();
  end;
end;
{$endregion}

{$region '閉じるボタン'}
procedure TfrmResult.Button2Click(Sender: TObject);
begin
  Self.Close();
end;
{$endregion}

{$region 'Formのショートカットキー'}
procedure TfrmResult.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE : Self.Close();
    VK_F12 : Self.Button5.OnClick(Self.Button5);
  end;
end;
{$endregion}

{$region 'コピーボタン'}
procedure TfrmResult.Button6Click(Sender: TObject);
var
  toPath : string;
  toFile : String;
  fromFile : string;
  i : Integer;
  frm : TfrmPregress;
begin
  pnl.Enabled := false;
  frm := TfrmPregress.Create(Self);
  try
   toPath := GetSpecialFolder(CSIDL_DESKTOP);
   if SelectDirectory('フォルダの指定',
                      '.',
                      toPath,
                      [sdNewUI,sdNewFolder,sdShowEdit],
                      Self) then
    begin
      frm.SetTitle('コピー中');
      frm.ProgressBar1.Min := 0;
      frm.ProgressBar1.Max := Self.GetCheckedItemCount();
      frm.Show();
      with CheckListBox1 do
      begin
        toPath := toPath + '\' + 'FileSearchCopyTo' + FormatDateTime('yyyymmddhhnnss', Now);
        for i := 0 to Items.Count -1 do
        begin
          if(Checked[i])then
          begin
            fromFile := StringReplace(Items[i], '/', '\', [rfReplaceAll, rfIgnoreCase]);
            fromFile := StringReplace(fromFile, '\\', '\', [rfReplaceAll, rfIgnoreCase]);
            if(Copy(fromFile, 1, 1) = '.')then
            begin
              fromFile := Copy(fromFile, 2, Length(fromFile));
            end;
            toFile := fromFile;
            if(Copy(fromFile, 1, 1) = '\')then
            begin
              fromFile := Copy(fromFile, 2, Length(fromFile));
            end;
            fromFile := ExtractFilePath(Application.ExeName) + fromFile;
            toFile := toPath + toFile;
            toFile := ExtractFilePath(toFile);
            if(not(FileExists(toFile)))then
            begin
              ForceDirectories(toFile);
            end;
            frm.SetDetail(fromFile);
            SHFileCopy(fromFile, toFile);
          end;
        end;
      end;
      frm.Close();
    end;
  finally
    pnl.Enabled := true;
    frm.Free();
  end;
end;
{$endregion}

{$region '画面でチェックされているItemの数を得る'}
function TfrmResult.GetCheckedItemCount():Integer;
var
  i : Integer;
  cnt : Integer;
begin
  cnt := 0;
  with CheckListBox1 do
  begin
     for i := 0 to Items.Count -1 do
     begin
       if(Checked[i])then
       begin
          Inc(cnt);
       end;
     end;
  end;
  result := cnt;
end;
{$endregion}


{$endregion}

{$region 'Tools'}

{$region 'OSの特殊なフォルダのパスを得る'}
function TfrmResult.GetSpecialFolder(Folder :integer):string;
var
  Path: array[0..MAX_PATH] of Char;
  pidl: PItemIDList;
begin
  SHGetSpecialFolderLocation(Application.Handle,Folder,pidl);
  SHGetPathFromIDList(pidl,Path);
  Result :=Path;
end;
{$endregion}

{$region 'SHFileOperationでコピーのラッパ'}
procedure TfrmResult.SHFileCopy(fromPath, toPath : String);
var
  foStruct:  TSHFileOpStruct;
begin
  with foStruct do
  begin
    wnd                :=   Self.Handle;
    wFunc              :=   FO_COPY;
    pFrom              :=   PChar(FromPath + #0);
    pTo                :=   PChar(ToPath   + '\' + #0);
    fFlags             :=   FOF_NOCONFIRMATION
                         or FOF_ALLOWUNDO
                         or FOF_NOCONFIRMMKDIR
                         or FOF_SILENT;
    fAnyOperationsAborted   :=   False;
    hNameMappings      :=   nil;
    lpszProgressTitle  :=   nil;
  end;
  try
    SHFileOperation(foStruct);
    Application.ProcessMessages();
  except
  end;
end;
{$endregion}

{$endregion}

end.
