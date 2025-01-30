unit uInstalar;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Registry, ShellAPI, Vcl.StdCtrls;

type
  TfrmInstalar = class(TForm)
    btnInstalar: TButton;
    btnDesinstalar: TButton;
    procedure btnInstalarClick(Sender: TObject);
    procedure btnDesinstalarClick(Sender: TObject);
  private
    { Private declarations }
    procedure AdicionarOpcaoMenuContexto(const pKey: string;
                                         const pCampo: string;
                                         const pValor: string);
    procedure RemoverOpcaoMenuContexto(const pKey: string);
    procedure RecuperarArquivo(const pResourceName: string;
                               const pFileName: string);
    procedure DescompactarArquivo(const pArquivo: string;
                                  const pDestino: string);

    procedure AdicionarMenuContexto;
    procedure RecuperarArquivos;

    procedure RemoverMenuContexto;
    procedure RemoverArquivos;

    procedure Instalar;
    procedure Desinstalar;
  public
    { Public declarations }
  end;

var
  frmInstalar: TfrmInstalar;

implementation

uses
  System.Zip,
  System.IOUtils;

{$R *.dfm}

{ TForm1 }

procedure TfrmInstalar.AdicionarMenuContexto;
begin
  AdicionarOpcaoMenuContexto('\*\shell\IB_Utils', 'MUIVerb', 'IB Utils');
  AdicionarOpcaoMenuContexto('\*\shell\IB_Utils', 'Icon', '"C:\Program Files (x86)\IB_Utils\icons\IB_Utils.ico"');
  AdicionarOpcaoMenuContexto('\*\shell\IB_Utils', 'subcommands', '');

  AdicionarOpcaoMenuContexto('\*\shell\IB_Utils\shell\RemoverAcentos', 'MUIVerb', 'Remover Acentos');
  AdicionarOpcaoMenuContexto('\*\shell\IB_Utils\shell\RemoverAcentos', 'Icon', '"C:\Program Files (x86)\IB_Utils\icons\RemoverAcentos.ico"');
  AdicionarOpcaoMenuContexto('\*\shell\IB_Utils\shell\RemoverAcentos\command', '', '"C:\Program Files (x86)\IB_Utils\RemoverCaracteres.exe" "%1" 1');

  AdicionarOpcaoMenuContexto('\*\shell\IB_Utils\shell\RemoverAspas', 'MUIVerb', 'Remover Aspas');
  AdicionarOpcaoMenuContexto('\*\shell\IB_Utils\shell\RemoverAspas', 'Icon', '"C:\Program Files (x86)\IB_Utils\icons\RemoverAspas.ico"');
  AdicionarOpcaoMenuContexto('\*\shell\IB_Utils\shell\RemoverAspas\command', '', '"C:\Program Files (x86)\IB_Utils\RemoverCaracteres.exe" "%1" 2');
end;

procedure TfrmInstalar.AdicionarOpcaoMenuContexto(const pKey: string;
  const pCampo: string; const pValor: string);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create(KEY_WRITE);
  try
    Reg.RootKey := HKEY_CLASSES_ROOT;

    if Reg.OpenKey(pKey, True) then
    begin
      Reg.WriteString(pCampo, pValor);
    end;
  finally
    Reg.Free;
  end;
end;

procedure TfrmInstalar.btnInstalarClick(Sender: TObject);
begin
  Instalar;
end;

procedure TfrmInstalar.DescompactarArquivo(const pArquivo, pDestino: string);
begin
  // Verifica se o arquivo .zip existe
  if not FileExists(pArquivo) then
    raise Exception.Create('Arquivo .zip não encontrado!');

  // Verifica se o diretório de destino existe, se não, cria
  if not DirectoryExists(pDestino) then
    ForceDirectories(pDestino);

  // Descompacta o arquivo .zip para o diretório de destino
  TZipFile.ExtractZipFile(pArquivo, pDestino);
end;

procedure TfrmInstalar.Desinstalar;
begin
  RemoverMenuContexto;

  RemoverArquivos;
end;

procedure TfrmInstalar.Instalar;
begin
  RecuperarArquivos;

  AdicionarMenuContexto;
end;

procedure TfrmInstalar.btnDesinstalarClick(Sender: TObject);
begin
  Desinstalar;
end;

procedure TfrmInstalar.RecuperarArquivo(const pResourceName, pFileName: string);
var
  lResourceStream: TResourceStream;
  lFileStream: TFileStream;
begin
  lResourceStream :=  TResourceStream.Create(HInstance, pResourceName, RT_RCDATA);
  try
    lFileStream := TFileStream.Create(pFileName, fmCreate);
    try
      lFileStream.CopyFrom(lResourceStream, 0);
    finally
      lFileStream.Free;
    end;
  finally
    lResourceStream.Free;
  end;
end;

procedure TfrmInstalar.RecuperarArquivos;
begin
  if not DirectoryExists('C:\Program Files (x86)\IB_Utils') then
    CreateDir('C:\Program Files (x86)\IB_Utils');

  RecuperarArquivo('REMOVER_CARACTERES', 'C:\Program Files (x86)\IB_Utils\RemoverCaracteres.exe');
  RecuperarArquivo('ICONS', 'C:\Program Files (x86)\IB_Utils\Icons.zip');

  DescompactarArquivo('C:\Program Files (x86)\IB_Utils\Icons.zip', 'C:\Program Files (x86)\IB_Utils\Icons');

  try
    TFile.Copy(ParamStr(0), 'C:\Program Files (x86)\IB_Utils\uninstall.exe', True);
  except
    on E: Exception do
      WriteLn('Erro ao copiar o arquivo: ' + E.Message);
  end;
end;

procedure TfrmInstalar.RemoverArquivos;
var
  lCaminhoExecutavel: string;
  lCaminhoScript: string;
  lScript: TStringList;
begin
  // Obtém o caminho do executável
  lCaminhoExecutavel := 'C:\Program Files (x86)\IB_Utils\';

  // Define o caminho do script .bat
  lCaminhoScript := ExtractFilePath(ParamStr(0)) + 'ApagarPasta.bat';

  // Cria o script .bat
  lScript := TStringList.Create;
  try
    lScript.Add(':Repeat');
    lScript.Add('del "' + lCaminhoExecutavel + '*.*" /s /q'); // Exclui todos os arquivos
    lScript.Add('rmdir "' + lCaminhoExecutavel + '" /s /q');  // Exclui a pasta
    lScript.Add('if exist "' + lCaminhoExecutavel + '" goto Repeat'); // Repete se a pasta ainda existir
    lScript.SaveToFile(lCaminhoScript);
  finally
    lScript.Free;
  end;

  // Executa o script .bat após o encerramento do programa
  WinExec(PAnsiChar(AnsiString('cmd.exe /c "' + lCaminhoScript + '"')), SW_HIDE);
end;

procedure TfrmInstalar.RemoverMenuContexto;
begin
  RemoverOpcaoMenuContexto('\*\shell\RemoverAcentos\command');
  RemoverOpcaoMenuContexto('\*\shell\RemoverAcentos');
end;

procedure TfrmInstalar.RemoverOpcaoMenuContexto(const pKey: string);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create(KEY_WRITE);
  try
    Reg.RootKey := HKEY_CLASSES_ROOT;

    // Remover a chave do menu de contexto
    Reg.DeleteKey(pKey);
  finally
    Reg.Free;
  end;
end;

end.
