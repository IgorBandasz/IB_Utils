unit uFunctions;

interface

type
  TFunctions = class
  private
    { private declarations }
    class function RemoverPosicaoString(const pTexto: string;
                                        const pPosicao: Integer):string;
  protected
    { protected declarations }
  public
    { public declarations }
    class procedure RemoverAcentos(const pPath: string);
    class procedure RemoverAspas(const pPath: string);
  end;

implementation

uses
  System.SysUtils,
  Classes;

const
  ComAcentos: array[0..25] of Char = ('á', 'à', 'ã', 'â', 'é', 'è', 'ê', 'í', 'ó', 'ô', 'õ', 'ú',
                                      'Á', 'À', 'Ã', 'Â', 'É', 'È', 'Ê', 'Í', 'Ó', 'Ô', 'Õ', 'Ú',
                                      'ç', 'Ç');
  SemAcentos: array[0..25] of Char = ('a', 'a', 'a', 'a', 'e', 'e', 'e', 'i', 'o', 'o', 'o', 'u',
                                      'A', 'A', 'A', 'A', 'E', 'E', 'E', 'I', 'O', 'O', 'O', 'U',
                                      'c', 'C');
{ TFunctions }

class procedure TFunctions.RemoverAcentos(const pPath: string);
var
  lStringList: TStringList;
  lLinha: string;
  lPos: Integer;
  lPosLinha: Integer;
  lPosArray: Integer;
begin
  try
    lStringList := TStringList.Create;
    try
      lStringList.LoadFromFile(pPath);

      for lPos := 0 to lStringList.Count - 1 do
      begin
        lLinha := lStringList.Strings[lPos];

        //Remover letras acentuadas
        for lPosLinha := 1 to Length(lLinha) do
          for lPosArray := 0 to High(ComAcentos) do
            if lLinha[lPosLinha] = ComAcentos[lPosArray] then
              lLinha[lPosLinha] := SemAcentos[lPosArray];

        //Remover acentos soltos
        for lPosLinha := Length(lLinha) downto 1 do
          if CharInSet(lLinha[lPosLinha], ['~','^','`','´']) then
            lLinha := RemoverPosicaoString(lLinha, lPosLinha);

        lStringList.Strings[lPos] := lLinha;
      end;

      lStringList.SaveToFile(pPath);
    finally
      FreeAndNil(lStringList);
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end;

class procedure TFunctions.RemoverAspas(const pPath: string);
var
  lStringList: TStringList;
  lLinha: string;
  lPos: Integer;
  lPosLinha: Integer;
begin
  try
    lStringList := TStringList.Create;
    try
      lStringList.LoadFromFile(pPath);

      for lPos := 0 to lStringList.Count - 1 do
      begin
        lLinha := lStringList.Strings[lPos];

        for lPosLinha := Length(lLinha) downto 1  do
          if CharInSet(lLinha[lPosLinha], ['''','"']) then
            lLinha := RemoverPosicaoString(lLinha, lPosLinha);

        lStringList.Strings[lPos] := lLinha;
      end;

      lStringList.SaveToFile(pPath);
    finally
      FreeAndNil(lStringList);
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end;

class function TFunctions.RemoverPosicaoString(const pTexto: string;
  const pPosicao: Integer): string;
begin
  Result := Copy(pTexto, 1, pPosicao - 1) + Copy(pTexto, pPosicao + 1, Length(pTexto) - pPosicao);
end;

end.
