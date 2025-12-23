program Desafio;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  FireDAC.Phys,
  FireDAC.Phys.MSSQL,
  FireDAC.DApt,
  FireDAC.Stan.Def,
  FireDAC.Stan.Async,
  FireDAC.Phys.MSSQLDef,
  Cliente in 'Domain\Cliente.pas',
  Modelo in 'Domain\Modelo.pas',
  Venda in 'Domain\Venda.pas',
  Database in 'Data\Database.pas',
  CadastroService in 'Services\CadastroService.pas',
  SorteioService in 'Services\SorteioService.pas',
  VendaService in 'Services\VendaService.pas',
  ClienteRepository in 'Data\Repositories\ClienteRepository.pas',
  ModeloRepository in 'Data\Repositories\ModeloRepository.pas',
  VendaRepository in 'Data\Repositories\VendaRepository.pas';

var
  Cadastro: TCadastroService;
  Sorteio: TSorteioService;

begin
  try
    Writeln('=== AVALIACAO TECNICA DELPHI ===');

    Cadastro := TCadastroService.Create;
    Sorteio := TSorteioService.Create;
    try
      Cadastro.InserirDados;
      Cadastro.CriarModelos;
      Cadastro.CriarVendas;
      Sorteio.ExecutarSorteio;
    finally
      Cadastro.Free;
      Sorteio.Free;
    end;

    Writeln('Processo finalizado com sucesso.');
    Readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
