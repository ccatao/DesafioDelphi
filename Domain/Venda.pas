unit Venda;

interface

uses Cliente, Modelo;

type
  TVenda = class
  private
    FCliente: TCliente;
    FModelo: TModelo;
    FDataVenda: TDate;
    FValor: Currency;
  public
    constructor Create; overload;
    constructor Create(ACliente: TCliente; AModelo: TModelo; AValor: Currency); overload;
    property Cliente: TCliente read FCliente write FCliente;
    property Modelo: TModelo read FModelo write FModelo;
    property DataVenda: TDate read FDataVenda write FDataVenda;
    property Valor: Currency read FValor write FValor;
  end;

implementation

uses System.SysUtils;


constructor TVenda.Create;
begin
  inherited Create;

end;

constructor TVenda.Create(ACliente: TCliente; AModelo: TModelo; AValor: Currency);
begin
  FCliente := ACliente;
  FModelo := AModelo;
  FValor := AValor;
  FDataVenda := Date;
end;

end.

