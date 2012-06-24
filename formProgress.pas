unit formProgress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls;

type
  TfrmPregress = class(TForm)
    Panel1: TPanel;
    lblTitle: TLabel;
    lblFooter: TLabel;
    ProgressBar1: TProgressBar;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private �錾 }
    b : Boolean;
    cnt : Integer;
  public
    { Public �錾 }
    procedure SetDetail(s: String);
    procedure SetTitle(s: String);
  end;

var
  frmPregress: TfrmPregress;

implementation

{$R *.dfm}

{ TfrmPregress }

{$region 'Form�S��'}

{$region '��ʉ��ɕ\�����镶���ݒ�'}
procedure TfrmPregress.SetDetail(s: String);
begin
  Self.lblFooter.Caption := s;
  Application.ProcessMessages();
end;
{$endregion}

{$region '��ʏ�ɕ\�����镶���ݒ�'}
procedure TfrmPregress.SetTitle(s: String);
begin
  Self.lblTitle.Caption := s;
  Application.ProcessMessages();
end;
{$endregion}

{$region '��ʕ\���C�x���g'}
procedure TfrmPregress.FormShow(Sender: TObject);
begin
  Self.lblTitle.Color := clBtnFace;
  Self.lblFooter.Color := clBtnFace;
  Self.ProgressBar1.Max := 10;
  b := true;
end;
{$endregion}

{$region '�^�C�}�['}
procedure TfrmPregress.Timer1Timer(Sender: TObject);
begin
  if(b)then
  begin
    cnt := cnt + 1;
  end else begin
    cnt := cnt - 1;
  end;
  if(cnt > 10)then
  begin
    b := not b;
  end;
  if(cnt < 0)then
  begin
    b := not b;
  end;
  Self.ProgressBar1.Position := cnt;
end;
{$endregion}

{$endregion}

end.
