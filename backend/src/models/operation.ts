export type OperationStatus = 'awaiting_pickup' | 'in_transit' | 'delayed' | 'completed';

export interface Operation {
  id: string;
  code: string;
  origin: string;
  destination: string;
  status: OperationStatus;
  scheduledDate: Date;
}
