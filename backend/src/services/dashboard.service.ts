import type { DashboardSummary } from '../models/dashboard.js';
import { findAllDistributionCenters } from '../repositories/distribution-center.repository.js';
import {
  countActiveOperations,
  countDeliveriesToday,
} from '../repositories/operation.repository.js';
import { getCurrentProfile } from './profile.service.js';

// Indicadores provisórios: ainda não existem tabelas de ocorrências
// nem de prazos de entrega para calcular esses valores a partir do banco.
const PROVISIONAL_INCIDENTS = 3;
const PROVISIONAL_ON_TIME_PERCENTAGE = 92;

export async function getDashboardSummary(): Promise<DashboardSummary> {
  const [employee, activeOperations, deliveriesToday, distributionCenters] = await Promise.all([
    getCurrentProfile(),
    countActiveOperations(),
    countDeliveriesToday(),
    findAllDistributionCenters(),
  ]);

  return {
    employeeFirstName: employee.name.split(' ')[0],
    activeOperations,
    deliveriesToday,
    incidents: PROVISIONAL_INCIDENTS,
    onTimePercentage: PROVISIONAL_ON_TIME_PERCENTAGE,
    distributionCenters,
  };
}
