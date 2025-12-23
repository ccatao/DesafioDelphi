unit Database;

interface

uses
  FireDAC.Comp.Client, FireDAC.Comp.UI, FireDAC.Phys, FireDAC.Phys.MSSQL;

function GetConnection: TFDConnection;
function GerarCPF(const ComPontos: Boolean = True): string;
function GerarDataAleatoriaEntre(const DataInicial, DataFinal: TDateTime): TDateTime;
function GeraCarroVenda: String;

implementation

uses
  System.SysUtils, System.Classes;

var
  FConnection: TFDConnection;
  FDGUIxWaitCursor: TFDGUIxWaitCursor;
  FDPhysDriverLink: TFDPhysDriverLink;
  MSSQLDriverLink: TFDPhysMSSQLDriverLink;

function GetConnection: TFDConnection;
begin

  if not Assigned(FConnection) then
  begin

    FConnection := TFDConnection.Create(nil);

    // componente de Conexão entre a aplicação e o banco de dados. "Traduz" SQL.
    FDPhysDriverLink := TFDPhysDriverLink.Create(nil);
    // driver de conexão com o banco. Utilizado pelo componente anterior e a conexão
    MSSQLDriverLink := TFDPhysMSSQLDriverLink.Create(nil);
    FConnection.DriverName := 'MSSQL';



    // Parâmetros de conexão
    FConnection.Params.Clear;
    FConnection.Params.DriverId := 'MSSQL';
    FConnection.Params.Values['Server']   := 'Cleber';
    FConnection.Params.Values['Database'] := 'DesafioDelphi';
    FConnection.Params.Values['User_Name'] := 'usuario';
    FConnection.Params.Values['Password']  := 'senha';

    // Recomendações FireDAC
    // Encrypt=No e TrustServerCertificate=Yes
    // usados para evitar erro SSL em ambientes locais de teste.
    // Em produção, recomenda-se Encrypt=Yes com certificado válido.
    FConnection.Params.Values['Encrypt'] := 'No';
    FConnection.Params.Values['TrustServerCertificate'] := 'Yes';

    FConnection.LoginPrompt := False;
    FConnection.Connected := True;
  end;

  Result := FConnection;
end;

function GerarDataAleatoriaEntre(const DataInicial, DataFinal: TDateTime): TDateTime;
var
  DiasEntre: Integer;
  DiasAleatorios: Integer;
begin
  // Calcular o número total de dias no período
  // Trunc() é usado para garantir que a diferença seja um número inteiro de dias,
  // útil caso as datas de início/fim incluam horários.
  DiasEntre := Trunc(DataFinal) - Trunc(DataInicial);

  // Garantir que a data inicial seja menor ou igual à data final
  if DiasEntre < 0 then
    raise Exception.Create('A data inicial deve ser anterior ou igual à data final.');

  // Inicializar o gerador de números aleatórios (se ainda não foi feito no início do programa)
  // Randomize;

  // Gerar um número aleatório de dias dentro do intervalo (inclusive o último dia)
  DiasAleatorios := Random(DiasEntre + 1);

  // Adicionar os dias aleatórios à data inicial
  Result := DataInicial + DiasAleatorios;
end;

function GerarCPF(const ComPontos: Boolean = True): string;
var
  n: array[1..11] of Integer;
  i, soma, resto, digito1, digito2: Integer;
  cpf_temp: string;
begin
  // Inicializa o gerador de números aleatórios
  Randomize;

  // Gera os primeiros 9 dígitos aleatórios
  for i := 1 to 9 do
    n[i] := Trunc(Random(10));

  // Calcula o primeiro dígito verificador
  soma := 0;
  for i := 1 to 9 do
    soma := soma + (n[i] * (11 - i));
  resto := (soma * 10) mod 11;
  if (resto = 10) or (resto = 11) then
    digito1 := 0
  else
    digito1 := resto;
  n[10] := digito1;

  // Calcula o segundo dígito verificador
  soma := 0;
  for i := 1 to 10 do
    soma := soma + (n[i] * (12 - i));
  resto := (soma * 10) mod 11;
  if (resto = 10) or (resto = 11) then
    digito2 := 0
  else
    digito2 := resto;
  n[11] := digito2;

  // Formata o CPF (opcionalmente com pontos e hífen)
  if ComPontos then
    cpf_temp := Format('%.1d%.1d%.1d.%.1d%.1d%.1d.%.1d%.1d%.1d-%.1d%.1d',
                       [n[1], n[2], n[3], n[4], n[5], n[6], n[7], n[8], n[9], n[10], n[11]])
  else
    cpf_temp := Format('%.1d%.1d%.1d%.1d%.1d%.1d%.1d%.1d%.1d%.1d%.1d',
                       [n[1], n[2], n[3], n[4], n[5], n[6], n[7], n[8], n[9], n[10], n[11]]);

  Result := cpf_temp;
end;

function GeraCarroVenda: String;
var
  ListaCarros: TStringList;
  IndiceSorteado: Integer;
begin
  try
    // Inicializa o gerador de números aleatórios (importante!)
    Randomize;
    // Cria a lista de 10 carros
    ListaCarros := TStringList.Create;
    try
      ListaCarros.Add('Fiat Marea');
      ListaCarros.Add('Fiat Uno');
      ListaCarros.Add('Volkswagen Gol');
      ListaCarros.Add('Chevrolet Onix');
      ListaCarros.Add('Hyundai HB20');
      ListaCarros.Add('Ford Ka');
      ListaCarros.Add('Renault Kwid');
      ListaCarros.Add('Toyota Corolla');
      ListaCarros.Add('Honda Civic');
      ListaCarros.Add('Jeep Renegade'); // 10º carro
      // Sorteia um índice entre 0 e 9
      IndiceSorteado := Random(ListaCarros.Count);
      // Pega o carro sorteado
      Result := ListaCarros[IndiceSorteado];


    finally
      ListaCarros.Free;
    end;
  except
    on E: Exception do
      Writeln('Erro: ', E.Message);
  end;
end;

end.

