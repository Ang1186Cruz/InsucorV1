class RecentFile {
  final String? date, customer, invoice, status, import;

  RecentFile(
      {this.date, this.customer, this.invoice, this.status, this.import});
}

List demoListRouters = [
  RecentFile(
    date: "01-03-2021",
    customer: "GREDESA S.A.S",
    invoice: "27870",
    status: "PENDIENTE A COBRAR",
    import: "124,830.05",
  ),
  RecentFile(
    date: "01-03-2021",
    customer: "VIGLIONE CARLOS ALBERTO",
    invoice: "27934",
    status: "PENDIENTE A COBRAR",
    import: "144,330.05",
  ),
  RecentFile(
    date: "01-03-2021",
    customer: "GREDESA S.A.S",
    invoice: "27870",
    status: "PENDIENTE A COBRAR",
    import: "124,830.05",
  ),
  RecentFile(
    date: "01-03-2021",
    customer: "SUCESION DE WENDELER JUAN PEDRO",
    invoice: "27872",
    status: "PENDIENTE A COBRAR",
    import: "14,430.05",
  ),
  RecentFile(
    date: "01-03-2021",
    customer: "MORCILLO OSVALDO HORACIO",
    invoice: "27878",
    status: "PENDIENTE A COBRAR",
    import: "24,830.05",
  ),
];
