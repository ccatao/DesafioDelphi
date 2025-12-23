unit VendaRepository;

interface

uses Venda;

type
  TVendaRepository = class
  public
    procedure Inserir(AVenda: TVenda);
  end;

implementation

uses
  Database, FireDAC.Comp.Client;

procedure TVendaRepository.Inserir(AVenda: TVenda);
var
  Q: TFDQuery;
begin
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := GetConnection;
    Q.SQL.Text :=
      'INSERT INTO Vendas (IdCliente, IdModelo, DataVenda, Valor) ' +
      'VALUES (:Cliente, :Modelo, GETDATE(), :Valor)';

    Q.ParamByName('Cliente').AsInteger := AVenda.Cliente.Id;
    Q.ParamByName('Modelo').AsInteger  := AVenda.Modelo.Id;
    Q.ParamByName('Valor').AsCurrency  := AVenda.Valor;

    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

end.

