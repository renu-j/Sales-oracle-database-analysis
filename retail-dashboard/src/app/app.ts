import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterOutlet } from '@angular/router';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet, CommonModule],
  templateUrl: './app.html',
  styleUrl: './app.scss'
})
export class App {

  // Overall KPI analysis
  totalSales = 2297200.86;
  totalProfit = 286397.02;
  totalOrders = 5009;
  totalCustomers = 793;
  profitMargin = 12.47;

  // Category analysis
  categories = [
    {
      name: 'Technology',
      sales: 836154.03,
      profit: 145454.95
    },
    {
      name: 'Furniture',
      sales: 741999.80,
      profit: 18451.27
    },
    {
      name: 'Office Supplies',
      sales: 719047.03,
      profit: 122490.80
    }
  ];

  // Region analysis
  regions = [
    {
      name: 'West',
      sales: 725457.82
    },
    {
      name: 'East',
      sales: 678781.24
    },
    {
      name: 'Central',
      sales: 501239.89
    },
    {
      name: 'South',
      sales: 391721.91
    }
  ];

}