unit CadastroService;

interface


type
  TCadastroService = class
  public
    procedure InserirDados;
    procedure InserirDadosDB; // método fictício exigido
    procedure CriarClientes;
    procedure CriarModelos;
    procedure CriarVendas;

  end;

implementation

uses
  Cliente, Modelo, Venda,
  ClienteRepository, ModeloRepository, VendaRepository,
  System.SysUtils, FireDAC.Comp.Client, System.Math, Database;

procedure TCadastroService.CriarClientes;
var
  Repo: TClienteRepository;
  C: TCliente;
  I: Integer;
begin
  Repo := TClienteRepository.Create;
  try
    for I := 1 to 5 do
    begin
      C := TCliente.Create('Cliente ' + I.ToString, GerarCPF(false));
      C.Id := Repo.Inserir(C);
    end;
  finally
    Repo.Free;
  end;
end;

procedure TCadastroService.CriarModelos;
var
  Repo: TModeloRepository;
  M: TModelo;
  I: Integer;
  Descricao: String;
begin
  Repo := TModeloRepository.Create;
  try
    for I := 1 to 5 do
    begin
      descricao := GeraCarroVenda;
      M := TModelo.Create( descricao , GerarDataAleatoriaEntre(StrToDate('01/05/2020'),
                                                                          StrToDate('31/12/2023')));
      M.Id := Repo.Inserir(M);
    end;
  finally
    Repo.Free;
  end;
end;

procedure TCadastroService.CriarVendas;
var
  VRepo: TVendaRepository;
  MRepo: TModeloRepository;
  CRepo: TClienteRepository;
  V: TVenda;
  I: Integer;
  QCliente, QModelo: TFDQuery;
  Cliente: TCliente;
  Modelo: TModelo;
  Valor: Integer;
begin
  // Repositórios para manipulação (Pode ser reaproveitado em modelos MVC)
  VRepo := TVendaRepository.Create;
  MRepo := TModeloRepository.Create;
  CRepo := TClienteRepository.Create;

  // Para manipular as classes
  Cliente := TCliente.Create;
  Modelo := TModelo.Create;


  try
    // Para percorrer os valores existentes
    QCliente := CRepo.ListarTodos;
    QModelo := MRepo.ListarTodos;

    try
      for I := 1 to 5 do
      begin
        Modelo.Id := QModelo.FieldByName('idModelo').Value;
        Modelo.Nome := QModelo.FieldByName('NomeModelo').Value;
        Modelo.DataLancamento := QModelo.FieldByName('DataLancamento').Value;

        Cliente.Id := QCliente.FieldByName('idCliente').Value;
        Cliente.Nome := QCliente.FieldByName('Nome').Value;
        Cliente.CPF := QCliente.FieldByName('CPF').Value;
        Cliente.DataCadastro := QCliente.FieldByName('DataCadastro').Value;

        Valor := RandomRange(25000, 100000);

        V := TVenda.Create(Cliente, Modelo, Valor);
        VRepo.Inserir(V);

        QCliente.Next;
        QModelo.Next;
      end;
    finally
      VRepo.Free;
    end;

  finally

  end;
end;

procedure TCadastroService.InserirDados;
begin
  InserirDadosDB; // utilização do método fictício
  CriarClientes;
  CriarModelos;
  CriarVendas;
end;

procedure TCadastroService.InserirDadosDB;
begin
  { Não realiza qualquer função. Apenas utilizado pela necessidade
    de ter o método "fictício" }
end;

end.

