program RemoverCaracteres;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Classes,
  uFunctions in 'uFunctions.pas';

var
  lArquivo: string;
  lFuncao: Integer;
begin
  lArquivo := ParamStr(1);
  lFuncao := StrToIntDef(ParamStr(2), 1);

  case lFuncao of
    1: TFunctions.RemoverAcentos(lArquivo);
    2: TFunctions.RemoverAspas(lArquivo);
  end;
end.
