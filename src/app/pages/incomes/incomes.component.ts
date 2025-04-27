import { Component } from '@angular/core';
import { jsPDF } from 'jspdf'; // <-- IMPORTAR librería de PDF
import * as XLSX from 'xlsx'; // <-- IMPORTAR librería de Excel

@Component({
  selector: 'app-incomes',
  imports: [],
  templateUrl: './incomes.component.html',
  styleUrl: './incomes.component.css'
})
export class IncomesComponent {
  mesSeleccionado: string = '';
  totalIngresos: number = 0;
  numeroCitas: number = 0;

  datosMock: any = {
    '2025-03': { ingresos: 980.50, citas: 12 },
    '2025-04': { ingresos: 1120.00, citas: 15 },
  };

  actualizarDatos() {
    const data = this.datosMock[this.mesSeleccionado] || { ingresos: 0, citas: 0 };
    this.totalIngresos = data.ingresos;
    this.numeroCitas = data.citas;
  }

  generarPDF() {
    const doc = new jsPDF();
    doc.text("Reporte de Ingresos", 20, 20);
    doc.text(`Mes: ${this.mesSeleccionado}`, 20, 30);
    doc.text(`Total Ganado: S/ ${this.totalIngresos.toFixed(2)}`, 20, 40);
    doc.text(`Número de Citas: ${this.numeroCitas}`, 20, 50);
    doc.save("reporte-ingresos.pdf");
  }

  generarExcel() {
    const wb = XLSX.utils.book_new();
    const ws_data = [
      ["Mes", "Total Ganado", "Número de Citas"],
      [this.mesSeleccionado, this.totalIngresos.toFixed(2), this.numeroCitas]
    ];
    const ws = XLSX.utils.aoa_to_sheet(ws_data);
    XLSX.utils.book_append_sheet(wb, ws, "Ingresos");
    XLSX.writeFile(wb, "reporte-ingresos.xlsx");
  }

}
