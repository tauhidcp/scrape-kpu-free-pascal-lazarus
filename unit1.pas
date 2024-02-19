unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Webdriver4L, httpsend, ssl_openssl;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    GroupBox1: TGroupBox;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  Robot : TWebDriver;
  kabupaten_kota, kecamatan, kelurahan_desa, tps : TWebElements;
  urlkab, urlkec, urldesa, urltps : String;
  i : integer;

  const
    main_url = 'https://pemilu2024.kpu.go.id';


implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  {$IFDEF WINDOWS}
  Robot := TChromeDriver.Create(nil);
  Robot.StartDriver(ExtractFileDir(Paramstr(0)) + '\chromedriver.exe');
  {$ELSE}
  //Robot := TChromeDriver.Create(nil);
  Robot := TFireFoxDriver.Create(nil);
  //Robot.StartDriver(ExtractFileDir(Paramstr(0)) + '/chromedriver');
  Robot.StartDriver(ExtractFileDir(Paramstr(0)) + '/geckodriver');
  {$ENDIF}
  Robot.NewSession;
  Robot.Implicitly_Wait(1000);
  Robot.Set_Window_Size(640, 640);
  Robot.GetURL(main_url+'/pilpres/hitung-suara/52');
  Sleep(2000);
  kabupaten_kota := Robot.FindElementsByXPath('//*[@id="main"]/div[3]/div[2]/div[2]/div[2]/div/div/table/tbody/tr/td[1]/a');
  Memo1.Clear;
  Memo1.Append('=== Data Kabupaten/Kota ===');
  for i := 0 to kabupaten_kota.Count - 1 do
  begin
       Memo1.Append(kabupaten_kota.Items[i].Text);
       if (kabupaten_kota.Items[i].Text='KOTA MATARAM') then urlkab:=kabupaten_kota.Items[i].AttributeValue('href');
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Robot.GetURL(main_url+urlkab);
  Sleep(2000);
  kecamatan := Robot.FindElementsByXPath('//*[@id="main"]/div[3]/div[2]/div[2]/div[2]/div/div/table/tbody/tr/td[1]/a');
  Memo1.Append('=== Data Kecamatan ===');
  for i := 0 to kecamatan.Count - 1 do
  begin
       Memo1.Append(kecamatan.Items[i].Text);
       if (kecamatan.Items[i].Text='SELAPARANG') then urlkec:=kecamatan.Items[i].AttributeValue('href');
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Robot.GetURL(main_url+urlkec);
  Sleep(2000);
  kelurahan_desa := Robot.FindElementsByXPath('//*[@id="main"]/div[3]/div[2]/div[2]/div[2]/div/div/table/tbody/tr/td[1]/a');
  Memo1.Append('=== Data Kelurahan/Desa ===');
  for i := 0 to kelurahan_desa.Count - 1 do
  begin
       Memo1.Append(kelurahan_desa.Items[i].Text);
       if (kelurahan_desa.Items[i].Text='REMBIGA') then urldesa:=kelurahan_desa.Items[i].AttributeValue('href');
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  Robot.GetURL(main_url+urldesa);
  Sleep(2000);
  tps := Robot.FindElementsByXPath('//*[@id="main"]/div[3]/div[2]/div[2]/div[2]/div/div/table/tbody/tr/td[1]/a');
  Memo1.Append('=== Data TPS ===');
  for i := 0 to tps.Count - 1 do
  begin
       Memo1.Append(tps.Items[i].Text);
       if (tps.Items[i].Text='TPS 002') then urltps:=tps.Items[i].AttributeValue('href');
  end;
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  anies, prabowo, ganjar : TWebElement;
begin
  Robot.GetURL(main_url+urltps);
  Sleep(2000);
  anies := Robot.FindElementByXPath('/html/body/div/div[1]/div/div[3]/div[2]/div[2]/div/div/div[1]/table[2]/tbody/tr[1]/td[3]');
  prabowo := Robot.FindElementByXPath('/html/body/div/div[1]/div/div[3]/div[2]/div[2]/div/div/div[1]/table[2]/tbody/tr[2]/td[3]');
  ganjar := Robot.FindElementByXPath('/html/body/div/div[1]/div/div[3]/div[2]/div[2]/div/div/div[1]/table[2]/tbody/tr[3]/td[3]');
  Memo1.Append('=== Hasil Perhitungan ===');
  Memo1.Append('Anies-Muhaimain : '+anies.Text);
  Memo1.Append('Prabowo-Gibran : '+prabowo.Text);
  Memo1.Append('Ganjar-Mahfud : '+ganjar.Text);
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  Robot.ExecuteScript('var xpath = "/html/body/div/div[1]/div/div[3]/div[2]/div[2]/div/div/button";'+
                        'function getElementByXpath(path) {'+
                        'return document.evaluate('+
                        '  path,'+
                        '  document,'+
                        '  null,'+
                        '  XPathResult.FIRST_ORDERED_NODE_TYPE,'+
                        '  null'+
                        ').singleNodeValue;'+
                        '}'+
                        'var element = getElementByXpath(xpath);'+
                        'if (!element) {'+
                        'throw new Error("Error: cannot find an element with XPath(" + xpath + ")");'+
                        '}'+
                        'element.click();');
end;

procedure TForm1.Button7Click(Sender: TObject);
var
  c1_hasil : TWebElements;
  httpClient: THTTPSend;
begin
  c1_hasil := Robot.FindElementsByXPath('/html/body/div/div[1]/div/div[3]/div[2]/div[2]/div/div/div[4]/div[2]/div/div/a');
  Memo1.Append('=== Download C1 Hasil ===');
  for i := 0 to c1_hasil.Count - 1 do
  begin
       httpClient:= THTTPSend.Create;
       if httpClient.HTTPMethod('GET', c1_hasil.Items[i].AttributeValue('href')) then
            begin
            httpClient.Document.SaveToFile('Download_C1/c1_'+IntToStr(i)+'_xx.jpg');
            Memo1.Append('C1 Hasil Berhasil didownload...');
            end;
       httpClient.Free;
  end;
end;

end.

