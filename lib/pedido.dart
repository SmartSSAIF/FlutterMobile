class Pedido {

  final int id;
  final int statusPedido;
  final int prioridade;
  final String observacoes;
  final String origem;
  final String destino;

  Pedido({this.id, this.statusPedido, this.prioridade, this.observacoes, this.origem, this.destino});

  Pedido.fromJson(Map<String, dynamic> json) : 
  id = json['idPedido'],
  statusPedido = json['statusPedido'],
  prioridade = json['prioridade'],
  observacoes = json['observacoes'],
  origem = json['origem'].toString(),
  destino = json['destino'].toString();


}