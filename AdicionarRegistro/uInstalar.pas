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

{$R *.dfm}

{ TForm1 }

procedure TfrmInstalar.AdicionarMenuContexto;
begin
  AdicionarOpcaoMenuContexto('\*\shell\IB_Utils', 'MUIVerb', 'IB Utils');
  AdicionarOpcaoMenuContexto('\*\shell\IB_Utils', 'Icon', '"C:\Program Files\IB_Utils\icons\IB_Utils.ico"');
  AdicionarOpcaoMenuContexto('\*\shell\IB_Utils', 'subcommands', '');

  AdicionarOpcaoMenuContexto('\*\shell\IB_Utils\shell\RemoverAcentos', 'MUIVerb', 'Remover Acentos');
  AdicionarOpcaoMenuContexto('\*\shell\IB_Utils\shell\RemoverAcentos', 'Icon', '"C:\Program Files\IB_Utils\icons\RemoverAcentos.ico"');
  AdicionarOpcaoMenuContexto('\*\shell\IB_Utils\shell\RemoverAcentos\command', '', '"C:\Program Files\IB_Utils\RemoverCaracteres.exe" "%1" 1');

  AdicionarOpcaoMenuContexto('\*\shell\IB_Utils\shell\RemoverAspas', 'MUIVerb', 'Remover Aspas');
  AdicionarOpcaoMenuContexto('\*\shell\IB_Utils\shell\RemoverAspas', 'Icon', '"C:\Program Files\IB_Utils\icons\RemoverAspas.ico"');
  AdicionarOpcaoMenuContexto('\*\shell\IB_Utils\shell\RemoverAspas\command', '', '"C:\Program Files\IB_Utils\RemoverCaracteres.exe" "%1" 2');
end;

procedure TfrmInstalar.AdicionarOpcaoMenuContexto(const pKey: string;
  const pCampo: string; const pValor: string);
var
  Reg: TRegistry;
  ArquivoExe: string;
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
  lResourceStream :=  TResourceStream.Create(, pResourceName, RT_RCDATA);
  try
    lFileStream := TFileStream.Create(pFileName, Create);

    lFileStream.CopyFrom(lResourceStream, 0);
  finally
    lResourceStream.Free;
  end;
end;

procedure TfrmInstalar.RecuperarArquivos;
begin
  if not DirectoryExists('C:\Program Files\IB_Utils') then
    CreateDir('C:\Program Files\IB_Utils');

  RecuperarArquivo('REMOVER_CARACTERES', 'C:\Program Files\IB_Utils\RemoverCaracteres.exe');
end;

procedure TfrmInstalar.RemoverArquivos;
begin
//
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
