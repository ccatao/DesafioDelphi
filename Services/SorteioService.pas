unit SorteioService;

interface

type
  TSorteioService = class
  public
    procedure ExecutarSorteio;
    procedure LimparVendasNaoSorteadas;
  end;

implementation

uses
  Database, FireDAC.Comp.Client, System.SysUtils;

{
procedure TSorteioService.ExecutarSorteio;
var
  Q: TFDQuery;
begin
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := GetConnection;
    Q.SQL.Text :=
      'SELECT TOP 15 C.Nome, C.CPF ' +
      'FROM Vendas V ' +
      'JOIN Clientes C ON C.IdCliente = V.IdCliente ' +
      'JOIN Modelos M ON M.IdModelo = V.IdModelo ' +
      'WHERE M.NomeModelo = ''Marea'' ' +
      'AND YEAR(M.DataLancamento) = 2021 ' +
      'AND C.CPF LIKE ''0%'' ' +
      'GROUP BY C.IdCliente, C.Nome, C.CPF, V.DataVenda ' +
      'HAVING COUNT(*) = 1 ' +
      'ORDER BY V.DataVenda';

    Q.Open;

    while not Q.Eof do
    begin
      Writeln(Q.FieldByName('Nome').AsString, ' - ', Q.FieldByName('CPF').AsString);
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;
}

procedure TSorteioService.ExecutarSorteio;
var
  Q: TFDQuery;
  SorteadoId: Integer;
begin
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := GetConnection;

    Q.SQL.Text :=
          'WITH VendasValidas AS ( ' +
          '    SELECT				 ' +
          '        V.IdVenda AS IdVenda, ' +
          '        C.Nome AS Cliente,' +
          '        C.CPF,' +
          '        M.NomeModelo AS Modelo,' +
          '        V.DataVenda,' +
          '        V.Valor,' +
          '        ROW_NUMBER() OVER (ORDER BY V.DataVenda) AS OrdemVenda' +
          '    FROM Vendas V' +
          '    JOIN Clientes C ON C.IdCliente = V.IdCliente' +
          '    JOIN Modelos M  ON M.IdModelo = V.IdModelo' +
          '    WHERE' +
          '        C.CPF LIKE '+  QuotedStr('0%') + // CPF iniciado em 0
          '        AND M.DataLancamento between ''01/01/2021'' and ''31/12/2021''' + // Apenas modelos 2021
          '        AND NOT EXISTS (                   '+         // regra Marea duplicado
          '            SELECT 1' +
          '            FROM Vendas V2' +
          '            JOIN Modelos M2 ON M2.IdModelo = V2.IdModelo ' +
          '            WHERE V2.IdCliente = V.IdCliente ' +
          '              AND M2.NomeModelo = ''Marea'' ' +
          '            GROUP BY V2.IdCliente ' +
          '            HAVING COUNT(*) > 1 ' +
          '        ) ' +
          ') ' +
          'SELECT * ' +
          'FROM VendasValidas ' +
          'WHERE OrdemVenda <= 15';

    Q.Open;

    { A VERSÃO ANTERIOR FOI FEITA PARA TESTAR APENAS 1 SORTEIO E VALIDAR
    * SE AS INSERÇÕES DOS CLIENTES E MODELOS ESTAVAM FUNCIONANDO.
    * APÓS A VALIDAÇÃO, ESTE CÓDIGO FOI COMENTADO E FOI REALIZADO O SORTEIDO PELA SQL
    * A FIM DE OTIMIZAR A CONSULTA }

 {   if Q.IsEmpty then
    begin
      Writeln('Nenhuma venda encontrada para sorteio.');
      Exit;
    end;


    // Sorteia uma posição aleatória
    Randomize;
    Q.First;
    Q.MoveBy(Random(Q.RecordCount));
    SorteadoId := Q.FieldByName('IdVenda').AsInteger;

    Writeln('===== CLIENTE SORTEADO =====');
    Writeln('Cliente : ', Q.FieldByName('Cliente').AsString);
    Writeln('Modelo  : ', Q.FieldByName('Modelo').AsString);
    Writeln('Valor   : ', FormatFloat('R$ #,##0.00', Q.FieldByName('Valor').AsFloat));
    Writeln;

    // Lista excluídos
    Writeln('===== CLIENTES NÃO SORTEADOS =====');
    Q.First;
    while not Q.Eof do
    begin
      if Q.FieldByName('IdVenda').AsInteger <> SorteadoId then
        Writeln('- ', Q.FieldByName('Cliente').AsString,
                ' | ', Q.FieldByName('Modelo').AsString);

      Q.Next;
    end;

  finally
    Q.Free;
  end;                   }

   if Q.IsEmpty then
    begin
      Writeln('Nenhuma venda elegível para o sorteio.');
      Exit;
    end;

    Writeln('===== VENDAS SORTEADAS (15 PRIMEIRAS) =====');

    while not Q.Eof do
    begin
      Writeln(
        'Cliente: ', Q.FieldByName('Cliente').AsString,
        ' | Modelo: ', Q.FieldByName('Modelo').AsString,
        ' | Data: ', DateToStr(Q.FieldByName('DataVenda').AsDateTime)
      );
      Q.Next;
    end;

  finally
    Q.Free;
  end;

end;


procedure TSorteioService.LimparVendasNaoSorteadas;
var
  Q: TFDQuery;
begin
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := GetConnection;
    Q.SQL.Text :=
      'DELETE V FROM Vendas V ' +
      'LEFT JOIN ( ' +
      '  SELECT TOP 15 C.IdCliente ' +
      '  FROM Vendas V ' +
      '  JOIN Clientes C ON C.IdCliente = V.IdCliente ' +
      '  JOIN Modelos M ON M.IdModelo = V.IdModelo ' +
      '  WHERE M.NomeModelo = ''Marea'' ' +
      '  AND YEAR(M.DataLancamento) = 2021 ' +
      '  AND C.CPF LIKE ''0%'' ' +
      '  GROUP BY C.IdCliente, V.DataVenda ' +
      '  HAVING COUNT(*) = 1 ' +
      '  ORDER BY V.DataVenda ' +
      ') S ON S.IdCliente = V.IdCliente ' +
      'WHERE S.IdCliente IS NULL';

    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

end.

