unit ModeloRepository;

interface

uses Modelo, FireDAC.Comp.Client;

type
  TModeloRepository = class
  public
    function Inserir(AModelo: TModelo): Integer;
    function ListarTodos: TFDQuery;
    procedure ExecutarSQL;
  end;

implementation

uses
  Database, System.SysUtils;

procedure TModeloRepository.ExecutarSQL;
begin
  { Criado apenas para cumprir com o pedido do desafio de
    exister o método fictício ExecutarSQL }
end;

function TModeloRepository.Inserir(AModelo: TModelo): Integer;
var
  Q: TFDQuery;
begin
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := GetConnection;
    Q.SQL.Text :=
      'INSERT INTO Modelos (NomeModelo, DataLancamento) ' +
      'VALUES (:Nome, :Data); SELECT SCOPE_IDENTITY();';

    Q.ParamByName('Nome').AsString := AModelo.Nome;
    Q.ParamByName('Data').AsDate   := AModelo.DataLancamento;

    Q.Open;
    Result := Q.Fields[0].AsInteger;
  finally
    Q.Free;
  end;
end;

function TModeloRepository.ListarTodos: TFDQuery;
begin

  ExecutarSQL; // utilização do método fictício
  Result := TFDQuery.Create(nil);
  Result.Connection := GetConnection;
  Result.SQL.Text :=
    'SELECT IdModelo, NomeModelo, DataLancamento FROM Modelos ORDER BY NomeModelo';
  Result.Open;
end;

end.


