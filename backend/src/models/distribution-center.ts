export type DistributionCenterStatus = 'normal' | 'attention' | 'critical';

export interface DistributionCenter {
  id: string;
  code: string;
  name: string;
  city: string;
  state: string;
  status: DistributionCenterStatus;
}
