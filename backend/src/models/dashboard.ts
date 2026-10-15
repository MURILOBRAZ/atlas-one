import type { DistributionCenter } from './distribution-center.js';

export interface DashboardSummary {
  employeeFirstName: string;
  activeOperations: number;
  deliveriesToday: number;
  incidents: number;
  onTimePercentage: number;
  distributionCenters: DistributionCenter[];
}
