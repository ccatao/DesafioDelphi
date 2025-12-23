unit ClienteRepository;

interface

uses Cliente, FireDAC.Comp.Client, System.SysUtils;

type
  TClienteRepository = class
  public
    function Inserir(ACliente: TCliente): Integer;
    function ListarTodos: TFDQuery;
    procedure ExecutarSQL;
  end;

implementation

uses
  Database;

procedure TClienteRepository.ExecutarSQL;
begin
  { Criado apenas para cumprir com o pedido do desafio de
    exister o método fictício ExecutarSQL }
end;

function TClienteRepository.Inserir(ACliente: TCliente): Integer;
var
  Q: TFDQuery;
begin
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := GetConnection;
    Q.SQL.Text :=
      'INSERT INTO Clientes (Nome, CPF, DataCadastro) ' +
      'VALUES (:Nome, :CPF, GETDATE()); ' +
      'SELECT SCOPE_IDENTITY();';

    Q.ParamByName('Nome').AsString := ACliente.Nome;
    Q.ParamByName('CPF').AsString  := ACliente.CPF;

    Q.Open;
    Result := Q.Fields[0].AsInteger;
  finally
    Q.Free;
  end;
end;

function TClienteRepository.ListarTodos: TFDQuery;
begin

  ExecutarSQL; // utilização do método fictício

  Result := TFDQuery.Create(nil);
  Result.Connection := GetConnection;
  Result.SQL.Text := 'SELECT IdCliente, Nome, CPF, DataCadastro FROM Clientes ORDER BY Nome';
  Result.Open;
end;

end.

