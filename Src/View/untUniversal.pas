unit untUniversal;

interface

uses
  System.SysUtils, System.StrUtils;

function FormatarMoeda(valor: string): string;

implementation

function FormatarMoeda(valor: string): string;
var
  decimais, centena, milhar, milhoes, bilhoes, trilhoes, quadrilhoes: string;
  valorDigitado: string;
  i: Integer;
begin
  Result := EmptyStr;
  valorDigitado := EmptyStr;

  for i := 1 to Length(valor) do
    begin
      if (CharInSet(valor[i], ['0'..'9'])) then
        valorDigitado := valorDigitado + valor[i];
    end;

  if copy(valorDigitado, 1, 1) = '0' then
    valorDigitado := copy(valorDigitado, 2, length(valorDigitado));

  decimais := RightStr(valorDigitado, 2);
  centena := copy(valor, 1, pos(',', valor)-1);

  case Length(decimais) of
    1:
      Result := '0,0' + decimais;
    2:
      Result := '0,' + decimais;
  else
    Result := '0,00';
  end;

  case Length(valorDigitado) of
    3..5:
      case Length(valorDigitado) of
        3:
          begin
            centena := copy(valorDigitado, 1, 1);
            Result := centena + ',' + decimais;
          end;
        4:
          begin
            centena := copy(valorDigitado, 1, 2);
            Result := centena + ',' + decimais;
          end;
        5:
          begin
            centena := copy(valorDigitado, 1, 3);
            Result := centena + ',' + decimais;
          end;
      end;
    6..8:
      case Length(valorDigitado) of
        6:
          begin
            milhar := copy(valorDigitado, 1, 1);
            centena := copy(valorDigitado, 2, 3);
            Result := milhar + '.' + centena + ',' + decimais;
          end;
        7:
          begin
            milhar := copy(valorDigitado, 1, 2);
            centena := copy(valorDigitado, 3, 3);
            Result := milhar + '.' + centena + ',' + decimais;
          end;
        8:
          begin
            milhar := copy(valorDigitado, 1, 3);
            centena := copy(valorDigitado, 4, 3);
            Result := milhar + '.' + centena + ',' + decimais;
          end;
      end;
    9..11:
      case Length(valorDigitado) of
        9:
          begin
            milhoes := copy(valorDigitado, 1, 1);
            milhar := copy(valorDigitado, 2, 3);
            centena := copy(valorDigitado, 5, 3);
            Result := milhoes + '.' + milhar + '.' + centena + ',' + decimais;
          end;
        10:
          begin
            milhoes := copy(valorDigitado, 1, 2);
            milhar := copy(valorDigitado, 3, 3);
            centena := copy(valorDigitado, 6, 3);
            Result := milhoes + '.' + milhar + '.' + centena + ',' + decimais;
          end;
        11:
          begin
            milhoes := copy(valorDigitado, 1, 3);
            milhar := copy(valorDigitado, 4, 3);
            centena := copy(valorDigitado, 7, 3);
            Result := milhoes + '.' + milhar + '.' + centena + ',' + decimais;
          end;
      end;
    12..14:
      case Length(valorDigitado) of
        12:
          begin
            bilhoes := copy(valorDigitado, 1, 1);
            milhoes := copy(valorDigitado, 2, 3);
            milhar := copy(valorDigitado, 5, 3);
            centena := copy(valorDigitado, 8, 3);
            Result := bilhoes + '.' + milhoes + '.' + milhar + '.' + centena + ',' + decimais;
          end;
        13:
          begin
            bilhoes := copy(valorDigitado, 1, 2);
            milhoes := copy(valorDigitado, 3, 3);
            milhar := copy(valorDigitado, 6, 3);
            centena := copy(valorDigitado, 9, 3);
            Result := bilhoes + '.' + milhoes + '.' + milhar + '.' + centena + ',' + decimais;
          end;
        14:
          begin
            bilhoes := copy(valorDigitado, 1, 3);
            milhoes := copy(valorDigitado, 4, 3);
            milhar := copy(valorDigitado, 7, 3);
            centena := copy(valorDigitado, 10, 3);
            Result := bilhoes + '.' + milhoes + '.' + milhar + '.' + centena + ',' + decimais;
          end;
      end;
    15..17:
      case Length(valorDigitado) of                                  //valor := '908.302.145.235.478,9322';
        15:
          begin
            trilhoes := copy(valorDigitado, 1, 1);
            bilhoes := copy(valorDigitado, 2, 3);
            milhoes := copy(valorDigitado, 5, 3);
            milhar := copy(valorDigitado, 8, 3);
            centena := copy(valorDigitado, 11, 3);
            Result := trilhoes + '.' + bilhoes + '.' + milhoes + '.' + milhar + '.' + centena + ',' + decimais;
          end;
        16:
          begin
            trilhoes := copy(valorDigitado, 1, 2);
            bilhoes := copy(valorDigitado, 3, 3);
            milhoes := copy(valorDigitado, 6, 3);
            milhar := copy(valorDigitado, 9, 3);
            centena := copy(valorDigitado, 12, 3);
            Result := trilhoes + '.' + bilhoes + '.' + milhoes + '.' + milhar + '.' + centena + ',' + decimais;
          end;
        17:
          begin
            trilhoes := copy(valorDigitado, 1, 3);
            bilhoes := copy(valorDigitado, 4, 3);
            milhoes := copy(valorDigitado, 7, 3);
            milhar := copy(valorDigitado, 10, 3);
            centena := copy(valorDigitado, 13, 3);
            Result := trilhoes + '.' + bilhoes + '.' + milhoes + '.' + milhar + '.' + centena + ',' + decimais;
          end;
      end;
    18..20:
      case Length(valorDigitado) of                                  //valor := '878.908.302.145.235.478,9322';
        18:
          begin
            quadrilhoes := copy(valorDigitado, 1, 1);
            trilhoes := copy(valorDigitado, 2, 3);
            bilhoes := copy(valorDigitado, 5, 3);
            milhoes := copy(valorDigitado, 8, 3);
            milhar := copy(valorDigitado, 11, 3);
            centena := copy(valorDigitado, 14, 3);
            Result := quadrilhoes + '.' + trilhoes + '.' + bilhoes + '.' + milhoes + '.' + milhar + '.' + centena + ',' + decimais;
          end;
        19:
          begin
            quadrilhoes := copy(valorDigitado, 1, 2);
            trilhoes := copy(valorDigitado, 3, 3);
            bilhoes := copy(valorDigitado, 6, 3);
            milhoes := copy(valorDigitado, 9, 3);
            milhar := copy(valorDigitado, 12, 3);
            centena := copy(valorDigitado, 15, 3);
            Result := quadrilhoes + '.' + trilhoes + '.' + bilhoes + '.' + milhoes + '.' + milhar + '.' + centena + ',' + decimais;
          end;
        20:
          begin
            quadrilhoes := copy(valorDigitado, 1, 3);
            trilhoes := copy(valorDigitado, 4, 3);
            bilhoes := copy(valorDigitado, 7, 3);
            milhoes := copy(valorDigitado, 10, 3);
            milhar := copy(valorDigitado, 13, 3);
            centena := copy(valorDigitado, 16, 3);
            Result := quadrilhoes + '.' + trilhoes + '.' + bilhoes + '.' + milhoes + '.' + milhar + '.' + centena + ',' + decimais;
          end;
      end;
  end;
end;

end.
