unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls,
  UNetworkProbe.TDiscoveryClient, UNetworkProbe.TExchangeClient, System.JSON;

type
  TForm1 = class(TForm)

    EdtJsonCmd: TLabeledEdit;
    Button1: TButton;
    MmLog: TMemo;
    cmdPanel: TPanel;
    Button2: TButton;
    Memo1: TMemo;

    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
    ServerAddress : String;
    procedure LogMessage(Msg : String);
    procedure StartNPSSearch();

  public
    { Public declarations }
    class var DiscoveryClient : TDiscoveryClient;
    class var ExchangeClient : TExchangeClient;
    class constructor Create;
  end;

var
  TTForm1: TForm1;

implementation

{$R *.dfm}

 procedure TForm1.Button2Click(Sender: TObject);
var
  ServerResponse : String;
  JsonValue : TJSONValue;
begin
  Memo1.Clear;
  ServerResponse := '';
  if Assigned(ExchangeClient) then
  begin
    ServerResponse := ExchangeClient.SendRaw(EdtJsonCmd.Text);
  end;
  Memo1.Lines.Add(ServerResponse);

  if ServerResponse.Contains('10054') then
  begin
    cmdPanel.Enabled := False;
    Button1.Enabled := True;
    ExchangeClient.Free;
  end;


  if not (String.IsNullOrEmpty(ServerResponse)) and not (ServerResponse.StartsWith('INTERNAL_ERROR')) then
  begin
    JsonValue := TJSONObject.ParseJSONValue(ServerResponse);
    if JsonValue.GetValue<String>('message', '''') = '''' then
    begin
     ShowMessage('Informa��es de conex�o: ' + sLineBreak +
                'Provider: ' + JsonValue.GetValue<String>('database_type') + sLineBreak +
                'Endere�o servidor: ' + JsonValue.GetValue<String>('address') + sLineBreak +
                'Banco de dados: ' + JsonValue.GetValue<String>('database'));
    end;

  end;
end;

class constructor TForm1.Create;
 begin
   { Initialize the static FList member }
   DiscoveryClient := TDiscoveryClient.Create;

 end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Left :=(Screen.Width-Width)  div 2;
  Top :=(Screen.Height-Height) div 2;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  StartNPSSearch;
end;

procedure TForm1.LogMessage(Msg : String);
begin
  MmLog.Lines.Add(Msg);
end;

procedure TForm1.StartNPSSearch();
begin
  try
    MmLog.Clear;
    LogMessage('Iniciando pesquisa...');
    DiscoveryClient.StartSearch;
    LogMessage('Endere�o encontrado: ' + DiscoveryClient.HostAddress);
    if DiscoveryClient.HostAddress <> TDiscoveryClient.NONE then
    begin
      ServerAddress := DiscoveryClient.HostAddress;
      cmdPanel.Enabled := True;
      Button1.Enabled := False;
      LogMessage('Habilitando comandos!');
      ExchangeClient := TExchangeClient.Create(DiscoveryClient.HostAddress);
    end;

  except
  raise;
    {on E : Exception do
    begin
      LogMessage(e.Message);
    end;}

  end;
end;

end.
