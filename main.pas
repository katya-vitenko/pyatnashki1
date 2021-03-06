unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
  private
    procedure ButClicked(Sender: TObject);
    procedure CreatFishkas();
    procedure KillOldFihkas();
    function position(const x, y: integer): integer;
    procedure victopia();
    { Private declarations }
  public
    { Public declarations }
  end;

type Tfish = TButton; // ��������� ��� ����� �����, �� �������� ����� - ������� ������

const
  W = 80; // ������ �����
  D = 10; // ��������� ����� �������
  L = D + W; // ��������� ����� "�" � �����
  NXM = 4; // ������ ���� 4�4
  N = 1; M = 16; // ����������� ������� �����
  POLET = 10; POLEL = 10; //��������� ������� ���� ����� �� �����
  prefix = 'Fishka';

var
  Form1: TForm1;
  btn: array[N..M] of Tfish;
  sorseAr: array[N..M] of boolean;
  zeroX, zeroY: integer;
  XYmatrix: array[1..M, 1..2] of integer;

implementation

uses Unit2;

{$R *.dfm}

//������ �����

procedure FormSize;
begin
  Form1.Width := (POLEL * 2) + (L * NXM);
  Form1.Height := (L * NXM) + POLET + 50;
end;

procedure TForm1.FormCreate(Sender: TObject);
var i, ty, lx: integer;
begin
  randomize; i := 0;
   // ��������� ������ ������������ �� ������� ����� ��������� ������� ���������
   // ����� ��� ������ ����� ����
  ty := POLET; lx := POLEL;
  for i := N to M do begin
    XYmatrix[i, 1] := lx;
    XYmatrix[i, 2] := ty;
    lx := lx + L;
    if i mod NXM = 0 then begin
      ty := ty + L;
      lx := POLEL;
    end;
  end;
  FormSize();
end;


procedure TForm1.FormShow(Sender: TObject);
begin
  CreatFishkas();
end;

// ���� �� ������ ���� - "����� ����"

procedure TForm1.N1Click(Sender: TObject);
begin
  KillOldFihkas();
  FormSize();
  CreatFishkas();
end;

{ ���������� ��� �������� ������� � true,
 ������ �������� �� ��������������� ���������� ������ �����
 ������� ���������� ��������� �������
����� ��� ������������ ����� ����}

function dump(): boolean;
var i: integer;
begin
  i := 0;
  for i := N to M do
    sorseAr[i] := true; ;
end;

// ��������������� �������� ������� ��������������� �������� ��������� �������

function choose(): integer;
var i: integer;
begin
  i := 0;
  result := random(M) + 1;
  while sorseAr[result] = false do
    result := random(M) + 1;
  sorseAr[result] := false;
end;

procedure TForm1.CreatFishkas;
// ����� ����, �������� �������� ����
var
  i, ty, lx, ch: integer;
begin
  randomize;
  dump();
 // But.Enabled:=false; BitBtn1.Enabled:=true; BitBtn2.Enabled:=true;
  ty := POLET; lx := POLEL;
  for i := N to M do begin

    btn[i] := Tfish.Create(Self);
    btn[i].Width := W;
    btn[i].Height := W;
    btn[i].Font.Size := 26;
    btn[i].Font.Style := [fsBold];

    ch := choose(); // �������� ��������� ������� ����� 1-16, ����� �� �����������

    btn[i].Left := XYmatrix[ch, 1]; // �������� ���������� �
    btn[i].Top := XYmatrix[ch, 2]; // �������� ���������� �
    btn[i].Tag := ch; // � Tag ����� ������� ������� ��������� �����
    btn[i].Name := prefix + inttostr(i);

    if i <> M then begin
      btn[i].Caption := inttostr(i);
      btn[i].OnClick := ButClicked;
    end else begin // ��� ������ ������, ��� ������� � ����������� OnClick
      btn[i].Caption := '';
      zeroX := btn[i].Left; zeroY := btn[i].Top;
    end;

    btn[i].Parent := Self;

  end;
end;


// ���������� ������� �� ������� ����� ����� � ������ ������ �� �� �����������

function TForm1.position(const x, y: integer): integer;
var i: integer;
begin
  i := 0;
  result := -32;
  for i := N to M do begin
    if ((XYmatrix[i, 1] = x) and (XYmatrix[i, 2] = y)) then begin
      result := i; break;
    end;
  end;
end;


// ����������� ����� �� ����� �������

procedure TForm1.ButClicked(Sender: TObject);
var X, Y, ps: integer;
begin
  X := Tfish(Sender).left; Y := Tfish(Sender).Top;
  if ((X = zeroX + L) and (Y = zeroY)) or
    ((X = zeroX - L) and (Y = zeroY)) or
    ((X = zeroX) and (Y = zeroY + L)) or
    ((X = zeroX) and (Y = zeroY - L)) then begin

    Tfish(Sender).Left := zeroX;
    Tfish(Sender).Top := zeroY;

    Tfish(FindComponent(prefix + inttostr(M))).left := X;
    Tfish(FindComponent(prefix + inttostr(M))).top := Y;

    ps := position(zeroX, zeroY);
    if ps <> -32 then
      Tfish(Sender).Tag := ps else
      ShowMessage('������ � ������ �����. ����������');

    zeroX := X; zeroY := Y;

    victopia(); // �������� - ������ ��� ������ ������
  end;
end;

// �������� - ������ ��� ������ ������...

procedure TForm1.victopia;
var i: integer; b: boolean;
begin
  b := true; i := 0;
  for i := N to M - 1 do
  begin
    if strtoint(Tfish(FindComponent(prefix + inttostr(i))).Caption) <>
      Tfish(FindComponent(prefix + inttostr(i))).Tag then
    begin
      b := false; break;
    end;
  end;
  if b then ShowMessage('�� ��������');
end;


procedure TForm1.KillOldFihkas;
// ���������� ������-�����, ����� ����� ������� ����� ����
var i: integer;
begin
  for i := N to M do
    FreeAndNil(btn[i]);
end;

procedure TForm1.N2Click(Sender: TObject);
begin
  Application.Terminate();
end;

procedure TForm1.N3Click(Sender: TObject);
begin
Form2.show
end;

end.

