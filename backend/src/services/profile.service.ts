import { env } from '../config/env.js';
import { NotFoundError } from '../errors/http-error.js';
import type { Employee, UpdateProfileInput } from '../models/employee.js';
import {
  findEmployeeByRegistration,
  updateEmployeeProfile,
} from '../repositories/employee.repository.js';

/**
 * Ainda não existe autenticação: o "usuário logado" é sempre o funcionário
 * definido em CURRENT_EMPLOYEE_REGISTRATION (por padrão, Lucas Almeida).
 */
export async function getCurrentProfile(): Promise<Employee> {
  const employee = await findEmployeeByRegistration(env.currentEmployeeRegistration);

  if (!employee) {
    throw new NotFoundError('Funcionário não encontrado. Verifique se o seed do banco foi executado.');
  }

  return employee;
}

export async function updateCurrentProfile(input: UpdateProfileInput): Promise<Employee> {
  const employee = await getCurrentProfile();

  await updateEmployeeProfile(employee.id, {
    name: input.name.trim(),
    phone: input.phone.trim(),
    jobTitle: input.jobTitle.trim(),
  });

  return getCurrentProfile();
}
