unit VendaService;

interface


type
  TVendaService = class
  public
    procedure IncluirVenda;
  end;

implementation

uses
  System.SysUtils,
  FireDAC.Comp.Client,
  ClienteRepository,
  ModeloRepository,
  VendaRepository,
  Venda;

procedure TVendaService.IncluirVenda;
var
  ClienteRepo: TClienteRepository;
  ModeloRepo: TModeloRepository;
  VendaRepo: TVendaRepository;
  QClientes, QModelos: TFDQuery;
  IdCliente, IdModelo: Integer;
  Valor: Currency;
  Venda: TVenda;
begin
  ClienteRepo := TClienteRepository.Create;
  ModeloRepo  := TModeloRepository.Create;
  VendaRepo   := TVendaRepository.Create;

  try
    // LISTAR CLIENTES
    Writeln('=== CLIENTES CADASTRADOS ===');
    QClientes := ClienteRepo.ListarTodos;
    try
      while not QClientes.Eof do
      begin
        Writeln(
          QClientes.FieldByName('IdCliente').AsInteger, ' - ',
          QClientes.FieldByName('Nome').AsString,
          ' (CPF: ', QClientes.FieldByName('CPF').AsString, ')'
        );
        QClientes.Next;
      end;
    finally
      QClientes.Free;
    end;

    Write('Informe o ID do Cliente: ');
    Readln(IdCliente);

    // LISTAR MODELOS
    Writeln;
    Writeln('=== MODELOS CADASTRADOS ===');
    QModelos := ModeloRepo.ListarTodos;
    try
      while not QModelos.Eof do
      begin
        Writeln(
          QModelos.FieldByName('IdModelo').AsInteger, ' - ',
          QModelos.FieldByName('NomeModelo').AsString,
          ' (Lancamento: ',
          DateToStr(QModelos.FieldByName('DataLancamento').AsDateTime), ')'
        );
        QModelos.Next;
      end;
    finally
      QModelos.Free;
    end;

    Write('Informe o ID do Modelo: ');
    Readln(IdModelo);

    Write('Informe o valor da venda: ');
    Readln(Valor);

    // INSERIR VENDA
    Venda := TVenda.Create;
    try
      Venda.Cliente.Id := IdCliente;
      Venda.Modelo.Id  := IdModelo;
      Venda.Valor     := Valor;
      VendaRepo.Inserir(Venda);
    finally
      Venda.Free;
    end;


    Writeln('Venda cadastrada com sucesso!');
    Writeln;

  finally
    ClienteRepo.Free;
    ModeloRepo.Free;
    VendaRepo.Free;
  end;
end;

end.

