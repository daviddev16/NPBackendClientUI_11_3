unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls,
  UNetworkProbe.TDiscoveryClient,
  UNetworkProbe.TExchangeClient,
  UNetworkProbe.TDiscoveryInformation,
  UNetworkProbe.TDiscoveryResult,
  UNetworkProbe.TUtility,
  System.JSON;

type
  TForm1 = class(TForm)

    EdtJsonCmd: TLabeledEdit;
    Button1: TButton;
    MmLog: TMemo;
    cmdPanel: TPanel;
    Button2: TButton;
    Memo1: TMemo;
    Button3: TButton;

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
     ShowMessage('Informações de conexão: ' + sLineBreak +
                'Provider: ' + JsonValue.GetValue<String>('database_type') + sLineBreak +
                'Endereço servidor: ' + JsonValue.GetValue<String>('address') + sLineBreak +
                'Banco de dados: ' + JsonValue.GetValue<String>('database'));
    end;

  end;
end;

class constructor TForm1.Create;
 begin
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
var
  Result : TDiscoveryResult;

begin
  try
    MmLog.Clear;
    LogMessage('Iniciando pesquisa...');

    Result := DiscoveryClient.Sync();
    ShowMessage('Retorno: ' + Result.GetDiscoveryStatus.ToString);
    if Result.IsFoundStatus() then
    begin

      LogMessage('Endereço encontrado: ' + Result.GetDiscoveryInformation.GetServerAddress);
      if Result.GetDiscoveryInformation.GetServerAddress <> TDiscoveryInformation.NONE_ADDRESS then
      begin
        ServerAddress := Result.GetDiscoveryInformation.GetServerAddress;
        cmdPanel.Enabled := True;
        Button1.Enabled := False;
        LogMessage('Habilitando comandos!');
        ExchangeClient := TExchangeClient.Create(ServerAddress);
      end;
    end
    else
    begin
      ShowMessage('Erro: ' + Result.GetDiscoveryStatus.ToString);
    end;

  except
    on E : Exception do
    begin
      ShowMessage('Exc: ' + E.message);
    end;

  end;
end;

end.
