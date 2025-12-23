unit Modelo;

interface

type
  TModelo = class
  private
    FId: Integer;
    FNome: string;
    FDataLancamento: TDate;
  public
    constructor Create; overload;
    constructor Create(const ANome: string; AData: TDate); overload;
    property Id: Integer read FId write FId;
    property Nome: string read FNome write FNome;
    property DataLancamento: TDate read FDataLancamento write FDataLancamento;
  end;

implementation

constructor TModelo.Create;
begin
  inherited Create;

end;

constructor TModelo.Create(const ANome: string; AData: TDate);
begin
  FNome := ANome;
  FDataLancamento := AData;
end;

end.

