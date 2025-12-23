unit Cliente;

interface

type
  TCliente = class
  private
    FId: Integer;
    FNome: string;
    FCPF: string;
    FDataCadastro: TDate;
  public
    constructor Create; overload;
    constructor Create(const ANome, ACPF: string); overload;
    property Id: Integer read FId write FId;
    property Nome: string read FNome write FNome;
    property CPF: string read FCPF write FCPF;
    property DataCadastro: TDate read FDataCadastro write FDataCadastro;
  end;

implementation

uses System.SysUtils;

constructor TCliente.Create;
begin
  inherited Create;

end;

constructor TCliente.Create(const ANome, ACPF: string);
begin
  FNome := ANome;
  FCPF := ACPF;
  FDataCadastro := Date;
end;

end.

