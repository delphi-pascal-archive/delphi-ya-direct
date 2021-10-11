unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, OleCtrls, SHDocVw, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, ExtCtrls, Base64, ComCtrls, IniFiles;

type
  TForm1 = class(TForm)
    Panel2: TPanel;
    WebBrowser1: TWebBrowser;
    IdHTTP1: TIdHTTP;
    StatusBar1: TStatusBar;
    Memo1: TMemo;
    Panel1: TPanel;
    Button6: TButton;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Button3: TButton;
    Button4: TButton;
    ProgressBar1: TProgressBar;
    procedure WebBrowser1DocumentComplete(Sender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure StatusBar1DblClick(Sender: TObject);
    procedure StatusBar1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Str: TStringList;
  arres: array of string;
  web2status,web1status,web1l,web1p: string;
  yalogin,yapassword,begunlogin,begunpassword,http,yahttp,begunhttp: string;

implementation

uses TypInfo;

{$R *.dfm}

procedure thinking(s: string);
begin
 Application.ProcessMessages;
 Form1.StatusBar1.SimpleText := s;
 Application.ProcessMessages;
end;

procedure strtoarr(s : string; delimiter : string);
var
  p,cnt,p2: integer;
  ss : string;
begin
  cnt := 0;
  while Pos(delimiter, s)>0 do
   begin
      p := Pos(delimiter, s);
      ss := copy(s,0,p-1);
      //Memo2.Text := Memo2.Text + '***' + ss;
      //Str.Add(ss);
      SetLength(arres,cnt+1);
      arres[cnt]:=ss;
      ss := '';
      p2 := Length(s)-p;
      s := copy(s,p+2,p2);
      cnt := cnt+1;
    end;
end;

procedure TForm1.WebBrowser1DocumentComplete(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
if(web1status = 'login') then
begin
web1status := '';
WebBrowser1.OleObject.Document.getElementById('login-form').style.display := 'block';
WebBrowser1.OleObject.Document.login.login.value := web1l;
WebBrowser1.OleObject.Document.login.passwd.value := web1p;
//WebBrowser1.OleObject.Document.login.submit();
thinking('');
end;

if(web1status = 'loginbegun') then
begin
web1status := '';
WebBrowser1.OleObject.Document.Forms.Item(0).Elements.Item(3).Value := web1l;
WebBrowser1.OleObject.Document.Forms.Item(0).Elements.Item(4).Value := web1p;
thinking('');
end;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
thinking('Авторизация...');
web1l := yalogin;
web1p := yapassword;

web1status := 'login';
WebBrowser1.Navigate(yahttp);
end;

/////////////////////////////
///////////////////////////

function AppendOrWriteTextToFile(FileName : TFilename; WriteText : string): boolean;
 var
   f : Textfile;

 begin
   Result := False;
   AssignFile(f, FileName);
   try
     if FileExists(FileName) = False then
       Rewrite(f)
     else
     begin
       Append(f);
     end;
     Writeln(f, WriteText);
     Result := True;
   finally
     CloseFile(f);
   end;
 end;

///////////////////////////////

procedure TForm1.Button7Click(Sender: TObject);
var
  s,res : String;
  sl:TStringList;
  dir, log : string;
  i,j,k,y : Integer;
  myarres : array of string;
  arres2 : array of array of string;
  tmp,stmp : Variant;
begin
thinking('Обрабатываем страницу...');
s := WebBrowser1.OleObject.Document.body.innerHTML;

sl:=TStringList.create;
sl.add('data='+EncodeBase64(s));

res := idHttp1.post(http+'a=getfieldsbegun',sl);

//dir := ExtractFilePath(Application.Exename);
//log := s;
//AppendOrWriteTextToFile(dir + '\logfile.txt', log);

Memo1.Text := StringReplace(res,'~~',chr(13)+chr(10),[rfReplaceAll,rfIgnoreCase]);

sl.free;

//set values to form
////////////////////////////////////////////////////////////////////////////

 s := res;
 strtoarr(s,'~~');
  SetLength(myarres,length(arres));
  for i := 0 to length(arres)-1 do
    begin
      myarres[i] := arres[i];
    end;
  s:='';
  k := length(myarres);
  SetLength(arres2,k,50);
  for i := 0 to length(myarres)-1 do
    begin
      strtoarr(myarres[i],'##');
      for j := 0 to length(arres)-1 do begin arres2[i][j] := arres[j]; end;
    end;

  tmp := WebBrowser1.OleObject.Document.Forms.Item(4);

  ProgressBar1.Max := (length(arres2)-1);
  ProgressBar1.Position := 0;

  for i := 0 to length(arres2)-1 do
  begin
    ProgressBar1.Position := i;

    for j := 0 to tmp.Length - 1 do
    begin
      if tmp.Item(j).Name = arres2[i][0] then
        begin
          tmp.Item(j).Value := arres2[i][1];

          //tmp.Item(j).Style.backgroundColor := '#DAFAE7';
        
        end;
    end;
  end;

thinking('');//ShowMessage('Готово');
end;

procedure TForm1.FormActivate(Sender: TObject);
var
 Ini: TIniFile;
begin
 Application.Title := Form1.Caption;
 Ini := TIniFile.Create( ExtractFilePath(Application.ExeName)+'\conf.ini' );
 http     := Ini.ReadString( 'Form', 'http','');
 yahttp     := Ini.ReadString( 'Form', 'yahttp','');
 begunhttp     := Ini.ReadString( 'Form', 'begunhttp','');
 yalogin     := Ini.ReadString( 'Form', 'yalogin','');
 yapassword     := Ini.ReadString( 'Form', 'yapassword','');
 begunlogin     := Ini.ReadString( 'Form', 'begunlogin','');
 begunpassword     := Ini.ReadString( 'Form', 'begunpassword','');
 Ini.Free;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
thinking('Авторизация...');
web1l := begunlogin;
web1p := begunpassword;

web1status := 'loginbegun';
WebBrowser1.Navigate(begunhttp);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  s,res : String;
  sl:TStringList;
  dir, log : string;

  i,j,k,y : Integer;
  myarres : array of string;
  arres2 : array of array of string;
  tmp,stmp : Variant;
begin
thinking('Обрабатываем страницу...');
s := WebBrowser1.OleObject.Document.body.innerHTML;

sl:=TStringList.create;
sl.add('data='+EncodeBase64(s));

res := idHttp1.post(http+'a=getfields',sl);

//dir := ExtractFilePath(Application.Exename);
//log := s;
//AppendOrWriteTextToFile(dir + '\logfile.txt', log);

Memo1.Text := StringReplace(res,'~~',chr(13)+chr(10),[rfReplaceAll,rfIgnoreCase]);

sl.free;

//set values to form
////////////////////////////////////////////////////////////////////////////

 s := res;
 strtoarr(s,'~~');
  SetLength(myarres,length(arres));
  for i := 0 to length(arres)-1 do
    begin
      myarres[i] := arres[i];
    end;
  s:='';
  k := length(myarres);
  SetLength(arres2,k,50);
  for i := 0 to length(myarres)-1 do
    begin
      strtoarr(myarres[i],'##');
      for j := 0 to length(arres)-1 do begin arres2[i][j] := arres[j]; end;
    end;

  tmp := WebBrowser1.OleObject.Document.Prices;

  ProgressBar1.Max := (length(arres2)-1);
  ProgressBar1.Position := 0;

  for i := 0 to length(arres2)-1 do
  begin

    ProgressBar1.Position := i;

    for j := 0 to tmp.Length - 1 do
    begin
      if tmp.Item(j).Name = arres2[i][0] then
        begin
          tmp.Item(j).Value := arres2[i][6];
          tmp.Item(j).Style.backgroundColor := '#DAFAE7';

          //status div
          WebBrowser1.OleObject.Document.getElementById('revert_price_' + arres2[i][0]).innerHTML :=
          'YaPos:'+arres2[i][2]+'<br>'+arres2[i][3]+':'+arres2[i][4]+'<br>Max ставка:<b style="color:#990000">'+arres2[i][5]+'</b>';
          WebBrowser1.OleObject.Document.getElementById('revert_price_' + arres2[i][0]).style.fontSize := '11px';
        end;
    end;
  end;

///////////////////////////////////////////////////////////////////////////
thinking('');
//ShowMessage('Готово');
end;

procedure TForm1.StatusBar1DblClick(Sender: TObject);
begin
Memo1.Visible := false;
end;

procedure TForm1.StatusBar1Click(Sender: TObject);
begin
Memo1.Visible := true;
end;

end.
