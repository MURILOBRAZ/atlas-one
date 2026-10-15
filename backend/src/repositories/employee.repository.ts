import { db } from '../config/database.js';
import type { Employee, UpdateProfileInput } from '../models/employee.js';

export async function findEmployeeByRegistration(registration: string): Promise<Employee | null> {
  const result = await db.query<Employee>(
    `SELECT
       e.id,
       e.name,
       e.email,
       e.phone,
       e.job_title              AS "jobTitle",
       e.registration,
       e.distribution_center_id AS "distributionCenterId",
       dc.city || ' - ' || dc.state AS unit,
       e.updated_at             AS "updatedAt"
     FROM employees e
     LEFT JOIN distribution_centers dc ON dc.id = e.distribution_center_id
     WHERE e.registration = $1`,
    [registration],
  );

  return result.rows[0] ?? null;
}

export async function updateEmployeeProfile(id: string, input: UpdateProfileInput): Promise<void> {
  await db.query(
    `UPDATE employees
     SET name = $1,
         phone = $2,
         job_title = $3,
         updated_at = now()
     WHERE id = $4`,
    [input.name, input.phone, input.jobTitle, id],
  );
}
