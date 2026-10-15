export interface Employee {
  id: string;
  name: string;
  email: string;
  phone: string | null;
  jobTitle: string;
  registration: string;
  distributionCenterId: string | null;
  /** Unidade de trabalho formatada, ex.: "Santos - SP". */
  unit: string | null;
  updatedAt: Date;
}

/** Campos que o próprio funcionário pode alterar pelo aplicativo. */
export interface UpdateProfileInput {
  name: string;
  phone: string;
  jobTitle: string;
}
